Report.Window = T{}

Report.Window.Name = "Metrics - Reporting"
Report.Window.Visible = {false}
Report.Window.Need_Position_Reset = true

------------------------------------------------------------------------------------------------------
-- Populate the data in the monitor window.
------------------------------------------------------------------------------------------------------
Report.Window.Populate = function()
    if not Ashita.States.Zoning and Report.Window.Visible[1] then

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

        if UI.Begin(Report.Window.Name, Report.Window.Visible, window_flags) then
            Metrics.Window.Report_X, Metrics.Window.Report_Y = UI.GetWindowPos()
            Window.Set_Window_Scale()
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
    Report.Window.Visible[1] = not Report.Window.Visible[1]
end

------------------------------------------------------------------------------------------------------
-- Hides the report window.
------------------------------------------------------------------------------------------------------
Report.Window.Hide = function()
    Report.Window.Visible[1] = false
end