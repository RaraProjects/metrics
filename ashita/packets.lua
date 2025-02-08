local parser = require('packets._parser') -- from atom0s
local breader = require('packets._bitreader') -- from atom0s

Ashita.Packets = T{}

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
Ashita.Packets.Build_Action = function (data)
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
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Packets.Build_Message = function(data)
    local reader = breader:new()
    reader:set_data(data)
    reader:set_pos(4)
    local parsed_data = {}
    parsed_data.actor = reader:read(32)
    parsed_data.target = reader:read(32)
    parsed_data.param1 = reader:read(32)
    parsed_data.param2 = reader:read(32)
    parsed_data.actor_index = reader:read(16)
    parsed_data.target_index = reader:read(16)
    parsed_data.message = reader:read(16)
    parsed_data.unknown = reader:read(16)
    return parsed_data
end

-- ------------------------------------------------------------------------------------------------------
-- Handles parsing the experience points packet 0x02D.
-- ------------------------------------------------------------------------------------------------------
---@param data table parsed packet data
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Packets.EXP = function(data)
	local reader = breader:new()
    reader:set_data(data)
    reader:set_pos(4)
	local parsed_data = T{}
	parsed_data.player = reader:read(32)
	parsed_data.target = reader:read(32)
	parsed_data.player_index = reader:read(16)
    parsed_data.target_index = reader:read(16)
	parsed_data.xp_amount = reader:read(32)		-- Amount of XP or limit points.
    parsed_data.chain_count = reader:read(32)	-- Current chain.
	parsed_data.message_id = reader:read(16)	-- Determines if on a chain and if limit or exp.
	parsed_data.unknown = reader:read(16)
	return parsed_data
end

-- ------------------------------------------------------------------------------------------------------
-- Handles parsing the capacity and limit points packet 0x063.
-- ------------------------------------------------------------------------------------------------------
---@param data table parsed packet data
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Packets.Capacity_And_Limit_Update = function(data)
	local reader = breader:new()
    reader:set_data(data)
    reader:set_pos(4)
	local parsed_data = T{}
	parsed_data.order = reader:read(16)

	-- Limit Points
	if parsed_data.order == 2 then
		parsed_data.unknown = reader:read(16)
		parsed_data.limit_points_into_level = reader:read(16)
		parsed_data.current_merit_points = reader:read(7)
		parsed_data.assimilation = reader:read(6)
		parsed_data.limit_breakder = reader:read(1)
		parsed_data.exp_capped = reader:read(1)
		parsed_data.limit_point_mode = reader:read(1)
		parsed_data.max_merit_points_aquirable = reader:read(8)

	-- Capacity Points
	elseif parsed_data.order == 5 then
		local job_id = Ashita.Player.Main_Job_ID()
		if not job_id then job_id = 1 end

		-- Skip the initial junk packets.
		reader:read(16 * 6)

		-- Jump to the specific job data.
		reader:read((job_id - 1) * (16 * 3))

		parsed_data.capacity_points_into_level = reader:read(16) or 0
		parsed_data.current_job_points = reader:read(16) or 0
		parsed_data.spent_job_points = reader:read(16) or 0
	end

	return parsed_data
end

-- ------------------------------------------------------------------------------------------------------
-- Handles parsing the stat update packet 0x061.
-- ------------------------------------------------------------------------------------------------------
---@param data table parsed packet data
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Packets.Stat_Update = function(data)
    local reader = breader:new()
    reader:set_data(data)
    reader:set_pos(4)
	local parsed_data = T{}

	parsed_data.max_hp = reader:read(32)
	parsed_data.max_mp = reader:read(32)
	parsed_data.main_job = reader:read(8)
	parsed_data.main_job_level = reader:read(8)
	parsed_data.sub_job = reader:read(8)
	parsed_data.sub_job_level = reader:read(8)
	parsed_data.current_exp = reader:read(16)
	parsed_data.required_exp = reader:read(16)
	parsed_data.base_str = reader:read(16)
	parsed_data.base_dex = reader:read(16)
	parsed_data.base_vit = reader:read(16)
	parsed_data.base_agi = reader:read(16)
	parsed_data.base_int = reader:read(16)
	parsed_data.base_mnd = reader:read(16)
	parsed_data.base_chr = reader:read(16)
	parsed_data.added_str = reader:read(16)
	parsed_data.added_dex = reader:read(16)
	parsed_data.added_vit = reader:read(16)
	parsed_data.added_agi = reader:read(16)
	parsed_data.added_int = reader:read(16)
	parsed_data.added_mnd = reader:read(16)
	parsed_data.added_chr = reader:read(16)
	parsed_data.attack = reader:read(16)
	parsed_data.defense = reader:read(16)
	parsed_data.fire_resist = reader:read(16)
	parsed_data.wind_resist = reader:read(16)
	parsed_data.lighting_resist = reader:read(16)
	parsed_data.light_resist = reader:read(16)
	parsed_data.ice_resist = reader:read(16)
	parsed_data.earth_resist = reader:read(16)
	parsed_data.water_resist = reader:read(16)
	parsed_data.dark_resist = reader:read(16)
	parsed_data.title = reader:read(16)
	parsed_data.nation_rank = reader:read(16)
	parsed_data.rank_points = reader:read(16)
	parsed_data.home_point = reader:read(16)
	parsed_data.unknown1 = reader:read(16)
	parsed_data.unknown2 = reader:read(16)
	parsed_data.nation = reader:read(8)
	parsed_data.unknown3 = reader:read(8)
	parsed_data.su_level = reader:read(8)
	parsed_data.unknown4 = reader:read(8)
	parsed_data.max_ilevel = reader:read(8)
	parsed_data.ilevel_over_99 = reader:read(8)
	parsed_data.main_hand_ilevel = reader:read(8)
	parsed_data.unknown5 = reader:read(8)
	parsed_data.unity_id = reader:read(5)
	parsed_data.unity_rank = reader:read(5)
	parsed_data.unity_points = reader:read(17)
	parsed_data.unknown6 = reader:read(5)
	parsed_data.junk1 = reader:read(32)
	parsed_data.junk2 = reader:read(32)
	parsed_data.unknown7 = reader:read(8)
	parsed_data.master_level = reader:read(8)
	parsed_data.master_breaker = reader:read(1)
	parsed_data.junk3 = reader:read(15)
	parsed_data.exemplar_points_into_level = reader:read(32)
	parsed_data.exemplar_level_max = reader:read(32)

	return parsed_data
end

-- ------------------------------------------------------------------------------------------------------
-- Handles parsing the character update packet 0x0DF.
-- ------------------------------------------------------------------------------------------------------
---@param data table parsed packet data
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Packets.Character_Update = function(data)
	local reader = breader:new()
    reader:set_data(data)
    reader:set_pos(4)
	local parsed_data = T{}
	parsed_data.ID    = reader:read(32)
	parsed_data.HP    = reader:read(32)
	parsed_data.MP    = reader:read(32)
	parsed_data.TP    = reader:read(32)
	parsed_data.Index = reader:read(16)
	parsed_data.HPP   = reader:read(16)
	parsed_data.MPP   = reader:read(16)
	parsed_data.Unk1  = reader:read(16)
	parsed_data.Unk2  = reader:read(16)
	parsed_data.Mon_Species = reader:read(16)
	parsed_data.Mon_Name1   = reader:read(8)
	parsed_data.Mon_Name2   = reader:read(8)
	parsed_data.Main_Job = reader:read(8)
	parsed_data.Main_Lvl = reader:read(8)
	parsed_data.Sub_Job  = reader:read(8)
	parsed_data.Sub_Lvl  = reader:read(8)
	return parsed_data
end

-- ------------------------------------------------------------------------------------------------------
-- Handles parsing messages out of incoming packet 0x0D2.
-- ------------------------------------------------------------------------------------------------------
---@param data table parsed packet data
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Packets.Item_Drop = function(data)
	local reader = breader:new()
    reader:set_data(data)
    reader:set_pos(4)
	local parsed_data = T{}
	parsed_data.Unknown1      = reader:read(32)
	parsed_data.Dropper       = reader:read(32)
	parsed_data.Count         = reader:read(32)
	parsed_data.Item          = reader:read(16)
	parsed_data.Dropper_Index = reader:read(16)
	parsed_data.Index         = reader:read(8)
	parsed_data.Old           = reader:read(8)
	parsed_data.Unknown2      = reader:read(8)
	parsed_data.Unknown3      = reader:read(8)
	parsed_data.Timestamp     = reader:read(32)

	return parsed_data
end

-- ------------------------------------------------------------------------------------------------------
-- Handles parsing messages out of incoming packet 0x0D3.
-- ------------------------------------------------------------------------------------------------------
---@param data table parsed packet data
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Packets.Item_Action = function(data)
	local reader = breader:new()
    reader:set_data(data)
    reader:set_pos(4)
	local parsed_data = T{}
	parsed_data.Highest_Lotter       = reader:read(32)
	parsed_data.Current_Lotter       = reader:read(32)
	parsed_data.Highest_Lotter_Index = reader:read(16)
	parsed_data.Highest_Lot          = reader:read(16)
	parsed_data.Current_Lotter_Index = reader:read(15)
	parsed_data.Unknown              = reader:read(1)
	parsed_data.Current_Lot          = reader:read(16)
	parsed_data.Index                = reader:read(8)
	parsed_data.Drop                 = reader:read(8)

	local highest_lotter = ""
	for x = 1, 16 do
		highest_lotter = highest_lotter .. string.char(reader:read(8))
	end
	parsed_data.Highest_Lotter_Name  = highest_lotter

	local current_lotter = ""
	for x = 1, 16 do
		current_lotter = current_lotter .. string.char(reader:read(8))
	end
	parsed_data.Current_Lotter_Name  = current_lotter

	return parsed_data
end

-- ------------------------------------------------------------------------------------------------------
-- Gets the action packet target.
-- Used to see if the target is an affiliate to drive defensive stats.
-- ------------------------------------------------------------------------------------------------------
---@param action table
---@return table|nil
-- ------------------------------------------------------------------------------------------------------
Ashita.Packets.Get_Action_Target = function(action)
	for target_index, target_value in pairs(action.targets) do
		for action_index, _ in pairs(target_value.actions) do
			local result = action.targets[target_index].actions[action_index]
			local target_mob = Ashita.Mob.GetMobByID(action.targets[target_index].id)
            return target_mob
		end
	end
	return nil
end

-- ------------------------------------------------------------------------------------------------------
-- Check if the packet is a duplicate.
-- Duplicate packet checking from Thorny by way of the parse addon.
-- https://github.com/WinterSolstice8/parse/
-- ------------------------------------------------------------------------------------------------------
---@param packet table
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Packets.Is_Duplicate = function(packet)
	--Check if new chunk..
    if (FFI.C.memcmp(packet.data_raw, packet.chunk_data_raw, packet.size) == 0) then
        Last_Chunk_Buffer = Current_Chunk_Buffer
        Current_Chunk_Buffer = T{}
    end

    --Add packet to current chunk's buffer..
    local pointer = FFI.cast('uint8_t*', packet.data_raw)
    local new_packet = FFI.new('uint8_t[?]', 512)
    FFI.copy(new_packet, pointer, packet.size)
    Current_Chunk_Buffer:append(new_packet)

    --Check if last chunk contained this packet..
    for _, p in ipairs(Last_Chunk_Buffer) do
        if (FFI.C.memcmp(p, pointer, packet.size) == 0) then return true end
    end

    return false
end