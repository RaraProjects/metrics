Window.Widgets = T{}

Window.Widgets.Slider_Width = 100

------------------------------------------------------------------------------------------------------
-- Creates a help text marker.
------------------------------------------------------------------------------------------------------
Window.Widgets.HelpMarker = function(text)
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
Window.Widgets.Alpha = function()
    local alpha = {[1] = Metrics.Window.Alpha}
    UI.SetNextItemWidth(Window.Widgets.Slider_Width)
    if UI.DragFloat("Window Transparency", alpha, 0.005, 0.2, 1, "%.2f", ImGuiSliderFlags_None) then
        if alpha[1] < 0.2 then alpha[1] = 0.2
        elseif alpha[1] > 1 then alpha[1] = 1 end
        Metrics.Window.Alpha = alpha[1]
    end
    UI.SameLine() Window.Widgets.HelpMarker("Window transparency.")
end

------------------------------------------------------------------------------------------------------
-- Sets window scaling.
------------------------------------------------------------------------------------------------------
Window.Widgets.Window_Scale = function()
    local window_scale = {[1] = Metrics.Window.Window_Scaling}
    UI.SetNextItemWidth(Window.Widgets.Slider_Width)
    if UI.DragFloat("Window Scaling", window_scale, 0.005, 0.7, 3, "%.2f", ImGuiSliderFlags_None) then
        if window_scale[1] < 0.7 then window_scale[1] = 0.7
        elseif window_scale[1] > 3 then window_scale[1] = 3 end
        Metrics.Window.Window_Scaling = window_scale[1]
        Window.Scaling_Set = false
        Window.Set_Window_Scale()
    end
    UI.SameLine() Window.Widgets.HelpMarker("Adjust window element size.")
end