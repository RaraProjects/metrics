Config.Window = T{}

Config.Window.Name = "Metrics - Help"
Config.Window.Need_Position_Reset = true

------------------------------------------------------------------------------------------------------
-- Populate the data in the monitor window.
------------------------------------------------------------------------------------------------------
Config.Window.Populate = function()
    if not Ashita.States.Zoning and Metrics.Window.Config_Window_Visible[1] then

        UI.PushStyleVar(ImGuiStyleVar_Alpha, Metrics.Window.Alpha)
        UI.PushStyleVar(ImGuiStyleVar_CellPadding, {10, 1})
        UI.PushStyleVar(ImGuiStyleVar_WindowPadding, {7, 3})
        UI.PushStyleVar(ImGuiStyleVar_ItemSpacing, {0, 5})
        UI.PushStyleVar(ImGuiStyleVar_ItemInnerSpacing, {5, 0})

        local window_flags = Window.Flags
        if not Metrics.Window.Show_Title then window_flags = bit.bor(window_flags, ImGuiWindowFlags_NoTitleBar) end

        -- Handle resetting the window position between characters.
        if Config.Window.Need_Position_Reset then
            UI.SetNextWindowPos({Metrics.Window.Config_X, Metrics.Window.Config_Y}, ImGuiCond_Always)
            Config.Window.Need_Position_Reset = false
        end

        if UI.Begin(Config.Window.Name, Metrics.Window.Config_Window_Visible, window_flags) then
            Metrics.Window.Config_X, Metrics.Window.Config_Y = UI.GetWindowPos()
            Window.Set_Window_Scale()
            Window.Theme.Set()
            Config.Populate()       -- Populate the window.
            UI.End()
        end

        UI.PopStyleVar(5)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles Settings window visibility.
------------------------------------------------------------------------------------------------------
Config.Window.Toggle_Visibility = function()
    Metrics.Window.Config_Window_Visible[1] = not Metrics.Window.Config_Window_Visible[1]
end

------------------------------------------------------------------------------------------------------
-- Hides the config window.
------------------------------------------------------------------------------------------------------
Config.Window.Hide = function()
    Metrics.Window.Config_Window_Visible[1] = false
end