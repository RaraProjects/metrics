Window_Manager.Theme = {}

Window_Manager.Theme.Is_Set = false
Window_Manager.Theme.Table_Row_Bg = {0.00, 0.00, 0.00, 0.00}

------------------------------------------------------------------------------------------------------
-- Change the window themes.
-- Modeled from the ImGui demo.
-- https://github.com/ocornut/imgui/blob/master/imgui_demo.cpp
------------------------------------------------------------------------------------------------------
Window_Manager.Theme.Choose = function()
    UI.Text("Theme (will affect other ImGui based addons)")
    if UI.RadioButton("Default ", {Window_Manager.Settings.Style}, 0) then
        Window_Manager.Settings.Style = 0
        Window_Manager.Theme.Is_Set = false
    end
    UI.SameLine()
    if UI.RadioButton("Dark ", {Window_Manager.Settings.Style}, 1) then
        Window_Manager.Settings.Style = 1
        Window_Manager.Theme.Is_Set = false
    end
    UI.SameLine()
    if UI.RadioButton("Classic ", {Window_Manager.Settings.Style}, 3) then
        Window_Manager.Settings.Style = 3
        Window_Manager.Theme.Is_Set = false
    end
    Window_Manager.Theme.Set()
end

------------------------------------------------------------------------------------------------------
-- Change the window themes.
-- Modeled from the ImGui demo.
-- https://github.com/ocornut/imgui/blob/master/imgui_demo.cpp
------------------------------------------------------------------------------------------------------
Window_Manager.Theme.Set = function()
    if not Window_Manager.Theme.Is_Set then
        if Window_Manager.Settings.Style == 0 then
            Window_Manager.Theme.Apply_Custom(Themes.Default)
            Window_Manager.Theme.Table_Row_Bg = {0.18, 0.20, 0.23, 1.00}
        elseif Window_Manager.Settings.Style == 1 then
            UI.StyleColorsDark()
            Window_Manager.Theme.Table_Row_Bg = {0.06, 0.06, 0.06, 1.00}
        elseif Window_Manager.Settings.Style == 2 then
            UI.StyleColorsLight()
        elseif Window_Manager.Settings.Style == 3 then
            UI.StyleColorsClassic()
            Window_Manager.Theme.Table_Row_Bg = {0.00, 0.00, 0.00, 1.00}
        else
            Window_Manager.Theme.Apply_Custom(Themes.Default)
        end
        Window_Manager.Theme.Is_Set = true
    end
end

------------------------------------------------------------------------------------------------------
-- Applies a custom theme.
------------------------------------------------------------------------------------------------------
---@param theme table defined in resources.themes.
------------------------------------------------------------------------------------------------------
Window_Manager.Theme.Apply_Custom = function(theme)
    for flag_name, flag_value in pairs(Themes.Elements) do
        if theme[flag_name] then
            UI.PushStyleColor(flag_value, theme[flag_name])
        end
    end
end