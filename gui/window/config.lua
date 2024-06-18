Window.Config = T{}

------------------------------------------------------------------------------------------------------
-- Resets visual settings in the window.
------------------------------------------------------------------------------------------------------
Window.Config.Reset = function()
    Metrics.Window.Alpha = Window.Defaults.Alpha
    Metrics.Window.Window_Scaling = Window.Defaults.Window_Scaling
    Metrics.Window.Show_Title = Window.Defaults.Show_Title
    Window.Scaling_Set = false
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the GUI.
------------------------------------------------------------------------------------------------------
Window.Config.Display = function()
    if UI.BeginTable("GUI Setings", 2) then
        UI.TableNextColumn()
        if UI.Checkbox("Show Title Bar", {Metrics.Window.Show_Title}) then
            Metrics.Window.Show_Title = not Metrics.Window.Show_Title
        end
        UI.SameLine() Window.Widgets.HelpMarker("Enables a window header that allows you to collapse the window.")

        UI.TableNextColumn()
        if UI.Checkbox("Show Mouse", {Metrics.Window.Show_Mouse}) then
            Metrics.Window.Show_Mouse = not Metrics.Window.Show_Mouse
            Window.IO.MouseDrawCursor = Metrics.Window.Show_Mouse
        end
        UI.SameLine() Window.Widgets.HelpMarker("There are a lot of click targets in Metrics. If you can't see your mouse when hovering over " ..
                                   "the windows of ImGui based addons and would like to then give this a try. It will show your regular " ..
                                   "Windows mouse on top of your regular in game cursor.")
        UI.EndTable()
    end

    UI.Separator() Window.Theme.Choose()
    UI.Separator() Window.Widgets.Alpha()
    Window.Widgets.Window_Scale()
end