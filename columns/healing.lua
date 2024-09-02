Column.Healing = T{}

------------------------------------------------------------------------------------------------------
-- Grabs the damage of a certain trackable that the entity has done.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param percent? boolean whether or not the damage should be raw or percent.
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Healing.Total = function(player_name, percent, justify, raw)
    local spell_healing = DB.Data.Get(player_name, DB.Enum.Trackable.HEALING, Column.Metric.TOTAL)
    local ability_healing = DB.Data.Get(player_name, DB.Enum.Trackable.ABILITY_HEALING, Column.Metric.TOTAL)
    local total_healing = spell_healing + ability_healing
    local color = Column.String.Color_Zero(total_healing)
    if percent then
        local total_damage = Column.Damage.Raw_Total_Player_Damage(player_name)
        if raw then return Column.String.Format_Percent(total_healing, total_damage) end
        return UI.TextColored(color, Column.String.Format_Percent(total_healing, total_damage, justify))
    end
    if raw then return Column.String.Format_Number(total_healing) end
    return UI.TextColored(color, Column.String.Format_Number(total_healing, justify))
end

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