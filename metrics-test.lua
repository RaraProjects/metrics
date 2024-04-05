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

Lists = require("lists")
WS = require("resources.weapon_skills")
Pet_Skill = require("resources.monster_skills")

UI = require("imgui")
A = require("ashita")
Model = require('model')
require("packets.events")

-- require('data.settings')

require('magic_numbers')
require('string_lib')
require('lib')



-- Windows
Window = require("gui._window")
Col = require('gui._columns')
Blog = require('gui.battle_log')
Monitor = require('gui.table')
Focus = require('gui.focus')
Settings = require("gui.settings")


Window.Initialize()

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

