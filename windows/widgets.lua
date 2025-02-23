WindowManager.Widgets = { }

WindowManager.Widgets.SliderWidth = 100

------------------------------------------------------------------------------------------------------
-- Creates a help text marker.
------------------------------------------------------------------------------------------------------
WindowManager.Widgets.HelpMarker = function(text)
    UI.SameLine()
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
-- Creates a checkbox that can toggle a setting.
-- I'm trying to take advantage of Lua passing tables by reference, but I have send the setting name via string.
------------------------------------------------------------------------------------------------------
---@param caption         string
---@param settingsPointer table
---@param settingName     string
------------------------------------------------------------------------------------------------------
WindowManager.Widgets.ToggleCheckbox = function(caption, settingsPointer, settingName)
    if not caption or not settingsPointer or not settingName then
        return nil
    end

    if settingsPointer[settingName] == nil then
        return nil
    end

    if UI.Checkbox(tostring(caption), {settingsPointer[settingName]}) then
        settingsPointer[settingName] = not settingsPointer[settingName]
    end
end

------------------------------------------------------------------------------------------------------
-- Sets screen alpha.
------------------------------------------------------------------------------------------------------
WindowManager.Widgets.Alpha = function()
    local alpha = { WindowManager.Settings.Alpha }

    UI.SetNextItemWidth(WindowManager.Widgets.SliderWidth)

    if UI.DragFloat("Window Transparency", alpha, 0.005, 0.2, 1, "%.2f", ImGuiSliderFlags_None) then
        WindowManager.Settings.Alpha = math.clamp(alpha[1], 0.2, 1)
    end

    WindowManager.Widgets.HelpMarker("Window transparency.")
end

------------------------------------------------------------------------------------------------------
-- Sets window scaling.
------------------------------------------------------------------------------------------------------
WindowManager.Widgets.WindowScale = function()
    local windowScale = { WindowManager.Settings.Window_Scaling }

    UI.SetNextItemWidth(WindowManager.Widgets.SliderWidth)

    if UI.DragFloat("Window Scaling", windowScale, 0.005, 0.7, 3, "%.2f", ImGuiSliderFlags_None) then
        WindowManager.Settings.Window_Scaling = math.clamp(windowScale[1], 0.7, 3)
        WindowManager.ResetScalingFlags()
    end
    WindowManager.Widgets.HelpMarker("Adjust window element size.")
end