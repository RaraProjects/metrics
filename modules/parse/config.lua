Parse.Config = {}

-- Default settings are saved to file.
Parse.Config.Defaults = T{
    X = 100,
    Y = 100,
    Visible = {false},
    Display_Mode = Parse.Enum.Display_Mode.FULL,

    -- General Settings
    Is_Horizon        = true,
    Show_Clock        = false,
    Include_SC_Damage = false,
    Condensed_Numbers = false,
    Lurk_Mode         = false,
    Name_Colors       = true,
    Hide_Subjob       = false,
    Mask_Names        = false,
    Grand_Totals      = false,
    Show_Filter       = false,
    Rank_Cutoff = 6,

    -- Column Flags
    Show_Focus_Jump            = true,
    Show_Jobs                  = false,
    Show_Accuracy_Combined     = false,
    Show_Accuracy_Recent       = true,
    Show_Accuracy_Melee        = false,
    Show_Accuracy_Ranged       = false,
    Show_Accuracy_Weaponskill  = false,
    Show_Accuracy_Pet          = false,
    Show_Crit_Combined         = false,
    Show_Crit_Melee            = false,
    Show_Crit_Ranged           = false,
    Show_DPS                   = false,
    Show_Melee_Delay           = false,
    Show_Ranged_Distance       = false,
    Show_Total_Melee           = true,
    Show_Total_Ranged          = true,
    Show_Total_Nuking          = true,
    Show_Total_Healing         = false,
    Show_Total_Weaponskill     = true,
    Show_Total_Skillchain      = false,
    Show_Total_Ability         = false,
    Show_Weaponskill_Average   = false,
    Show_Weaponskill_TP        = false,
    Show_Pet_Total             = false,
    Show_Pet_Accuracy          = false,
    Show_Pet_Melee             = false,
    Show_Pet_Ranged            = false,
    Show_Pet_TP_Move           = false,
    Show_Pet_Healing           = false,
    Show_Damage_Taken          = false,
    Show_Player_Deaths         = false,
}

Parse.Config.Column_Flags = Column.Flags.None
Parse.Config.Column_Width = Column.Widths.Settings
Parse.Config.Slider_Width = 100

Parse.Config.General_Settings = {}
table.insert(Parse.Config.General_Settings, {header = "Horizon Mode",      setting = "Is_Horizon",        help = Parse.Help.Horizon_Mode})
table.insert(Parse.Config.General_Settings, {header = "Run Time",          setting = "Show_Clock",        help = Parse.Help.Help_Text_Clock})
table.insert(Parse.Config.General_Settings, {header = "Include SC Damage", setting = "Include_SC_Damage", help = Parse.Help.Help_Text_SC_Damage})
table.insert(Parse.Config.General_Settings, {header = "Short Numbers",     setting = "Condensed_Numbers", help = Parse.Help.Help_Text_Condensed_Numbers})
table.insert(Parse.Config.General_Settings, {header = "Hide Sub Job",      setting = "Hide_Subjob"})
table.insert(Parse.Config.General_Settings, {header = "Job Colors",        setting = "Name_Colors"})
table.insert(Parse.Config.General_Settings, {header = "Mask Names",        setting = "Mask_Names",        help = Parse.Help.Help_Text_Mask_Names})
table.insert(Parse.Config.General_Settings, {header = "Total Row",         setting = "Grand_Totals"})
table.insert(Parse.Config.General_Settings, {header = "Lurk Mode",         setting = "Lurk_Mode",         help = Parse.Help.Help_Text_Lurk_Mode})

Parse.Config.Columns = {}
Parse.Config.Columns.General = {}
table.insert(Parse.Config.Columns.General, {header = "Focus Jump",         setting = "Show_Focus_Jump",   help = Parse.Help.Help_Text_Focus_Jump})
table.insert(Parse.Config.Columns.General, {header = "Player Job",         setting = "Show_Jobs"})
table.insert(Parse.Config.Columns.General, {header = "DPS",                setting = "Show_DPS"})
table.insert(Parse.Config.Columns.General, {header = "Damage Taken",       setting = "Show_Damage_Taken"})
table.insert(Parse.Config.Columns.General, {header = "Player Deaths",      setting = "Show_Player_Deaths"})

Parse.Config.Columns.Accuracy = {}
table.insert(Parse.Config.Columns.Accuracy, {header = "Recent",            setting = "Show_Accuracy_Recent"})
table.insert(Parse.Config.Columns.Accuracy, {header = nil,                 setting = nil})
table.insert(Parse.Config.Columns.Accuracy, {header = nil,                 setting = nil})
table.insert(Parse.Config.Columns.Accuracy, {header = "Melee",             setting = "Show_Accuracy_Melee"})
table.insert(Parse.Config.Columns.Accuracy, {header = "Ranged",            setting = "Show_Accuracy_Ranged"})
table.insert(Parse.Config.Columns.Accuracy, {header = "Combined",          setting = "Show_Accuracy_Combined"})

Parse.Config.Columns.Physical = {}
table.insert(Parse.Config.Columns.Physical, {header = "Melee Damage",      setting = "Show_Total_Melee"})
table.insert(Parse.Config.Columns.Physical, {header = "Melee Delay",       setting = "Show_Melee_Delay"})
table.insert(Parse.Config.Columns.Physical, {header = nil,                 setting = nil})
table.insert(Parse.Config.Columns.Physical, {header = "Ranged Damage",     setting = "Show_Total_Ranged"})
table.insert(Parse.Config.Columns.Physical, {header = "Shot Distance",     setting = "Show_Ranged_Distance"})
table.insert(Parse.Config.Columns.Physical, {header = nil,                 setting = nil})
table.insert(Parse.Config.Columns.Physical, {header = "Melee Crit",        setting = "Show_Crit_Melee"})
table.insert(Parse.Config.Columns.Physical, {header = "Ranged Crit",       setting = "Show_Crit_Ranged"})
table.insert(Parse.Config.Columns.Physical, {header = "Combined Crit",     setting = "Show_Crit_Combined"})
table.insert(Parse.Config.Columns.Physical, {header = "Abilities",         setting = "Show_Total_Ability"})

Parse.Config.Columns.Weaponskills = {}
table.insert(Parse.Config.Columns.Weaponskills, {header = "WS Damage",     setting = "Show_Total_Weaponskill"})
table.insert(Parse.Config.Columns.Weaponskills, {header = "WS Average",    setting = "Show_Weaponskill_Average"})
table.insert(Parse.Config.Columns.Weaponskills, {header = "WS ~TP",        setting = "Show_Weaponskill_TP"})
table.insert(Parse.Config.Columns.Weaponskills, {header = "WS Accuracy",   setting = "Show_Accuracy_Weaponskill"})
table.insert(Parse.Config.Columns.Weaponskills, {header = "SC Damage",     setting = "Show_Total_Skillchain"})

Parse.Config.Columns.Magic = {}
table.insert(Parse.Config.Columns.Magic, {header = "Nuking",               setting = "Show_Total_Nuking"})
table.insert(Parse.Config.Columns.Magic, {header = "Healing",              setting = "Show_Total_Healing"})

Parse.Config.Columns.Pets = {}
table.insert(Parse.Config.Columns.Pets, {header = "Pet Total",             setting = "Show_Pet_Total"})
table.insert(Parse.Config.Columns.Pets, {header = "Pet Accuracy",          setting = "Show_Pet_Accuracy"})
table.insert(Parse.Config.Columns.Pets, {header = "Pet Melee",             setting = "Show_Pet_Melee"})
table.insert(Parse.Config.Columns.Pets, {header = "Pet Ranged",            setting = "Show_Pet_Ranged"})
table.insert(Parse.Config.Columns.Pets, {header = "Pet TP",                setting = "Show_Pet_TP_Move"})
table.insert(Parse.Config.Columns.Pets, {header = "Pet Healing",           setting = "Show_Pet_Healing"})

------------------------------------------------------------------------------------------------------
-- Resets the Parse window to default settings.
------------------------------------------------------------------------------------------------------
Parse.Config.Reset = function()
    for setting, value in pairs(Parse.Config.Defaults) do
        Parse.Settings[setting] = value
    end
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the Parse screens.
------------------------------------------------------------------------------------------------------
Parse.Config.Display = function()
    Parse.Config.Show_Column_Group(Parse.Config.General_Settings, "General Settings", true)
    Parse.Widgets.Player_Limit()
    UI.Separator()
    Parse.Config.Show_Column_Group(Parse.Config.Columns.General, "General")
    DB.DPS.Dropdown(Parse.Config.Slider_Width)
    UI.Separator()
    Parse.Config.Show_Column_Group(Parse.Config.Columns.Accuracy, "Accuracy")
    Parse.Widgets.Acc_Limit()
    UI.Separator()
    Parse.Config.Show_Column_Group(Parse.Config.Columns.Physical, "Physical")
    UI.Separator()
    Parse.Config.Show_Column_Group(Parse.Config.Columns.Weaponskills, "Weaponskills")
    UI.Separator()
    Parse.Config.Show_Column_Group(Parse.Config.Columns.Magic, "Magic")
    UI.Separator()
    Parse.Config.Show_Column_Group(Parse.Config.Columns.Pets, "Pets")
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Shows a group of columns.
------------------------------------------------------------------------------------------------------
---@param columns table
---@param group_name string
---@param hide_buttons? boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Show_Column_Group = function(columns, group_name, hide_buttons)
    local col_flags = Parse.Config.Column_Flags
    local width     = Parse.Config.Column_Width

    if hide_buttons then
        UI.Text(tostring(group_name))
    else
        Parse.Config.Column_Group_Buttons(columns, group_name)
    end

    if UI.BeginTable(tostring(group_name) .. " Columns", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        for _, data in ipairs(columns) do
            UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox(data.header, Parse.Settings, data.setting)
            if data.help and type(data.help) == "function" then data.help() end
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows the All/None buttons for a column group.
------------------------------------------------------------------------------------------------------
---@param columns table
---@param group_name string
------------------------------------------------------------------------------------------------------
Parse.Config.Column_Group_Buttons = function(columns, group_name)
    UI.PushID(tostring(group_name) .. " All")
    if UI.SmallButton("All") then
        Parse.Config.Set_Column_Group(columns, true)
    end

    UI.SameLine() UI.Text(" ") UI.SameLine()

    UI.PushID(tostring(group_name) .. " None")
    if UI.SmallButton("None") then
        Parse.Config.Set_Column_Group(columns, false)
    end

    UI.SameLine() UI.Text(" " .. tostring(group_name))
end

------------------------------------------------------------------------------------------------------
-- Sets a group of columns.
------------------------------------------------------------------------------------------------------
---@param columns table
---@param bool boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Set_Column_Group = function(columns, bool)
    for _, data in ipairs(columns) do
        if data.setting and Parse.Settings[data.setting] ~= nil then
            Parse.Settings[data.setting] = bool
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles basic pet columns.
------------------------------------------------------------------------------------------------------
---@param bool boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Set_Pet_Columns = function(bool)
    Parse.Settings.Show_Pet_Total = bool
    Parse.Settings.Show_Pet_Accuracy = bool
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Checks if a pet column is currently enabled.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Is_Pet_Column_Enabled = function()
    return Parse.Settings.Show_Pet_Accuracy
    or Parse.Settings.Show_Pet_Total
end

------------------------------------------------------------------------------------------------------
-- Returns whether or not Lurk Mode is enabled.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Is_Lurking = function()
    return Parse.Settings.Lurk_Mode
end

------------------------------------------------------------------------------------------------------
-- Toggles Lurk Mode.
------------------------------------------------------------------------------------------------------
Parse.Config.Toggle_Lurk_Mode = function()
    Parse.Settings.Lurk_Mode = not Parse.Settings.Lurk_Mode
end

------------------------------------------------------------------------------------------------------
-- Returns whether or not names are being masked.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Is_Masking_Names = function()
    return Parse.Settings.Mask_Names
end

------------------------------------------------------------------------------------------------------
-- Returns whether or not name colors are enabled.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Is_Colored_Name = function()
    return Parse.Settings.Name_Colors
end

------------------------------------------------------------------------------------------------------
-- Returns whether or not sub jobs should be shown.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Is_Hiding_Subjob = function()
    return Parse.Settings.Hide_Subjob
end

------------------------------------------------------------------------------------------------------
-- Toggles DPS column visibility.
------------------------------------------------------------------------------------------------------
Parse.Config.Toggle_DPS = function()
    Parse.Settings.Show_DPS = not Parse.Settings.Show_DPS
end

------------------------------------------------------------------------------------------------------
-- Toggles Attack Speed column visibility.
------------------------------------------------------------------------------------------------------
Parse.Config.Toggle_Melee_Delay = function()
    Parse.Settings.Show_Melee_Delay = not Parse.Settings.Show_Melee_Delay
end

------------------------------------------------------------------------------------------------------
-- Returns whether or not Skillchain damage is being taken into account.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Include_SC_Damage = function()
    return Parse.Settings.Include_SC_Damage
end

------------------------------------------------------------------------------------------------------
-- Returns what number of players should show on the Parse window.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Rank_Cutoff = function()
    return Parse.Settings.Rank_Cutoff
end

------------------------------------------------------------------------------------------------------
-- Returns whether to show condensed numbers or not.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Condensed_Numbers = function()
    return Parse.Settings.Condensed_Numbers
end

------------------------------------------------------------------------------------------------------
-- Toggles pet column flags.
------------------------------------------------------------------------------------------------------
Parse.Config.Toggle_Pet = function()
    Parse.Config.Set_Pet_Columns(not Parse.Config.Is_Pet_Column_Enabled())
end

------------------------------------------------------------------------------------------------------
-- Toggles the clock.
------------------------------------------------------------------------------------------------------
Parse.Config.Toggle_Clock = function()
    Parse.Settings.Show_Clock = not Parse.Settings.Show_Clock
end