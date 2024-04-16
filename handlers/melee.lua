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
			if not target then target = {name = 'test'} end
			damage = damage + H.Melee.Parse(result, actor_mob.name, target.name, owner_mob)
		end
	end

    H.Melee.Blog(actor_mob, owner_mob, damage)
end

-- ------------------------------------------------------------------------------------------------------
-- Adds melee damage to the battle log.
-- ------------------------------------------------------------------------------------------------------
H.Melee.Blog = function(actor_mob, owner_mob, damage)
    if Blog.Flags.Melee then
        local blog_name = actor_mob.name
        if owner_mob then
            blog_name = owner_mob.name .. " (" .. actor_mob.name .. ")"
        end
        Blog.Add(blog_name, Model.Enum.Trackable.MELEE, damage)
    end
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
    local damage = result.param
    local message_id = result.message
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
    damage = H.Melee.No_Damage_Messages(message_id, damage)

    -- Totals
    H.Melee.Totals(audits, damage, melee_type_discrete)

    -- Pet Totals
    H.Melee.Pet_Total(owner_mob, audits, damage)

    -- Melee or Throwing Totals and Counts
    throwing = H.Melee.Animation(animation_id, audits, damage, melee_type_broad, throwing)

    -- Min/Max
    H.Melee.Min_Max(throwing, damage, audits, melee_type_broad)

    -- Enspell
    local enspell_damage = result.add_effect_param
    if enspell_damage > 0 then H.Melee.Enspell(audits, enspell_damage) end

    -- Accuracy and misc. traits.
    H.Melee.Message(audits, damage, message_id, melee_type_broad, melee_type_discrete)

    local spikes = result.spike_effect_effect

    return damage
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
        return H.Trackable.MELEE_OFFH
    elseif animation_id == A.Enum.Animation.MELEE_KICK or animation_id == A.Enum.Animation.MELEE_KICK2 then
        return H.Trackable.MELEE_KICK
    elseif animation_id == A.Enum.Animation.THROWING then
        return H.Trackable.THROWING
    else
        return H.Trackable.DEFAULT
    end
end

------------------------------------------------------------------------------------------------------
-- Certain messages may come in with damage, but it's not actually damage.
-- Need to set the damage to zero for these cases.
------------------------------------------------------------------------------------------------------
H.Melee.No_Damage_Messages = function(message_id, damage)
    if message_id == A.Enum.Message.DODGE or message_id == A.Enum.Message.MOBHEAL373
    or message_id == A.Enum.Message.MISS or message_id == A.Enum.Message.SHADOWS then
        return 0
    end
    return damage
end

------------------------------------------------------------------------------------------------------
-- Increment Grand Totals.
------------------------------------------------------------------------------------------------------
H.Melee.Totals = function(audits, damage, melee_type_discrete)
    Model.Update.Data(H.Mode.INC, damage, audits, H.Trackable.TOTAL, H.Metric.TOTAL)
    Model.Update.Data(H.Mode.INC, damage, audits, H.Trackable.TOTAL_NO_SC, H.Metric.TOTAL)
    Model.Update.Data(H.Mode.INC, damage, audits, melee_type_discrete, H.Metric.TOTAL)
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.COUNT)
end

------------------------------------------------------------------------------------------------------
-- Increment total pet damage.
------------------------------------------------------------------------------------------------------
H.Melee.Pet_Total = function(owner_mob, audits, damage)
    if owner_mob then
        Model.Update.Data(H.Mode.INC, damage, audits, H.Trackable.PET, H.Metric.TOTAL)
    end
end

------------------------------------------------------------------------------------------------------
-- The melee's animation to determine whether this is a regular melee of throwing melee.
------------------------------------------------------------------------------------------------------
H.Melee.Animation = function(animation_id, audits, damage, melee_type_broad, throwing)
    -- Regular Melee
    if animation_id >= A.Enum.Animation.MELEE_MAIN and animation_id < A.Enum.Animation.THROWING then
        Model.Update.Data(H.Mode.INC, damage, audits, melee_type_broad, H.Metric.TOTAL)
        Model.Update.Data(H.Mode.INC,      1, audits, melee_type_broad, H.Metric.COUNT)
    -- Throwing
    elseif animation_id == A.Enum.Animation.THROWING then
        throwing = true
        Model.Update.Data(H.Mode.INC, damage, audits, H.Trackable.RANGED, H.Metric.TOTAL)
        Model.Update.Data(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.COUNT)
    -- Unhandled Animation
    else
        _Debug.Error.Add("Handler.Melee: {" .. tostring(audits.player_name) .. "} Unhandled animation: " .. tostring(animation_id))
    end
    return throwing
end

------------------------------------------------------------------------------------------------------
-- Handle the various metrics based on message.
------------------------------------------------------------------------------------------------------
H.Melee.Message = function(audits, damage, message_id, melee_type_broad, melee_type_discrete)
    if message_id == A.Enum.Message.HIT then
        H.Melee.Hit(audits, melee_type_broad, melee_type_discrete)
    elseif message_id == A.Enum.Message.MOBHEAL3 or message_id == A.Enum.Message.MOBHEAL373 then
        H.Melee.Mob_Heal(audits, damage, melee_type_broad, melee_type_discrete)
    elseif message_id == A.Enum.Message.MISS then
        H.Melee.Miss(audits, melee_type_broad)
    elseif message_id == A.Enum.Message.SHADOWS then
        H.Melee.Shadows(audits, melee_type_broad, melee_type_discrete)
    elseif message_id == A.Enum.Message.DODGE then
        H.Melee.Dodge(audits, melee_type_broad, melee_type_discrete)
    elseif message_id == A.Enum.Message.CRIT then
        H.Melee.Crit(audits, damage, melee_type_broad, melee_type_discrete)
    elseif message_id == A.Enum.Message.RANGECRIT then
        H.Melee.Throw_Crit(audits, damage)
    elseif message_id == A.Enum.Message.RANGEMISS then
        H.Melee.Throw_Miss(audits)
    elseif message_id == A.Enum.Message.SQUARE then
        H.Melee.Square(audits)
    elseif message_id == A.Enum.Message.TRUE then
        H.Melee.Truestrike(audits)
    else
        _Debug.Error.Add("Handler.Melee: {" .. tostring(audits.player_name) .. "} Unhandled Melee Nuance " .. tostring(message_id))
    end
end

------------------------------------------------------------------------------------------------------
-- Regular melee hit.
------------------------------------------------------------------------------------------------------
H.Melee.Hit = function(audits, melee_type_broad, melee_type_discrete)
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.HIT_COUNT)
    Model.Update.Running_Accuracy(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Regular melee miss.
------------------------------------------------------------------------------------------------------
H.Melee.Miss = function(audits, melee_type_broad)
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_broad, H.Metric.MISS_COUNT)
    Model.Update.Running_Accuracy(audits.player_name, false)
end

------------------------------------------------------------------------------------------------------
-- Regular melee critical hit.
------------------------------------------------------------------------------------------------------
H.Melee.Crit = function(audits, damage, melee_type_broad, melee_type_discrete)
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.CRIT_COUNT)
    Model.Update.Data(H.Mode.INC, damage, audits, melee_type_broad,    H.Metric.CRIT_DAMAGE)
    Model.Update.Running_Accuracy(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Regular melee absorbed by shadows.
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
H.Melee.Dodge = function(audits, melee_type_broad, melee_type_discrete)
    Model.Update.Data(H.Mode.INC,     -1, audits, melee_type_broad,    H.Metric.COUNT)
    Model.Update.Data(H.Mode.INC,     -1, audits, melee_type_discrete, H.Metric.COUNT)
end

------------------------------------------------------------------------------------------------------
-- Healing the mob with a melee hit.
------------------------------------------------------------------------------------------------------
H.Melee.Mob_Heal = function(audits, damage, melee_type_broad, melee_type_discrete)
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC, damage, audits, melee_type_broad,    H.Metric.MOB_HEAL)
end

------------------------------------------------------------------------------------------------------
-- Throwing square hit.
------------------------------------------------------------------------------------------------------
H.Melee.Square = function(audits)
    Model.Update.Data(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.HIT_COUNT)
    Model.Update.Running_Accuracy(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Throwing truestrike hit.
------------------------------------------------------------------------------------------------------
H.Melee.Truestrike = function(audits)
    Model.Update.Data(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.HIT_COUNT)
    Model.Update.Running_Accuracy(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Throwing miss.
------------------------------------------------------------------------------------------------------
H.Melee.Throw_Miss = function(audits)
    Model.Update.Data(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.MISS_COUNT)
    Model.Update.Running_Accuracy(audits.player_name, false)
end

------------------------------------------------------------------------------------------------------
-- Throwing critical hit.
------------------------------------------------------------------------------------------------------
H.Melee.Throw_Crit = function(audits, damage)
    Model.Update.Data(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.CRIT_COUNT)
    Model.Update.Data(H.Mode.INC, damage, audits, H.Trackable.RANGED, H.Metric.CRIT_DAMAGE)
    Model.Update.Running_Accuracy(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Minimum and maximum melee values.
------------------------------------------------------------------------------------------------------
H.Melee.Min_Max = function(throwing, damage, audits, melee_type_broad)
    if throwing then
        if damage > 0 and (damage < Model.Get.Data(audits.player_name, H.Trackable.RANGED, H.Metric.MIN)) then Model.Update.Data(H.Mode.SET, damage, audits, H.Trackable.RANGED, H.Metric.MIN) end
        if damage > Model.Get.Data(audits.player_name, H.Trackable.RANGED, H.Metric.MAX) then Model.Update.Data(H.Mode.SET, damage, audits, H.Trackable.RANGED, H.Metric.MAX) end
    else
        if damage > 0 and (damage < Model.Get.Data(audits.player_name, melee_type_broad, H.Metric.MIN)) then Model.Update.Data(H.Mode.SET, damage, audits, melee_type_broad, H.Metric.MIN) end
        if damage > Model.Get.Data(audits.player_name, melee_type_broad, H.Metric.MAX) then Model.Update.Data(H.Mode.SET, damage, audits, melee_type_broad, H.Metric.MAX) end
    end
end

------------------------------------------------------------------------------------------------------
-- Enspell damage.
-- Element of the enspell is in add_effect_animation.
------------------------------------------------------------------------------------------------------
H.Melee.Enspell = function(audits, enspell_damage)
    Model.Update.Data(H.Mode.INC, enspell_damage, audits, H.Trackable.MAGIC,       H.Metric.TOTAL)
    Model.Update.Data(H.Mode.INC, enspell_damage, audits, H.Trackable.ENSPELL,     H.Metric.TOTAL)
    Model.Update.Data(H.Mode.INC, enspell_damage, audits, H.Trackable.TOTAL,       H.Metric.TOTAL)  -- It's an extra step to add additional enspell damage to total.
    Model.Update.Data(H.Mode.INC, enspell_damage, audits, H.Trackable.TOTAL_NO_SC, H.Metric.TOTAL)  -- It's an extra step to add additional enspell damage to total.
    Model.Update.Data(H.Mode.INC,              1, audits, H.Trackable.MAGIC,       H.Metric.COUNT)
    if enspell_damage < Model.Get.Data(audits.player_name, H.Trackable.MAGIC, H.Metric.MIN) then Model.Update.Data(H.Mode.SET, enspell_damage, audits, H.Trackable.MAGIC, H.Metric.MIN) end
    if enspell_damage > Model.Get.Data(audits.player_name, H.Trackable.MAGIC, H.Metric.MAX) then Model.Update.Data(H.Mode.SET, enspell_damage, audits, H.Trackable.MAGIC, H.Metric.MAX) end
end