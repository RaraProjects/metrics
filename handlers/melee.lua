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
	if not log_offense then return end
	local result, target
	local damage = 0

	for target_index, target_value in pairs(action.targets) do
		for action_index, _ in pairs(target_value.actions) do
			result = action.targets[target_index].actions[action_index]
			target = A.Mob.Get_Mob_By_ID(action.targets[target_index].id)
			if not target then target = {name = Model.Enum.Index.DEBUG} end
            if target.spawn_flags == A.Enum.Spawn_Flags.MOB then Model.Util.Check_Mob_List(target.name) end
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
    _Debug.Packet.Add(player_name, target_name, "Melee", result)
    local animation_id = result.animation
    local effect_animation_id = result.add_effect_animation
    local damage = result.param
    local message_id = result.message
    local effect_message_id = result.add_effect_message
    local throwing = false

    local melee_type_broad = Model.Enum.Trackable.MELEE
    local melee_type_discrete = H.Melee.Melee_Type(animation_id)

    -- Need special handling for pets
    local pet_name
    if owner_mob then
        melee_type_broad = Model.Enum.Trackable.PET_MELEE
        melee_type_discrete = Model.Enum.Trackable.PET_MELEE_DISCRETE
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

    local spikes = result.spike_effect_effect

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
        Blog.Add(blog_name, Model.Enum.Trackable.MELEE, damage)
    end
end

------------------------------------------------------------------------------------------------------
-- Map an animation to a discrete type of melee action.
------------------------------------------------------------------------------------------------------
---@param animation_id number represents, primary attack, offhand attack, kicking, etc.
---@return string
------------------------------------------------------------------------------------------------------
H.Melee.Melee_Type = function(animation_id)
    if animation_id == A.Enum.Animation.MELEE_MAIN then
        return H.Trackable.MELEE_MAIN
    elseif animation_id == A.Enum.Animation.MELEE_OFFHAND then
        return H.Trackable.MELEE_OFFHAND
    elseif animation_id == A.Enum.Animation.MELEE_KICK or animation_id == A.Enum.Animation.MELEE_KICK2 then
        return H.Trackable.MELEE_KICK
    elseif animation_id == A.Enum.Animation.DAKEN then
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
    return message_id == A.Enum.Message.DODGE or
           message_id == A.Enum.Message.MISS or
           message_id == A.Enum.Message.SHADOWS or
           message_id == A.Enum.Message.MOBHEAL373
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
    Model.Update.Data(H.Mode.INC, damage, audits, H.Trackable.TOTAL, H.Metric.TOTAL)
    Model.Update.Data(H.Mode.INC, damage, audits, H.Trackable.TOTAL_NO_SC, H.Metric.TOTAL)
    Model.Update.Data(H.Mode.INC, damage, audits, melee_type_discrete, H.Metric.TOTAL)
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.COUNT)
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
        Model.Update.Data(H.Mode.INC, damage, audits, H.Trackable.PET, H.Metric.TOTAL)
    end
end

------------------------------------------------------------------------------------------------------
-- The melee's animation to determine whether this is a regular melee of throwing melee.
------------------------------------------------------------------------------------------------------
---comment
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
    if animation_id >= A.Enum.Animation.MELEE_MAIN and animation_id < A.Enum.Animation.DAKEN then
        Model.Update.Data(H.Mode.INC, damage, audits, melee_type_broad, H.Metric.TOTAL)
        Model.Update.Data(H.Mode.INC,      1, audits, melee_type_broad, H.Metric.COUNT)
    elseif animation_id == A.Enum.Animation.DAKEN then
        throwing = true
        Model.Update.Data(H.Mode.INC, damage, audits, H.Trackable.RANGED, H.Metric.TOTAL)
        Model.Update.Data(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.COUNT)
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
    if message_id == A.Enum.Message.HIT then
        H.Melee.Hit(audits, melee_type_broad, melee_type_discrete)
    elseif message_id == A.Enum.Message.MISS then
        H.Melee.Miss(audits, melee_type_broad)
    elseif message_id == A.Enum.Message.CRIT then
        H.Melee.Crit(audits, damage, melee_type_broad, melee_type_discrete)
    elseif message_id == A.Enum.Message.SHADOWS then
        H.Melee.Shadows(audits, melee_type_broad, melee_type_discrete)
    elseif message_id == A.Enum.Message.DODGE then
        H.Melee.Dodge(audits, melee_type_broad, melee_type_discrete)
    elseif message_id == A.Enum.Message.MOBHEAL3 or message_id == A.Enum.Message.MOBHEAL373 then
        H.Melee.Mob_Heal(audits, damage, melee_type_broad, melee_type_discrete)
    elseif message_id == A.Enum.Message.RANGEHIT then
        H.Melee.Daken_Hit(audits)
    elseif message_id == A.Enum.Message.RANGEMISS then
        H.Melee.Daken_Miss(audits)
    elseif message_id == A.Enum.Message.SQUARE then
        H.Melee.Daken_Square(audits)
    elseif message_id == A.Enum.Message.TRUE then
        H.Melee.Daken_Truestrike(audits)
    elseif message_id == A.Enum.Message.RANGECRIT then
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
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.HIT_COUNT)
    if melee_type_broad ~= H.Trackable.PET_MELEE then Model.Update.Running_Accuracy(audits.player_name, true) end
end

------------------------------------------------------------------------------------------------------
-- Regular melee miss.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param melee_type_broad string player melee or pet melee.
------------------------------------------------------------------------------------------------------
H.Melee.Miss = function(audits, melee_type_broad)
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_broad, H.Metric.MISS_COUNT)
    if melee_type_broad ~= H.Trackable.PET_MELEE then Model.Update.Running_Accuracy(audits.player_name, false) end
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
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.CRIT_COUNT)
    Model.Update.Data(H.Mode.INC, damage, audits, melee_type_broad,    H.Metric.CRIT_DAMAGE)
    if melee_type_broad ~= H.Trackable.PET_MELEE then Model.Update.Running_Accuracy(audits.player_name, true) end
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
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.SHADOWS)
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
    Model.Update.Data(H.Mode.INC,     -1, audits, melee_type_broad,    H.Metric.COUNT)
    Model.Update.Data(H.Mode.INC,     -1, audits, melee_type_discrete, H.Metric.COUNT)
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
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC, damage, audits, melee_type_broad,    H.Metric.MOB_HEAL)
end

------------------------------------------------------------------------------------------------------
-- Daken regular hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
------------------------------------------------------------------------------------------------------
H.Melee.Daken_Hit = function(audits)
    Model.Update.Data(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.HIT_COUNT)
    Model.Update.Running_Accuracy(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Daken square hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
------------------------------------------------------------------------------------------------------
H.Melee.Daken_Square = function(audits)
    Model.Update.Data(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.HIT_COUNT)
    Model.Update.Running_Accuracy(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Daken truestrike hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
------------------------------------------------------------------------------------------------------
H.Melee.Daken_Truestrike = function(audits)
    Model.Update.Data(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.HIT_COUNT)
    Model.Update.Running_Accuracy(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Daken miss.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
------------------------------------------------------------------------------------------------------
H.Melee.Daken_Miss = function(audits)
    Model.Update.Data(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.MISS_COUNT)
    Model.Update.Running_Accuracy(audits.player_name, false)
end

------------------------------------------------------------------------------------------------------
-- Daken critical hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
------------------------------------------------------------------------------------------------------
H.Melee.Daken_Crit = function(audits, damage)
    Model.Update.Data(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.CRIT_COUNT)
    Model.Update.Data(H.Mode.INC, damage, audits, H.Trackable.RANGED, H.Metric.CRIT_DAMAGE)
    Model.Update.Running_Accuracy(audits.player_name, true)
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
        if damage > 0 and (damage < Model.Get.Data(audits.player_name, H.Trackable.RANGED, H.Metric.MIN)) then Model.Update.Data(H.Mode.SET, damage, audits, H.Trackable.RANGED, H.Metric.MIN) end
        if damage > Model.Get.Data(audits.player_name, H.Trackable.RANGED, H.Metric.MAX) then Model.Update.Data(H.Mode.SET, damage, audits, H.Trackable.RANGED, H.Metric.MAX) end
    else
        if damage > 0 and (damage < Model.Get.Data(audits.player_name, melee_type_broad, H.Metric.MIN)) then Model.Update.Data(H.Mode.SET, damage, audits, melee_type_broad, H.Metric.MIN) end
        if damage > Model.Get.Data(audits.player_name, melee_type_broad, H.Metric.MAX) then Model.Update.Data(H.Mode.SET, damage, audits, melee_type_broad, H.Metric.MAX) end
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
    if message_id == A.Enum.Message.ENSPELL then
        if no_damage then value = 0 end
        Model.Update.Data(H.Mode.INC, value, audits, H.Trackable.MAGIC,       H.Metric.TOTAL)
        Model.Update.Data(H.Mode.INC, value, audits, H.Trackable.TOTAL,       H.Metric.TOTAL)       -- It's an extra step to add additional enspell damage to total.
        Model.Update.Data(H.Mode.INC, value, audits, H.Trackable.TOTAL_NO_SC, H.Metric.TOTAL)       -- It's an extra step to add additional enspell damage to total.
        Model.Update.Data(H.Mode.INC,     1, audits, H.Trackable.ENSPELL,     H.Metric.HIT_COUNT)
        Model.Update.Data(H.Mode.INC,     1, audits, H.Trackable.MAGIC,       H.Metric.COUNT)       -- Used to flag that data is availabel for show in Focus.
        if Lists.Spell.Enspell_Type[effect_animation_id] then
            local enspell_name = Lists.Spell.Enspell_Type[effect_animation_id]
            Model.Update.Catalog_Damage(audits.player_name, audits.target_name, H.Trackable.ENSPELL, value, enspell_name)
            Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, H.Trackable.ENSPELL, enspell_name, H.Metric.COUNT)
            Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, H.Trackable.ENSPELL, enspell_name, H.Metric.HIT_COUNT)
        end
    elseif message_id == A.Enum.Message.ENDRAIN then
        Model.Update.Data(H.Mode.INC, value, audits, H.Trackable.ENDRAIN,     H.Metric.TOTAL)
        Model.Update.Data(H.Mode.INC, value, audits, H.Trackable.ENDRAIN,     H.Metric.HIT_COUNT)
    elseif message_id == A.Enum.Message.ENASPIR then
        Model.Update.Data(H.Mode.INC, value, audits, H.Trackable.ENASPIR,     H.Metric.TOTAL)
        Model.Update.Data(H.Mode.INC, value, audits, H.Trackable.ENASPIR,     H.Metric.HIT_COUNT)
    end
end