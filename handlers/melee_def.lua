H.Melee_Def = {}

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
    local counter_damage = 0

	for target_index, target_value in pairs(action.targets) do
		for action_index, _ in pairs(target_value.actions) do
			result = action.targets[target_index].actions[action_index]
			target_mob = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if target_mob then
                if Ashita.Mob.Is_Monster(actor_mob) then DB.Lists.Check.Mob_Exists(actor_mob.name) end
			    local new_damage, new_counter_damage = H.Melee_Def.Parse(result, actor_mob.name, target_mob.name, owner_mob)
                damage = damage + new_damage
                counter_damage = counter_damage + new_counter_damage
            end
		end
	end

    H.Melee_Def.Blog(actor_mob, damage, counter_damage)
end

------------------------------------------------------------------------------------------------------
-- Set data for a melee action performed by a mob.
------------------------------------------------------------------------------------------------------
---@param result table contains all the information for the action.
---@param actor_name string name of the player that did the action.
---@param target_name string name of the target that received the action.
---@param owner_mob? table if the action was from a pet then this will hold the owner's mob.
---@return integer, integer
------------------------------------------------------------------------------------------------------
H.Melee_Def.Parse = function(result, actor_name, target_name, owner_mob)
    Debug.Packet.Add_Action(actor_name, target_name, "Melee Def.", result)
    local damage              = result.param
    local reaction_id         = result.reaction
    local message_id          = result.message
    local effect_message_id   = result.add_effect_message
    local effect_animation_id = result.add_effect_animation
    local melee_trackable = DB.Trackable.DEF_MELEE
    local counter_damage = 0

    -- Need special handling for pets
    local pet_name = nil
    if owner_mob then
        pet_name = target_name
        target_name = owner_mob.name
        melee_trackable = DB.Trackable.DEF_MELEE_PET
    end

    -- These are switched compared to offense.
    local audits = {
        player_name = target_name,
        target_name = actor_name,
        pet_name = pet_name,
    }

    -- No damage Messages
    local no_damage = H.No_Damage_Messages(result)
    if no_damage then damage = 0 end

    H.Defense.Grand_Totals(audits, damage, owner_mob)

    -- Need to handle pets here because they aren't handled below.
    if owner_mob then
        if damage > 0 then
            H.Offense.Hit(audits, melee_trackable, damage)
            H.Offense.Min_Max(audits, melee_trackable, damage)
        else
            H.Offense.Miss(audits, melee_trackable)
        end
    end

    -- There is an order of operations to defensive actions. Need to protect the denominator.
    -- Not tracking damage mitigation for pets at this time.
    if not owner_mob then
        -- Full Mitigation
        local full = false
        if not full then full = H.Defense.Mitigation(audits, DB.Trackable.DEF_EVASION_MELEE, damage, message_id, Ashita.Enum.Message.MISS, true) end
        if not full then full = H.Defense.Mitigation(audits, DB.Trackable.DEF_PARRY, damage, message_id, Ashita.Enum.Message.PARRY, true) end
        if not full then full = H.Defense.Mitigation(audits, DB.Trackable.DEF_SHADOWS_MELEE, damage, message_id, Ashita.Enum.Message.SHADOWS, true) end
        if not full then full = H.Defense.Mitigation(audits, DB.Trackable.DEF_THIRD_EYE_ANTICIPATION, damage, message_id, Ashita.Enum.Message.THIRD_EYE_ANTICIPATION, true) end
        if not full then full, counter_damage = H.Melee_Def.Counter(audits, result) end

        -- Partial Mitigation
        local partial = false
        if not full then
            if not partial then partial = H.Defense.Mitigation(audits, DB.Trackable.DEF_GUARD, damage, reaction_id, Ashita.Enum.Reaction.GUARD) end
            if not partial then partial = H.Defense.Mitigation(audits, DB.Trackable.DEF_SHIELD_BLOCK, damage, reaction_id, Ashita.Enum.Reaction.SHIELD_BLOCK) end
        end

        -- Full damage mitigation just increments attempts.
        if full then
            H.Offense.Miss(audits, melee_trackable)

        -- Partial damage mitigation doesn't affect DEF_MELEE min max.
        elseif partial then
            H.Offense.Hit(audits, melee_trackable, damage)
            H.Offense.Min_Max(audits, DB.Trackable.DEF_UNMITIGATED_MELEE_PARTIAL, damage)
            H.Offense.Hit(audits, DB.Trackable.DEF_UNMITIGATED_MELEE_PARTIAL, damage)

        -- Totally unmitigated hit.
        else
            H.Offense.Hit(audits, melee_trackable, damage)
            H.Offense.Min_Max(audits, melee_trackable, damage)
            H.Offense.Hit(audits, DB.Trackable.DEF_UNMITIGATED_MELEE, damage)
        end

        H.Defense.Crit(audits, damage, message_id)
        H.Melee_Def.Spikes(audits, result)
        damage = damage + H.Melee_Def.Additional_Effect(audits, result, effect_animation_id, effect_message_id)
    end

    -- Set battle log flags.
    if no_damage or counter_damage > 0 then damage = -1 end

    return damage, counter_damage
end

-- ------------------------------------------------------------------------------------------------------
-- Adds melee damage to the battle log.
-- ------------------------------------------------------------------------------------------------------
---@param actor_mob table the mob data of the entity performing the action.
---@param damage integer
---@param counter_damage integer
-- ------------------------------------------------------------------------------------------------------
H.Melee_Def.Blog = function(actor_mob, damage, counter_damage)
    local note = ""
    if counter_damage and counter_damage > 0 then note = "Counter: " .. tostring(counter_damage) end
    Blog.Add(actor_mob.name, nil, Blog.Action_Type.MOB_MELEE, DB.Trackable.MELEE_OVERALL, damage, note)
end

------------------------------------------------------------------------------------------------------
-- Check for counter.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param result table the ID of the entity animation when taking a hit.
---@return boolean, integer
------------------------------------------------------------------------------------------------------
H.Melee_Def.Counter = function(audits, result)
    local counter = false
    local counter_damage = 0

    -- Combined spike message check because blaze spikes etc. also has a spike effect.
    if result.has_spike_effect and result.spike_effect_message == Ashita.Enum.Message.COUNTER then
        local damage = result.spike_effect_param
        H.Offense.Grand_Totals(audits, damage)
        H.Offense.Hit(audits, DB.Trackable.MELEE_OVERALL, damage)
        H.Offense.Hit(audits, DB.Trackable.MELEE_COUNTER, damage)
        counter = true
        counter_damage = damage
    else
        H.Offense.Miss(audits, DB.Trackable.MELEE_COUNTER)
    end

    return counter, counter_damage
end

------------------------------------------------------------------------------------------------------
-- Check for spike damage.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param result table action data
------------------------------------------------------------------------------------------------------
H.Melee_Def.Spikes = function(audits, result)
    if result.has_spike_effect then
        local damage          = result.spike_effect_param
        local spike_animation = result.spike_effect_animation
        local spike_message   = result.spike_effect_message
        local spike_trackable = DB.Trackable.SPELLS_SPIKE_DAMAGE

        if spike_message == Ashita.Enum.Message.SPIKE_DMG then
            H.Offense.Hit(audits, DB.Trackable.SPELLS_OVERALL, damage)

            if spike_animation == Ashita.Enum.Effect_Animation.FIRE then
                H.Offense.Catalog_Hit(audits, spike_trackable, damage, "Blaze Spikes")

            elseif spike_animation == Ashita.Enum.Effect_Animation.ICE then
                H.Offense.Catalog_Hit(audits, spike_trackable, damage, "Ice Spikes")

            elseif spike_animation == Ashita.Enum.Effect_Animation.THUNDER then
                H.Offense.Catalog_Hit(audits, spike_trackable, damage, "Shock Spikes")

            else
                DB.Data.Update(DB.Update_Mode.INC, damage, audits, DB.Trackable.TOTAL_DAMAGE, DB.Metric.TOTAL)
                DB.Data.Update(DB.Update_Mode.INC, damage, audits, DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN, DB.Metric.TOTAL)
                DB.Data.Update(DB.Update_Mode.INC, damage, audits, spike_trackable, DB.Metric.TOTAL)
            end
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Captures additional effects from melee.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param result table how much of the thing you did.
---@param animation_id number determines which element the enspell is.
---@param message_id number numberic identifier for system chat messages.
---@return integer
------------------------------------------------------------------------------------------------------
H.Melee_Def.Additional_Effect = function(audits, result, animation_id, message_id)
    local additional_damage = 0

    if result.has_add_effect then
        additional_damage = result.add_effect_param
        if message_id == Ashita.Enum.Message.ENSPELL then
            if animation_id and Res.Spells.Get_Enspell_Type(animation_id) then
                local enspell_name = Res.Spells.Get_Enspell_Type(animation_id)
                H.Defense.Grand_Totals(audits, additional_damage)
                H.Offense.Catalog_Hit(audits, DB.Trackable.DEF_NUKING, additional_damage, enspell_name)

                -- Need to undo the counts because Grand Totals is also called in the main parse function.
                DB.Data.Update(DB.Update_Mode.INC, -1, audits, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, DB.Metric.HITS_ON_TARGET)
                DB.Data.Update(DB.Update_Mode.INC, -1, audits, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, DB.Metric.ATTEMPTS_ON_TARGET)
            end
        end
    end

    return additional_damage
end