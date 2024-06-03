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
addon.version = "06/03/24.00"

_Globals = {}
_Globals.Initialized = false
Settings_File = require("settings")
Metrics = T{}

-- Resources
require("resources._resource")

-- Modules
UI = require("imgui")
require("database._database")
require("file")
Timers = require("timers")

-- Ashita Helpers
require("ashita._ashita")

-- Action Handlers
require("handlers._handler")

-- Windows
Config = require("tabs.settings.config")
require("gui.window._window")
require("gui.columns._column")
require("tabs.parse._parse")
require("tabs.focus._focus")
require("tabs.battle_log._battle_log")
require("tabs.report._report")

-- Debug
require("debug._debug")

------------------------------------------------------------------------------------------------------
-- Subscribe to screen rendering. Use this to drive things over time.
-- https://github.com/ocornut/imgui
-- https://github.com/ocornut/imgui/blob/master/imgui_demo.cpp
-- https://github.com/ocornut/imgui/blob/master/imgui_tables.cpp
------------------------------------------------------------------------------------------------------
ashita.events.register('d3d_present', 'present_cb', function ()
    if not _Globals.Initialized then
        if not Ashita.Player.Is_Logged_In() then return nil end

        -- Initialize Settings
        Metrics = T{
            Window = Settings_File.load(Window.Defaults, Config.Enum.File.WINDOW),
            Parse  = Settings_File.load(Parse.Config.Defaults, Config.Enum.File.PARSE),
            Focus  = Settings_File.load(Focus.Config.Defaults, Config.Enum.File.FOCUS),
            Blog   = Settings_File.load(Blog.Config.Defaults, Config.Enum.File.BLOG),
            Model  = Settings_File.load(DB.Defaults, Config.Enum.File.DATABASE),
            Report = Settings_File.load(Report.Config.Defaults, Config.Enum.File.REPORT),
        }

        -- Initialize Modules
        Window.Initialize()
        DB.Initialize()
        Parse.Initialize()
        Ashita.Party.Refresh()

        -- Start the clock.
        Timers.Start(Timers.Enum.Names.PARSE)
        Timers.Start(Timers.Enum.Names.AUTOPAUSE)
        Timers.Start(Timers.Enum.Names.DPS)

        _Globals.Initialized = true
    end

    if _Debug.Is_Enabled() and _Debug.Config.Show_Demo then
        UI.ShowDemoWindow()
    end

    Timers.Cycle(Timers.Enum.Names.AUTOPAUSE)
    Timers.Cycle(Timers.Enum.Names.DPS)
    Window.Populate()
end)

------------------------------------------------------------------------------------------------------
-- Subscribes to incoming packets.
-- Party info doesn't seem to update right away with 0xC8 (200) and 0xDD (221) so can't update party directly from those.
-- https://github.com/atom0s/XiPackets/tree/main/world/server/0x0028
------------------------------------------------------------------------------------------------------
ashita.events.register('packet_in', 'packet_in_cb', function(packet)
    if not _Globals.Initialized then return nil end

    -- Start Zone
    if packet.id == 0xB then
        Ashita.Player.Zoning(true)

    -- End Zone
    elseif packet.id == 0xA then
        Ashita.Player.Zoning(false)

    -- 200 0xC8 Alliance Update
    elseif packet.id == 0xC8 then
        Ashita.Party.Need_Refresh = true

    -- 221 0xDD Party Member Update
    elseif packet.id == 0xDD then
        Ashita.Party.Need_Refresh = true

    -- Action Packet
    elseif packet.id == 0x028 then
        local action = Ashita.Packets.Build_Action(packet.data)
        if not action then
            _Debug.Error.Add("Packet Event: action was nil from Packets.Build_Action")
            return nil
        end

        local actor_mob = Ashita.Mob.Get_Mob_By_ID(action.actor_id)
        if not actor_mob then
            _Debug.Error.Add("Packet Event: actor_mob was nil from Mob.Get_Mob_By_ID")
            return nil
        end
        local target_mob = Ashita.Packets.Get_Action_Target(action)
        if not target_mob then
            _Debug.Error.Add("Packet Event: target_mob was nil from Mob.Get_Mob_By_ID")
            return nil
        end

        Ashita.Party.Refresh()

        local owner_mob = Ashita.Mob.Pet_Owner(actor_mob)
        local target_owner_mob = Ashita.Mob.Pet_Owner(target_mob)
        local log_offense = false
        local log_defense = false

        -- Process action if the actor is an affiliated pet or affiliated player.
        if owner_mob or Ashita.Party.Is_Affiliate(actor_mob.name) then
            log_offense = true
            Timers.Reset(Timers.Enum.Names.AUTOPAUSE)
            Timers.Unpause(Timers.Enum.Names.PARSE)
        elseif target_owner_mob or Ashita.Party.Is_Affiliate(target_mob.name) then
            log_defense = true
            Timers.Reset(Timers.Enum.Names.AUTOPAUSE)
            Timers.Unpause(Timers.Enum.Names.PARSE)
        end

        if (action.category ==  1) then
            if log_offense then H.Melee.Action(action, actor_mob, owner_mob, log_offense)
            elseif log_defense then H.Melee_Def.Action(action, actor_mob, target_owner_mob, log_defense) end
        elseif (action.category ==  2) then H.Ranged.Action(action, actor_mob, log_offense)
        elseif (action.category ==  3) then H.TP.Action(action, actor_mob, log_offense)
        elseif (action.category ==  4) then
            if log_offense then H.Spell.Action(action, actor_mob, log_offense)
            elseif log_defense then H.Spell_Def.Action(action, actor_mob, target_owner_mob, log_defense) end
        elseif (action.category ==  5) then -- Do nothing (Finish Item Use)
        elseif (action.category ==  6) then H.Ability.Action(action, actor_mob, log_offense)
        elseif (action.category ==  7) then -- Do nothing (Begin WS)
        elseif (action.category ==  8) then -- Do nothing (Begin Spellcasting)
        elseif (action.category ==  9) then -- Do nothing (Begin or Interrupt Item Usage)
        elseif (action.category == 11) then 
            if log_offense then H.TP.Monster_Action(action, actor_mob, log_offense)
            elseif log_defense then H.TP_Def.Monster_Action(action, actor_mob, owner_mob, log_defense) end
        elseif (action.category == 12) then -- Do nothing (Begin Ranged Attack)
        elseif (action.category == 13) then H.Ability.Pet_Action(action, actor_mob, log_offense)
        elseif (action.category == 14) then -- Do nothing (Unblinkable Job Ability); Waltz
        end

    -- Action Messages
    elseif packet.id == 0x029 then
        local data = Ashita.Packets.Build_Message(packet.data)
        if not data then return nil end
        if _Debug.Is_Enabled() then _Debug.Packet.Add_Message(data) end

        -- Killing a mob.
        if data.message == Ashita.Enum.Message.MOB_KILL then
            local actor_mob = Ashita.Mob.Get_Mob_By_Index(data.actor_index)
            if Ashita.Party.Is_Affiliate(actor_mob.name) then
                local target_mob = Ashita.Mob.Get_Mob_By_Index(data.target_index)
                DB.Defeated_Mob(target_mob.name)
                Blog.Add(target_mob.name, Blog.Enum.Types.DEATH, Blog.Enum.Text.MOB_DEATH)
            end

        -- Being defeated by a mob.
        elseif data.message == Ashita.Enum.Message.DEATH_FALL or data.message == Ashita.Enum.Message.DEATH then
            local target_mob = Ashita.Mob.Get_Mob_By_Index(data.target_index)
            if Ashita.Party.Is_Affiliate(target_mob.name) then
                local actor_mob = Ashita.Mob.Get_Mob_By_Index(data.actor_index)
                H.Death.Action(actor_mob, target_mob)
            end
        end

    -- Item obtained by someone.
    elseif packet.id == 0x0D3 then
        -- Not implemented.
    end
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

        -- Help Text
        if not arg then
            Config.Show_Window[1] = not Config.Show_Window[1]

        -- General Settings
        elseif arg == "show" or arg == "s" then
            Window.Toggle_Visibility()
        elseif arg == "debug" then
            _Debug.Toggle()
        elseif arg == "nano" or arg == "n" then
            Parse.Nano.Toggle()
        elseif arg == "mini" or arg == "m" then
            Parse.Mini.Toggle()
        elseif arg == "reset" or arg == "r" then
            DB.Initialize(true)
        elseif arg == "full" or arg == "f" then
            Parse.Full.Enable()
        elseif (arg == "pet" or arg == "p") and (Window.Tabs.Active == Window.Tabs.Names.PARSE or Parse.Mini.Is_Enabled()) then
            Parse.Config.Toggle_Pet()
            Parse.Util.Calculate_Column_Flags()
        elseif arg == "clock" or arg == "c" then
            Parse.Config.Toggle_Clock()
        elseif arg == "percent" then
            Focus.Config.Percent_Toggle()

        -- General reports.
        elseif arg == "report" or arg == "rep" then
            local report_type = command_args[3]
            if report_type == "total" then
                Report.Publishing.Total_Damage()
            elseif report_type == "acc" then
                Report.Publishing.Accuracy()
            elseif report_type == "melee" then
                Report.Publishing.Damage_By_Type(DB.Enum.Trackable.MELEE)
            elseif report_type == "ws" then
                Report.Publishing.Damage_By_Type(DB.Enum.Trackable.WS)
            elseif report_type == "healing" then
                Report.Publishing.Damage_By_Type(DB.Enum.Trackable.HEALING)
            end

        -- Primary tab switching.
        elseif arg == "team" or arg == "parse" then
            Window.Tabs.Switch[Window.Tabs.Names.PARSE] = ImGuiTabItemFlags_SetSelected
        elseif arg == "focus" then
            Window.Tabs.Switch[Window.Tabs.Names.FOCUS] = ImGuiTabItemFlags_SetSelected
        elseif arg == "log" or arg == "bl" then
            Window.Tabs.Switch[Window.Tabs.Names.BATTLELOG] = ImGuiTabItemFlags_SetSelected
        elseif arg == "report" or arg == "rep" then
            Window.Tabs.Switch[Window.Tabs.Names.REPORT] = ImGuiTabItemFlags_SetSelected

        -- Player selection
        elseif arg == "player" or arg == "pl" then
            local player_string = command_args[3]
            _Debug.Error.Add("Metrics Command: " .. tostring(arg) .. " " .. tostring(command_args[3]))
            if player_string then
                DB.Widgets.Util.Player_Switch(player_string)
            end

        -- Focus tab switching.
        elseif arg == "melee" then
            Focus.Tabs.Switch[Focus.Tabs.Names.MELEE] = ImGuiTabItemFlags_SetSelected
        elseif arg == "ranged" then
            Focus.Tabs.Switch[Focus.Tabs.Names.RANGED] = ImGuiTabItemFlags_SetSelected
        elseif arg == "ws" or arg == "weaponskill" then
            Focus.Tabs.Switch[Focus.Tabs.Names.WS] = ImGuiTabItemFlags_SetSelected
        elseif arg == "magic" then
            Focus.Tabs.Switch[Focus.Tabs.Names.MAGIC] = ImGuiTabItemFlags_SetSelected
        elseif arg == "ability" or arg == "abil" then
            Focus.Tabs.Switch[Focus.Tabs.Names.ABILITIES] = ImGuiTabItemFlags_SetSelected
        elseif (arg == "pet" or arg == "p") and Window.Tabs.Active == Window.Tabs.Names.FOCUS then
            Focus.Tabs.Switch[Focus.Tabs.Names.PETS] = ImGuiTabItemFlags_SetSelected
        elseif arg == "defense" or arg == "def" then
            Focus.Tabs.Switch[Focus.Tabs.Names.DEFENSE] = ImGuiTabItemFlags_SetSelected
        end
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Database settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Config.Enum.File.DATABASE, "settings_update", function(settings)
    if settings ~= nil and _Globals.Initialized then Metrics.Model = settings end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Parse settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Config.Enum.File.PARSE, "settings_update", function(settings)
    if settings ~= nil and _Globals.Initialized then
        Metrics.Parse = settings
        Parse.Util.Calculate_Column_Flags()
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Parse settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Config.Enum.File.FOCUS, "settings_update", function(settings)
    if settings ~= nil and _Globals.Initialized then Metrics.Focus = settings end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Parse settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Config.Enum.File.BLOG, "settings_update", function(settings)
    if settings ~= nil and _Globals.Initialized then Metrics.Blog = settings end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Parse settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Config.Enum.File.WINDOW, "settings_update", function(settings)
    if settings ~= nil and _Globals.Initialized then
        Metrics.Window = settings
        Window.Theme.Is_Set = false
        Window.Scaling_Set = false
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Parse settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Config.Enum.File.REPORT, "settings_update", function(settings)
    if settings ~= nil and _Globals.Initialized then Metrics.Report = settings end
end)

------------------------------------------------------------------------------------------------------
-- Save settings when the addon is unloaded.
------------------------------------------------------------------------------------------------------
ashita.events.register('unload', 'unload_cb', function ()
    Settings_File.save(Config.Enum.File.DATABASE)
    Settings_File.save(Config.Enum.File.PARSE)
    Settings_File.save(Config.Enum.File.FOCUS)
    Settings_File.save(Config.Enum.File.BLOG)
    Settings_File.save(Config.Enum.File.WINDOW)
    Settings_File.save(Config.Enum.File.REPORT)

    if Metrics.Report.Auto_Save then
        File.Save_Data()
        File.Save_Catalog()
        File.Save_Battlelog()
    end
end)