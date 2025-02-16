Column.Proc = {}

------------------------------------------------------------------------------------------------------
-- Grabs how many times an entity has died.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param justify? boolean whether or not to right justify the text.
---@return string
------------------------------------------------------------------------------------------------------
Column.Proc.Deaths = function(player_name, justify)
    local death_count = DB.Data.Get(player_name, DB.Trackable.DEATH, DB.Metric.ATTEMPTS_ON_USE)
    local color = Column.String.Color_Zero(death_count)
    return UI.TextColored(color, Column.String.FormatNumber(death_count, justify))
end

------------------------------------------------------------------------------------------------------
-- Gets the proc rate for ranged attack distance corrections (square hit or true strike).
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param correction_type string
---@param justify? boolean
---@return string
------------------------------------------------------------------------------------------------------
Column.Proc.Distance_Correction = function(player_name, correction_type, justify)
    local ranged_shots = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, DB.Metric.ATTEMPTS_ON_USE)
    local correction_hits = DB.Data.Get(player_name, correction_type, DB.Metric.HITS_ON_USE)
    local color = Column.String.Color_Zero(correction_hits)
    if ranged_shots == 0 or correction_hits == 0 then return UI.TextColored(color, Column.String.FormatNumber(0, justify)) end
    return UI.TextColored(color, Column.String.FormatPercent(correction_hits, ranged_shots))
end