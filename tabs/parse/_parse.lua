Parse = T{}

Parse.Tab_Name = "Parse"

-- Used to house general functions that I don't want immediately exposed.
Parse.Util = {}

-- Keeps track of how many columns should be shown on the screen in full mode.
Parse.Columns = {
    Base = 5,
    Current = 10,
    Start = 6,
    Max = 18,
    Default = 10,
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
    if Metrics.Team.Flags.Total_Damage_Only then
        Parse.Columns.Current = Parse.Columns.Base
    else
        local added_columns = Parse.Columns.Start
        if Metrics.Team.Flags.Pet then added_columns = added_columns + 5 end
        if Metrics.Team.Flags.Crit then added_columns = added_columns + 1 end
        if Metrics.Team.Settings.Include_SC_Damage then added_columns = added_columns + 1 end
        if Metrics.Team.Flags.Healing then added_columns = added_columns + 1 end
        if Metrics.Team.Flags.Deaths then added_columns = added_columns + 1 end

        -- Apply new column count.
        Parse.Columns.Current = Parse.Columns.Base + added_columns
        if Parse.Columns.Current > Parse.Columns.Max then Parse.Columns.Current = Parse.Columns.Max end
    end
end