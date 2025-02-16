Column.Single = {}

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs how many times a cataloged action was magic burst.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@return string
------------------------------------------------------------------------------------------------------
Column.Single.Bursts = function(player_name, action_name)
    local burst_count = DB.Catalog.Get(player_name, DB.Trackable.SPELLS_NUKING, action_name, DB.Metric.MAGIC_BURST_COUNT)
    local color = Column.String.Color_Zero(burst_count)
    return UI.TextColored(color, Column.String.FormatNumber(burst_count))
end