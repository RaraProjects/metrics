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
    if UI.Checkbox("Show Title Bar", {Metrics.Window.Show_Title}) then
        Metrics.Window.Show_Title = not Metrics.Window.Show_Title
    end
    UI.Separator() Window.Theme.Choose()
    UI.Separator() Window.Widgets.Alpha()
    Window.Widgets.Window_Scale()
end