Focus.Config = { }

Focus.Config.Defaults = T{
    X                       = 100,
    Y                       = 100,
    Visible                 = { false },
    Show_Mitigation_Details = false,
    Show_Misc_Actions       = true,
}

Focus.Config.ShowPercentDetails = false
Focus.Config.ColumnFlags        = Column.Flags.None
Focus.Config.ColumnWidth        = Column.Widths.Settings

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the focus screens.
------------------------------------------------------------------------------------------------------
Focus.Config.Display = function()
    local colFlags = Focus.Config.ColumnFlags

    if UI.BeginTable("Focus General", 2) then
        UI.TableSetupColumn("Col 1", colFlags)
        UI.TableSetupColumn("Col 2", colFlags)

        UI.TableNextColumn()
        if UI.Checkbox("Misc Actions", { Focus.Settings.Show_Misc_Actions }) then
            Focus.Settings.Show_Misc_Actions = not Focus.Settings.Show_Misc_Actions
        end
        WindowManager.Widgets.HelpMarker
        (
            "Shows uncategorized actions in the catalog lists. " ..
            "Sometimes these lists can get quite long and take up a lot of space. " ..
            "Turn this off if you aren't interested in seeing those."
        )

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows percent details checkbox.
------------------------------------------------------------------------------------------------------
Focus.Config.PercentDetails = function()
    if UI.SmallButton("% Details") then
        Focus.Config.PercentToggle()
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the percent details setting.
------------------------------------------------------------------------------------------------------
Focus.Config.PercentToggle = function()
    Focus.Config.ShowPercentDetails = not Focus.Config.ShowPercentDetails
end

------------------------------------------------------------------------------------------------------
-- Toggles miscellaneous actions.
------------------------------------------------------------------------------------------------------
Focus.Config.MiscActions = function()
    if UI.SmallButton("Misc. Actions") then
        Focus.Settings.Show_Misc_Actions = not Focus.Settings.Show_Misc_Actions
    end
end