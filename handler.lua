local p = {}

p.Action = {}
p.Handler = {}
p.Packets = {}
p.Util = {}

p.Mode = Model.Enum.Mode
p.Trackable = Model.Enum.Trackable
p.Metric = Model.Enum.Metric

p.Enum = {}
p.Enum.Offsets = {
    ABILITY = 512,
    PET  = 512,
}
p.Enum.Flags = {
    IGNORE = "ignore",
}
p.Enum.Text = {
    BLANK = "",
}

-- FUTURE CONSIDERATIONS 
-- 1. Catalog enspell damage.

------------------------------------------------------------------------------------------------------
-- Parse the weaponskill packet.
-- Surprises:
-- 1. Some abilities--like DRG Jumps--oddly show up in this packet.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param log_offense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
p.Action.Finish_Weaponskill = function(action, actor_mob, log_offense)
    if not log_offense then return end

	local ws_id = action.param
    local ws_data = A.WS.ID(ws_id)
	if not ws_data then
        _Debug.Error.Add("Action.Finish_Weaponskill: {" .. tostring(actor_mob.name) .. "} used ws ID " .. tostring(ws_id) .. " and it wasn't found.")
        return nil
    end
	local ws_name = ws_data.en

    local result, target, sc_id, sc_name, skillchain
    local damage    = 0
    local sc_damage = 0

    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do

            result = action.targets[target_index].actions[action_index]

            -- Handle the case where a job ability shows up in the weaponskill packet. Swift Blade and Steal share the same ID...
            -- I'm differentiating them based on chate message
            -- Specific case: Steal/Swift Blade, Atonement/Mug, Gale Axe/Jump, Spinning Axe/Super Jump
            if Lists.WS.WS_Abilities[ws_id] then
                if result.message ~= 185 and result.message ~= 188 then
                    Handler.Action.Job_Ability(action, actor_mob, log_offense)
                    return nil
                end
            end

            target = A.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if not target then target = {name = 'test'} end
            if target.spawn_flags == A.Enum.Spawn_Flags.MOB then Model.Util.Check_Mob_List(target.name) end

            -- Check for skillchains
            sc_id = result.add_effect_message

            if sc_id > 0 then
                skillchain = true
                sc_name    = Lists.WS.Skillchains[sc_id]
                sc_damage  = sc_damage + p.Handler.Skillchain(result, actor_mob.name, target.name, sc_name)
            end

            -- Need to calculate WS damage here to account for AOE weaponskills
            damage = damage + p.Handler.Weaponskill(result, actor_mob.name, target.name, ws_name, ws_id)
        end
    end

    -- Finalize weaponskill data
    -- Have to do it outside of the loop to avoid counting attempts and hits multiple times
    local audits = {
        player_name = actor_mob.name,
        target_name = target.name,
    }

    Model.Update.Data(p.Mode.INC, 1, audits, p.Trackable.WS, p.Metric.COUNT)
    Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, p.Trackable.WS, ws_name, p.Metric.COUNT)

    if damage > 0 then
        Model.Update.Data(p.Mode.INC, 1, audits, p.Trackable.WS, p.Metric.HIT_COUNT)
        Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, p.Trackable.WS, ws_name, p.Metric.HIT_COUNT)
    end

    if sc_damage > 0 then
        Model.Update.Data(p.Mode.INC, 1, audits, p.Trackable.SC, p.Metric.COUNT)
        Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, p.Trackable.SC, sc_name, p.Metric.COUNT)
        Model.Update.Data(p.Mode.INC, 1, audits, p.Trackable.SC, p.Metric.HIT_COUNT)
        Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, p.Trackable.SC, sc_name, p.Metric.HIT_COUNT)
    end

    -- Update the battle log
    if Blog.Flags.WS then
        Blog.Add(actor_mob.name, ws_name, damage, A.Party.Refresh(actor_mob.name, A.Enum.Mob.TP), p.Trackable.WS, ws_data)
    end
    if Blog.Flags.SC and skillchain then
        Blog.Add(actor_mob.name, sc_name, sc_damage, nil, Model.Enum.Trackable.SC)
    end
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
p.Action.Finish_Monster_TP_Move = function(action, actor_mob, log_offense)
    if not log_offense then return false end
    local owner_mob = A.Mob.Pet_Owner(actor_mob)    -- Check to see if the pet belongs to anyone in the party.

    local result, target, ws_name, sc_id, sc_name
    local sc_damage  = 0
    local damage     = 0
    local action_id  = action.param

    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target = A.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if not target then target = {name = 'test'} end
            if target.spawn_flags == A.Enum.Spawn_Flags.MOB then Model.Util.Check_Mob_List(target.name) end

            -- Puppet ranged attack
            if action_id == 1949 then
                p.Handler.Ranged(result, actor_mob.name, target.name, owner_mob)
                ws_name = "Pet Ranged"
                damage = result.param
            else
                -- Get ability data
                local ws_data = Pet_Skill[action_id]
                if not ws_data then
                    _Debug.Error.Add("Action.Finish_Monster_TP_Move: {" .. tostring(actor_mob.name) .. "} TP move " .. tostring(action_id) .. " unampped in Pet_Skill.")
                    ws_data = {id = action_id, en = "UNK Mon. Ability (" .. action_id .. ")"}
                end
                ws_name = ws_data.en

                -- Check for skillchains
                sc_id = result.add_effect_message
                if sc_id > 0 then
                    sc_name    = Lists.WS.Skillchains[sc_id]
                    sc_damage  = sc_damage + p.Handler.Skillchain(result, actor_mob.name, target.name, sc_name)
                end

                -- Need to calculate WS damage here to account for AOE weaponskills
                damage = damage + p.Handler.Weaponskill(result, actor_mob.name, target.name, ws_name, action_id, owner_mob)
            end
        end
    end

    -- Case where this is a trust or regular monster.
    local player_name = actor_mob.name
    local pet_name = nil
    local trackable = p.Trackable.WS

    -- Case where this is a player's pet using an ability.
    if owner_mob then
        player_name = owner_mob.name
        pet_name = actor_mob.name
        trackable = p.Trackable.PET_WS
    end

    local audits = {
        player_name = player_name,
        target_name = target.name,
        pet_name = pet_name,
    }
    Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, trackable, ws_name, p.Metric.COUNT)

    if damage > 0 then
        Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, trackable, ws_name, p.Metric.HIT_COUNT)
    end

    -- The battle log is interesting here. Pets have abilities that have status effects but don't do any damage.
    -- The text needs a little massaging to avoid making it look like all the pet's status effect abilities missed.
    -- Additional abilities such as these may need to be added to monster ability filter.
    if Blog.Flags.Pet and owner_mob then
        local ignore = nil
        if not Lists.Ability.Monster_Damaging[action_id] then ignore = p.Enum.Flags.IGNORE end
        Blog.Add(owner_mob.name .. " (" .. Col.String.Truncate(actor_mob.name, Blog.Settings.Truncate_Length) .. ")", ws_name, damage, p.Enum.Text.BLANK, ignore)
    end

    return true
end

------------------------------------------------------------------------------------------------------
-- Set data for a weaponskill action.
-- AOE weaponskills will go through this one time for each mob hit.
------------------------------------------------------------------------------------------------------
---@param metadata table contains all the information for the action.
---@param player_name string name of the player that did the action.
---@param target_name string name of the target that received the action.
---@param ws_name string name of the weaponskill that was used.
---@param ws_id number ID of the ability that was used. Right now this is used to check monster abilities.
---@param owner_mob? table if the action was from a pet then this will hold the owner's mob.
---@return number
------------------------------------------------------------------------------------------------------
p.Handler.Weaponskill = function(metadata, player_name, target_name, ws_name, ws_id, owner_mob)
    _Debug.Packet.Add(player_name, target_name, "Weaponskill", metadata)
    local damage = metadata.param
    local ws_type = p.Trackable.WS
    local pet_name

    if owner_mob then
        pet_name = player_name
        player_name = owner_mob.name
        ws_type = p.Trackable.PET_WS
    end

    local audits = {
        player_name = player_name,
        target_name = target_name,
        pet_name = pet_name,
    }

    -- Landing a status effect carries in a value as if it were damage.
    if owner_mob then
        Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.PET, p.Metric.TOTAL)
        if not Lists.Ability.Monster_Damaging[ws_id] then
            _Debug.Error.Add("Handler.Weaponskill: " .. tostring(ws_id) .. " " .. tostring(ws_name) .. " considered a non-damage pet ability.")
            damage = 0
        end
    end

    -- Ignore numbers on these.
    -- Energy Steal [21]
    -- Energy Drain [22]
    -- Starlight [163]
    -- Moonlight [164]

    -- This handles both the pet and player case.
    Model.Update.Catalog_Damage(player_name, target_name, ws_type, damage, ws_name, pet_name)

    return damage
end

------------------------------------------------------------------------------------------------------
-- Set data for a skillchain action.
------------------------------------------------------------------------------------------------------
---@param metadata table contains all the information for the action.
---@param player_name string name of the player that did the action.
---@param target_name string name of the target that received the action.
---@param sc_name string name of the skillchain that happened.
---@return number
------------------------------------------------------------------------------------------------------
p.Handler.Skillchain = function(metadata, player_name, target_name, sc_name)
    _Debug.Packet.Add(player_name, target_name, "Skillchain", metadata)
    local damage = metadata.add_effect_param
    Model.Update.Catalog_Damage(player_name, target_name, p.Trackable.SC, damage, sc_name)
    return damage
end

------------------------------------------------------------------------------------------------------
-- Parse the job ability casting packet.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param log_offense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
p.Action.Job_Ability = function(action, actor_mob, log_offense)
    if not log_offense then return end

	-- Need to provide an offset to get to the abilities. Otherwise I get WS information.
	local ability_id = action.param + p.Enum.Offsets.ABILITY
    local ability_data = A.Ability.ID(ability_id)

    -- Handle missing abilities.
    if not ability_data then
        _Debug.Error.Add("Action.Job_Ability: {" .. tostring(actor_mob.name) .. "} Data on ability ID " .. tostring(ability_id) .. " is unavailable.")
        ability_data = {Id = ability_id, Name = "UNK Ability (" .. ability_id .. ")"}
    else
        ability_data = {Id = ability_id, Name = A.Ability.Name(ability_id, ability_data)}
    end

    -- Process action data.
    local result, target
    local damage = 0
    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target = A.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if not target then target = {name = 'test'} end
            if target.spawn_flags == A.Enum.Spawn_Flags.MOB then Model.Util.Check_Mob_List(target.name) end
            damage = damage + p.Handler.Ability(ability_data, result, actor_mob, target.name)
        end
    end

    -- Log remaining action data.
    local audits = {
        player_name = actor_mob.name,
        target_name = target.name,
    }
    Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, p.Trackable.ABILITY, ability_data.Name, p.Metric.COUNT)
end

------------------------------------------------------------------------------------------------------
-- Parse the pet ability packet.
-- SMN bloodpacts; DRG wyvern breaths
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param log_offense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
p.Action.Pet_Ability = function(action, actor_mob, log_offense)
    if not log_offense then return false end

    -- Check to see if the pet belongs to anyone in the party.
    local owner_mob = A.Mob.Pet_Owner(actor_mob)
    if not owner_mob then return false end

    local ability_id = action.param
    local ability_data
    local avatar = false
    local trackable = p.Trackable.PET_ABILITY

    -- Handle offset for Blood Pacts. I don't know why they are all out of order.
    if Lists.Ability.Rage[ability_id] then
        ability_data = Lists.Ability.Rage[ability_id]
        avatar = true
    elseif Lists.Ability.Ward[ability_id] then
        ability_data = Lists.Ability.Ward[ability_id]
        if Lists.Ability.Avatar_Healing[ability_id] then trackable = p.Trackable.PET_HEAL end
        avatar = true
    else
        ability_data = A.Ability.ID(ability_id + p.Enum.Offsets.PET)
        if Lists.Ability.Wyvern_Healing[ability_id] then trackable = p.Trackable.PET_HEAL end
    end

    -- Need special data handling since pulling from multiple sources.
    if not ability_data then
        _Debug.Error.Add("Action.Pet_Ability: {" .. tostring(actor_mob.name) .. "} Data on ability ID " .. tostring(ability_id) .. " is unavailable.")
        ability_data = {Id = ability_id, Name = "UNK Ability (" .. ability_id .. ")"}
    else
        if avatar then
            ability_data = {Id = ability_id, Name = ability_data.en}
        else
            ability_data = {Id = ability_id, Name = A.Ability.Name(ability_id, ability_data)}
        end
    end

    local result, target
    local damage = 0
    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target = A.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if not target then target = {name = 'test'} end
            if target.spawn_flags == A.Enum.Spawn_Flags.MOB then Model.Util.Check_Mob_List(target.name) end
            damage = damage + p.Handler.Ability(ability_data, result, owner_mob, target.name, actor_mob)
        end
    end

    local audits = {
        player_name = owner_mob.name,
        target_name = target.name,
        pet_name = actor_mob.name,
    }

    Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, trackable, ability_data.Name, p.Metric.COUNT)

    if damage > 0 then
        Model.Update.Data(p.Mode.INC, 1, audits, trackable, p.Metric.HIT_COUNT)
        if Blog.Flags.Pet and (Lists.Ability.Rage[ability_id] or Lists.Ability.Wyvern_Breath[ability_id]) then
            Blog.Add(owner_mob.name .. " (" .. Col.String.Truncate(actor_mob.name, Blog.Settings.Truncate_Length) .. ")", ability_data.Name, damage) 
        end
    end

    return true
end

------------------------------------------------------------------------------------------------------
-- Set data for an ability action.
-- This includes pet damage (since they are ability based).
-- Using an ability to cause a pet to attack gets captured here, but the actual data for the damage
-- done comes in a different packet. SMN comes in Pet_Ability and then routes back to here.
------------------------------------------------------------------------------------------------------
---@param ability_data table the main packet; need it to get ability ID
---@param metadata table contains all the information for the action.
---@param actor_mob table name of the player that did the action.
---@param target_name string name of the target that received the action.
---@param owner_mob? table if the action was from a pet then this will hold the owner's mob.
---@return number
------------------------------------------------------------------------------------------------------
p.Handler.Ability = function(ability_data, metadata, actor_mob, target_name, owner_mob)
    _Debug.Packet.Add(actor_mob.name, target_name, "Ability", metadata)
    local player_name = actor_mob.name
    local ability_id = ability_data.Id
    local ability_name = ability_data.Name
    local damage = metadata.param
    local ability_type = p.Trackable.ABILITY

    local pet_name = nil
    if owner_mob then
        ability_type = p.Trackable.PET_ABILITY
        pet_name = owner_mob.name
    end

    local audits = {
        player_name = player_name,
        target_name = target_name,
        pet_name = pet_name,
    }

    -- Specifics
    if owner_mob then
        if Lists.Ability.Rage[ability_id] then
            Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.PET, p.Metric.TOTAL)
            Model.Update.Catalog_Damage(player_name, target_name, ability_type, damage, ability_name, owner_mob.name)
            if damage > 0 then
                Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, ability_type, ability_name, p.Metric.HIT_COUNT)
            end
        elseif Lists.Ability.Avatar_Healing[ability_id] or Lists.Ability.Wyvern_Healing[ability_id] then
            ability_type = p.Trackable.PET_HEAL
            Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.HEALING, p.Metric.TOTAL)
            Model.Update.Catalog_Damage(player_name, target_name, ability_type, damage, ability_name, owner_mob.name)
            if damage > 0 then
                Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, ability_type, ability_name, p.Metric.HIT_COUNT)
            end
        elseif Lists.Ability.Wyvern_Breath[ability_id] then
            Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.PET, p.Metric.TOTAL)
            Model.Update.Catalog_Damage(player_name, target_name, ability_type, damage, ability_name, owner_mob.name)
            if damage > 0 then
                Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, ability_type, ability_name, p.Metric.HIT_COUNT)
            end
        end
    else
        if Lists.Ability.Damaging[ability_id] then
            if damage > 0 then
                Model.Update.Catalog_Damage(player_name, target_name, ability_type, damage, ability_name)
                Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, ability_type, ability_name, p.Metric.HIT_COUNT)
            end
        end
    end

    -- Set a flag to make this section show up in the Focus menu.
    Model.Update.Data(p.Mode.INC, 1, audits, ability_type, p.Metric.COUNT)

    return damage
end

------------------------------------------------------------------------------------------------------
-- Parse the finish spell casting packet.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param log_offense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
p.Action.Finish_Spell_Casting = function(action, actor_mob, log_offense)
    if not log_offense then return nil end

    local result, target, new_damage
    local damage = 0
    local spell_id = action.param
    local spell_data = A.Spell.ID(spell_id)
    if not spell_data then return nil end
	local spell_name = A.Spell.Name(spell_id, spell_data)
    local is_burst = false

    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target = A.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if not target then target = {name = "test"} end
            if target.spawn_flags == A.Enum.Spawn_Flags.MOB then Model.Util.Check_Mob_List(target.name) end

            is_burst = result.message == 252
            new_damage = p.Handler.Spell_Damage(spell_data, result, actor_mob.name, target.name, is_burst)
            if not new_damage then new_damage = 0 end

            damage = damage + new_damage
        end
    end

    local audits = {
        player_name = actor_mob.name,
        target_name = target.name,
    }

    -- Log the use of the spell
    if Lists.Spell.Damaging[spell_id] then
        Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, p.Trackable.MAGIC, spell_name, p.Metric.COUNT)
    end
    if Lists.Spell.Healing[spell_id] then
        Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, p.Trackable.HEALING, spell_name, p.Metric.COUNT)
    end
    if is_burst then Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, p.Trackable.MAGIC, spell_name, p.Metric.BURST_COUNT) end

    if Lists.Spell.Damaging[spell_id] and Blog.Flags.Magic then
        local burst_message = ""
        if is_burst then burst_message = Blog.Enum.Text.MB end
        Blog.Add(actor_mob.name, spell_name, damage, burst_message, Model.Enum.Trackable.MAGIC, spell_data)
    end
end

------------------------------------------------------------------------------------------------------
-- Set data for a spell action (including healing).
-- Not all spells do damage and not all spells heal this will sort those out.
------------------------------------------------------------------------------------------------------
---@param spell_data table the main packet; need it to get spell ID
---@param metadata table contains all the information for the action
---@param player_name string name of the player that did the action
---@param target_name string name of the target that received the action
---@param burst boolean true if this cast was a magic burst.
---@return number
------------------------------------------------------------------------------------------------------
p.Handler.Spell_Damage = function(spell_data, metadata, player_name, target_name, burst)
    _Debug.Packet.Add(player_name, target_name, "Spell", metadata)
    if not spell_data then return 0 end

    local spell_id = spell_data.Index
    local spell_name = A.Spell.Name(spell_id, spell_data)
    local is_mapped = false
    local damage = metadata.param or 0

    if Lists.Spell.Damaging[spell_id] then
        Model.Update.Catalog_Damage(player_name, target_name, p.Trackable.MAGIC, damage, spell_name, nil, burst)
        is_mapped = true
    end

    -- TO DO: Handle Overcure
    if Lists.Spell.Healing[spell_id] then
    	Model.Update.Catalog_Damage(player_name, target_name, p.Trackable.HEALING, damage, spell_name, nil, burst)
        local spell_max = Model.Get.Catalog(player_name, p.Trackable.HEALING, spell_name, p.Metric.MAX)
        local overcure = 0
        if spell_max > damage then
            overcure = spell_max - damage
        end
        local audits = {
            player_name = player_name,
            target_name = target_name,
        }
        Model.Update.Data(p.Mode.INC, overcure, audits, p.Trackable.HEALING, p.Metric.OVERCURE)
        Model.Update.Catalog_Metric(p.Mode.INC, overcure, audits, p.Trackable.HEALING, spell_name, p.Metric.OVERCURE)
        is_mapped = true
    end

    if not is_mapped then
        _Debug.Error.Add("Handler.Spell_Damage: {" .. tostring(player_name) .. "} spell " .. tostring(spell_id) .. " named " .. tostring(spell_name) .. " is unhandled.")
    end

    return damage
end

------------------------------------------------------------------------------------------------------
-- Parse the player death message.
------------------------------------------------------------------------------------------------------
---@param actor_id number mob id of the entity performing the action
---@param target_id number mob id of the entity receiving the action (this is the person dying)
------------------------------------------------------------------------------------------------------
function Player_Death(actor_id, target_id)
    local target = A.Mob.Get_Mob_By_ID(target_id)
    if not target then return end

    local log_death = target.in_party or target.in_alliance
    if not log_death then return end

    local actor = A.Mob.Get_Mob_By_ID(actor_id)
    if not actor then return end

    local audits = {
        player_name = target.name,
        target_name = actor.name,
    }

    Model.Update.Data(p.Mode.INC, 1, audits, p.Trackable.DEATH, p.Metric.COUNT)

    if Blog.Flags.Deaths then Blog.Add(actor.name, "Death", 0) end
end

return p