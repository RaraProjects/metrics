Column.General = { }

------------------------------------------------------------------------------------------------------
-- Takes one metric and divides it by another metric.
------------------------------------------------------------------------------------------------------
---@param playerName        string
---@param trackable         DB.Trackable a trackable from the model.
---@param metricNumerator   DB.Metric    a metric from the model.
---@param metricDenominator DB.Metric    metric from the model to be used as a denominator in a percent calculation.
---@param justify?          boolean      whether or not to right justify the text
---@param raw?              boolean      true: just output the raw value; false: output a column to a table.
---@param noScaling?        boolean      do not scale the fraction by 100.
---@return string
------------------------------------------------------------------------------------------------------
Column.General.Fraction = function(playerName, trackable, metricNumerator, metricDenominator, justify, raw, noScaling)
    local numerator   = DB.Data.Get(playerName, trackable, metricNumerator)
    local color       = Column.String.ColorZero(numerator)
    local denominator = DB.Data.Get(playerName, trackable, metricDenominator)

    if not denominator or denominator <= 0 then
        return UI.TextColored(color, Column.String.FormatPercent(0, 0, justify))
    end

    if raw then
        return Column.String.FormatPercent(numerator, denominator)
    end

    return UI.TextColored(color, Column.String.FormatPercent(numerator, denominator, justify, noScaling))
end

------------------------------------------------------------------------------------------------------
-- Takes the total metric from a trackable and divides by how much of the trackable the party has done.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable a trackable from the model.
---@param justify?   boolean      whether or not to right justify the text
---@param raw?       boolean      true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.General.PercentPartyTotal = function(playerName, trackable, justify, raw)
    local playerTotal = DB.Data.Get(playerName, trackable, DB.Metric.TOTAL)
    local color       = Column.String.ColorZero(playerTotal)
    local partyTotal  = 0

    for name, _ in pairs(DB.Tracking.InitializedPlayers) do
        partyTotal = partyTotal + DB.Data.Get(name, trackable, DB.Metric.TOTAL)
    end

    if raw then
        return Column.String.FormatPercent(playerTotal, partyTotal)
    end

    return UI.TextColored(color, Column.String.FormatPercent(playerTotal, partyTotal, justify))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs the total amount of damage a cataloged action has done for a given trackable and metric.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param actionName string
---@param trackable  DB.Trackable a trackable from the model.
---@param raw?       boolean      true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.General.PercentPartyTotalAction = function(playerName, actionName, trackable, raw)
    local actionTotal = DB.Catalog.Get(playerName, trackable, actionName, DB.Metric.TOTAL)
    local color       = Column.String.ColorZero(actionTotal)
    local partyTotal  = 0

    for name, _ in pairs(DB.Tracking.InitializedPlayers) do
        partyTotal = partyTotal + DB.Data.Get(name, trackable, DB.Metric.TOTAL)
    end

    if raw then
        return Column.String.FormatPercent(actionTotal, partyTotal)
    end

    return UI.TextColored(color, Column.String.FormatPercent(actionTotal, partyTotal))
end

------------------------------------------------------------------------------------------------------
-- Takes the total metric from a pet specific trackable and divides by how much of the trackable the party has done.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param petName    string
---@param trackable  DB.Trackable a trackable from the model.
---@param justify?   boolean      whether or not to right justify the text
---@param raw?       boolean      true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.General.PercentPartyTotalPet = function(playerName, petName, trackable, justify, raw)
    local petTotal   = DB.PetData.Get(playerName, petName, trackable, DB.Metric.TOTAL)
    local color      = Column.String.ColorZero(petTotal)
    local partyTotal = 0

    for name, _ in pairs(DB.Tracking.InitializedPlayers) do
        partyTotal = partyTotal + DB.Data.Get(name, trackable, DB.Metric.TOTAL)
    end

    if raw then
        return Column.String.FormatPercent(petTotal, partyTotal)
    end

    return UI.TextColored(color, Column.String.FormatPercent(petTotal, partyTotal, justify))
end
