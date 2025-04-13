Column.Acc = { }

------------------------------------------------------------------------------------------------------
-- Calculates text colors.
------------------------------------------------------------------------------------------------------
---@param numerator   integer
---@param denominator integer a trackable from the model.
---@param threshold?  number  whether or not to right justify the text
---@return table
------------------------------------------------------------------------------------------------------
Column.Acc.ColorSelection = function(numerator, denominator, threshold)
    local color   = Res.Colors.Basic.WHITE
    local percent = Column.String.RawPercent(numerator, denominator)

    if percent == 0 then
        color = Res.Colors.Basic.DIM
    elseif threshold and percent <= threshold then
        color = Res.Colors.Basic.RED
    end

    return color
end

------------------------------------------------------------------------------------------------------
-- Grabs an entities accuracy for a specific trackable.
-- Accuracy can be broken up into type--like melee and ranged--or melee and ranged combined.
------------------------------------------------------------------------------------------------------
---@param playerName   string
---@param trackable    string
---@param threshold?   integer
---@param criticalHit? boolean
---@param actionName?  string
---@param justify?     boolean whether or not to right justify the text
---@param raw?         boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Acc.ByType = function(playerName, trackable, threshold, criticalHit, actionName, justify, raw)
    local hitMetric     = criticalHit and DB.Metric.CRITICAL_COUNT or DB.Metric.HITS_ON_TARGET
    local attemptMetric = criticalHit and DB.Metric.HITS_ON_TARGET or DB.Metric.ATTEMPTS_ON_TARGET
    threshold           = criticalHit and 0 or threshold or DB.Settings.AccuracyWarning

    local hits, attempts

    -- Getting melee and ranged combine accuracy.
    if trackable == DB.Enum.COMBINED then
        local meleeHits      = DB.Data.Get(playerName, DB.Trackable.MELEE_OVERALL,  hitMetric)
        local meleeAttempts  = DB.Data.Get(playerName, DB.Trackable.MELEE_OVERALL,  attemptMetric)
        local rangedHits     = DB.Data.Get(playerName, DB.Trackable.RANGED_OVERALL, hitMetric)
        local rangedAttempts = DB.Data.Get(playerName, DB.Trackable.RANGED_OVERALL, attemptMetric)

        hits     = meleeHits + rangedHits
        attempts = meleeAttempts + rangedAttempts

    -- Getting the accuracy of an action like a weaponskill.
    elseif actionName then
        hits     = DB.Catalog.Get(playerName, trackable, actionName, hitMetric)
        attempts = DB.Catalog.Get(playerName, trackable, actionName, attemptMetric)

    -- General accuracy of melee or ranged attaack.
    else
        hits     = DB.Data.Get(playerName, trackable, hitMetric)
        attempts = DB.Data.Get(playerName, trackable, attemptMetric)
    end

    local color = Column.Acc.ColorSelection(hits, attempts, threshold)

    return Column.Output.Percent(hits, attempts, color, false, justify, raw)
end

------------------------------------------------------------------------------------------------------
-- Grabs the accuracy of a certain trackable that the entity's pet has done.
------------------------------------------------------------------------------------------------------
---@param playerName  string       the entity that owns the pet.
---@param petName     string       the pet that we want the damage for.
---@param trackable   DB.Trackable a trackable from the model.
---@param actionName? string
---@param justify?    boolean      whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.Acc.ByTypePet = function(playerName, petName, trackable, actionName, justify)
    local hitMetric     = DB.Metric.HITS_ON_TARGET
    local attemptMetric = DB.Metric.ATTEMPTS_ON_TARGET
    local hits          = 0
    local attempts      = 0

    if actionName then
        hits     = DB.PetCatalog.Get(playerName, petName, trackable, actionName, hitMetric)
        attempts = DB.PetCatalog.Get(playerName, petName, trackable, actionName, attemptMetric)
    else
        hits     = DB.PetData.Get(playerName, petName, trackable, hitMetric)
        attempts = DB.PetData.Get(playerName, petName, trackable, attemptMetric)
    end

    local color = Column.Acc.ColorSelection(hits, attempts, DB.Settings.AccuracyWarning)

    return Column.Output.Percent(hits, attempts, color, false, justify)
end

------------------------------------------------------------------------------------------------------
-- Grabs an entity's accuracy for last {X} amount of attempts. Includes melee and ranged combined.
-- {X} is defined in the model's settings.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param justify?   boolean
---@return string
------------------------------------------------------------------------------------------------------
Column.Acc.Recent = function(playerName, justify)
    local accuracy = DB.Accuracy.Get(playerName)
    local color    = Column.Acc.ColorSelection(accuracy[1], accuracy[2], DB.Settings.AccuracyWarning)

    return Column.Output.Percent(accuracy[1], accuracy[2], color, false, justify)
end

------------------------------------------------------------------------------------------------------
-- Grabs the multi attack rate for a specific melee type.
------------------------------------------------------------------------------------------------------
---@param playerName        string
---@param meleeType         DB.Trackable
---@param multiAttackMetric DB.Metric
---@param totalMulti?       boolean
---@return string
------------------------------------------------------------------------------------------------------
Column.Acc.MultiAttack = function(playerName, meleeType, multiAttackMetric, totalMulti)
    local multiAttack  = DB.Data.Get(playerName, meleeType, multiAttackMetric)
    local attackRounds = DB.Data.Get(playerName, meleeType, DB.Metric.ATTEMPTS_ON_USE)

    -- The denominator for the total multi attack needs to be the sum amount of attack rounds for main- and off-hand attacks.
    if totalMulti then
        local mainHandMulti = DB.Data.Get(playerName, DB.Trackable.MELEE_MAIN_HAND, DB.Metric.MULTI_ATTACK_HIT_ON_USE)
        local offHandMulti  = DB.Data.Get(playerName, DB.Trackable.MELEE_OFF_HAND, DB.Metric.MULTI_ATTACK_HIT_ON_USE)
        local mainHandCount = DB.Data.Get(playerName, DB.Trackable.MELEE_MAIN_HAND, DB.Metric.ATTEMPTS_ON_USE)
        local offHandCount  = DB.Data.Get(playerName, DB.Trackable.MELEE_OFF_HAND,  DB.Metric.ATTEMPTS_ON_USE)

        multiAttack  = mainHandMulti + offHandMulti
        attackRounds = mainHandCount + offHandCount
    end

    local color = Column.Acc.ColorSelection(multiAttack, attackRounds, 0)

    return Column.Output.Percent(multiAttack, attackRounds, color)
end

------------------------------------------------------------------------------------------------------
-- Displays Phantom Roll rates.
------------------------------------------------------------------------------------------------------
---@param playerName  string
---@param rollMetric  DB.Metric
---@param actionName? string
---@return string
------------------------------------------------------------------------------------------------------
Column.Acc.PhantomRoll = function(playerName, rollMetric, actionName)
    local trackable = DB.Trackable.PHANTOM_ROLL
    local rollHits  = DB.Data.Get(playerName, trackable, rollMetric)

    if actionName then
        rollHits = DB.Catalog.Get(playerName, trackable, actionName, rollMetric)
    end

    local rollAttempts = DB.Data.Get(playerName, trackable, DB.Metric.ATTEMPTS_ON_TARGET)
    local color        = Column.Acc.ColorSelection(rollHits, rollAttempts, 0)

    return Column.Output.Percent(rollHits, rollAttempts, color)
end

------------------------------------------------------------------------------------------------------
-- Displays how often certain additional effect debuffs proc.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable
---@param actionName string
---@return string
------------------------------------------------------------------------------------------------------
Column.Acc.AdditionalEffectProc = function(playerName, trackable, actionName)
    local hits     = DB.Catalog.Get(playerName, trackable, actionName, DB.Metric.HITS_ON_TARGET)
    local attempts = DB.Data.Get(playerName, DB.Trackable.DEF_MELEE, DB.Metric.ATTEMPTS_ON_TARGET)
    local color    = Column.Acc.ColorSelection(hits, attempts)

    return Column.Output.Percent(hits, attempts, color)
end