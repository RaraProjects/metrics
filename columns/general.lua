Column.General = T{}

------------------------------------------------------------------------------------------------------
-- Takes one metric and divides it by another metric.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the model.
---@param metric string a metric from the model.
---@param metric_denominator string metric from the model to be used as a denominator in a percent calculation.
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.General.Fraction = function(player_name, trackable, metric, metric_denominator, justify, raw)
    local numerator = DB.Data.Get(player_name, trackable, metric)
    local color = Column.String.Color_Zero(numerator)
    local denominator = DB.Data.Get(player_name, trackable, metric_denominator)
    if not denominator or denominator <= 0 then return UI.TextColored(color, Column.String.Format_Percent(0, 0, justify)) end
    if raw then return Column.String.Format_Percent(numerator, denominator) end
    return UI.TextColored(color, Column.String.Format_Percent(numerator, denominator, justify))
end

------------------------------------------------------------------------------------------------------
-- Takes the total metric from a trackable and divides by how much of the trackable the party has done.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the model.
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.General.Percent_Party_Total = function(player_name, trackable, justify, raw)
    local player_total = DB.Data.Get(player_name, trackable, Column.Metric.TOTAL)
    local color = Column.String.Color_Zero(player_total)
    local party_total = 0
    for name, _ in pairs(DB.Tracking.Initialized_Players) do
        party_total = party_total + DB.Data.Get(name, trackable, Column.Metric.TOTAL)
    end
    if raw then return Column.String.Format_Percent(player_total, party_total) end
    return UI.TextColored(color, Column.String.Format_Percent(player_total, party_total, justify))
end