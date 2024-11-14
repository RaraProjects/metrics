Window_Manager.Config = T{}

Window_Manager.Config.Defaults = T{
    Alpha = 1.0,
    Window_Scaling = 1.0,
    Style = 0,
    X_Pos = 100,
    Y_Pos = 100,
    Show_Title = false,
    Show_Mouse = false,
    Multi_Window = false,
    Active_Window = "Parse",
    Hub_X = 100,
    Hub_Y = 100,
    Screenshot_X = 100,
    Screenshot_Y = 100,
    Config_Window_Visible = {false},
    Config_X = 100,
    Config_Y = 100,
}

------------------------------------------------------------------------------------------------------
-- Resets visual settings in the window.
------------------------------------------------------------------------------------------------------
Window_Manager.Config.Reset = function()
    Metrics.Window.Alpha = Window_Manager.Defaults.Alpha
    Metrics.Window.Window_Scaling = Window_Manager.Defaults.Window_Scaling
    Metrics.Window.Show_Title = Window_Manager.Defaults.Show_Title
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the GUI.
------------------------------------------------------------------------------------------------------
Window_Manager.Config.Display = function()
    if UI.BeginTable("GUI Setings", 2) then
        UI.TableNextColumn()
        if UI.Checkbox("Show Title Bar", {Metrics.Window.Show_Title}) then
            Metrics.Window.Show_Title = not Metrics.Window.Show_Title
        end
        UI.SameLine() Window_Manager.Widgets.HelpMarker("Enables a window header that allows you to collapse the window.")

        UI.TableNextColumn()
        if UI.Checkbox("Show Mouse", {Metrics.Window.Show_Mouse}) then
            Window_Manager.Toggle_Mouse()
        end
        UI.SameLine() Window_Manager.Widgets.HelpMarker("There are a lot of click targets in Metrics. If you can't see your mouse when hovering over " ..
                                   "the windows of ImGui based addons and would like to then give this a try. It will show your regular " ..
                                   "Windows mouse on top of your regular in game cursor.")

                                   UI.TableNextColumn()
        if UI.Checkbox("Multi Window", {Metrics.Window.Multi_Window}) then
            Metrics.Window.Multi_Window = not Metrics.Window.Multi_Window
            if Metrics.Window.Multi_Window then
                Metrics.Window.Active_Window = nil
                Config.Window.Show()
            else
                Metrics.Window.Active_Window = Config.Name
                Config.Window.Hide()
            end
        end
        UI.SameLine() Window_Manager.Widgets.HelpMarker("Have mutliple tabs open at once by enabling multiple windows. Be cautious running at " ..
                                                "higher FPS with multiple windows open. It may affect performance.")
        UI.EndTable()
    end

    UI.Separator() Window_Manager.Theme.Choose()
    UI.Separator() Window_Manager.Widgets.Alpha()
    Window_Manager.Widgets.Window_Scale()
end