H.Ranged = { }

------------------------------------------------------------------------------------------------------
-- Parse the ranged attack packet.
------------------------------------------------------------------------------------------------------
---@param action     table   action packet data.
---@param actorMob   table   the mob data of the entity performing the action.
---@param logOffense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.Ranged.Action = function(action, actorMob, logOffense)
    if not logOffense then
        return nil
    end

    local damage = 0

    for _, target in pairs(action.targets) do
        local targetMob = Ashita.Mob.GetMobByID(target.id) or { name = DB.Enum.DEBUG }

        -- Keep the mob list up-to-date.
        if Ashita.Mob.IsMonster(targetMob) then
            DB.Lists.AddToInitializedMobs(targetMob.name)
        end

        -- Loop through actions on the target.
        for _, actionData in pairs(target.actions) do
            damage = damage + H.Ranged.Parse(actionData, actorMob, targetMob)
        end
    end

    H.Ranged.Blog(actorMob, damage)
end

-- ------------------------------------------------------------------------------------------------------
-- Adds ranged damage to the battle log.
-- ------------------------------------------------------------------------------------------------------
---@param actorMob table the mob data of the entity performing the action.
---@param damage   number
-- ------------------------------------------------------------------------------------------------------
H.Ranged.Blog = function(actorMob, damage)
    Blog.Add(actorMob.name, nil, Blog.ActionType.RANGED, DB.Trackable.RANGED_OVERALL, damage)
end

------------------------------------------------------------------------------------------------------
-- Set data for a ranged attack action.
------------------------------------------------------------------------------------------------------
---@param actionData table contains all the information for the action.
---@param actorMob   table name of the player that did the action.
---@param targetMob  table name of the target that received the action.
---@param ownerMob?  table if the action was from a pet then this will hold the owner's mob.
---@return number
------------------------------------------------------------------------------------------------------
H.Ranged.Parse = function(actionData, actorMob, targetMob, ownerMob)
    Debug.Packet.AddAction(actorMob.name, targetMob.name, "Ranged", actionData)

    local damage          = actionData.param
    local messageId       = actionData.message
    local noDamage        = H.MessageNoDamage(messageId)
    local playerName      = actorMob.name
    local rangedTrackable = DB.Trackable.RANGED_OVERALL
    local petName

    if ownerMob then
        rangedTrackable = DB.Trackable.PET_RANGED_OVERALL
        petName         = playerName
        playerName      = ownerMob.name
    end

    local audits =
    {
        player_name = playerName,
        target_name = targetMob.name,
        pet_name    = petName,
    }

    local wasCriticalHit = H.Ranged.Message(audits, damage, messageId, rangedTrackable, ownerMob)

    -- Avoid setting any damage data if the shot missed or healed a mob or something.
    if not noDamage then
        H.Offense.GrandTotals(audits, damage, ownerMob)
        H.Offense.MinMax(audits, rangedTrackable, damage, wasCriticalHit)
    end

    -- This has its own damage separate from the intiial ranged shot.
    damage = damage + H.Ranged.AdditionalEffect(audits, actionData)

    -- Shot Distance
    H.Ranged.Distance(audits, actorMob, targetMob, rangedTrackable)

    if noDamage then
        damage = 0
    end

    return damage
end

------------------------------------------------------------------------------------------------------
-- Handle the various metrics based on message.
------------------------------------------------------------------------------------------------------
---@param audits            table          contains necessary entity audit data; helps save on parameter slots.
---@param damage            number
---@param messageId         Ashita.Message numberic identifier for system chat messages.
---@param rangedTypeOverall DB.Trackable   player ranged or melee ranged.
---@param ownerMob?         table
---@return boolean
------------------------------------------------------------------------------------------------------
H.Ranged.Message = function(audits, damage, messageId, rangedTypeOverall, ownerMob)
    local wasCriticalHit = false

    if messageId == Ashita.Message.RANGE_HIT then
        H.Offense.Hit(audits, rangedTypeOverall, damage)
        H.Offense.Miss(audits, DB.Trackable.RANGED_SQUARE_HIT)
        H.Offense.Miss(audits, DB.Trackable.RANGED_TRUE_STRIKE)
        H.Offense.UpdateRecentAccuracy(audits, true, ownerMob)

    -- PUP Ranged Attack
    elseif messageId == Ashita.Message.WEAPONSKILL_DAMAGE then
        H.Offense.Hit(audits, rangedTypeOverall, damage)

    elseif messageId == Ashita.Message.RANGE_MISS then
        H.Offense.Miss(audits, rangedTypeOverall)
        H.Offense.Miss(audits, DB.Trackable.RANGED_SQUARE_HIT)
        H.Offense.Miss(audits, DB.Trackable.RANGED_TRUE_STRIKE)
        H.Offense.UpdateRecentAccuracy(audits, false, ownerMob)

    elseif messageId == Ashita.Message.RANGE_SQUARE_HIT then
        H.Offense.Hit(audits, rangedTypeOverall, damage)
        H.Offense.Hit(audits, DB.Trackable.RANGED_SQUARE_HIT, damage)
        H.Offense.Miss(audits, DB.Trackable.RANGED_TRUE_STRIKE)
        H.Offense.UpdateRecentAccuracy(audits, true, ownerMob)

    elseif messageId == Ashita.Message.RANGE_TRUESTRIKE then
        H.Offense.Hit(audits, rangedTypeOverall, damage)
        H.Offense.Hit(audits, DB.Trackable.RANGED_TRUE_STRIKE, damage)
        H.Offense.Miss(audits, DB.Trackable.RANGED_SQUARE_HIT)
        H.Offense.UpdateRecentAccuracy(audits, true, ownerMob)

    -- Critical hits will not negatively impact true strike or square hit rates.
    elseif messageId == Ashita.Message.RANGE_CRITICAL_HIT then
        wasCriticalHit = true
        H.Offense.Hit(audits, rangedTypeOverall, damage, true)
        H.Offense.UpdateRecentAccuracy(audits, true, ownerMob)

    -- Shadows have no impact on recent accuracy.
    elseif messageId == Ashita.Message.SHADOW_ABSORPTION then
        H.Offense.NoDamageHit(audits, rangedTypeOverall, DB.Metric.SHADOW_ABSORPTION)

    elseif messageId == Ashita.Message.MOB_HEAL_MELEE then
        H.Offense.MobHeal(audits, rangedTypeOverall, damage)
        H.Offense.UpdateRecentAccuracy(audits, true, ownerMob)

    -- PUP ranged hits will not negatively impact true strike or square hit rates.
    elseif messageId == Ashita.Message.WEAPONSKILL_DAMAGE then
        H.Offense.Hit(audits, rangedTypeOverall, damage)
        H.Offense.UpdateRecentAccuracy(audits, true, ownerMob)

    else
        local errorMessage = string.format("Player {%s} had unhandled ranged message: {%d}.", audits.player_name, messageId or 0)
        Debug.Error.Add(Debug.Error.ERROR, "H.Ranged.Message", errorMessage)
    end

    return wasCriticalHit
end

------------------------------------------------------------------------------------------------------
-- Catalog's ranged attack additional effects.
-- Additional elemental effects are treated as magic damage.
------------------------------------------------------------------------------------------------------
---@param audits     table contains necessary entity audit data; helps save on parameter slots.
---@param actionData table
---@return integer
------------------------------------------------------------------------------------------------------
H.Ranged.AdditionalEffect = function(audits, actionData)
    if not actionData or not actionData.has_add_effect then
        return 0
    end

    local additionalDamage = 0
    local messageId        = actionData.add_effect_message
    local animationId      = actionData.add_effect_animation
    local param            = actionData.add_effect_param            -- This is either damage or the type of debuff applied.

    -- Additional elemental damage from ammunition.
    if messageId == Ashita.Message.ENDAMAGE and animationId then
        local effectName = Res.Game.EffectAnimation[animationId]
        additionalDamage = param
        H.Offense.Hit(audits, DB.Trackable.SPELLS_OVERALL, additionalDamage)
        H.Offense.CatalogHit(audits, DB.Trackable.RANGED_ENDAMAGE, additionalDamage, effectName)

    -- Debuff effect from ammunition.
    elseif messageId == Ashita.Message.ENDEBUFF then
        local buff = Res.Buffs.List[param]
        if buff then
            H.Offense.CatalogNoDamageHit(audits, DB.Trackable.RANGED_ENDEBUFF, buff.en)
        end

    -- Additional damage from bloody bolts.
    elseif messageId == Ashita.Message.ENDRAIN then
        additionalDamage = param
        H.Offense.GrandTotals(audits, param)                        -- Bloody Bolt is net additional damage.
        H.Offense.Hit(audits, DB.Trackable.SPELLS_OVERALL, param)   -- Bloody Bolt is net additional damage.
        H.Offense.Hit(audits, DB.Trackable.RANGED_ENDRAIN, param)

    -- Not sure if aspir bolts exist, but have this just in case.
    elseif messageId == Ashita.Message.ENASPIR then
        H.Offense.Hit(audits, DB.Trackable.RANGED_ENASPIR, param)
    end

    return additionalDamage
end

------------------------------------------------------------------------------------------------------
-- Gets the distance between the actor and target.
------------------------------------------------------------------------------------------------------
---@param audits    table        contains necessary entity audit data; helps save on parameter slots.
---@param actorMob  table
---@param targetMob table
---@param trackable DB.Trackable player ranged or melee ranged.
------------------------------------------------------------------------------------------------------
H.Ranged.Distance = function(audits, actorMob, targetMob, trackable)
    if not actorMob or not targetMob then
        return nil
    end

    -- Clamp distance between 0 and 30.
    local distance = math.max(0, math.min(Ashita.Mob.Distance(actorMob, targetMob), 30))

    DB.Data.Update(DB.UpdateMode.INC, distance, audits, trackable, DB.Metric.SHOT_DISTANCE)
end