Parse = T{}

Parse.Tab_Name = "Parse"

-- Used to house general functions that I don't want immediately exposed.
Parse.Util = {}

-- Keeps track of how many columns should be shown on the screen in full mode.
Parse.Columns = {
    Base = 3,       -- Name, Total, %T
    Current = 5,
    Max = 21,
}

-- Load dependencies
require("windows.parse.enum")
require("windows.parse.config")
require("windows.parse.display_full")
require("windows.parse.display_mini")
require("windows.parse.display_nano")
require("windows.parse.widgets")
require("windows.parse.window")

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
    if Metrics.Parse.DPS then added_columns = added_columns + 1 end
    if Metrics.Parse.Running_Acc then added_columns = added_columns + 1 end
    if Metrics.Parse.Total_Acc then added_columns = added_columns + 1 end
    if Metrics.Parse.Melee then added_columns = added_columns + 1 end
    if Metrics.Parse.Crit then added_columns = added_columns + 1 end
    if Metrics.Parse.Average_WS then added_columns = added_columns + 1 end
    if Metrics.Parse.Weaponskill then added_columns = added_columns + 1 end
    if Parse.Config.Include_SC_Damage() then added_columns = added_columns + 1 end
    if Metrics.Parse.Ranged then added_columns = added_columns + 1 end
    if Metrics.Parse.Magic then added_columns = added_columns + 1 end
    if Metrics.Parse.Ability then added_columns = added_columns + 1 end
    if Metrics.Parse.Pet_Acc then added_columns = added_columns + 1 end
    if Metrics.Parse.Pet_Melee then added_columns = added_columns + 1 end
    if Metrics.Parse.Pet_Ranged then added_columns = added_columns + 1 end
    if Metrics.Parse.Pet_WS then added_columns = added_columns + 1 end
    if Metrics.Parse.Pet_Ability then added_columns = added_columns + 1 end
    if Metrics.Parse.Healing then added_columns = added_columns + 1 end
    if Metrics.Parse.Deaths then added_columns = added_columns + 1 end

    -- Apply new column count.
    Parse.Columns.Current = Parse.Columns.Base + added_columns
    if Parse.Columns.Current > Parse.Columns.Max then Parse.Columns.Current = Parse.Columns.Max end
end