local parser = require('packets._parser') -- from atom0s

local p = {}

p.Action = {}
p.Handler = {}
p.Packets = {}

-- ------------------------------------------------------------------------------------------------------
-- Parse the melee attack packet.
-- ------------------------------------------------------------------------------------------------------
-- act         : action packet data
-- actor_mob   : the mob data of the entity performing the action
-- log_offense : boolean of if we should log the data; initial filtering happens in action packet
-- ------------------------------------------------------------------------------------------------------
p.Action.Melee = function(act, actor_mob, owner_mob, log_offense)
	if not log_offense then return end	-- Will need to adjust this when implementing defense metrics.

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
		-- if Log_CSV then
		-- 	local data = {
		-- 		["Actor Name"] = actor_mob.name,
		-- 		["Action Name"] = "Melee",
		-- 		["Melee"] = damage
		-- 	}
		-- 	Add_CSV_Entry(data)
		-- end
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

    local e_broad_melee_type = Model.Enum.Trackable.MELEE
    local e_discrete_melee_type = Get_Discrete_Melee_Type(animation_id)

    -- Need special handling for pets
    if owner_mob then
        e_broad_melee_type = Model.Enum.Trackable.PET_MELEE
        e_discrete_melee_type = Model.Enum.Trackable.PET_MELEE_DISCRETE
        player_name = owner_mob.name
    end

    local audits = {
        player_name = player_name,
        target_name = target_name,
    }

    local e_inc = Model.Enum.Mode.INC
    local e_set = Model.Enum.Mode.SET

    -- Totals ///////////////////////////////////////////////////////
    Model.Update.Data('inc', damage, audits, 'total', 'total')
    Model.Update.Data('inc', damage, audits, 'total_no_sc', 'total')
    Model.Update.Data('inc', damage, audits, e_discrete_melee_type, 'total')
    Model.Update.Data('inc',      1, audits, e_discrete_melee_type, 'count')

    if owner_mob then
        Model.Update.Data('inc', damage, audits, 'pet', 'total')
    end

    -- Melee ////////////////////////////////////////////////////////
    if animation_id >= 0 and animation_id < 4 then
        Model.Update.Data('inc', damage, audits, e_broad_melee_type, 'total')
        Model.Update.Data('inc',      1, audits, e_broad_melee_type, 'count')

    -- Throwing /////////////////////////////////////////////////////
    elseif animation_id == 4 then
        throwing = true
        Model.Update.Data('inc', damage, audits, 'ranged', 'total')
        Model.Update.Data('inc',      1, audits, 'ranged', 'count')

    -- Unhandled Animation //////////////////////////////////////////
    else
        Add_Message_To_Chat('W', 'Melee_Damage^handling', 'Unhandled animation: '..tostring(animation_id))
    end

    -- Min/Max //////////////////////////////////////////////////////
    if throwing then
        if damage > 0 and (damage < Model.Get.Data(player_name, 'ranged', 'min')) then Model.Update.Data('set', damage, audits, 'ranged', 'min') end
        if damage > Model.Get.Data(player_name, 'ranged', 'max') then Model.Update.Data('set', damage, audits, 'ranged', 'max') end
    else
        if damage > 0 and (damage < Model.Get.Data(player_name, e_broad_melee_type, 'min')) then Model.Update.Data('set', damage, audits, e_broad_melee_type, 'min') end
        if damage > Model.Get.Data(player_name, e_broad_melee_type, 'max') then Model.Update.Data('set', damage, audits, e_broad_melee_type, 'max') end
    end

    -- Enspell //////////////////////////////////////////////////////
    local enspell_damage = metadata.add_effect_param
    if enspell_damage > 0 then
        -- Element of the enspell is in add_effect_animation
        Model.Update.Data('inc', enspell_damage, audits, 'magic',   'total')
        Model.Update.Data('inc', enspell_damage, audits, 'enspell', 'total')
        Model.Update.Data('inc',              1, audits, 'magic', 'count')
        if enspell_damage < Model.Get.Data(player_name, 'magic', 'min') then Model.Update.Data('set', enspell_damage, audits, 'magic', 'min') end
        if enspell_damage > Model.Get.Data(player_name, 'magic', 'max') then Model.Update.Data('set', enspell_damage, audits, 'magic', 'max') end
    end

    -- Metadata /////////////////////////////////////////////////////
    local message_id = metadata.message

    -- Hit
    if message_id == 1 then
        Model.Update.Data('inc',      1, audits, e_broad_melee_type,    'hits')
        Model.Update.Data('inc',      1, audits, e_discrete_melee_type, 'hits')
        Model.Update.Running_Accuracy(player_name, true)

    -- Healing with melee attacks
    elseif message_id == 3 or message_id == 373 then
        Model.Update.Data('inc',      1, audits, e_broad_melee_type,    'hits')
        Model.Update.Data('inc',      1, audits, e_discrete_melee_type, 'hits')
        Model.Update.Data('inc', damage, audits, e_broad_melee_type,    'mob heal')

    -- Misses
    elseif message_id == 15 then
        Model.Update.Data('inc',      1, audits, e_broad_melee_type, 'misses')
        Model.Update.Running_Accuracy(player_name, false)

    -- DRK vs. Omen Gorger
    elseif message_id == 30 then
        Add_Message_To_Chat('A', 'Melee_Damage^handling', 'Attack Nuance 30 -- DRK vs. Omen Gorger')

    -- Attack absorbed by shadows
    elseif message_id == 31 then
        Model.Update.Data('inc',      1, audits, e_broad_melee_type,    'hits')
        Model.Update.Data('inc',      1, audits, e_discrete_melee_type, 'hits')
        Model.Update.Data('inc',      1, audits, e_broad_melee_type,    'shadows')

    -- Attack dodged (Perfect Dodge) / Remove the count so perfect dodge doesn't count.
    elseif message_id == 32 then
        Model.Update.Data('inc',     -1, audits, e_broad_melee_type,    'count')
        Model.Update.Data('inc',     -1, audits, e_discrete_melee_type, 'count')

    -- Critical Hits
    elseif message_id == 67 then
        Model.Update.Data('inc',      1, audits, e_broad_melee_type,    'hits')
        Model.Update.Data('inc',      1, audits, e_discrete_melee_type, 'hits')
        Model.Update.Data('inc',      1, audits, e_broad_melee_type,    'crits')
        Model.Update.Data('inc', damage, audits, e_broad_melee_type,    'crit damage')
        Model.Update.Running_Accuracy(player_name, true)

    -- Throwing Critical Hit
    elseif message_id == 353 then
        Model.Update.Data('inc',      1, audits, 'ranged', 'hits')
        Model.Update.Data('inc',      1, audits, 'ranged', 'crits')
        Model.Update.Data('inc', damage, audits, 'ranged', 'crit damage')
        Model.Update.Running_Accuracy(player_name, true)

    -- Throwing Miss
    elseif message_id == 354 then
        Model.Update.Data('inc',      1, audits, 'ranged', 'misses')
        Model.Update.Running_Accuracy(player_name, false)

    -- Throwing Square Hit
    elseif message_id == 576 then
        Model.Update.Data('inc',      1, audits, 'ranged', 'hits')
        Model.Update.Running_Accuracy(player_name, true)

    -- Throwing Truestrike
    elseif message_id == 577 then
        Model.Update.Data('inc',      1, audits, 'ranged', 'hits')
        Model.Update.Running_Accuracy(player_name, true)

    else
        Blog.Log.Add(player_name, 'Att. nuance '..message_id) end

    local spikes = metadata.spike_effect_effect

    return damage
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
                A.Chat.Message("Handler - Ranged Attack")
                damage = damage + p.Handler.Ranged(result, actor_mob.name, target.name)
            end
        end
    end

    -- if not actor_mob.is_npc then
        if Log_CSV then
            local data = {
                ["Actor Name"] = actor_mob.name,
                ["Action Name"] = "Ranged",
                ["Ranged"] = damage
            }
            Add_CSV_Entry(data)
        end
        if Blog.Display.Flags.Ranged then
            Blog.Log.Add(actor_mob.name, 'Ranged', damage)
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
        ranged_type = 'pet_ranged'
        player_name = owner_mob.name
    else
        ranged_type = 'ranged'
    end

    local audits = {
        player_name = player_name,
        target_name = target_name,
    }

    -- Totals ///////////////////////////////////////////////////////
    Model.Update.Data('inc', damage, audits, 'total',  'total')
    Model.Update.Data('inc', damage, audits, 'total_no_sc', 'total')
    Model.Update.Data('inc',      1, audits, ranged_type, 'count')

    if owner_mob then
        Model.Update.Data('inc', damage, audits, 'pet', 'total')
    end

    -- Miss /////////////////////////////////////////////////////////
    if message_id == 354 then
    	Model.Update.Data('inc',      1, audits, ranged_type, 'misses')
        Model.Update.Running_Accuracy(player_name, false)
    	return damage

    -- Shadows //////////////////////////////////////////////////////
    elseif message_id == 31 then
        Model.Update.Data('inc',      1, audits, ranged_type, 'hits')
        Model.Update.Data('inc',      1, audits, ranged_type, 'shadows')
        return damage

    -- Puppet ///////////////////////////////////////////////////////
    elseif message_id == 185 then
        Model.Update.Data('inc',      1, audits, ranged_type, 'hits')
        Model.Update.Data('inc', damage, audits, ranged_type, 'total')
        Model.Update.Running_Accuracy(player_name, true)

    -- Regular Hit //////////////////////////////////////////////////
    elseif message_id == 352 then
        Model.Update.Data('inc',      1, audits, ranged_type, 'hits')
        Model.Update.Data('inc', damage, audits, ranged_type, 'total')
        Model.Update.Running_Accuracy(player_name, true)

    -- Square Hit ///////////////////////////////////////////////////
    elseif message_id == 576 then
        Model.Update.Data('inc',      1, audits, ranged_type, 'hits')
        Model.Update.Data('inc', damage, audits, ranged_type, 'total')
        Model.Update.Running_Accuracy(player_name, true)

    -- Truestrike ///////////////////////////////////////////////////
    elseif message_id == 577 then
        Model.Update.Data('inc',      1, audits, ranged_type, 'hits')
        Model.Update.Data('inc', damage, audits, ranged_type, 'total')
        Model.Update.Running_Accuracy(player_name, true)

    -- Crit /////////////////////////////////////////////////////////
    elseif message_id == 353 then
        A.Chat.Message("Handling - Crit Ranged Attack")
        Model.Update.Data('inc',      1, audits, ranged_type, 'hits')
        Model.Update.Data('inc',      1, audits, ranged_type, 'crits')
        Model.Update.Data('inc', damage, audits, ranged_type, 'crit damage')
        Model.Update.Data('inc', damage, audits, ranged_type, 'total')
        Model.Update.Running_Accuracy(player_name, true)

    else
        Blog.Log.Add(player_name, 'Ranged nuance '..tostring(message_id)) end

    if damage == 0 then
        Add_Message_To_Chat('W', 'Handle_Ranged^handling', 'Ranged damage was 0.')
    end

    if damage > 0 and (damage < Model.Get.Data(player_name, ranged_type, 'min')) then Model.Update.Data('set', damage, audits, ranged_type, 'min') end
    if damage > Model.Get.Data(player_name, ranged_type, 'max') then Model.Update.Data('set', damage, audits, ranged_type, 'max') end

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

    Model.Update.Data('inc', 1, audits, 'ws', 'count')
    Model.Update.Catalog_Metric('inc', 1, audits, 'ws', ws_name, 'count')

    if damage > 0 then
        Model.Update.Data('inc', 1, audits, 'ws', 'hits')
        Model.Update.Catalog_Metric('inc', 1, audits, 'ws', ws_name, 'hits')
    end

    -- Update the battle log
    -- if not actor_mob.is_npc then
        if Log_CSV then
            local data = {
                ["Actor Name"] = actor_mob.name,
                ["Action Name"] = ws_data.name,
                ["WS"] = damage
            }
            Add_CSV_Entry(data)

            data = {
                ["Actor Name"] = actor_mob.name,
                ["Action Name"] = sc_name,
                ["SC"] = sc_damage
            }
        end
        if Blog.Display.Flags.WS then
            Blog.Log.Add(actor_mob.name, ws_name, damage, nil, A.Party.Refresh(actor_mob.name, 'tp'), 'ws', ws_data)
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

    local ws_type = 'ws'
    if owner_mob then
        player_name = owner_mob.name
        ws_type = 'pet_ws'
    end

    local audits = {
        player_name = player_name,
        target_name = target_name,
    }

    if owner_mob then
        Model.Update.Data('inc', damage, audits, 'pet', 'total')
    end

    Model.Update.Catalog_Damage(player_name, target_name, ws_type, damage, ws_name)

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
    Model.Update.Catalog_Damage(player_name, target_name, 'sc', damage, sc_name)
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
    Model.Update.Catalog_Metric('inc', 1, audits, 'magic', spell_name, 'count')

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
        Model.Update.Catalog_Damage(player_name, target_name, 'magic', damage, spell_name)
        spell_mapped = true
    end

    -- TO DO: Handle Overcure
    if Lists.Spell.Healing[spell_id] then
    	Model.Update.Catalog_Damage(player_name, target_name, 'healing', damage, spell_name)
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
    if not ability_data then return nil end
	local ability_name = A.Ability.Name(ability_id, ability_data)
	A.Chat.Message(tostring(ability_name))

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
    Model.Update.Catalog_Metric('inc', 1, audits, 'ability', ability_name, 'count')

    -- Battle log message gets handled in Handle_Ability if the damage is >0
    -- if Blog.Display.Flags.Ability and not actor_mob.is_npc and damage <= 0 then
    if Blog.Display.Flags.Ability and damage >= 0 then
        Blog.Log.Add(actor_mob.name, ability_name, damage)
    end
end

------------------------------------------------------------------------------------------------------
-- Set data for an ability action.
-- This includes pet damage (since they are ability based).
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
    local ability_name = A.Ability.Name(ability_id, ability_data)
    local damage = metadata.param

    local ability_type = "ability"
    if owner_mob then
        ability_type = "pet_ability"
    end

    local audits = {
        player_name = player_name,
        target_name = target_name,
    }

    if owner_mob then
        Model.Update.Data("inc", damage, audits, "pet", "total")
    end

    -- TO DO: Need to get the ID for BloodPactRage
    if Lists.Ability.Damaging[ability_id] or (ability_data.Type == "BloodPactRage") then
        if damage > 0 then
            Model.Update.Catalog_Damage(player_name, target_name, ability_type, damage, ability_name)

            if not actor_mob.is_npc then
                Blog.Log.Add(player_name, ability_name, damage, nil, nil, ability_type, ability_data)
            end
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
    if not log_offense then return end

    -- Check to see if the pet belongs to anyone in the party.
    local owner_mob = A.Mob.Pet_Owner(act)

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
                local ws_data = Res.monster_abilities[act.param]
                ws_name = ws_data.name

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

    if Log_Pet and owner_mob then
        Blog.Log.Add(actor_mob.name, ws_name, damage)
    end
end

------------------------------------------------------------------------------------------------------
-- Parse the pet ability packet.
-- SMN bloodpacts; DRG wyvern breaths
------------------------------------------------------------------------------------------------------
-- act         : action packet data
-- actor_mob   : the mob data of the entity performing the action
-- log_offense : boolean of if we should log the data; initial filtering happens in action packet
------------------------------------------------------------------------------------------------------
p.Action.Pet_Ability = function(act, actor_mob, log_offense)
    if not log_offense then return end

    -- Check to see if the pet belongs to anyone in the party.
    local owner_mob = A.Mob.Pet_Owner(act)

    local ability_name = A.Ability.Name(act.param)
    if not ability_name then
        Add_Message_To_Chat('E', 'Pet_Ability^packet_handling', 'Ability name not found.')
        return false
    end

    local result, target
    local damage = 0

    for target_index, target_value in pairs(act.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = act.targets[target_index].actions[action_index]
            target = windower.ffxi.get_mob_by_id(act.targets[target_index].id)
            if not target then target = {name = 'test'} end
            damage = damage + p.Handler.Ability(act, result, owner_mob, target.name, owner_mob)
        end
    end

    local audits = {
        player_name = owner_mob.name,
        target_name = target.name,
    }

    if damage > 0 then
        Model.Update.Data('inc', 1, audits, 'ability', 'hits')

        if Log_Pet then
            Blog.Log.Add(actor_mob.name, ability_name, damage)
        end
    end
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