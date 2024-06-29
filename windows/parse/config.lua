Parse.Config = T{}

-- Default settings are saved to file.
Parse.Config.Defaults = T{
    Show_Clock         = true,
    Show_DPS_Graph     = false,
    Include_SC_Damage  = false,
    Condensed_Numbers  = false,
    Rank_Cutoff        = 6,
    DPS_Graph_Height   = 50,
    Total_Acc    = false,
    Running_Acc  = true,
    DPS          = true,
    Melee        = true,
    Average_WS   = false,
    Weaponskill  = true,
    Ranged       = false,
    Magic        = true,
    Ability      = false,
    Crit         = false,
    Pet_Melee    = false,
    Pet_Ranged   = false,
    Pet_Acc      = false,
    Pet_WS       = false,
    Pet_Ability  = false,
    Healing      = false,
    Deaths       = false,
    Grand_Totals = false,
    Global_DPS   = false,
    Show_Filter  = false,
    Display_Mode = Parse.Enum.Display_Mode.FULL,
}

Parse.Config.Show_Settings = false
Parse.Config.Column_Flags = Column.Flags.None
Parse.Config.Column_Width = Column.Widths.Settings
Parse.Config.Slider_Width = 100

Parse.Config.DPS_Graph_Window_Flags = bit.bor(ImGuiWindowFlags_NoTitleBar, ImGuiWindowFlags_NoBackground,
                                              ImGuiWindowFlags_NoFocusOnAppearing, ImGuiWindowFlags_AlwaysAutoResize)

------------------------------------------------------------------------------------------------------
-- Resets the Parse window to default settings.
------------------------------------------------------------------------------------------------------
Parse.Config.Reset = function()
    for setting, value in pairs(Parse.Config.Defaults) do
        Metrics.Parse[setting] = value
    end
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the Parse screens.
------------------------------------------------------------------------------------------------------
Parse.Config.Display = function()
    UI.Separator() Parse.Config.General()
    UI.Separator() Parse.Config.Column_Selection()
    UI.Separator() Parse.Config.Sliders()
    UI.Separator()
end

------------------------------------------------------------------------------------------------------
-- Shows general settings.
------------------------------------------------------------------------------------------------------
Parse.Config.General = function()
    local col_flags = Parse.Config.Column_Flags
    local width = Parse.Config.Column_Width

    UI.Text("General Settings")
    if UI.BeginTable("Parse General", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        -- Row 1
        UI.TableNextColumn()
        if UI.Checkbox("Run Time", {Metrics.Parse.Show_Clock}) then
            Metrics.Parse.Show_Clock = not Metrics.Parse.Show_Clock
        end
        UI.SameLine() Window.Widgets.HelpMarker("Show a timer of how long actions have been taking place.")
        UI.TableNextColumn() Parse.Widgets.SC_Damage()
        UI.TableNextColumn() Parse.Widgets.Condensed_Numbers()

        -- Row 2
        UI.TableNextColumn()
        if UI.Checkbox("Global DPS", {Metrics.Parse.Global_DPS}) then
            Metrics.Parse.Global_DPS = not Metrics.Parse.Global_DPS
        end
        UI.SameLine() Window.Widgets.HelpMarker("TL;DR The default DPS calculation method is local. Local DPS is spikey and closer to the present. "
                                             .. "Global DPS is smoother and averaged over a longer period. \n \n"
                                             .. "The default DPS calculation method is a local such that actions you do right now matter more. "
                                             .. "For example, if you were to stop taking actions for {X} amount of seconds your DPS would drop to zero. "
                                             .. "Global DPS is your total damage divided by the parse duration timer. The timer only runs while actions "
                                             .. "are taking place by your affiliates near you so idle time by the party won't hurt your DPS by much.")
        UI.TableNextColumn()
        if UI.Checkbox("Show DPS Graph", {Metrics.Parse.Show_DPS_Graph}) then
            Metrics.Parse.Show_DPS_Graph = not Metrics.Parse.Show_DPS_Graph
        end
        UI.TableNextColumn()
        if UI.Checkbox("Show Total Row", {Metrics.Parse.Grand_Totals}) then
            Metrics.Parse.Grand_Totals = not Metrics.Parse.Grand_Totals
            Parse.Util.Calculate_Column_Flags()
        end

        -- Row 3
        UI.TableNextColumn() Focus.Config.Percent_Details()

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows column selection settings.
------------------------------------------------------------------------------------------------------
Parse.Config.Column_Selection = function()
    local col_flags = Parse.Config.Column_Flags
    local width = Parse.Config.Column_Width
    Parse.Config.General_Flags(col_flags, width)
    UI.Separator()
    Parse.Config.Physical_Flags(col_flags, width)
    UI.Separator()
    Parse.Config.Magic_Flags(col_flags, width)
    UI.Separator()
    Parse.Config.Pet_Flags(col_flags, width)
end

------------------------------------------------------------------------------------------------------
-- Shows the general column flags table.
------------------------------------------------------------------------------------------------------
---@param col_flags any
---@param width any
------------------------------------------------------------------------------------------------------
Parse.Config.General_Flags = function(col_flags, width)
    Parse.Config.General_Buttons()
    UI.SameLine() UI.Text(" General")
    if UI.BeginTable("Parse General", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Show DPS", {Metrics.Parse.DPS}) then
            Metrics.Parse.DPS = not Metrics.Parse.DPS
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Show Deaths", {Metrics.Parse.Deaths}) then
            Metrics.Parse.Deaths = not Metrics.Parse.Deaths
            Parse.Util.Calculate_Column_Flags()
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows the physical column flags table.
------------------------------------------------------------------------------------------------------
---@param col_flags any
---@param width any
------------------------------------------------------------------------------------------------------
Parse.Config.Physical_Flags = function(col_flags, width)
    Parse.Config.Physical_Buttons()
    UI.SameLine() UI.Text(" Physical")
    if UI.BeginTable("Physical Parse Flags", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Running Accuracy", {Metrics.Parse.Running_Acc}) then
            Metrics.Parse.Running_Acc = not Metrics.Parse.Running_Acc
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Total Accuracy", {Metrics.Parse.Total_Acc}) then
            Metrics.Parse.Total_Acc = not Metrics.Parse.Total_Acc
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Melee", {Metrics.Parse.Melee}) then
            Metrics.Parse.Melee = not Metrics.Parse.Melee
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Ranged", {Metrics.Parse.Ranged}) then
            Metrics.Parse.Ranged = not Metrics.Parse.Ranged
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Crit Rate", {Metrics.Parse.Crit}) then
            Metrics.Parse.Crit = not Metrics.Parse.Crit
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Weaponskill", {Metrics.Parse.Weaponskill}) then
            Metrics.Parse.Weaponskill = not Metrics.Parse.Weaponskill
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Average WS", {Metrics.Parse.Average_WS}) then
            Metrics.Parse.Average_WS = not Metrics.Parse.Average_WS
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Abilities", {Metrics.Parse.Ability}) then
            Metrics.Parse.Ability = not Metrics.Parse.Ability
            Parse.Util.Calculate_Column_Flags()
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows the magic column flags table.
------------------------------------------------------------------------------------------------------
---@param col_flags any
---@param width any
------------------------------------------------------------------------------------------------------
Parse.Config.Magic_Flags = function(col_flags, width)
    Parse.Config.Magic_Buttons()
    UI.SameLine() UI.Text(" Magic")
    if UI.BeginTable("Magic Parse Flags", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Nukes", {Metrics.Parse.Magic}) then
            Metrics.Parse.Magic = not Metrics.Parse.Magic
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Healing", {Metrics.Parse.Healing}) then
            Metrics.Parse.Healing = not Metrics.Parse.Healing
            Parse.Util.Calculate_Column_Flags()
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows the pet column flags table.
------------------------------------------------------------------------------------------------------
---@param col_flags any
---@param width any
------------------------------------------------------------------------------------------------------
Parse.Config.Pet_Flags = function(col_flags, width)
    Parse.Config.Pet_Buttons()
    UI.SameLine() UI.Text(" Pets")
    if UI.BeginTable("Pet Parse Flags", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Pet Accuracy", {Metrics.Parse.Pet_Acc}) then
            Metrics.Parse.Pet_Acc = not Metrics.Parse.Pet_Acc
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Pet Melee", {Metrics.Parse.Pet_Melee}) then
            Metrics.Parse.Pet_Melee = not Metrics.Parse.Pet_Melee
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Pet Ranged", {Metrics.Parse.Pet_Ranged}) then
            Metrics.Parse.Pet_Ranged = not Metrics.Parse.Pet_Ranged
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Pet WS", {Metrics.Parse.Pet_WS}) then
            Metrics.Parse.Pet_WS = not Metrics.Parse.Pet_WS
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Pet Ability", {Metrics.Parse.Pet_Ability}) then
            Metrics.Parse.Pet_Ability = not Metrics.Parse.Pet_Ability
            Parse.Util.Calculate_Column_Flags()
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Activates or clears all optional columns.
------------------------------------------------------------------------------------------------------
---@param bool boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Set_All_Columns = function(bool)
    Parse.Config.Set_Physical_Columns(bool)
    Parse.Config.Set_Magic_Columns(bool)
    Parse.Config.Set_Pet_Columns(bool)
    Metrics.Parse.DPS = bool
    Metrics.Parse.Deaths = bool
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Activates or clears all of the physical columns.
------------------------------------------------------------------------------------------------------
---@param bool boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Set_Physical_Columns = function(bool)
    Metrics.Parse.Running_Acc = bool
    Metrics.Parse.Total_Acc = bool
    Metrics.Parse.Melee = bool
    Metrics.Parse.Ranged = bool
    Metrics.Parse.Crit = bool
    Metrics.Parse.Weaponskill = bool
    Metrics.Parse.Average_WS = bool
    Metrics.Parse.Ability = bool
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Activates or clears all of the magic columns.
------------------------------------------------------------------------------------------------------
---@param bool boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Set_Magic_Columns = function(bool)
    Metrics.Parse.Magic = bool
    Metrics.Parse.Healing = bool
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Activates or clears all of the pet columns.
------------------------------------------------------------------------------------------------------
---@param bool boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Set_Pet_Columns = function(bool)
    Metrics.Parse.Pet_Acc = bool
    Metrics.Parse.Pet_Melee = bool
    Metrics.Parse.Pet_Ranged = bool
    Metrics.Parse.Pet_WS = bool
    Metrics.Parse.Pet_Ability = bool
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Checks if a pet column is currently enabled.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Is_Pet_Column_Enabled = function()
    return Metrics.Parse.Pet_Acc
    or Metrics.Parse.Pet_Melee
    or Metrics.Parse.Pet_Ranged
    or Metrics.Parse.Pet_WS
    or Metrics.Parse.Pet_Ability
end

------------------------------------------------------------------------------------------------------
-- Displays general All and None column buttons.
------------------------------------------------------------------------------------------------------
Parse.Config.General_Buttons = function()
    UI.PushID("General All")
    if UI.SmallButton("All") then
        Parse.Config.Set_All_Columns(true)
    end
    UI.SameLine() UI.Text(" ") UI.SameLine()
    UI.PushID("General None")
    if UI.SmallButton("None") then
        Parse.Config.Set_All_Columns(false)
    end
end

------------------------------------------------------------------------------------------------------
-- Displays physical All and None column buttons.
------------------------------------------------------------------------------------------------------
Parse.Config.Physical_Buttons = function()
    UI.PushID("Physical All")
    if UI.SmallButton("All") then
        Parse.Config.Set_Physical_Columns(true)
    end
    UI.SameLine() UI.Text(" ") UI.SameLine()
    UI.PushID("Physical None")
    if UI.SmallButton("None") then
        Parse.Config.Set_Physical_Columns(false)
    end
end

------------------------------------------------------------------------------------------------------
-- Displays magic All and None column buttons.
------------------------------------------------------------------------------------------------------
Parse.Config.Magic_Buttons = function()
    UI.PushID("Magic All")
    if UI.SmallButton("All") then
        Parse.Config.Set_Magic_Columns(true)
    end
    UI.SameLine() UI.Text(" ") UI.SameLine()
    UI.PushID("Magic None")
    if UI.SmallButton("None") then
        Parse.Config.Set_Magic_Columns(false)
    end
end

------------------------------------------------------------------------------------------------------
-- Displays pet All and None column buttons.
------------------------------------------------------------------------------------------------------
Parse.Config.Pet_Buttons = function()
    UI.PushID("Pet All")
    if UI.SmallButton("All") then
        Parse.Config.Set_Pet_Columns(true)
    end
    UI.SameLine() UI.Text(" ") UI.SameLine()
    UI.PushID("Pet None")
    if UI.SmallButton("None") then
        Parse.Config.Set_Pet_Columns(false)
    end
end

------------------------------------------------------------------------------------------------------
-- Shows slider settings.
------------------------------------------------------------------------------------------------------
Parse.Config.Sliders = function()
    UI.Text("Use Ctrl+Click on the component to set the number directly.")
    Parse.Widgets.Player_Limit()
    Parse.Widgets.Acc_Limit()
    if Metrics.Parse.Show_DPS_Graph then Parse.Widgets.DPS_Graph_Height() end
end

------------------------------------------------------------------------------------------------------
-- Returns whether or not the DPS graph window should show.
------------------------------------------------------------------------------------------------------
Parse.Config.Show_DPS_Graph = function()
    return Metrics.Parse.Show_DPS_Graph
end

------------------------------------------------------------------------------------------------------
-- Returns whether or not Skillchain damage is being taken into account.
------------------------------------------------------------------------------------------------------
Parse.Config.Include_SC_Damage = function()
    return Metrics.Parse.Include_SC_Damage
end

------------------------------------------------------------------------------------------------------
-- Returns what number of players should show on the Parse window.
------------------------------------------------------------------------------------------------------
Parse.Config.Rank_Cutoff = function()
    return Metrics.Parse.Rank_Cutoff
end

------------------------------------------------------------------------------------------------------
-- Returns whether to show condensed numbers or not.
------------------------------------------------------------------------------------------------------
Parse.Config.Condensed_Numbers = function()
    return Metrics.Parse.Condensed_Numbers
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
    Metrics.Parse.Show_Clock = not Metrics.Parse.Show_Clock
end