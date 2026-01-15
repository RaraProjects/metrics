-- Performance review: 01/14/26

H.TP = { }

H.TP.SkillchainOpener    = nil
H.TP.SkillchainOpeningWS = nil
H.TP.SkillchainStep      = 0

local globalsInitialized = false

-- Local holders for common global tables--performance+.
---@type table
local messages   = nil
---@type table
local offense    = nil
---@type table
local trackables = nil
---@type table
local metrics    = nil
---@type table
local data       = nil
---@type table
local updateMode = nil
---@type table
local catalog    = nil
---@type table
local mobs       = nil
---@type table
local dataLists  = nil

------------------------------------------------------------------------------------------------------
-- Helper function for binding globals to locals to increase performance.
------------------------------------------------------------------------------------------------------
local bindGlobals = function()
    if globalsInitialized then
        return nil
    end

    messages   = messages or H.Messages
    offense    = offense or H.Offense
    data       = data or DB.Data
    catalog    = catalog or DB.Catalog
    updateMode = updateMode or DB.UpdateMode
    trackables = trackables or DB.Trackable
    metrics    = metrics or DB.Metric
    mobs       = mobs or Ashita.Mob
    dataLists  = dataLists or DB.Lists

    globalsInitialized = true
end

-- ------------------------------------------------------------------------------------------------------
-- Set audit information for pet skills.
-- ------------------------------------------------------------------------------------------------------
---@param actorMob  table
---@param ownerMob  table|nil
---@param targetMob table
---@return table
-- ------------------------------------------------------------------------------------------------------
local getAudits = function(actorMob, ownerMob, targetMob)
    -- Initialize on case where this is a trust or regular monster.
    local playerName = actorMob.name
    local trackable  = trackables.WEAPONSKILL
    local petName

    -- Case where this is a player's pet using an ability.
    if ownerMob then
        playerName = ownerMob.name
        petName    = actorMob.name
        trackable  = trackables.PET_TP
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
local weaponskillData = function(action, actorMob)
    local wsData = Ashita.WS.GetByID(action.param)

	if not wsData then
        local errorMessage = string.format("Actor {%s} used WS ID {%d} and it wasn't found.", actorMob.name or DB.Enum.DEBUG, action.param or 0)

        Debug.Error.Add(Debug.Error.ERROR, "weaponskillData", errorMessage)

        return nil
    end

    return wsData
end

-- ------------------------------------------------------------------------------------------------------
-- Checks for abilities that come through on the WS packet.
-- I'm differentiating them based on chat message, so this needs to be called in the result loop and not before.
-- Specific case: Steal/Swift Blade, Atonement/Mug, Gale Axe/Jump, Spinning Axe/Super Jump
-- ------------------------------------------------------------------------------------------------------
---@param result   table
---@param wsID     number
---@param action   table
---@param actorMob table
---@return boolean true: weaponskill was actually an ability
-- ------------------------------------------------------------------------------------------------------
local isWeaponskillAbility = function(result, wsID, action, actorMob)
    local isWeaponskillMessage = result.message == 185 or result.message == 188

    if not Res.WS.Abilities[wsID] or isWeaponskillMessage then
        return false
    end

    return true
end

------------------------------------------------------------------------------------------------------
-- Checks for damage mitigation like evasion or shadows.
------------------------------------------------------------------------------------------------------
---@param audits    table
---@param damage    integer
---@param messageID Ashita.Message
---@param wsName    string
---@param ownerMob? table
---@return integer  damage
---@return boolean  isHit
---@return boolean  isNoDamage
------------------------------------------------------------------------------------------------------
local damageMitigation = function(audits, damage, messageID, wsName, ownerMob)
    -- Mob misses the player.
    if messages.NoDamageMiss(messageID) then
        offense.GrandTotals(audits, 0, ownerMob)
        offense.CatalogMiss(audits, audits.trackable, wsName)
        return 0, false, true

    -- Player's shadow absorbs the ability.
    elseif messages.NoDamage(messageID) then
        offense.GrandTotals(audits, 0, ownerMob)
        offense.CatalogNoDamageHit(audits, audits.trackable, wsName)
        return 0, true, true
    end

    return damage, true, false
end

------------------------------------------------------------------------------------------------------
-- Set data for a weaponskill action.
-- AOE weaponskills will go through this one time for each mob hit.
------------------------------------------------------------------------------------------------------
---@param actionData table   contains all the information for the action.
---@param actorMob   table   name of the player that did the action.
---@param targetMob  table   name of the target that received the action.
---@param wsName     string  name of the weaponskill that was used.
---@param wsID       integer ID of the ability that was used. Right now this is used to check monster abilities.
---@param ownerMob?  table   if the action was from a pet then this will hold the owner's mob.
---@return table     result
------------------------------------------------------------------------------------------------------
local weaponskillParse = function(actionData, actorMob, targetMob, wsName, wsID, ownerMob)
    local messageID  = actionData.message
    local audits     = getAudits(actorMob, ownerMob, targetMob)
    local isDamaging = messages.Damaging(messageID)
    local isDrain    = messages.HpDrain(messageID)

    local result =
    {
        damage   = actionData.param,
        hit      = true,
        noDamage = false,
        mpDrain  = false,
    }

    -- Check damage mitigation first. If mitigated, the damage is set to zero for the counts, blog, etc.
    result.damage, result.hit, result.noDamage = damageMitigation(audits, result.damage, messageID, wsName, ownerMob)

    -- Pet Damage
    if ownerMob and isDamaging then
        data.Update(updateMode.INC, result.damage, audits, trackables.PET_OVERALL, metrics.TOTAL)
        offense.CatalogHit(audits, audits.trackable, result.damage, wsName)

    -- Damaging Weaponskill
    elseif isDamaging then
        offense.CatalogHit(audits, audits.trackable, result.damage, wsName)

    -- Debuff
    elseif messages.Debuff(messageID) then
        offense.CatalogHit(audits, audits.trackable, 0, wsName)
        result.noDamage = true

    -- HP Drain
    elseif isDrain then
        offense.CatalogHit(audits, audits.trackable, result.damage, wsName)
        offense.CatalogHit(audits, trackables.SPELLS_HP_DRAIN, result.damage, wsName)

    -- MP Drain
    elseif messages.MpDrain(messageID) then
        offense.CatalogHit(audits, trackables.WEAPONSKILL_MP_DRAIN, result.damage, wsName)
        result.mpDrain = true

    -- TP Drain and Dispel
    elseif messages.TpDrain(messageID) or messages.Dispel(messageID) then
        result.noDamage = true

    -- Just for information gathering purposes.
    else
        local warning = string.format("BENIGN: Weaponskill {%s} (%d) has unaccounted message {%d}.", wsName or DB.Enum.DEBUG, wsID or 0, messageID or 0)

        Debug.Error.Add(Debug.Error.WARNING, "weaponskillParse", warning)
    end

    return result
end

-- ------------------------------------------------------------------------------------------------------
-- Increments skillchain counts.
-- ------------------------------------------------------------------------------------------------------
---@param audits table
---@param scName string
-- ------------------------------------------------------------------------------------------------------
local skillchainHit = function(audits, scName)
    -- Total Attempts
    data.Update(updateMode.INC, 1, audits, trackables.SKILLCHAIN, metrics.ATTEMPTS_ON_USE)
    catalog.UpdateMetric(updateMode.INC, 1, audits, trackables.SKILLCHAIN, scName, metrics.ATTEMPTS_ON_USE)

    -- Successfull SC Count
    data.Update(updateMode.INC, 1, audits, trackables.SKILLCHAIN, metrics.HITS_ON_USE)
    catalog.UpdateMetric(updateMode.INC, 1, audits, trackables.SKILLCHAIN, scName, metrics.HITS_ON_USE)

    -- Credit to skillchain closer.
    data.Update(updateMode.INC, 1, audits, trackables.SKILLCHAIN, metrics.SKILLCHAIN_CLOSED)
    catalog.UpdateMetric(updateMode.INC, 1, audits, trackables.SKILLCHAIN, scName, metrics.SKILLCHAIN_CLOSED)

    -- Credit to skillchain opener (except for multistep skillchains).
    if H.TP.SkillchainStep <= 2 then
        local scAudits =
        {
            player_name = H.TP.SkillchainOpener,
            target_name = audits.target_name,
        }

        data.Update(updateMode.INC, 1, scAudits, trackables.SKILLCHAIN, metrics.SKILLCHAIN_OPENED)
        catalog.UpdateMetric(updateMode.INC, 1, scAudits, trackables.SKILLCHAIN, scName, metrics.SKILLCHAIN_OPENED)
    end
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
---@return integer   tp
-- ------------------------------------------------------------------------------------------------------
local weaponskillWrapUp = function(actorMob, targetMob, damage, wsName, scName, wasHit, wasMpDrain)
    local audits =
    {
        player_name = actorMob.name,
        target_name = targetMob.name,
    }

    local trackable = wasMpDrain and trackables.WEAPONSKILL_MP_DRAIN or trackables.WEAPONSKILL
    local tp        = Ashita.Party.Refresh(audits.player_name, Ashita.PlayerAttributes.TP)

    -- Update TP usage.
    tp = offense.WeaponskillTP(audits, tp, wsName, trackable)

    -- Update non-target loop hits and attempts.
    data.Update(updateMode.INC, 1, audits, trackable, metrics.ATTEMPTS_ON_USE)
    catalog.UpdateMetric(updateMode.INC, 1, audits, trackable, wsName, metrics.ATTEMPTS_ON_USE)

    if damage > 0 or wasHit then
        data.Update(updateMode.INC, 1, audits, trackable, metrics.HITS_ON_USE)
        catalog.UpdateMetric(updateMode.INC, 1, audits, trackable, wsName, metrics.HITS_ON_USE)
    end

    if scName ~= DB.Enum.DEBUG then
        skillchainHit(audits, scName)
    end

    return tp
end

-- ------------------------------------------------------------------------------------------------------
-- Increments pet skill attempts.
-- ------------------------------------------------------------------------------------------------------
---@param audits    table
---@param trackable DB.Trackable
---@param skillName string
-- ------------------------------------------------------------------------------------------------------
local petSkillAttempts = function(audits, trackable, skillName)
    data.Update(updateMode.INC, 1, audits, trackable, metrics.ATTEMPTS_ON_USE)
    catalog.UpdateMetric(updateMode.INC, 1, audits, trackable, skillName, metrics.ATTEMPTS_ON_USE)
end

-- ------------------------------------------------------------------------------------------------------
-- Increments pet skill hits.
-- ------------------------------------------------------------------------------------------------------
---@param audits    table
---@param trackable DB.Trackable
---@param skillName string
-- ------------------------------------------------------------------------------------------------------
local petSkillHit = function(audits, trackable, skillName)
    data.Update(updateMode.INC, 1, audits, trackable, metrics.HITS_ON_USE)
    catalog.UpdateMetric(updateMode.INC, 1, audits, trackable, skillName, metrics.HITS_ON_USE)
end

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

    bindGlobals()

	local wsData = weaponskillData(action, actorMob)

    if not wsData then
        return nil
    end

    local wsName        = wsData.en
    local wsID          = wsData.id
    local targetMob     = { }
    local scName        = "None"
    local tpDamage      = 0
    local scDamage      = 0
    local isUseHit      = false
    local isUseNoDamage = true
    local isUseMpDrain  = false

    for _, target in ipairs(action.targets) do
        targetMob = mobs.GetMobByID(target.id) or { name = DB.Enum.DEBUG }

        -- Keep the mob list up-to-date.
        if mobs.IsMonster(targetMob) then
            dataLists.AddToInitializedMobs(targetMob.name)
        end

        for _, actionData in ipairs(target.actions) do
            -- Send to the ability handler is the TP action is actually an ability.
            if isWeaponskillAbility(actionData, wsID, action, actorMob) then
                return H.Ability.Action(action, actorMob, true)
            end

            -- Check for skillchains
            scDamage, scName = H.TP.SkillchainParse(actionData, actorMob, targetMob, wsName)

            -- Need to calculate WS damage here to account for AOE weaponskills
            local result = weaponskillParse(actionData, actorMob, targetMob, wsName, wsID)

            tpDamage = tpDamage + result.damage

            -- No Damage: The "use: level is only no damage if all of the target checks are no damage.
            isUseNoDamage = isUseNoDamage and result.noDamage

            -- Hit: The "use" level is a hit if any of the target checks are hits.
            isUseHit     = isUseHit or result.hit
            isUseMpDrain = isUseMpDrain or result.mpDrain
        end
    end

    -- Finalize weaponskill and skillchain data.
    -- Have to do it outside of the loop to avoid counting attempts and hits multiple times.
    local tp = weaponskillWrapUp(actorMob, targetMob, tpDamage, wsName, scName, isUseHit, isUseMpDrain)

    -- Update the battle log.
    if isUseNoDamage then
        tpDamage = 0
    end

    Blog.Add(actorMob.name, nil, Blog.ActionType.WEAPONSKILL, wsName, tpDamage, tp, wsData)

    if scDamage > 0 then
        Blog.Add(actorMob.name, nil, Blog.ActionType.SKILLCHAIN, scName, scDamage)
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
    if not logOffense or mobs.IsPlayer(actorMob) then
        return nil
    end

    bindGlobals()

    -- Check to see if the pet belongs to anyone in the party.
    local ownerMob = mobs.PetOwner(actorMob)

    if not ownerMob then
        return nil
    end

    local skillName = DB.Enum.DEBUG
    local trackable = trackables.PET_TP
    local targetMob = { }

    for _, target in ipairs(action.targets) do
        targetMob = mobs.GetMobByID(target.id) or { name = DB.Enum.DEBUG }

        -- Keep the mob list up-to-date.
        if mobs.IsMonster(targetMob) then
            dataLists.AddToInitializedMobs(targetMob.name)
        end

        for _, actionData in ipairs(target.actions) do
            local actionID   = actionData.param
            local isSMNorDRG = false
            local ownerJob   = Ashita.Party.GetMember(ownerMob.name)
            local skillData  = { }

            -- The pet ability IDs have two different sources based on type of pet so need to check job.
            if ownerJob then
                if ownerJob.main == Ashita.Jobs.BST or ownerJob.main == Ashita.Jobs.PUP then
                    skillData = H.TP.PetSkillData(actionID, actorMob)
                    skillName = skillData.en or DB.Enum.DEBUG

                -- SMN and DRG
                else
                    skillData  = Ashita.Ability.GetByID(actionID + Ashita.AbilityOffset.PET)
                    skillName  = skillData.Name or DB.Enum.DEBUG
                    isSMNorDRG = true
                end
            end

            -- Avatar and Wyvern Healing
            if skillData and isSMNorDRG then
                if Horizon.HealingList(actionID) then
                    trackable = trackables.PET_HEALING
                end
            end
        end
    end

    local petTp  = Ashita.Player.Get(Ashita.PlayerAttributes.PET_TP) or 0
    local audits = getAudits(actorMob, ownerMob, targetMob)

    offense.WeaponskillTP(audits, petTp, skillName, trackable)
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

    bindGlobals()

    -- Check to see if the pet belongs to anyone in the party.
    local ownerMob = mobs.PetOwner(actorMob)

    if not ownerMob and not Parse.Config.IsLurking() then
        return nil
    end

    local skillData = H.TP.PetSkillData(action.param, actorMob)

    if not skillData then
        return nil
    end

    local skillName     = skillData.en
    local actionID      = skillData.id
    local tpDamage      = 0
    local isUseHit      = false
    local isUseNoDamage = true
    local targetMob     = { }

    for _, target in ipairs(action.targets) do
        targetMob = mobs.GetMobByID(target.id) or { name = DB.Enum.DEBUG }

        -- Keep the mob list up-to-date.
        if mobs.IsMonster(targetMob) then
            dataLists.AddToInitializedMobs(targetMob.name)
        end

        for _, actionData in ipairs(target.actions) do
            -- Puppet ranged attack. Send this action to the ranged action parser.
            if actionID == Ashita.Abilities.PUP_RANGED then
                return H.Ranged.Parse(actionData, actorMob, targetMob, ownerMob)

            -- BST pet abilities can't skillchain in HorizonXI.
            -- Need to calculate WS damage here to account for AOE weaponskills.
            else
                local result = weaponskillParse(actionData, actorMob, targetMob, skillName, actionID, ownerMob)

                tpDamage = tpDamage + result.damage

                -- No Damage: The "use: level is only no damage if all of the target checks are no damage.
                isUseNoDamage = isUseNoDamage and result.noDamage

                -- Hit: The "use" level is a hit if any of the target checks are hits.
                isUseHit = isUseHit or result.hit
            end
        end
    end

    local audits = getAudits(actorMob, ownerMob, targetMob)

    petSkillAttempts(audits, audits.trackable, skillName)

    if tpDamage > 0 then
        petSkillHit(audits, audits.trackable, skillName)
    end

    -- Update the battle log. -1 is a formatting flag for the battle log.
    if ownerMob then
        tpDamage = isUseNoDamage and -1 or tpDamage
        Blog.Add(ownerMob.name, actorMob.name, Blog.ActionType.PET_TP, skillName, tpDamage)
    end

    return true
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
    bindGlobals()

    local scID = actionData.add_effect_message

    if scID <= 0 then
        H.TP.SkillchainOpener    = actorMob.name
        H.TP.SkillchainOpeningWS = wsName
        H.TP.SkillchainStep      = 1
        return 0, DB.Enum.DEBUG
    end

    local audits =
    {
        player_name = actorMob.name,
        target_name = targetMob.name,
    }

    local scName   = Res.WS.Skillchains[scID]
    local scDamage = actionData.add_effect_param

    offense.CatalogHit(audits, trackables.SKILLCHAIN, scDamage, scName)
    H.TP.SkillchainStep = H.TP.SkillchainStep + 1

    return scDamage, scName
end

-- ------------------------------------------------------------------------------------------------------
-- Get pet skill data.
-- ------------------------------------------------------------------------------------------------------
---@param actionID number
---@param actorMob table
---@return table
-- ------------------------------------------------------------------------------------------------------
H.TP.PetSkillData = function(actionID, actorMob)
    bindGlobals()

    actionID = actionID or 0

    local skillData = Res.Monster.FullList[actionID]

    if skillData then
        return skillData
    end

    local errorMessage = string.format("Actor {%s} used TP move {%d} and it was unmapped.", actorMob.name or DB.Enum.DEBUG, actionID)

    Debug.Error.Add(Debug.Error.ERROR, "H.TP.PetSkillData", errorMessage)

    return { id = actionID, en = string.format("(%d) UNK Mon. Ability", actionID) }
end
