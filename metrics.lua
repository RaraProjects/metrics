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

-- Horizon Approved Addon 0457

addon.author = "Metra"
addon.name = "Metrics"
addon.version = "0.9.0"

_Globals = {}
_Globals.Initialized = false
--require('common')
Settings_File = require("settings")

-- Resources
Lists     = require("lists")
WS        = require("resources.weapon_skills")
Pet_Skill = require("resources.monster_abilities")
Themes    = require("resources.themes")

-- Modules
UI     = require("imgui")
A      = require("ashita")
Model  = require("model")
Report = require("report")

-- Action Handlers
require("handlers._handler")
require("handlers.melee")
require("handlers.ranged")
require("handlers.tp_action")
require("handlers.abilities")
require("handlers.spells")

-- Windows
Window = require("gui._window")
Col    = require('gui._columns')
Blog   = require('gui.blog')
Team   = require('gui.team')
Focus  = require('gui.focus')
Config = require("gui.config")

-- Debug
require("debug._debug")

-- Initialize Settings
Metrics = T{
    Window = Settings_File.load(Window.Defaults, "window"),
    Team   = Settings_File.load(Team.Defaults, "team"),
    Blog   = Settings_File.load(Blog.Defaults, "blog"),
    Model  = Settings_File.load(Model.Defaults, "model"),
}

-- Initialize Modules
Window.Initialize()
Model.Initialize()
Team.Initialize()
A.Party.Refresh()

------------------------------------------------------------------------------------------------------
-- Subscribes to incoming packets.
-- Party info doesn't seem to update right away with 0xC8 (200) and 0xDD (221) so can't update party directly from those.
-- https://github.com/atom0s/XiPackets/tree/main/world/server/0x0028
------------------------------------------------------------------------------------------------------
ashita.events.register('packet_in', 'packet_in_cb', function(packet)
    if not _Globals.Initialized then return nil end

    -- Start Zone
    if packet.id == 0xB then
        A.Util.Zoning(true)

    -- End Zone
    elseif packet.id == 0xA then
        A.Util.Zoning(false)

    -- 200 0xC8 Alliance Update
    elseif packet.id == 0xC8 then
        A.Party.Need_Refresh = true

    -- 221 0xDD Party Member Update
    elseif packet.id == 0xDD then
        A.Party.Need_Refresh = true

    -- Action Packet
    elseif packet.id == 0x028 then
        local action = A.Packets.Build_Action(packet.data)
        if not action then
            _Debug.Error.Add("Packet Event: action was nil from Packets.Build_Action")
            return nil
        end

        local actor_mob = A.Mob.Get_Mob_By_ID(action.actor_id)
        if not actor_mob then
            _Debug.Error.Add("Packet Event: actor_mob was nil from Mob.Get_Mob_By_ID")
            return nil
        end

        A.Party.Refresh()

        local owner_mob = A.Mob.Pet_Owner(actor_mob)
        local log_offense = false

        -- Process action if the actor is an affiliated pet or affiliated player.
        if owner_mob or A.Party.Is_Affiliate(actor_mob.name) then log_offense = true end

        if     (action.category ==  1) then H.Melee.Action(action, actor_mob, owner_mob, log_offense)
        elseif (action.category ==  2) then H.Ranged.Action(action, actor_mob, log_offense)
        elseif (action.category ==  3) then H.TP.Action(action, actor_mob, log_offense)
        elseif (action.category ==  4) then H.Spell.Action(action, actor_mob, log_offense)
        elseif (action.category ==  5) then -- Do nothing (Finish Item Use)
        elseif (action.category ==  6) then H.Ability.Action(action, actor_mob, log_offense)
        elseif (action.category ==  7) then -- Do nothing (Begin WS)
        elseif (action.category ==  8) then -- Do nothing (Begin Spellcasting)
        elseif (action.category ==  9) then -- Do nothing (Begin or Interrupt Item Usage)
        elseif (action.category == 11) then H.TP.Monster_Action(action, actor_mob, log_offense)
        elseif (action.category == 12) then -- Do nothing (Begin Ranged Attack)
        elseif (action.category == 13) then H.Ability.Pet_Action(action, actor_mob, log_offense)
        elseif (action.category == 14) then -- Do nothing (Unblinkable Job Ability)
        end

    -- Can't implement death functionality until I can get this figured out.
    elseif packet.id == 0x029 then
        -- _Debug.Error.Add("Packet Event: 0x029.")
        -- A.Packets.Build_Message(packet)
    end
end)

------------------------------------------------------------------------------------------------------
-- Subscribe to screen rendering. Use this to drive things over time.
-- https://github.com/ocornut/imgui
-- https://github.com/ocornut/imgui/blob/master/imgui_demo.cpp
-- https://github.com/ocornut/imgui/blob/master/imgui_tables.cpp
------------------------------------------------------------------------------------------------------
ashita.events.register('d3d_present', 'present_cb', function ()
    if not _Globals.Initialized then
        if not A.Data.Is_Logged_In() then return nil end
        _Globals.Initialized = true
    end
    if _Debug.Enabled then
        UI.ShowDemoWindow()
    end
    Window.Populate()
end)

------------------------------------------------------------------------------------------------------
-- Subscribe to addon commands.
-- Influenced by HXUI: https://github.com/tirem/HXUI
------------------------------------------------------------------------------------------------------
ashita.events.register('command', 'command_cb', function (e)
    local command_args = e.command:lower():args()
---@diagnostic disable-next-line: undefined-field
    if table.contains({"/metrics"}, command_args[1]) or table.contains({"/met"}, command_args[1]) then
        local arg = command_args[2]
        if arg == "show" or arg == "s" or arg == "vis" then
            Window.Util.Toggle_Visibility()
        elseif arg == "debug" then
            _Debug.Toggle()
        elseif arg == "nano" or arg == "n" then
            Window.Util.Toggle_Nano()
        elseif arg == "mini" or arg == "m" then
            Window.Util.Toggle_Mini()
        elseif arg == "reset" or arg == "r" then
            Model.Initialize()
        elseif arg == "full" or arg == "f" then
            Window.Util.Enable_Full()
        elseif arg == "pet" or arg == "p" then
            Metrics.Team.Flags.Pet = not Metrics.Team.Flags.Pet
            Team.Util.Calculate_Column_Flags()
        elseif arg == "total" then
            Report.Publish.Total_Damage()
        elseif arg == "acc" then
            Report.Publish.Accuracy()
        elseif arg == "melee" then
            Report.Publish.Damage_By_Type(Model.Enum.Trackable.MELEE)
        elseif arg == "ws" then
            Report.Publish.Damage_By_Type(Model.Enum.Trackable.WS)
        elseif arg == "healing" then
            Report.Publish.Damage_By_Type(Model.Enum.Trackable.HEALING)
        end
    end
end)

------------------------------------------------------------------------------------------------------
-- Save settings when the addon is unloaded.
------------------------------------------------------------------------------------------------------
ashita.events.register('unload', 'unload_cb', function ()
    Settings_File.save(Config.Enum.File.MODEL)
    Settings_File.save(Config.Enum.File.TEAM)
    Settings_File.save(Config.Enum.File.BLOG)
    Settings_File.save(Config.Enum.File.WINDOW)
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

