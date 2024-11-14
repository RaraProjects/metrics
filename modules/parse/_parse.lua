Parse = T{}

Parse.Name   = "Parse"
Parse.Title  = "Metrics - Parse"
Parse.Module = "Parse"
Parse.Window = Window:New({
    Name   = Parse.Name,
    Title  = Parse.Title,
    Module = Parse.Module,
})

-- Used to house general functions that I don't want immediately exposed.
Parse.Util = {}

-- Keeps track of how many columns should be shown on the screen in full mode.
Parse.Columns = {
    Base = 3,       -- Name, Total, %T
    Current = 5,
    Max = 32,
}

Parse.Confirmation = false

-- Load dependencies
require("modules.parse.enum")
require("modules.parse.config")
require("modules.parse.display_full")
require("modules.parse.display_mini")
require("modules.parse.display_nano")
require("modules.parse.widgets")

------------------------------------------------------------------------------------------------------
-- Initializes the Parse screen.
------------------------------------------------------------------------------------------------------
Parse.Initialize = function()
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Parse window content.
------------------------------------------------------------------------------------------------------
Parse.Content = function()
    if Parse.Nano.Is_Enabled() then
        Parse.Nano.Populate()
    elseif Parse.Mini.Is_Enabled() then
        Parse.Mini.Populate()
    else
        Parse.Full.Populate()
    end
end

------------------------------------------------------------------------------------------------------
-- Calculates how many columns should be shown on the Parse table based on column visibility flags.
------------------------------------------------------------------------------------------------------
Parse.Util.Calculate_Column_Flags = function()
    local added_columns = 0
    if Metrics.Parse.Focus then added_columns = added_columns + 1 end
    if Metrics.Parse.Jobs then added_columns = added_columns + 1 end
    if Metrics.Parse.Attack_Speed then added_columns = added_columns + 1 end
    if Metrics.Parse.DPS then added_columns = added_columns + 1 end
    if Metrics.Parse.Running_Acc then added_columns = added_columns + 1 end
    if Metrics.Parse.Total_Acc then added_columns = added_columns + 1 end
    if Metrics.Parse.Crit then added_columns = added_columns + 1 end
    if Metrics.Parse.Melee then added_columns = added_columns + 1 end
    if Metrics.Parse.Melee_Acc then added_columns = added_columns + 1 end
    if Metrics.Parse.Melee_Crit then added_columns = added_columns + 1 end
    if Metrics.Parse.Weaponskill then added_columns = added_columns + 1 end
    if Metrics.Parse.Average_WS then added_columns = added_columns + 1 end
    if Metrics.Parse.WS_TP then added_columns = added_columns + 1 end
    if Metrics.Parse.WS_Accuracy then added_columns = added_columns + 1 end
    if Parse.Config.Include_SC_Damage() then added_columns = added_columns + 1 end
    if Metrics.Parse.Ranged then added_columns = added_columns + 1 end
    if Metrics.Parse.Ranged_Acc then added_columns = added_columns + 1 end
    if Metrics.Parse.Ranged_Crit then added_columns = added_columns + 1 end
    if Metrics.Parse.Ranged_Dist then added_columns = added_columns + 1 end
    if Metrics.Parse.Magic then added_columns = added_columns + 1 end
    if Metrics.Parse.Ability then added_columns = added_columns + 1 end
    if Metrics.Parse.Pet_Acc then added_columns = added_columns + 1 end
    if Metrics.Parse.Pet_Melee then added_columns = added_columns + 1 end
    if Metrics.Parse.Pet_Ranged then added_columns = added_columns + 1 end
    if Metrics.Parse.Pet_WS then added_columns = added_columns + 1 end
    if Metrics.Parse.Pet_Ability then added_columns = added_columns + 1 end
    if Metrics.Parse.Healing then added_columns = added_columns + 1 end
    if Metrics.Parse.Damage_Taken then added_columns = added_columns + 1 end
    if Metrics.Parse.Deaths then added_columns = added_columns + 1 end

    -- Apply new column count.
    Parse.Columns.Current = Parse.Columns.Base + added_columns
    if Parse.Columns.Current > Parse.Columns.Max then Parse.Columns.Current = Parse.Columns.Max end
end