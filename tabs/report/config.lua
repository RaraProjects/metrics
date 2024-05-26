Report.Config = T{}

Report.Config.Defaults = T{
    Damage_Threshold = 5,   -- Controls what damage percent is needed for showing up in a cross-player chat report.
    Auto_Save = false,
}

Report.Config.Show_Settings = false
Report.Config.Slider_Width = 100

------------------------------------------------------------------------------------------------------
-- Resets report settings.
------------------------------------------------------------------------------------------------------
Report.Config.Reset = function()
    for setting, value in pairs(Report.Config.Defaults) do
        Metrics.Report[setting] = value
    end
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the Report tab.
------------------------------------------------------------------------------------------------------
Report.Config.Display = function()
    -- UI.Separator()
    -- if UI.Checkbox("Auto Save", {Metrics.Report.Auto_Save}) then
    --     Metrics.Report.Auto_Save = not Metrics.Report.Auto_Save
    -- end
    -- UI.SameLine() Window.Widgets.HelpMarker("Automatically save an export of the database as a CSV whenver you "
    --                                       .."reset the database or unload the addon (like logging out).")
    UI.Separator()
    local damage_threshold = {[1] = Metrics.Report.Damage_Threshold}
    UI.Text("This does not affect the Publish button on the focus tab.")
    UI.SetNextItemWidth(Report.Config.Slider_Width)
    if UI.DragInt("Chat Report % Threshold", damage_threshold, 0.1, 0, 50, "%d", ImGuiSliderFlags_None) then
        Metrics.Report.Damage_Threshold = damage_threshold[1]
    end
end