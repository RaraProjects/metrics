Report.Config = { }

Report.Config.Defaults = T{
    X                = 100,
    Y                = 100,
    Visible          = { false },
    Damage_Threshold = 5,           -- Controls what damage percent is needed for showing up in a cross-player chat report.
    Auto_Save        = false,
}

Report.Config.SliderWidth = 100

------------------------------------------------------------------------------------------------------
-- Resets report settings.
------------------------------------------------------------------------------------------------------
Report.Config.Reset = function()
    for setting, value in pairs(Report.Config.Defaults) do
        Report.Settings[setting] = value
    end
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the Report tab.
------------------------------------------------------------------------------------------------------
Report.Config.Display = function()
    if UI.Checkbox("Auto Save", {Report.Settings.Auto_Save}) then
        Report.Settings.Auto_Save = not Report.Settings.Auto_Save
    end

    WindowManager.Widgets.HelpMarker("Automatically save an export of the database as a CSV whenver you " ..
                                     "reset the database or re/unload the addon (like shutting down).")
    UI.Separator()

    local damageThreshold = { Report.Settings.Damage_Threshold }

    UI.Text("This does not affect the Publish button on the focus tab.")
    UI.SetNextItemWidth(Report.Config.SliderWidth)

    if UI.DragInt("Chat Report % Threshold", damageThreshold, 0.1, 0, 50, "%d", ImGuiSliderFlags_None) then
        Report.Settings.Damage_Threshold = damageThreshold[1]
    end
end