--[[
Copyright © 2024, Metra of HorizonXI
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of React nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL --Metra-- BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

addon.author = 'Metra'
addon.name = "Metrics-Test"
addon.version = '1.0.0'
addon.commands = {'p', 'parse'}

_Globals = {}
_Globals.Initialized = false
_Globals.Debug = true

Lists = require("lists")
WS = require("resources.weapon_skills")
Pet_Skill = require("resources.monster_skills")

UI = require("imgui")
A = require("ashita")
Model = require('model')
Handler = require("handler")

require('magic_numbers')

-- Windows
Window = require("gui._window")
Col = require('gui._columns')
Blog = require('gui.battle_log')
Team = require('gui.team')
Focus = require('gui.focus')
Settings = require("gui.settings")


Window.Initialize()
Model.Initialize()
_Globals.Initialized = true

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

  if not _Globals.Initialized then return nil end

  if packet.id == 0x028 then
    local action = A.Packets.Build_Action(packet.data)
    if not action then return nil end

    local actor_mob = A.Mob.Get_Mob_By_ID(action.actor_id)
    if not actor_mob then return nil end

    local owner_mob = A.Mob.Pet_Owner(actor_mob)
    local log_offense = owner_mob or actor_mob.in_party or actor_mob.in_alliance

    if     (action.category ==  1) then Handler.Action.Melee(action, actor_mob, owner_mob, log_offense)
    elseif (action.category ==  2) then Handler.Action.Ranged(action, actor_mob, log_offense)
    elseif (action.category ==  3) then Handler.Action.Finish_Weaponskill(action, actor_mob, log_offense)
    elseif (action.category ==  4) then Handler.Action.Finish_Spell_Casting(action, actor_mob, log_offense)
    elseif (action.category ==  5) then -- Do nothing (Finish Item Use)
    elseif (action.category ==  6) then Handler.Action.Job_Ability(action, actor_mob, log_offense)
    elseif (action.category ==  7) then -- Do nothing (Begin WS)
    elseif (action.category ==  8) then -- Do nothing (Begin Spellcasting)
    elseif (action.category ==  9) then -- Do nothing (Begin or Interrupt Item Usage)
    elseif (action.category == 11) then Handler.Action.Finish_Monster_TP_Move(action, actor_mob, log_offense)
    elseif (action.category == 12) then -- Do nothing (Begin Ranged Attack)
    elseif (action.category == 13) then Handler.Action.Pet_Ability(action, actor_mob, log_offense)
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

	end
end)

-- Record all offensive actions from players or pets in party or alliance

--[[
    DESCRIPTION:    Handle the action packet. 
                    Documentation: https://github.com/Windower/Lua/wiki/Action-Event
                    (Documentation gets it right ~97% of the time.)
]]
-- windower.register_event('action',
-- function(act)
--     if (not act) then return end

--     local actor_mob = windower.ffxi.get_mob_by_id(act.actor_id)
--     if (not actor_mob) then return end

--     local owner_mob = Pet_Owner(act)
--     local log_offense = owner_mob or actor_mob.in_party or actor_mob.in_alliance

--     if     (act.category ==  1) then Melee_Attack(act, actor_mob, log_offense)
--     elseif (act.category ==  2) then Ranged_Attack(act, actor_mob, log_offense)
--     elseif (act.category ==  3) then Finish_WS(act, actor_mob, log_offense)
--     elseif (act.category ==  4) then Finish_Spell_Casting(act, actor_mob, log_offense)
--     elseif (act.category ==  5) then -- Do nothing (Finish Item Use)
--     elseif (act.category ==  6) then Job_Ability(act, actor_mob, log_offense)
--     elseif (act.category ==  7) then -- Do nothing (Begin WS)
--     elseif (act.category ==  8) then -- Do nothing (Begin Spellcasting)
--     elseif (act.category ==  9) then -- Do nothing (Begin or Interrupt Item Usage)
--     elseif (act.category == 11) then Finish_Monster_TP_Move(act, actor_mob, log_offense)
--     elseif (act.category == 12) then -- Do nothing (Begin Ranged Attack)
--     elseif (act.category == 13) then Pet_Ability(act, actor_mob, log_offense)
--     elseif (act.category == 14) then -- Do nothing (Unblinkable Job Ability)
--     else
--         Add_Message_To_Chat('W', ' Action Event^parse', 'Uncaptured_Category: '..act.category)
--     end

-- end)

--[[
    DESCRIPTION:    Detect loss of buffs.
]] 
-- windower.register_event('action message',
-- function (actor_id, target_id, actor_index, target_index, message_id, param_1, param_2, param_3)

--     local target = windower.ffxi.get_mob_by_id(target_id)
--     if (not target) then return end

--     -- Effect wears off
--     if (message_id == 206) then
--         if (target.in_party or target.in_alliance) then
--             if Important_Buffs[param_1] then
--                 --add_message(target.name, '-'..important_buffs[param_1].name, ' ', c_orange)
--             end
--         end

--     elseif (message_id == 97) then
--         Player_Death(actor_id, target_id)

--     else
--         --Add_Message_To_Chat('W', 'action message^parse', 'Action Message: '..tostring(message_id))

--     end

-- end)

