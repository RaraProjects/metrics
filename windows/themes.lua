local themeHandler = { }

themeHandler.isSet      = false
themeHandler.tableRowBg = { 0.00, 0.00, 0.00, 0.00 }
themeHandler.resources  = require("resources.themes")
themeHandler.colorCount = 0

------------------------------------------------------------------------------------------------------
-- Reset the theme flag.
------------------------------------------------------------------------------------------------------
themeHandler.ResetTheme = function()
    themeHandler.isSet = false
end

------------------------------------------------------------------------------------------------------
-- Gets the style color for the row background.
------------------------------------------------------------------------------------------------------
themeHandler.GetRowBgColor = function()
    return themeHandler.tableRowBg
end

------------------------------------------------------------------------------------------------------
-- Applies a custom theme.
-- Style colors MUST be popped via themeHandler.PopThemeStyle().
------------------------------------------------------------------------------------------------------
---@param theme table defined in resources.themes.
------------------------------------------------------------------------------------------------------
themeHandler.ApplyCustomTheme = function(theme)
    local themeResources = themeHandler.resources

    themeHandler.colorCount = 0

    for flagName, flagValue in pairs(themeResources.Elements) do
        if theme[flagName] then
            UI.PushStyleColor(flagValue, theme[flagName])
            themeHandler.colorCount = themeHandler.colorCount + 1
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Pops the style colors added during ApplyCustomTheme.
------------------------------------------------------------------------------------------------------
themeHandler.PopThemeElements = function()
    if themeHandler.colorCount > 0 then
        UI.PopStyleColor(themeHandler.colorCount)
        themeHandler.colorCount = 0
    end
end

------------------------------------------------------------------------------------------------------
-- Change the window themes.
-- Modeled from the ImGui demo.
-- https://github.com/ocornut/imgui/blob/master/imgui_demo.cpp
------------------------------------------------------------------------------------------------------
themeHandler.SetThemeElements = function(style)
    local themeResources = themeHandler.resources

    if not themeHandler.isSet then
        -- Default
        if style == 0 then
            themeHandler.ApplyCustomTheme(themeResources.Default)
            themeHandler.tableRowBg = { 0.18, 0.20, 0.23, 1.00 }

        -- Dark
        elseif style == 1 then
            UI.StyleColorsDark()
            themeHandler.tableRowBg = { 0.06, 0.06, 0.06, 1.00 }

        -- Light (Not Used)
        elseif style == 2 then
            UI.StyleColorsLight()

        -- Classic
        elseif style == 3 then
            UI.StyleColorsClassic()
            themeHandler.tableRowBg = { 0.00, 0.00, 0.00, 1.00 }

        else
            themeHandler.ApplyCustomTheme(themeResources.Default)
        end

        themeHandler.isSet = true
    end
end

------------------------------------------------------------------------------------------------------
-- Change the window themes.
-- Modeled from the ImGui demo.
-- https://github.com/ocornut/imgui/blob/master/imgui_demo.cpp
------------------------------------------------------------------------------------------------------
---@param style integer
---@return integer|nil
------------------------------------------------------------------------------------------------------
themeHandler.ThemeSelectionContent = function(style)
    UI.Text('Theme (will affect other ImGui based addons)')

    if UI.RadioButton('Default ', { style }, 0) then
        return 0
    end

    UI.SameLine()
    if UI.RadioButton('Dark ', { style }, 1) then
        return 1
    end

    UI.SameLine()
    if UI.RadioButton('Classic ', { style }, 3) then
        return 3
    end

    return nil
end

return themeHandler
