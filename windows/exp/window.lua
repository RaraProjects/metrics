XP.Window = T{}

XP.Window.Name = "Metrics - EXP"
XP.Window.Need_Position_Reset = true
XP.Window.Scaling_Set = false
XP.Window.Table_Flags = bit.bor(ImGuiTableFlags_Borders)

------------------------------------------------------------------------------------------------------
-- Populate the data in the monitor window.
------------------------------------------------------------------------------------------------------
XP.Window.Populate = function()
    if not Ashita.States.Zoning and Metrics.Window.XP_Window_Visible[1] then

        UI.PushStyleVar(ImGuiStyleVar_Alpha, Metrics.Window.Alpha)
        UI.PushStyleVar(ImGuiStyleVar_CellPadding, {10, 1})
        UI.PushStyleVar(ImGuiStyleVar_WindowPadding, {7, 3})
        UI.PushStyleVar(ImGuiStyleVar_ItemSpacing, {0, 5})
        UI.PushStyleVar(ImGuiStyleVar_ItemInnerSpacing, {5, 0})

        local window_flags = Window.Flags
        if not Metrics.Window.Show_Title then window_flags = bit.bor(window_flags, ImGuiWindowFlags_NoTitleBar) end
        if not Metrics.XP.Show_Background then window_flags = bit.bor(window_flags, ImGuiWindowFlags_NoBackground) end

        -- Handle resetting the window position between characters.
        if XP.Window.Need_Position_Reset then
            UI.SetNextWindowPos({Metrics.Window.XP_X, Metrics.Window.XP_Y}, ImGuiCond_Always)
            XP.Window.Need_Position_Reset = false
        end

        if UI.Begin(XP.Window.Name, Metrics.Window.XP_Window_Visible, window_flags) then
            local x = Metrics.Window.XP_X
            local y = Metrics.Window.XP_Y
            Metrics.Window.XP_X, Metrics.Window.XP_Y = UI.GetWindowPos()
            if x ~= Metrics.Window.XP_X or y ~= Metrics.Window.XP_Y then Window.Set_Bar_Delay() end

            XP.Window.Set_Scaling()
            Window.Theme.Set()
            XP.Populate()       -- Populate the window.
            UI.End()
        end

        UI.PopStyleVar(5)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles exp window visibility.
------------------------------------------------------------------------------------------------------
XP.Window.Toggle_Visibility = function()
    Metrics.Window.XP_Window_Visible[1] = not Metrics.Window.XP_Window_Visible[1]
end

------------------------------------------------------------------------------------------------------
-- Hides the exp window.
------------------------------------------------------------------------------------------------------
XP.Window.Hide = function()
    Metrics.Window.XP_Window_Visible[1] = false
end

------------------------------------------------------------------------------------------------------
-- Sets the exp window scaling.
------------------------------------------------------------------------------------------------------
XP.Window.Set_Scaling = function()
    if not XP.Window.Is_Scaling_Set() then
        UI.SetWindowFontScale(Window.Get_Scaling())
        XP.Window.Set_Scaling_Flag(true)
    end
end

------------------------------------------------------------------------------------------------------
-- Checks if the exp window scaling is set.
------------------------------------------------------------------------------------------------------
XP.Window.Is_Scaling_Set = function()
    return XP.Window.Scaling_Set
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the exp window scaling update flag.
-- ------------------------------------------------------------------------------------------------------
---@param scaling boolean
-- ------------------------------------------------------------------------------------------------------
XP.Window.Set_Scaling_Flag = function(scaling)
    XP.Window.Scaling_Set = scaling
end