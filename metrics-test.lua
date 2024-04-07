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

-- Resources
Lists = require("lists")
WS = require("resources.weapon_skills")
Pet_Skill = require("resources.monster_skills")

-- Modules
UI = require("imgui")
A = require("ashita")
Model = require('model')
Handler = require("handler")

-- Windows
Window = require("gui._window")
Col = require('gui._columns')
Blog = require('gui.battle_log')
Team = require('gui.team')
Focus = require('gui.focus')
Settings = require("gui.settings")

-- Initialization
Window.Initialize()
Model.Initialize()
_Globals.Initialized = true

------------------------------------------------------------------------------------------------------
-- Subscribes to incoming packets.
-- https://github.com/atom0s/XiPackets/tree/main/world/server/0x0028
------------------------------------------------------------------------------------------------------
ashita.events.register('packet_in', 'packet_in_cb', function(packet)
    -- There was some duplicate packet checking here. I didn't quite understand it, and
    -- as far ask I know I haven't run into duplicate packet issues. So I removed it.

    if not _Globals.Initialized then return nil end

    if packet.id == 0x028 then
        local action = A.Packets.Build_Action(packet.data)
        if not action then return nil end

        local actor_mob = A.Mob.Get_Mob_By_ID(action.actor_id)
        if not actor_mob then return nil end

        local owner_mob = A.Mob.Pet_Owner(actor_mob)
        local log_offense = false
        if owner_mob or actor_mob.in_party or actor_mob.in_alliance then log_offense = true end

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

------------------------------------------------------------------------------------------------------
-- Subscribe to screen rendering. Use this to drive things over time.
-- https://github.com/ocornut/imgui
-- https://github.com/ocornut/imgui/blob/master/imgui_demo.cpp
-- https://github.com/ocornut/imgui/blob/master/imgui_tables.cpp
------------------------------------------------------------------------------------------------------
ashita.events.register('d3d_present', 'present_cb', function ()
    UI.ShowDemoWindow()
    Window.Populate()
end)

------------------------------------------------------------------------------------------------------
-- Subscribe to addon commands.
-- Influenced by HXUI: https://github.com/tirem/HXUI
------------------------------------------------------------------------------------------------------
ashita.events.register('command', 'command_cb', function (e)
    local command_args = e.command:lower():args()
---@diagnostic disable-next-line: undefined-field
    if table.contains({"/metrics"}, command_args[1]) then
        if command_args[2] == "show" then
            Window.Window.Visible = not Window.Window.Visible
        end
    end
end)

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

