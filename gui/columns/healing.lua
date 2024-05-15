Column.Healing = T{}

------------------------------------------------------------------------------------------------------
-- Grabs the overcure amount for the player.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param justify? boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.Healing.Overcure = function(player_name, justify)
    local overcure = DB.Data.Get(player_name, Column.Trackable.HEALING, Column.Metric.OVERCURE)
    local color = Column.String.Color_Zero(overcure)
    return UI.TextColored(color, Column.String.Format_Number(overcure, justify))
end