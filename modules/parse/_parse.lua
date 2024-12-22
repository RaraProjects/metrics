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

Parse.Is_Initialized = false
Parse.Settings = T{}            -- Keep the "T" on this.
Parse.Confirmation = false

-- Load dependencies
require("modules.parse.enum")
require("modules.parse.help_text")
require("modules.parse.config")
require("modules.parse.display_full")
require("modules.parse.display_mini")
require("modules.parse.display_nano")
require("modules.parse.widgets")

------------------------------------------------------------------------------------------------------
-- Initializes the Parse screen.
------------------------------------------------------------------------------------------------------
---@param settings_pointer? table you only need to set this once on initial addon load.
------------------------------------------------------------------------------------------------------
Parse.Initialize = function(settings_pointer)
    -- Check for necessary settings and dependencies.
    if settings_pointer and Ashita and Res and Window_Manager and UI and Column then
        Parse.Settings = settings_pointer
        Parse.Is_Initialized = true
    end
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Parse window content.
------------------------------------------------------------------------------------------------------
Parse.Content = function()
    if not Parse.Is_Initialized then return nil end
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
    if Parse.Settings.Show_Focus_Jump            then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Jobs                  then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Melee_Delay           then added_columns = added_columns + 1 end
    if Parse.Settings.Show_DPS                   then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Accuracy_Recent       then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Accuracy_Combined     then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Crit_Combined         then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Total_Melee           then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Accuracy_Melee        then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Crit_Melee            then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Total_Weaponskill     then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Weaponskill_Average   then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Weaponskill_TP        then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Accuracy_Weaponskill  then added_columns = added_columns + 1 end
    if Parse.Config.Include_SC_Damage()          then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Total_Ranged          then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Accuracy_Ranged       then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Crit_Ranged           then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Ranged_Distance       then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Total_Nuking_Combined then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Total_Nuking_No_Burst then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Total_Nuking_Burst    then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Total_Ability         then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Pet_Total             then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Pet_Accuracy          then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Pet_Melee             then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Pet_Ranged            then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Pet_TP_Move           then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Pet_Healing           then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Total_Healing         then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Damage_Taken          then added_columns = added_columns + 1 end
    if Parse.Settings.Show_Player_Deaths         then added_columns = added_columns + 1 end

    -- Apply new column count.
    Parse.Columns.Current = Parse.Columns.Base + added_columns
    if Parse.Columns.Current > Parse.Columns.Max then Parse.Columns.Current = Parse.Columns.Max end
end