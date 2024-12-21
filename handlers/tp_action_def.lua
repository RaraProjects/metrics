H.TP_Def = {}

------------------------------------------------------------------------------------------------------
-- Parse the finish monster TP move packet.
-- BST Pet and Puppet ranged attacks fall into this category.
-- Trust abilities can show up here too. They don't have an owner.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param owner_mob? table (if pet) the mob data of the entity's owner.
---@param log_defense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.TP_Def.Monster_Action = function(action, actor_mob, owner_mob, log_defense)
    if not log_defense then return false end

    local skill_data = H.TP.Pet_Skill_Data(action.param, actor_mob)
    if not skill_data then return nil end
    local skill_name = skill_data.en
    local action_id  = skill_data.id

    -- Mob ranged attacks come in as TP moves. Jump to Ranged Defense if that happens.
    if skill_name and skill_name == "Ranged Attack" then
        H.Ranged_Def.Action(action, actor_mob, owner_mob, log_defense)
        return nil
    end

    local result, target_mob
    local damage = 0
    local count  = 0
    local trackable = DB.Trackable.DEF_TP_MOVE_PET

    -- Mob AOEs can hit pets. Need to check for all the target owner mobs because they may not be the original target.
    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target_mob = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if target_mob and (Ashita.Party.Is_Affiliate(target_mob.name) or Ashita.Mob.Pet_Owner(target_mob) or Metrics.Parse.Lurk_Mode) then
                if Ashita.Mob.Is_Monster(actor_mob) then DB.Lists.Check.Mob_Exists(actor_mob.name) end
                owner_mob = Ashita.Mob.Pet_Owner(target_mob)    -- Need to recheck for AOEs.
                if not owner_mob then trackable = DB.Trackable.DEF_TP_MOVE end
                count = count + 1
                damage = damage + H.TP_Def.Weaponskill_Parse(result, actor_mob, target_mob, skill_name, action_id, owner_mob)
            end
        end
    end

    -- Counts
    local audits = H.TP_Def.Audits(actor_mob, owner_mob, target_mob)
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS_ON_USE)
    DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, skill_name, DB.Metric.ATTEMPTS_ON_USE)
    if damage > 0 then
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.HITS_ON_USE)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, skill_name, DB.Metric.HITS_ON_USE)
    end

    -- Battle Log
    H.TP_Def.Blog(actor_mob, damage, action_id, skill_name, count)

    return true
end

------------------------------------------------------------------------------------------------------
-- Parse the packet where a mob buffs themselves with a self-targeting buff.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
------------------------------------------------------------------------------------------------------
H.TP_Def.Mob_Self_Target = function(action, actor_mob)
    local skill_data = H.TP.Pet_Skill_Data(action.param, actor_mob)
    if not skill_data then return nil end
    H.TP_Def.Blog(actor_mob, 0, skill_data.id, skill_data.en, 1)
end

------------------------------------------------------------------------------------------------------
-- Set data for a weaponskill action.
-- AOE weaponskills will go through this one time for each mob hit.
------------------------------------------------------------------------------------------------------
---@param result table contains all the information for the action.
---@param actor_mob table name of the player that did the action.
---@param target_mob table name of the target that received the action.
---@param ws_name string name of the weaponskill that was used.
---@param ws_id number ID of the ability that was used. Right now this is used to check monster abilities.
---@param owner_mob? table if the action was from a pet then this will hold the owner's mob.
---@return number
------------------------------------------------------------------------------------------------------
H.TP_Def.Weaponskill_Parse = function(result, actor_mob, target_mob, ws_name, ws_id, owner_mob)
    Debug.Packet.Add_Action(actor_mob.name, target_mob.name, "TP Def", result)
    local damage     = result.param
    local message_id = result.message
    local audits = H.TP_Def.Audits(actor_mob, owner_mob, target_mob)

    -- A lot of pet abilities just land a status effect and it carries in a value as if it were damage.
    local no_damage = H.No_Damage_Messages(result)
    if no_damage then damage = 0 end

    -- Damaging ability tallies.
    local damaging_ability = false
    if Res.Monster.Get_Damaging_Ability(ws_id) then
        H.Defense.Grand_Totals(audits, damage, owner_mob)
        H.Offense.Catalog_Hit(audits, audits.trackable, damage, ws_name)
        damaging_ability = true

    -- Some weaponskills drain MP instead of doing damage.
    elseif Res.WS.Get_MP_Drain(ws_id) then
        H.Offense.Catalog_Hit(audits, DB.Trackable.WEAPONSKILL_MP_DRAIN, damage, ws_name)
    end

    -- Not tracking these for pets right now.
    if not owner_mob then
        -- Full Mitigation; track unmitigated damage if it isn't absorbed by a shadow.
        local full = false
        if not full then full = H.Defense.Mitigation(audits, DB.Trackable.DEF_EVASION_TP_ACTION, damage, message_id, Ashita.Enum.Message.MISS_TP, true) end
        if not full then full = H.Defense.Mitigation(audits, DB.Trackable.DEF_SHADOWS_TP_ACTION, damage, message_id, Ashita.Enum.Message.SHADOWS, true) end
        if not full and damaging_ability then H.Offense.Hit(audits, DB.Trackable.DEF_UNMITIGATED_TP_ACTION, damage) end
    end

    return damage
end

-- ------------------------------------------------------------------------------------------------------
-- Adds mob TP damage to the battle log.
-- ------------------------------------------------------------------------------------------------------
---@param actor_mob table
---@param damage integer
---@param action_id? integer
---@param skill_name string
---@param target_count integer
-- ------------------------------------------------------------------------------------------------------
H.TP_Def.Blog = function(actor_mob, damage, action_id, skill_name, target_count)
    local note = nil
    if target_count > 1 then note = "TGTs: " .. tostring(target_count) end
    -- Flag non damaging abilities to have "---" for damage.
    if action_id and not Res.Monster.Get_Damaging_Ability(action_id) then damage = -1 end
    Blog.Add(actor_mob.name, nil, Blog.Action_Type.MOB_TP, skill_name, damage, note)
end

-- ------------------------------------------------------------------------------------------------------
-- Set audit information for pet skills.
-- ------------------------------------------------------------------------------------------------------
---@param actor_mob table
---@param owner_mob table|nil
---@param target_mob table
---@return table
-- ------------------------------------------------------------------------------------------------------
H.TP_Def.Audits = function(actor_mob, owner_mob, target_mob)
    local player_name = actor_mob.name
    local target_name = target_mob.name
    local pet_name = nil
    local trackable = DB.Trackable.DEF_TP_MOVE

    if owner_mob then
        pet_name = target_mob.name
        target_name = owner_mob.name
        trackable = DB.Trackable.DEF_TP_MOVE_PET
    end

    -- These are switched compared to offense.
    local audits = {
        player_name = target_name,
        target_name = player_name,
        pet_name = pet_name,
        trackable = trackable
    }

    return audits
end
