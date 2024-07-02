Focus.Window = T{}

Focus.Window.Name = "Metrics - Focus"
Focus.Window.Need_Position_Reset = true
Focus.Window.Scaling_Set = false

------------------------------------------------------------------------------------------------------
-- Populate the data in the monitor window.
------------------------------------------------------------------------------------------------------
Focus.Window.Populate = function()
    if not Ashita.States.Zoning and Metrics.Window.Focus_Window_Visible[1] then

        UI.PushStyleVar(ImGuiStyleVar_Alpha, Metrics.Window.Alpha)
        UI.PushStyleVar(ImGuiStyleVar_CellPadding, {10, 1})
        UI.PushStyleVar(ImGuiStyleVar_WindowPadding, {7, 3})
        UI.PushStyleVar(ImGuiStyleVar_ItemSpacing, {0, 5})
        UI.PushStyleVar(ImGuiStyleVar_ItemInnerSpacing, {5, 0})

        local window_flags = Window.Flags
        if not Metrics.Window.Show_Title then window_flags = bit.bor(window_flags, ImGuiWindowFlags_NoTitleBar) end

        -- Handle resetting the window position between characters.
        if Focus.Window.Need_Position_Reset then
            UI.SetNextWindowPos({Metrics.Window.Focus_X, Metrics.Window.Focus_Y}, ImGuiCond_Always)
            Focus.Window.Need_Position_Reset = false
        end

        if UI.Begin(Focus.Window.Name, Metrics.Window.Focus_Window_Visible, window_flags) then
            Metrics.Window.Focus_X, Metrics.Window.Focus_Y = UI.GetWindowPos()
            Focus.Window.Set_Scaling()
            Window.Theme.Set()
            Focus.Populate()        -- Populate the window.
            UI.End()
        end

        UI.PopStyleVar(5)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles Focus window visibility.
------------------------------------------------------------------------------------------------------
Focus.Window.Toggle_Visibility = function()
    Metrics.Window.Focus_Window_Visible[1] = not Metrics.Window.Focus_Window_Visible[1]
end

------------------------------------------------------------------------------------------------------
-- Hides the focus window.
------------------------------------------------------------------------------------------------------
Focus.Window.Hide = function()
    Metrics.Window.Focus_Window_Visible[1] = false
end

------------------------------------------------------------------------------------------------------
-- Sets the focus window scaling.
------------------------------------------------------------------------------------------------------
Focus.Window.Set_Scaling = function()
    if not Focus.Window.Is_Scaling_Set() then
        UI.SetWindowFontScale(Window.Get_Scaling())
        Focus.Window.Set_Scaling_Flag(true)
    end
end

------------------------------------------------------------------------------------------------------
-- Checks if the focus window scaling is set.
------------------------------------------------------------------------------------------------------
Focus.Window.Is_Scaling_Set = function()
    return Focus.Window.Scaling_Set
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the focus window scaling update flag.
-- ------------------------------------------------------------------------------------------------------
---@param scaling boolean
-- ------------------------------------------------------------------------------------------------------
Focus.Window.Set_Scaling_Flag = function(scaling)
    Focus.Window.Scaling_Set = scaling
end