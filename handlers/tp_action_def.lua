H.TP_Def = T{}

------------------------------------------------------------------------------------------------------
-- Parse the finish monster TP move packet.
-- BST Pet and Puppet ranged attacks fall into this category.
-- Trust abilities can show up here too. They don't have an owner.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param owner_mob table|nil (if pet) the mob data of the entity's owner.
---@param log_defense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.TP_Def.Monster_Action = function(action, actor_mob, owner_mob, log_defense)
    if not log_defense then return false end

    local skill_data = H.TP.Pet_Skill_Data(action.param, actor_mob)
    if not skill_data then return nil end
    local skill_name = skill_data.en
    local action_id = skill_data.id

    local result, target_mob
    local damage = 0

    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target_mob = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if not target_mob then target_mob = {name = DB.Enum.Values.DEBUG} end
            damage = damage + H.TP_Def.Weaponskill_Parse(result, actor_mob, target_mob, skill_name, action_id, owner_mob)
        end
    end

    return true
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
    _Debug.Packet.Add_Action(actor_mob.name, target_mob.name, "TP Def", result)
    local damage = result.param
    local audits = H.TP_Def.Audits(actor_mob, owner_mob, target_mob)

    -- A lot of pet abilities just land a status effect and it carries in a value as if it were damage.
    damage = H.TP_Def.Ignore_Damage(damage, ws_id, ws_name)

    -- Some weaponskills drain MP instead of doing damage.
    audits = H.TP.MP_Drain(audits, ws_id)

    if not owner_mob then DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.DAMAGE_TAKEN_TOTAL, H.Metric.TOTAL) end
    DB.Data.Update(H.Mode.INC, damage, audits, audits.trackable, H.Metric.TOTAL)

    return damage
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
    local trackable = H.Trackable.TP_DMG_TAKEN

    if owner_mob then
        pet_name = target_mob.name
        target_name = owner_mob.name
        trackable = H.Trackable.PET_TP_DMG_TAKEN
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

-- ------------------------------------------------------------------------------------------------------
-- Some pet skills don't do direct damage and their effects come in as damage--must be ignored.
-- ------------------------------------------------------------------------------------------------------
---@param damage number
---@param ws_id number
---@param ws_name string
---@return number
-- ------------------------------------------------------------------------------------------------------
H.TP_Def.Ignore_Damage = function(damage, ws_id, ws_name)
    if not Lists.Ability.Pet_Damaging[ws_id] then
        _Debug.Error.Add("TP.Pet_Skill_Ignore: " .. tostring(ws_id) .. " " .. tostring(ws_name) .. " considered a non-damage pet ability.")
        damage = 0
    end
    return damage
end