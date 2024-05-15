Parse.Config = T{}

-- Default settings are saved to file.
Parse.Config.Defaults = T{}
Parse.Config.Defaults.Flags = T{
    Total_Damage_Only = false,
    Show_Clock = true,
    Total_Acc = false,
    Crit = false,
    Pet = false,
    Healing = false,
    Deaths = false,
}
Parse.Config.Defaults.Settings = T{
    Rank_Cutoff = 6,
    Condensed_Numbers = false,
    Include_SC_Damage = false
}

Parse.Config.Show_Settings = false
Parse.Config.Column_Flags = Column.Flags.None
Parse.Config.Column_Width = Column.Widths.Settings
Parse.Config.Slider_Width = 100

------------------------------------------------------------------------------------------------------
-- Resets the Parse window to default settings.
------------------------------------------------------------------------------------------------------
Parse.Config.Reset = function()
    for setting, value in pairs(Parse.Config.Defaults.Settings) do
        Metrics.Team.Settings[setting] = value
    end
    for flag, value in pairs(Parse.Config.Defaults.Flags) do
        Metrics.Team.Flags[flag] = value
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
        if UI.Checkbox("Less Columns", {Metrics.Team.Flags.Total_Damage_Only}) then
            Metrics.Team.Flags.Total_Damage_Only = not Metrics.Team.Flags.Total_Damage_Only
            Parse.Util.Calculate_Column_Flags()
        end
        UI.SameLine() Window.Widgets.HelpMarker("Reduces the amount of columns on Parse table to just "
                                                .."the most essential: Name, %T, Total, and Running Accuracy.")

        UI.TableNextColumn()
        if UI.Checkbox("Run Time", {Metrics.Team.Settings.Show_Clock}) then
            Metrics.Team.Settings.Show_Clock = not Metrics.Team.Settings.Show_Clock
        end
        UI.SameLine() Window.Widgets.HelpMarker("Show a timer of how long action has been taking place.")
        UI.TableNextColumn()
        Parse.Widgets.SC_Damage()

        -- Row 2
        UI.TableNextColumn()
        Parse.Widgets.Condensed_Numbers()

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

        -- Row 1
        UI.TableNextColumn()
        if UI.Checkbox("Show Crits", {Metrics.Team.Flags.Crit}) then
            Metrics.Team.Flags.Crit = not Metrics.Team.Flags.Crit
            Parse.Util.Calculate_Column_Flags()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Show Pets", {Metrics.Team.Flags.Pet}) then
            Metrics.Team.Flags.Pet = not Metrics.Team.Flags.Pet
            Parse.Util.Calculate_Column_Flags()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Show Healing", {Metrics.Team.Flags.Healing}) then
            Metrics.Team.Flags.Healing = not Metrics.Team.Flags.Healing
            Parse.Util.Calculate_Column_Flags()
        end

        -- Row 2
        UI.TableNextColumn()
        if UI.Checkbox("Show Deaths", {Metrics.Team.Flags.Deaths}) then
            Metrics.Team.Flags.Deaths = not Metrics.Team.Flags.Deaths
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
end