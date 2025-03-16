local parser  = require('packets._parser') -- from atom0s
local breader = require('packets._bitreader') -- from atom0s

Ashita.Packets = { }

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
Ashita.Packets.BuildAction = function (data)
	local parsedPacket = parser.parse(data)
	local act = { }

	-- Junk packet from server. Ignore it.
	if parsedPacket.trg_sum == 0 then
		return nil
	end

	act.actor_id     = parsedPacket.m_uID
	act.category     = parsedPacket.cmd_no
	act.param        = parsedPacket.cmd_arg
	act.target_count = parsedPacket.trg_sum
	act.unknown      = 0
	act.recast       = parsedPacket.info
	act.targets      = { }

	for _, v in ipairs(parsedPacket.target) do
		local target = { }

		target.id           = v.m_uID
		target.action_count = v.result_sum
		target.actions      = { }
		for _, action in ipairs (v.result) do
			local newAction = { }

			newAction.reaction  = action.miss -- These values are different compared to windower, so the code outside of this function was adjusted.
			newAction.animation = action.sub_kind
			newAction.effect    = action.info
			newAction.stagger   = action.scale
			newAction.param     = action.value
			newAction.message   = action.message
			newAction.unknown   = action.bit

			if action.has_proc then
				newAction.has_add_effect       = true
				newAction.add_effect_animation = action.proc_kind
				newAction.add_effect_effect    = action.proc_info
				newAction.add_effect_param     = action.proc_value
				newAction.add_effect_message   = action.proc_message
			else
				newAction.has_add_effect       = false
				newAction.add_effect_animation = 0
				newAction.add_effect_effect    = 0
				newAction.add_effect_param     = 0
				newAction.add_effect_message   = 0
			end

			if action.has_react then
				newAction.has_spike_effect       = true
				newAction.spike_effect_animation = action.react_kind
				newAction.spike_effect_effect    = action.react_info
				newAction.spike_effect_param     = action.react_value
				newAction.spike_effect_message   = action.react_message
			else
				newAction.has_spike_effect       = false
				newAction.spike_effect_animation = 0
				newAction.spike_effect_effect    = 0
				newAction.spike_effect_param     = 0
				newAction.spike_effect_message   = 0
			end

			table.insert(target.actions, newAction)
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
Ashita.Packets.BuildMessage = function(data)
    local reader = breader:new()
    reader:set_data(data)
    reader:set_pos(4)

    local parsedData = { }
    parsedData.actor        = reader:read(32)
    parsedData.target       = reader:read(32)
    parsedData.param1       = reader:read(32)
    parsedData.param2       = reader:read(32)
    parsedData.actor_index  = reader:read(16)
    parsedData.target_index = reader:read(16)
    parsedData.message      = reader:read(16)
    parsedData.unknown      = reader:read(16)

    return parsedData
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

	local parsedData = { }
	parsedData.player       = reader:read(32)
	parsedData.target       = reader:read(32)
	parsedData.player_index = reader:read(16)
    parsedData.target_index = reader:read(16)
	parsedData.xp_amount    = reader:read(32)	-- Amount of XP or limit points.
    parsedData.chain_count  = reader:read(32)	-- Current chain.
	parsedData.message_id   = reader:read(16)	-- Determines if on a chain and if limit or exp.
	parsedData.unknown      = reader:read(16)

	return parsedData
end

-- ------------------------------------------------------------------------------------------------------
-- Handles parsing the capacity and limit points packet 0x063.
-- ------------------------------------------------------------------------------------------------------
---@param data table parsed packet data
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Packets.CapacityAndLimitUpdate = function(data)
	local reader = breader:new()
    reader:set_data(data)
    reader:set_pos(4)

	local parsedData = { }
	parsedData.order = reader:read(16)

	-- Limit Points
	if parsedData.order == 2 then
		parsedData.unknown                    = reader:read(16)
		parsedData.limit_points_into_level    = reader:read(16)
		parsedData.current_merit_points       = reader:read(7)
		parsedData.assimilation               = reader:read(6)
		parsedData.limit_breakder             = reader:read(1)
		parsedData.exp_capped                 = reader:read(1)
		parsedData.limit_point_mode           = reader:read(1)
		parsedData.max_merit_points_aquirable = reader:read(8)

	-- Capacity Points
	elseif parsedData.order == 5 then
		local jobId = Ashita.Player.MainJobID()
		if not jobId then
			jobId = 1
		end

		-- Skip the initial junk packets.
		reader:read(16 * 6)

		-- Jump to the specific job data.
		reader:read((jobId - 1) * (16 * 3))

		parsedData.capacity_points_into_level = reader:read(16) or 0
		parsedData.current_job_points         = reader:read(16) or 0
		parsedData.spent_job_points           = reader:read(16) or 0
	end

	return parsedData
end

-- ------------------------------------------------------------------------------------------------------
-- Handles parsing the stat update packet 0x061.
-- ------------------------------------------------------------------------------------------------------
---@param data table parsed packet data
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Packets.StatUpdate = function(data)
    local reader = breader:new()
    reader:set_data(data)
    reader:set_pos(4)

	local parsedData = { }
	parsedData.max_hp                     = reader:read(32)
	parsedData.max_mp                     = reader:read(32)
	parsedData.main_job                   = reader:read(8)
	parsedData.main_job_level             = reader:read(8)
	parsedData.sub_job                    = reader:read(8)
	parsedData.sub_job_level              = reader:read(8)
	parsedData.current_exp                = reader:read(16)
	parsedData.required_exp               = reader:read(16)
	parsedData.base_str                   = reader:read(16)
	parsedData.base_dex                   = reader:read(16)
	parsedData.base_vit                   = reader:read(16)
	parsedData.base_agi                   = reader:read(16)
	parsedData.base_int                   = reader:read(16)
	parsedData.base_mnd                   = reader:read(16)
	parsedData.base_chr                   = reader:read(16)
	parsedData.added_str                  = reader:read(16)
	parsedData.added_dex                  = reader:read(16)
	parsedData.added_vit                  = reader:read(16)
	parsedData.added_agi                  = reader:read(16)
	parsedData.added_int                  = reader:read(16)
	parsedData.added_mnd                  = reader:read(16)
	parsedData.added_chr                  = reader:read(16)
	parsedData.attack                     = reader:read(16)
	parsedData.defense                    = reader:read(16)
	parsedData.fire_resist                = reader:read(16)
	parsedData.wind_resist                = reader:read(16)
	parsedData.lighting_resist            = reader:read(16)
	parsedData.light_resist               = reader:read(16)
	parsedData.ice_resist                 = reader:read(16)
	parsedData.earth_resist               = reader:read(16)
	parsedData.water_resist               = reader:read(16)
	parsedData.dark_resist                = reader:read(16)
	parsedData.title                      = reader:read(16)
	parsedData.nation_rank                = reader:read(16)
	parsedData.rank_points                = reader:read(16)
	parsedData.home_point                 = reader:read(16)
	parsedData.unknown1                   = reader:read(16)
	parsedData.unknown2                   = reader:read(16)
	parsedData.nation                     = reader:read(8)
	parsedData.unknown3                   = reader:read(8)
	parsedData.su_level                   = reader:read(8)
	parsedData.unknown4                   = reader:read(8)
	parsedData.max_ilevel                 = reader:read(8)
	parsedData.ilevel_over_99             = reader:read(8)
	parsedData.main_hand_ilevel           = reader:read(8)
	parsedData.unknown5                   = reader:read(8)
	parsedData.unity_id                   = reader:read(5)
	parsedData.unity_rank                 = reader:read(5)
	parsedData.unity_points               = reader:read(17)
	parsedData.unknown6                   = reader:read(5)
	parsedData.junk1                      = reader:read(32)
	parsedData.junk2                      = reader:read(32)
	parsedData.unknown7                   = reader:read(8)
	parsedData.master_level               = reader:read(8)
	parsedData.master_breaker             = reader:read(1)
	parsedData.junk3                      = reader:read(15)
	parsedData.exemplar_points_into_level = reader:read(32)
	parsedData.exemplar_level_max         = reader:read(32)

	return parsedData
end

-- ------------------------------------------------------------------------------------------------------
-- Handles parsing the character update packet 0x0DF.
-- ------------------------------------------------------------------------------------------------------
---@param data table parsed packet data
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Packets.CharacterUpdate = function(data)
	local reader = breader:new()
    reader:set_data(data)
    reader:set_pos(4)

	local parsedData = { }
	parsedData.ID          = reader:read(32)
	parsedData.HP          = reader:read(32)
	parsedData.MP          = reader:read(32)
	parsedData.TP          = reader:read(32)
	parsedData.Index       = reader:read(16)
	parsedData.HPP         = reader:read(16)
	parsedData.MPP         = reader:read(16)
	parsedData.Unk1        = reader:read(16)
	parsedData.Unk2        = reader:read(16)
	parsedData.Mon_Species = reader:read(16)
	parsedData.Mon_Name1   = reader:read(8)
	parsedData.Mon_Name2   = reader:read(8)
	parsedData.Main_Job    = reader:read(8)
	parsedData.Main_Lvl    = reader:read(8)
	parsedData.Sub_Job     = reader:read(8)
	parsedData.Sub_Lvl     = reader:read(8)

	return parsedData
end

-- ------------------------------------------------------------------------------------------------------
-- Handles parsing special messages out of incoming packet 0x02A.
-- ------------------------------------------------------------------------------------------------------
---@param data table parsed packet data
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Packets.SpecialMessage = function(data)
	local reader = breader:new()
    reader:set_data(data)
    reader:set_pos(4)

	local parsedData = { }
	parsedData.Player       = reader:read(32)
	parsedData.Param1       = reader:read(32)
	parsedData.Param2       = reader:read(32)
	parsedData.Param3       = reader:read(32)
	parsedData.Param4       = reader:read(32)
	parsedData.Player_Index = reader:read(16)
	parsedData.Message_ID   = reader:read(16)
	parsedData.Unknown      = reader:read(32)

	return parsedData
end

-- ------------------------------------------------------------------------------------------------------
-- Handles parsing messages out of incoming packet 0x0D2.
-- ------------------------------------------------------------------------------------------------------
---@param data table parsed packet data
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Packets.ItemDrop = function(data)
	local reader = breader:new()
    reader:set_data(data)
    reader:set_pos(4)

	local parsedData = { }
	parsedData.Unknown1      = reader:read(32)
	parsedData.Dropper       = reader:read(32)
	parsedData.Count         = reader:read(32)
	parsedData.Item          = reader:read(16)
	parsedData.Dropper_Index = reader:read(16)
	parsedData.Index         = reader:read(8)
	parsedData.Old           = reader:read(8)
	parsedData.Unknown2      = reader:read(8)
	parsedData.Unknown3      = reader:read(8)
	parsedData.Timestamp     = reader:read(32)

	return parsedData
end

-- ------------------------------------------------------------------------------------------------------
-- Handles parsing messages out of incoming packet 0x0D3.
-- ------------------------------------------------------------------------------------------------------
---@param data table parsed packet data
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Packets.ItemAction = function(data)
	local reader = breader:new()
    reader:set_data(data)
    reader:set_pos(4)

	local parsedData = { }
	parsedData.Highest_Lotter       = reader:read(32)
	parsedData.Current_Lotter       = reader:read(32)
	parsedData.Highest_Lotter_Index = reader:read(16)
	parsedData.Highest_Lot          = reader:read(16)
	parsedData.Current_Lotter_Index = reader:read(15)
	parsedData.Unknown              = reader:read(1)
	parsedData.Current_Lot          = reader:read(16)
	parsedData.Index                = reader:read(8)
	parsedData.Drop                 = reader:read(8)

	local highestLotter = ""
	for x = 1, 16 do
		highestLotter = highestLotter .. string.char(reader:read(8))
	end
	parsedData.Highest_Lotter_Name  = highestLotter

	local currentLotter = ""
	for x = 1, 16 do
		currentLotter = currentLotter .. string.char(reader:read(8))
	end
	parsedData.Current_Lotter_Name  = currentLotter

	return parsedData
end

-- ------------------------------------------------------------------------------------------------------
-- Gets the action packet target.
-- Used to see if the target is an affiliate to drive defensive stats.
-- ------------------------------------------------------------------------------------------------------
---@param action table
---@return table|nil
-- ------------------------------------------------------------------------------------------------------
Ashita.Packets.GetActionTarget = function(action)
	for _, target in pairs(action.targets) do
		for _, _ in pairs(target.actions) do
			return Ashita.Mob.GetMobByID(target.id)
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
Ashita.Packets.IsDuplicate = function(packet)
	--Check if new chunk..
    if (FFI.C.memcmp(packet.data_raw, packet.chunk_data_raw, packet.size) == 0) then
        LastChunkBuffer = CurrentChunkBuffer
        CurrentChunkBuffer = T{}
    end

    --Add packet to current chunk's buffer..
    local pointer   = FFI.cast('uint8_t*', packet.data_raw)
    local newPacket = FFI.new('uint8_t[?]', 512)
    FFI.copy(newPacket, pointer, packet.size)
    CurrentChunkBuffer:append(newPacket)

    --Check if last chunk contained this packet..
    for _, p in ipairs(LastChunkBuffer) do
        if (FFI.C.memcmp(p, pointer, packet.size) == 0) then return true end
    end

    return false
end