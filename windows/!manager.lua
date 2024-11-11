Window_Manager = T{}

Window_Manager.Window_List = T{}
Window_Manager.Mask = false         -- Hides all windows.

Window_Manager.Tabs = {}
Window_Manager.Tabs.Flags = ImGuiTabBarFlags_None
Window_Manager.Tabs.Switches = T{}
Window_Manager.Tabs.Active = nil

Window_Manager.Table = {}
Window_Manager.Table.Flags = {
    None = bit.bor(ImGuiTableFlags_None),
    Resizable = bit.bor(ImGuiTableFlags_NoSavedSettings, ImGuiTableFlags_Resizable, ImGuiTableFlags_SizingStretchProp, ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders),
    Borders = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders),
    Fixed_Borders = bit.bor(ImGuiTableFlags_SizingFixedFit, ImGuiTableFlags_Resizable, ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders, ImGuiTableFlags_NoHostExtendX),
    Team = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders),
    Scrollable = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders, ImGuiTableFlags_ScrollY),
}

Window_Manager.Bar_Delay = Socket.gettime()
Window_Manager.Bar_Delay_Threshold = 0.70

Window_Manager.Show_Mouse_Refresh = true
Window_Manager.IO = UI.GetIO()
Window_Manager.IO.MouseDrawCursor = false

require("windows.themes")
require("windows.widgets")
require("windows.config")

------------------------------------------------------------------------------------------------------
-- Adds a window to be tracked by the Window Manager.
------------------------------------------------------------------------------------------------------
---@param name string
---@param module string
---@param window table
------------------------------------------------------------------------------------------------------
Window_Manager.Add_Window = function(name, module, window)
    if not name or not module or not window then return nil end
    Window_Manager.Window_List[module] = window
end

------------------------------------------------------------------------------------------------------
-- Makes all windows invisible or not.
------------------------------------------------------------------------------------------------------
Window_Manager.Toggle_Mask = function()
    Window_Manager.Mask = not Window_Manager.Mask
end

------------------------------------------------------------------------------------------------------
-- Returns whether to mask the windows or not.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Window_Manager.Is_Masked = function()
    return Window_Manager.Mask
end

------------------------------------------------------------------------------------------------------
-- Resets the settings flags for all windows for initialization and character switch.
------------------------------------------------------------------------------------------------------
Window_Manager.Settings_Reset = function()
    for _, pointer in pairs(Window_Manager.Window_List) do
        if pointer.Settings_Reset then pointer.Settings_Reset() end
    end
end

------------------------------------------------------------------------------------------------------
-- Resets all window scaling flags.
------------------------------------------------------------------------------------------------------
Window_Manager.Reset_Scaling_Flags = function()
    for _, pointer in pairs(Window_Manager.Window_List) do
        if pointer.Force_Scaling_Reset then pointer.Force_Scaling_Reset() end
    end
end

------------------------------------------------------------------------------------------------------
-- Gets saved window visibility data.
------------------------------------------------------------------------------------------------------
---@param module string
---@return boolean
------------------------------------------------------------------------------------------------------
Window_Manager.Get_Visibility = function(module)
    if not module or not Metrics[module] then return false end
    if Metrics[module].Visible then return Metrics[module].Visible[1] end
    return false
end

------------------------------------------------------------------------------------------------------
-- Saves window visibility data.
------------------------------------------------------------------------------------------------------
---@param module string
---@param visible boolean
------------------------------------------------------------------------------------------------------
Window_Manager.Save_Visibility = function(module, visible)
    if not module or not Metrics[module] then return nil end
    Metrics[module].Visible[1] = visible
end

------------------------------------------------------------------------------------------------------
-- Gets saved window position data.
------------------------------------------------------------------------------------------------------
---@param module string
---@return table
------------------------------------------------------------------------------------------------------
Window_Manager.Get_Position = function(module)
    if not module or not Metrics[module] then return {100, 100} end
    if Metrics[module].X and Metrics[module].Y then return {Metrics[module].X, Metrics[module].Y} end
    return {100, 100}
end

------------------------------------------------------------------------------------------------------
-- Saves window position data.
------------------------------------------------------------------------------------------------------
---@param module string
---@param x integer
---@param y integer
------------------------------------------------------------------------------------------------------
Window_Manager.Save_Position = function(module, x, y)
    if not module or not Metrics[module] then return nil end
    if not x then x = 100 end
    if not y then y = 100 end
    Metrics[module].X = x
    Metrics[module].Y = y
end

------------------------------------------------------------------------------------------------------
-- Switch to a different module.
------------------------------------------------------------------------------------------------------
---@param module string
------------------------------------------------------------------------------------------------------
Window_Manager.Is_Module_Active = function(module)
    if not module then return nil end
    return Window_Manager.Tabs.Switches[module]
end

------------------------------------------------------------------------------------------------------
-- Switch to a different module.
------------------------------------------------------------------------------------------------------
---@param module string
------------------------------------------------------------------------------------------------------
Window_Manager.Switch_Module = function(module)
    if not module then return nil end
    Window_Manager.Tabs.Switches = T{}
    Window_Manager.Tabs.Switches[module] = ImGuiTabItemFlags_SetSelected
end

------------------------------------------------------------------------------------------------------
-- Clears the tab flag to stop it from being stuck open.
-- I tried just clearing the table entirely, but then the switch doesn't happen.
-- The individual module nodes need to be removed otherwise this doesn't work.
------------------------------------------------------------------------------------------------------
---@param module string
------------------------------------------------------------------------------------------------------
Window_Manager.Clear_Module_Switch = function(module)
    if not module then return nil end
    Window_Manager.Tabs.Switches[module] = nil
    Window_Manager.Tabs.Active = module
end

------------------------------------------------------------------------------------------------------
-- Returns the window scaling.
------------------------------------------------------------------------------------------------------
Window_Manager.Get_Scaling = function()
    return Metrics.Window.Window_Scaling
end

------------------------------------------------------------------------------------------------------
-- Toggles the Show Mouse option.
------------------------------------------------------------------------------------------------------
Window_Manager.Toggle_Mouse = function()
    Metrics.Window.Show_Mouse = not Metrics.Window.Show_Mouse
    Window_Manager.Show_Mouse_Refresh = true
end

------------------------------------------------------------------------------------------------------
-- Sets the show mouse flag after a setting change or initialization.
------------------------------------------------------------------------------------------------------
Window_Manager.Check_Mouse = function()
    if Window_Manager.Show_Mouse_Refresh then
        Window_Manager.IO.MouseDrawCursor = Metrics.Window.Show_Mouse
        Window_Manager.Show_Mouse_Refresh = false
    end
end

------------------------------------------------------------------------------------------------------
-- Sets the table row color.
------------------------------------------------------------------------------------------------------
---@param row integer
------------------------------------------------------------------------------------------------------
Window_Manager.Table_Row_Color = function(row)
    local x, y, z, w = UI.GetStyleColorVec4(ImGuiCol_TableRowBg)
    if (row % 2) == 0 then x, y, z, w = UI.GetStyleColorVec4(ImGuiCol_TableRowBgAlt) end
    local row_color = UI.GetColorU32({x, y, z, w})
    UI.TableSetBgColor(ImGuiTableBgTarget_RowBg0, row_color)
end

------------------------------------------------------------------------------------------------------
-- Starts a timer for progress bars to delay their loading to prevent slow screen resizing.
------------------------------------------------------------------------------------------------------
Window_Manager.Set_Bar_Delay = function()
    Window_Manager.Bar_Delay = Socket.gettime()
end

------------------------------------------------------------------------------------------------------
-- Checks if the bar loading delay has passed.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Window_Manager.Can_Bar_Load = function()
    local now = Socket.gettime()
    return (now - Window_Manager.Bar_Delay) > Window_Manager.Bar_Delay_Threshold
end