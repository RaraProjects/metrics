H.Melee_Def = T{}

-- ------------------------------------------------------------------------------------------------------
-- Parse the melee attack packet.
-- ------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param owner_mob table|nil (if pet) the mob data of the entity's owner.
---@param log_defense boolean if this action should actually be logged.
-- ------------------------------------------------------------------------------------------------------
H.Melee_Def.Action = function(action, actor_mob, owner_mob, log_defense)
	if not log_defense then return nil end
	local result, target_mob
	local damage = 0

	for target_index, target_value in pairs(action.targets) do
		for action_index, _ in pairs(target_value.actions) do
			result = action.targets[target_index].actions[action_index]
			target_mob = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if target_mob then
                if Ashita.Mob.Is_Monster(actor_mob) then DB.Lists.Check.Mob_Exists(actor_mob.name) end
			    damage = damage + H.Melee_Def.Parse(result, actor_mob.name, target_mob.name, owner_mob)
            end
		end
	end

    H.Melee_Def.Blog(actor_mob, damage)
end

------------------------------------------------------------------------------------------------------
-- Set data for a melee action performed by a mob.
------------------------------------------------------------------------------------------------------
---@param result table contains all the information for the action.
---@param actor_name string name of the player that did the action.
---@param target_name string name of the target that received the action.
---@param owner_mob? table if the action was from a pet then this will hold the owner's mob.
---@return number
------------------------------------------------------------------------------------------------------
H.Melee_Def.Parse = function(result, actor_name, target_name, owner_mob)
    Debug.Packet.Add_Action(actor_name, target_name, "Melee Def.", result)
    local damage = result.param
    local reaction_id = result.reaction
    local message_id = result.message
    local effect_message_id = result.add_effect_message
    local effect_animation_id = result.add_effect_animation

    -- Need special handling for pets
    local pet_name = nil
    if owner_mob then
        pet_name = target_name
        target_name = owner_mob.name
    end

    -- These are switched compared to offense.
    local audits = {
        player_name = target_name,
        target_name = actor_name,
        pet_name = pet_name,
    }

    -- No damage Messages
    local no_damage = H.Melee_Def.No_Damage_Messages(message_id)

    if owner_mob then
        H.Melee_Def.Pet_Total(audits, damage, no_damage)
    else
        H.Melee_Def.Totals(audits, damage, no_damage)
    end

    -- There is an order of operations to defensive actions. Need to protect the denominator.
    if not owner_mob then
        local action_taken = false
        if not action_taken then action_taken = H.Melee_Def.Evade(audits, message_id) end
        if not action_taken then action_taken = H.Melee_Def.Parry(audits, message_id) end
        if not action_taken then action_taken = H.Melee_Def.Shadows(audits, message_id) end
        if not action_taken then action_taken = H.Melee_Def.Counter(audits, result) end
        if not action_taken then action_taken = H.Melee_Def.Guard(audits, damage, reaction_id) end
        if not action_taken then action_taken = H.Melee_Def.Block(audits, damage, reaction_id) end

        -- Unmitigated melee hit.
        if not action_taken then
            DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.MELEE_DMG_TAKEN, H.Metric.HIT_COUNT)
            DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.DEF_UNMITIGATED, H.Metric.HIT_COUNT)
            DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.DEF_UNMITIGATED, H.Metric.TOTAL)
        end

        H.Melee_Def.Crit(audits, damage, message_id)
        H.Melee_Def.Spikes(audits, result)

        -- Enspell
        local add_effect_damage = result.add_effect_param
        if add_effect_damage > 0 then H.Melee_Def.Additional_Effect(audits, add_effect_damage, effect_animation_id, effect_message_id, no_damage) end
    end

    -- Set to zero for the battle log.
    if no_damage then damage = 0 end

    return damage
end

-- ------------------------------------------------------------------------------------------------------
-- Adds melee damage to the battle log.
-- ------------------------------------------------------------------------------------------------------
---@param actor_mob table the mob data of the entity performing the action.
---@param damage number
-- ------------------------------------------------------------------------------------------------------
H.Melee_Def.Blog = function(actor_mob, damage)
    Blog.Add(actor_mob.name, nil, Blog.Enum.Types.MOB_MELEE, DB.Enum.Trackable.MELEE, damage)
end

------------------------------------------------------------------------------------------------------
-- Increment Grand Totals.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param no_damage? boolean whether or not the damage from this should be treated as actual damage or not.
------------------------------------------------------------------------------------------------------
H.Melee_Def.Totals = function(audits, damage, no_damage)
    if no_damage then damage = 0 end
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.DAMAGE_TAKEN_TOTAL, H.Metric.TOTAL)

    local trackable = H.Trackable.MELEE_DMG_TAKEN
    DB.Data.Update(H.Mode.INC, damage, audits, trackable, H.Metric.TOTAL)
    DB.Data.Update(H.Mode.INC, 1,      audits, trackable, H.Metric.COUNT) -- Melee attempts against entity.
    -- HIT_COUNT gets set in the primary parse function.
    if damage > 0 and (damage < DB.Data.Get(audits.player_name, trackable, H.Metric.MIN)) then DB.Data.Update(H.Mode.SET, damage, audits, trackable, H.Metric.MIN) end
    if damage > DB.Data.Get(audits.player_name, trackable, H.Metric.MAX) then DB.Data.Update(H.Mode.SET, damage, audits, trackable, H.Metric.MAX) end
end

------------------------------------------------------------------------------------------------------
-- Increment total pet damage taken.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param no_damage? boolean whether or not the damage from this should be treated as actual damage or not.
------------------------------------------------------------------------------------------------------
H.Melee_Def.Pet_Total = function(audits, damage, no_damage)
    if no_damage then damage = 0 end
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.DMG_TAKEN_TOTAL_PET, H.Metric.TOTAL)

    local trackable = H.Trackable.MELEE_PET_DMG_TAKEN
    DB.Data.Update(H.Mode.INC, damage, audits, trackable, H.Metric.TOTAL)
    DB.Data.Update(H.Mode.INC, 1,      audits, trackable, H.Metric.COUNT) -- Melee attempts against entity.
    if damage > 0 then DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.HIT_COUNT) end
    if damage > 0 and (damage < DB.Data.Get(audits.player_name, trackable, H.Metric.MIN)) then DB.Data.Update(H.Mode.SET, damage, audits, trackable, H.Metric.MIN) end
    if damage > DB.Data.Get(audits.player_name, trackable, H.Metric.MAX) then DB.Data.Update(H.Mode.SET, damage, audits, trackable, H.Metric.MAX) end
end

------------------------------------------------------------------------------------------------------
-- Check for evasion.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param message_id number the ID of the entity animation when taking a hit.
---@return boolean
------------------------------------------------------------------------------------------------------
H.Melee_Def.Evade = function(audits, message_id)
    local evade = false
    DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.DEF_EVASION, H.Metric.COUNT)
    if message_id == Ashita.Enum.Message.MISS then
        DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.DEF_EVASION, H.Metric.HIT_COUNT)
        evade = true
    end
    return evade
end

------------------------------------------------------------------------------------------------------
-- Check for parry.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param message_id number the ID of the entity animation when taking a hit.
---@return boolean
------------------------------------------------------------------------------------------------------
H.Melee_Def.Parry = function(audits, message_id)
    local parry = false
    DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.DEF_PARRY, H.Metric.COUNT)
    if message_id == Ashita.Enum.Message.PARRY then
        DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.DEF_PARRY, H.Metric.HIT_COUNT)
        parry = true
    end
    return parry
end

------------------------------------------------------------------------------------------------------
-- Check for shadows.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param message_id number the ID of the entity animation when taking a hit.
---@return boolean
------------------------------------------------------------------------------------------------------
H.Melee_Def.Shadows = function(audits, message_id)
    local shadow = false
    DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.DEF_SHADOWS, H.Metric.COUNT)
    if message_id == Ashita.Enum.Message.SHADOWS then
        DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.DEF_SHADOWS, H.Metric.HIT_COUNT)
        shadow = true
    end
    return shadow
end

------------------------------------------------------------------------------------------------------
-- Check for counter.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param result table the ID of the entity animation when taking a hit.
---@return boolean
------------------------------------------------------------------------------------------------------
H.Melee_Def.Counter = function(audits, result)
    local counter = false
    DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.DEF_COUNTER, H.Metric.COUNT)
    local spike_effect = result.has_spike_effect
    if spike_effect then
        local damage = result.spike_effect_param
        local spike_message = result.spike_effect_message
        if spike_message == Ashita.Enum.Message.COUNTER then
            DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.TOTAL, H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.TOTAL_NO_SC, H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.MELEE, H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.DEF_COUNTER, H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC, 1     , audits, H.Trackable.DEF_COUNTER, H.Metric.HIT_COUNT)
            counter = true
        end
    end
    return counter
end

------------------------------------------------------------------------------------------------------
-- Check for guard.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param reaction_id number the ID of the entity animation when taking a hit.
---@return boolean
------------------------------------------------------------------------------------------------------
H.Melee_Def.Guard = function(audits, damage, reaction_id)
    local guard = false
    DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.DEF_GUARD, H.Metric.COUNT)
    if reaction_id == Ashita.Enum.Reaction.GUARD then
        DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.DEF_GUARD, H.Metric.TOTAL)
        DB.Data.Update(H.Mode.INC, 1,      audits, H.Trackable.DEF_GUARD, H.Metric.HIT_COUNT)
        DB.Data.Update(H.Mode.INC, 1,      audits, H.Trackable.MELEE_DMG_TAKEN, H.Metric.HIT_COUNT)
        guard = true
    end
    return guard
end

------------------------------------------------------------------------------------------------------
-- Check for block.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param reaction_id number the ID of the entity animation when taking a hit.
---@return boolean
------------------------------------------------------------------------------------------------------
H.Melee_Def.Block = function(audits, damage, reaction_id)
    local block = false
    DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.DEF_BLOCK, H.Metric.COUNT)
    if reaction_id == Ashita.Enum.Reaction.SHIELD_BLOCK then
        DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.DEF_BLOCK, H.Metric.TOTAL)
        DB.Data.Update(H.Mode.INC, 1,      audits, H.Trackable.DEF_BLOCK, H.Metric.HIT_COUNT)
        DB.Data.Update(H.Mode.INC, 1,      audits, H.Trackable.MELEE_DMG_TAKEN, H.Metric.HIT_COUNT)
        block = true
    end
    return block
end

------------------------------------------------------------------------------------------------------
-- Check for critical damage taken.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param message_id number the ID of the entity animation when taking a hit.
------------------------------------------------------------------------------------------------------
H.Melee_Def.Crit = function(audits, damage, message_id)
    DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.DEF_CRIT, H.Metric.COUNT)
    if message_id == Ashita.Enum.Message.CRIT then
        DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.DEF_CRIT, H.Metric.TOTAL)
        DB.Data.Update(H.Mode.INC, 1,      audits, H.Trackable.DEF_CRIT, H.Metric.HIT_COUNT)
    end
end

------------------------------------------------------------------------------------------------------
-- Check for spike damage.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param result table action data
------------------------------------------------------------------------------------------------------
H.Melee_Def.Spikes = function(audits, result)
    local spike_effect = result.has_spike_effect
    if spike_effect then
        local damage = result.spike_effect_param
        local spike_animation = result.spike_effect_animation
        local spike_message = result.spike_effect_message
        if spike_message == Ashita.Enum.Message.SPIKE_DMG then
            DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.MAGIC, H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC, 1     , audits, H.Trackable.OUTGOING_SPIKE_DMG, H.Metric.HIT_COUNT)
            if spike_animation == Ashita.Enum.Effect_Animation.FIRE then
                DB.Catalog.Update_Damage(audits.player_name, audits.target_name, H.Trackable.OUTGOING_SPIKE_DMG, damage, "Blaze Spikes")
                DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, H.Trackable.OUTGOING_SPIKE_DMG, "Blaze Spikes", H.Metric.HIT_COUNT)
            elseif spike_animation == Ashita.Enum.Effect_Animation.ICE then
                DB.Catalog.Update_Damage(audits.player_name, audits.target_name, H.Trackable.OUTGOING_SPIKE_DMG, damage, "Ice Spikes")
                DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, H.Trackable.OUTGOING_SPIKE_DMG, "Ice Spikes", H.Metric.HIT_COUNT)
            elseif spike_animation == Ashita.Enum.Effect_Animation.THUNDER then
                DB.Catalog.Update_Damage(audits.player_name, audits.target_name, H.Trackable.OUTGOING_SPIKE_DMG, damage, "Shock Spikes")
                DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, H.Trackable.OUTGOING_SPIKE_DMG, "Shock Spikes", H.Metric.HIT_COUNT)
            else
                DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.TOTAL, H.Metric.TOTAL)
                DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.TOTAL_NO_SC, H.Metric.TOTAL)
                DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.OUTGOING_SPIKE_DMG, H.Metric.TOTAL)
            end
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Certain messages may come in with damage, but it's not actually damage.
-- Need to set the damage to zero for these cases.
------------------------------------------------------------------------------------------------------
---@param message_id number
---@return boolean whether or not the damage from this should be treated as actual damage or not.
------------------------------------------------------------------------------------------------------
H.Melee_Def.No_Damage_Messages = function(message_id)
    return message_id == Ashita.Enum.Message.DODGE or
           message_id == Ashita.Enum.Message.MISS or
           message_id == Ashita.Enum.Message.SHADOWS or
           message_id == Ashita.Enum.Message.MOBHEAL373
end

------------------------------------------------------------------------------------------------------
-- Captures additional effects from melee.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param value number how much of the thing you did.
---@param animation_id number determines which element the enspell is.
---@param message_id number numberic identifier for system chat messages.
---@param no_damage? boolean whether or not the damage from this should be treated as actual damage or not.
------------------------------------------------------------------------------------------------------
H.Melee_Def.Additional_Effect = function(audits, value, animation_id, message_id, no_damage)
    -- Only add additional damage to the damage totals.
    if message_id == Ashita.Enum.Message.ENSPELL then
        if no_damage then value = 0 end
        DB.Data.Update(H.Mode.INC, value, audits, H.Trackable.DAMAGE_TAKEN_TOTAL, H.Metric.TOTAL)
        if Res.Spells.Get_Enspell_Type(animation_id) then
            local enspell_name = Res.Spells.Get_Enspell_Type(animation_id)
            DB.Catalog.Update_Damage(audits.player_name, audits.target_name, H.Trackable.SPELL_DMG_TAKEN, value, enspell_name)
            DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, H.Trackable.SPELL_DMG_TAKEN, enspell_name, H.Metric.COUNT)
            DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, H.Trackable.SPELL_DMG_TAKEN, enspell_name, H.Metric.HIT_COUNT)
        end
    end
end