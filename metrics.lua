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

addon.author  = "Metra"
addon.name    = "Metrics"
addon.version = "01.09.26.02"

_Globals = { }
_Globals.Initialized = false

SettingsFile = require("settings")
Socket       = require("socket")   -- Needed for millisecond precision on timestamps for attack speed.
Timers       = require("timers")

-- This holds all of the settings for the various Metrics modules.
-- It needs to be initialized after requiring "settings" because "settings" contains the definition for the "T" table modifier.
-- The "T" table modifier is needed for the settings to save correctly without crashing on initial load.
Metrics = T{ }

-- Duplicate packet checking from Thorny by way of the parse addon.
-- https://github.com/WinterSolstice8/parse/
FFI = require("ffi")
FFI.cdef[[
    int32_t memcmp(const void* buff1, const void* buff2, size_t count);
]]
LastChunkBuffer    = T{ }
CurrentChunkBuffer = T{ }

require("resources._resource")
require("database._database")
require("file")
require("throttling")
require("ashita._ashita")
require("handlers._handler")
require("windows.!manager")
require("windows.!window")
require("columns.!column")
require("modules.config._config")
require("modules.exp._exp")
require("modules.loot._loot")
require("modules.parse._parse")
require("modules.focus._focus")
require("modules.battle log._battle_log")
require("modules.report._report")
require("modules.overview._overview")
require("modules.hub.!hub")
require("modules.debug.!debug")
require("commands")
require("horizon")
require("initialization")

------------------------------------------------------------------------------------------------------
-- Subscribe to screen rendering. Use this to drive things over time.
-- https://github.com/ocornut/imgui
-- https://github.com/ocornut/imgui/blob/master/imgui_demo.cpp
-- https://github.com/ocornut/imgui/blob/master/imgui_tables.cpp
------------------------------------------------------------------------------------------------------
ashita.events.register('d3d_present', 'present_cb', function()
    if not _Globals.Initialized or not Ashita.Player.IsLoggedIn() then
        return nil
    end

    -- Throttling for performance.
    Throttle.Throttle()

    -- Need to initialize here because some things aren't ready when addon loads.
    XP.Initialize()

    Ashita.Party.CheckRefreshTime()
    Ashita.Party.Refresh()

    WindowManager.CheckMouse()

    Timers.Cycle(Timers.Types.AUTOPAUSE)
    Timers.Cycle(Timers.Types.DPS)

    if not WindowManager.Menu.Hide() and not WindowManager.IsMasked() then
        -- Windows that always standalone.
        Hub.Window.Populate(Hub.Content)
        Overview.Window.Populate(Overview.Content)
        Config.Window.Populate(Config.Content)
        Debug.Window.Populate(Debug.Content)

        -- Windows that standalone only in multi-window mode.
        if WindowManager.Settings.Multi_Window then
            Parse.Window.Populate(Parse.Content)
            Focus.Window.Populate(Focus.Content)
            Blog.Window.Populate(Blog.Content)
            XP.Window.Populate(XP.Content)
            Loot.Window.Populate(Loot.Content)
            Report.Window.Populate(Report.Content)
        end

        Throttle.Block()
    end
end)

------------------------------------------------------------------------------------------------------
-- Subscribes to incoming packets.
-- Party info doesn't seem to update right away with 0xC8 (200) and 0xDD (221) so can't update party directly from those.
-- https://github.com/atom0s/XiPackets/tree/main/world/server/0x0028
------------------------------------------------------------------------------------------------------
ashita.events.register('packet_in', 'packet_in_cb', function(packet)
    if not _Globals.Initialized or not packet or not packet.data then
        return nil
    end

    -- Duplicate packet checking from Thorny by way of the parse addon.
    -- https://github.com/WinterSolstice8/parse/
	if not packet.injected and Ashita.Packets.IsDuplicate(packet) then
        Debug.Error.Add(Debug.Error.WARNING, "Packet In", string.format("Duplicate packet for packet {%s} found.", tostring(packet.id)))
        return nil
    end

    local handlers =
    {
        [ H.Packet.ZONE_START      ] = function() Ashita.Player.Zoning(true) end,
        [ H.Packet.ZONE_END        ] = function() H.ZoningEnd() end,
        [ H.Packet.EXAMPLAR_UPDATE ] = function() XP.OnExemplarUpdate(packet.data) end,
        [ H.Packet.CAPACITY_UPDATE ] = function() XP.OnCapacityUpdate(packet.data) end,
        [ H.Packet.ALLIANCE_UPDATE ] = function() Ashita.Party.NeedRefresh = true end,
        [ H.Packet.PARTY_UPDATE    ] = function() Ashita.Party.NeedRefresh = true end,
        [ H.Packet.XP_UPDATE       ] = function() XP.OnXpGained(packet.data) end,
        [ H.Packet.PLAYER_UPDATE   ] = function() H.PlayerUpdate() end,
        [ H.Packet.ACTION          ] = function() H.StartActionPacket(packet) end,
        [ H.Packet.ACTION_MESSAGE  ] = function() H.ActionMessage(packet) end,
        [ H.Packet.ITEM_DROPPED    ] = function() Loot.Dropped(packet.data) end,
        [ H.Packet.ITEM_OBTAINED   ] = function() Loot.Obtained(packet.data) end,
    }

    if handlers[packet.id] then
        pcall(handlers[packet.id])
    end
end)