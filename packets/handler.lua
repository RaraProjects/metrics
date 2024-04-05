local parser = require('packets._parser') -- from atom0s

local p = {}

p.Action = {}
p.Handler = {}
p.Packets = {}
p.Util = {}

p.Mode = Model.Enum.Mode
p.Trackable = Model.Enum.Trackable
p.Metric = Model.Enum.Metric

-- Everything is pretty self explanatory except...

-- ------------------------------------------------------------------------------------------------------
-- Parse the melee attack packet.
-- ------------------------------------------------------------------------------------------------------
-- act         : action packet data
-- actor_mob   : the mob data of the entity performing the action
-- log_offense : boolean of if we should log the data; initial filtering happens in action packet
-- ------------------------------------------------------------------------------------------------------
p.Action.Melee = function(act, actor_mob, owner_mob, log_offense)
	if not log_offense then return end

	local result, target
	local damage = 0

	for target_index, target_value in pairs(act.targets) do
		for action_index, _ in pairs(target_value.actions) do
			result = act.targets[target_index].actions[action_index]
			target = A.Mob.Get_Mob_By_ID(act.targets[target_index].id)
			if not target then target = {name = 'test'} end
			damage = damage + p.Handler.Melee(result, actor_mob.name, target.name, owner_mob)
		end
	end

	-- if not actor_mob.is_npc then
		if Blog.Display.Flags.Melee then
			local blog_name = actor_mob.name
            if owner_mob then
                blog_name = owner_mob.name .. " (" .. actor_mob.name .. ")"
            end
            Blog.Log.Add(blog_name, 'Melee', damage)
		end
	-- end
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
-- metadata    : contains all the information for the action
-- player_name : name of the player that did the action
-- target_name : name of the target that received the action
-- owner_mob   : if the action was from a pet then this will hold the owner's mob
------------------------------------------------------------------------------------------------------
p.Handler.Melee = function(metadata, player_name, target_name, owner_mob)
    local animation_id = metadata.animation
    local damage = metadata.param
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

    -- Totals ///////////////////////////////////////////////////////
    Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.TOTAL, p.Metric.TOTAL)
    Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.TOTAL_NO_SC, p.Metric.TOTAL)
    Model.Update.Data(p.Mode.INC, damage, audits, melee_type_discrete, p.Metric.TOTAL)
    Model.Update.Data(p.Mode.INC,      1, audits, melee_type_discrete, p.Metric.COUNT)

    if owner_mob then
        Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.PET, p.Metric.TOTAL)
    end

    -- Melee ////////////////////////////////////////////////////////
    if animation_id >= 0 and animation_id < 4 then
        Model.Update.Data(p.Mode.INC, damage, audits, melee_type_broad, p.Metric.TOTAL)
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_broad, p.Metric.COUNT)
    -- Throwing /////////////////////////////////////////////////////
    elseif animation_id == 4 then
        throwing = true
        Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.RANGED, p.Metric.TOTAL)
        Model.Update.Data(p.Mode.INC,      1, audits, p.Trackable.RANGED, p.Metric.COUNT)
    -- Unhandled Animation //////////////////////////////////////////
    else
        A.Chat.Debug("Handler.Melee: Unhandled animation: "..tostring(animation_id))
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
        Model.Update.Data(p.Mode.INC, enspell_damage, audits, p.Trackable.MAGIC,   p.Metric.TOTAL)
        Model.Update.Data(p.Mode.INC, enspell_damage, audits, p.Trackable.ENSPELL, p.Metric.TOTAL)
        Model.Update.Data(p.Mode.INC,              1, audits, p.Trackable.MAGIC, p.Metric.COUNT)
        if enspell_damage < Model.Get.Data(player_name, p.Trackable.MAGIC, p.Metric.MIN) then Model.Update.Data(p.Mode.SET, enspell_damage, audits, p.Trackable.MAGIC, p.Metric.MIN) end
        if enspell_damage > Model.Get.Data(player_name, p.Trackable.MAGIC, p.Metric.MAX) then Model.Update.Data(p.Mode.SET, enspell_damage, audits, p.Trackable.MAGIC, p.Metric.MAX) end
    end

    -- Metadata /////////////////////////////////////////////////////
    local message_id = metadata.message

    -- Hit //////////////////////////////////////////////////////////
    if message_id == 1 then
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_broad,    p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_discrete, p.Metric.HIT_COUNT)
        Model.Update.Running_Accuracy(player_name, true)
    -- Healing with melee attacks ///////////////////////////////////
    elseif message_id == 3 or message_id == 373 then
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_broad,    p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_discrete, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC, damage, audits, melee_type_broad,    p.Metric.MOB_HEAL)
    -- Misses ///////////////////////////////////////////////////////
    elseif message_id == 15 then
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_broad, p.Metric.MISS_COUNT)
        Model.Update.Running_Accuracy(player_name, false)
    -- DRK vs. Omen Gorger //////////////////////////////////////////
    elseif message_id == 30 then
        A.Chat.Debug("Attack Nuance 30 -- DRK vs. Omen Gorger")
    -- Attack absorbed by shadows ///////////////////////////////////
    elseif message_id == 31 then
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_broad,    p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_discrete, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_broad,    p.Metric.SHADOWS)
    -- Attack dodged (Perfect Dodge) ////////////////////////////////
    -- Remove the count so perfect dodge doesn't count.
    elseif message_id == 32 then
        Model.Update.Data(p.Mode.INC,     -1, audits, melee_type_broad,    p.Metric.COUNT)
        Model.Update.Data(p.Mode.INC,     -1, audits, melee_type_discrete, p.Metric.COUNT)
    -- Critical Hits ////////////////////////////////////////////////
    elseif message_id == 67 then
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_broad,    p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_discrete, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC,      1, audits, melee_type_broad,    p.Metric.CRIT_COUNT)
        Model.Update.Data(p.Mode.INC, damage, audits, melee_type_broad,    p.Metric.CRIT_DAMAGE)
        Model.Update.Running_Accuracy(player_name, true)
    -- Throwing Critical Hit ////////////////////////////////////////
    elseif message_id == 353 then
        Model.Update.Data(p.Mode.INC,      1, audits, p.Trackable.RANGED, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC,      1, audits, p.Trackable.RANGED, p.Metric.CRIT_COUNT)
        Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.RANGED, p.Metric.CRIT_DAMAGE)
        Model.Update.Running_Accuracy(player_name, true)
    -- Throwing Miss ////////////////////////////////////////////////
    elseif message_id == 354 then
        Model.Update.Data(p.Mode.INC,      1, audits, p.Trackable.RANGED, p.Metric.MISS_COUNT)
        Model.Update.Running_Accuracy(player_name, false)
    -- Throwing Square Hit //////////////////////////////////////////
    elseif message_id == 576 then
        Model.Update.Data(p.Mode.INC,      1, audits, p.Trackable.RANGED, p.Metric.HIT_COUNT)
        Model.Update.Running_Accuracy(player_name, true)
    -- Throwing Truestrike //////////////////////////////////////////
    elseif message_id == 577 then
        Model.Update.Data(p.Mode.INC,      1, audits, p.Trackable.RANGED, p.Metric.HIT_COUNT)
        Model.Update.Running_Accuracy(player_name, true)
    else
        Blog.Log.Add(player_name, 'Att. nuance '..message_id) end

    local spikes = metadata.spike_effect_effect

    return damage
end

------------------------------------------------------------------------------------------------------
--
------------------------------------------------------------------------------------------------------
p.Util.Discrete_Melee_Type = function(animation_id)
    if animation_id == 0 then
        return p.Trackable.MELEE_MAIN
    elseif animation_id == 1 then
        return p.Trackable.MELEE_OFFH
    elseif animation_id == 2 or animation_id == 3 then
        return p.Trackable.MELEE_KICK
    elseif animation_id == 4 then
        return p.Trackable.THROWING
    else
        return p.Trackable.DEFAULT
    end
end

------------------------------------------------------------------------------------------------------
-- Parse the ranged attack packet.
------------------------------------------------------------------------------------------------------
-- act         : action packet data
-- actor_mob   : the mob data of the entity performing the action
-- log_offense : boolean of if we should log the data; initial filtering happens in action packet
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
                damage = damage + p.Handler.Ranged(result, actor_mob.name, target.name)
            end
        end
    end

    -- if not actor_mob.is_npc then
        if Blog.Display.Flags.Ranged then
            Blog.Log.Add(actor_mob.name, p.Trackable.RANGED, damage)
        end
    -- end
end

------------------------------------------------------------------------------------------------------
-- Set data for a ranged attack action.
------------------------------------------------------------------------------------------------------
-- metadata    : contains all the information for the action
-- player_name : name of the player that did the action
-- target_name : name of the target that received the action
-- owner_mob   : if the action was from a pet then this will hold the owner's mob
------------------------------------------------------------------------------------------------------
p.Handler.Ranged = function(metadata, player_name, target_name, owner_mob)
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
    if message_id == 354 then
    	Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.MISS_COUNT)
        Model.Update.Running_Accuracy(player_name, false)
    	return damage
    -- Shadows //////////////////////////////////////////////////////
    elseif message_id == 31 then
        Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.SHADOWS)
        return damage
    -- Puppet ///////////////////////////////////////////////////////
    elseif message_id == 185 then
        Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC, damage, audits, ranged_type, p.Metric.TOTAL)
        Model.Update.Running_Accuracy(player_name, true)
    -- Regular Hit //////////////////////////////////////////////////
    elseif message_id == 352 then
        Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC, damage, audits, ranged_type, p.Metric.TOTAL)
        Model.Update.Running_Accuracy(player_name, true)
    -- Square Hit ///////////////////////////////////////////////////
    elseif message_id == 576 then
        Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC, damage, audits, ranged_type, p.Metric.TOTAL)
        Model.Update.Running_Accuracy(player_name, true)
    -- Truestrike ///////////////////////////////////////////////////
    elseif message_id == 577 then
        Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC, damage, audits, ranged_type, p.Metric.TOTAL)
        Model.Update.Running_Accuracy(player_name, true)
    -- Crit /////////////////////////////////////////////////////////
    elseif message_id == 353 then
        Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.HIT_COUNT)
        Model.Update.Data(p.Mode.INC,      1, audits, ranged_type, p.Metric.CRIT_COUNT)
        Model.Update.Data(p.Mode.INC, damage, audits, ranged_type, p.Metric.CRIT_DAMAGE)
        Model.Update.Data(p.Mode.INC, damage, audits, ranged_type, p.Metric.TOTAL)
        Model.Update.Running_Accuracy(player_name, true)
    else
        Blog.Log.Add(player_name, "Missing Ranged Nuance "..tostring(message_id))
    end

    if damage == 0 then
        A.Chat.Debug("Ranged damage was 0.")
    end

    if damage > 0 and (damage < Model.Get.Data(player_name, ranged_type, p.Metric.MIN)) then Model.Update.Data(p.Mode.SET, damage, audits, ranged_type, p.Metric.MIN) end
    if damage > Model.Get.Data(player_name, ranged_type, p.Metric.MAX) then Model.Update.Data(p.Mode.SET, damage, audits, ranged_type, p.Metric.MAX) end

    return damage
end

------------------------------------------------------------------------------------------------------
-- Parse the weaponskill packet.
------------------------------------------------------------------------------------------------------
-- act         : action packet data
-- actor_mob   : the mob data of the entity performing the action
-- log_offense : boolean of if we should log the data; initial filtering happens in action packet
------------------------------------------------------------------------------------------------------
p.Action.Finish_Weaponskill = function(action, actor_mob, log_offense)
    if not log_offense then return end

	local ws_id = action.param
    local ws_data = A.WS.ID(ws_id)
	if not ws_data then return nil end
	local ws_name = ws_data.en

    -- Some abilities--like DRG Jumps--oddly show up in this packet
    if Lists.WS.WS_Abilities[ws_id] then
        P.Action.Job_Ability(action, actor_mob, log_offense)
        return nil
    end

    local result, target, sc_id, sc_name, skillchain
    local damage    = 0
    local sc_damage = 0

    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do

            result = action.targets[target_index].actions[action_index]
            target = A.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if not target then target = {name = 'test'} end

            -- Check for skillchains
            sc_id = result.add_effect_message

            if sc_id > 0 then
                skillchain = true
                sc_name    = Lists.WS.Skillchains[sc_id]
                sc_damage  = sc_damage + p.Handler.Skillchain(result, actor_mob.name, target.name, sc_name)
            end

            -- Need to calculate WS damage here to account for AOE weaponskills
            damage = damage + p.Handler.Weaponskill(result, actor_mob.name, target.name, ws_name)
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

    -- Update the battle log
    -- if not actor_mob.is_npc then
        if Blog.Display.Flags.WS then
            Blog.Log.Add(actor_mob.name, ws_name, damage, nil, A.Party.Refresh(actor_mob.name, A.Mob.Enum.Party_Node.TP), p.Trackable.WS, ws_data)
        end
        if Blog.Display.Flags.SC and skillchain then
            Blog.Log.Add(actor_mob.name, sc_name, sc_damage, nil, nil)
        end
    -- end
end

------------------------------------------------------------------------------------------------------
-- Set data for a weaponskill action.
------------------------------------------------------------------------------------------------------
-- metadata    : contains all the information for the action
-- player_name : name of the player that did the action
-- target_name : name of the target that received the action
-- ws_name     : name of the weaponskill
-- owner_mob   : if the action was from a pet then this will hold the owner's mob
------------------------------------------------------------------------------------------------------
p.Handler.Weaponskill = function(metadata, player_name, target_name, ws_name, owner_mob)
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

    if owner_mob then
        Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.PET, p.Metric.TOTAL)
    end

    Model.Update.Catalog_Damage(player_name, target_name, ws_type, damage, ws_name, pet_name)

    return damage
end

------------------------------------------------------------------------------------------------------
-- Set data for a skillchain action.
------------------------------------------------------------------------------------------------------
-- metadata    : contains all the information for the action
-- player_name : name of the player that did the action
-- target_name : name of the target that received the action
-- sc_name     : name of the skillchain
------------------------------------------------------------------------------------------------------
p.Handler.Skillchain = function(metadata, player_name, target_name, sc_name)
    local damage = metadata.add_effect_param
    Model.Update.Catalog_Damage(player_name, target_name, p.Trackable.SC, damage, sc_name)
    return damage
end

------------------------------------------------------------------------------------------------------
-- Parse the finish spell casting packet.
------------------------------------------------------------------------------------------------------
-- act         : action packet data
-- actor_mob   : the mob data of the entity performing the action
-- log_offense : boolean of if we should log the data; initial filtering happens in action packet
------------------------------------------------------------------------------------------------------
p.Action.Finish_Spell_Casting = function(action, actor_mob, log_offense)
    if not log_offense then return nil end

    local result, target, new_damage
    local damage = 0
    local spell_id = action.param
    local spell_data = A.Spell.ID(spell_id)
    if not spell_data then return nil end
	local spell_name = A.Spell.Name(spell_id, spell_data)

    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target = A.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if not target then target = {name = "test"} end

            new_damage = p.Handler.Spell(spell_data, result, actor_mob.name, target.name)
            if not new_damage then new_damage = 0 end

            damage = damage + new_damage
        end
    end

    local audits = {
        player_name = actor_mob.name,
        target_name = target.name,
    }

    -- Log the use of the spell
    Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, p.Trackable.MAGIC, spell_name, p.Metric.COUNT)

    if Lists.Spell.Damaging[spell_id] and not actor_mob.is_npc then
        Blog.Log.Add(actor_mob.name, spell_name, damage, nil, nil, 'spell', spell_data)
    end
end

------------------------------------------------------------------------------------------------------
-- Set data for a spell action (including healing).
-- Not all spells do damage and not all spells heal this will sort those out.
------------------------------------------------------------------------------------------------------
-- act         : the main packet; need it to get spell ID
-- metadata    : contains all the information for the action
-- player_name : name of the player that did the action
-- target_name : name of the target that received the action
------------------------------------------------------------------------------------------------------
p.Handler.Spell = function(spell_data, metadata, player_name, target_name)
    if not spell_data then return 0 end

    local spell_name = spell_data.Name[0]
    local spell_id = spell_data.Id
    local spell_mapped = false
    local damage = metadata.param or 0

    if Lists.Spell.Damaging[spell_id] then
        Model.Update.Catalog_Damage(player_name, target_name, p.Trackable.MAGIC, damage, spell_name)
        spell_mapped = true
    end

    -- TO DO: Handle Overcure
    if Lists.Spell.Healing[spell_id] then
    	Model.Update.Catalog_Damage(player_name, target_name, p.Trackable.HEALING, damage, spell_name)
        spell_mapped = true
    end

    if not spell_mapped then
        --Add_Message_To_Chat('W', 'Handle_Spell^handling', tostring(spell_name)..' is not included in Damage_Spells global.')
    end

    return damage
end

------------------------------------------------------------------------------------------------------
-- Parse the job ability casting packet.
------------------------------------------------------------------------------------------------------
-- act         : action packet data
-- actor_mob   : the mob data of the entity performing the action
-- log_offense : boolean of if we should log the data; initial filtering happens in action packet
------------------------------------------------------------------------------------------------------
p.Action.Job_Ability = function(act, actor_mob, log_offense)
    if not log_offense then return end

	-- Need to provide an offset to get to the abilities. Otherwise I get WS information.
	local ability_id = act.param + 512
    local ability_data = A.Ability.ID(ability_id)

    -- Handle missing abilities.
    if not ability_data then
        ability_data = {Id = ability_id, Name = "UNK Ability (" .. ability_id .. ")"}
    else
        ability_data = {Id = ability_id, Name = A.Ability.Name(ability_id, ability_data)}
    end

	-- A.Chat.Debug("Action.Job_Ability: " .. tostring(ability_data.Name) .. " " .. tostring(actor_mob.name))

    local result, target
    local damage = 0

    for target_index, target_value in pairs(act.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = act.targets[target_index].actions[action_index]
            target = A.Mob.Get_Mob_By_ID(act.targets[target_index].id)
            if not target then target = {name = 'test'} end
            damage = damage + p.Handler.Ability(ability_data, result, actor_mob, target.name)
        end
    end

    local audits = {
        player_name = actor_mob.name,
        target_name = target.name,
    }

    -- Log the use of the ability
    Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, p.Trackable.ABILITY, ability_data.Name, p.Metric.COUNT)

    -- Ignore abilities the player uses on themself that don't do any damage directly.
    if ability_data.Type == A.Ability.Enum.Type.BLOODPACTRAGE or
       ability_data.Type == A.Ability.Enum.Type.BLOODPACTWARD or
       ability_data.Type == A.Ability.Enum.Type.PETLOGISTICS then
        A.Chat.Debug("Handler.Ability ignore ability.")
        return damage
    end

    -- Battle log message gets handled in Handle_Ability if the damage is >0
    -- if Blog.Display.Flags.Ability and not actor_mob.is_npc and damage <= 0 then
    if Blog.Display.Flags.Ability and damage >= 0 then
        Blog.Log.Add(actor_mob.name, ability_data.Name, damage)
    end
end

------------------------------------------------------------------------------------------------------
-- Set data for an ability action.
-- This includes pet damage (since they are ability based).
-- Using an ability to cause a pet to attack gets captured here, but the actual data for the damage
-- done comes in a different packet. SMN comes in Pet_Ability and then routes back to here.
------------------------------------------------------------------------------------------------------
-- act         : the main packet; need it to get spell ID
-- metadata    : contains all the information for the action
-- actor_mob   : mob of the player that did the action
-- target_name : name of the target that received the action
-- owner_mob   : if the action was from a pet then this will hold the owner's mob
------------------------------------------------------------------------------------------------------
p.Handler.Ability = function(ability_data, metadata, actor_mob, target_name, owner_mob)
    local player_name = actor_mob.name
    local ability_id = ability_data.Id
    local ability_name = ability_data.Name
    local damage = metadata.param

    local ability_type = p.Trackable.ABILITY
    local pet_name
    if owner_mob then
        ability_type = p.Trackable.PET_ABILITY
        pet_name = owner_mob.name
    end

    local audits = {
        player_name = player_name,
        target_name = target_name,
        pet_name = pet_name,
    }

    if owner_mob then
        Model.Update.Data(p.Mode.INC, damage, audits, p.Trackable.PET, p.Metric.TOTAL)
        Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, ability_type, ability_name, p.Metric.COUNT)
    end

    -- TO DO: Need to get the ID for BloodPactRage
    if (Lists.Ability.Damaging[ability_id] or Lists.Ability.Avatar[ability_id] or ability_data.Type == A.Ability.Enum.Type.PETOFFENSE) and owner_mob then
        Model.Update.Catalog_Damage(player_name, target_name, ability_type, damage, ability_name, owner_mob.name)
        if damage > 0 then
            Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, ability_type, ability_name, p.Metric.HIT_COUNT)
            -- if not actor_mob.is_npc then
                Blog.Log.Add(player_name, ability_name, damage, nil, nil, ability_type, ability_data)
            -- end
        end
    end

    return damage
end

------------------------------------------------------------------------------------------------------
-- Parse the finish monster TP move packet.
-- Puppet ranged attacks fall into this too.
------------------------------------------------------------------------------------------------------
-- act         : action packet data
-- actor_mob   : the mob data of the entity performing the action
-- log_offense : boolean of if we should log the data; initial filtering happens in action packet
------------------------------------------------------------------------------------------------------
p.Action.Finish_Monster_TP_Move = function(act, actor_mob, log_offense)
    if not log_offense then return false end

    -- Check to see if the pet belongs to anyone in the party.
    local owner_mob = A.Mob.Pet_Owner(actor_mob)

    local result, target, ws_name, sc_id, sc_name
    local sc_damage  = 0
    local damage     = 0

    for target_index, target_value in pairs(act.targets) do
        for action_index, _ in pairs(target_value.actions) do

            result = act.targets[target_index].actions[action_index]
            target = A.Mob.Get_Mob_By_ID(act.targets[target_index].id)
            if not target then target = {name = 'test'} end

            -- Puppet ranged attack
            if act.param == 1949 then
                p.Handler.Ranged(result, actor_mob.name, target.name, owner_mob)
                ws_name = 'Pet Ranged'
                damage = result.param

            else
                local ws_data = Pet_Skill[act.param]
                ws_name = ws_data.en

                -- Check for skillchains
                sc_id = result.add_effect_message
                if sc_id > 0 then 
                    sc_name    = Lists.WS.Skillchains[sc_id]
                    sc_damage  = sc_damage + p.Handler.Skillchain(result, actor_mob.name, target.name, sc_name)
                end

                -- Need to calculate WS damage here to account for AOE weaponskills
                damage = damage + p.Handler.Weaponskill(result, actor_mob.name, target.name, ws_name, owner_mob)
            end

        end
    end

    if Blog.Display.Flags.Pet and owner_mob then
        Blog.Log.Add(actor_mob.name .. " (" .. owner_mob.name .. ")", ws_name, damage)
    end

    return true
end

------------------------------------------------------------------------------------------------------
-- Parse the pet ability packet.
-- SMN bloodpacts; DRG wyvern breaths
------------------------------------------------------------------------------------------------------
-- act         : action packet data
-- actor_mob   : the mob data of the entity performing the action; If SMN this will be your avatar
-- log_offense : boolean of if we should log the data; initial filtering happens in action packet
------------------------------------------------------------------------------------------------------
p.Action.Pet_Ability = function(act, actor_mob, log_offense)
    if not log_offense then return false end

    -- Check to see if the pet belongs to anyone in the party.
    local owner_mob = A.Mob.Pet_Owner(actor_mob)
    if not owner_mob then return false end

    local ability_id = act.param
    local ability_data
    local avatar = false

    -- Handle offset for Blood Pacts
    if ability_id >= 831 and ability_id <= 838 then
        ability_data = Lists.Ability.Avatar[ability_id]
        avatar = true
    else
        ability_data = A.Ability.ID(ability_id)
    end

    if not ability_data then
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

    for target_index, target_value in pairs(act.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = act.targets[target_index].actions[action_index]
            target = A.Mob.Get_Mob_By_ID(act.targets[target_index].id)
            if not target then target = {name = 'test'} end
            damage = damage + p.Handler.Ability(ability_data, result, owner_mob, target.name, actor_mob)
        end
    end

    local audits = {
        player_name = owner_mob.name,
        target_name = target.name,
    }

    if damage > 0 then
        Model.Update.Data(p.Mode.INC, 1, audits, p.Trackable.ABILITY, p.Metric.HIT_COUNT)
        if Blog.Display.Flags.Pet then Blog.Log.Add(actor_mob.name, ability_data.Name, damage) end
    end

    return true
end

------------------------------------------------------------------------------------------------------
-- Parse the player death message.
------------------------------------------------------------------------------------------------------
-- actor_id  : mob id of the entity performing the action
-- target_id : mob id of the entity receiving the action (this is the person dying)
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

    if Blog.Display.Flags.Deaths then Blog.Log.Add(actor.name, 'Death', 0) end
end

-- ------------------------------------------------------------------------------------------------------
-- Wintersolstice converted the the action packet 0x0028 to the Windower version.
-- This is basically copy and pasted from Wintersolstice's parse lua.
-- Ashita  : https://github.com/atom0s/XiPackets/tree/main/world/server/0x0028
-- Windower: https://github.com/Windower/Lua/wiki/Action-Event
-- Parse   : https://github.com/WinterSolstice8/parse
-- ------------------------------------------------------------------------------------------------------
p.Packets.Build_Action = function (data)
	local parsed_packet = parser.parse(data)
	local act = {}

	-- Junk packet from server. Ignore it.
	if parsed_packet.trg_sum == 0 then
		return nil
	end

	act.actor_id     = parsed_packet.m_uID
	act.category     = parsed_packet.cmd_no
	act.param        = parsed_packet.cmd_arg
	act.target_count = parsed_packet.trg_sum
	act.unknown      = 0
	act.recast       = parsed_packet.info
	act.targets      = {}

	for _, v in ipairs (parsed_packet.target) do
		local target = {}

		target.id           = v.m_uID
		target.action_count = v.result_sum
		target.actions      = {}
		for _, action in ipairs (v.result) do
			local new_action = {}

			new_action.reaction  = action.miss -- These values are different compared to windower, so the code outside of this function was adjusted.
			new_action.animation = action.sub_kind
			new_action.effect    = action.info
			new_action.stagger   = action.scale
			new_action.param     = action.value
			new_action.message   = action.message
			new_action.unknown   = action.bit

			if action.has_proc then
				new_action.has_add_effect       = true
				new_action.add_effect_animation = action.proc_kind
				new_action.add_effect_effect    = action.proc_info
				new_action.add_effect_param     = action.proc_value
				new_action.add_effect_message   = action.proc_message
			else
				new_action.has_add_effect       = false
				new_action.add_effect_animation = 0
				new_action.add_effect_effect    = 0
				new_action.add_effect_param     = 0
				new_action.add_effect_message   = 0
			end

			if action.has_react then
				new_action.has_spike_effect       = true
				new_action.spike_effect_animation = action.react_kind
				new_action.spike_effect_effect    = action.react_info
				new_action.spike_effect_param     = action.react_value
				new_action.spike_effect_message   = action.react_message
			else 
				new_action.has_spike_effect       = false
				new_action.spike_effect_animation = 0
				new_action.spike_effect_effect    = 0
				new_action.spike_effect_param     = 0
				new_action.spike_effect_message   = 0
			end

			table.insert(target.actions, new_action)
		end

		table.insert(act.targets, target)
	end

	return act
end

return p