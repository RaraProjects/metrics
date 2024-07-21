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
addon.version = "07.21.24.00"

_Globals = {}
_Globals.Initialized = false
Settings_File = require("settings")
Socket = require("socket")              -- Needed for millisecond precision on timestamps for attack speed.
Metrics = T{}

-- Resources
require("resources._resource")

-- Modules
UI = require("imgui")
require("database._database")
require("file")
Timers = require("timers")

require("throttling")
require("ashita._ashita")
require("handlers._handler")
require("windows.exp._exp")

-- Windows
require("windows.config._config")
require("gui.window._window")
require("gui.columns._column")
require("windows.parse._parse")
require("windows.focus._focus")
require("windows.battle log._battle_log")
require("windows.report._report")
require("windows.hub")

require("commands")
require("debug._debug")
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
    if _Debug.Is_Enabled() and _Debug.Config.Show_Demo then UI.ShowDemoWindow() end

    Throttle.Throttle()     -- Throttling for performance.
    XP.Initialize()         -- Need to initialize here because some things aren't ready when addon loads.

    Timers.Cycle(Timers.Enum.Names.AUTOPAUSE)
    Timers.Cycle(Timers.Enum.Names.DPS)
    Timers.Cycle(Timers.Enum.Names.EXP)
    Window.Populate()
    Hub.Populate()
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
        Timers.Reset(Timers.Enum.Names.ZONE)
        Window.Set_Bar_Delay()
        XP.Chains.End()

    -- 200 0xC8 Alliance Update
    elseif packet.id == 0xC8 then
        Ashita.Party.Need_Refresh = true

    -- 221 0xDD Party Member Update
    elseif packet.id == 0xDD then
        Ashita.Party.Need_Refresh = true

    -- Experience Points
    elseif packet.id == 0x2D then
        XP.Parse(packet.data)

    -- Player Update
    elseif packet.id == 0x37 then
        if XP.Is_Initialized then XP.Dedication.Check() end

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
        elseif (action.category ==  5) then H.Item.Action(action, actor_mob)
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
                Blog.Add(target_mob.name, nil, Blog.Enum.Types.MOB_DEATH, Blog.Enum.Text.MOB_DEATH)
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