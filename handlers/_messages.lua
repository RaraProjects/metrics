H.Messages = { }

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is a completely missed action.
------------------------------------------------------------------------------------------------------
---@param messageId Ashita.Message
---@return boolean
------------------------------------------------------------------------------------------------------
H.Messages.NoDamageMiss = function(messageId)
    return messageId == Ashita.Message.MELEE_MISS or
           messageId == Ashita.Message.WEAPONSKILL_MISS or
           messageId == Ashita.Message.RANGE_MISS or
           messageId == Ashita.Message.ABILITY_MISS or
           messageId == Ashita.Message.ABILITY_MISS_2
end

------------------------------------------------------------------------------------------------------
-- Certain messages may come in with damage, but it's not actually damage.
-- Need to set the damage to zero for these cases.
-- Counter isn't included here because that message is a spike message.
------------------------------------------------------------------------------------------------------
---@param messageId Ashita.Message
---@return boolean whether or not the damage from this should be treated as actual damage or not.
------------------------------------------------------------------------------------------------------
H.Messages.NoDamage = function(messageId)
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
---@param messageId Ashita.Message
---@return boolean
------------------------------------------------------------------------------------------------------
H.Messages.Damaging = function(messageId)
    return messageId == Ashita.Message.ABILITY_DAMAGE_1 or
           messageId == Ashita.Message.ABILITY_DAMAGE_2 or
           messageId == Ashita.Message.WEAPONSKILL_DAMAGE or
           messageId == Ashita.Message.WEAPONSKILL_HP_DRAIN or
           messageId == Ashita.Message.SPELL_DAMAGE_HIT or
           messageId == Ashita.Message.SPELL_MAGIC_BURST_PRIMARY or
           messageId == Ashita.Message.SPELL_MAGIC_BURST_ADDITIONAL or
           messageId == Ashita.Message.SPELL_HP_DRAIN or
           messageId == Ashita.Message.SPELL_MAGIC_BURST_HP_DRAIN or
           messageId == Ashita.Message.TAKES_DAMAGE
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to a magic burst or not.
------------------------------------------------------------------------------------------------------
---@param messageId Ashita.Message
---@return boolean
------------------------------------------------------------------------------------------------------
H.Messages.MagicBurst = function(messageId)
    return messageId == Ashita.Message.SPELL_MAGIC_BURST_PRIMARY or
           messageId == Ashita.Message.SPELL_MAGIC_BURST_ADDITIONAL or
           messageId == Ashita.Message.SPELL_MAGIC_BURST_ENFEEBLE_PRIMARY or
           messageId == Ashita.Message.SPELL_MAGIC_BURST_ENFEEBLE_PRIMARY_2 or
           messageId == Ashita.Message.SPELL_MAGIC_BURST_ENFEEBLE_ADDITIONAL or
           messageId == Ashita.Message.SPELL_MAGIC_BURST_ENFEEBLE_ADDITIONAL_2 or
           messageId == Ashita.Message.SPELL_MAGIC_BURST_HP_DRAIN or
           messageId == Ashita.Message.SPELL_MAGIC_BURST_MP_DRAIN or
           messageId == Ashita.Message.ABILITY_MAGIC_BURST
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to debuffs having no effect or not.
------------------------------------------------------------------------------------------------------
---@param messageId Ashita.Message
---@return boolean
------------------------------------------------------------------------------------------------------
H.Messages.NoEffect = function(messageId)
    return messageId == Ashita.Message.SPELL_NO_EFFECT or
           messageId == Ashita.Message.SPELL_EFFECT_FAIL or
           messageId == Ashita.Message.SPELL_COMPLETE_RESIST
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to debuffs getting resisted or not.
------------------------------------------------------------------------------------------------------
---@param messageId Ashita.Message
---@return boolean
------------------------------------------------------------------------------------------------------
H.Messages.Resist = function(messageId)
    return messageId == Ashita.Message.SPELL_RESIST or
           messageId == Ashita.Message.SPELL_RESIST_2
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to healing or not.
------------------------------------------------------------------------------------------------------
---@param messageId Ashita.Message
---@return boolean
------------------------------------------------------------------------------------------------------
H.Messages.Healing = function(messageId)
    return messageId == Ashita.Message.ABILITY_RECOVER_HP or
           messageId == Ashita.Message.ABILITY_RECOVER_HP_2 or
           messageId == Ashita.Message.ABILITY_RECOVER_HP_3 or
           messageId == Ashita.Message.ABILITY_RECOVER_HP_4 or
           messageId == Ashita.Message.SPELL_HP_RECOVERY_PRIMARY or
           messageId == Ashita.Message.SPELL_HP_RECOVERY_ADDITIONAL or
           messageId == Ashita.Message.HP_RECOVERED
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to buff or not.
------------------------------------------------------------------------------------------------------
---@param messageId Ashita.Message
---@return boolean
------------------------------------------------------------------------------------------------------
H.Messages.Buff = function(messageId)
    return messageId == Ashita.Message.SPELL_BUFF_PRIMARY or
           messageId == Ashita.Message.SPELL_BUFF_ADDITIONAL
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to debuff or not.
------------------------------------------------------------------------------------------------------
---@param messageId Ashita.Message
---@return boolean
------------------------------------------------------------------------------------------------------
H.Messages.Debuff = function(messageId)
    return messageId == Ashita.Message.WEAPONSKILL_DEBUFF or
           messageId == Ashita.Message.SPELL_ENFEEBLE_LAND or
           messageId == Ashita.Message.SPELL_ENFEEBLE_LAND_2 or
           messageId == Ashita.Message.SPELL_MAGIC_BURST_ENFEEBLE_PRIMARY or
           messageId == Ashita.Message.SPELL_MAGIC_BURST_ENFEEBLE_PRIMARY_2 or
           messageId == Ashita.Message.SPELL_MAGIC_BURST_ENFEEBLE_ADDITIONAL or
           messageId == Ashita.Message.SPELL_MAGIC_BURST_ENFEEBLE_ADDITIONAL_2 or
           messageId == Ashita.Message.ABILITY_ENFEEBLE_IS or
           messageId == Ashita.Message.TARGET_STATUS
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to dispel or not.
------------------------------------------------------------------------------------------------------
---@param messageId Ashita.Message
---@return boolean
------------------------------------------------------------------------------------------------------
H.Messages.Dispel = function(messageId)
    return messageId == Ashita.Message.ABILITY_REMOVE_STATUS_EFFECT_PRIMARY or
           messageId == Ashita.Message.ABILITY_REMOVE_STATUS_EFFECT_PRIMARY_2 or
           messageId == Ashita.Message.SPELL_REMOVE_STATUS_EFFECT_PRIMARY or
           messageId == Ashita.Message.SPELL_REMOVE_STATUS_EFFECT_PRIMARY_2 or
           messageId == Ashita.Message.SPELL_REMOVE_STATUS_EFFECT_ADDITIONAL or
           messageId == Ashita.Message.SPELL_REMOVE_STATUS_EFFECT_ADDITIONAL_2
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to HP Draining or not.
------------------------------------------------------------------------------------------------------
---@param messageId Ashita.Message
---@return boolean
------------------------------------------------------------------------------------------------------
H.Messages.HpDrain = function(messageId)
    return messageId == Ashita.Message.WEAPONSKILL_HP_DRAIN or
           messageId == Ashita.Message.SPELL_HP_DRAIN or
           messageId == Ashita.Message.SPELL_MAGIC_BURST_HP_DRAIN
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to MP Draining or not.
------------------------------------------------------------------------------------------------------
---@param messageId Ashita.Message
---@return boolean
------------------------------------------------------------------------------------------------------
H.Messages.MpDrain = function(messageId)
    return messageId == Ashita.Message.WEAPONSKILL_MP_DRAIN or
           messageId == Ashita.Message.SPELL_MP_DRAIN or
           messageId == Ashita.Message.SPELL_MAGIC_BURST_MP_DRAIN
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to TP Draining or not.
------------------------------------------------------------------------------------------------------
---@param messageId Ashita.Message
---@return boolean
------------------------------------------------------------------------------------------------------
H.Messages.TpDrain = function(messageId)
    return messageId == Ashita.Message.WEAPONSKILL_TP_DRAIN
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to TP Reduction or not.
------------------------------------------------------------------------------------------------------
---@param messageId Ashita.Message
---@return boolean
------------------------------------------------------------------------------------------------------
H.Messages.TpReduction = function(messageId)
    return messageId == Ashita.Message.ABILITY_TP_REDUCTION
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to Maneuver or not.
------------------------------------------------------------------------------------------------------
---@param messageId Ashita.Message
---@return boolean
------------------------------------------------------------------------------------------------------
H.Messages.Maneuver = function(messageId)
    return messageId == Ashita.Message.MANEUVER_NO_OVERLOAD or
           messageId == Ashita.Message.MANEUVER_OVERLOAD
end

------------------------------------------------------------------------------------------------------
-- Checks the action message to see if it is related to Phantom Roll or not.
------------------------------------------------------------------------------------------------------
---@param messageId Ashita.Message
---@return boolean
------------------------------------------------------------------------------------------------------
H.Messages.PhantomRoll = function(messageId)
    return messageId == Ashita.Message.PHANTOM_ROLL_FIRST or
           messageId == Ashita.Message.PHANTOM_ROLL_REROLL or
           messageId == Ashita.Message.PHANTOM_ROLL_EFFECT or
           messageId == Ashita.Message.PHANTOM_ROLL_NO_EFFECT or
           messageId == Ashita.Message.PHANTOM_ROLL_BUST
end