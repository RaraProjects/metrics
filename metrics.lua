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
addon.version = "12.22.24.00"

_Globals = {}
_Globals.Initialized = false

Settings_File = require("settings")
Socket        = require("socket")   -- Needed for millisecond precision on timestamps for attack speed.
Timers        = require("timers")

-- This holds all of the settings for the various Metrics modules.
-- It needs to be initialized after requiring "settings" because "settings" contains the definition for the "T" table modifier.
-- The "T" table modifier is needed for the settings to save correctly without crashing on initial load.
Metrics = T{}

-- Duplicate packet checking from Thorny by way of the parse addon.
-- https://github.com/WinterSolstice8/parse/
FFI = require("ffi")
FFI.cdef[[
    int32_t memcmp(const void* buff1, const void* buff2, size_t count);
]]
Last_Chunk_Buffer = T{}
Current_Chunk_Buffer = T{}

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
require("modules.parse._parse")
require("modules.focus._focus")
require("modules.battle log._battle_log")
require("modules.report._report")
require("modules.overview._overview")
require("modules.hub.!hub")
require("modules.debug.!debug")
require("commands")
require("initialization")

------------------------------------------------------------------------------------------------------
-- Subscribe to screen rendering. Use this to drive things over time.
-- https://github.com/ocornut/imgui
-- https://github.com/ocornut/imgui/blob/master/imgui_demo.cpp
-- https://github.com/ocornut/imgui/blob/master/imgui_tables.cpp
------------------------------------------------------------------------------------------------------
ashita.events.register('d3d_present', 'present_cb', function()
    if not _Globals.Initialized then return nil end
    if not Ashita.Player.Is_Logged_In() then return nil end
    if Debug.Is_Enabled() and Debug.Show_Demo then UI.ShowDemoWindow() end

    Throttle.Throttle()                     -- Throttling for performance.
    XP.Initialize()                         -- Need to initialize here because some things aren't ready when addon loads.
    Ashita.Party.Check_Refresh_Time()
    Ashita.Party.Refresh()
    Window_Manager.Check_Mouse()

    Timers.Cycle(Timers.Enum.Names.AUTOPAUSE)
    Timers.Cycle(Timers.Enum.Names.DPS)
    Timers.Cycle(Timers.Enum.Names.EXP)

    if not Window_Manager.Menu.Hide() and not Window_Manager.Is_Masked() then
        Hub.Window.Populate(Hub.Content)
        Overview.Window.Populate(Overview.Content)
        Config.Window.Populate(Config.Content)
        Debug.Window.Populate(Debug.Content)
        if Metrics.Window.Multi_Window then
            Parse.Window.Populate(Parse.Content)
            Focus.Window.Populate(Focus.Content)
            Blog.Window.Populate(Blog.Content)
            XP.Window.Populate(XP.Content)
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
    if not _Globals.Initialized then return nil end
    if not packet then return nil end

    -- Duplicate packet checking from Thorny by way of the parse addon.
    -- https://github.com/WinterSolstice8/parse/
	local is_duplicate = false
	if not packet.injected then is_duplicate = Ashita.Packets.Is_Duplicate(packet) end
    if is_duplicate then
        Debug.Error.Add(Debug.Error.WARNING, "Packet In", "Duplicate packet for packet {" .. tostring(packet.id) .. "} found.")
        return nil
    end

    if packet.id == 0x00B then Ashita.Player.Zoning(true)                               -- Start Zone

    -- End Zone
    elseif packet.id == 0x00A then
        Ashita.Player.Zoning(false)
        Timers.Reset(Timers.Enum.Names.ZONE)
        Window_Manager.Set_Bar_Delay()
        XP.Chains.End()

    elseif packet.id == 0x0C8 then Ashita.Party.Need_Refresh = true                     -- 200 0xC8 Alliance Update
    elseif packet.id == 0x0DD then Ashita.Party.Need_Refresh = true                     -- 221 0xDD Party Member Update
    elseif packet.id == 0x02D then XP.Parse(packet.data)                                -- Experience Points
    elseif packet.id == 0x037 then if XP.Is_Initialized then XP.Dedication.Check() end  -- Player Update
    elseif packet.id == 0x028 then H.Start_Action_Packet(packet)                        -- Action Packet

    -- Action Messages
    elseif packet.id == 0x029 then
        local data = Ashita.Packets.Build_Message(packet.data)
        if not data then return nil end
        if Debug.Is_Enabled() then Debug.Packet.Add_Message(data) end

        -- Killing a mob.
        if data.message == Ashita.Enum.Message.MOB_KILL then
            local actor_mob = Ashita.Mob.Get_Mob_By_Index(data.actor_index)
            if Ashita.Party.Is_Affiliate(actor_mob.name) or Ashita.Mob.Pet_Owner(actor_mob) then
                local target_mob = Ashita.Mob.Get_Mob_By_Index(data.target_index)
                DB.Defeated_Mob(target_mob.name)
                Blog.Add(target_mob.name, nil, Blog.Action_Type.MOB_DEATH, Blog.Enum.MOB_DEATH, nil, "------------")
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