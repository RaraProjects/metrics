Column = T{}

Column.Flags = T{
    None = bit.bor(ImGuiTableColumnFlags_None),
    Expandable = bit.bor(ImGuiTableColumnFlags_WidthStretch),
}

Column.Widths = T{
    Name = 150,
    Parse = 60,
    Percent = 60,
    Single = 40,
    Standard = 75,
    Settings = 175,
    Report = 110,
    Catalog = 65,
}

Column.Mode = DB.Enum.Mode
Column.Trackable = DB.Enum.Trackable
Column.Metric = DB.Enum.Metric

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