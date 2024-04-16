local parser = require('packets._parser') -- from atom0s
Chat = require("chat")

local a = {}

a.Data = {}
a.Chat = {}
a.Party = {}
a.Party.List = {}   -- Maintains who is currently in the party.
a.Party.Need_Refresh = true
a.Packets = {}
a.Spell = {}
a.WS = {}
a.Item = {}
a.Util = {}

a.Mob = {}
a.Ability = {}
a.States = {
    Zoning = false,
}

a.Enum = {}
a.Enum.Mob = {
    NAME     = "Name",
    TP       = "TP",
    ISZONING = "IsZoning",
    ME       = "me",
    TARGET   = "t",
    PET      = "pet",
    PLAYERTYPE = 0, -- Type
    PETTYPE    = 2, -- Type
}
a.Enum.Spawn_Flags = {
    MAINPLAYER = 525,
    OTHERPLAYER = 13,
    NPC = 2,
}
a.Enum.Ability = {
    NORMAL        = 1,  -- Type: Normal Ability
    PETLOGISTICS  = 2,  -- Type: Fight, Heel, Stay, etc.
    BLOODPACTRAGE = 6,  -- Type: 
    BLOODPACTWARD = 10, -- Type: 
    PETABILITY    = 18, -- Type: Offensive BST/SMN ability.
}
a.Enum.Animation = {
    MELEE_MAIN    = 0,
    MELEE_OFFHAND = 1,
    MELEE_KICK    = 2,
    MELEE_KICK2   = 3,
    THROWING      = 4,
}
a.Enum.Message = {
    HIT        = 1,
    MOBHEAL3   = 3,
    MOBHEAL373 = 373,
    MISS       = 15,
    SHADOWS    = 31,
    DODGE      = 32,
    CRIT       = 67,
    RANGEPUP   = 185,
    RANGEHIT   = 352,
    RANGECRIT  = 353,
    RANGEMISS  = 354,
    SQUARE     = 576,
    TRUE       = 577,
}

-- ------------------------------------------------------------------------------------------------------
-- https://github.com/AshitaXI/Ashita-v4beta/blob/main/plugins/sdk/Ashita.h
-- Memory Manager Functions
-- IAutoFollow* GetAutoFollow(void)
-- ICastBar* GetCastBar(void)
-- IEntity* GetEntity(void)
-- IInventory* GetInventory(void)
-- IParty* GetParty(void)
-- IPlayer* GetPlayer(void)
-- IRecast* GetRecast(void)
-- ITarget* GetTarget(void)
-- ------------------------------------------------------------------------------------------------------
-- TO DO
-- 1. Finish the pet portion in a.Mob.Get_Mob_By_Target
-- ------------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------------
-- Get player data. If an attribute is provided then just get that attribute as long as it is handled.
-- ------------------------------------------------------------------------------------------------------
---@param attribute string the specific attribute to be returned.
---@return any
-- ------------------------------------------------------------------------------------------------------
a.Data.Player = function(attribute)
    local player = AshitaCore:GetMemoryManager():GetPlayer()
    if attribute == a.Enum.Mob.ISZONING then
        return player:GetIsZoning()
    end
    return player
end

-- ------------------------------------------------------------------------------------------------------
-- Get player entity data.
-- I can't figure out where this function is defined, but it works. ¯\_(ツ)_/¯
-- ------------------------------------------------------------------------------------------------------
a.Data.Player_Entity = function()
    return GetPlayerEntity()
end

-- ------------------------------------------------------------------------------------------------------
-- Get player's target index.
-- I grabbed and adjusted this snippet from HXUI and mobdb.
-- https://github.com/tirem/HXUI
-- https://github.com/ThornyFFXI/mobdb
-- ------------------------------------------------------------------------------------------------------
a.Data.Target_Index = function()
    local memory_manager = AshitaCore:GetMemoryManager()
    local target_manager = memory_manager:GetTarget()
    return target_manager:GetTargetIndex(target_manager:GetIsSubTargetActive())
end

-- ------------------------------------------------------------------------------------------------------
-- Get party data. I'm trying to mimic the windower.ffxi.get_party() function.
-- Windower: https://github.com/Windower/Lua/wiki/FFXI-Functions
-- ------------------------------------------------------------------------------------------------------
a.Data.Party = function()
    local data = AshitaCore:GetMemoryManager():GetParty()
    if not data then return {} end

    local party = {}
    local parties = {}
    local alliance_count = 0

    for slot = 0, 17 do
        -- Group the 18 members up into 3 parties.
        local party_number = math.ceil((slot + 1) / 6)
        if not parties[party_number] then parties[party_number] = {} end

        -- The party slot is occupied.
        if data:GetMemberIsActive(slot) == 1 then
            alliance_count = alliance_count + 1

            if not parties[party_number].count then
                parties[party_number].count = 1
            else
                parties[party_number].count = parties[party_number].count + 1
            end

            party[slot] = {}
            party[slot].name  = data:GetMemberName(slot)
            party[slot].index = data:GetMemberTargetIndex(slot)
            party[slot].id    = data:GetMemberServerId(slot)
            party[slot].job   = data:GetMemberMainJob(slot)
            party[slot].hp    = data:GetMemberHP(slot)
            party[slot].hpp   = data:GetMemberHPPercent(slot)
            party[slot].mp    = data:GetMemberMP(slot)
            party[slot].mpp   = data:GetMemberMPPercent(slot)
            party[slot].tp    = data:GetMemberTP(slot)
            party[slot].zone  = data:GetMemberZone(slot)
            party[slot].flags = data:GetMemberFlagMask(slot)
            party[slot].mob   = a.Mob.Get_Mob_By_Index(party[slot].index)

            if party[slot].flags == 4 then
                parties[party_number].leader = party[slot].index
            end

        -- The party slot is not occupied.
        else
            if not parties[party_number].leader then
                parties[party_number].leader = nil
            end

		end
    end

    party.party1_leader = parties[1].leader
    party.party2_leader = parties[2].leader
    party.party3_leader = parties[3].leader
    party.party1_count  = parties[1].count or 0
    party.party2_count  = parties[2].count or 0
    party.party3_count  = parties[3].count or 0
    --alliance_leader
    party.alliance_count = alliance_count

    return party
end

-- ------------------------------------------------------------------------------------------------------
-- Refreshes the party list.
-- This is a lighter version than Party() for just caching who is in the party.
-- It avoids stack overflow by not computing mob structure.
-- ------------------------------------------------------------------------------------------------------
---@param player_name? string
---@param node? string
---@return nil|number
-- ------------------------------------------------------------------------------------------------------
a.Party.Refresh = function(player_name, node)
    if not a.Party.Need_Refresh and not player_name then return nil end

    local data = AshitaCore:GetMemoryManager():GetParty()
    if not data then return nil end

    a.Party.List = {}
    local return_data = nil

    for slot = 0, 17 do
        -- Group the 18 members up into 3 parties.
        local party_number = math.ceil((slot + 1) / 6)
        if data:GetMemberIsActive(slot) == 1 then
            a.Party.List[data:GetMemberName(slot)] = party_number

            -- Might as well grab some data while looping through.
            if player_name then
                local member_name = data:GetMemberName(slot)
                if member_name == player_name then
                    if node then
                        if node == a.Enum.Mob.TP then
                            return_data = data:GetMemberTP(slot)
                        end
                    else
                        return_data = 1
                    end
                end
            end
        end
    end

    a.Party.Need_Refresh = false
    return return_data
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if a mob index is in the party or alliance.
-- ------------------------------------------------------------------------------------------------------
---@param player_name string
---@return boolean
-- ------------------------------------------------------------------------------------------------------
a.Party.Is_Affiliate = function(player_name)
    local party_number = a.Party.List[player_name]
    if not party_number then return false end
    return a.Party.In_Party(player_name) or a.Party.In_Alliance(player_name)
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if a mob is in the party.
-- ------------------------------------------------------------------------------------------------------
---@param player_name string
---@return boolean
-- ------------------------------------------------------------------------------------------------------
a.Party.In_Party = function(player_name)
    local party_number = a.Party.List[player_name]
    if not party_number then return false end
    return party_number == 1
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if a mob is in the alliance.
-- ------------------------------------------------------------------------------------------------------
---@param player_name string
---@return boolean
-- ------------------------------------------------------------------------------------------------------
a.Party.In_Alliance = function(player_name)
    local party_number = a.Party.List[player_name]
    if not party_number then return false end
    return party_number == 2 or party_number == 3
end

-- ------------------------------------------------------------------------------------------------------
-- Since I removed the p0, a10, a20 indicies from party, this function helps party loops find
-- their starting slot index.
-- ------------------------------------------------------------------------------------------------------
---@param party_number number party 1, 2, or 3.
---@return integer starting slot for that particular party.
-- ------------------------------------------------------------------------------------------------------
a.Party.Start_Slot = function(party_number)
    if party_number == 1 then
        return 0
    elseif party_number == 2 then
        return 6
    elseif party_number == 3 then
        return 12
    else
        return 1
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Get an index from a mob ID. I got this from WinterSolstice8's parse lua.
-- Parse: https://github.com/WinterSolstice8/parse
-- ------------------------------------------------------------------------------------------------------
---@param id number
---@return number
-- ------------------------------------------------------------------------------------------------------
a.Data.Index_By_ID = function(id)
    local index = bit.band(id, 0x7FF)
    local entity_manager = AshitaCore:GetMemoryManager():GetEntity()

    if entity_manager:GetServerId(index) == id then
        return index
    end

    for i = 1, 2303 do
        if entity_manager:GetServerId(i) == id then
            return i
        end
    end

    return 0
end

-- ------------------------------------------------------------------------------------------------------
-- Get mob data. Trying to make this behave like get_mob_by_id() in windower.
-- ------------------------------------------------------------------------------------------------------
---@param id number
---@return table
-- ------------------------------------------------------------------------------------------------------
a.Mob.Get_Mob_By_ID = function(id)
    return a.Mob.Data(id, true)
end

-- ------------------------------------------------------------------------------------------------------
-- Get mob data. Trying to make this behave like get_mob_by_index() in windower.
-- ------------------------------------------------------------------------------------------------------
---@param index number this is different than ID.
---@return table
-- ------------------------------------------------------------------------------------------------------
a.Mob.Get_Mob_By_Index = function(index)
    return a.Mob.Data(index)
end

-- ------------------------------------------------------------------------------------------------------
-- Get mob data. Trying to make this behave like get_mob_by_id() in windower.
-- Ashita  : https://github.com/AshitaXI/Ashita-v4beta/blob/main/plugins/sdk/Ashita.h
-- Windower: https://github.com/Windower/Lua/wiki/FFXI-Functions
-- HXUI    : https://github.com/tirem/HXUI
-- Zone might only come from the party packet.
-- ------------------------------------------------------------------------------------------------------
---@param id number this can be an ID or an index. If it's an ID then set the convert_id flag.
---@param convert_id? boolean if an ID is supplied then the it will be need to be converted to an index.
---@return table
-- ------------------------------------------------------------------------------------------------------
a.Mob.Data = function(id, convert_id)
    local index = id
    if convert_id then
        index = a.Data.Index_By_ID(id)
    end

	local entity_manager = AshitaCore:GetMemoryManager():GetEntity()
    local entity = {}

    entity.name = entity_manager:GetName(index)
    entity.id = string.sub(string.format("0x%X", entity_manager:GetServerId(index)), -3) -- This came from HXUI
    entity.index = index    -- Primary identifier.
    entity.entity_type = entity_manager:GetType(index)
    entity.status = entity_manager:GetStatus(index)             -- Idle [0], Engaged [1], Healing [33]
    entity.distance = entity_manager:GetDistance(index)         -- This distance is NOT in yalms.
    entity.hpp = entity_manager:GetHPPercent(index)
    entity.x = entity_manager:GetLocalPositionX(index)
    entity.y = entity_manager:GetLocalPositionY(index)
    entity.z = entity_manager:GetLocalPositionZ(index)
    entity.target_index = entity_manager:GetTargetIndex(index)  -- Should be same as index.
    entity.pet_index = entity_manager:GetPetTargetIndex(index)  -- The index of the entity's pet. This should be blank for the pet.
    entity.claim_id = entity_manager:GetClaimStatus(index)      -- The server ID of the entity who has claim.
    entity.spawn_flags = entity_manager:GetSpawnFlags(index)    -- Player [525], Avatar/Jug Pet [258], Mob [16], Trust [4366]

    return entity
end

-- ------------------------------------------------------------------------------------------------------
-- Checks to see if a given string matches your character's name.
-- ------------------------------------------------------------------------------------------------------
---@param player_name string
---@return boolean
-- ------------------------------------------------------------------------------------------------------
a.Mob.Is_Me = function(player_name)
    local player = a.Mob.Get_Mob_By_Target(a.Enum.Mob.ME)
    if not player then return false end
    return player_name == player.name
end

-- ------------------------------------------------------------------------------------------------------
-- Get mob data. Trying to make this behave like get_mob_by_target() in windower.
-- Ashita  : https://github.com/AshitaXI/Ashita-v4beta/blob/main/plugins/sdk/Ashita.h
-- Windower: https://github.com/Windower/Lua/wiki/FFXI-Functions
-- ------------------------------------------------------------------------------------------------------
---@param target string Things you put in <> in game--me, t, pet, etc.
---@return table
-- ------------------------------------------------------------------------------------------------------
a.Mob.Get_Mob_By_Target = function(target)
    local player = a.Data.Player_Entity()
    if not player then return {} end
    local player_id = player.ServerId
    local player_entity = a.Mob.Get_Mob_By_ID(player_id)

    if target == a.Enum.Mob.ME then
        return player_entity
    elseif target == a.Enum.Mob.TARGET then
        local target_index = a.Data.Target_Index()
        if target_index then
            return a.Mob.Get_Mob_By_Index(target_index)
        end
    elseif target == a.Enum.Mob.PET then
        -- local pet_index = player_entity.pet_index
        -- local pet_id = pet_entity.ServerId
        -- return a.Data.Mob_By_ID(pet_id)
    end

    return {}
end

-- ------------------------------------------------------------------------------------------------------
-- Check to see if the pet belongs to anyone in the party.
-- Influenced by Flippant parse
-- ------------------------------------------------------------------------------------------------------
---@param pet_data table the pet's mob table; needs to have an index.
---@return table
-- ------------------------------------------------------------------------------------------------------
a.Mob.Pet_Owner = function(pet_data)
    local party = A.Data.Party()
    local owner
    for _, member in pairs(party) do
        if type(member) == 'table' and member.mob then
            -- May not always have a pet when running unit tests so need to short circuit here.
            if _Debug.Enabled and _Debug.Unit.Active then
                return _Debug.Unit.Mob.PLAYER
            elseif member.mob.pet_index == pet_data.index then
                owner = member.mob
            end
        end
    end
    return owner
end

-- ------------------------------------------------------------------------------------------------------
-- Get ability data.
-- https://wiki.ashitaxi.com/doku.php?id=addons:adk:iresourcemanager
-- Type 1  = Special Ability (2-hour), Third Eye,
-- Type 6  = SMN using BloodPactRage
-- Type 10 = BloodPactWard
-- Type 18 = BloodPactRage
-- Offsets
-- WS have zero offset.
-- Abilities have 512 offset.
-- ------------------------------------------------------------------------------------------------------
---@param id number
---@return table
-- ------------------------------------------------------------------------------------------------------
a.Ability.ID = function(id)
    return AshitaCore:GetResourceManager():GetAbilityById(id)
end

-- ------------------------------------------------------------------------------------------------------
-- Get the name of an ability.
-- If we already have the ability data then we don't need to get it again.
-- ------------------------------------------------------------------------------------------------------
---@param id number ability ID.
---@param data? table ability table if we already have it. 
---@return string
-- ------------------------------------------------------------------------------------------------------
a.Ability.Name = function(id, data)
    local ability = data
    if not ability then
        ability = a.Ability.ID(id)
    end
    if not ability then return "Error" end
    return ability.Name[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Get the current recast time for an ability by the abilities ID.
-- ------------------------------------------------------------------------------------------------------
---@param id number ability ID.
---@return number
-- ------------------------------------------------------------------------------------------------------
a.Ability.Recast_ID = function(id)
    local ability_id
    local recast = 0
    local found = false
    for i = 0, 31 do
        if not found then
            ability_id = AshitaCore:GetMemoryManager():GetRecast():GetAbilityTimerId(i)
            if ability_id == id then
                recast = math.floor(AshitaCore:GetMemoryManager():GetRecast():GetAbilityTimer(i) / 60)
                found = true
            end
        end
    end
    return recast
end

-- ------------------------------------------------------------------------------------------------------
-- Get spell data.
-- https://wiki.ashitaxi.com/doku.php?id=addons:adk:iresourcemanager
-- ------------------------------------------------------------------------------------------------------
---@param id number spell ID.
---@return table
-- ------------------------------------------------------------------------------------------------------
a.Spell.ID = function(id)
    return AshitaCore:GetResourceManager():GetSpellById(id)
end

-- ------------------------------------------------------------------------------------------------------
-- Get the name of a spell.
-- If we already have the spell data then we don't need to get it again.
-- ------------------------------------------------------------------------------------------------------
---@param id number spell ID.
---@param data? table spell table if we already have it.
---@return string
-- ------------------------------------------------------------------------------------------------------
a.Spell.Name = function(id, data)
    local spell = data
    if not spell then
        spell = a.Spell.ID(id)
    end
    if not spell then return "Error" end
    return spell.Name[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Gets properties for a WS.
-- The resource file used to do this is from Windower.
-- Some things are treated as weaponskills, but aren't actually. Those can be missing from the WS file.
-- For those I keep track of them in Missing_WS define in the lists.lua
-- ------------------------------------------------------------------------------------------------------
---@param id number weaponskill ID.
---@return table
-- ------------------------------------------------------------------------------------------------------
a.WS.ID = function(id)
    local ws = WS[id]
    if not ws then ws = Lists.WS.Missing_WS[id] end
    return ws
end

-- ------------------------------------------------------------------------------------------------------
-- Checks a piece of gear's level.
-- ------------------------------------------------------------------------------------------------------
---@param item_name string
---@return number
-- ------------------------------------------------------------------------------------------------------
a.Item.Get_Item_Level = function(item_name)
    local item = AshitaCore:GetResourceManager():GetItemByName(item_name, 0)
    local item_level = item.Level
    if not item_level then return 0 end
    return item_level
end

-- ------------------------------------------------------------------------------------------------------
-- Adds a message in game chat.
-- ------------------------------------------------------------------------------------------------------
---@param message string
-- ------------------------------------------------------------------------------------------------------
a.Chat.Message = function(message)
    print("METRICS: " .. message)
end

-- ------------------------------------------------------------------------------------------------------
-- Returns whether the given ID is associated with an ability that should be ignored.
-- These are usually pet logistics ability like Sic, Heel, Assault, Avatar ability kickoff, etc.
-- Nothing is lost by excluding these because they either do nothing or damage comes in a separate packet.
-- ------------------------------------------------------------------------------------------------------
---@param data table ability data.
---@return boolean
-- ------------------------------------------------------------------------------------------------------
a.Util.Is_Ignore_Ability = function(data)
    return data.Type == a.Enum.Ability.BLOODPACTRAGE or data.Type == a.Enum.Ability.BLOODPACTWARD or data.Type == a.Enum.Ability.PETLOGISTICS
end

-- ------------------------------------------------------------------------------------------------------
-- Keeps track of if the player is zoning or not. Used to hide the window during zoning.
-- ------------------------------------------------------------------------------------------------------
---@param zoning boolean
-- ------------------------------------------------------------------------------------------------------
a.Util.Zoning = function(zoning)
    a.States.Zoning = zoning
end

-- ------------------------------------------------------------------------------------------------------
-- Wintersolstice converted the the action packet 0x0028 to the Windower version.
-- This is basically copy and pasted from Wintersolstice's parse lua.
-- Ashita  : https://github.com/atom0s/XiPackets/tree/main/world/server/0x0028
-- Windower: https://github.com/Windower/Lua/wiki/Action-Event
-- Parse   : https://github.com/WinterSolstice8/parse
-- ------------------------------------------------------------------------------------------------------
---@param data table parsed packet data
---@return nil
-- ------------------------------------------------------------------------------------------------------
a.Packets.Build_Action = function (data)
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

	for _, v in ipairs(parsed_packet.target) do
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

-- ------------------------------------------------------------------------------------------------------
-- Handles parsing messages out of incoming packet 0x029.
-- ------------------------------------------------------------------------------------------------------
---@param data table parsed packet data
---@return nil
-- ------------------------------------------------------------------------------------------------------
a.Packets.Build_Message = function(data)
    -- player = windower.ffxi.get_player()
    local p = parser.parse(data)
    if not p then return nil end
    local player_id    = p['Actor'] 
    local target_id    = p['Target']
    local param_1      = p['Param 1']
    local param_2      = p['Param 2']
    local target_index = p['Target Index']
    local message_id   = p['Message']
    _Debug.Error.Add("Packets.Build_Message: " .. tostring(message_id))
    -- local message      = res.action_messages[message_id][language]
    -- windower.add_to_chat(c_chat, tostring(player_id))
end

return a