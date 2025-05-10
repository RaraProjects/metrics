H.SpellDef = { }

------------------------------------------------------------------------------------------------------
-- Parse the finish spell casting packet.
------------------------------------------------------------------------------------------------------
---@param action     table     action packet data.
---@param actorMob   table     the mob data of the entity performing the action.
---@param ownerMob   table|nil (if pet) the mob data of the entity's owner.
---@param logDefense boolean   if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.SpellDef.Action = function(action, actorMob, ownerMob, logDefense)
    if not logDefense then
        return nil
    end

    local spellId   = action.param
    local spellData = Ashita.Spell.GetByID(spellId)
    if not spellData then
        return nil
    end

    -- Keep the mob list up-to-date.
    if Ashita.Mob.IsMonster(actorMob) then
        DB.Lists.AddToInitializedMobs(actorMob.name)
    end

    local spellName   = Ashita.Spell.Name(spellId, spellData)
    local totalDamage = 0
    local targetCount = 0

    -- Loop through target actions.
    for _, target in pairs(action.targets) do
        local targetMob = Ashita.Mob.GetMobByID(target.id) or { name = DB.Enum.DEBUG }

        if Ashita.Party.IsAffiliate(targetMob.name) or Ashita.Mob.PetOwner(targetMob) or Parse.Config.IsLurking() then
            ownerMob = Ashita.Mob.PetOwner(targetMob)   -- Need to recheck for AOEs.

            for _, actionData in pairs(target.actions) do
                local newDamage = H.SpellDef.Parse(spellData, actionData, actorMob, targetMob, ownerMob) or 0
                targetCount = targetCount + 1
                totalDamage = totalDamage + newDamage
            end
        end
    end

    -- Update the Battle Log.
    if Res.Spells.Damaging[spellId] then
        H.SpellDef.Blog(actorMob, spellData, spellName, totalDamage, targetCount)
    end
end

------------------------------------------------------------------------------------------------------
-- Parse the packet where a mob buffs themselves with a self-targeting buff.
------------------------------------------------------------------------------------------------------
---@param action   table action packet data.
---@param actorMob table the mob data of the entity performing the action.
------------------------------------------------------------------------------------------------------
H.SpellDef.MobSelfTarget = function(action, actorMob)
    local spellID   = action.param
    local spellData = Ashita.Spell.GetByID(spellID)

    if not spellData then
        return nil
    end

    local spellName = Ashita.Spell.Name(spellID, spellData)

    H.SpellDef.Blog(actorMob, spellData, spellName, -1, 0)
end

------------------------------------------------------------------------------------------------------
-- Set data for a spell action (including healing).
-- Not all spells do damage and not all spells heal this will sort those out.
------------------------------------------------------------------------------------------------------
---@param spellData  table the main packet; need it to get spell ID
---@param actionData table contains all the information for the action
---@param actorMob   table
---@param targetMob  table
---@param ownerMob?  table
---@return number
------------------------------------------------------------------------------------------------------
H.SpellDef.Parse = function(spellData, actionData, actorMob, targetMob, ownerMob)
    local spellId   = spellData.Index
    local spellName = Ashita.Spell.Name(spellId, spellData)

    Debug.Packet.AddAction(actorMob.name, targetMob.name, "Spell Def", actionData, spellId, spellName)

    -- Need to double check each target in case a pet gets hit by AOE and wasn't the primary target.
    if not ownerMob then
        ownerMob = Ashita.Mob.PetOwner(targetMob)
    end

    local messageId = actionData.message
    local noDamage  = H.Messages.NoDamage(messageId)
    local damage    = actionData.param or 0
    local audits    = H.SpellDef.Audits(actorMob, targetMob, ownerMob)

    local tag = "H.Spell_Def.Parse"
    local warning = string.format("BENIGN: Spell {%s} (%d) has message {%d}.", spellName, spellId, messageId)
    Debug.Error.Add(Debug.Error.WARNING, tag, warning)

    if noDamage then
        damage = 0
    end

    -- Track damage for both players and pets.
    if Res.Spells.Damaging[spellId] then
        H.SpellDef.Nuke(audits, damage, spellName, ownerMob)
    else
        H.Offense.CatalogNoDamageHit(audits, DB.Trackable.DEF_NO_DAMAGE_SPELLS, spellName)
    end

    -- Not tracking mitigation, MP drain, or enfeebling for pets at this time.
    if not ownerMob then
        local fullMitigation = H.Defense.Mitigation(audits, DB.Trackable.DEF_SHADOWS_MAGIC, damage, messageId, Ashita.Message.SHADOW_ABSORPTION, true)

        -- Player was hit by the spell.
        if not fullMitigation then
            if Res.Spells.Damaging[spellId] then
                H.Offense.Hit(audits, DB.Trackable.DEF_UNMITIGATED_MAGIC, damage)

            elseif Res.Spells.MpDrain[spellId] then
                H.Offense.Hit(audits, DB.Trackable.DEF_MP_DRAIN, damage)

            elseif Res.Spells.Enfeebling[spellId] then
                H.Offense.Hit(audits, DB.Trackable.DEF_ENFEEBLING, damage)
            end
        end
    end

    -- Set battle log flags.
    if noDamage then
        damage = -1
    end

    return damage
end

------------------------------------------------------------------------------------------------------
-- Handles spells that damage enemies.
------------------------------------------------------------------------------------------------------
---@param audits    table
---@param damage    number
---@param spellName string
---@param ownerMob? table
------------------------------------------------------------------------------------------------------
H.SpellDef.Nuke = function(audits, damage, spellName, ownerMob)
    local trackable = DB.Trackable.DEF_NUKING

    if ownerMob then
        trackable = DB.Trackable.DEF_NUKING_PET
    end

    H.Defense.GrandTotals(audits, damage, ownerMob)
    H.Offense.CatalogHit(audits, trackable, damage, spellName)
end

-- ------------------------------------------------------------------------------------------------------
-- Adds spell damage taken to the battle log.
-- ------------------------------------------------------------------------------------------------------
---@param actorMob    table   the mob data of the entity receiving the action.
---@param spellData   table
---@param spellName   string
---@param damage      number
---@param targetCount integer
-- ------------------------------------------------------------------------------------------------------
H.SpellDef.Blog = function(actorMob, spellData, spellName, damage, targetCount)
    local blog_note = targetCount > 1 and string.format("TGTs: %d", targetCount) or ""

    Blog.Add(actorMob.name, nil, Blog.ActionType.MOB_SPELL, spellName, damage, blog_note, spellData)
end

------------------------------------------------------------------------------------------------------
-- Convenient function to build the audit table.
------------------------------------------------------------------------------------------------------
---@param actorMob  table
---@param targetMob table
---@param ownerMob? table this will not be nil if the actor is a pet.
---@return table
------------------------------------------------------------------------------------------------------
H.SpellDef.Audits = function(actorMob, targetMob, ownerMob)
    local playerName = actorMob.name
    local targetName = targetMob.name
    local petName

    if ownerMob then
        petName    = targetMob.name
        targetName = ownerMob.name
    end

    -- These are switched compared to offense.
    local audits =
    {
        player_name = targetName,
        target_name = playerName,
        pet_name    = petName,
    }

    return audits
end