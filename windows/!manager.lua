UI = require('imgui')

WindowManager = { }

require('windows.!window')

local themeHandler  = require('windows.themes')
local menuHandler   = require('windows.menu')
local configHandler = require('windows.config')

WindowManager.WindowList = { }

WindowManager.Settings     = { }
WindowManager.SettingsKeys = { }

WindowManager.Mask       = false -- Hides all windows.

WindowManager.Tabs          = { }
WindowManager.Tabs.Flags    = ImGuiTabBarFlags_None
WindowManager.Tabs.Switches = { }
WindowManager.Tabs.Active   = nil

WindowManager.Table = { }
WindowManager.Table.Flags =
{
    None         = bit.bor(ImGuiTableFlags_None),
    Resizable    = bit.bor(ImGuiTableFlags_NoSavedSettings, ImGuiTableFlags_Resizable, ImGuiTableFlags_SizingStretchProp, ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders),
    Borders      = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders),
    FixedBorders = bit.bor(ImGuiTableFlags_SizingFixedFit, ImGuiTableFlags_Resizable, ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders, ImGuiTableFlags_NoHostExtendX),
    Team         = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders),
    Scrollable   = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders, ImGuiTableFlags_ScrollY),
}

WindowManager.BarDelay           = Socket.gettime()
WindowManager.BarDelayThreshold  = 0.70

WindowManager.ShowMouseRefresh   = true

WindowManager.IO                 = UI.GetIO()
WindowManager.IO.MouseDrawCursor = false

WindowManager.Draw               = { }
WindowManager.Draw.Modes         =
{
    LEGACY = 0,
    BETA   = 1,
}
WindowManager.Draw.CurrentMode   = WindowManager.Draw.Modes.LEGACY

------------------------------------------------------------------------------------------------------
-- Initializes the window manager.
------------------------------------------------------------------------------------------------------
WindowManager.Initialize = function()
    WindowManager.ShowMouseRefresh = true
    WindowManager.SetDrawMode()
    configHandler.LoadSettings()
    WindowManager.Settings     = configHandler.GetSettings()
    WindowManager.SettingsKeys = configHandler.GetKeys()
end

------------------------------------------------------------------------------------------------------
-- Updates the settings table from Ashita settings_update event.
------------------------------------------------------------------------------------------------------
---@param settings table
------------------------------------------------------------------------------------------------------
WindowManager.UpdateSettingsFromLoad = function(settings)
    if settings then
        configHandler.UpdateSettingsFromLoad(settings)
        WindowManager.Settings = configHandler.GetSettings()
    end
end

------------------------------------------------------------------------------------------------------
-- Returns a pointer to the window settings table.
------------------------------------------------------------------------------------------------------
---@return table, table
------------------------------------------------------------------------------------------------------
WindowManager.GetSettings = function()
    return WindowManager.Settings, WindowManager.SettingsKeys
end

------------------------------------------------------------------------------------------------------
-- Returns whether the window manager is in multi-window mode or not.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
WindowManager.IsMultiWindow = function()
    return configHandler.IsMultiWindow()
end

------------------------------------------------------------------------------------------------------
-- Returns the current window scaling.
------------------------------------------------------------------------------------------------------
---@return number
------------------------------------------------------------------------------------------------------
WindowManager.GetScaling = function()
    return configHandler.GetScaling()
end

------------------------------------------------------------------------------------------------------
-- Returns the current window transparency.
------------------------------------------------------------------------------------------------------
---@return number
------------------------------------------------------------------------------------------------------
WindowManager.GetTransparency = function()
    return configHandler.GetTransparency()
end

------------------------------------------------------------------------------------------------------
-- Should windows show titles or not.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
WindowManager.IsShowingTitles = function()
    return configHandler.IsShowingTitles()
end

------------------------------------------------------------------------------------------------------
-- Returns the active window when multi-window is enabled.
------------------------------------------------------------------------------------------------------
WindowManager.SetActiveWindow = function(windowName)
    WindowManager.Settings.Active_Window = windowName
end

------------------------------------------------------------------------------------------------------
-- Adds a window to be tracked by the Window Manager.
------------------------------------------------------------------------------------------------------
---@param name   string
---@param module string
---@param window table
------------------------------------------------------------------------------------------------------
WindowManager.AddWindow = function(name, module, window)
    if not name or not module or not window then
        return nil
    end

    WindowManager.WindowList[module] = window
end

------------------------------------------------------------------------------------------------------
-- Makes all windows invisible or not.
------------------------------------------------------------------------------------------------------
WindowManager.ToggleMask = function()
    WindowManager.Mask = not WindowManager.Mask
end

------------------------------------------------------------------------------------------------------
-- Returns whether to mask the windows or not.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
WindowManager.IsMasked = function()
    return WindowManager.Mask
end

------------------------------------------------------------------------------------------------------
-- Resets the settings flags for all windows for initialization and character switch.
------------------------------------------------------------------------------------------------------
WindowManager.SettingsReset = function()
    for _, pointer in pairs(WindowManager.WindowList) do
        if pointer.SettingsReset and type(pointer.SettingsReset) == 'function' then
            pointer.SettingsReset()
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Call window configuration reset handler.
------------------------------------------------------------------------------------------------------
WindowManager.ResetConfig = function()
    return configHandler and configHandler.Reset()
end

------------------------------------------------------------------------------------------------------
-- Gets saved window visibility data.
------------------------------------------------------------------------------------------------------
---@param module string
---@return boolean
------------------------------------------------------------------------------------------------------
WindowManager.GetVisibility = function(module)
    if not WindowManager.WindowList[module] then
        return false
    end

    return WindowManager.WindowList[module].IsVisible()
end

------------------------------------------------------------------------------------------------------
-- Switch to a different module.
------------------------------------------------------------------------------------------------------
---@param module string
---@return any
------------------------------------------------------------------------------------------------------
WindowManager.IsModuleActive = function(module)
    if not module then
        return nil
    end

    return WindowManager.Tabs.Switches[module]
end

------------------------------------------------------------------------------------------------------
-- Switch to a different module.
------------------------------------------------------------------------------------------------------
---@param module string
------------------------------------------------------------------------------------------------------
WindowManager.SwitchModule = function(module)
    if not module then
        return nil
    end

    WindowManager.Tabs.Switches         = { }
    WindowManager.Tabs.Switches[module] = ImGuiTabItemFlags_SetSelected
end

------------------------------------------------------------------------------------------------------
-- Clears the tab flag to stop it from being stuck open.
-- I tried just clearing the table entirely, but then the switch doesn't happen.
-- The individual module nodes need to be removed otherwise this doesn't work.
------------------------------------------------------------------------------------------------------
---@param module string
------------------------------------------------------------------------------------------------------
WindowManager.ClearModuleSwitch = function(module)
    if not module then
        return nil
    end

    WindowManager.Tabs.Switches[module] = nil
    WindowManager.Tabs.Active           = module
end

------------------------------------------------------------------------------------------------------
-- Returns the draw mode.
------------------------------------------------------------------------------------------------------
---@return integer
------------------------------------------------------------------------------------------------------
WindowManager.GetDrawMode = function()
    return WindowManager.Draw.CurrentMode
end

------------------------------------------------------------------------------------------------------
-- Checks whether this is 4.2.0.1+ or not.
------------------------------------------------------------------------------------------------------
WindowManager.SetDrawMode = function()
    if UI.GetStyle then
        local style = UI.GetStyle()

        -- Ashita 4.2.0.1+
        if style and style.FontScaleMain ~= nil then
            WindowManager.Draw.CurrentMode = WindowManager.Draw.Modes.BETA
        elseif WindowManager.IO and WindowManager.IO.FontGlobalScale ~= nil then
            WindowManager.Draw.CurrentMode = WindowManager.Draw.Modes.LEGACY
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Show Mouse option.
------------------------------------------------------------------------------------------------------
WindowManager.ToggleMouse = function()
    WindowManager.Settings.Show_Mouse = not WindowManager.Settings.Show_Mouse
    WindowManager.ShowMouseRefresh    = true
end

------------------------------------------------------------------------------------------------------
-- Sets the show mouse flag after a setting change or initialization.
------------------------------------------------------------------------------------------------------
WindowManager.CheckMouse = function()
    if WindowManager.ShowMouseRefresh and WindowManager.Settings.Show_Mouse ~= nil then
        WindowManager.IO.MouseDrawCursor = WindowManager.Settings.Show_Mouse
        WindowManager.ShowMouseRefresh   = false
    end
end

------------------------------------------------------------------------------------------------------
-- Sets the table row color.
------------------------------------------------------------------------------------------------------
---@param row integer
------------------------------------------------------------------------------------------------------
WindowManager.TableRowColor = function(row)
    local x, y, z, w = UI.GetStyleColorVec4(ImGuiCol_TableRowBg)

    if (row % 2) == 0 then
        x, y, z, w = UI.GetStyleColorVec4(ImGuiCol_TableRowBgAlt)
    end

    UI.TableSetBgColor(ImGuiTableBgTarget_RowBg0, UI.GetColorU32({ x, y, z, w }))
end

------------------------------------------------------------------------------------------------------
-- Starts a timer for progress bars to delay their loading to prevent slow screen resizing.
------------------------------------------------------------------------------------------------------
WindowManager.SetBarDelay = function()
    WindowManager.BarDelay = Socket.gettime()
end

------------------------------------------------------------------------------------------------------
-- Checks if the bar loading delay has passed.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
WindowManager.CanBarLoad = function()
    local now = Socket.gettime()

    return (now - WindowManager.BarDelay) > WindowManager.BarDelayThreshold
end

------------------------------------------------------------------------------------------------------
-- Get the active menu name from the menu handler.
------------------------------------------------------------------------------------------------------
---@return string
------------------------------------------------------------------------------------------------------
WindowManager.GetMenuName = function()
    return menuHandler and menuHandler.GetMenuName() or 'No menu handler.'
end

------------------------------------------------------------------------------------------------------
-- Should we hide windows due to menus?
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
WindowManager.ShouldHideFromMenu = function()
    if not menuHandler then
        return false
    end

    return menuHandler.ShouldHideFromMenu() == true
end

------------------------------------------------------------------------------------------------------
-- Set the window theme flag.
------------------------------------------------------------------------------------------------------
WindowManager.ResetTheme = function()
    if not themeHandler then
        return false
    end

    themeHandler.ResetTheme()
end

------------------------------------------------------------------------------------------------------
-- Gets the style color for the row background from the theme.
------------------------------------------------------------------------------------------------------
WindowManager.GetRowBgColor = function()
    return themeHandler and themeHandler.GetRowBgColor() or { 0.00, 0.00, 0.00, 0.00 }
end

------------------------------------------------------------------------------------------------------
-- Populates the theme selection portion of a configuration screen.
------------------------------------------------------------------------------------------------------
WindowManager.ThemeSelectionContent = function()
    if not themeHandler then
        return UI.Text('No theme handler detected.')
    end

    local newStyle = themeHandler.ThemeSelectionContent(WindowManager.Settings.Style)

    if newStyle then
        WindowManager.Settings.Style = newStyle
        themeHandler.ResetTheme()
    end
end

------------------------------------------------------------------------------------------------------
-- Apply theme elements to the current window frame.
------------------------------------------------------------------------------------------------------
WindowManager.SetThemeElements = function()
    return themeHandler and themeHandler.SetThemeElements(WindowManager.Settings.Style)
end

------------------------------------------------------------------------------------------------------
-- Pop theme elements from the current window frame.
------------------------------------------------------------------------------------------------------
WindowManager.PopThemeElements = function()
    return themeHandler and themeHandler.PopThemeElements()
end

------------------------------------------------------------------------------------------------------
-- Display the window configuration settings.
------------------------------------------------------------------------------------------------------
WindowManager.ConfigDisplay = function()
    return configHandler and configHandler.Display()
end
