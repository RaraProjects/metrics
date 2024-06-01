Focus.Config = T{}

Focus.Config.Defaults = T{
    Show_Mitigation_Details = false,
    Show_Misc_Actions = false,
}

Focus.Config.Show_Settings = false
Focus.Config.Show_Percent_Details = false
Focus.Config.Column_Flags = Column.Flags.None
Focus.Config.Column_Width = Column.Widths.Settings

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the focus screens.
------------------------------------------------------------------------------------------------------
Focus.Config.Display = function()
    local col_flags = Focus.Config.Column_Flags

    UI.Separator()
    if UI.BeginTable("Focus General", 2) then
        UI.TableSetupColumn("Col 1", col_flags)
        UI.TableSetupColumn("Col 2", col_flags)

        -- Row 1
        UI.TableNextColumn() Focus.Config.Percent_Details()
        UI.TableNextColumn()
        if UI.Checkbox("Misc Actions", {Metrics.Focus.Show_Misc_Actions}) then
            Metrics.Focus.Show_Misc_Actions = not Metrics.Focus.Show_Misc_Actions
        end
        UI.SameLine() Window.Widgets.HelpMarker("Shows uncategorized actions in the catalog lists. "
                                              .."Sometimes these lists can get quite long and take up a lot of space. "
                                              .."Turn this off if you aren't interested in seeing those.")

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the settings showing for the battle log.
------------------------------------------------------------------------------------------------------
Focus.Config.Settings_Button = function()
    if UI.SmallButton("Settings") then
        Focus.Config.Show_Settings = not Focus.Config.Show_Settings
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the settings showing for the battle log.
------------------------------------------------------------------------------------------------------
Focus.Config.Screenshot_Button = function()
    if UI.SmallButton("Screenshot") then
        Focus.Screenshot_Mode = not Focus.Screenshot_Mode
    end
end

------------------------------------------------------------------------------------------------------
-- Shows percent details checkbox.
------------------------------------------------------------------------------------------------------
Focus.Config.Percent_Details = function()
    if UI.Checkbox("Percent Details", {Focus.Config.Show_Percent_Details}) then
        Focus.Config.Show_Percent_Details = not Focus.Config.Show_Percent_Details
    end
    UI.SameLine() Window.Widgets.HelpMarker("Show numerator and denominator for percentages in the same cell.")
end