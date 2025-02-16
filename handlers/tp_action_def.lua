H.TpDef = { }

------------------------------------------------------------------------------------------------------
-- Parse the finish monster TP move packet.
-- BST Pet and Puppet ranged attacks fall into this category.
-- Trust abilities can show up here too. They don't have an owner.
------------------------------------------------------------------------------------------------------
---@param action     table   action packet data.
---@param actorMob   table   the mob data of the entity performing the action.
---@param ownerMob?  table   (if pet) the mob data of the entity's owner.
---@param logDefense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.TpDef.MonsterAction = function(action, actorMob, ownerMob, logDefense)
    if not logDefense then
        return false
    end

    local skillData = H.TP.PetSkillData(action.param, actorMob)
    if not skillData then
        return nil
    end

    local skillName, actionId = skillData.en, skillData.id

    -- Mob ranged attacks come in as TP moves. Jump to Ranged Defense if that happens.
    if skillName and skillName == "Ranged Attack" then
        H.RangedDef.Action(action, actorMob, ownerMob, logDefense)
        return nil
    end

    -- Keep the mob list up-to-date.
    if Ashita.Mob.IsMonster(actorMob) then
        DB.Lists.AddToInitializedMobs(actorMob.name)
    end

    local totalDamage    = 0
    local count          = 0
    local isUseNoDamage  = true
    local isUseHit       = false
    local trackable      = DB.Trackable.DEF_TP_MOVE_PET
    local targetMob
    local targetOwnerMob

    -- Mob AOEs can hit pets. Need to check for all the target owner mobs because they may not be the original target.
    for _, target in pairs(action.targets) do
        targetMob = Ashita.Mob.GetMobByID(target.id) or { name = DB.Enum.DEBUG }
        targetOwnerMob = Ashita.Mob.PetOwner(targetMob)

        if Ashita.Party.IsAffiliate(targetMob.name) or targetOwnerMob or Parse.Config.Is_Lurking() then
            trackable = targetOwnerMob and DB.Trackable.DEF_TP_MOVE_PET or DB.Trackable.DEF_TP_MOVE

            for _, actionData in pairs(target.actions) do
                local targetDamage, isTargetHit, isTargetNoDamage = H.TpDef.Parse(actionData, actorMob, targetMob, skillName, actionId, targetOwnerMob)

                -- If the ability is an AOE, if any of the hits are not "no damage" (like a miss) then the use level becomes a hit.
                isUseNoDamage = isUseNoDamage and isTargetNoDamage
                isUseHit      = isUseHit or isTargetHit
                totalDamage   = totalDamage + targetDamage
                count         = count + 1
            end
        end
    end

    -- Counts
    local audits = H.TpDef.Audits(actorMob, targetOwnerMob, targetMob)
    DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS_ON_USE)
    DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, trackable, skillName, DB.Metric.ATTEMPTS_ON_USE)

    if isUseHit then
        DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.HITS_ON_USE)
        DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, trackable, skillName, DB.Metric.HITS_ON_USE)
    end

    -- Battle Log
    H.TpDef.Blog(actorMob, totalDamage, skillName, count, isUseNoDamage)

    return true
end

------------------------------------------------------------------------------------------------------
-- Parse the packet where a mob buffs themselves with a self-targeting buff.
------------------------------------------------------------------------------------------------------
---@param action   table action packet data.
---@param actorMob table the mob data of the entity performing the action.
------------------------------------------------------------------------------------------------------
H.TpDef.MobSelfTarget = function(action, actorMob)
    local skillData = H.TP.PetSkillData(action.param, actorMob)

    if not skillData then
        return nil
    end

    H.TpDef.Blog(actorMob, 0, skillData.en, 1, true)
end

------------------------------------------------------------------------------------------------------
-- Set data for a weaponskill action.
-- AOE weaponskills will go through this one time for each mob hit.
------------------------------------------------------------------------------------------------------
---@param actionData table contains all the information for the action.
---@param actorMob   table name of the player that did the action.
---@param targetMob  table name of the target that received the action.
---@param actionName string name of the weaponskill that was used.
---@param actionId   number ID of the ability that was used. Right now this is used to check monster abilities.
---@param ownerMob?  table if the action was from a pet then this will hold the owner's mob.
---@return number
---@return boolean
---@return boolean
------------------------------------------------------------------------------------------------------
H.TpDef.Parse = function(actionData, actorMob, targetMob, actionName, actionId, ownerMob)
    Debug.Packet.AddAction(actorMob.name, targetMob.name, "TP Def", actionData)

    local damage     = actionData.param
    local messageId  = actionData.message
    local audits     = H.TpDef.Audits(actorMob, ownerMob, targetMob)
    local hit        = false
    local isNoDamage = false

    -- Check damage mitigation first. If mitigated, the damage is set to zero for the counts, blog, etc.
    damage, hit, isNoDamage = H.TpDef.DamageMitigation(audits, damage, messageId, actionName, ownerMob)

    -- The mob drains the player's MP.
    if H.MessageMPDrain(messageId) then
        H.Offense.CatalogNoDamageHit(audits, audits.trackable, actionName)
        H.Offense.CatalogHit(audits, DB.Trackable.DEF_MP_DRAIN, damage, actionName)

    -- The mob drains the player's TP.
    elseif H.Message_TP_Drain(messageId) then

    -- The mob dispels the player.
    elseif H.MessageDispel(messageId) then
        isNoDamage = true

    -- The mob debuffs the player.
    elseif H.Message_Debuff(messageId) then
        H.Offense.CatalogNoDamageHit(audits, audits.trackable, actionName)
        isNoDamage = true

    -- The mob's attack deals damage. This also includes HP drained from the player.
    elseif H.MessageDamaging(messageId) or H.MessageHpDrain(messageId) then
        H.Defense.GrandTotals(audits, damage, ownerMob)
        H.Offense.CatalogHit(audits, audits.trackable, damage, actionName)

        if not ownerMob then
            H.Offense.Hit(audits, DB.Trackable.DEF_UNMITIGATED_TP_ACTION, damage)
        end

        if H.MessageHpDrain(messageId) then
            H.Offense.CatalogHit(audits, DB.Trackable.DEF_MP_DRAIN, damage, actionName)
        end

    -- Just for information gathering purposes.
    else
        local warning = string.format("BENIGN: Ability {%s} (%d) has message {%d}.", actionName or DB.Enum.DEBUG, actionId or 0, messageId or 0)
        Debug.Error.Add(Debug.Error.WARNING, "H.TpDef.Parse", warning)
    end

    return damage, hit, isNoDamage
end

------------------------------------------------------------------------------------------------------
-- Checks for damage mitigation like evasion or shadows.
------------------------------------------------------------------------------------------------------
---@param audits     table
---@param damage     integer
---@param messageId  Ashita.Message
---@param actionName string
---@param ownerMob?  table
---@return integer
---@return boolean
---@return boolean
------------------------------------------------------------------------------------------------------
H.TpDef.DamageMitigation = function(audits, damage, messageId, actionName, ownerMob)
    local miss   = false
    local shadow = false

    -- Mob misses the player.
    if H.MessageNoDamageMiss(messageId) then
        H.Defense.GrandTotals(audits, 0, ownerMob)
        H.Offense.CatalogHit(audits, audits.trackable, 0, actionName)
        DB.Data.Update(DB.UpdateMode.INC, 1, audits, DB.Trackable.DEF_EVASION_TP_ACTION, DB.Metric.HITS_ON_TARGET)
        damage = 0
        miss   = true

    -- Player's shadow absorbs the ability.
    elseif H.MessageNoDamage(messageId) then
        H.Defense.GrandTotals(audits, 0, ownerMob)
        H.Offense.CatalogNoDamageHit(audits, audits.trackable, actionName)
        DB.Data.Update(DB.UpdateMode.INC, 1, audits, DB.Trackable.DEF_SHADOWS_TP_ACTION, DB.Metric.HITS_ON_TARGET)
        damage = 0
        shadow = true
    end

    -- Set attempts. Not tracking mitigation for pets.
    if not ownerMob then
        if miss then
            DB.Data.Update(DB.UpdateMode.INC, 1, audits, DB.Trackable.DEF_EVASION_TP_ACTION, DB.Metric.ATTEMPTS_ON_TARGET)
        else
            DB.Data.Update(DB.UpdateMode.INC, 1, audits, DB.Trackable.DEF_EVASION_TP_ACTION, DB.Metric.ATTEMPTS_ON_TARGET)
            DB.Data.Update(DB.UpdateMode.INC, 1, audits, DB.Trackable.DEF_SHADOWS_TP_ACTION, DB.Metric.ATTEMPTS_ON_TARGET)
        end
    end

    return damage, not miss, miss or shadow
end

-- ------------------------------------------------------------------------------------------------------
-- Adds mob TP damage to the battle log.
-- ------------------------------------------------------------------------------------------------------
---@param actorMob table
---@param damage integer
---@param skillName string
---@param targetCount integer
---@param isNoDamage boolean
-- ------------------------------------------------------------------------------------------------------
H.TpDef.Blog = function(actorMob, damage, skillName, targetCount, isNoDamage)
    local note = (targetCount > 1) and string.format("TGTs: %d", targetCount or 0) or ""

    damage = isNoDamage and -1 or damage

    Blog.Add(actorMob.name, nil, Blog.ActionType.MOB_TP, skillName, damage, note)
end

-- ------------------------------------------------------------------------------------------------------
-- Set audit information for pet skills.
-- ------------------------------------------------------------------------------------------------------
---@param actorMob  table
---@param ownerMob  table|nil
---@param targetMob table
---@return table
-- ------------------------------------------------------------------------------------------------------
H.TpDef.Audits = function(actorMob, ownerMob, targetMob)
    local playerName = actorMob.name
    local targetName = targetMob.name
    local trackable  = DB.Trackable.DEF_TP_MOVE
    local petName

    if ownerMob then
        petName    = targetMob.name
        targetName = ownerMob.name
        trackable  = DB.Trackable.DEF_TP_MOVE_PET
    end

    -- These are switched compared to offense.
    local audits =
    {
        player_name = targetName,
        target_name = playerName,
        pet_name    = petName,
        trackable   = trackable
    }

    return audits
end