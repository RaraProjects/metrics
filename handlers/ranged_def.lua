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
    local damage      = result.param
    local message_id  = result.message
    local player_name = target_mob.name
    local mob_name    = actor_mob.name
    local ranged_trackable = DB.Trackable.DEF_RANGED

    -- Need special handling for pets
    local pet_name = nil
    if owner_mob then
        pet_name = target_mob.name
        player_name = owner_mob.name
        ranged_trackable = DB.Trackable.DEF_RANGED_PET
    end

    local audits = {
        player_name = player_name,
        target_name = mob_name,
        pet_name = pet_name,
    }

    -- No damage Messages
    local no_damage = H.No_Damage_Messages(result)
    if no_damage then damage = 0 end

    H.Defense.Grand_Totals(audits, damage, owner_mob)

    -- Need to handle pets here because they aren't handled below.
    if owner_mob then
        if damage > 0 then
            H.Offense.Hit(audits, ranged_trackable, damage)
            H.Offense.Min_Max(audits, ranged_trackable, damage)
        else
            H.Offense.Miss(audits, ranged_trackable)
        end
    end

    -- There is an order of operations to defensive actions. Need to protect the denominator.
    -- Not tracking damage mitigation for pets at this time.
    if not owner_mob then
        -- Full Mitigation
        local full = false
        if not full then full = H.Defense.Mitigation(audits, DB.Trackable.DEF_EVASION_RANGED, damage, message_id, Ashita.Enum.Message.RANGE_MISS, true) end
        if not full then full = H.Defense.Mitigation(audits, DB.Trackable.DEF_SHADOWS_RANGED, damage, message_id, Ashita.Enum.Message.SHADOW_ABSORPTION, true) end

        -- Full damage mitigation just increments attempts.
        if full then
            H.Offense.Miss(audits, ranged_trackable)

        -- Totally unmitigated hit.
        else
            H.Offense.Hit(audits, ranged_trackable, damage)
            H.Offense.Min_Max(audits, ranged_trackable, damage)
            H.Offense.Hit(audits, DB.Trackable.DEF_UNMITIGATED_RANGED, damage)
        end

        H.Defense.Crit(audits, damage, message_id)
    end

    if no_damage then damage = -1 end

    return damage
end