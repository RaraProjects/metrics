Parse = T{}

Parse.Tab_Name = "Parse"

-- Used to house general functions that I don't want immediately exposed.
Parse.Util = {}

-- Keeps track of how many columns should be shown on the screen in full mode.
Parse.Columns = {
    Base = 5,
    Current = 5,
    Max = 20,
}

-- Load dependencies
require("tabs.parse.config")
require("tabs.parse.display_full")
require("tabs.parse.display_mini")
require("tabs.parse.display_nano")
require("tabs.parse.widgets")

------------------------------------------------------------------------------------------------------
-- Initializes the Parse screen.
------------------------------------------------------------------------------------------------------
Parse.Initialize = function()
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Calculates how many columns should be shown on the Parse table based on column visibility flags.
------------------------------------------------------------------------------------------------------
Parse.Util.Calculate_Column_Flags = function()
    local added_columns = 0
    local added_width = 0
    if Metrics.Parse.Total_Acc then
        added_columns = added_columns + 1
        added_width = added_width + Column.Widths.Percent
    end
    if Metrics.Parse.Melee then
        added_columns = added_columns + 1
        added_width = added_width + Column.Widths.Damage
    end
    if Metrics.Parse.Crit then
        added_columns = added_columns + 1
        added_width = added_width + Column.Widths.Percent
    end
    if Metrics.Parse.Weaponskill then
        added_columns = added_columns + 1
        added_width = added_width + Column.Widths.Damage
    end
    if Parse.Config.Include_SC_Damage() then
        added_columns = added_columns + 1
        added_width = added_width + Column.Widths.Damage
    end
    if Metrics.Parse.Ranged then
        added_columns = added_columns + 1
        added_width = added_width + Column.Widths.Damage
    end
    if Metrics.Parse.Magic then
        added_columns = added_columns + 1
        added_width = added_width + Column.Widths.Damage
    end
    if Metrics.Parse.Ability then
        added_columns = added_columns + 1
        added_width = added_width + Column.Widths.Damage
    end
    if Metrics.Parse.Pet then
        added_columns = added_columns + 5
        added_width = added_width + (Column.Widths.Damage * 5)
    end
    if Metrics.Parse.Healing then
        added_columns = added_columns + 1
        added_width = added_width + Column.Widths.Damage
    end
    if Metrics.Parse.Deaths then
        added_columns = added_columns + 1
        added_width = added_width + Column.Widths.Damage
    end

    Parse.Full.Width.Current = Parse.Full.Width.Base + added_width

    -- Apply new column count.
    Parse.Columns.Current = Parse.Columns.Base + added_columns
    if Parse.Columns.Current > Parse.Columns.Max then Parse.Columns.Current = Parse.Columns.Max end
end