Report.Config = T{}

Report.Config.Defaults = T{
    Damage_Threshold = 5,   -- Controls what damage percent is needed for showing up in a cross-player chat report.
}

Report.Config.Slider_Width = 100

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the Report tab.
------------------------------------------------------------------------------------------------------
Report.Config.Display = function()
    local damage_threshold = {[1] = Metrics.Report.Damage_Threshold}
    UI.Text("This does not affect the Publish button on the focus tab.")
    UI.SetNextItemWidth(Report.Config.Slider_Width)
    if UI.DragInt("Chat Report % Threshold", damage_threshold, 0.1, 0, 50, "%d", ImGuiSliderFlags_None) then
        Metrics.Report.Damage_Threshold = damage_threshold[1]
    end
end
