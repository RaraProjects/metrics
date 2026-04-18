Column.Defense = { }

------------------------------------------------------------------------------------------------------
-- Grabs the damage of a certain trackable that the entity has taken.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable a trackable from the model.
---@param percent?   boolean      whether or not the damage should be raw or percent.
---@param justify?   boolean      whether or not to right justify the text
---@param raw?       boolean      true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Defense.DamageTakenByType = function(playerName, trackable, percent, justify, raw)
    local total = DB.Data.Get(playerName, trackable, DB.Metric.TOTAL)
    local color = Column.String.ColorZero(total)

    if percent then
        local totalDamage = DB.Data.Get(playerName, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, DB.Metric.TOTAL)

        return raw and Column.String.FormatPercent(total, totalDamage) or UI.TextColored(color, Column.String.FormatPercent(total, totalDamage, justify))
    end

    return raw and Column.String.FormatNumber(total) or UI.TextColored(color, Column.String.FormatNumber(total, justify))
end

------------------------------------------------------------------------------------------------------
-- Approximates how much damage has been potentially mitigated by the given mitigation type.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable a trackable from the model.
---@param justify?   boolean      whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.Defense.DamageMitigation = function(playerName, trackable, justify)
    -- How many times the damage mitigation has proc'd.
    local procs = DB.Data.Get(playerName, trackable, DB.Metric.HITS_ON_TARGET)
    local color = Column.String.ColorZero(procs)

    if procs == 0 then
        return UI.TextColored(color, Column.String.FormatNumber(procs))
    end

    -- What is the average unmitigated melee damage? (We ignore ranged evasions here)
    local unmitigatedTrackable = DB.Trackable.DEF_UNMITIGATED_MELEE

    if trackable == DB.Trackable.DEF_EVASION_RANGED or trackable == DB.Trackable.DEF_SHADOWS_RANGED then
        unmitigatedTrackable = DB.Trackable.DEF_UNMITIGATED_RANGED
    elseif trackable == DB.Trackable.DEF_SHADOWS_MAGIC then
        unmitigatedTrackable = DB.Trackable.DEF_UNMITIGATED_MAGIC
    end

    local averageMelee = Column.Defense.AverageDamageByType(playerName, unmitigatedTrackable, false, true)
    color = Column.String.ColorZero(averageMelee)

    if averageMelee == 0 then
        return UI.TextColored(color, "...")
    end

    -- What is the average damage for the trackable?
    local averageTrackable = Column.Defense.AverageDamageByType(playerName, trackable, false, true)

    -- Counter reduces damage 100%, but stores counter damage done.
    if trackable == DB.Trackable.MELEE_COUNTER then
        averageTrackable = 0
    end

    local damageMitigated = math.max(0, procs * (averageMelee - averageTrackable))
    color = Column.String.ColorZero(damageMitigated)

    return UI.TextColored(color, Column.String.FormatNumber(damageMitigated, justify))
end

------------------------------------------------------------------------------------------------------
-- Gets the average amount of damage taken per damage type.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable a trackable from the model.
---@param justify?   boolean      whether or not to right justify the text
---@param raw?       boolean      true: just output the raw value; false: output a column to a table.
---@return integer
------------------------------------------------------------------------------------------------------
Column.Defense.AverageDamageByType = function(playerName, trackable, justify, raw)
    local count = DB.Data.Get(playerName, trackable, DB.Metric.HITS_ON_TARGET)
    local color = Column.String.ColorZero(count)

    if count == 0 then
        return raw and 0 or UI.TextColored(color, "...", justify)
    end

    local damage        = DB.Data.Get(playerName, trackable, DB.Metric.TOTAL)
    local averageDamage = math.floor(damage / count)

    color = Column.String.ColorZero(damage)

    return raw and averageDamage or UI.TextColored(color, Column.String.FormatPercent(damage, count, justify, true))
end

------------------------------------------------------------------------------------------------------
-- Calculates how what the DT% is for a given mitigation type.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable a trackable from the model.
---@param justify?   boolean      whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.Defense.DamageReduction = function(playerName, trackable, justify)
    local averageMelee = Column.Defense.AverageDamageByType(playerName, DB.Trackable.DEF_UNMITIGATED_MELEE, false, true)
    local color        = Column.String.ColorZero(averageMelee)

    if averageMelee == 0 then
        return UI.TextColored(color, "...")
    end

    local averageReducedDamage = Column.Defense.AverageDamageByType(playerName, trackable, false, true)
    color = Column.String.ColorZero(averageReducedDamage)

    return UI.TextColored(color, Column.String.FormatPercent(averageMelee - averageReducedDamage, averageMelee, justify))
end