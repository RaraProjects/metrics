Column = {}

Column.Flags = {
    None = bit.bor(ImGuiTableColumnFlags_None),
    Expandable = bit.bor(ImGuiTableColumnFlags_WidthStretch),
}

Column.Widths = {
    Name = 150,
    Parse = 60,
    Percent = 60,
    Single = 40,
    Standard = 75,
    Settings = 175,
    Report = 110,
    Catalog = 65,
}

-- Load dependencies
require("columns.string")
require("columns.damage")
require("columns.attack_speed")
require("columns.defense")
require("columns.healing")
require("columns.accuracy")
require("columns.proc")
require("columns.spell")
require("columns.catalog")
require("columns.util")
require("columns.general")

Column.Output = {}

------------------------------------------------------------------------------------------------------
-- Grabs an entities accuracy for a specific trackable.
-- Accuracy can be broken up into type--like melee and ranged--or melee and ranged combined.
------------------------------------------------------------------------------------------------------
---@param value integer
---@param color table
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Output.Number = function(value, color, justify, raw)
    if raw then return Column.String.Format_Number(value) end
    return UI.TextColored(color, Column.String.Format_Number(value, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs an entities accuracy for a specific trackable.
-- Accuracy can be broken up into type--like melee and ranged--or melee and ranged combined.
------------------------------------------------------------------------------------------------------
---@param numerator integer
---@param denominator integer
---@param color table
---@param no_scaling? boolean
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Output.Percent = function(numerator, denominator, color, no_scaling, justify, raw)
    if raw then return Column.String.FormatPercent(numerator, denominator, justify, no_scaling) end
    return UI.TextColored(color, Column.String.FormatPercent(numerator, denominator, justify, no_scaling))
end