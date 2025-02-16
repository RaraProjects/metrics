WindowManager.Theme = { }

WindowManager.Theme.IsSet      = false
WindowManager.Theme.TableRowBg = { 0.00, 0.00, 0.00, 0.00 }

------------------------------------------------------------------------------------------------------
-- Change the window themes.
-- Modeled from the ImGui demo.
-- https://github.com/ocornut/imgui/blob/master/imgui_demo.cpp
------------------------------------------------------------------------------------------------------
WindowManager.Theme.Choose = function()
    UI.Text("Theme (will affect other ImGui based addons)")

    if UI.RadioButton("Default ", { WindowManager.Settings.Style }, 0) then
        WindowManager.Settings.Style = 0
        WindowManager.Theme.IsSet    = false
    end

    UI.SameLine()
    if UI.RadioButton("Dark ", { WindowManager.Settings.Style }, 1) then
        WindowManager.Settings.Style = 1
        WindowManager.Theme.IsSet    = false
    end

    UI.SameLine()
    if UI.RadioButton("Classic ", { WindowManager.Settings.Style }, 3) then
        WindowManager.Settings.Style = 3
        WindowManager.Theme.IsSet    = false
    end

    WindowManager.Theme.Set()
end

------------------------------------------------------------------------------------------------------
-- Change the window themes.
-- Modeled from the ImGui demo.
-- https://github.com/ocornut/imgui/blob/master/imgui_demo.cpp
------------------------------------------------------------------------------------------------------
WindowManager.Theme.Set = function()
    if not WindowManager.Theme.IsSet then
        -- Default
        if WindowManager.Settings.Style == 0 then
            WindowManager.Theme.ApplyCustom(Themes.Default)
            WindowManager.Theme.TableRowBg = { 0.18, 0.20, 0.23, 1.00 }

        -- Dark
        elseif WindowManager.Settings.Style == 1 then
            UI.StyleColorsDark()
            WindowManager.Theme.TableRowBg = { 0.06, 0.06, 0.06, 1.00 }

        -- Light (Not Used)
        elseif WindowManager.Settings.Style == 2 then
            UI.StyleColorsLight()

        -- Classic
        elseif WindowManager.Settings.Style == 3 then
            UI.StyleColorsClassic()
            WindowManager.Theme.TableRowBg = { 0.00, 0.00, 0.00, 1.00 }

        else
            WindowManager.Theme.ApplyCustom(Themes.Default)
        end

        WindowManager.Theme.IsSet = true
    end
end

------------------------------------------------------------------------------------------------------
-- Applies a custom theme.
------------------------------------------------------------------------------------------------------
---@param theme table defined in resources.themes.
------------------------------------------------------------------------------------------------------
WindowManager.Theme.ApplyCustom = function(theme)
    for flagName, flagValue in pairs(Themes.Elements) do
        if theme[flagName] then
            UI.PushStyleColor(flagValue, theme[flagName])
        end
    end
end