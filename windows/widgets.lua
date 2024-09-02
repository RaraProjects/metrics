Window_Manager.Widgets = T{}

Window_Manager.Widgets.Slider_Width = 100

------------------------------------------------------------------------------------------------------
-- Creates a help text marker.
------------------------------------------------------------------------------------------------------
Window_Manager.Widgets.HelpMarker = function(text)
    UI.TextDisabled("(?)")
    if UI.IsItemHovered() then
        UI.BeginTooltip()
        UI.PushTextWrapPos(UI.GetFontSize() * 25)
        UI.TextUnformatted(text)
        UI.PopTextWrapPos()
        UI.EndTooltip()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets screen alpha.
------------------------------------------------------------------------------------------------------
Window_Manager.Widgets.Alpha = function()
    local alpha = {[1] = Metrics.Window.Alpha}
    UI.SetNextItemWidth(Window_Manager.Widgets.Slider_Width)
    if UI.DragFloat("Window Transparency", alpha, 0.005, 0.2, 1, "%.2f", ImGuiSliderFlags_None) then
        if alpha[1] < 0.2 then alpha[1] = 0.2
        elseif alpha[1] > 1 then alpha[1] = 1 end
        Metrics.Window.Alpha = alpha[1]
    end
    UI.SameLine() Window_Manager.Widgets.HelpMarker("Window transparency.")
end

------------------------------------------------------------------------------------------------------
-- Sets window scaling.
------------------------------------------------------------------------------------------------------
Window_Manager.Widgets.Window_Scale = function()
    local window_scale = {[1] = Metrics.Window.Window_Scaling}
    UI.SetNextItemWidth(Window_Manager.Widgets.Slider_Width)
    if UI.DragFloat("Window Scaling", window_scale, 0.005, 0.7, 3, "%.2f", ImGuiSliderFlags_None) then
        if window_scale[1] < 0.7 then window_scale[1] = 0.7
        elseif window_scale[1] > 3 then window_scale[1] = 3 end
        Metrics.Window.Window_Scaling = window_scale[1]
        Window_Manager.Reset_Scaling_Flags()
    end
    UI.SameLine() Window_Manager.Widgets.HelpMarker("Adjust window element size.")
end