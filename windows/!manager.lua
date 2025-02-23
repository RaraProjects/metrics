UI = require("imgui")

WindowManager = { }

require("windows.themes")
require("windows.widgets")
require("windows.config")
require("windows.menu")

WindowManager.WindowList = { }
WindowManager.Settings   = SettingsFile.load(WindowManager.Config.Defaults, "window")
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

WindowManager.BarDelay          = Socket.gettime()
WindowManager.BarDelayThreshold = 0.70

WindowManager.ShowMouseRefresh   = true

WindowManager.IO                 = UI.GetIO()
WindowManager.IO.MouseDrawCursor = false

------------------------------------------------------------------------------------------------------
-- Initializes the window manager.
------------------------------------------------------------------------------------------------------
WindowManager.Initialize = function()
    WindowManager.ShowMouseRefresh = true
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
        if pointer.SettingsReset and type(pointer.SettingsReset) == "function" then
            pointer.SettingsReset()
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Resets all window scaling flags.
------------------------------------------------------------------------------------------------------
WindowManager.ResetScalingFlags = function()
    for _, pointer in pairs(WindowManager.WindowList) do
        if pointer.ForceScalingReset and type(pointer.ForceScalingReset) == "function" then
            pointer.ForceScalingReset()
        end
    end
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