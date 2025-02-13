H.TP = { }

H.TP.SkillchainOpener    = nil
H.TP.SkillchainOpeningWS = nil
H.TP.SkillchainStep      = 0

------------------------------------------------------------------------------------------------------
-- Parse the weaponskill packet.
-- Surprises:
-- 1. Some abilities--like DRG Jumps--oddly show up in this packet.
------------------------------------------------------------------------------------------------------
---@param action     table action packet data.
---@param actorMob   table the mob data of the entity performing the action.
---@param logOffense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.TP.Action = function(action, actorMob, logOffense)
    if not logOffense then
        return nil
    end

	local wsData = H.TP.WeaponskillData(action, actorMob)

    if not wsData then
        return nil
    end

    local wsName        = wsData.en
    local wsId          = wsData.id
    local targetMob     = {}
    local scName        = "None"
    local tpDamage      = 0
    local scDamage      = 0
    local isUseHit      = false
    local isUseNoDamage = true
    local isUseMpDrain  = false

    for _, target in pairs(action.targets) do
        targetMob = Ashita.Mob.GetMobByID(target.id) or { name = DB.Enum.DEBUG }

        -- Keep the mob list up-to-date.
        if Ashita.Mob.IsMonster(targetMob) then
            DB.Lists.AddToInitializedMobs(targetMob.name)
        end

        for _, actionData in pairs(target.actions) do
            -- Abilities marked as weaponskills
            if H.TP.IsWeaponskillAbility(actionData, wsId, action, actorMob) then
                return nil
            end

            -- Check for skillchains
            scDamage, scName = H.TP.SkillchainParse(actionData, actorMob, targetMob, wsName)

            -- Need to calculate WS damage here to account for AOE weaponskills
            local targetDamage, isTargetHit, isTargetNoDamage, isTargetMpDrain = H.TP.WeaponskillParse(actionData, actorMob, targetMob, wsName, wsId)
            tpDamage = tpDamage + targetDamage

            -- No Damage: The Use level is only no damage if all of the target checks are no damage.
            isUseNoDamage = isUseNoDamage and isTargetNoDamage

            -- Hit: The Use level is a hit if any of the target checks are hits.
            isUseHit     = isUseHit or isTargetHit
            isUseMpDrain = isUseMpDrain or isTargetMpDrain
        end
    end

    -- Finalize weaponskill and skillchain data.
    -- Have to do it outside of the loop to avoid counting attempts and hits multiple times.
    local tp = H.TP.WeaponskillWrapUp(actorMob, targetMob, tpDamage, wsName, scName, isUseHit, isUseMpDrain)

    -- Update the battle log.
    if isUseNoDamage then
        tpDamage = 0
    end

    Blog.Add(actorMob.name, nil, Blog.Action_Type.WEAPONSKILL, wsName, tpDamage, tp, wsData)

    if scDamage > 0 then
        Blog.Add(actorMob.name, nil, Blog.Action_Type.SKILLCHAIN, scName, scDamage)
    end
end

------------------------------------------------------------------------------------------------------
-- Parse the begin monster TP move packet. This is primarily used to capture pet TP when using abilities.
-- BST Pet and Puppet ranged attacks fall into this category.
-- Trust abilities can show up here too. They don't have an owner.
-- As DRG, using Smiting Breath and Restoring Breath also come through here (as abilities).
-- Using the avatar ability as SMN also goes through here.
------------------------------------------------------------------------------------------------------
---@param action     table   action packet data.
---@param actorMob   table   the mob data of the entity performing the action.
---@param logOffense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.TP.BeginMonsterAction = function(action, actorMob, logOffense)
    if not logOffense or Ashita.Mob.IsPlayer(actorMob) then
        return nil
    end

    -- Check to see if the pet belongs to anyone in the party.
    local ownerMob = Ashita.Mob.PetOwner(actorMob)
    if not ownerMob then
        return nil
    end

    local skillName = DB.Enum.DEBUG
    local trackable = DB.Trackable.PET_TP
    local targetMob

    for _, target in pairs(action.targets) do
        targetMob = Ashita.Mob.GetMobByID(target.id) or { name = DB.Enum.DEBUG }

        -- Keep the mob list up-to-date.
        if Ashita.Mob.IsMonster(targetMob) then
            DB.Lists.AddToInitializedMobs(targetMob.name)
        end

        for _, actionData in pairs(target.actions) do
            local actionId   = actionData.param
            local isSMNorDRG = false
            local ownerJob   = Ashita.Party.GetMember(ownerMob.name)
            local skillData

            -- The pet ability IDs have two different sources based on type of pet so need to check job.
            if ownerJob then
                -- BST and PUP
                if ownerJob.main == 9 or ownerJob.main == 18 then
                    skillData = H.TP.PetSkillData(actionId, actorMob)
                    skillName = skillData.en or DB.Enum.DEBUG

                -- SMN and DRG
                else
                    skillData  = Ashita.Ability.GetByID(actionId + Ashita.AbilityOffset.PET)
                    skillName  = skillData.Name or DB.Enum.DEBUG
                    isSMNorDRG = true
                end
            end

            if skillData and isSMNorDRG then
                -- Avatar and Wyvern Healing
                if Res.Pets.Healing[actionId] then
                    trackable = DB.Trackable.PET_HEALING
                end
            end
        end
    end

    local petTp  = Ashita.Player.Get(Ashita.PlayerAttributes.PET_TP) or 0
    local audits = H.TP.Audits(actorMob, ownerMob, targetMob)
    H.Offense.WeaponskillTP(audits, petTp, skillName, trackable)
end

------------------------------------------------------------------------------------------------------
-- Parse the finish monster TP move packet.
-- BST Pet and Puppet ranged attacks fall into this category.
-- Trust abilities can show up here too. They don't have an owner.
------------------------------------------------------------------------------------------------------
---@param action     table   action packet data.
---@param actorMob   table   the mob data of the entity performing the action.
---@param logOffense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.TP.MonsterAction = function(action, actorMob, logOffense)
    if not logOffense then
        return nil
    end

    -- Check to see if the pet belongs to anyone in the party.
    local ownerMob = Ashita.Mob.PetOwner(actorMob)
    if not ownerMob and not Parse.Config.Is_Lurking() then
        return nil
    end

    local skillData = H.TP.PetSkillData(action.param, actorMob)
    if not skillData then
        return nil
    end

    local skillName     = skillData.en
    local actionId      = skillData.id
    local tpDamage      = 0
    local isUseHit      = false
    local isUseNoDamage = true
    local targetMob

    for _, target in pairs(action.targets) do
        targetMob = Ashita.Mob.GetMobByID(target.id) or { name = DB.Enum.DEBUG }

        -- Keep the mob list up-to-date.
        if Ashita.Mob.IsMonster(targetMob) then
            DB.Lists.AddToInitializedMobs(targetMob.name)
        end

        for _, actionData in pairs(target.actions) do

            -- Puppet ranged attack. Send this action to the ranged action parser.
            if actionId == 1949 then
                return H.Ranged.Parse(actionData, actorMob, targetMob, ownerMob)

            -- BST pet abilities can't skillchain in HorizonXI.
            -- Need to calculate WS damage here to account for AOE weaponskills.
            else
                local targetDamage, isTargetHit, isTargetNoDamage = H.TP.WeaponskillParse(actionData, actorMob, targetMob, skillName, actionId, ownerMob)
                tpDamage = tpDamage + targetDamage

                -- No Damage: The Use level is only no damage if all of the target checks are no damage.
                isUseNoDamage = isUseNoDamage and isTargetNoDamage

                -- Hit: The Use level is a hit if any of the target checks are hits.
                isUseHit = isUseHit or isTargetHit
            end
        end
    end

    local audits = H.TP.Audits(actorMob, ownerMob, targetMob)
    H.TP.PetSkillAttempts(audits, audits.trackable, skillName)

    if tpDamage > 0 then
        H.TP.PetSkillHit(audits, audits.trackable, skillName)
    end

    -- Update the battle log.
    if ownerMob then
        tpDamage = isUseNoDamage and -1 or tpDamage
        Blog.Add(ownerMob.name, actorMob.name, Blog.Action_Type.PET_TP, skillName, tpDamage)
    end

    return true
end

------------------------------------------------------------------------------------------------------
-- Set data for a weaponskill action.
-- AOE weaponskills will go through this one time for each mob hit.
------------------------------------------------------------------------------------------------------
---@param actionData table   contains all the information for the action.
---@param actorMob   table   name of the player that did the action.
---@param targetMob  table   name of the target that received the action.
---@param wsName     string  name of the weaponskill that was used.
---@param wsId       integer ID of the ability that was used. Right now this is used to check monster abilities.
---@param ownerMob?  table   if the action was from a pet then this will hold the owner's mob.
---@return integer
---@return boolean
---@return boolean
---@return boolean
------------------------------------------------------------------------------------------------------
H.TP.WeaponskillParse = function(actionData, actorMob, targetMob, wsName, wsId, ownerMob)
    Debug.Packet.AddAction(actorMob.name, targetMob.name, "Weaponskill", actionData)

    local damage     = actionData.param
    local messageId  = actionData.message
    local audits     = H.TP.Audits(actorMob, ownerMob, targetMob)
    local hit        = false
    local isNoDamage = false
    local isMpDrain  = false

    -- Check damage mitigation first. If mitigated, the damage is set to zero for the counts, blog, etc.
    damage, hit, isNoDamage = H.TP.DamageMitigation(audits, damage, messageId, wsName, ownerMob)

    -- The player drains the mob's MP.
    if H.MessageMPDrain(messageId) then
        H.Offense.CatalogHit(audits, DB.Trackable.WEAPONSKILL_MP_DRAIN, damage, wsName)
        isMpDrain = true

    -- The player drains the mob's TP.
    elseif H.Message_TP_Drain(messageId) then
        isNoDamage = true

    -- The player dispels the mob. (this situation may not exist)
    elseif H.MessageDispel(messageId) then
        isNoDamage = true

    -- The player debuffs the mob. (this situation may not exist)
    elseif H.Message_Debuff(messageId) then
        H.Offense.CatalogNoDamageHit(audits, audits.trackable, wsName)
        isNoDamage = true

    -- A pet does damage to the mob.
    elseif ownerMob and H.MessageDamaging(messageId) then
        DB.Data.Update(DB.UpdateMode.INC, damage, audits, DB.Trackable.PET_OVERALL, DB.Metric.TOTAL)
        H.Offense.CatalogHit(audits, audits.trackable, damage, wsName)

    -- The player damages or drains HP from the mob.
    elseif H.MessageDamaging(messageId) or H.MessageHpDrain(messageId) then
        H.Offense.CatalogHit(audits, audits.trackable, damage, wsName)
        if H.MessageHpDrain(messageId) then H.Offense.CatalogHit(audits, DB.Trackable.SPELLS_HP_DRAIN, damage, wsName) end

    -- Just for information gathering purposes.
    else
        local warning = string.format("BENIGN: Weaponskill {%s} (%d) has unaccounted message {%d}.", wsName or DB.Enum.DEBUG, wsId or 0, messageId or 0)
        Debug.Error.Add(Debug.Error.WARNING, "H.TP.Weaponskill_Parse", warning)
    end

    return damage, hit, isNoDamage, isMpDrain
end

------------------------------------------------------------------------------------------------------
-- Checks for damage mitigation like evasion or shadows.
------------------------------------------------------------------------------------------------------
---@param audits    table
---@param damage    integer
---@param messageId Ashita.Message
---@param wsName    string
---@param ownerMob? table
---@return integer
---@return boolean
---@return boolean
------------------------------------------------------------------------------------------------------
H.TP.DamageMitigation = function(audits, damage, messageId, wsName, ownerMob)
    local miss   = false
    local shadow = false

    -- Mob misses the player.
    if H.MessageNoDamageMiss(messageId) then
        H.Offense.GrandTotals(audits, 0, ownerMob)
        H.Offense.CatalogHit(audits, audits.trackable, 0, wsName)
        damage = 0
        miss   = true

    -- Player's shadow absorbs the ability.
    elseif H.MessageNoDamage(messageId) then
        H.Offense.GrandTotals(audits, 0, ownerMob)
        H.Offense.CatalogNoDamageHit(audits, audits.trackable, wsName)
        damage = 0
        shadow = true
    end

    return damage, not miss, miss or shadow
end

-- ------------------------------------------------------------------------------------------------------
-- Check for skillchains.
-- ------------------------------------------------------------------------------------------------------
---@param actionData table
---@param actorMob   table
---@param targetMob  table
---@param wsName     string
---@return number
---@return string
-- ------------------------------------------------------------------------------------------------------
H.TP.SkillchainParse = function(actionData, actorMob, targetMob, wsName)
    local scId     = actionData.add_effect_message
    local scDamage = 0
    local scName   = DB.Enum.DEBUG

    if scId > 0 then
        scName   = Res.WS.Skillchains[scId]
        scDamage = actionData.add_effect_param
        local audits =
        {
            player_name = actorMob.name,
            target_name = targetMob.name,
        }

        H.Offense.CatalogHit(audits, DB.Trackable.SKILLCHAIN, scDamage, scName)
        H.TP.SkillchainStep = H.TP.SkillchainStep + 1

    else
        H.TP.SkillchainOpener    = actorMob.name
        H.TP.SkillchainOpeningWS = wsName
        H.TP.SkillchainStep      = 1
    end

    return scDamage, scName
end

-- ------------------------------------------------------------------------------------------------------
-- Wraps up weaponskill and skillchain tallys outside of the target loop.
-- ------------------------------------------------------------------------------------------------------
---@param actorMob   table
---@param targetMob  table
---@param damage     integer
---@param wsName     string
---@param scName     string
---@param wasHit     boolean
---@param wasMpDrain boolean
---@return integer
-- ------------------------------------------------------------------------------------------------------
H.TP.WeaponskillWrapUp = function(actorMob, targetMob, damage, wsName, scName, wasHit, wasMpDrain)
    local audits =
    {
        player_name = actorMob.name,
        target_name = targetMob.name,
    }

    local trackable = wasMpDrain and DB.Trackable.WEAPONSKILL_MP_DRAIN or DB.Trackable.WEAPONSKILL

    -- Update TP usage.
    local tp = Ashita.Party.Refresh(audits.player_name, Ashita.PlayerAttributes.TP)
    tp = H.Offense.WeaponskillTP(audits, tp, wsName, trackable)

    -- Update non-target loop hits and attempts.
    DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS_ON_USE)
    DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, trackable, wsName, DB.Metric.ATTEMPTS_ON_USE)

    if damage > 0 or wasHit then
        DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.HITS_ON_USE)
        DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, trackable, wsName, DB.Metric.HITS_ON_USE)
    end

    if scName ~= DB.Enum.DEBUG then
        H.TP.SkillchainHit(audits, scName)
    end

    return tp
end

-- ------------------------------------------------------------------------------------------------------
-- Increments skillchain counts.
-- ------------------------------------------------------------------------------------------------------
---@param audits table
---@param scName string
-- ------------------------------------------------------------------------------------------------------
H.TP.SkillchainHit = function(audits, scName)
    -- Total Attempts
    DB.Data.Update(DB.UpdateMode.INC, 1, audits, DB.Trackable.SKILLCHAIN, DB.Metric.ATTEMPTS_ON_USE)
    DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, DB.Trackable.SKILLCHAIN, scName, DB.Metric.ATTEMPTS_ON_USE)

    -- Successfull SC Count
    DB.Data.Update(DB.UpdateMode.INC, 1, audits, DB.Trackable.SKILLCHAIN, DB.Metric.HITS_ON_USE)
    DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, DB.Trackable.SKILLCHAIN, scName, DB.Metric.HITS_ON_USE)

    -- Credit to skillchain closer.
    DB.Data.Update(DB.UpdateMode.INC, 1, audits, DB.Trackable.SKILLCHAIN, DB.Metric.SKILLCHAIN_CLOSED)
    DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, DB.Trackable.SKILLCHAIN, scName, DB.Metric.SKILLCHAIN_CLOSED)

    -- Credit to skillchain opener (except for multistep skillchains).
    if H.TP.SkillchainStep <= 2 then
        local scAudits =
        {
            player_name = H.TP.SkillchainOpener,
            target_name = audits.target_name,
        }
        DB.Data.Update(DB.UpdateMode.INC, 1, scAudits, DB.Trackable.SKILLCHAIN, DB.Metric.SKILLCHAIN_OPENED)
        DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, scAudits, DB.Trackable.SKILLCHAIN, scName, DB.Metric.SKILLCHAIN_OPENED)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Increments pet skill attempts.
-- ------------------------------------------------------------------------------------------------------
---@param audits    table
---@param trackable DB.Trackable
---@param skillName string
-- ------------------------------------------------------------------------------------------------------
H.TP.PetSkillAttempts = function(audits, trackable, skillName)
    DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS_ON_USE)
    DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, trackable, skillName, DB.Metric.ATTEMPTS_ON_USE)
end

-- ------------------------------------------------------------------------------------------------------
-- Increments pet skill hits.
-- ------------------------------------------------------------------------------------------------------
---@param audits    table
---@param trackable DB.Trackable
---@param skillName string
-- ------------------------------------------------------------------------------------------------------
H.TP.PetSkillHit = function(audits, trackable, skillName)
    DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.HITS_ON_USE)
    DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, trackable, skillName, DB.Metric.HITS_ON_USE)
end

-- ------------------------------------------------------------------------------------------------------
-- Set audit information for pet skills.
-- ------------------------------------------------------------------------------------------------------
---@param actorMob  table
---@param ownerMob  table|nil
---@param targetMob table
---@return table
-- ------------------------------------------------------------------------------------------------------
H.TP.Audits = function(actorMob, ownerMob, targetMob)
    -- Initialize on case where this is a trust or regular monster.
    local playerName = actorMob.name
    local trackable  = DB.Trackable.WEAPONSKILL
    local petName

    -- Case where this is a player's pet using an ability.
    if ownerMob then
        playerName = ownerMob.name
        petName    = actorMob.name
        trackable  = DB.Trackable.PET_TP
    end

    local audits =
    {
        player_name = playerName,
        target_name = targetMob.name,
        pet_name    = petName,
        trackable   = trackable
    }

    return audits
end

-- ------------------------------------------------------------------------------------------------------
-- Get weaponskill data.
-- ------------------------------------------------------------------------------------------------------
---@param action   table
---@param actorMob table
---@return table|nil
-- ------------------------------------------------------------------------------------------------------
H.TP.WeaponskillData = function(action, actorMob)
    local wsData = Ashita.WS.GetByID(action.param)

	if not wsData then
        local errorMessage = string.format("Actor {%s} used WS ID {%d} and it wasn't found.", actorMob.name or DB.Enum.DEBUG, action.param or 0)
        Debug.Error.Add(Debug.Error.ERROR, "H.TP.WS_Data", errorMessage)
        return nil
    end

    return wsData
end

-- ------------------------------------------------------------------------------------------------------
-- Get pet skill data.
-- ------------------------------------------------------------------------------------------------------
---@param actionId number
---@param actorMob table
---@return table
-- ------------------------------------------------------------------------------------------------------
H.TP.PetSkillData = function(actionId, actorMob)
    local skillData = Res.Monster.Full_List[actionId]

    if not skillData then
        local errorMessage = string.format("Actor {%s} used TP move {%d} and it was unmapped.", actorMob.name or DB.Enum.DEBUG, actionId or 0)
        Debug.Error.Add(Debug.Error.ERROR, "H.TP.Pet_Skill_Data", errorMessage)
        skillData = { id = actionId, en = string.format("(%d) UNK Mon. Ability", actionId or 0) }
    end

    return skillData
end

-- ------------------------------------------------------------------------------------------------------
-- Checks for abilities that come through on the WS packet.
-- I'm differentiating them based on chat message, so this needs to be called in the result loop and not before.
-- Specific case: Steal/Swift Blade, Atonement/Mug, Gale Axe/Jump, Spinning Axe/Super Jump
-- ------------------------------------------------------------------------------------------------------
---@param result   table
---@param wsId     number
---@param action   table
---@param actorMob table
---@return boolean true: weaponskill was actually an ability
-- ------------------------------------------------------------------------------------------------------
H.TP.IsWeaponskillAbility = function(result, wsId, action, actorMob)
    if Res.WS.Abilities[wsId] then
        if result.message ~= 185 and result.message ~= 188 then
            H.Ability.Action(action, actorMob, true)
            return true
        end
    end

    return false
end