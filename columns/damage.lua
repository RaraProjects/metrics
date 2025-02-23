Column.Damage = { }

------------------------------------------------------------------------------------------------------
-- Grabs the damage of a certain trackable that the entity has done.
------------------------------------------------------------------------------------------------------
---@param playerName     string
---@param trackable      DB.Trackable a trackable from the model.
---@param metric?        string
---@param percentPlayer? boolean      whether or not the damage should be raw or percent.
---@param justify?       boolean      whether or not to right justify the text
---@param raw?           boolean      true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.ByType = function(playerName, trackable, metric, actionName, percentPlayer, justify, raw)
    local trackableDamage = 0
    metric = metric or DB.Metric.TOTAL

    if actionName then
        trackableDamage = DB.Catalog.Get(playerName, trackable, actionName, metric)
    else
        trackableDamage = DB.Data.Get(playerName, trackable, metric)
    end

    if DB.MetricNeedsMaxValue(metric) and trackableDamage >= DB.Enum.MAX_DAMAGE then trackableDamage = 0 end

    local color = Column.String.ColorZero(trackableDamage)

    if percentPlayer then
        local totalDamage = Column.Damage.RawTotalPlayerDamage(playerName)

        if trackable == DB.Trackable.SPELLS_HEALING or
           trackable == DB.Trackable.ABILITY_HEALING or
           trackable == DB.Trackable.PET_HEALING or
           trackable == DB.Trackable.ALL_HEAL then
            totalDamage = DB.Data.Get(playerName, DB.Trackable.ALL_HEAL, DB.Metric.TOTAL)
        end

        return Column.Output.Percent(trackableDamage, totalDamage, color, false, justify, raw)
    end

    return Column.Output.Number(trackableDamage, color, justify, raw)
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- This is for pet actions.
-- Grabs the total amount of damage a cataloged action has done for a given trackable and metric.
------------------------------------------------------------------------------------------------------
---@param playerName  string
---@param petName     string
---@param trackable   DB.Trackable a trackable from the model.
---@param metric?     string       a metric from the model.
---@param actionName? string
---@param percentPet? boolean      whether or not the damage should be raw or percent.
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.ByTypePet = function(playerName, petName, trackable, metric, actionName, percentPet)
    local trackableDamage = 0
    metric = metric or DB.Metric.TOTAL

    if actionName then
        trackableDamage = DB.PetCatalog.Get(playerName, petName, trackable, actionName, metric)
    else
        trackableDamage = DB.PetData.Get(playerName, petName, trackable, metric)
    end

    if DB.MetricNeedsMaxValue(metric) and trackableDamage >= DB.Enum.MAX_DAMAGE then trackableDamage = 0 end

    local color = Column.String.ColorZero(trackableDamage)

    if percentPet then
        local totalDamage = DB.PetData.Get(playerName, petName, DB.Trackable.TOTAL_DAMAGE, DB.Metric.TOTAL)

        return UI.TextColored(color, Column.String.FormatPercent(trackableDamage, totalDamage))
    end

    return UI.TextColored(color, Column.String.FormatNumber(trackableDamage))
end

------------------------------------------------------------------------------------------------------
-- Grabs an entity's critical hit damage for a given trackable.
-- Can also give combine melee/ranged crit damage.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  string
---@param percent?   boolean whether or not the damage should be raw or percent.
---@param justify?   boolean whether or not to right justify the text.
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.ByTypeCrit = function(playerName, trackable, percent, justify)
    local critDamage = 0

    -- Get data
    if trackable == DB.Enum.COMBINED then
        local meleeCrits  = DB.Data.Get(playerName, DB.Trackable.MELEE_OVERALL,  DB.Metric.CRITICAL_DAMAGE)
        local rangedCrits = DB.Data.Get(playerName, DB.Trackable.RANGED_OVERALL, DB.Metric.CRITICAL_DAMAGE)

        critDamage = meleeCrits + rangedCrits
    else
        critDamage = DB.Data.Get(playerName, trackable, DB.Metric.CRITICAL_DAMAGE)
    end

    -- Colors
    local color = Column.String.ColorZero(critDamage)

    if percent then
        local totalDamage = Column.Damage.RawTotalPlayerDamage(playerName)

        return Column.Output.Percent(critDamage, totalDamage, color, false, justify)
    end

    return Column.Output.Number(critDamage, color, true, justify)
end

------------------------------------------------------------------------------------------------------
-- Shows the average damage for a trackable (like weaponskills).
------------------------------------------------------------------------------------------------------
---@param playerName    string
---@param trackable     DB.Trackable a trackable from the model.
---@param damageMetric? DB.Metric
---@param actionName?   string
---@param justify?      boolean      whether or not to right justify the text
---@param raw?          boolean
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.ByTypeAverage = function(playerName, trackable, damageMetric, actionName, justify, raw)
    local damage      = 0
    local hits        = 0
    damageMetric      = damageMetric or DB.Metric.TOTAL
    local countMetric = damageMetric == DB.Metric.CRITICAL_DAMAGE and DB.Metric.CRITICAL_COUNT or DB.Metric.HITS_ON_TARGET

    if actionName then
        damage = DB.Catalog.Get(playerName, trackable, actionName, damageMetric)
        hits   = DB.Catalog.Get(playerName, trackable, actionName, countMetric)
    else
        damage = DB.Data.Get(playerName, trackable, damageMetric)
        hits   = DB.Data.Get(playerName, trackable, countMetric)
    end

    local color = Column.String.ColorZero(damage)

    if damage == 0 or hits == 0 then
        return Column.Output.Number(0, color, justify, raw)
    end

    return Column.Output.Percent(damage, hits, color, true, justify, raw)
end

------------------------------------------------------------------------------------------------------
-- Shows the average non-critical damage for a given damage type.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable a trackable from the model.
---@param justify?   boolean      whether or not to right justify the text
---@return number
------------------------------------------------------------------------------------------------------
Column.Damage.AverageByTypeExcludeCritical = function(playerName, trackable, justify)
    local damage     = DB.Data.Get(playerName, trackable, DB.Metric.TOTAL)
    local critDamage = DB.Data.Get(playerName, trackable, DB.Metric.CRITICAL_DAMAGE)
    local hitCount   = DB.Data.Get(playerName, trackable, DB.Metric.HITS_ON_TARGET)
    local critCount  = DB.Data.Get(playerName, trackable, DB.Metric.CRITICAL_COUNT)

    -- Seperate the critical and non-critical hit damage.
    local nonCritDamage = damage - critDamage
    local nonCritCount  = hitCount - critCount

    -- Colors
    local color = Column.String.ColorZero(nonCritDamage)

    if nonCritDamage == 0 or nonCritCount == 0 then
        return UI.TextColored(color, Column.String.FormatPercent(0, 0, justify))
    end

    return UI.TextColored(color, Column.String.FormatPercent(nonCritDamage, nonCritCount, justify, true))
end

------------------------------------------------------------------------------------------------------
-- Gets the average critical hit damage for a given damage type.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  string
---@param justify?   boolean      whether or not to right justify the text.
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.AverageByTypeCriticalOnly = function(playerName, trackable, justify)
    local critDamage = 0
    local critCount  = 0

    -- Get data
    if trackable == DB.Enum.COMBINED then
        local meleeCrits      = DB.Data.Get(playerName, DB.Trackable.MELEE_OVERALL,  DB.Metric.CRITICAL_DAMAGE)
        local meleeCritCount  = DB.Data.Get(playerName, DB.Trackable.MELEE_OVERALL,  DB.Metric.CRITICAL_COUNT)
        local rangedCrits     = DB.Data.Get(playerName, DB.Trackable.RANGED_OVERALL, DB.Metric.CRITICAL_DAMAGE)
        local rangedCritCount = DB.Data.Get(playerName, DB.Trackable.RANGED_OVERALL, DB.Metric.CRITICAL_COUNT)

        critDamage = meleeCrits + rangedCrits
        critCount  = meleeCritCount + rangedCritCount
    else
        critDamage = DB.Data.Get(playerName, trackable, DB.Metric.CRITICAL_DAMAGE)
        critCount  = DB.Data.Get(playerName, trackable, DB.Metric.CRITICAL_COUNT)
    end

    -- Colors
    local color = Column.String.ColorZero(critDamage)

    return UI.TextColored(color, Column.String.FormatPercent(critDamage, critCount, justify, true))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- This is for pet actions.
-- Grabs the average damage for a given cataloged action and trackable.
------------------------------------------------------------------------------------------------------
---@param playerName  string
---@param petName     string
---@param trackable   DB.Trackable a trackable from the model.
---@param actionName? string
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.PetAverage = function(playerName, petName, trackable, actionName)
    local hits   = 0
    local damage = 0

    if actionName then
        hits   = DB.PetCatalog.Get(playerName, petName, trackable, actionName, DB.Metric.HITS_ON_TARGET)
        damage = DB.PetCatalog.Get(playerName, petName, trackable, actionName, DB.Metric.TOTAL)
    else
        hits   = DB.PetData.Get(playerName, petName, trackable, DB.Metric.HITS_ON_TARGET)
        damage = DB.PetData.Get(playerName, petName, trackable, DB.Metric.TOTAL)
    end

    local color = Column.String.ColorZero(hits)

    if hits == 0 or damage == 0 then
        return UI.TextColored(color, Column.String.FormatNumber(0))
    end

    return UI.TextColored(color, Column.String.FormatPercent(damage, hits, false, true))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs the usage rate of specfic enspells.
------------------------------------------------------------------------------------------------------
---@param playerName  string
---@param trackable   DB.Trackable a trackable from the model.
---@param actionName? string
---@param onTarget?   boolean
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.Hits = function(playerName, trackable, actionName, onTarget)
    local hits      = 0
    local hitMetric = onTarget and DB.Metric.HITS_ON_TARGET or DB.Metric.HITS_ON_USE

    if actionName then
        hits = DB.Catalog.Get(playerName, trackable, actionName, hitMetric)
    else
        hits = DB.Data.Get(playerName, trackable, hitMetric)
    end

    local color = Column.String.ColorZero(hits)

    return UI.TextColored(color, Column.String.FormatNumber(hits))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs how many times a cataloged action was attempted for a given trackable.
------------------------------------------------------------------------------------------------------
---@param playerName     string
---@param trackable      DB.Trackable a trackable from the model.
---@param attemptMetric? DB.Metric
---@param actionName?    string
---@param onTarget?      boolean
---@param raw?           boolean      true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.Attempts = function(playerName, trackable, attemptMetric, actionName, onTarget, raw)
    local attempts = 0
    attemptMetric  = onTarget and DB.Metric.ATTEMPTS_ON_TARGET or attemptMetric or DB.Metric.ATTEMPTS_ON_USE

    if actionName then
        attempts = DB.Catalog.Get(playerName, trackable, actionName, attemptMetric)
    else
        attempts = DB.Data.Get(playerName, trackable, attemptMetric)
    end

    local color = Column.String.ColorZero(attempts)

    if raw then return
        Column.String.FormatNumber(attempts)
    end

    return UI.TextColored(color, Column.String.FormatNumber(attempts))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- This is for pet actions.
-- Grabs how many times a cataloged action was attempted for a given trackable.
------------------------------------------------------------------------------------------------------
---@param playerName  string
---@param petName     string
---@param trackable   DB.Trackable a trackable from the model.
---@param actionName? string
---@param onTarget?   boolean
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.PetAttempts = function(playerName, petName, trackable, actionName, onTarget)
    local attemptMetric = onTarget and DB.Metric.ATTEMPTS_ON_TARGET or DB.Metric.ATTEMPTS_ON_USE
    local attempts      = 0

    if actionName then
        attempts = DB.PetCatalog.Get(playerName, petName, trackable, actionName, attemptMetric)
    else
        attempts = DB.PetData.Get(playerName, petName, trackable, attemptMetric)
    end

    local color = Column.String.ColorZero(attempts)

    return UI.TextColored(color, Column.String.FormatNumber(attempts))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs the total amount of damage a cataloged action has done for a given trackable and metric.
------------------------------------------------------------------------------------------------------
---@param playerName  string
---@param trackable   DB.Trackable a trackable from the model.
---@param unitMetric  string
---@param actionName? string
---@param burst?      boolean
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.PerUnit = function(playerName, trackable, unitMetric, actionName, burst)
    local damage      = 0
    local unit        = 0
    local metricTotal = burst and DB.Metric.CRITICAL_DAMAGE or DB.Metric.TOTAL

    if actionName then
        damage = DB.Catalog.Get(playerName, trackable, actionName, metricTotal)
        unit   = DB.Catalog.Get(playerName, trackable, actionName, unitMetric)
    else
        damage = DB.Data.Get(playerName, trackable, metricTotal)
        unit   = DB.Data.Get(playerName, trackable, unitMetric)
    end

    local finalUnit = unit

    -- Convert MP to Burst MP if needed.
    if burst then
        local targetCount   = DB.Data.Get(playerName, trackable, DB.Metric.ATTEMPTS_ON_TARGET)
        local burstAttempts = DB.Data.Get(playerName, trackable, DB.Metric.CRITICAL_COUNT)
        local unitPerTarget = unit / targetCount
        local burstMP       = unitPerTarget * burstAttempts
        finalUnit           = burstMP
    end

    -- Colors
    local color = Column.String.ColorZero(finalUnit)

    if damage == 0 or unit == 0 then
        color = Res.Colors.Basic.DIM
    end

    return UI.TextColored(color, Column.String.FormatPercent(damage, finalUnit, false, true))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs the average tp used for a weaponskill.
------------------------------------------------------------------------------------------------------
---@param playerName  string
---@param trackable   DB.Trackable
---@param unitMetric  string
---@param actionName? string
---@param justify?    boolean
------------------------------------------------------------------------------------------------------
Column.Damage.PerUnitAverage = function(playerName, trackable, unitMetric, actionName, justify)
    local tp        = 0
    local attempts  = 0

    -- If an action name isn't provided then get the overall weaponskill TP.
    if actionName then
        tp       = DB.Catalog.Get(playerName, trackable, actionName, unitMetric)
        attempts = DB.Catalog.Get(playerName, trackable, actionName, DB.Metric.ATTEMPTS_ON_USE)
    else
        tp       = DB.Data.Get(playerName, trackable, unitMetric)
        attempts = DB.Data.Get(playerName, trackable, DB.Metric.ATTEMPTS_ON_USE)
    end

    -- Colors
    local color = Column.String.ColorZero(tp)

    if tp == 0 or attempts == 0 then
        color = Res.Colors.Basic.DIM
    end

    return UI.TextColored(color, Column.String.FormatPercent(tp, attempts, justify, true))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs the average tp used for a pet weaponskill.
------------------------------------------------------------------------------------------------------
---@param playerName  string
---@param petName     string
---@param trackable   DB.Trackable
---@param actionName? string
------------------------------------------------------------------------------------------------------
Column.Damage.AveragePetTP = function(playerName, petName, trackable, actionName)
    local tp = 0
    local attempts = 0

    if actionName then
        tp       = DB.PetCatalog.Get(playerName, petName, trackable, actionName, DB.Metric.TP_SPENT)
        attempts = DB.PetCatalog.Get(playerName, petName, trackable, actionName, DB.Metric.ATTEMPTS_ON_USE)
    else
        tp       = DB.Data.Get(playerName, trackable, DB.Metric.TP_SPENT)
        attempts = DB.Data.Get(playerName, trackable, DB.Metric.ATTEMPTS_ON_USE)
    end

    local color = Column.String.ColorZero(tp)

    if tp == 0 or attempts == 0 then
        color = Res.Colors.Basic.DIM
    end

    return UI.TextColored(color, Column.String.FormatPercent(tp, attempts, false, true))
end

------------------------------------------------------------------------------------------------------
-- Grabs the damage of a certain trackable that the entity's pet has done.
------------------------------------------------------------------------------------------------------
---@param playerName string       the entity that owns the pet.
---@param petName    string       the pet that we want the damage for.
---@param trackable  DB.Trackable a trackable from the model.
---@param percent?   boolean      whether or not the damage should be raw or percent.
---@param justify?   boolean      whether or not to right justify the text
---@param allTotal?  boolean      controls denominator for %; true = pet total; false = all total
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.PetByType = function(playerName, petName, trackable, percent, justify, allTotal)
    local trackableDamage = DB.PetData.Get(playerName, petName, trackable, DB.Metric.TOTAL)
    local color           = Column.String.ColorZero(trackableDamage)

    if percent then
        local totalDamage = DB.Data.Get(playerName, DB.Trackable.PET_OVERALL, DB.Metric.TOTAL)

        if allTotal then
            totalDamage = DB.Data.Get(playerName, DB.Trackable.TOTAL_DAMAGE, DB.Metric.TOTAL)
        end

        return UI.TextColored(color, Column.String.FormatPercent(trackableDamage, totalDamage, justify))
    end

    return UI.TextColored(color, Column.String.FormatNumber(trackableDamage, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the damage of a certain trackable that the entity's pet has done.
------------------------------------------------------------------------------------------------------
---@param playerName string       the entity that owns the pet.
---@param petName?   string       the pet that we want the damage for.
---@param trackable  DB.Trackable a trackable from the model.
---@param justify?   boolean      whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.HealingPlayer = function(playerName, petName, trackable, justify)
    local healing = DB.Data.Get(playerName, trackable, DB.Metric.TOTAL)

    if petName then
        healing = DB.PetData.Get(playerName, petName, trackable, DB.Metric.TOTAL)
    end

    local color         = Column.String.ColorZero(healing)
    local playerHealing = DB.Data.Get(playerName, DB.Trackable.ALL_HEAL, DB.Metric.TOTAL)

    return UI.TextColored(color, Column.String.FormatPercent(healing, playerHealing, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the total damage that the entity has done.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param percent?   boolean whether or not the damage should be raw or percent.
---@param justify?   boolean whether or not to right justify the text
---@param raw?       boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.Total = function(playerName, percent, justify, raw)
    local grandTotal = Column.Damage.RawTotalPlayerDamage(playerName)
    local color      = Column.String.ColorZero(grandTotal)

    if percent then
        local partyDamage = DB.GetTeamDamage()

        if raw then
            return Column.String.FormatPercent(grandTotal, partyDamage)
        end

        return UI.TextColored(color, Column.String.FormatPercent(grandTotal, partyDamage, justify))
    end

    if raw then
        return Column.String.FormatNumber(grandTotal)
    end

    return UI.TextColored(color, Column.String.FormatNumber(grandTotal, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the total damage percentage that the entity has done.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable a trackable from the model.
---@param justify?   boolean      whether or not to right justify the text
---@param raw?       boolean      true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.PercentTotalByType = function(playerName, trackable, justify, raw)
    local total      = DB.Data.Get(playerName, trackable, DB.Metric.TOTAL)
    local color      = Column.String.ColorZero(total)
    local teamDamage = DB.GetTeamDamageByType(trackable)

    if raw then
        return Column.String.FormatPercent(total, teamDamage)
    end

    return UI.TextColored(color, Column.String.FormatPercent(total, teamDamage, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the total running damage for the player.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param justify?   boolean whether or not to right justify the text
------------------------------------------------------------------------------------------------------
Column.Damage.DPS = function(playerName, justify)
    local dps   = DB.DPS.GetDPS(playerName)
    local color = Column.String.ColorZero(dps)

    return UI.TextColored(color, Column.String.FormatNumber(dps, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the total damage that the entity has done.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@return number
------------------------------------------------------------------------------------------------------
Column.Damage.RawTotalPlayerDamage = function(playerName)
    if playerName then
        if Parse.Config.IncludeSkillchainDamage() then
            return DB.Data.Get(playerName, DB.Trackable.TOTAL_DAMAGE, DB.Metric.TOTAL)
        else
            return DB.Data.Get(playerName, DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN, DB.Metric.TOTAL)
        end
    end

    return 0
end

------------------------------------------------------------------------------------------------------
-- Calculates total for a trackable across all members of the database.
------------------------------------------------------------------------------------------------------
---@param trackable DB.Trackable
---@param justify? boolean whether or not to right justify the text
------------------------------------------------------------------------------------------------------
Column.Damage.TrackableTotal = function(trackable, justify)
    local damage = 0

    for playerName, _ in pairs(DB.Tracking.InitializedPlayers) do
        damage = damage + DB.Data.Get(playerName, trackable, DB.Metric.TOTAL)
    end

    local color = Column.String.ColorZero(damage)

    return UI.TextColored(color, Column.String.FormatNumber(damage, justify))
end

------------------------------------------------------------------------------------------------------
-- Displays the sum total damage of all members of the database.
------------------------------------------------------------------------------------------------------
---@param justify? boolean whether or not to right justify the text
------------------------------------------------------------------------------------------------------
Column.Damage.ParseTotal = function(justify)
    local damage = DB.GetTeamDamage()
    local color  = Column.String.ColorZero(damage)

    return UI.TextColored(color, Column.String.FormatNumber(damage, justify))
end

------------------------------------------------------------------------------------------------------
-- Displays the sum dps of all members of the database.
------------------------------------------------------------------------------------------------------
---@param justify? boolean whether or not to right justify the text
------------------------------------------------------------------------------------------------------
Column.Damage.ParseDPS = function(justify)
    local dps = 0

    for playerName, _ in pairs(DB.Tracking.InitializedPlayers) do
        dps = dps + DB.DPS.GetDPS(playerName)
    end

    local color = Column.String.ColorZero(dps)

    return UI.TextColored(color, Column.String.FormatNumber(dps, justify))
end

------------------------------------------------------------------------------------------------------
-- Displays the sum dps of all members of the database.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param justify?   boolean whether or not to right justify the text
------------------------------------------------------------------------------------------------------
Column.Damage.ShotDistance = function(playerName, justify)
    local shotDistance = DB.Data.Get(playerName, DB.Trackable.RANGED_OVERALL, DB.Metric.SHOT_DISTANCE)

    if shotDistance then
        shotDistance = shotDistance / 100
    end

    local count = DB.Data.Get(playerName, DB.Trackable.RANGED_OVERALL, DB.Metric.ATTEMPTS_ON_TARGET)
    local color = Column.String.ColorZero(shotDistance)

    return UI.TextColored(color, Column.String.FormatPercent(shotDistance, count, justify))
end