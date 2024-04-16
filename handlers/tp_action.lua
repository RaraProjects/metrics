H.TP = {}

------------------------------------------------------------------------------------------------------
-- Parse the weaponskill packet.
-- Surprises:
-- 1. Some abilities--like DRG Jumps--oddly show up in this packet.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param log_offense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.TP.Action = function(action, actor_mob, log_offense)
    if not log_offense then return nil end

	local ws_data = H.TP.WS_Data(action, actor_mob)
    if not ws_data then return nil end
    local ws_name = ws_data.en
    local ws_id = ws_data.id

    local result, target_mob, sc_name
    local damage    = 0
    local sc_damage = 0

    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do

            result = action.targets[target_index].actions[action_index]

            -- Abilities marked as weaponskills
            if H.TP.WS_Ability(result, ws_id, action, actor_mob) then return nil end

            target_mob = A.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if not target_mob then target_mob = {name = Model.Enum.Index.DEBUG} end

            -- Check for skillchains
            sc_damage = H.TP.Skillchain_Parse(result, actor_mob, target_mob)

            -- Need to calculate WS damage here to account for AOE weaponskills
            damage = damage + H.TP.Weaponskill_Parse(result, actor_mob, target_mob, ws_name, ws_id)
        end
    end

    -- Finalize weaponskill data.
    -- Have to do it outside of the loop to avoid counting attempts and hits multiple times.
    local audits = {
        player_name = actor_mob.name,
        target_name = target_mob.name,
    }
    H.TP.Weaponskill_Attempts(audits, ws_name)
    if damage > 0 then H.TP.Weaponskill_Hit(audits, ws_name) end
    if sc_damage > 0 then H.TP.Skillchain_Hit(audits, sc_name) end

    -- Update the battle log.
    H.TP.Blog_WS(actor_mob, damage, ws_data, ws_name)
    H.TP.Blog_SC(actor_mob, sc_damage, sc_name)
end

------------------------------------------------------------------------------------------------------
-- Parse the finish monster TP move packet.
-- BST Pet and Puppet ranged attacks fall into this category.
-- Trust abilities can show up here too. They don't have an owner.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param log_offense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.TP.Monster_Action = function(action, actor_mob, log_offense)
    if not log_offense then return false end
    local owner_mob = A.Mob.Pet_Owner(actor_mob)    -- Check to see if the pet belongs to anyone in the party.

    local skill_data = H.TP.Pet_Skill_Data(action.param, actor_mob)
    if not skill_data then return nil end
    local skill_name = skill_data.en
    local action_id = skill_data.id

    local result, target_mob
    local damage = 0

    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target_mob = A.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if not target_mob then target_mob = {name = Model.Enum.Index.DEBUG} end

            -- Puppet ranged attack
            -- This needs to be inside the result loop in order to send the data to the ranged handler.
            if action_id == 1949 then
                H.Ranged.Parse(result, actor_mob.name, target_mob.name, owner_mob)
                skill_name = "Pet Ranged"
                damage = result.param

            -- BST pet abilities can't skillchain in HorizonXI.
            -- Need to calculate WS damage here to account for AOE weaponskills.
            else
                damage = damage + H.TP.Weaponskill_Parse(result, actor_mob, target_mob, skill_name, action_id, owner_mob)
            end
        end
    end

    local audits = H.TP.Audits(actor_mob, owner_mob, target_mob)
    H.TP.Pet_Skill_Attempts(audits, audits.trackable, skill_name)
    if damage > 0 then H.TP.Pet_Skill_Hit(audits, audits.trackable, skill_name) end

    -- Update the battle log.
    H.TP.Blog_Pet_Skill(owner_mob, actor_mob, action_id, damage, skill_name)

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
H.TP.Weaponskill_Parse = function(result, actor_mob, target_mob, ws_name, ws_id, owner_mob)
    _Debug.Packet.Add(actor_mob, target_mob, "Weaponskill", result)
    local damage = result.param
    local audits = H.TP.Audits(actor_mob, owner_mob, target_mob)

    -- A lot of pet abilities just land a status effect and it carries in a value as if it were damage.
    damage = H.TP.Pet_Skill_Ignore(owner_mob, audits, damage, ws_id, ws_name)

    -- Ignore numbers on these.
    -- Energy Steal [21]
    -- Energy Drain [22]
    -- Starlight [163]
    -- Moonlight [164]

    -- This handles both the pet and player case.
    Model.Update.Catalog_Damage(actor_mob.name, target_mob.name, audits.trackable, damage, ws_name, audits.pet_name)

    -- Set a flag to make this section show up in the Focus menu.
    Model.Update.Data(H.Mode.INC, 1, audits, audits.trackable, H.Metric.COUNT)

    return damage
end

-- ------------------------------------------------------------------------------------------------------
-- Get weaponskill data.
-- ------------------------------------------------------------------------------------------------------
H.TP.WS_Data = function(action, actor_mob)
    local ws_data = A.WS.ID(action.param)
	if not ws_data then
        _Debug.Error.Add("Action.Finish_Weaponskill: {" .. tostring(actor_mob.name) .. "} used ws ID " .. tostring(action.param) .. " and it wasn't found.")
        return nil
    end
    return ws_data
end

-- ------------------------------------------------------------------------------------------------------
-- Get pet skill data.
-- ------------------------------------------------------------------------------------------------------
H.TP.Pet_Skill_Data = function(action_id, actor_mob)
    local skill_data = Pet_Skill[action_id]
    if not skill_data then
        _Debug.Error.Add("Action.Finish_Monster_TP_Move: {" .. tostring(actor_mob.name) .. "} TP move " .. tostring(action_id) .. " unampped in Pet_Skill.")
        skill_data = {id = action_id, en = "UNK Mon. Ability (" .. action_id .. ")"}
    end
    return skill_data
end

-- ------------------------------------------------------------------------------------------------------
-- Checks for abilities that come through on the WS packet.
-- I'm differentiating them based on chat message, so this needs to be called in the result loop and not before.
-- Specific case: Steal/Swift Blade, Atonement/Mug, Gale Axe/Jump, Spinning Axe/Super Jump
-- ------------------------------------------------------------------------------------------------------
H.TP.WS_Ability = function(result, ws_id, action, actor_mob)
    if Lists.WS.WS_Abilities[ws_id] then
        if result.message ~= 185 and result.message ~= 188 then
            Handler.Action.Job_Ability(action, actor_mob, true)
            return true
        end
    end
    return false
end

-- ------------------------------------------------------------------------------------------------------
-- Increments weaponskill attempts.
-- ------------------------------------------------------------------------------------------------------
H.TP.Weaponskill_Attempts = function(audits, ws_name)
    Model.Update.Data(H.Mode.INC, 1, audits, H.Trackable.WS, H.Metric.COUNT)
    Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, H.Trackable.WS, ws_name, H.Metric.COUNT)
end

-- ------------------------------------------------------------------------------------------------------
-- Increments weaponskill hits.
-- ------------------------------------------------------------------------------------------------------
H.TP.Weaponskill_Hit = function(audits, ws_name)
    Model.Update.Data(H.Mode.INC, 1, audits, H.Trackable.WS, H.Metric.HIT_COUNT)
    Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, H.Trackable.WS, ws_name, H.Metric.HIT_COUNT)
end

-- ------------------------------------------------------------------------------------------------------
-- Increments pet skill attempts.
-- ------------------------------------------------------------------------------------------------------
H.TP.Pet_Skill_Attempts = function(audits, trackable, skill_name)
    Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, trackable, skill_name, H.Metric.COUNT)
end

-- ------------------------------------------------------------------------------------------------------
-- Some pet skills don't do direct damage and their effects come in as damage--must be ignored.
-- ------------------------------------------------------------------------------------------------------
H.TP.Pet_Skill_Ignore = function(owner_mob, audits, damage, ws_id, ws_name)
    if owner_mob then
        Model.Update.Data(H.Mode.INC, damage, audits, H.Trackable.PET, H.Metric.TOTAL)
        if not Lists.Ability.Monster_Damaging[ws_id] then
            _Debug.Error.Add("Handler.Weaponskill: " .. tostring(ws_id) .. " " .. tostring(ws_name) .. " considered a non-damage pet ability.")
            damage = 0
        end
    end
    return damage
end

-- ------------------------------------------------------------------------------------------------------
-- Increments pet skill hits.
-- ------------------------------------------------------------------------------------------------------
H.TP.Pet_Skill_Hit = function(audits, trackable, skill_name)
    Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, trackable, skill_name, H.Metric.HIT_COUNT)
end

-- ------------------------------------------------------------------------------------------------------
-- Set audit information for pet skills.
-- ------------------------------------------------------------------------------------------------------
H.TP.Audits = function(actor_mob, owner_mob, target_mob)
    -- Initialize on case where this is a trust or regular monster.
    local player_name = actor_mob.name
    local pet_name = nil
    local trackable = H.Trackable.WS

    -- Case where this is a player's pet using an ability.
    if owner_mob then
        player_name = owner_mob.name
        pet_name = actor_mob.name
        trackable = H.Trackable.PET_WS
    end

    -- Finalize pet skill data.
    -- Have to do it outside of the loop to avoid counting attempts and hits multiple times.
    local audits = {
        player_name = player_name,
        target_name = target_mob.name,
        pet_name = pet_name,
        trackable = trackable
    }

    return audits
end

-- ------------------------------------------------------------------------------------------------------
-- Check for skillchains.
-- ------------------------------------------------------------------------------------------------------
H.TP.Skillchain_Parse = function(result, actor_mob, target_mob)
    local sc_id = result.add_effect_message
    local sc_damage = 0
    if sc_id > 0 then
        local sc_name    = Lists.WS.Skillchains[sc_id]
        sc_damage  = sc_damage + H.TP.Skillchain_Damage(result, actor_mob.name, target_mob.name, sc_name)
    end
    return sc_damage
end

------------------------------------------------------------------------------------------------------
-- Set damage data for a skillchain action.
------------------------------------------------------------------------------------------------------
---@param result table contains all the information for the action.
---@param player_name string name of the player that did the action.
---@param target_name string name of the target that received the action.
---@param sc_name string name of the skillchain that happened.
---@return number
------------------------------------------------------------------------------------------------------
H.TP.Skillchain_Damage = function(result, player_name, target_name, sc_name)
    _Debug.Packet.Add(player_name, target_name, "Skillchain", result)
    local damage = result.add_effect_param
    Model.Update.Catalog_Damage(player_name, target_name, H.Trackable.SC, damage, sc_name)
    return damage
end

-- ------------------------------------------------------------------------------------------------------
-- Increments skillchain counts.
-- ------------------------------------------------------------------------------------------------------
H.TP.Skillchain_Hit = function(audits, sc_name)
    Model.Update.Data(H.Mode.INC, 1, audits, H.Trackable.SC, H.Metric.COUNT)
    Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, H.Trackable.SC, sc_name, H.Metric.COUNT)
    Model.Update.Data(H.Mode.INC, 1, audits, H.Trackable.SC, H.Metric.HIT_COUNT)
    Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, H.Trackable.SC, sc_name, H.Metric.HIT_COUNT)
end

-- ------------------------------------------------------------------------------------------------------
-- Adds weaponskill damage to the battle log.
-- ------------------------------------------------------------------------------------------------------
H.TP.Blog_WS = function(actor_mob, damage, ws_data, ws_name)
    if Blog.Flags.WS then
        Blog.Add(actor_mob.name, ws_name, damage, A.Party.Refresh(actor_mob.name, A.Enum.Mob.TP), H.Trackable.WS, ws_data)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Adds skillchain damage to the battle log.
-- ------------------------------------------------------------------------------------------------------
H.TP.Blog_SC = function(actor_mob, sc_damage, sc_name)
    if Blog.Flags.SC and sc_damage > 0 then
        Blog.Add(actor_mob.name, sc_name, sc_damage, nil, Model.Enum.Trackable.SC)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Adds pet skill damage to the battle log.
-- The battle log is interesting here. Pets have abilities that have status effects but don't do any damage.
-- The text needs a little massaging to avoid making it look like all the pet's status effect abilities missed.
-- Additional abilities such as these may need to be added to monster ability filter.
-- ------------------------------------------------------------------------------------------------------
H.TP.Blog_Pet_Skill = function(owner_mob, actor_mob, action_id, damage, skill_name)
    if Blog.Flags.Pet and owner_mob then
        local ignore = nil
        if not Lists.Ability.Monster_Damaging[action_id] then ignore = H.Enum.Flags.IGNORE end
        Blog.Add(owner_mob.name .. " (" .. Col.String.Truncate(actor_mob.name, Blog.Settings.Truncate_Length) .. ")", skill_name, damage, H.Enum.Text.BLANK, ignore)
    end
end