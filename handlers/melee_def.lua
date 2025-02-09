H.Melee_Def = { }

-- ------------------------------------------------------------------------------------------------------
-- Parse the melee attack (defense) packet.
-- ------------------------------------------------------------------------------------------------------
---@param action     table     action packet data.
---@param actorMob   table     the mob data of the entity performing the action.
---@param ownerMob   table|nil (if pet) the mob data of the entity's owner.
---@param logDefense boolean   if this action should actually be logged.
-- ------------------------------------------------------------------------------------------------------
H.Melee_Def.Action = function(action, actorMob, ownerMob, logDefense)
	if not logDefense then
        return nil
    end

	local totalDamage   = 0
    local counterDamage = 0
    local targetMob

    for _, target in pairs(action.targets) do
        targetMob = Ashita.Mob.GetMobByID(target.id)
        if targetMob then
            -- Keep the mob list up-to-date.
            if Ashita.Mob.IsMonster(actorMob) then
                DB.Lists.Check.MobExists(actorMob.name)
            end

            -- Loop through actions on the target.
            for _, actionData in pairs(target.actions) do
			    local newDamage, newCounterDamage = H.Melee_Def.Parse(actionData, actorMob.name, targetMob.name, ownerMob)
                totalDamage = totalDamage + newDamage
                counterDamage = counterDamage + newCounterDamage
            end
        end
    end

    H.Melee_Def.Blog(actorMob, totalDamage, counterDamage)
end

------------------------------------------------------------------------------------------------------
-- Set data for a melee action performed by a mob.
------------------------------------------------------------------------------------------------------
---@param actionData table  contains all the information for the action.
---@param actorName  string name of the player that did the action.
---@param targetName string name of the target that received the action.
---@param ownerMob?  table  if the action was from a pet then this will hold the owner's mob.
---@return integer, integer
------------------------------------------------------------------------------------------------------
H.Melee_Def.Parse = function(actionData, actorName, targetName, ownerMob)
    Debug.Packet.AddAction(actorName, targetName, "Melee Def.", actionData)

    local damage            = actionData.param
    local reactionId        = actionData.reaction
    local messageId         = actionData.message
    local effectMessageId   = actionData.add_effect_message
    local effectAnimationId = actionData.add_effect_animation
    local meleeTrackable    = DB.Trackable.DEF_MELEE
    local counterDamage     = 0
    local petName

    -- Need special handling for pet attacks.
    if ownerMob then
        petName        = targetName
        targetName     = ownerMob.name
        meleeTrackable = DB.Trackable.DEF_MELEE_PET
    end

    -- Player and Target are switched compared to offense.
    local audits =
    {
        player_name = targetName,
        target_name = actorName,
        pet_name    = petName,
    }

    -- No damage Messages (miss, third eye, shadows, etc.)
    local noDamage = H.NoDamageMessages(actionData)
    if noDamage then
        damage = 0
    end

    -- Add to total damage taken metrics.
    H.Defense.GrandTotals(audits, damage, ownerMob)

    -- Mitigation from pets is not tracked at this time.
    if ownerMob then
        if damage > 0 then
            H.Offense.Hit(audits, meleeTrackable, damage)
            H.Offense.MinMax(audits, meleeTrackable, damage)
        else
            H.Offense.Miss(audits, meleeTrackable)
        end

    -- There is an order of operations to defensive actions. Need to protect the denominator.
    else
        -- All damage was mitigated.
        local fullMitigation =
            H.Defense.Mitigation(audits, DB.Trackable.DEF_EVASION_MELEE, damage, messageId, Ashita.Message.MELEE_MISS, true) or
            H.Defense.Mitigation(audits, DB.Trackable.DEF_PARRY, damage, messageId, Ashita.Message.MELEE_PARRY, true) or
            H.Defense.Mitigation(audits, DB.Trackable.DEF_SHADOWS_MELEE, damage, messageId, Ashita.Message.SHADOW_ABSORPTION, true) or
            H.Defense.Mitigation(audits, DB.Trackable.DEF_THIRD_EYE_ANTICIPATION, damage, messageId, Ashita.Message.THIRD_EYE_ANTICIPATION, true)

        if not fullMitigation then
            fullMitigation, counterDamage = H.Melee_Def.Counter(audits, actionData)
        end

        -- Only some damage was mitigated.
        local partialMitigation = not fullMitigation and
        (
            H.Defense.Mitigation(audits, DB.Trackable.DEF_GUARD, damage, reactionId, Ashita.AttackReaction.GUARD) or
            H.Defense.Mitigation(audits, DB.Trackable.DEF_SHIELD_BLOCK, damage, reactionId, Ashita.AttackReaction.SHIELD_BLOCK)
        )

        -- Full damage mitigation just increments attempts.
        if fullMitigation then
            H.Offense.Miss(audits, meleeTrackable)

        -- Partial damage mitigation doesn't affect DEF_MELEE min max.
        elseif partialMitigation then
            H.Offense.Hit(audits, meleeTrackable, damage)
            H.Offense.MinMax(audits, DB.Trackable.DEF_UNMITIGATED_MELEE_PARTIAL, damage)
            H.Offense.Hit(audits, DB.Trackable.DEF_UNMITIGATED_MELEE_PARTIAL, damage)

        -- Totally unmitigated hit.
        else
            H.Offense.Hit(audits, meleeTrackable, damage)
            H.Offense.MinMax(audits, meleeTrackable, damage)
            H.Offense.Hit(audits, DB.Trackable.DEF_UNMITIGATED_MELEE, damage)
        end

        H.Defense.Crit(audits, damage, messageId)
        H.Melee_Def.Spikes(audits, actionData)
        damage = damage + H.Melee_Def.AdditionalEffect(audits, actionData, effectAnimationId, effectMessageId)
    end

    -- Set battle log flags.
    if noDamage or counterDamage > 0 then
        damage = -1
    end

    return damage, counterDamage
end

-- ------------------------------------------------------------------------------------------------------
-- Adds melee damage to the battle log.
-- ------------------------------------------------------------------------------------------------------
---@param actorMob      table   the mob data of the entity performing the action.
---@param damage        integer
---@param counterDamage integer
-- ------------------------------------------------------------------------------------------------------
H.Melee_Def.Blog = function(actorMob, damage, counterDamage)
    local note = (counterDamage and counterDamage > 0) and string.format("Counter: %d", counterDamage) or ""
    Blog.Add(actorMob.name, nil, Blog.Action_Type.MOB_MELEE, DB.Trackable.MELEE_OVERALL, damage, note)
end

------------------------------------------------------------------------------------------------------
-- Check for counter.
------------------------------------------------------------------------------------------------------
---@param audits     table  contains necessary entity audit data; helps save on parameter slots.
---@param actionData table  the ID of the entity animation when taking a hit.
---@return boolean, integer
------------------------------------------------------------------------------------------------------
H.Melee_Def.Counter = function(audits, actionData)
    local counterDamage = 0

    -- Combined spike message check because blaze spikes etc. also has a spike effect.
    if actionData.has_spike_effect and actionData.spike_effect_message == Ashita.Message.MELEE_COUNTER then
        counterDamage = actionData.spike_effect_param or 0
        H.Offense.GrandTotals(audits, counterDamage)
        H.Offense.Hit(audits, DB.Trackable.MELEE_OVERALL, counterDamage)
        H.Offense.Hit(audits, DB.Trackable.MELEE_COUNTER, counterDamage)
        return true, counterDamage
    end

    -- No counter occurred.
    H.Offense.Miss(audits, DB.Trackable.MELEE_COUNTER)
    return false, 0
end

------------------------------------------------------------------------------------------------------
-- Check for spike damage.
------------------------------------------------------------------------------------------------------
---@param audits     table Contains necessary entity audit data; helps save on parameter slots.
---@param actionData table action data
------------------------------------------------------------------------------------------------------
H.Melee_Def.Spikes = function(audits, actionData)
    if not actionData.has_spike_effect then
        return nil
    end

    local damage         = actionData.spike_effect_param or 0
    local spikeAnimation = actionData.spike_effect_animation
    local spikeMessage   = actionData.spike_effect_message
    local spikeTrackable = DB.Trackable.SPELLS_SPIKE_DAMAGE

    if spikeMessage == Ashita.Message.SPIKE_DAMAGE then
        H.Offense.Hit(audits, DB.Trackable.SPELLS_OVERALL, damage)

        -- Determine which spikes were used by animation.
        if spikeAnimation == Ashita.EffectAnimation.FIRE then
            H.Offense.CatalogHit(audits, spikeTrackable, damage, "Blaze Spikes")

        elseif spikeAnimation == Ashita.EffectAnimation.ICE then
            H.Offense.CatalogHit(audits, spikeTrackable, damage, "Ice Spikes")

        elseif spikeAnimation == Ashita.EffectAnimation.THUNDER then
            H.Offense.CatalogHit(audits, spikeTrackable, damage, "Shock Spikes")

        else
            DB.Data.Update(DB.Update_Mode.INC, damage, audits, DB.Trackable.TOTAL_DAMAGE, DB.Metric.TOTAL)
            DB.Data.Update(DB.Update_Mode.INC, damage, audits, DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN, DB.Metric.TOTAL)
            DB.Data.Update(DB.Update_Mode.INC, damage, audits, spikeTrackable, DB.Metric.TOTAL)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Captures additional effects from melee.
------------------------------------------------------------------------------------------------------
---@param audits      table                  Contains necessary entity audit data; helps save on parameter slots.
---@param actionData  table                  how much of the thing you did.
---@param animationId Ashita.EffectAnimation determines which element the enspell is.
---@param messageId   Ashita.Message         numberic identifier for system chat messages.
---@return integer
------------------------------------------------------------------------------------------------------
H.Melee_Def.AdditionalEffect = function(audits, actionData, animationId, messageId)
    if not actionData.has_add_effect then
        return 0
    end

    local additionalDamage = actionData.add_effect_param or 0

    if messageId == Ashita.Message.ADDITIONAL_DAMAGE and animationId then
        local enspellName = Res.Spells.EnspellType[animationId]

        if enspellName then
            H.Defense.GrandTotals(audits, additionalDamage)
            H.Offense.CatalogHit(audits, DB.Trackable.DEF_NUKING, additionalDamage, enspellName)

            -- Need to undo the counts because Grand Totals is also called in the main parse function.
            DB.Data.Update(DB.Update_Mode.INC, -1, audits, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, DB.Metric.HITS_ON_TARGET)
            DB.Data.Update(DB.Update_Mode.INC, -1, audits, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, DB.Metric.ATTEMPTS_ON_TARGET)
        end
    end

    return additionalDamage
end