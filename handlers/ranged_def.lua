H.RangedDef = { }

------------------------------------------------------------------------------------------------------
-- Parse the ranged attack packet.
------------------------------------------------------------------------------------------------------
---@param action     table   action packet data.
---@param actorMob   table   the mob data of the entity performing the action.
---@param ownerMob?  table
---@param logDefense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.RangedDef.Action = function(action, actorMob, ownerMob, logDefense)
    if not logDefense then
        return nil
    end

    -- Keep the mob list up-to-date.
    if Ashita.Mob.IsMonster(actorMob) then
        DB.Lists.AddToInitializedMobs(actorMob.name)
    end

    local damage = 0

    for _, target in pairs(action.targets) do
        local targetMob = Ashita.Mob.GetMobByID(target.id) or { name = DB.Enum.DEBUG }

        if Ashita.Party.IsAffiliate(targetMob.name) or Ashita.Mob.PetOwner(targetMob) or Parse.Config.IsLurking() then
            for _, actionData in pairs(target.actions) do
                damage = damage + H.RangedDef.Parse(actionData, actorMob, targetMob, ownerMob)
            end
        end
    end

    Blog.Add(actorMob.name, nil, Blog.ActionType.MOB_RANGED, DB.Trackable.RANGED_OVERALL, damage)
end

------------------------------------------------------------------------------------------------------
-- Set data for a ranged attack action.
------------------------------------------------------------------------------------------------------
---@param actionData table contains all the information for the action.
---@param actorMob   table name of the mob that did the action.
---@param targetMob  table name of the target player that received the action.
---@param ownerMob?  table if the action was from a pet then this will hold the owner's mob.
---@return number
------------------------------------------------------------------------------------------------------
H.RangedDef.Parse = function(actionData, actorMob, targetMob, ownerMob)
    Debug.Packet.AddAction(actorMob.name, targetMob.name, "Ranged Def.", actionData)

    local damage          = actionData.param
    local messageId       = actionData.message
    local playerName      = targetMob.name
    local mobName         = actorMob.name
    local rangedTrackable = DB.Trackable.DEF_RANGED
    local petName

    -- Need special handling for pets
    if ownerMob then
        petName         = targetMob.name
        playerName      = ownerMob.name
        rangedTrackable = DB.Trackable.DEF_RANGED_PET
    end

    local audits =
    {
        player_name = playerName,
        target_name = mobName,
        pet_name    = petName,
    }

    -- No damage Messages (miss, third eye, shadows, etc.)
    local noDamage = H.MessageNoDamage(messageId)
    if noDamage then
        damage = 0
    end

    -- Add to total damage taken metrics.
    H.Defense.GrandTotals(audits, damage, ownerMob)

    -- Mitigation from pets is not tracked at this time.
    if ownerMob then
        if damage > 0 then
            H.Offense.Hit(audits, rangedTrackable, damage)
            H.Offense.MinMax(audits, rangedTrackable, damage)
        else
            H.Offense.Miss(audits, rangedTrackable)
        end

    -- There is an order of operations to defensive actions. Need to protect the denominator.
    else
        -- Full Mitigation
        local fullMitigation =
            H.Defense.Mitigation(audits, DB.Trackable.DEF_EVASION_RANGED, damage, messageId, Ashita.Message.RANGE_MISS, true) or
            H.Defense.Mitigation(audits, DB.Trackable.DEF_SHADOWS_RANGED, damage, messageId, Ashita.Message.SHADOW_ABSORPTION, true)

        -- Full damage mitigation just increments attempts.
        if fullMitigation then
            H.Offense.Miss(audits, rangedTrackable)

        -- Totally unmitigated hit.
        else
            H.Offense.Hit(audits, rangedTrackable, damage)
            H.Offense.MinMax(audits, rangedTrackable, damage)
            H.Offense.Hit(audits, DB.Trackable.DEF_UNMITIGATED_RANGED, damage)
        end

        H.Defense.Crit(audits, damage, messageId)
    end

    -- Set battle log flags.
    if noDamage then
        damage = -1
    end

    return damage
end