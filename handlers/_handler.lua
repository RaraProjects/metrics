H = {}
H.Offense = {}
H.Defense = {}

require("handlers.melee")
require("handlers.melee_def")
require("handlers.ranged")
require("handlers.ranged_def")
require("handlers.tp_action")
require("handlers.tp_action_def")
require("handlers.abilities")
require("handlers.spells")
require("handlers.spells_def")
require("handlers.unblinkable")
require("handlers.deaths")
require("handlers.items")

------------------------------------------------------------------------------------------------------
-- Sorts out the entities involved with the action packet.
------------------------------------------------------------------------------------------------------
H.Start_Action_Packet = function(packet)
    local action = Ashita.Packets.BuildAction(packet.data)
    if not action then Debug.Error.Add(Debug.Error.ERROR, "Packet In", "action was nil from Packets.Build_Action") return nil end

    local actor_mob = Ashita.Mob.GetMobByID(action.actor_id)
    if not actor_mob then Debug.Error.Add(Debug.Error.ERROR, "Packet In", "actor_mob was nil from Mob.Get_Mob_By_ID") return nil end

    local target_mob = Ashita.Packets.GetActionTarget(action)
    if not target_mob then Debug.Error.Add(Debug.Error.ERROR, "Packet In", "target_mob was nil from Mob.Get_Mob_By_ID") return nil end

    -- Need to refresh party for pet checks.
    Ashita.Party.Refresh()
    local pet_owner_mob = Ashita.Mob.PetOwner(actor_mob)           -- Is the actor the pet of someone in the party/alliance?
    local target_pet_owner_mob = Ashita.Mob.PetOwner(target_mob)   -- Is the target the pet of someone in the party/alliance?

    local is_offense    = false
    local is_defense    = false
    local mob_self_buff = false

    -- OFFENSE: The actor is an affiliate or the pet of an affiliate.
    if pet_owner_mob or Ashita.Party.IsAffiliate(actor_mob.name) then
        is_offense = true
        Timers.Reset(Timers.Enum.Names.AUTOPAUSE)
        Timers.Unpause(Timers.Enum.Names.PARSE)

    -- DEFENSE: The actor is not another player and the target is an affiliate or the pet of an affiliate.
    elseif not Ashita.Mob.IsPlayer(actor_mob) and (target_pet_owner_mob or Ashita.Party.IsAffiliate(target_mob.name)) then
        is_defense = true
        Timers.Reset(Timers.Enum.Names.AUTOPAUSE)
        Timers.Unpause(Timers.Enum.Names.PARSE)

    -- The actor is a mob claimed by the party and is doing something that is targetting itself.
    elseif Ashita.Mob.ClaimedByAffiliate(actor_mob) and actor_mob.name == target_mob.name then
        mob_self_buff = true

    -- Lurk mode detects all actions.
    elseif Parse.Config.Is_Lurking() then
        -- If the actor is player so log offense.
        if Ashita.Mob.IsPlayer(actor_mob) then
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
    if     category ==  1 then H.Action_Packet_Melee(action, actor_mob, target_pet_owner_mob, pet_owner_mob, is_offense, is_defense)
    elseif category ==  2 then H.Ranged.Action(action, actor_mob, is_offense)
    elseif category ==  3 then H.TP.Action(action, actor_mob, is_offense)
    elseif category ==  4 then H.Action_Packet_Spell(action, actor_mob, target_pet_owner_mob, pet_owner_mob, is_offense, is_defense)
    elseif category ==  5 then H.Item.Action(action, actor_mob)
    elseif category ==  6 then H.Ability.Action(action, actor_mob, is_offense)
    elseif category ==  7 then H.TP.Begin_Monster_Action(action, actor_mob, is_offense)
    elseif category ==  8 then -- Do nothing (Begin Spellcasting)
    elseif category ==  9 then -- Do nothing (Begin or Interrupt Item Usage)
    elseif category == 11 then H.Action_Packet_TP_Move(action, actor_mob, target_pet_owner_mob, pet_owner_mob, is_offense, is_defense, mob_self_buff)
    elseif category == 12 then -- Do nothing (Begin Ranged Attack)
    elseif category == 13 then H.Ability.PetAction(action, actor_mob, is_offense)
    elseif category == 14 then H.Ability.Action(action, actor_mob, is_offense)
    elseif category == 15 then H.Ability.Action(action, actor_mob, is_offense)
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
        H.MeleeDef.Action(action, actor_mob, target_pet_owner_mob, is_defense)
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
        H.SpellDef.Action(action, actor_mob, target_pet_owner_mob, is_defense)
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

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is a completely missed action.
------------------------------------------------------------------------------------------------------
---@param message_id integer
---@return boolean
------------------------------------------------------------------------------------------------------
H.Message_No_Damage_Miss = function(message_id)
    return message_id == Ashita.Message.MELEE_MISS or
           message_id == Ashita.Message.WEAPONSKILL_MISS or
           message_id == Ashita.Message.RANGE_MISS
end

------------------------------------------------------------------------------------------------------
-- Certain messages may come in with damage, but it's not actually damage.
-- Need to set the damage to zero for these cases.
-- Counter isn't included here because that message is a spike message.
------------------------------------------------------------------------------------------------------
---@param messageId Ashita.Message
---@return boolean whether or not the damage from this should be treated as actual damage or not.
------------------------------------------------------------------------------------------------------
H.MessageNoDamage = function(messageId)
    return messageId == Ashita.Message.PERFECT_DODGE or
           messageId == Ashita.Message.MELEE_MISS or
           messageId == Ashita.Message.WEAPONSKILL_MISS or
           messageId == Ashita.Message.MELEE_PARRY or
           messageId == Ashita.Message.THIRD_EYE_ANTICIPATION or
           messageId == Ashita.Message.RANGE_MISS or
           messageId == Ashita.Message.SHADOW_ABSORPTION or
           messageId == Ashita.Message.MOB_HEAL_MELEE or
           messageId == Ashita.Message.MOB_HEAL_RANGED
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to damage or not.
------------------------------------------------------------------------------------------------------
---@param message_id integer
---@return boolean
------------------------------------------------------------------------------------------------------
H.Message_Damaging = function(message_id)
    return message_id == Ashita.Message.ABILITY_DAMAGE_1 or
           message_id == Ashita.Message.ABILITY_DAMAGE_2 or
           message_id == Ashita.Message.WEAPONSKILL_DAMAGE or
           message_id == Ashita.Message.WEAPONSKILL_HP_DRAIN or
           message_id == Ashita.Message.SPELL_DAMAGE_HIT or
           message_id == Ashita.Message.SPELL_MAGIC_BURST_PRIMARY or
           message_id == Ashita.Message.SPELL_MAGIC_BURST_ADDITIONAL or
           message_id == Ashita.Message.SPELL_HP_DRAIN or
           message_id == Ashita.Message.SPELL_MAGIC_BURST_HP_DRAIN or
           message_id == Ashita.Message.TAKES_DAMAGE
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to a magic burst or not.
------------------------------------------------------------------------------------------------------
---@param message_id integer
---@return boolean
------------------------------------------------------------------------------------------------------
H.MessageMagicBurst = function(message_id)
    return message_id == Ashita.Message.SPELL_MAGIC_BURST_PRIMARY or
           message_id == Ashita.Message.SPELL_MAGIC_BURST_ADDITIONAL or
           message_id == Ashita.Message.SPELL_MAGIC_BURST_ENFEEBLE_PRIMARY or
           message_id == Ashita.Message.SPELL_MAGIC_BURST_ENFEEBLE_PRIMARY_2 or
           message_id == Ashita.Message.SPELL_MAGIC_BURST_ENFEEBLE_ADDITIONAL or
           message_id == Ashita.Message.SPELL_MAGIC_BURST_ENFEEBLE_ADDITIONAL_2 or
           message_id == Ashita.Message.SPELL_MAGIC_BURST_HP_DRAIN or
           message_id == Ashita.Message.SPELL_MAGIC_BURST_MP_DRAIN or
           message_id == Ashita.Message.ABILITY_MAGIC_BURST
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to debuffs having no effect or not.
------------------------------------------------------------------------------------------------------
---@param message_id integer
---@return boolean
------------------------------------------------------------------------------------------------------
H.MessageNoEffect = function(message_id)
    return message_id == Ashita.Message.SPELL_NO_EFFECT or
           message_id == Ashita.Message.SPELL_EFFECT_FAIL or
           message_id == Ashita.Message.SPELL_COMPLETE_RESIST
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to debuffs getting resisted or not.
------------------------------------------------------------------------------------------------------
---@param message_id integer
---@return boolean
------------------------------------------------------------------------------------------------------
H.Message_Resist = function(message_id)
    return message_id == Ashita.Message.SPELL_RESIST or
           message_id == Ashita.Message.SPELL_RESIST_2
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to healing or not.
------------------------------------------------------------------------------------------------------
---@param message_id integer
---@return boolean
------------------------------------------------------------------------------------------------------
H.Message_Healing = function(message_id)
    return
           message_id == Ashita.Message.ABILITY_RECOVER_HP or
           message_id == Ashita.Message.ABILITY_RECOVER_HP_2 or
           message_id == Ashita.Message.ABILITY_RECOVER_HP_3 or
           message_id == Ashita.Message.ABILITY_RECOVER_HP_4 or
           message_id == Ashita.Message.SPELL_HP_RECOVERY_PRIMARY or
           message_id == Ashita.Message.SPELL_HP_RECOVERY_ADDITIONAL or
           message_id == Ashita.Message.HP_RECOVERED
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to buff or not.
------------------------------------------------------------------------------------------------------
---@param message_id integer
---@return boolean
------------------------------------------------------------------------------------------------------
H.Message_Buff = function(message_id)
    return message_id == Ashita.Message.SPELL_BUFF_PRIMARY or
           message_id == Ashita.Message.SPELL_BUFF_ADDITIONAL
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to debuff or not.
------------------------------------------------------------------------------------------------------
---@param message_id integer
---@return boolean
------------------------------------------------------------------------------------------------------
H.Message_Debuff = function(message_id)
    return message_id == Ashita.Message.WEAPONSKILL_DEBUFF or
           message_id == Ashita.Message.SPELL_ENFEEBLE_LAND or
           message_id == Ashita.Message.SPELL_ENFEEBLE_LAND_2 or
           message_id == Ashita.Message.SPELL_MAGIC_BURST_ENFEEBLE_PRIMARY or
           message_id == Ashita.Message.SPELL_MAGIC_BURST_ENFEEBLE_PRIMARY_2 or
           message_id == Ashita.Message.SPELL_MAGIC_BURST_ENFEEBLE_ADDITIONAL or
           message_id == Ashita.Message.SPELL_MAGIC_BURST_ENFEEBLE_ADDITIONAL_2 or
           message_id == Ashita.Message.TARGET_STATUS
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to dispel or not.
------------------------------------------------------------------------------------------------------
---@param message_id integer
---@return boolean
------------------------------------------------------------------------------------------------------
H.MessageDispel = function(message_id)
    return message_id == Ashita.Message.ABILITY_REMOVE_STATUS_EFFECT_PRIMARY or
           message_id == Ashita.Message.ABILITY_REMOVE_STATUS_EFFECT_PRIMARY_2 or
           message_id == Ashita.Message.SPELL_REMOVE_STATUS_EFFECT_PRIMARY or
           message_id == Ashita.Message.SPELL_REMOVE_STATUS_EFFECT_PRIMARY_2 or
           message_id == Ashita.Message.SPELL_REMOVE_STATUS_EFFECT_ADDITIONAL or
           message_id == Ashita.Message.SPELL_REMOVE_STATUS_EFFECT_ADDITIONAL_2
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to HP Draining or not.
------------------------------------------------------------------------------------------------------
---@param message_id integer
---@return boolean
------------------------------------------------------------------------------------------------------
H.Message_HP_Drain = function(message_id)
    return message_id == Ashita.Message.WEAPONSKILL_HP_DRAIN or
           message_id == Ashita.Message.SPELL_HP_DRAIN or
           message_id == Ashita.Message.SPELL_MAGIC_BURST_HP_DRAIN
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to MP Draining or not.
------------------------------------------------------------------------------------------------------
---@param message_id integer
---@return boolean
------------------------------------------------------------------------------------------------------
H.MessageMPDrain = function(message_id)
    return message_id == Ashita.Message.WEAPONSKILL_MP_DRAIN or
           message_id == Ashita.Message.SPELL_MP_DRAIN or
           message_id == Ashita.Message.SPELL_MAGIC_BURST_MP_DRAIN
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to TP Draining or not.
------------------------------------------------------------------------------------------------------
---@param message_id integer
---@return boolean
------------------------------------------------------------------------------------------------------
H.Message_TP_Drain = function(message_id)
    return message_id == Ashita.Message.WEAPONSKILL_TP_DRAIN
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to TP Reduction or not.
------------------------------------------------------------------------------------------------------
---@param message_id integer
---@return boolean
------------------------------------------------------------------------------------------------------
H.Message_TP_Reduction = function(message_id)
    return message_id == Ashita.Message.ABILITY_TP_REDUCTION
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to Maneuver or not.
------------------------------------------------------------------------------------------------------
---@param message_id integer
---@return boolean
------------------------------------------------------------------------------------------------------
H.Message_Maneuver = function(message_id)
    return message_id == Ashita.Message.MANEUVER_NO_OVERLOAD or
           message_id == Ashita.Message.MANEUVER_OVERLOAD
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to Phantom Roll or not.
------------------------------------------------------------------------------------------------------
---@param message_id integer
---@return boolean
------------------------------------------------------------------------------------------------------
H.Message_Phantom_Roll = function(message_id)
    return message_id == Ashita.Message.PHANTOM_ROLL_FIRST or
           message_id == Ashita.Message.PHANTOM_ROLL_REROLL or
           message_id == Ashita.Message.PHANTOM_ROLL_EFFECT or
           message_id == Ashita.Message.PHANTOM_ROLL_NO_EFFECT or
           message_id == Ashita.Message.PHANTOM_ROLL_BUST
end

------------------------------------------------------------------------------------------------------
-- Increment Grand Totals.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param owner_mob? table
------------------------------------------------------------------------------------------------------
H.Offense.GrandTotals = function(audits, damage, owner_mob)
    DB.Data.Update(DB.Update_Mode.INC, damage, audits, DB.Trackable.TOTAL_DAMAGE, DB.Metric.TOTAL)
    DB.Data.Update(DB.Update_Mode.INC, damage, audits, DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN, DB.Metric.TOTAL)
    DB.Total_Damage = DB.Total_Damage + damage
    DB.Total_Damage_No_Skillchain = DB.Total_Damage_No_Skillchain + damage
    if owner_mob then DB.Data.Update(DB.Update_Mode.INC, damage, audits, DB.Trackable.PET_OVERALL, DB.Metric.TOTAL) end
end

------------------------------------------------------------------------------------------------------
-- Tracks over time recent accuracy.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param hit boolean
---@param owner_mob? table
------------------------------------------------------------------------------------------------------
H.Offense.UpdateRecentAccuracy = function(audits, hit, owner_mob)
    if not owner_mob then DB.Accuracy.Update(audits.player_name, hit) end
end

------------------------------------------------------------------------------------------------------
-- Hit.
-- Can't just used DB.Data.Update_Damage for this because I can call this multiple times per packet.
-- The total damage will be incremented too much if that happens.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param trackable string
---@param damage integer
---@param critical_hit? boolean
------------------------------------------------------------------------------------------------------
H.Offense.Hit = function(audits, trackable, damage, critical_hit)
    DB.Data.Update_Damage_Basic(audits, trackable, damage, critical_hit)
end

------------------------------------------------------------------------------------------------------
-- Miss.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param trackable string
------------------------------------------------------------------------------------------------------
H.Offense.Miss = function(audits, trackable)
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS_ON_TARGET)
end

------------------------------------------------------------------------------------------------------
-- Player attacks absorbed by shadows. These are counted as hits in terms of accuracy.
-- No effect on recent accuracy tracking.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param trackable string
---@param metric string
------------------------------------------------------------------------------------------------------
H.Offense.NoDamageHit = function(audits, trackable, metric)
    H.Offense.Hit(audits, trackable, 0)
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.HITS_ON_TARGET)
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, metric)
end

------------------------------------------------------------------------------------------------------
-- Healing the mob with a physical hit.
-- Accuracy doesn't suffer because this isn't a miss. It just heals the mob.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param trackable string player melee or pet melee.
---@param damage integer
------------------------------------------------------------------------------------------------------
H.Offense.MobHeal = function(audits, trackable, damage)
    H.Offense.Hit(audits, trackable, 0)
    DB.Data.Update(DB.Update_Mode.INC,      1, audits, trackable, DB.Metric.HITS_ON_TARGET)
    DB.Data.Update(DB.Update_Mode.INC, damage, audits, trackable, DB.Metric.MOB_HEALING)
end

------------------------------------------------------------------------------------------------------
-- Cataloged action hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param trackable string
---@param damage integer
---@param action_name string
---@param critical_hit? boolean
------------------------------------------------------------------------------------------------------
H.Offense.CatalogHit = function(audits, trackable, damage, action_name, critical_hit)
    DB.Catalog.Update_Damage(audits.player_name, audits.target_name, trackable, damage, action_name, audits.pet_name, critical_hit)
end

------------------------------------------------------------------------------------------------------
-- Cataloged action no damage hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param trackable string
---@param action_name string
------------------------------------------------------------------------------------------------------
H.Offense.CatalogNoDamageHit = function(audits, trackable, action_name)
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.HITS_ON_TARGET)
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS_ON_TARGET)
    DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, action_name, DB.Metric.HITS_ON_TARGET)
    DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, action_name, DB.Metric.ATTEMPTS_ON_TARGET)
end

------------------------------------------------------------------------------------------------------
-- Action used outside of the target loop.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param trackable string
---@param hit boolean
---@param mp_spent? integer If the action is spell
------------------------------------------------------------------------------------------------------
H.Offense.ActionUsed = function(audits, trackable, action_name, hit, mp_spent)
    if hit then
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.HITS_ON_USE)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, action_name, DB.Metric.HITS_ON_USE)
    end
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS_ON_USE)
    DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, action_name, DB.Metric.ATTEMPTS_ON_USE)

    if mp_spent then
        DB.Data.Update(DB.Update_Mode.INC, mp_spent, audits, trackable, DB.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, mp_spent, audits, trackable, action_name, DB.Metric.MP_SPENT)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Increments weaponskill hits.
-- ------------------------------------------------------------------------------------------------------
---@param audits table
---@param tp? integer
---@param ws_name string
---@param trackable string
---@return integer
-- ------------------------------------------------------------------------------------------------------
H.Offense.Weaponskill_TP = function(audits, tp, ws_name, trackable)
    if not tp or tp < 0 then tp = 0 end
    if tp > 3000 then tp = 3000 end
    DB.Data.Update(DB.Update_Mode.INC, tp, audits, trackable, DB.Metric.TP_SPENT)
    DB.Catalog.Update_Metric(DB.Update_Mode.INC, tp, audits, trackable, ws_name, DB.Metric.TP_SPENT)
    return tp
end

------------------------------------------------------------------------------------------------------
-- Minimum and maximum melee values.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param trackable string
---@param damage integer whether or not the animation is a NIN auto throwing attack.
---@param was_critical_hit? boolean
------------------------------------------------------------------------------------------------------
H.Offense.MinMax = function(audits, trackable, damage, was_critical_hit)
    local metric_min = DB.Metric.MIN
    local metric_max = DB.Metric.MAX

    if was_critical_hit then
        metric_min = DB.Metric.CRITICAL_MIN
        metric_max = DB.Metric.CRITICAL_MAX
    end

    if damage > 0 and (damage < DB.Data.Get(audits.player_name, trackable, metric_min, audits.target_name)) then
        DB.Data.Update(DB.Update_Mode.SET, damage, audits, trackable, metric_min)
    end
    if damage > DB.Data.Get(audits.player_name, trackable, metric_max, audits.target_name) then
        DB.Data.Update(DB.Update_Mode.SET, damage, audits, trackable, metric_max)
    end
end

------------------------------------------------------------------------------------------------------
-- Increment Grand Totals.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param owner_mob? table
------------------------------------------------------------------------------------------------------
H.Defense.GrandTotals = function(audits, damage, owner_mob)
    if owner_mob then
        H.Offense.Hit(audits, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET, damage)
    else
        H.Offense.Hit(audits, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, damage)
    end
end

------------------------------------------------------------------------------------------------------
-- Check for a full mitigation attempt.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param trackable string
---@param damage integer
---@param message_id number the ID of the entity animation when taking a hit.
---@param message_check integer
---@param no_damage_hit? boolean If this is set hits will increment with 0 damage.
---@return boolean
------------------------------------------------------------------------------------------------------
H.Defense.Mitigation = function(audits, trackable, damage, message_id, message_check, no_damage_hit)
    local mitigation_occurred = false
    if message_id == message_check then
        H.Offense.Hit(audits, trackable, damage)
        if no_damage_hit then DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.HITS_ON_TARGET) end
        mitigation_occurred = true
    else
        H.Offense.Miss(audits, trackable)
    end
    return mitigation_occurred
end


------------------------------------------------------------------------------------------------------
-- Check for critical damage taken.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param message_id number the ID of the entity animation when taking a hit.
------------------------------------------------------------------------------------------------------
H.Defense.Crit = function(audits, damage, message_id)
    if message_id == Ashita.Message.CRITICAL_HIT then
        H.Offense.Hit(audits, DB.Trackable.DEF_CRITICAL, damage, true)
    else
        H.Offense.Miss(audits, DB.Trackable.DEF_CRITICAL)
    end
end