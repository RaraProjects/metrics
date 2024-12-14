H.Ranged_Def = {}

------------------------------------------------------------------------------------------------------
-- Parse the ranged attack packet.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param owner_mob? table
---@param log_defense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.Ranged_Def.Action = function(action, actor_mob, owner_mob, log_defense)
    if not log_defense then return nil end
    local result, target_mob
    local damage = 0

    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target_mob = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if target_mob then
                if Ashita.Mob.Is_Monster(actor_mob) then DB.Lists.Check.Mob_Exists(actor_mob.name) end
                damage = damage + H.Ranged_Def.Parse(result, actor_mob, target_mob, owner_mob)
            end
        end
    end

    H.Ranged_Def.Blog(actor_mob, damage)
end

-- ------------------------------------------------------------------------------------------------------
-- Adds ranged damage to the battle log.
-- ------------------------------------------------------------------------------------------------------
---@param actor_mob table the mob data of the entity performing the action.
---@param damage number
-- ------------------------------------------------------------------------------------------------------
H.Ranged_Def.Blog = function(actor_mob, damage)
    Blog.Add(actor_mob.name, nil, Blog.Action_Type.MOB_RANGED, DB.Trackable.RANGED_OVERALL, damage)
end

------------------------------------------------------------------------------------------------------
-- Set data for a ranged attack action.
------------------------------------------------------------------------------------------------------
---@param result table contains all the information for the action.
---@param actor_mob table name of the mob that did the action.
---@param target_mob table name of the target player that received the action.
---@param owner_mob? table if the action was from a pet then this will hold the owner's mob.
---@return number
------------------------------------------------------------------------------------------------------
H.Ranged_Def.Parse = function(result, actor_mob, target_mob, owner_mob)
    if not actor_mob or not target_mob then return 0 end

    Debug.Packet.Add_Action(actor_mob.name, target_mob.name, "Ranged Def.", result)
    local damage = result.param
    local message_id = result.message

    local player_name = target_mob.name
    local mob_name = actor_mob.name

    -- Need special handling for pets
    local pet_name = nil
    if owner_mob then
        pet_name = target_mob.name
        player_name = owner_mob.name
    end

    local audits = {
        player_name = player_name,
        target_name = mob_name,
        pet_name = pet_name,
    }

    local no_damage = H.No_Damage_Messages(result)

    if owner_mob then
        H.Ranged_Def.Pet_Total(audits, damage, no_damage)
    else
        H.Ranged_Def.Totals(audits, damage, no_damage)
    end

    -- There is an order of operations to defensive actions. Need to protect the denominator.
    if not owner_mob then
        local action_taken = false
        if not action_taken then action_taken = H.Ranged_Def.Evade(audits, message_id) end
        if not action_taken then action_taken = H.Ranged_Def.Shadows(audits, message_id) end

        -- Unmitigated ranged attack.
        if not action_taken then
            DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.DEF_RANGED, DB.Metric.HITS_ON_USE)
        end

        H.Ranged_Def.Crit(audits, damage, message_id)
    end

    if no_damage then damage = -1 end

    return damage
end

------------------------------------------------------------------------------------------------------
-- Increment Grand Totals.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param no_damage boolean
------------------------------------------------------------------------------------------------------
H.Ranged_Def.Totals = function(audits, damage, no_damage)
    if no_damage then damage = 0 end
    DB.Data.Update(DB.Update_Mode.INC, damage, audits, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, DB.Metric.TOTAL)

    local trackable = DB.Trackable.DEF_RANGED
    DB.Data.Update(DB.Update_Mode.INC, damage, audits, trackable, DB.Metric.TOTAL)
    DB.Data.Update(DB.Update_Mode.INC, 1,      audits, trackable, DB.Metric.ATTEMPTS_ON_USE) -- Ranged attempts against entity.
    -- HIT_COUNT gets set in the primary parse function.
    if damage > 0 and (damage < DB.Data.Get(audits.player_name, trackable, DB.Metric.MIN)) then DB.Data.Update(DB.Update_Mode.SET, damage, audits, trackable, DB.Metric.MIN) end
    if damage > DB.Data.Get(audits.player_name, trackable, DB.Metric.MAX) then DB.Data.Update(DB.Update_Mode.SET, damage, audits, trackable, DB.Metric.MAX) end
end

------------------------------------------------------------------------------------------------------
-- Increment total pet damage.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage integer
---@param no_damage boolean
------------------------------------------------------------------------------------------------------
H.Ranged_Def.Pet_Total = function(audits, damage, no_damage)
    if no_damage then damage = 0 end
    DB.Data.Update(DB.Update_Mode.INC, damage, audits, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET, DB.Metric.TOTAL)

    local trackable = DB.Trackable.DEF_RANGED_PET
    DB.Data.Update(DB.Update_Mode.INC, damage, audits, trackable, DB.Metric.TOTAL)
    DB.Data.Update(DB.Update_Mode.INC, 1,      audits, trackable, DB.Metric.ATTEMPTS_ON_USE) -- Ranged attempts against entity.
    if damage > 0 then DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.HITS_ON_USE) end
    if damage > 0 and (damage < DB.Data.Get(audits.player_name, trackable, DB.Metric.MIN)) then DB.Data.Update(DB.Update_Mode.SET, damage, audits, trackable, DB.Metric.MIN) end
    if damage > DB.Data.Get(audits.player_name, trackable, DB.Metric.MAX) then DB.Data.Update(DB.Update_Mode.SET, damage, audits, trackable, DB.Metric.MAX) end
end

------------------------------------------------------------------------------------------------------
-- Check for evasion.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param message_id number the ID of the entity animation when taking a hit.
---@return boolean
------------------------------------------------------------------------------------------------------
H.Ranged_Def.Evade = function(audits, message_id)
    local evade = false
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.DEF_EVASION, DB.Metric.ATTEMPTS_ON_USE)
    if message_id == Ashita.Enum.Message.RANGEMISS then
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.DEF_EVASION, DB.Metric.HITS_ON_USE)
        evade = true
    end
    return evade
end

------------------------------------------------------------------------------------------------------
-- Check for shadows.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param message_id number the ID of the entity animation when taking a hit.
---@return boolean
------------------------------------------------------------------------------------------------------
H.Ranged_Def.Shadows = function(audits, message_id)
    local shadow = false
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.DEF_SHADOWS, DB.Metric.ATTEMPTS_ON_USE)
    if message_id == Ashita.Enum.Message.SHADOWS then
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.DEF_SHADOWS, DB.Metric.HITS_ON_USE)
        shadow = true
    end
    return shadow
end

------------------------------------------------------------------------------------------------------
-- Check for critical damage taken.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param message_id number the ID of the entity animation when taking a hit.
------------------------------------------------------------------------------------------------------
H.Ranged_Def.Crit = function(audits, damage, message_id)
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.DEF_CRITICAL, DB.Metric.ATTEMPTS_ON_USE)
    if message_id == Ashita.Enum.Message.CRIT then
        DB.Data.Update(DB.Update_Mode.INC, damage, audits, DB.Trackable.DEF_CRITICAL, DB.Metric.TOTAL)
        DB.Data.Update(DB.Update_Mode.INC, 1,      audits, DB.Trackable.DEF_CRITICAL, DB.Metric.HITS_ON_USE)
    end
end