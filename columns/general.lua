Column.General = T{}

------------------------------------------------------------------------------------------------------
-- Grabs the damage of a certain trackable that the entity has done.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the model.
---@param metric string a metric from the model.
---@param metric_denominator? string metric from the model to be used as a denominator in a percent calculation.
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.General.By_Type = function(player_name, trackable, metric, metric_denominator, justify, raw)
    local numerator = DB.Data.Get(player_name, trackable, metric)
    local color = Column.String.Color_Zero(numerator)
    if metric_denominator then
        local denominator = DB.Data.Get(player_name, trackable, metric_denominator)
        if not denominator or denominator <= 0 then return UI.TextColored(color, Column.String.Format_Percent(0, 0, justify)) end
        if raw then return Column.String.Format_Percent(numerator, denominator) end
        return UI.TextColored(color, Column.String.Format_Percent(numerator, denominator, justify))
    end
    if raw then return Column.String.Format_Number(numerator) end
    return UI.TextColored(color, Column.String.Format_Number(numerator, justify))
end