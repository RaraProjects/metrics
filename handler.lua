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

-- ------------------------------------------------------------------------------------------------------
-- Parse the melee attack packet.
-- ------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param owner_mob table|nil (if pet) the mob data of the entity's owner.
---@param log_offense boolean if this action should actually be logged.
-- ------------------------------------------------------------------------------------------------------
p.Action.Melee = function(action, actor_mob, owner_mob, log_offense)
	if not log_offense then return end

	local result, target
	local damage = 0

	for target_index, target_value in pairs(action.targets) do
		for action_index, _ in pairs(target_value.actions) do
			result = action.targets[target_index].actions[action_index]
			target = A.Mob.Get_Mob_By_ID(action.targets[target_index].id)
			if not target then target = {name = 'test'} end
            if target.spawn_flags == A.Enum.Spawn_Flags.MOB then Model.Util.Check_Mob_List(target.name) end
			damage = damage + p.Handler.Melee(result, actor_mob.name, target.name, owner_mob)
		end
	end

    if Blog.Flags.Melee then
        local blog_name = actor_mob.name
        if owner_mob then
            blog_name = owner_mob.name .. " (" .. actor_mob.name .. ")"
        end
        Blog.Add(blog_name, Model.Enum.Trackable.MELEE, damage)
    end
end

------------------------------------------------------------------------------------------------------
-- Set data for a melee action.
-- NOTES:
-- message 				https://github.com/Windower/Lua/wiki/Message-IDs
-- has_add_effect		boolean
-- add_effect_animation	https://github.com/Windower/Lua/wiki/Additional-Effect-IDs
-- Enspell element
-- add_effect_message	229: comes up with Ygnas bonus attack
-- add_effect_param		enspell damage
-- spike_effect_param	0: consistently on MNK vs Apex bats
-- spike_effect_effect	
-- effect 				2: killing blow
-- 						4: counter? (probably not)
-- stagger 				animation the target does when being hit
-- reaction 			8: hit; consistently on MNK vs Apex bats
-- 						9: miss?; very rarely on MNK vs Apex bats
------------------------------------------------------------------------------------------------------
---@param metadata table contains all the information for the action.
---@param player_name string name of the player that did the action.
---@param target_name string name of the target that received the action.
---@param owner_mob? table if the action was from a pet then this will hold the owner's mob.
---@return number
------------------------------------------------------------------------------------------------------
p.Handler.Melee = function(metadata, player_name, target_name, owner_mob)
    _Debug.Packet.Add(player_name, target_name, "Melee", metadata)
    local animation_id = metadata.animation
    local damage = metadata.param
    local message_id = metadata.message
    local throwing = false

    local melee_type_broad = Model.Enum.Trackable.MELEE
    local melee_type_discrete = p.Util.Discrete_Melee_Type(animation_id)

    -- Need special handling for pets
    local pet_name
    if owner_mob then
        melee_type_broad = Model.Enum.Trackable.PET_MELEE
        melee_type_discrete = Model.Enum.Trackable.PET_MELEE_DISCRETE
        pet_name = player_name
        player_name = owner_mob.name
    end

    local audits = {
        player_name = player_name,
        target_name = target_name,
        pet_name = pet_name,
    }

    -- Perfect Dodge miss, miss, mob heal, shadows shouldn't count toward damage.
    if message_id == A.Enum.Message.DODGE or message_id == A.Enum.Message.MOBHEAL373 or message_id == A.Enum.Message.MISS or message_id == A.Enum.Message.SHADOWS then
        damage = 0
    end

    -- Totals ///////////////////////////////////////////////////////
    Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.TOTAL, p.Metric.TOTAL)
    Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.TOTAL_NO_SC, p.Metric.TOTAL)
    Model.Update.Data(p.Mode.INC, damage, audits, melee_type_discrete, p.Metric.TOTAL)
    Model.Update.Data(p.Mode.INC,      1, audits, melee_type_discrete, p.Metric.COUNT)

    if owner_mob then
        Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.PET, p.Metric.TOTAL)
    end

    -- Melee ////////////////////////////////////////////////////////
    if animation_id >= A.Enum.Animation.MELEE_MAIN and animation_id < A.Enum.Animation.THROWING then
        Model.Update.Data(p.Mode.INC, damage, audits, melee_type_broad, p.Metric.TOTAL)
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_broad, p.Metric.COUNT)
    -- Throwing /////////////////////////////////////////////////////
    elseif animation_id == A.Enum.Animation.THROWING then
        throwing = true
        Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.RANGED, p.Metric.TOTAL)
        Model.Update.Data(p.Mode.INC,      1, audits, p.Trackable.RANGED, p.Metric.COUNT)
    -- Unhandled Animation //////////////////////////////////////////
    else
        _Debug.Error.Add("Handler.Melee: {" .. tostring(player_name) .. "} Unhandled animation: " .. tostring(animation_id))
    end

    -- Min/Max //////////////////////////////////////////////////////
    if throwing then
        if damage > 0 and (damage < Model.Get.Data(player_name, p.Trackable.RANGED, p.Metric.MIN)) then Model.Update.Data(p.Mode.SET, damage, audits, p.Trackable.RANGED, p.Metric.MIN) end
        if damage > Model.Get.Data(player_name, p.Trackable.RANGED, p.Metric.MAX) then Model.Update.Data(p.Mode.SET, damage, audits, p.Trackable.RANGED, p.Metric.MAX) end
    else
        if damage > 0 and (damage < Model.Get.Data(player_name, melee_type_broad, p.Metric.MIN)) then Model.Update.Data(p.Mode.SET, damage, audits, melee_type_broad, p.Metric.MIN) end
        if damage > Model.Get.Data(player_name, melee_type_broad, p.Metric.MAX) then Model.Update.Data(p.Mode.SET, damage, audits, melee_type_broad, p.Metric.MAX) end
    end

    -- Enspell //////////////////////////////////////////////////////
    local enspell_damage = metadata.add_effect_param
    if enspell_damage > 0 then
        -- Element of the enspell is in add_effect_animation
        Model.Update.Data(p.Mode.INC, enspell_damage, audits, p.Trackable.MAGIC,       p.Metric.TOTAL)
        Model.Update.Data(p.Mode.INC, enspell_damage, audits, p.Trackable.ENSPELL,     p.Metric.TOTAL)
        Model.Update.Data(p.Mode.INC, enspell_damage, audits, p.Trackable.TOTAL,       p.Metric.TOTAL)  -- It's an extra step to add additional enspell damage to total.
        Model.Update.Data(p.Mode.INC, enspell_damage, audits, p.Trackable.TOTAL_NO_SC, p.Metric.TOTAL)  -- It's an extra step to add additional enspell damage to total.
        Model.Update.Data(p.Mode.INC,              1, audits, p.Trackable.MAGIC,       p.Metric.COUNT)
        if enspell_damage < Model.Get.Data(player_name, p.Trackable.MAGIC, p.Metric.MIN) then Model.Update.Data(p.Mode.SET, enspell_damage, audits, p.Trackable.MAGIC, p.Metric.MIN) end
        if enspell_damage > Model.Get.Data(player_name, p.Trackable.MAGIC, p.Metric.MAX) then Model.Update.Data(p.Mode.SET, enspell_damage, audits, p.Trackable.MAGIC, p.Metric.MAX) end
    end    

    -- Hit //////////////////////////////////////////////////////////
    if message_id == A.Enum.Message.HIT then
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_broad,    p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_discrete, p.Metric.HIT_COUNT)
        Model.Update.Running_Accuracy(player_name, true)
    -- Healing with melee attacks ///////////////////////////////////
    elseif message_id == A.Enum.Message.MOBHEAL3 or message_id == A.Enum.Message.MOBHEAL373 then
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_broad,    p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_discrete, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC, damage, audits, melee_type_broad,    p.Metric.MOB_HEAL)
    -- Misses ///////////////////////////////////////////////////////
    elseif message_id == A.Enum.Message.MISS then
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_broad, p.Metric.MISS_COUNT)
        Model.Update.Running_Accuracy(player_name, false)
    -- Attack absorbed by shadows ///////////////////////////////////
    elseif message_id == A.Enum.Message.SHADOWS then
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_broad,    p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_discrete, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_broad,    p.Metric.SHADOWS)
    -- Attack dodged (Perfect Dodge) ////////////////////////////////
    -- Remove the count so perfect dodge doesn't count.
    elseif message_id == A.Enum.Message.DODGE then
        Model.Update.Data(p.Mode.INC,     -1, audits, melee_type_broad,    p.Metric.COUNT)
        Model.Update.Data(p.Mode.INC,     -1, audits, melee_type_discrete, p.Metric.COUNT)
    -- Critical Hits ////////////////////////////////////////////////
    elseif message_id == A.Enum.Message.CRIT then
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_broad,    p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_discrete, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_broad,    p.Metric.CRIT_COUNT)
        Model.Update.Data(p.Mode.INC, damage, audits, melee_type_broad,    p.Metric.CRIT_DAMAGE)
        Model.Update.Running_Accuracy(player_name, true)
    -- Throwing Critical Hit ////////////////////////////////////////
    elseif message_id == A.Enum.Message.RANGECRIT then
        Model.Update.Data(p.Mode.INC,      1, audits, p.Trackable.RANGED, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC,      1, audits, p.Trackable.RANGED, p.Metric.CRIT_COUNT)
        Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.RANGED, p.Metric.CRIT_DAMAGE)
        Model.Update.Running_Accuracy(player_name, true)
    -- Throwing Miss ////////////////////////////////////////////////
    elseif message_id == A.Enum.Message.RANGEMISS then
        Model.Update.Data(p.Mode.INC,      1, audits, p.Trackable.RANGED, p.Metric.MISS_COUNT)
        Model.Update.Running_Accuracy(player_name, false)
    -- Throwing Square Hit //////////////////////////////////////////
    elseif message_id == A.Enum.Message.SQUARE then
        Model.Update.Data(p.Mode.INC,      1, audits, p.Trackable.RANGED, p.Metric.HIT_COUNT)
        Model.Update.Running_Accuracy(player_name, true)
    -- Throwing Truestrike //////////////////////////////////////////
    elseif message_id == A.Enum.Message.TRUE then
        Model.Update.Data(p.Mode.INC,      1, audits, p.Trackable.RANGED, p.Metric.HIT_COUNT)
        Model.Update.Running_Accuracy(player_name, true)
    else
        _Debug.Error.Add("Handler.Melee: {" .. tostring(player_name) .. "} Unhandled Melee Nuance " .. tostring(message_id))
    end

    local spikes = metadata.spike_effect_effect

    return damage
end

------------------------------------------------------------------------------------------------------
-- Map an animation to a discrete type of melee action.
------------------------------------------------------------------------------------------------------
---@param animation_id number represents, primary attack, offhand attack, kicking, etc.
---@return string
------------------------------------------------------------------------------------------------------
p.Util.Discrete_Melee_Type = function(animation_id)
    if animation_id == A.Enum.Animation.MELEE_MAIN then
        return p.Trackable.MELEE_MAIN
    elseif animation_id == A.Enum.Animation.MELEE_OFFHAND then
        return p.Trackable.MELEE_OFFH
    elseif animation_id == A.Enum.Animation.MELEE_KICK or animation_id == A.Enum.Animation.MELEE_KICK2 then
        return p.Trackable.MELEE_KICK
    elseif animation_id == A.Enum.Animation.THROWING then
        return p.Trackable.THROWING
    else
        return p.Trackable.DEFAULT
    end
end

------------------------------------------------------------------------------------------------------
-- Parse the ranged attack packet.
------------------------------------------------------------------------------------------------------
---@param act table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param log_offense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
p.Action.Ranged = function(act, actor_mob, log_offense)
    if not log_offense then return end

    local result, target
    local damage = 0

    for target_index, target_value in pairs(act.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = act.targets[target_index].actions[action_index]
            target = A.Mob.Get_Mob_By_ID(act.targets[target_index].id)
            if target then
                if target.spawn_flags == A.Enum.Spawn_Flags.MOB then Model.Util.Check_Mob_List(target.name) end
                damage = damage + p.Handler.Ranged(result, actor_mob.name, target.name)
            end
        end
    end

    if Blog.Flags.Ranged then
        Blog.Add(actor_mob.name, p.Trackable.RANGED, damage)
    end
end

------------------------------------------------------------------------------------------------------
-- Set data for a ranged attack action.
------------------------------------------------------------------------------------------------------
---@param metadata table contains all the information for the action.
---@param player_name string name of the player that did the action.
---@param target_name string name of the target that received the action.
---@param owner_mob? table if the action was from a pet then this will hold the owner's mob.
---@return number
------------------------------------------------------------------------------------------------------
p.Handler.Ranged = function(metadata, player_name, target_name, owner_mob)
    _Debug.Packet.Add(player_name, target_name, "Ranged", metadata)
    local damage = metadata.param
    local message_id = metadata.message

    -- Need special handling for pets
    local ranged_type
    if owner_mob then
        ranged_type = p.Trackable.PET_RANGED
        player_name = owner_mob.name
    else
        ranged_type = p.Trackable.RANGED
    end

    local audits = {
        player_name = player_name,
        target_name = target_name,
    }

    -- Totals ///////////////////////////////////////////////////////
    Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.TOTAL,  p.Metric.TOTAL)
    Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.TOTAL_NO_SC, p.Metric.TOTAL)
    Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.COUNT)

    if owner_mob then
        Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.PET, p.Metric.TOTAL)
    end

    -- Miss /////////////////////////////////////////////////////////
    if message_id == A.Enum.Message.RANGEMISS then
    	Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.MISS_COUNT)
        Model.Update.Running_Accuracy(player_name, false)
    	return damage
    -- Shadows //////////////////////////////////////////////////////
    elseif message_id == A.Enum.Message.SHADOWS then
        Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.SHADOWS)
        return damage
    -- Puppet ///////////////////////////////////////////////////////
    elseif message_id == A.Enum.Message.RANGEPUP then
        Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC, damage, audits, ranged_type, p.Metric.TOTAL)
        Model.Update.Running_Accuracy(player_name, true)
    -- Regular Hit //////////////////////////////////////////////////
    elseif message_id == A.Enum.Message.RANGEHIT then
        Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC, damage, audits, ranged_type, p.Metric.TOTAL)
        Model.Update.Running_Accuracy(player_name, true)
    -- Square Hit ///////////////////////////////////////////////////
    elseif message_id == A.Enum.Message.SQUARE then
        Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC, damage, audits, ranged_type, p.Metric.TOTAL)
        Model.Update.Running_Accuracy(player_name, true)
    -- Truestrike ///////////////////////////////////////////////////
    elseif message_id == A.Enum.Message.TRUE then
        Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC, damage, audits, ranged_type, p.Metric.TOTAL)
        Model.Update.Running_Accuracy(player_name, true)
    -- Crit /////////////////////////////////////////////////////////
    elseif message_id == A.Enum.Message.RANGECRIT then
        Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.CRIT_COUNT)
        Model.Update.Data(p.Mode.INC, damage, audits, ranged_type, p.Metric.CRIT_DAMAGE)
        Model.Update.Data(p.Mode.INC, damage, audits, ranged_type, p.Metric.TOTAL)
        Model.Update.Running_Accuracy(player_name, true)
    else
        _Debug.Error.Add("Handler.Ranged: {" .. tostring(player_name) .. "} Unhandled Ranged Nuance " .. tostring(message_id))
    end

    if damage > 0 and (damage < Model.Get.Data(player_name, ranged_type, p.Metric.MIN)) then Model.Update.Data(p.Mode.SET, damage, audits, ranged_type, p.Metric.MIN) end
    if damage > Model.Get.Data(player_name, ranged_type, p.Metric.MAX) then Model.Update.Data(p.Mode.SET, damage, audits, ranged_type, p.Metric.MAX) end

    return damage
end

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