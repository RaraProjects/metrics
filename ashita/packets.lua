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
-- NOT IMPLEMENTED
-- Handles parsing messages out of incoming packet 0x029.
-- ------------------------------------------------------------------------------------------------------
---@param data table parsed packet data
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Packets.Item_Message = function(data)
    return {}
end