WindowManager.Config = { }

WindowManager.Config.Defaults = T{
    Alpha                 = 1.0,
    Window_Scaling        = 1.0,
    Style                 = 0,
    Show_Title            = false,
    Show_Mouse            = false,
    Multi_Window          = false,
    Active_Window         = 'Parse',
    Hub_X                 = 100,
    Hub_Y                 = 100,
    Screenshot_X          = 100,
    Screenshot_Y          = 100,
    Config_Window_Visible = { false },
    Config_X              = 100,
    Config_Y              = 100,
}

------------------------------------------------------------------------------------------------------
-- Resets visual settings in the window.
------------------------------------------------------------------------------------------------------
WindowManager.Config.Reset = function()
    WindowManager.Settings.Alpha          = WindowManager.Config.Defaults.Alpha
    WindowManager.Settings.Window_Scaling = WindowManager.Config.Defaults.Window_Scaling
    WindowManager.Settings.Show_Title     = WindowManager.Config.Defaults.Show_Title
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the GUI.
------------------------------------------------------------------------------------------------------
WindowManager.Config.Display = function()
    if UI.BeginTable('GUI Setings', 2) then
        -- Title Bar
        UI.TableNextColumn()
        if UI.Checkbox('Show Title Bar', {WindowManager.Settings.Show_Title}) then
            WindowManager.Settings.Show_Title = not WindowManager.Settings.Show_Title
        end
        WindowManager.Widgets.HelpMarker('Enables a window header that allows you to collapse the window.')

        -- Show Mouse
        UI.TableNextColumn()
        if UI.Checkbox('Show Mouse', {WindowManager.Settings.Show_Mouse}) then
            WindowManager.ToggleMouse()
        end
        WindowManager.Widgets.HelpMarker('There are a lot of click targets in Metrics. If you can\'t see your mouse when hovering over ' ..
                                   'the windows of ImGui based addons and would like to then give this a try. It will show your regular ' ..
                                   'Windows mouse on top of your regular in game cursor.')

        -- Multi Window
        UI.TableNextColumn()
        if UI.Checkbox('Multi Window', {WindowManager.Settings.Multi_Window}) then
            WindowManager.Settings.Multi_Window = not WindowManager.Settings.Multi_Window
            if WindowManager.Settings.Multi_Window then
                WindowManager.Settings.Active_Window = nil
                Config.Window.Show()
            else
                WindowManager.Settings.Active_Window = Config.Name
                Hub.Window.Show()
                Config.Window.Hide()
            end
        end
        WindowManager.Widgets.HelpMarker('Have mutliple tabs open at once by enabling multiple windows. Be cautious running at ' ..
                                                'higher FPS with multiple windows open. It may affect performance.')

        UI.EndTable()
    end

    UI.Separator() WindowManager.ThemeSelectionContent()
    UI.Separator() WindowManager.Widgets.Alpha()
    WindowManager.Widgets.WindowScale()
end

------------------------------------------------------------------------------------------------------
-- Returns the window alpha.
------------------------------------------------------------------------------------------------------
---@return number
------------------------------------------------------------------------------------------------------
WindowManager.Config.GetAlpha = function()
    return WindowManager.Settings.Alpha or 1
end

------------------------------------------------------------------------------------------------------
-- Returns the window scaling.
------------------------------------------------------------------------------------------------------
---@return number
------------------------------------------------------------------------------------------------------
WindowManager.Config.GetScaling = function()
    return WindowManager.Settings.Window_Scaling or 1
end