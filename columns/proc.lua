Column.Proc = { }

------------------------------------------------------------------------------------------------------
-- Grabs how many times an entity has died.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param justify?   boolean whether or not to right justify the text.
---@return string
------------------------------------------------------------------------------------------------------
Column.Proc.Deaths = function(playerName, justify)
    local deathCount = DB.Data.Get(playerName, DB.Trackable.DEATH, DB.Metric.ATTEMPTS_ON_USE)
    local color      = Column.String.ColorZero(deathCount)

    return UI.TextColored(color, Column.String.FormatNumber(deathCount, justify))
end