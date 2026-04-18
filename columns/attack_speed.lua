Column.AttackSpeed = { }

------------------------------------------------------------------------------------------------------
-- Gets a player's attack speed.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param justify?   boolean whether or not to right justify the text
---@param raw?       boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.AttackSpeed.Get = function(playerName, justify, raw)
    local speed = DB.AttackSpeed.Get(playerName)
    local color = speed == 0 and Res.Colors.Basic.DIM or Res.Colors.Basic.WHITE

    if raw then
        return Column.String.FormatDecimal(speed, justify)
    end

    return UI.TextColored(color, Column.String.FormatDecimal(speed, justify))
end