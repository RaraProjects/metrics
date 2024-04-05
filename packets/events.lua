P = require("packets.handler")

-- From Parse by Flippant and Wintersolstice
-- From Thorny
local ffi = require("ffi")
ffi.cdef[[
    int32_t memcmp(const void* buff1, const void* buff2, size_t count)
]]
local lastChunkBuffer = {}
local currentChunkBuffer = {}

local function CheckForDuplicate(e)
    --Check if new chunk..
    if (ffi.C.memcmp(e.data_raw, e.chunk_data_raw, e.size) == 0) then
        lastChunkBuffer = currentChunkBuffer
        currentChunkBuffer = {}
    end

    --Add packet to current chunk's buffer..
    local ptr = ffi.cast('uint8_t*', e.data_raw)
    local newPacket = ffi.new('uint8_t[?]', 512)
    ffi.copy(newPacket, ptr, e.size)
    table.insert(currentChunkBuffer, newPacket)

    --Check if last chunk contained this packet..
    for _, packet in ipairs(lastChunkBuffer) do
        if (ffi.C.memcmp(packet, ptr, e.size) == 0) then
            return true
        end
    end
    return false
end

-- https://github.com/atom0s/XiPackets/tree/main/world/server/0x0028
ashita.events.register('packet_in', 'packet_in_cb', function(packet)
	-- Thanks Thorny!
	-- local isDuplicate = false
	-- if (not e.injected) then
	-- 	isDuplicate = CheckForDuplicate(e)
	-- end

	-- if e.id == 0x028 and not isDuplicate then -- Action packet
	-- 	A.Chat.Message(e.id)
    --     --parse_action_packet(e.data)
	-- end

    if packet.id == 0x028 then
        local action = P.Packets.Build_Action(packet.data)
        if not action then return nil end

        local actor_mob = A.Mob.Get_Mob_By_ID(action.actor_id)
        if not actor_mob then return nil end

        local owner_mob = A.Mob.Pet_Owner(actor_mob)
        local log_offense = owner_mob or actor_mob.in_party or actor_mob.in_alliance

        if     (action.category ==  1) then P.Action.Melee(action, actor_mob, owner_mob, log_offense)
        elseif (action.category ==  2) then P.Action.Ranged(action, actor_mob, log_offense)
        elseif (action.category ==  3) then P.Action.Finish_Weaponskill(action, actor_mob, log_offense)
        elseif (action.category ==  4) then P.Action.Finish_Spell_Casting(action, actor_mob, log_offense)
        elseif (action.category ==  5) then -- Do nothing (Finish Item Use)
        elseif (action.category ==  6) then P.Action.Job_Ability(action, actor_mob, log_offense)
        elseif (action.category ==  7) then -- Do nothing (Begin WS)
        elseif (action.category ==  8) then -- Do nothing (Begin Spellcasting)
        elseif (action.category ==  9) then -- Do nothing (Begin or Interrupt Item Usage)
        elseif (action.category == 11) then P.Action.Finish_Monster_TP_Move(action, actor_mob, log_offense)
        elseif (action.category == 12) then -- Do nothing (Begin Ranged Attack)
        elseif (action.category == 13) then P.Action.Pet_Ability(action, actor_mob, log_offense)
        elseif (action.category == 14) then -- Do nothing (Unblinkable Job Ability)
        end

    end
end)

-- https://github.com/ocornut/imgui
-- https://github.com/ocornut/imgui/blob/master/imgui_demo.cpp
-- https://github.com/ocornut/imgui/blob/master/imgui_tables.cpp
-- --------------------------------------------------------------------------
-- Things to update over time.
-- --------------------------------------------------------------------------
ashita.events.register('d3d_present', 'present_cb', function ()
    UI.ShowDemoWindow()
    Window.Populate()
end)

Test_Gobal = true
-- --------------------------------------------------------------------------
-- Influenced by HXUI.
-- https://github.com/tirem/HXUI
-- --------------------------------------------------------------------------
ashita.events.register('command', 'command_cb', function (e)
	local command_args = e.command:lower():args()
    if table.contains({'/metrics'}, command_args[1]) then
		A.Chat.Message("Command: " .. tostring(Test_Gobal))
        Monitor.Test(Test_Gobal)
        A.Chat.Message("Command: " .. tostring(Test_Gobal))
	end
end)