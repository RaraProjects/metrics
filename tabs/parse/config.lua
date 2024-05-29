Parse.Config = T{}

-- Default settings are saved to file.
Parse.Config.Defaults = T{
    Show_Clock = true,
    Show_DPS_Graph = false,
    Include_SC_Damage = false,
    Condensed_Numbers = false,
    Basic_Columns_Only = false,
    Rank_Cutoff = 6,
    DPS_Graph_Height = 50,
    Total_Acc = false,
    DPS = true,
    Melee = true,
    Average_WS = false,
    Weaponskill = true,
    Ranged = false,
    Magic = true,
    Ability = false,
    Crit = false,
    Pet = false,
    Healing = false,
    Deaths = false,
    Grand_Totals = false,
    Global_DPS = false,
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

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows column selection settings.
------------------------------------------------------------------------------------------------------
Parse.Config.Column_Selection = function()
    local col_flags = Parse.Config.Column_Flags
    local width = Parse.Config.Column_Width

    UI.Text("Which extra columns should show in the Parse tab?")
    if UI.BeginTable("Parse General", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        -- Row 0
        UI.TableNextColumn()
        if UI.Checkbox("Basic Only", {Metrics.Parse.Basic_Columns_Only}) then
            Metrics.Parse.Basic_Columns_Only = not Metrics.Parse.Basic_Columns_Only
            if Metrics.Parse.Basic_Columns_Only then
                Metrics.Parse.DPS = true
                Metrics.Parse.Total_Acc = false
                Metrics.Parse.Melee = false
                Metrics.Parse.Crit = false
                Metrics.Parse.Average_WS = false
                Metrics.Parse.Weaponskill = false
                Metrics.Parse.Ranged = false
                Metrics.Parse.Magic = false
                Metrics.Parse.Ability = false
                Metrics.Parse.Pet = false
                Metrics.Parse.Healing = false
                Metrics.Parse.Deaths = false
            end
            Parse.Util.Calculate_Column_Flags()
        end
        UI.SameLine() Window.Widgets.HelpMarker("Reduces the amount of columns on Parse table to just "
                                                .."the most essential: Name, %T, Total, and Running Accuracy.")
        UI.TableNextColumn()
        if UI.Checkbox("Show DPS", {Metrics.Parse.DPS}) then
            Metrics.Parse.DPS = not Metrics.Parse.DPS
            Parse.Util.Calculate_Column_Flags()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Average WS", {Metrics.Parse.Average_WS}) then
            Metrics.Parse.Average_WS = not Metrics.Parse.Average_WS
            Parse.Util.Calculate_Column_Flags()
        end

        -- Row 1
        UI.TableNextColumn()
        if UI.Checkbox("Show Total Acc.", {Metrics.Parse.Total_Acc}) then
            Metrics.Parse.Total_Acc = not Metrics.Parse.Total_Acc
            Metrics.Parse.Basic_Columns_Only = false
            Parse.Util.Calculate_Column_Flags()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Show Melee", {Metrics.Parse.Melee}) then
            Metrics.Parse.Melee = not Metrics.Parse.Melee
            Metrics.Parse.Basic_Columns_Only = false
            Parse.Util.Calculate_Column_Flags()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Show Crits", {Metrics.Parse.Crit}) then
            Metrics.Parse.Crit = not Metrics.Parse.Crit
            Metrics.Parse.Basic_Columns_Only = false
            Parse.Util.Calculate_Column_Flags()
        end

        -- Row 2
        UI.TableNextColumn()
        if UI.Checkbox("Show Weaponskill", {Metrics.Parse.Weaponskill}) then
            Metrics.Parse.Weaponskill = not Metrics.Parse.Weaponskill
            Metrics.Parse.Basic_Columns_Only = false
            Parse.Util.Calculate_Column_Flags()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Show Ranged", {Metrics.Parse.Ranged}) then
            Metrics.Parse.Ranged = not Metrics.Parse.Ranged
            Metrics.Parse.Basic_Columns_Only = false
            Parse.Util.Calculate_Column_Flags()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Show Magic", {Metrics.Parse.Magic}) then
            Metrics.Parse.Magic = not Metrics.Parse.Magic
            Metrics.Parse.Basic_Columns_Only = false
            Parse.Util.Calculate_Column_Flags()
        end

        -- Row 3
        UI.TableNextColumn()
        if UI.Checkbox("Show Abilities", {Metrics.Parse.Ability}) then
            Metrics.Parse.Ability = not Metrics.Parse.Ability
            Metrics.Parse.Basic_Columns_Only = false
            Parse.Util.Calculate_Column_Flags()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Show Pets", {Metrics.Parse.Pet}) then
            Metrics.Parse.Pet = not Metrics.Parse.Pet
            Metrics.Parse.Basic_Columns_Only = false
            Parse.Util.Calculate_Column_Flags()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Show Healing", {Metrics.Parse.Healing}) then
            Metrics.Parse.Healing = not Metrics.Parse.Healing
            Metrics.Parse.Basic_Columns_Only = false
            Parse.Util.Calculate_Column_Flags()
        end

        -- Row 4
        UI.TableNextColumn()
        if UI.Checkbox("Show Deaths", {Metrics.Parse.Deaths}) then
            Metrics.Parse.Deaths = not Metrics.Parse.Deaths
            Metrics.Parse.Basic_Columns_Only = false
            Parse.Util.Calculate_Column_Flags()
        end

        UI.EndTable()
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
    Metrics.Parse.Pet = not Metrics.Parse.Pet
end

------------------------------------------------------------------------------------------------------
-- Toggles the clock.
------------------------------------------------------------------------------------------------------
Parse.Config.Toggle_Clock = function()
    Metrics.Parse.Show_Clock = not Metrics.Parse.Show_Clock
end