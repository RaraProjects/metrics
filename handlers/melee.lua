H.Melee = {}

-- ------------------------------------------------------------------------------------------------------
-- Parse the melee attack packet.
-- ------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param owner_mob table|nil (if pet) the mob data of the entity's owner.
---@param log_offense boolean if this action should actually be logged.
-- ------------------------------------------------------------------------------------------------------
H.Melee.Action = function(action, actor_mob, owner_mob, log_offense)
	if not log_offense then return nil end
	local result, target
	local damage = 0

	for target_index, target_value in pairs(action.targets) do
		for action_index, _ in pairs(target_value.actions) do
			result = action.targets[target_index].actions[action_index]
			target = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)
			if not target then target = {name = DB.Enum.Values.DEBUG} end
            if target.spawn_flags == Ashita.Enum.Spawn_Flags.MOB then DB.Lists.Check.Mob_Exists(target.name) end
			damage = damage + H.Melee.Parse(result, actor_mob.name, target.name, owner_mob)
		end
	end

    H.Melee.Blog(actor_mob, owner_mob, damage)
end

------------------------------------------------------------------------------------------------------
-- Set data for a melee action.
-- NOTES:
-- message 				https://github.com/Windower/Lua/wiki/Message-IDs
-- has_add_effect		boolean
-- add_effect_animation	https://github.com/Windower/Lua/wiki/Additional-Effect-IDs
-- Enspell element
-- add_effect_message	229: comes up with Ygnas bonus attack
-- add_effect_param		enspell damage
-- spike_effect_param	0: consistently on MNK vs Apex bats
-- spike_effect_effect	
-- effect 				2: killing blow
-- 						4: counter? (probably not)
-- stagger 				animation the target does when being hit
-- reaction 			8: hit; consistently on MNK vs Apex bats
-- 						9: miss?; very rarely on MNK vs Apex bats
------------------------------------------------------------------------------------------------------
---@param result table contains all the information for the action.
---@param player_name string name of the player that did the action.
---@param target_name string name of the target that received the action.
---@param owner_mob? table if the action was from a pet then this will hold the owner's mob.
---@return number
------------------------------------------------------------------------------------------------------
H.Melee.Parse = function(result, player_name, target_name, owner_mob)
    _Debug.Packet.Add_Action(player_name, target_name, "Melee", result)
    local animation_id = result.animation
    local effect_animation_id = result.add_effect_animation
    local damage = result.param
    local message_id = result.message
    local effect_message_id = result.add_effect_message
    local throwing = false

    local melee_type_broad = DB.Enum.Trackable.MELEE
    local melee_type_discrete = H.Melee.Melee_Type(animation_id)

    -- Need special handling for pets
    local pet_name
    if owner_mob then
        melee_type_broad = DB.Enum.Trackable.PET_MELEE
        melee_type_discrete = DB.Enum.Trackable.PET_MELEE_DISCRETE
        pet_name = player_name
        player_name = owner_mob.name
    end

    local audits = {
        player_name = player_name,
        target_name = target_name,
        pet_name = pet_name,
    }

    -- No damage Messages
    local no_damage = H.Melee.No_Damage_Messages(message_id)

    -- Totals
    H.Melee.Totals(audits, damage, melee_type_discrete, no_damage)

    -- Pet Totals
    H.Melee.Pet_Total(owner_mob, audits, damage, no_damage)

    -- Melee or Throwing Totals and Counts
    throwing = H.Melee.Animation(animation_id, audits, damage, melee_type_broad, throwing, no_damage)

    -- Min/Max
    H.Melee.Min_Max(throwing, damage, audits, melee_type_broad, no_damage)

    -- Enspell
    local add_effect_damage = result.add_effect_param
    if add_effect_damage > 0 then H.Melee.Additional_Effect(audits, add_effect_damage, effect_message_id, effect_animation_id, no_damage) end

    -- Accuracy, crits, absorbed by shadows, etc.
    H.Melee.Message(audits, damage, message_id, melee_type_broad, melee_type_discrete)

    -- Spike damage
    H.Melee.Spikes(audits, result)

    return damage
end

-- ------------------------------------------------------------------------------------------------------
-- Adds melee damage to the battle log.
-- ------------------------------------------------------------------------------------------------------
---@param actor_mob table the mob data of the entity performing the action.
---@param owner_mob table|nil (if pet) the mob data of the entity's owner.
---@param damage number
-- ------------------------------------------------------------------------------------------------------
H.Melee.Blog = function(actor_mob, owner_mob, damage)
    if Metrics.Blog.Flags.Melee then
        local blog_name = actor_mob.name
        if owner_mob then
            blog_name = owner_mob.name .. " (" .. actor_mob.name .. ")"
        end
        Blog.Add(blog_name, DB.Enum.Trackable.MELEE, damage)
    end
end

------------------------------------------------------------------------------------------------------
-- Map an animation to a discrete type of melee action.
------------------------------------------------------------------------------------------------------
---@param animation_id number represents, primary attack, offhand attack, kicking, etc.
---@return string
------------------------------------------------------------------------------------------------------
H.Melee.Melee_Type = function(animation_id)
    if animation_id == Ashita.Enum.Animation.MELEE_MAIN then
        return H.Trackable.MELEE_MAIN
    elseif animation_id == Ashita.Enum.Animation.MELEE_OFFHAND then
        return H.Trackable.MELEE_OFFHAND
    elseif animation_id == Ashita.Enum.Animation.MELEE_KICK or animation_id == Ashita.Enum.Animation.MELEE_KICK2 then
        return H.Trackable.MELEE_KICK
    elseif animation_id == Ashita.Enum.Animation.DAKEN then
        return H.Trackable.THROWING
    else
        return H.Trackable.DEFAULT
    end
end

------------------------------------------------------------------------------------------------------
-- Certain messages may come in with damage, but it's not actually damage.
-- Need to set the damage to zero for these cases.
------------------------------------------------------------------------------------------------------
---@param message_id number
---@return boolean whether or not the damage from this should be treated as actual damage or not.
------------------------------------------------------------------------------------------------------
H.Melee.No_Damage_Messages = function(message_id)
    return message_id == Ashita.Enum.Message.DODGE or
           message_id == Ashita.Enum.Message.MISS or
           message_id == Ashita.Enum.Message.SHADOWS or
           message_id == Ashita.Enum.Message.MOBHEAL373
end

------------------------------------------------------------------------------------------------------
-- Increment Grand Totals.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param melee_type_discrete string main-hand, off-hand, etc.
---@param no_damage? boolean whether or not the damage from this should be treated as actual damage or not.
------------------------------------------------------------------------------------------------------
H.Melee.Totals = function(audits, damage, melee_type_discrete, no_damage)
    if no_damage then damage = 0 end
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.TOTAL, H.Metric.TOTAL)
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.TOTAL_NO_SC, H.Metric.TOTAL)
    DB.Data.Update(H.Mode.INC, damage, audits, melee_type_discrete, H.Metric.TOTAL)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.COUNT)
end

------------------------------------------------------------------------------------------------------
-- Increment total pet damage.
------------------------------------------------------------------------------------------------------
---@param owner_mob table|nil if the action was from a pet then this will hold the owner's mob.
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param no_damage? boolean whether or not the damage from this should be treated as actual damage or not.
------------------------------------------------------------------------------------------------------
H.Melee.Pet_Total = function(owner_mob, audits, damage, no_damage)
    if no_damage then damage = 0 end
    if owner_mob then
        DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.PET, H.Metric.TOTAL)
    end
end

------------------------------------------------------------------------------------------------------
-- The melee's animation to determine whether this is a regular melee of throwing melee.
------------------------------------------------------------------------------------------------------
---@param animation_id number this determines if the melee is main-hand, off-hand, etc.
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param melee_type_broad string player melee or pet melee.
---@param throwing boolean whether or not the animation is a NIN auto throwing attack.
---@param no_damage? boolean whether or not the damage from this should be treated as actual damage or not.
---@return boolean throwing whether or not the animation is a NIN auto throwing attack.
------------------------------------------------------------------------------------------------------
H.Melee.Animation = function(animation_id, audits, damage, melee_type_broad, throwing, no_damage)
    if no_damage then damage = 0 end
    if animation_id >= Ashita.Enum.Animation.MELEE_MAIN and animation_id < Ashita.Enum.Animation.DAKEN then
        DB.Data.Update(H.Mode.INC, damage, audits, melee_type_broad, H.Metric.TOTAL)
        DB.Data.Update(H.Mode.INC,      1, audits, melee_type_broad, H.Metric.COUNT)
    elseif animation_id == Ashita.Enum.Animation.DAKEN then
        throwing = true
        DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.RANGED, H.Metric.TOTAL)
        DB.Data.Update(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.COUNT)
    else
        _Debug.Error.Add("Melee.Animation: {" .. tostring(audits.player_name) .. "} Unhandled animation: " .. tostring(animation_id))
    end
    return throwing
end

------------------------------------------------------------------------------------------------------
-- Handle the various metrics based on message.
-- The range attacks here are specifically the NIN auto throwing attacks while engaged.
-- https://github.com/Windower/Lua/wiki/Message-IDs
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param message_id number numberic identifier for system chat messages.
---@param melee_type_broad string player melee or pet melee.
---@param melee_type_discrete string main-hand, off-hand, etc.
------------------------------------------------------------------------------------------------------
H.Melee.Message = function(audits, damage, message_id, melee_type_broad, melee_type_discrete)
    if message_id == Ashita.Enum.Message.HIT then
        H.Melee.Hit(audits, melee_type_broad, melee_type_discrete)
    elseif message_id == Ashita.Enum.Message.MISS then
        H.Melee.Miss(audits, melee_type_broad)
    elseif message_id == Ashita.Enum.Message.CRIT then
        H.Melee.Crit(audits, damage, melee_type_broad, melee_type_discrete)
    elseif message_id == Ashita.Enum.Message.SHADOWS then
        H.Melee.Shadows(audits, melee_type_broad, melee_type_discrete)
    elseif message_id == Ashita.Enum.Message.DODGE then
        H.Melee.Dodge(audits, melee_type_broad, melee_type_discrete)
    elseif message_id == Ashita.Enum.Message.MOBHEAL3 or message_id == Ashita.Enum.Message.MOBHEAL373 then
        H.Melee.Mob_Heal(audits, damage, melee_type_broad, melee_type_discrete)
    elseif message_id == Ashita.Enum.Message.RANGEHIT then
        H.Melee.Daken_Hit(audits)
    elseif message_id == Ashita.Enum.Message.RANGEMISS then
        H.Melee.Daken_Miss(audits)
    elseif message_id == Ashita.Enum.Message.SQUARE then
        H.Melee.Daken_Square(audits)
    elseif message_id == Ashita.Enum.Message.TRUE then
        H.Melee.Daken_Truestrike(audits)
    elseif message_id == Ashita.Enum.Message.RANGECRIT then
        H.Melee.Daken_Crit(audits, damage)
    else
        _Debug.Error.Add("Melee.Message: {" .. tostring(audits.player_name) .. "} Unhandled Melee Nuance " .. tostring(message_id))
    end
end

------------------------------------------------------------------------------------------------------
-- Regular melee hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param melee_type_broad string player melee or pet melee.
---@param melee_type_discrete string main-hand, off-hand, etc.
------------------------------------------------------------------------------------------------------
H.Melee.Hit = function(audits, melee_type_broad, melee_type_discrete)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.HIT_COUNT)
    if melee_type_broad ~= H.Trackable.PET_MELEE then DB.Accuracy.Update(audits.player_name, true) end
end

------------------------------------------------------------------------------------------------------
-- Regular melee miss.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param melee_type_broad string player melee or pet melee.
------------------------------------------------------------------------------------------------------
H.Melee.Miss = function(audits, melee_type_broad)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_broad, H.Metric.MISS_COUNT)
    if melee_type_broad ~= H.Trackable.PET_MELEE then DB.Accuracy.Update(audits.player_name, false) end
end

------------------------------------------------------------------------------------------------------
-- Regular melee critical hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param melee_type_broad string player melee or pet melee.
---@param melee_type_discrete string main-hand, off-hand, etc.
------------------------------------------------------------------------------------------------------
H.Melee.Crit = function(audits, damage, melee_type_broad, melee_type_discrete)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.CRIT_COUNT)
    DB.Data.Update(H.Mode.INC, damage, audits, melee_type_broad,    H.Metric.CRIT_DAMAGE)
    if melee_type_broad ~= H.Trackable.PET_MELEE then DB.Accuracy.Update(audits.player_name, true) end
end

------------------------------------------------------------------------------------------------------
-- Regular melee absorbed by shadows.
-- These are counted as hits in terms of accuracy.
-- Sometimes you just need to melee down through shadows. I don't think your accuracy should suffer.
-- If you actually miss, only then should the accuracy suffer.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param melee_type_broad string player melee or pet melee.
---@param melee_type_discrete string main-hand, off-hand, etc.
------------------------------------------------------------------------------------------------------
H.Melee.Shadows = function(audits, melee_type_broad, melee_type_discrete)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.SHADOWS)
end

------------------------------------------------------------------------------------------------------
-- Regular melee evaded by Pefect Dodge.
-- Remove the count so perfect dodge isn't penalized.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param melee_type_broad string player melee or pet melee.
---@param melee_type_discrete string main-hand, off-hand, etc.
------------------------------------------------------------------------------------------------------
H.Melee.Dodge = function(audits, melee_type_broad, melee_type_discrete)
    DB.Data.Update(H.Mode.INC,     -1, audits, melee_type_broad,    H.Metric.COUNT)
    DB.Data.Update(H.Mode.INC,     -1, audits, melee_type_discrete, H.Metric.COUNT)
end

------------------------------------------------------------------------------------------------------
-- Healing the mob with a melee hit.
-- Accuracy doesn't suffer because this isn't a miss. It just heals the mob.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param melee_type_broad string player melee or pet melee.
---@param melee_type_discrete string main-hand, off-hand, etc.
------------------------------------------------------------------------------------------------------
H.Melee.Mob_Heal = function(audits, damage, melee_type_broad, melee_type_discrete)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC, damage, audits, melee_type_broad,    H.Metric.MOB_HEAL)
end

------------------------------------------------------------------------------------------------------
-- Daken regular hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
------------------------------------------------------------------------------------------------------
H.Melee.Daken_Hit = function(audits)
    DB.Data.Update(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.HIT_COUNT)
    DB.Accuracy.Update(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Daken square hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
------------------------------------------------------------------------------------------------------
H.Melee.Daken_Square = function(audits)
    DB.Data.Update(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.HIT_COUNT)
    DB.Accuracy.Update(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Daken truestrike hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
------------------------------------------------------------------------------------------------------
H.Melee.Daken_Truestrike = function(audits)
    DB.Data.Update(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.HIT_COUNT)
    DB.Accuracy.Update(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Daken miss.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
------------------------------------------------------------------------------------------------------
H.Melee.Daken_Miss = function(audits)
    DB.Data.Update(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.MISS_COUNT)
    DB.Accuracy.Update(audits.player_name, false)
end

------------------------------------------------------------------------------------------------------
-- Daken critical hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
------------------------------------------------------------------------------------------------------
H.Melee.Daken_Crit = function(audits, damage)
    DB.Data.Update(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.CRIT_COUNT)
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.RANGED, H.Metric.CRIT_DAMAGE)
    DB.Accuracy.Update(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Minimum and maximum melee values.
------------------------------------------------------------------------------------------------------
---@param throwing boolean whether or not the animation is a NIN auto throwing attack.
---@param damage number
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param melee_type_broad string player melee or pet melee.
---@param no_damage? boolean whether or not the damage from this should be treated as actual damage or not.
------------------------------------------------------------------------------------------------------
H.Melee.Min_Max = function(throwing, damage, audits, melee_type_broad, no_damage)
    if no_damage then damage = 0 end
    if throwing then
        if damage > 0 and (damage < DB.Data.Get(audits.player_name, H.Trackable.RANGED, H.Metric.MIN)) then DB.Data.Update(H.Mode.SET, damage, audits, H.Trackable.RANGED, H.Metric.MIN) end
        if damage > DB.Data.Get(audits.player_name, H.Trackable.RANGED, H.Metric.MAX) then DB.Data.Update(H.Mode.SET, damage, audits, H.Trackable.RANGED, H.Metric.MAX) end
    else
        if damage > 0 and (damage < DB.Data.Get(audits.player_name, melee_type_broad, H.Metric.MIN)) then DB.Data.Update(H.Mode.SET, damage, audits, melee_type_broad, H.Metric.MIN) end
        if damage > DB.Data.Get(audits.player_name, melee_type_broad, H.Metric.MAX) then DB.Data.Update(H.Mode.SET, damage, audits, melee_type_broad, H.Metric.MAX) end
    end
end

------------------------------------------------------------------------------------------------------
-- Captures additional effects from melee.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param value number how much of the thing you did.
---@param message_id number numberic identifier for system chat messages.
---@param effect_animation_id number the element of the enspell.
---@param no_damage? boolean whether or not the damage from this should be treated as actual damage or not.
------------------------------------------------------------------------------------------------------
H.Melee.Additional_Effect = function(audits, value, message_id, effect_animation_id, no_damage)
    -- Only add additional damage to the damage totals.
    if message_id == Ashita.Enum.Message.ENSPELL then
        if no_damage then value = 0 end
        DB.Data.Update(H.Mode.INC, value, audits, H.Trackable.MAGIC,       H.Metric.TOTAL)
        DB.Data.Update(H.Mode.INC, value, audits, H.Trackable.TOTAL,       H.Metric.TOTAL)       -- It's an extra step to add additional enspell damage to total.
        DB.Data.Update(H.Mode.INC, value, audits, H.Trackable.TOTAL_NO_SC, H.Metric.TOTAL)       -- It's an extra step to add additional enspell damage to total.
        DB.Data.Update(H.Mode.INC,     1, audits, H.Trackable.ENSPELL,     H.Metric.HIT_COUNT)
        DB.Data.Update(H.Mode.INC,     1, audits, H.Trackable.MAGIC,       H.Metric.COUNT)       -- Used to flag that data is availabel for show in Focus.
        if Res.Spells.Get_Enspell_Type(effect_animation_id) then
            local enspell_name = Res.Spells.Get_Enspell_Type(effect_animation_id)
            DB.Catalog.Update_Damage(audits.player_name, audits.target_name, H.Trackable.ENSPELL, value, enspell_name)
            DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, H.Trackable.ENSPELL, enspell_name, H.Metric.HIT_COUNT)
        end
    elseif message_id == Ashita.Enum.Message.ENDRAIN then
        DB.Data.Update(H.Mode.INC, value, audits, H.Trackable.ENDRAIN,     H.Metric.TOTAL)
        DB.Data.Update(H.Mode.INC, value, audits, H.Trackable.ENDRAIN,     H.Metric.HIT_COUNT)
    elseif message_id == Ashita.Enum.Message.ENASPIR then
        DB.Data.Update(H.Mode.INC, value, audits, H.Trackable.ENASPIR,     H.Metric.TOTAL)
        DB.Data.Update(H.Mode.INC, value, audits, H.Trackable.ENASPIR,     H.Metric.HIT_COUNT)
    end
end

------------------------------------------------------------------------------------------------------
-- Detects how much damage the player took from the spike damage.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param result table action data
------------------------------------------------------------------------------------------------------
H.Melee.Spikes = function(audits, result)
    local spike_effect = result.has_spike_effect
    if spike_effect and not audits.pet_name then
        local damage = result.spike_effect_param
        local spike_message = result.spike_effect_message
        if spike_message == Ashita.Enum.Message.SPIKE_DMG then
            DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.DAMAGE_TAKEN_TOTAL, H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.SPELL_DMG_TAKEN, H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.INCOMING_SPIKE_DMG, H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC, 1     , audits, H.Trackable.INCOMING_SPIKE_DMG, H.Metric.HIT_COUNT)
        end
    end
end