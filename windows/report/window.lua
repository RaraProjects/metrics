Report.Window = T{}

Report.Window.Name = "Metrics - Reporting"
Report.Window.Need_Position_Reset = true
Report.Window.Scaling_Set = false

------------------------------------------------------------------------------------------------------
-- Populate the data in the monitor window.
------------------------------------------------------------------------------------------------------
Report.Window.Populate = function()
    if not Ashita.States.Zoning and Metrics.Window.Report_Window_Visible[1] then

        UI.PushStyleVar(ImGuiStyleVar_Alpha, Metrics.Window.Alpha)
        UI.PushStyleVar(ImGuiStyleVar_CellPadding, {10, 1})
        UI.PushStyleVar(ImGuiStyleVar_WindowPadding, {7, 3})
        UI.PushStyleVar(ImGuiStyleVar_ItemSpacing, {0, 5})
        UI.PushStyleVar(ImGuiStyleVar_ItemInnerSpacing, {5, 0})

        local window_flags = Window.Flags
        if not Metrics.Window.Show_Title then window_flags = bit.bor(window_flags, ImGuiWindowFlags_NoTitleBar) end

        -- Handle resetting the window position between characters.
        if Report.Window.Need_Position_Reset then
            UI.SetNextWindowPos({Metrics.Window.Report_X, Metrics.Window.Report_Y}, ImGuiCond_Always)
            Report.Window.Need_Position_Reset = false
        end

        if UI.Begin(Report.Window.Name, Metrics.Window.Report_Window_Visible, window_flags) then
            Metrics.Window.Report_X, Metrics.Window.Report_Y = UI.GetWindowPos()
            Report.Window.Set_Scaling()
            Window.Theme.Set()
            Report.Populate()       -- Populate the window.
            UI.End()
        end

        UI.PopStyleVar(5)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles Report window visibility.
------------------------------------------------------------------------------------------------------
Report.Window.Toggle_Visibility = function()
    Metrics.Window.Report_Window_Visible[1] = not Metrics.Window.Report_Window_Visible[1]
end

------------------------------------------------------------------------------------------------------
-- Hides the report window.
------------------------------------------------------------------------------------------------------
Report.Window.Hide = function()
    Metrics.Window.Report_Window_Visible[1] = false
end

------------------------------------------------------------------------------------------------------
-- Sets the report window scaling.
------------------------------------------------------------------------------------------------------
Report.Window.Set_Scaling = function()
    if not Report.Window.Is_Scaling_Set() then
        UI.SetWindowFontScale(Window.Get_Scaling())
        Report.Window.Set_Scaling_Flag(true)
    end
end

------------------------------------------------------------------------------------------------------
-- Checks if the report window scaling is set.
------------------------------------------------------------------------------------------------------
Report.Window.Is_Scaling_Set = function()
    return Report.Window.Scaling_Set
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the report window scaling update flag.
-- ------------------------------------------------------------------------------------------------------
---@param scaling boolean
-- ------------------------------------------------------------------------------------------------------
Report.Window.Set_Scaling_Flag = function(scaling)
    Report.Window.Scaling_Set = scaling
end