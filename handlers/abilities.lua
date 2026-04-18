H.Ability = { }

H.Ability.ActivePhantomRoll           = nil
H.Ability.ActivePhantomRollNumber     = 0
H.Ability.ActivePhantomRollWasLucky   = false
H.Ability.ActivePhantomRollWasLucky11 = false
H.Ability.ActivePhantomRollWasUnlucky = false

------------------------------------------------------------------------------------------------------
-- Parse the job ability casting packet.
------------------------------------------------------------------------------------------------------
---@param action     table   action packet data.
---@param actorMob   table   the mob data of the entity performing the action.
---@param logOffense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.Ability.Action = function(action, actorMob, logOffense)
    if not logOffense then
        return nil
    end

	-- Need to provide an offset to get abilities.
	local abilityId   = action.param + Ashita.AbilityOffset.ABILITY
    local abilityData = Ashita.Ability.GetByID(abilityId)
    local totalDamage = 0
    local targetMob

    for _, target in pairs(action.targets) do
        targetMob = Ashita.Mob.GetMobByID(target.id) or { name = DB.Enum.DEBUG }

        -- Keep the mob list up-to-date.
        if Ashita.Mob.IsMonster(targetMob) then
            DB.Lists.AddToInitializedMobs(targetMob.name)
        end

        -- Loop through actions on the target.
        for _, actionData in pairs(target.actions) do
            totalDamage = totalDamage + H.Ability.Parse(abilityId, abilityData, actionData, actorMob, targetMob.name)
        end
    end

    -- Log remaining action data.
    H.Ability.PlayerCatalogCount(actorMob, targetMob, abilityData, totalDamage)
    H.Ability.Blog(actorMob, abilityData, abilityId, totalDamage)
end

------------------------------------------------------------------------------------------------------
-- Parse pet ability packets.
-- This includes SMN bloodpacts and DRG wyvern breaths. BST and PUP are not included here.
------------------------------------------------------------------------------------------------------
---@param action     table   action packet data.
---@param actorMob   table   the mob data of the entity performing the action.
---@param logOffense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.Ability.PetAction = function(action, actorMob, logOffense)
    if not logOffense then
        return nil
    end

    -- Check to see if the pet belongs to anyone in the party.
    local ownerMob = Ashita.Mob.PetOwner(actorMob)

    if not ownerMob then
        return nil
    end

    -- Handle offset for Blood Pacts.
    local abilityId   = action.param
    local abilityData = Ashita.Ability.GetByID(abilityId + Ashita.AbilityOffset.PET)
    local totalDamage = 0
    local count       = 0
    local targetMob

    for _, target in pairs(action.targets) do
        targetMob = Ashita.Mob.GetMobByID(target.id)

        if targetMob then
            -- Keep the mob list up-to-date.
            if Ashita.Mob.IsMonster(targetMob) then
                DB.Lists.AddToInitializedMobs(targetMob.name)
            end

            -- Loop through actions on the target.
            for _, actionData in pairs(target.actions) do
                totalDamage = totalDamage + H.Ability.Parse(abilityId, abilityData, actionData, ownerMob, targetMob.name, actorMob)
                count = count + 1
            end
        end
    end

    H.Ability.PetCount(actorMob, ownerMob, targetMob, abilityData, abilityId, totalDamage)
    H.Ability.PetBlog(actorMob, ownerMob, abilityData, abilityId, totalDamage, count)
end

------------------------------------------------------------------------------------------------------
-- Set data for an ability action.
-- This includes pet damage (since they are ability based).
-- Using an ability to cause a pet to attack gets captured here, but the actual data for the damage
-- done comes in a different packet. SMN comes in Pet_Ability and then routes back to here.
------------------------------------------------------------------------------------------------------
---@param abilityId   integer
---@param abilityData table   the main packet; need it to get ability ID
---@param actionData  table   contains all the information for the action.
---@param actorMob    table   name of the player that did the action.
---@param targetName  string  name of the target that received the action.
---@param ownerMob?   table   if the action was from a pet then this will hold the owner's mob.
---@return number
------------------------------------------------------------------------------------------------------
H.Ability.Parse = function(abilityId, abilityData, actionData, actorMob, targetName, ownerMob)
    local abilityName = abilityData.Name
    local playerName  = actorMob.name
    local damage      = actionData.param
    local messageId   = actionData.message
    local petName     = ownerMob and ownerMob.name or nil
    local audits      = H.Ability.Audits(playerName, targetName, petName)

    local tag     = "H.Ability.Parse"
    local warning = string.format("BENIGN: Ability {%s} (%s) has message {%s} and damage {%s}.",
                    tostring(abilityName), tostring(abilityId), tostring(messageId), tostring(damage))
    Debug.Error.Add(Debug.Error.WARNING, tag, warning)

    -- Blood pacts and wyvern breaths
    if ownerMob then
        abilityName = Horizon.GetAbilityName(abilityId, abilityName)

        if Horizon.RageList(abilityId) then
            H.Offense.Hit(audits, DB.Trackable.PET_OVERALL, damage)
            H.Offense.CatalogHit(audits, DB.Trackable.PET_TP, damage, abilityName)

        elseif Horizon.WardList(abilityId) then
            H.Offense.CatalogNoDamageHit(audits, DB.Trackable.PET_TP, abilityName)

        elseif Horizon.HealingList(abilityId) then
            H.Offense.Hit(audits, DB.Trackable.ALL_HEAL, damage)
            H.Offense.CatalogHit(audits, DB.Trackable.PET_HEALING, damage, abilityName)
        end

    -- Player abilities
    else
        local offsetId = math.max(abilityId - Ashita.AbilityOffset.ABILITY, 0)

        if Res.Abilities.Damaging[abilityId] then
            if H.Messages.NoDamageMiss(messageId) then
                H.Offense.CatalogMiss(audits, DB.Trackable.ABILITY_DAMAGING, abilityName)
            else
                H.Offense.CatalogHit(audits, DB.Trackable.ABILITY_DAMAGING, damage, abilityName)
            end

        elseif Res.Abilities.Healing[abilityId] or Res.Abilities.PetHealing[abilityId] then
            H.Offense.Hit(audits, DB.Trackable.ALL_HEAL, damage)
            H.Offense.CatalogHit(audits, DB.Trackable.ABILITY_HEALING, damage, abilityName)

        elseif Res.Abilities.MPRecovery[abilityId] then
            H.Offense.CatalogHit(audits, DB.Trackable.ABILITY_MP_RECOVERY, damage, abilityName)

        elseif abilityId == Res.Abilities.STEAL and damage > 0 then
            local itemName = Ashita.Item.GetItemName(damage)
            Loot.NonDrop(actorMob.name, itemName, 1)

        elseif abilityId == Res.Abilities.MUG and damage > 0 then
            Loot.NonDrop(actorMob.name, "Gil", damage)

        elseif Res.Abilities.Maneuvers[offsetId] then
            H.Offense.CatalogNoDamageHit(audits, DB.Trackable.MANEUVER, abilityName)
            if actionData.message == Ashita.Message.MANEUVER_OVERLOAD then
                DB.Data.Update(DB.UpdateMode.INC, 1, audits, DB.Trackable.MANEUVER, DB.Metric.OVERLOAD)
                DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, DB.Trackable.MANEUVER, abilityName, DB.Metric.OVERLOAD)
            end

        elseif Res.Abilities.PhantomRoll[offsetId] then
            H.Ability.PhantomRoll(audits, actionData, damage, abilityId, abilityName)
        end
    end

    return damage
end

------------------------------------------------------------------------------------------------------
-- Creates an audit table.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param targetName string
---@param petName?   string
---@return table
------------------------------------------------------------------------------------------------------
H.Ability.Audits = function(playerName, targetName, petName)
    return { player_name = playerName, target_name = targetName, pet_name = petName }
end

------------------------------------------------------------------------------------------------------
-- Adds ability damage to the battle log.
------------------------------------------------------------------------------------------------------
---@param actorMob    table
---@param abilityData table
---@param abilityId   number
---@param damage      number
------------------------------------------------------------------------------------------------------
H.Ability.Blog = function(actorMob, abilityData, abilityId, damage)
    if not abilityData or not abilityId then
        return nil
    end

    local offsetId = math.max(abilityId - Ashita.AbilityOffset.ABILITY, 0)

    if Res.Abilities.Damaging[abilityId] or Res.Abilities.MPRecovery[abilityId] then
        local note = nil
        if abilityId == Res.Abilities.CHIVALRY then
            note = Ashita.Party.Refresh(actorMob.name, Ashita.PlayerAttributes.TP)
        end
        Blog.Add(actorMob.name, nil, Blog.ActionType.ABILITY, abilityData.Name, damage, note)

    elseif Res.Abilities.Healing[abilityId] or Res.Abilities.PetHealing[abilityId] then
        Blog.Add(actorMob.name, nil, Blog.ActionType.MAGIC_HEALING, abilityData.Name, damage)

    elseif Res.Abilities.PetCommands[offsetId] then
        Blog.Add(actorMob.name, nil, Blog.ActionType.PET_COMMAND, abilityData.Name, damage)

    elseif Res.Abilities.PhantomRoll[offsetId] then
        local lucky_details = Res.Abilities.PhantomRollLucky[abilityId - Ashita.AbilityOffset.ABILITY]
        if lucky_details then
            local suffix = ""
            if damage == lucky_details.lucky or damage == 11 then
                suffix = " Lucky!"

            elseif damage == lucky_details.unlucky then
                suffix = " Unlucky"

            elseif damage > 11 then
                suffix = " BUST!"
            end

            Blog.Add(actorMob.name, nil, Blog.ActionType.PHANTOM_ROLL, abilityData.Name, nil, string.format("Roll: %d%s", damage, suffix), abilityData)
        end

    else
        Blog.Add(actorMob.name, nil, Blog.ActionType.ABILITY, abilityData.Name)
    end
end

------------------------------------------------------------------------------------------------------
-- Adds pet ability damage to the battle log.
------------------------------------------------------------------------------------------------------
---@param actorMob     table
---@param ownerMob     table
---@param abilityData  table
---@param abilityId    number
---@param damage       number
---@param targetCount? integer
------------------------------------------------------------------------------------------------------
H.Ability.PetBlog = function(actorMob, ownerMob, abilityData, abilityId, damage, targetCount)
    local abilityName = Horizon.GetAbilityName(abilityId, abilityData.Name)

    if Horizon.RageList(abilityId) then
        Blog.Add(ownerMob.name, actorMob.name, Blog.ActionType.PET_TP, abilityName, damage)

    elseif Horizon.WardList(abilityId) then
        Blog.Add(ownerMob.name, actorMob.name, Blog.ActionType.PET_TP, abilityName, nil, string.format("TGTs: %d", targetCount), abilityData)

    elseif Horizon.HealingList(abilityId) then
        Blog.Add(ownerMob.name, actorMob.name, Blog.ActionType.ALL_HEALING, abilityName, damage)
    end
end

------------------------------------------------------------------------------------------------------
-- Increment the use counter of the ability.
------------------------------------------------------------------------------------------------------
---@param actorMob    table
---@param targetMob   table
---@param abilityData table
---@param damage      integer
------------------------------------------------------------------------------------------------------
H.Ability.PlayerCatalogCount = function(actorMob, targetMob, abilityData, damage)
    local audits    = H.Ability.Audits(actorMob.name, targetMob.name)
    local noDamage  = false
    local abilityId = abilityData.Id

    -- Overall ability tracking.
    local trackable = DB.Trackable.ABILITY_OVERALL
    DB.Data.Update(DB.UpdateMode.INC, 1, audits, DB.Trackable.ABILITY_OVERALL, DB.Metric.ATTEMPTS_ON_USE)
    DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, DB.Trackable.ABILITY_OVERALL, abilityData.Name, DB.Metric.ATTEMPTS_ON_USE)

    -- Some abilities need to also have counts to tag them for pickup by listing functions.
    if Res.Abilities.Damaging[abilityId] then
        trackable = DB.Trackable.ABILITY_DAMAGING

    elseif Res.Abilities.Healing[abilityId] or Res.Abilities.PetHealing[abilityData.Id] then
        trackable = DB.Trackable.ABILITY_HEALING

    elseif Res.Abilities.MPRecovery[abilityId] then
        trackable = DB.Trackable.ABILITY_MP_RECOVERY

    elseif Res.Abilities.Maneuvers[math.max(abilityId - Ashita.AbilityOffset.ABILITY, 0)] then
        noDamage = true
        trackable = DB.Trackable.MANEUVER

    elseif Res.Abilities.PhantomRoll[math.max(abilityId - Ashita.AbilityOffset.ABILITY, 0)] then
        noDamage = true
        trackable = DB.Trackable.PHANTOM_ROLL

    else
        noDamage = true
        trackable = DB.Trackable.ABILITY_GENERAL
    end

    if not noDamage and damage > 0 then
        DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.HITS_ON_USE)
        DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, trackable, abilityData.Name, DB.Metric.HITS_ON_USE)
    end

    DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS_ON_USE)
    DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, trackable, abilityData.Name, DB.Metric.ATTEMPTS_ON_USE)
end

------------------------------------------------------------------------------------------------------
-- Increment the use count of a pet ability.
------------------------------------------------------------------------------------------------------
---@param actorMob    table
---@param ownerMob    table
---@param targetMob   table
---@param abilityData table
---@param abilityId   integer need the unadjusted IDs.
---@param damage      number
------------------------------------------------------------------------------------------------------
H.Ability.PetCount = function(actorMob, ownerMob, targetMob, abilityData, abilityId, damage)
    local audits      = H.Ability.Audits(ownerMob.name, targetMob.name, actorMob.name)
    local trackable   = Horizon.HealingList(abilityId) and DB.Trackable.PET_HEALING or DB.Trackable.PET_TP
    local abilityName = Horizon.GetAbilityName(abilityId, abilityData.Name)

    local function updateMetrics(metric)
        DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, metric)
        DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, trackable, abilityName, metric)
    end

    updateMetrics(DB.Metric.ATTEMPTS_ON_USE)

    if damage > 0 then
        updateMetrics(DB.Metric.HITS_ON_USE)
    end
end

------------------------------------------------------------------------------------------------------
-- Handles phantom roll parsing.
-- The phantom roll specific metrics take the place of "hit" metrics.
------------------------------------------------------------------------------------------------------
---@param audits      table
---@param result      table
---@param rollValue   integer
---@param abilityId   integer
---@param abilityName string
------------------------------------------------------------------------------------------------------
H.Ability.PhantomRoll = function(audits, result, rollValue, abilityId, abilityName)
    local trackable = DB.Trackable.PHANTOM_ROLL
    local rollId    = abilityId - Ashita.AbilityOffset.ABILITY

    -- First Roll; Attempt on TARGET is updated here to signify a roll series because attempt on use gets updated everytime the ability is used.
    if H.Ability.ActivePhantomRoll ~= rollId then
        H.Ability.ActivePhantomRoll           = rollId
        H.Ability.ActivePhantomRollNumber     = rollValue
        H.Ability.ActivePhantomRollWasLucky   = false
        H.Ability.ActivePhantomRollWasLucky11 = false
        H.Ability.ActivePhantomRollWasUnlucky = false
        H.Ability.PhantomRollAdjustRoll(audits, trackable, 1, abilityName, DB.Metric.ATTEMPTS_ON_TARGET)

    -- Re-Rolls; Can't use attempts here because the first roll doesn't count as a re-roll.
    else
        H.Ability.ActivePhantomRollNumber = rollValue
        H.Ability.PhantomRollAdjustRoll(audits, trackable, 1, abilityName, DB.Metric.REROLL)
    end

    -- Lucky, Unlucky, and Busts.
    local luckyDetails = Res.Abilities.PhantomRollLucky[rollId]
    if luckyDetails then
        -- Bust; Undo lucky and unluckies
        if result.message == Ashita.Message.PHANTOM_ROLL_BUST then
            H.Ability.PhantomRollAdjustRoll(audits, trackable, 1, abilityName, DB.Metric.BUSTS)
            if H.Ability.ActivePhantomRollWasLucky   then H.Ability.PhantomRollAdjustRoll(audits, trackable, -1, abilityName, DB.Metric.LUCKY) end
            if H.Ability.ActivePhantomRollWasLucky11 then H.Ability.PhantomRollAdjustRoll(audits, trackable, -1, abilityName, DB.Metric.LUCKY_11) end
            if H.Ability.ActivePhantomRollWasUnlucky then H.Ability.PhantomRollAdjustRoll(audits, trackable, -1, abilityName, DB.Metric.UNLUCKY) end
            H.Ability.ActivePhantomRollWasLucky   = false
            H.Ability.ActivePhantomRollWasLucky11 = false
            H.Ability.ActivePhantomRollWasUnlucky = false

        -- Lucky comes first so shouldn't need to undo any unluckies.
        elseif rollValue == luckyDetails.lucky then
            H.Ability.PhantomRollAdjustRoll(audits, trackable, 1, abilityName, DB.Metric.LUCKY)
            H.Ability.ActivePhantomRollWasLucky   = true
            H.Ability.ActivePhantomRollWasUnlucky = false
            H.Ability.ActivePhantomRollWasLucky11 = false

        -- Unlucky; Undo any luckies.
        elseif rollValue == luckyDetails.unlucky then
            H.Ability.PhantomRollAdjustRoll(audits, trackable, 1, abilityName, DB.Metric.UNLUCKY)
            if H.Ability.ActivePhantomRollWasLucky then H.Ability.PhantomRollAdjustRoll(audits, trackable, -1, abilityName, DB.Metric.LUCKY) end
            H.Ability.ActivePhantomRollWasLucky   = false
            H.Ability.ActivePhantomRollWasUnlucky = true
            H.Ability.ActivePhantomRollWasLucky11 = false

        -- Lucky 11; Undo any unluckies; don't double count general lucky.
        elseif rollValue == 11 then
            H.Ability.PhantomRollAdjustRoll(audits, trackable, 1, abilityName, DB.Metric.LUCKY_11)
            if H.Ability.ActivePhantomRollWasUnlucky   then H.Ability.PhantomRollAdjustRoll(audits, trackable, -1, abilityName, DB.Metric.UNLUCKY) end
            if not H.Ability.ActivePhantomRollWasLucky then H.Ability.PhantomRollAdjustRoll(audits, trackable, 1, abilityName, DB.Metric.LUCKY) end
            H.Ability.ActivePhantomRollWasLucky   = true
            H.Ability.ActivePhantomRollWasLucky11 = true
            H.Ability.ActivePhantomRollWasUnlucky = false

        -- All other rolls.
        else
            -- Undo lucky and unluckies
            if H.Ability.ActivePhantomRollWasLucky   then H.Ability.PhantomRollAdjustRoll(audits, trackable, -1, abilityName, DB.Metric.LUCKY) end
            if H.Ability.ActivePhantomRollWasLucky11 then H.Ability.PhantomRollAdjustRoll(audits, trackable, -1, abilityName, DB.Metric.LUCKY_11) end
            if H.Ability.ActivePhantomRollWasUnlucky then H.Ability.PhantomRollAdjustRoll(audits, trackable, -1, abilityName, DB.Metric.UNLUCKY) end
            H.Ability.ActivePhantomRollWasLucky   = false
            H.Ability.ActivePhantomRollWasLucky11 = false
            H.Ability.ActivePhantomRollWasUnlucky = false
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Sets Phantom Roll metrics.
------------------------------------------------------------------------------------------------------
---@param audits      table
---@param trackable   DB.Trackable
---@param increment   integer
---@param abilityName string
---@param metric      DB.Metric
------------------------------------------------------------------------------------------------------
H.Ability.PhantomRollAdjustRoll = function(audits, trackable, increment, abilityName, metric)
    DB.Data.Update(DB.UpdateMode.INC, increment, audits, trackable, metric)
    DB.Catalog.UpdateMetric(DB.UpdateMode.INC, increment, audits, trackable, abilityName, metric)
end