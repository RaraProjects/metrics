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
	if not log_defense then return end
	local result, target
	local damage = 0

	for target_index, target_value in pairs(action.targets) do
		for action_index, _ in pairs(target_value.actions) do
			result = action.targets[target_index].actions[action_index]
			target = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)
			if not target then target = {name = DB.Enum.Values.DEBUG} end
            if actor_mob.spawn_flags == Ashita.Enum.Spawn_Flags.MOB then DB.Lists.Check.Mob_Exists(target.name) end
			damage = damage + H.Melee_Def.Parse(result, actor_mob.name, target.name, owner_mob)
		end
	end

    H.Melee.Blog(actor_mob, owner_mob, damage)
end

------------------------------------------------------------------------------------------------------
-- Set data for a melee action performed by a mob.
------------------------------------------------------------------------------------------------------
---@param result table contains all the information for the action.
---@param player_name string name of the player that did the action.
---@param target_name string name of the target that received the action.
---@param owner_mob? table if the action was from a pet then this will hold the owner's mob.
---@return number
------------------------------------------------------------------------------------------------------
H.Melee_Def.Parse = function(result, player_name, target_name, owner_mob)
    _Debug.Packet.Add_Action(player_name, target_name, "Melee Def.", result)
    local damage = result.param
    local reaction_id = result.reaction
    local message_id = result.message
    local spike_effect = result.has_spike_effect

    -- Need special handling for pets
    local pet_name
    if owner_mob then
        pet_name = player_name
        player_name = owner_mob.name
    end

    local audits = {
        player_name = player_name,
        target_name = target_name,
        pet_name = pet_name,
    }

    -- -- No damage Messages
    -- local no_damage = H.Melee_Def.No_Damage_Messages(message_id)

    -- Totals
    H.Melee_Def.Totals(audits, damage)

    -- Pet Total
    H.Melee_Def.Pet_Total(owner_mob, audits, damage)

    -- Messages (Evasion and Parry)


    -- Reactions (Guard and Shield Block)
    H.Melee_Def.Reaction(audits, damage, reaction_id)

    -- Evasion = Message 15
    -- Parry = Message 70 with reaction 3

    if spike_effect then
        local spike_damage = result.spike_effect_param
        local spike_message = result.spike_effect_message
        -- Counter = spike message 33
        -- Spikes = spike message 44
    end


    

    -- DAMAGE_TAKEN_TOTAL = "Total Damage Taken",
    -- MELEE_DMG_TAKEN    = "Melee Damage Taken", 
    -- MELEE_EVASION      = "Melee Evasion",
    -- MELEE_PARRY_PROC   = "Parry",
    -- MELEE_SHIELD_PROC  = "Shield Block",
    -- MELEE_COUNTER      = "Counter",
    -- MELEE_GUARD        = "Guard",
    -- MELEE_SPIKES       = "Spikes",
    -- MELEE_SPIKE_DT     = "Spike Damage Taken",
    -- MELEE_SHADOWS      = "Shadow Absorption"


    -- -- Melee or Throwing Totals and Counts
    -- throwing = H.Melee.Animation(animation_id, audits, damage, melee_type_broad, throwing, no_damage)

    -- -- Min/Max
    -- H.Melee.Min_Max(throwing, damage, audits, melee_type_broad, no_damage)

    -- -- Enspell
    -- local add_effect_damage = result.add_effect_param
    -- if add_effect_damage > 0 then H.Melee.Additional_Effect(audits, add_effect_damage, effect_message_id, effect_animation_id, no_damage) end

    -- -- Accuracy, crits, absorbed by shadows, etc.
    -- H.Melee.Message(audits, damage, message_id, melee_type_broad, melee_type_discrete)

    -- local spikes = result.spike_effect_effect

    return damage
end

------------------------------------------------------------------------------------------------------
-- Increment Grand Totals.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
------------------------------------------------------------------------------------------------------
H.Melee_Def.Totals = function(audits, damage)
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.DAMAGE_TAKEN_TOTAL, H.Metric.TOTAL)
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.MELEE_DMG_TAKEN, H.Metric.TOTAL)
    DB.Data.Update(H.MOde.INC, 1,      audits, H.Trackable.MELEE_DMG_TAKEN, H.Metric.COUNT) -- Melee attempts against entity.
end

------------------------------------------------------------------------------------------------------
-- Increment total pet damage taken.
------------------------------------------------------------------------------------------------------
---@param owner_mob table|nil if the action was from a pet then this will hold the owner's mob.
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param no_damage? boolean whether or not the damage from this should be treated as actual damage or not.
------------------------------------------------------------------------------------------------------
H.Melee_Def.Pet_Total = function(owner_mob, audits, damage, no_damage)
    if no_damage then damage = 0 end
    if owner_mob then
        DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.MELEE_PET_DMG_TAKEN, H.Metric.TOTAL)
        DB.Data.Update(H.MOde.INC, 1,      audits, H.Trackable.MELEE_PET_DMG_TAKEN, H.Metric.COUNT) -- Melee attempts against entity.
    end
end

------------------------------------------------------------------------------------------------------
-- Check for evasion and parry.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param message_id number the ID of the entity animation when taking a hit.
------------------------------------------------------------------------------------------------------
H.Melee_Def.Message = function(audits, damage, message_id)
    -- if message_id == Ashita.Enum.Message.MISS then
    --     DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.MELEE_EVASION, H.Metric.TOTAL)
    --     DB.Data.Update(H.Mode.INC, 1,      audits, H.Trackable.MELEE_GUARD, H.Metric.COUNT)
    -- elseif message_id ==  then
        
    -- end
end

------------------------------------------------------------------------------------------------------
-- Check for shield block and guard.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param reaction_id number the ID of the entity animation when taking a hit.
------------------------------------------------------------------------------------------------------
H.Melee_Def.Reaction = function(audits, damage, reaction_id)
    if reaction_id == Ashita.Enum.Reaction.GUARD then
        DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.MELEE_GUARD, H.Metric.TOTAL)
        DB.Data.Update(H.Mode.INC, 1,      audits, H.Trackable.MELEE_GUARD, H.Metric.COUNT)
    elseif reaction_id == Ashita.Enum.Reaction.SHIELD_BLOCK then
        DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.MELEE_BLOCK, H.Metric.TOTAL)
        DB.Data.Update(H.Mode.INC, 1,      audits, H.Trackable.MELEE_BLOCK, H.Metric.COUNT)
    end
end