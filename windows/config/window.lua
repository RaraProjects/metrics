Config.Window = T{}

Config.Window.Name = "Metrics - Help"
Config.Window.Need_Position_Reset = true
Config.Window.Scaling_Set = false

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

        -- Handle resetting the window position between characters.
        if Config.Window.Need_Position_Reset then
            UI.SetNextWindowPos({Metrics.Window.Config_X, Metrics.Window.Config_Y}, ImGuiCond_Always)
            Config.Window.Need_Position_Reset = false
        end

        if UI.Begin(Config.Window.Name, Metrics.Window.Config_Window_Visible, window_flags) then
            Metrics.Window.Config_X, Metrics.Window.Config_Y = UI.GetWindowPos()
            Config.Window.Set_Scaling()
            Window.Theme.Set()
            if Config.Settings_Mode == Config.Enum.File.PARSE then
                Parse.Config.Display()
            elseif Config.Settings_Mode == Config.Enum.File.FOCUS then
                Focus.Config.Display()
            elseif Config.Settings_Mode == Config.Enum.File.BLOG then
                Blog.Config.Display()
            elseif Config.Settings_Mode == Config.Enum.File.REPORT then
                Report.Config.Display()
            elseif Config.Settings_Mode == Config.Enum.File.CONFIG then
                Config.Populate()
            elseif Config.Settings_Mode == Config.Enum.File.EXP then
                XP.Config.Populate()
            end
            UI.End()
        end

        UI.PopStyleVar(5)
    end
end

------------------------------------------------------------------------------------------------------
-- Returns whether the config window is visible or not.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Config.Window.Is_Visible = function()
    return Metrics.Window.Config_Window_Visible[1]
end

------------------------------------------------------------------------------------------------------
-- Toggles Settings window visibility.
------------------------------------------------------------------------------------------------------
Config.Window.Toggle_Visibility = function()
    Metrics.Window.Config_Window_Visible[1] = not Metrics.Window.Config_Window_Visible[1]
end

------------------------------------------------------------------------------------------------------
-- Shows the config window.
------------------------------------------------------------------------------------------------------
Config.Window.Show = function()
    Metrics.Window.Config_Window_Visible[1] = true
end

------------------------------------------------------------------------------------------------------
-- Hides the config window.
------------------------------------------------------------------------------------------------------
Config.Window.Hide = function()
    Metrics.Window.Config_Window_Visible[1] = false
end

------------------------------------------------------------------------------------------------------
-- Allows toggling and mode switching with the UI buttons.
------------------------------------------------------------------------------------------------------
---@param settings_mode string
------------------------------------------------------------------------------------------------------
Config.Window.Button_Toggle = function(settings_mode)
    if not settings_mode then return nil end
    if Config.Window.Is_Visible() and Config.Settings_Mode == settings_mode then
        Config.Window.Hide()
    else
        Config.Settings_Mode = settings_mode
        Config.Window.Show()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets the config window scaling.
------------------------------------------------------------------------------------------------------
Config.Window.Set_Scaling = function()
    if not Config.Window.Is_Scaling_Set() then
        UI.SetWindowFontScale(Window.Get_Scaling())
        Config.Window.Set_Scaling_Flag(true)
    end
end

------------------------------------------------------------------------------------------------------
-- Checks if the config window scaling is set.
------------------------------------------------------------------------------------------------------
Config.Window.Is_Scaling_Set = function()
    return Config.Window.Scaling_Set
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the config window scaling update flag.
-- ------------------------------------------------------------------------------------------------------
---@param scaling boolean
-- ------------------------------------------------------------------------------------------------------
Config.Window.Set_Scaling_Flag = function(scaling)
    Config.Window.Scaling_Set = scaling
end