Window.Theme = T{}

Window.Theme.Is_Set = false
Window.Theme.Table_Row_Bg = {0.00, 0.00, 0.00, 0.00}

------------------------------------------------------------------------------------------------------
-- Change the window themes.
-- Modeled from the ImGui demo.
-- https://github.com/ocornut/imgui/blob/master/imgui_demo.cpp
------------------------------------------------------------------------------------------------------
Window.Theme.Choose = function()
    UI.Text("Theme (will affect other ImGui based addons)")
    if UI.RadioButton("Default ", {Metrics.Window.Style}, 0) then
        Metrics.Window.Style = 0
        Window.Theme.Is_Set = false
    end
    UI.SameLine()
    if UI.RadioButton("Dark ", {Metrics.Window.Style}, 1) then
        Metrics.Window.Style = 1
        Window.Theme.Is_Set = false
    end
    UI.SameLine()
    if UI.RadioButton("Classic ", {Metrics.Window.Style}, 3) then
        Metrics.Window.Style = 3
        Window.Theme.Is_Set = false
    end
    Window.Theme.Set()
end

------------------------------------------------------------------------------------------------------
-- Change the window themes.
-- Modeled from the ImGui demo.
-- https://github.com/ocornut/imgui/blob/master/imgui_demo.cpp
------------------------------------------------------------------------------------------------------
Window.Theme.Set = function()
    if not Window.Theme.Is_Set then
        if Metrics.Window.Style == 0 then
            Window.Theme.Apply_Custom(Themes.Default)
            Window.Theme.Table_Row_Bg = {0.18, 0.20, 0.23, 1.00}
        elseif Metrics.Window.Style == 1 then
            UI.StyleColorsDark()
            Window.Theme.Table_Row_Bg = {0.06, 0.06, 0.06, 1.00}
        elseif Metrics.Window.Style == 2 then
            UI.StyleColorsLight()
        elseif Metrics.Window.Style == 3 then
            UI.StyleColorsClassic()
            Window.Theme.Table_Row_Bg = {0.00, 0.00, 0.00, 1.00}
        else
            Window.Theme.Apply_Custom(Themes.Default)
        end
        Window.Theme.Is_Set = true
    end
end

------------------------------------------------------------------------------------------------------
-- Applies a custom theme.
------------------------------------------------------------------------------------------------------
---@param theme table defined in resources.themes.
------------------------------------------------------------------------------------------------------
Window.Theme.Apply_Custom = function(theme)
    for flag_name, flag_value in pairs(Themes.Elements) do
        if theme[flag_name] then
            UI.PushStyleColor(flag_value, theme[flag_name])
        end
    end
end