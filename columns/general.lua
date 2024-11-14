Column.General = T{}

------------------------------------------------------------------------------------------------------
-- Takes one metric and divides it by another metric.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the model.
---@param metric_numerator string a metric from the model.
---@param metric_denominator string metric from the model to be used as a denominator in a percent calculation.
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@param no_scaling? boolean do not scale the fraction by 100.
---@return string
------------------------------------------------------------------------------------------------------
Column.General.Fraction = function(player_name, trackable, metric_numerator, metric_denominator, justify, raw, no_scaling)
    local numerator = DB.Data.Get(player_name, trackable, metric_numerator)
    local color = Column.String.Color_Zero(numerator)
    local denominator = DB.Data.Get(player_name, trackable, metric_denominator)
    if not denominator or denominator <= 0 then return UI.TextColored(color, Column.String.Format_Percent(0, 0, justify)) end
    if raw then return Column.String.Format_Percent(numerator, denominator) end
    return UI.TextColored(color, Column.String.Format_Percent(numerator, denominator, justify, no_scaling))
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

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs the total amount of damage a cataloged action has done for a given trackable and metric.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param trackable string a trackable from the model.
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.General.Percent_Party_Total_Action = function(player_name, action_name, trackable, raw)
    local action_total = DB.Catalog.Get(player_name, trackable, action_name, Column.Metric.TOTAL)
    local color = Column.String.Color_Zero(action_total)
    local party_total = 0
    for name, _ in pairs(DB.Tracking.Initialized_Players) do
        party_total = party_total + DB.Data.Get(name, trackable, Column.Metric.TOTAL)
    end
    if raw then return Column.String.Format_Percent(action_total, party_total) end
    return UI.TextColored(color, Column.String.Format_Percent(action_total, party_total))
end

------------------------------------------------------------------------------------------------------
-- Takes the total metric from a pet specific trackable and divides by how much of the trackable the party has done.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param pet_name string
---@param trackable string a trackable from the model.
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.General.Percent_Party_Total_Pet = function(player_name, pet_name, trackable, justify, raw)
    local pet_total = DB.Pet_Data.Get(player_name, pet_name, trackable, Column.Metric.TOTAL)
    local color = Column.String.Color_Zero(pet_total)
    local party_total = 0
    for name, _ in pairs(DB.Tracking.Initialized_Players) do
        party_total = party_total + DB.Data.Get(name, trackable, Column.Metric.TOTAL)
    end
    if raw then return Column.String.Format_Percent(pet_total, party_total) end
    return UI.TextColored(color, Column.String.Format_Percent(pet_total, party_total, justify))
end
