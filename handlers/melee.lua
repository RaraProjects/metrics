H.Melee = { }

-- ------------------------------------------------------------------------------------------------------
-- Parse the melee attack packet.
-- ------------------------------------------------------------------------------------------------------
---@param action     table     action packet data.
---@param actorMob   table     the mob data of the entity performing the action.
---@param ownerMob   table|nil (if pet) the mob data of the entity's owner.
---@param logOffense boolean   if this action should actually be logged.
-- ------------------------------------------------------------------------------------------------------
H.Melee.Action = function(action, actorMob, ownerMob, logOffense)
	if not logOffense then
        return nil
    end

    local damage, additionalDamage = 0, 0
    local overallHit  = false
    local details     = { }
    local multiAttack = { }

	for _, target in pairs(action.targets) do
		for _, actionData in pairs(target.actions) do
            local targetMob = Ashita.Mob.GetMobByID(target.id) or { name = DB.Enum.DEBUG }

            -- Keep the mob list up-to-date.
            if Ashita.Mob.IsMonster(targetMob) then
                DB.Lists.Check.MobExists(targetMob.name)
            end

            details = H.Melee.Parse(actionData, actorMob.name, targetMob.name, ownerMob)

            -- Special handling for tracking multi-attacks.
            -- Additional effect kept seperate from multi-attack damage.
            if details then
                damage = damage + (details.damage or 0)
                additionalDamage = additionalDamage + (details.add_damage or 0)

                -- Multi-attack handling by type.
                if details.type then
                    multiAttack[details.type] = multiAttack[details.type] or { swings = 0, multi_damage = 0, has_hit = false }  -- For first hit.

                    multiAttack[details.type].swings = multiAttack[details.type].swings + 1

                    -- Multi-damage only applies to the damage after the first swing.
                    if multiAttack[details.type].swings > 1 then
                        multiAttack[details.type].multi_damage = multiAttack[details.type].multi_damage + (details.damage or 0)
                    end

                    if details.has_hit then
                        multiAttack[details.type].has_hit = true
                        overallHit = true
                    end
                end
            end
		end
	end

    -- Handle the total multi-attack damage.
    H.Melee.MultiAttack(details, ownerMob, multiAttack)

    -- Keep track of how many melee cycles have occurred (1 per packet).
    -- Don't calculate for pets.
    if not ownerMob then
        DB.Attack_Speed.Update(actorMob.name)

        if overallHit then
            DB.Data.Update(DB.UpdateMode.INC, 1, details.audits, DB.Trackable.MELEE_OVERALL, DB.Metric.HITS_ON_USE)
        end

        DB.Data.Update(DB.UpdateMode.INC, 1, details.audits, DB.Trackable.MELEE_OVERALL, DB.Metric.ATTEMPTS_ON_USE)
    end

    H.Melee.Blog(actorMob, ownerMob, damage + additionalDamage)
end

------------------------------------------------------------------------------------------------------
-- Set data for a melee action.
-- message 				https://github.com/Windower/Lua/wiki/Message-IDs
-- add_effect_animation	https://github.com/Windower/Lua/wiki/Additional-Effect-IDs
------------------------------------------------------------------------------------------------------
---@param actionData table  contains all the information for the action.
---@param actorName  string name of the player that did the action.
---@param targetName string name of the target that received the action.
---@param ownerMob?  table  if the action was from a pet then this will hold the owner's mob.
---@return table
------------------------------------------------------------------------------------------------------
H.Melee.Parse = function(actionData, actorName, targetName, ownerMob)
    Debug.Packet.AddAction(actorName, targetName, "Melee", actionData)

    local animationId       = actionData.animation
    local damage            = actionData.param
    local messageId         = actionData.message
    local reactionId        = actionData.reaction
    local throwing          = animationId == Ashita.AttackAnimation.DAKEN
    local noDamage          = H.MessageNoDamage(messageId)
    local meleeTypeBroad    = DB.Trackable.MELEE_OVERALL
    local meleeTypeDiscrete = H.Melee.MeleeType(animationId)
    local petName

    if throwing then
        meleeTypeBroad    = DB.Trackable.RANGED_OVERALL
        meleeTypeDiscrete = DB.Trackable.RANGED_THROWING
    end

    -- Need special handling for pets
    if ownerMob then
        meleeTypeBroad    = DB.Trackable.PET_MELEE_OVERALL
        meleeTypeDiscrete = DB.Trackable.PET_MELEE_DISCRETE
        petName           = actorName
        actorName         = ownerMob.name
    end

    local audits =
    {
        player_name = actorName,
        target_name = targetName,
        pet_name    = petName,
    }

    local wasCriticalHit, hasHit = H.Melee.Message(audits, damage, messageId, meleeTypeBroad, meleeTypeDiscrete, ownerMob)

    -- Avoid setting any damage data if the strike missed or healed a mob or something.
    if noDamage then
        damage = 0
    else
        H.Offense.GrandTotals(audits, damage, ownerMob)
        H.Melee.Guarded(audits, meleeTypeBroad, reactionId)
        H.Offense.MinMax(audits, meleeTypeBroad, damage, wasCriticalHit)
        H.Offense.MinMax(audits, meleeTypeDiscrete, damage, wasCriticalHit)
    end

    -- These have their own damage separate from the initial melee strike.
    H.Melee.Spikes(audits, actionData, ownerMob)
    local additionalDamage = H.Melee.AdditionalEffect(audits, actionData)

    return { damage = damage, add_damage = additionalDamage, has_hit = hasHit, type = meleeTypeDiscrete, audits = audits }
end

-- ------------------------------------------------------------------------------------------------------
-- Handle multi-attack logging.
-- ------------------------------------------------------------------------------------------------------
---@param details    table
---@param ownerMob   table|nil
---@param multAttack table
-- ------------------------------------------------------------------------------------------------------
H.Melee.MultiAttack = function(details, ownerMob, multAttack)
    if not (details and details.audits and details.audits.player_name and not ownerMob) then
        return nil
    end

    local playerName = details.audits.player_name
    local hasMulti   = false

    -- Lookup table for multi-attack metrics.
    local multiAttackMetrics =
    {
        [1] = { count = DB.Metric.MULTI_ATTACK_1, damage = DB.Metric.MULTI_ATTACK_1_DAMAGE },
        [2] = { count = DB.Metric.MULTI_ATTACK_2, damage = DB.Metric.MULTI_ATTACK_2_DAMAGE },
        [3] = { count = DB.Metric.MULTI_ATTACK_3, damage = DB.Metric.MULTI_ATTACK_3_DAMAGE },
        [4] = { count = DB.Metric.MULTI_ATTACK_4, damage = DB.Metric.MULTI_ATTACK_4_DAMAGE },
        [5] = { count = DB.Metric.MULTI_ATTACK_5, damage = DB.Metric.MULTI_ATTACK_5_DAMAGE },
        [6] = { count = DB.Metric.MULTI_ATTACK_6, damage = DB.Metric.MULTI_ATTACK_6_DAMAGE },
        [7] = { count = DB.Metric.MULTI_ATTACK_7, damage = DB.Metric.MULTI_ATTACK_7_DAMAGE },
        [8] = { count = DB.Metric.MULTI_ATTACK_8, damage = DB.Metric.MULTI_ATTACK_8_DAMAGE },
    }

    DB.Tracking.MultiAttack[playerName] = DB.Tracking.MultiAttack[playerName] or { }

    for type, data in pairs(multAttack) do
        local multiSwings = data.swings
        local multiDamage = data.multi_damage
        local hasHit      = data.has_hit
        local metrics     = multiAttackMetrics[multiSwings]

        if metrics then
            DB.Tracking.MultiAttack[playerName][metrics.count] = true
            DB.Data.Update(DB.UpdateMode.INC, 1, details.audits, type, metrics.count)                  -- Specific multi-attack count (even if it's one).
            DB.Data.Update(DB.UpdateMode.INC, multiDamage, details.audits, type, metrics.damage)       -- Specific multi-attack damage.

            -- How many times an attack round contained a specific melee type.
            if hasHit then
                DB.Data.Update(DB.UpdateMode.INC, 1, details.audits, type, DB.Metric.HITS_ON_USE)
            end

            -- Kind of benign. All hits should have an attempt associated though.
            DB.Data.Update(DB.UpdateMode.INC, 1, details.audits, type, DB.Metric.ATTEMPTS_ON_USE)

            -- Total multi-attack rate.
            if multiSwings > 1 then
                hasMulti = true
                DB.Data.Update(DB.UpdateMode.INC, 1,           details.audits, type, DB.Metric.MULTI_ATTACK_HIT_ON_USE)
                DB.Data.Update(DB.UpdateMode.INC, multiDamage, details.audits, type, DB.Metric.MULTI_ATTACK_TOTAL)
                DB.Data.Update(DB.UpdateMode.INC, multiDamage, details.audits, DB.Trackable.MELEE_OVERALL, DB.Metric.MULTI_ATTACK_TOTAL)
            end
        end
    end

    -- Only count one multi attack per attack round for the overall metric. Otherwise there is >100% for overall multi rate.
    if hasMulti then
        DB.Data.Update(DB.UpdateMode.INC, 1, details.audits, DB.Trackable.MELEE_OVERALL, DB.Metric.MULTI_ATTACK_HIT_ON_USE)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Adds melee damage to the battle log.
-- ------------------------------------------------------------------------------------------------------
---@param actorMob table     the mob data of the entity performing the action.
---@param ownerMob table|nil (if pet) the mob data of the entity's owner.
---@param damage   number
-- ------------------------------------------------------------------------------------------------------
H.Melee.Blog = function(actorMob, ownerMob, damage)
    if ownerMob then
        Blog.Add(ownerMob.name, actorMob.name, Blog.Action_Type.PET_MELEE, DB.Trackable.PET_MELEE_OVERALL, damage)
    else
        Blog.Add(actorMob.name, nil, Blog.Action_Type.MELEE, DB.Trackable.MELEE_OVERALL, damage)
    end
end

------------------------------------------------------------------------------------------------------
-- Map an animation to a discrete type of melee action.
------------------------------------------------------------------------------------------------------
---@param animationId Ashita.AttackAnimation represents, primary attack, offhand attack, kicking, etc.
---@return DB.Trackable
------------------------------------------------------------------------------------------------------
H.Melee.MeleeType = function(animationId)
    local animationMapping =
    {
        [Ashita.AttackAnimation.MELEE_MAIN]    = DB.Trackable.MELEE_MAIN_HAND,
        [Ashita.AttackAnimation.MELEE_OFFHAND] = DB.Trackable.MELEE_OFF_HAND,
        [Ashita.AttackAnimation.MELEE_KICK]    = DB.Trackable.MELEE_KICK_ATTACKS,
        [Ashita.AttackAnimation.MELEE_KICK_2]  = DB.Trackable.MELEE_KICK_ATTACKS,
        [Ashita.AttackAnimation.DAKEN]         = DB.Trackable.RANGED_THROWING,
    }

    return animationMapping[animationId] or DB.Trackable.DEFAULT
end

------------------------------------------------------------------------------------------------------
-- The melee's reaction to determine whether the attack was guarded or not.
------------------------------------------------------------------------------------------------------
---@param audits           table
---@param meleeTypeOverall DB.Trackable
---@param reactionId       Ashita.AttackReaction
------------------------------------------------------------------------------------------------------
H.Melee.Guarded = function(audits, meleeTypeOverall, reactionId)
    if reactionId == Ashita.AttackReaction.GUARD then
        DB.Data.Update(DB.UpdateMode.INC, 1, audits, meleeTypeOverall, DB.Metric.GUARD)
    end
end

------------------------------------------------------------------------------------------------------
-- Handle the various metrics based on message.
-- The range attacks here are specifically the NIN auto throwing attacks while engaged.
-- https://github.com/Windower/Lua/wiki/Message-IDs
------------------------------------------------------------------------------------------------------
---@param audits            table          Contains necessary entity audit data; helps save on parameter slots.
---@param damage            integer
---@param messageId         Ashita.Message numberic identifier for system chat messages.
---@param meleeTypeOverall  DB.Trackable   player melee or pet melee.
---@param meleeTypeSpecific DB.Trackable   main-hand, off-hand, etc.
---@param ownerMob?         table
---@return boolean, boolean
------------------------------------------------------------------------------------------------------
H.Melee.Message = function(audits, damage, messageId, meleeTypeOverall, meleeTypeSpecific, ownerMob)
    local wasCriticalHit = false
    local hasHit         = true

    if messageId == Ashita.Message.MELEE_HIT then
        H.Offense.Hit(audits, meleeTypeOverall, damage)
        H.Offense.Hit(audits, meleeTypeSpecific, damage)
        H.Offense.UpdateRecentAccuracy(audits, true, ownerMob)

    elseif messageId == Ashita.Message.MELEE_MISS then
        H.Offense.Miss(audits, meleeTypeOverall)
        H.Offense.Miss(audits, meleeTypeSpecific)
        H.Offense.UpdateRecentAccuracy(audits, false, ownerMob)
        hasHit = false

    elseif messageId == Ashita.Message.CRITICAL_HIT then
        H.Offense.Hit(audits, meleeTypeOverall, damage, true)
        H.Offense.Hit(audits, meleeTypeSpecific, damage, true)
        H.Offense.UpdateRecentAccuracy(audits, true, ownerMob)
        wasCriticalHit = true

    -- Shadows have no impact on recent accuracy.
    elseif messageId == Ashita.Message.SHADOW_ABSORPTION then
        local metric = DB.Metric.SHADOW_ABSORPTION
        H.Offense.NoDamageHit(audits, meleeTypeOverall, metric)
        H.Offense.NoDamageHit(audits, meleeTypeSpecific, metric)

    elseif messageId == Ashita.Message.PERFECT_DODGE then
        H.Melee.Dodge(audits, meleeTypeOverall, meleeTypeSpecific)

    elseif messageId == Ashita.Message.MOB_HEAL_MELEE then
        H.Offense.MobHeal(audits, meleeTypeOverall, damage)
        H.Offense.MobHeal(audits, meleeTypeSpecific, damage)
        H.Offense.UpdateRecentAccuracy(audits, true, ownerMob)

    elseif messageId == Ashita.Message.RANGE_HIT then
        H.Offense.Hit(audits, meleeTypeOverall, damage)
        H.Offense.Hit(audits, meleeTypeSpecific, damage)
        H.Offense.UpdateRecentAccuracy(audits, true)

    elseif messageId == Ashita.Message.RANGE_MISS then
        H.Offense.Miss(audits, meleeTypeOverall)
        H.Offense.Miss(audits, meleeTypeSpecific)
        H.Offense.UpdateRecentAccuracy(audits, false, ownerMob)
        hasHit = false

    elseif messageId == Ashita.Message.RANGE_SQUARE_HIT then
        H.Offense.Hit(audits, meleeTypeOverall, damage)
        H.Offense.Hit(audits, meleeTypeSpecific, damage)
        H.Offense.UpdateRecentAccuracy(audits, true)

    elseif messageId == Ashita.Message.RANGE_TRUESTRIKE then
        H.Offense.Hit(audits, meleeTypeOverall, damage)
        H.Offense.Hit(audits, meleeTypeSpecific, damage)
        H.Offense.UpdateRecentAccuracy(audits, true)

    elseif messageId == Ashita.Message.RANGE_CRITICAL_HIT then
        H.Offense.Hit(audits, meleeTypeOverall, damage, true)
        H.Offense.Hit(audits, meleeTypeSpecific, damage, true)
        H.Offense.UpdateRecentAccuracy(audits, true, ownerMob)
        wasCriticalHit = true

    else
        local warning = string.format("Player {%s} had unhandled melee message {%d}.", audits.player_name, messageId or 0)
        Debug.Error.Add(Debug.Error.WARNING, "H.Melee.Message", warning)
        hasHit = false
    end

    return wasCriticalHit, hasHit
end

------------------------------------------------------------------------------------------------------
-- Regular melee evaded by Pefect Dodge.
-- Remove the count so perfect dodge isn't penalized.
------------------------------------------------------------------------------------------------------
---@param audits            table        contains necessary entity audit data; helps save on parameter slots.
---@param meleeTypeOverall  DB.Trackable player melee or pet melee.
---@param meleeTypeSpecific DB.Trackable main-hand, off-hand, etc.
------------------------------------------------------------------------------------------------------
H.Melee.Dodge = function(audits, meleeTypeOverall, meleeTypeSpecific)
    DB.Data.Update(DB.UpdateMode.INC, -1, audits, meleeTypeOverall,  DB.Metric.ATTEMPTS_ON_TARGET)
    DB.Data.Update(DB.UpdateMode.INC, -1, audits, meleeTypeSpecific, DB.Metric.ATTEMPTS_ON_TARGET)
end

------------------------------------------------------------------------------------------------------
-- Captures additional effects from melee.
------------------------------------------------------------------------------------------------------
---@param audits     table Contains necessary entity audit data; helps save on parameter slots.
---@param actionData table
---@return integer
------------------------------------------------------------------------------------------------------
H.Melee.AdditionalEffect = function(audits, actionData)
    if not actionData or not actionData.has_add_effect then
        return 0
    end

    local additionalDamage = 0
    local messageId        = actionData.add_effect_message
    local animationId      = actionData.add_effect_animation
    local param            = actionData.add_effect_param      -- This is either damage or the type of debuff applied.

    -- Magical Enspell
    if messageId == Ashita.Message.ADDITIONAL_DAMAGE and animationId then
        local enspellName = Res.Spells.EnspellType[animationId]

        if enspellName then
            additionalDamage = param
            H.Offense.Hit(audits, DB.Trackable.SPELLS_OVERALL, additionalDamage)
            H.Offense.CatalogHit(audits, DB.Trackable.MELEE_ENSPELL, additionalDamage, enspellName)
        end

    -- Endamage from a weapon.
    elseif messageId == Ashita.Message.ENDAMAGE and animationId then
        local effectName = Res.Game.EffectAnimation[animationId]

        if effectName then
            additionalDamage = param
            H.Offense.Hit(audits, DB.Trackable.SPELLS_OVERALL, additionalDamage)
            H.Offense.CatalogHit(audits, DB.Trackable.MELEE_ENDAMAGE, additionalDamage, effectName)
        end

    -- Debuff applied by a weapon.
    elseif messageId == Ashita.Message.ENDEBUFF then
        local buff = Res.Buffs.List[param]

        if buff then
            H.Offense.CatalogNoDamageHit(audits, DB.Trackable.MELEE_ENDEBUFF, buff.en)
        end

    -- Drain Samba and Blood Weapon do not contribute to net new damage.
    elseif messageId == Ashita.Message.ENDRAIN then
        H.Offense.Hit(audits, DB.Trackable.MELEE_ENDRAIN, param)

    -- Aspir does not contribute to net new damage.
    elseif messageId == Ashita.Message.ENASPIR then
        H.Offense.Hit(audits, DB.Trackable.MELEE_ENASPIR, param)
    end

    return additionalDamage
end

------------------------------------------------------------------------------------------------------
-- Detects how much damage the player took from the spike damage.
------------------------------------------------------------------------------------------------------
---@param audits     table contains necessary entity audit data; helps save on parameter slots.
---@param actionData table action data
---@param ownerMob?  table
------------------------------------------------------------------------------------------------------
H.Melee.Spikes = function(audits, actionData, ownerMob)
    if ownerMob or actionData.animation == Ashita.AttackAnimation.DAKEN then
        return nil
    end

    local wasCountered = false
    local spikeEffect = actionData.has_spike_effect

    if spikeEffect and not audits.pet_name then
        local damage         = actionData.spike_effect_param
        local spikeAnimation = actionData.spike_effect_animation
        local spikeMessage   = actionData.spike_effect_message
        local spikeTrackable = DB.Trackable.DEF_SPIKES

        -- Increment total damage taken.
        H.Defense.GrandTotals(audits, damage)

        if spikeMessage == Ashita.Message.SPIKE_DAMAGE then
            H.Offense.Hit(audits, DB.Trackable.DEF_NUKING, damage)

            if spikeAnimation == Ashita.EffectAnimation.FIRE then
                H.Offense.CatalogHit(audits, spikeTrackable, damage, "Blaze Spikes")

            elseif spikeAnimation == Ashita.EffectAnimation.ICE then
                H.Offense.CatalogHit(audits, spikeTrackable, damage, "Ice Spikes")

            elseif spikeAnimation == Ashita.EffectAnimation.THUNDER then
                H.Offense.CatalogHit(audits, spikeTrackable, damage, "Shock Spikes")
            end

        elseif spikeMessage == Ashita.Message.MELEE_COUNTER then
            wasCountered = true
            H.Offense.Hit(audits, DB.Trackable.DEF_MELEE, damage)
            H.Offense.Hit(audits, DB.Trackable.DEF_COUNTERED, damage)
        end
    end

    -- This needs to be incremented whether there was a spike effect or not.
    if not wasCountered then
        H.Offense.Miss(audits, DB.Trackable.DEF_COUNTERED)
    end
end