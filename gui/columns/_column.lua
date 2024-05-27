Column = T{}

Column.Flags = T{
    None = bit.bor(ImGuiTableColumnFlags_None),
    Expandable = bit.bor(ImGuiTableColumnFlags_WidthStretch),
}

Column.Widths = T{
    Name = 110,
    Damage = 80,
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
require("gui.columns.string")
require("gui.columns.damage")
require("gui.columns.defense")
require("gui.columns.healing")
require("gui.columns.accuracy")
require("gui.columns.proc")
require("gui.columns.spell")
require("gui.columns.catalog")