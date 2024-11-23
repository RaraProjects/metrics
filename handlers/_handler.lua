H = {}

require("handlers.melee")
require("handlers.melee_def")
require("handlers.ranged")
require("handlers.tp_action")
require("handlers.tp_action_def")
require("handlers.abilities")
require("handlers.spells")
require("handlers.spells_def")
require("handlers.deaths")
require("handlers.items")

------------------------------------------------------------------------------------------------------
-- Sorts out the entities involved with the action packet.
------------------------------------------------------------------------------------------------------
H.Start_Action_Packet = function(packet)
    local action = Ashita.Packets.Build_Action(packet.data)
    if not action then Debug.Error.Add(Debug.Error.ERROR, "Packet In", "action was nil from Packets.Build_Action") return nil end

    local actor_mob = Ashita.Mob.Get_Mob_By_ID(action.actor_id)
    if not actor_mob then Debug.Error.Add(Debug.Error.ERROR, "Packet In", "actor_mob was nil from Mob.Get_Mob_By_ID") return nil end

    local target_mob = Ashita.Packets.Get_Action_Target(action)
    if not target_mob then Debug.Error.Add(Debug.Error.ERROR, "Packet In", "target_mob was nil from Mob.Get_Mob_By_ID") return nil end

    -- Need to refresh party for pet checks.
    Ashita.Party.Refresh()
    local pet_owner_mob = Ashita.Mob.Pet_Owner(actor_mob)           -- Is the actor the pet of someone in the party/alliance?
    local target_pet_owner_mob = Ashita.Mob.Pet_Owner(target_mob)   -- Is the target the pet of someone in the party/alliance?

    local is_offense    = false
    local is_defense    = false
    local mob_self_buff = false

    -- OFFENSE: The actor is an affiliate or the pet of an affiliate.
    if pet_owner_mob or Ashita.Party.Is_Affiliate(actor_mob.name) then
        is_offense = true
        Timers.Reset(Timers.Enum.Names.AUTOPAUSE)
        Timers.Unpause(Timers.Enum.Names.PARSE)

    -- DEFENSE: The actor is not another player and the target is an affiliate or the pet of an affiliate.
    elseif not Ashita.Mob.Is_Player(actor_mob) and (target_pet_owner_mob or Ashita.Party.Is_Affiliate(target_mob.name)) then
        is_defense = true
        Timers.Reset(Timers.Enum.Names.AUTOPAUSE)
        Timers.Unpause(Timers.Enum.Names.PARSE)

    -- The actor is a mob claimed by the party and is doing something that is targetting itself.
    elseif Ashita.Mob.Claimed_By_Affiliate(actor_mob) and actor_mob.name == target_mob.name then
        mob_self_buff = true

    -- Lurk mode detects all actions.
    elseif Metrics.Parse.Lurk_Mode then
        -- If the actor is player so log offense.
        if Ashita.Mob.Is_Player(actor_mob) then
            is_offense = true
        -- This must be a mob. If it's targetting itself then it's a buff. If not, log a defensive action.
        else
            if actor_mob.name == target_mob.name then mob_self_buff = true
            else is_defense = true end
        end
    end

    H.Pick_Action_Category(action, actor_mob, target_pet_owner_mob, pet_owner_mob, is_offense, is_defense, mob_self_buff)
end

------------------------------------------------------------------------------------------------------
-- Primary entry point for the action packet.
------------------------------------------------------------------------------------------------------
---@param action table
---@param actor_mob table
---@param target_pet_owner_mob? table
---@param pet_owner_mob? table
---@param is_offense boolean
---@param is_defense boolean
---@param mob_self_buff boolean
------------------------------------------------------------------------------------------------------
H.Pick_Action_Category = function(action, actor_mob, target_pet_owner_mob, pet_owner_mob, is_offense, is_defense, mob_self_buff)
    local category = action.category
    if     (category ==  1) then H.Action_Packet_Melee(action, actor_mob, target_pet_owner_mob, pet_owner_mob, is_offense, is_defense)
    elseif (category ==  2) then H.Ranged.Action(action, actor_mob, is_offense)
    elseif (category ==  3) then H.TP.Action(action, actor_mob, is_offense)
    elseif (category ==  4) then H.Action_Packet_Spell(action, actor_mob, target_pet_owner_mob, pet_owner_mob, is_offense, is_defense)
    elseif (category ==  5) then H.Item.Action(action, actor_mob)
    elseif (category ==  6) then H.Ability.Action(action, actor_mob, is_offense)
    elseif (category ==  7) then H.TP.Begin_Monster_Action(action, actor_mob, is_offense)
    elseif (category ==  8) then -- Do nothing (Begin Spellcasting)
    elseif (category ==  9) then -- Do nothing (Begin or Interrupt Item Usage)
    elseif (category == 11) then H.Action_Packet_TP_Move(action, actor_mob, target_pet_owner_mob, pet_owner_mob, is_offense, is_defense, mob_self_buff)
    elseif (category == 12) then -- Do nothing (Begin Ranged Attack)
    elseif (category == 13) then H.Ability.Pet_Action(action, actor_mob, is_offense)
    elseif (category == 14) then -- Do nothing (Unblinkable Job Ability); Waltz
    end
end

------------------------------------------------------------------------------------------------------
-- Handles the melee action packet. Sends the code down the offense or defense path.
------------------------------------------------------------------------------------------------------
---@param action table
---@param actor_mob table
---@param target_pet_owner_mob? table
---@param pet_owner_mob? table
---@param is_offense boolean
---@param is_defense boolean
------------------------------------------------------------------------------------------------------
H.Action_Packet_Melee = function(action, actor_mob, target_pet_owner_mob, pet_owner_mob, is_offense, is_defense)
    if is_offense then
        H.Melee.Action(action, actor_mob, pet_owner_mob, is_offense)
    elseif is_defense then
        H.Melee_Def.Action(action, actor_mob, target_pet_owner_mob, is_defense)
    end
end

------------------------------------------------------------------------------------------------------
-- Handles the spell action packet. Sends the code down the offense or defense path.
------------------------------------------------------------------------------------------------------
---@param action table
---@param actor_mob table
---@param target_pet_owner_mob? table
---@param pet_owner_mob? table
---@param is_offense boolean
---@param is_defense boolean
------------------------------------------------------------------------------------------------------
H.Action_Packet_Spell = function(action, actor_mob, target_pet_owner_mob, pet_owner_mob, is_offense, is_defense)
    if is_offense then
        H.Spell.Action(action, actor_mob, pet_owner_mob, is_offense)
    elseif is_defense then
        H.Spell_Def.Action(action, actor_mob, target_pet_owner_mob, is_defense)
    end
end

------------------------------------------------------------------------------------------------------
-- Handles the TP action packet. Sends the code down the offense or defense path.
------------------------------------------------------------------------------------------------------
---@param action table
---@param actor_mob table
---@param target_pet_owner_mob? table
---@param pet_owner_mob? table
---@param is_offense boolean
---@param is_defense boolean
---@param mob_self_buff boolean
------------------------------------------------------------------------------------------------------
H.Action_Packet_TP_Move = function(action, actor_mob, target_pet_owner_mob, pet_owner_mob, is_offense, is_defense, mob_self_buff)
    if is_offense then
        H.TP.Monster_Action(action, actor_mob, is_offense)
    elseif is_defense then
        H.TP_Def.Monster_Action(action, actor_mob, pet_owner_mob, is_defense)
    elseif mob_self_buff then
        H.TP_Def.Mob_Self_Target(action, actor_mob)
    end
end