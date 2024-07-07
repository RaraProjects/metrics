Column.Attack_Speed = T{}

------------------------------------------------------------------------------------------------------
-- Gets a player's attack speed.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Attack_Speed.Get = function(player_name, justify, raw)
    local speed = DB.Attack_Speed.Get(player_name)

    local color = Res.Colors.Basic.WHITE
    if speed == 0 then color = Res.Colors.Basic.DIM end

    if raw then return Column.String.Format_Decimal(speed, justify) end
    return UI.TextColored(color, Column.String.Format_Decimal(speed, justify))
end