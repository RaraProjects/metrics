Column.Single = { }

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs how many times a cataloged action was magic burst.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param actionName string
---@return string
------------------------------------------------------------------------------------------------------
Column.Single.Bursts = function(playerName, actionName)
    local burstCount = DB.Catalog.Get(playerName, DB.Trackable.SPELLS_NUKING, actionName, DB.Metric.MAGIC_BURST_COUNT)
    local color      = Column.String.ColorZero(burstCount)

    return UI.TextColored(color, Column.String.FormatNumber(burstCount))
end