Parse.Window = T{}

Parse.Window.Name = "Metrics - Parse"
Parse.Window.Need_Position_Reset = true
Parse.Window.Scaling_Set = false

------------------------------------------------------------------------------------------------------
-- Populate the data in the monitor window.
------------------------------------------------------------------------------------------------------
Parse.Window.Populate = function()
    if not Ashita.States.Zoning and Metrics.Window.Parse_Window_Visible[1] then

        UI.PushStyleVar(ImGuiStyleVar_Alpha, Metrics.Window.Alpha)
        UI.PushStyleVar(ImGuiStyleVar_CellPadding, {10, 1})
        UI.PushStyleVar(ImGuiStyleVar_WindowPadding, {7, 3})
        UI.PushStyleVar(ImGuiStyleVar_ItemSpacing, {0, 5})
        UI.PushStyleVar(ImGuiStyleVar_ItemInnerSpacing, {5, 0})

        local window_flags = Window.Flags
        if not Metrics.Window.Show_Title then window_flags = bit.bor(window_flags, ImGuiWindowFlags_NoTitleBar) end

        -- Handle resetting the window position between characters.
        if Parse.Window.Need_Position_Reset then
            UI.SetNextWindowPos({Metrics.Window.Parse_X, Metrics.Window.Parse_Y}, ImGuiCond_Always)
            Parse.Window.Need_Position_Reset = false
        end

        if UI.Begin(Parse.Window.Name, Metrics.Window.Parse_Window_Visible, window_flags) then
            Metrics.Window.Parse_X, Metrics.Window.Parse_Y = UI.GetWindowPos()
            Parse.Window.Set_Scaling()
            Window.Theme.Set()

            if Parse.Nano.Is_Enabled() then
                Parse.Nano.Populate()
            elseif Parse.Mini.Is_Enabled() then
                Parse.Mini.Populate()
            else
                Parse.Full.Populate()
            end

            UI.End()
        end

        UI.PopStyleVar(5)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles Parse window visibility.
------------------------------------------------------------------------------------------------------
Parse.Window.Toggle_Visibility = function()
    Metrics.Window.Parse_Window_Visible[1] = not Metrics.Window.Parse_Window_Visible[1]
end

------------------------------------------------------------------------------------------------------
-- Hides the parse window.
------------------------------------------------------------------------------------------------------
Parse.Window.Hide = function()
    Metrics.Window.Parse_Window_Visible[1] = false
end

------------------------------------------------------------------------------------------------------
-- Sets the parse window scaling.
------------------------------------------------------------------------------------------------------
Parse.Window.Set_Scaling = function()
    if not Parse.Window.Is_Scaling_Set() then
        UI.SetWindowFontScale(Window.Get_Scaling())
        Parse.Window.Set_Scaling_Flag(true)
    end
end

------------------------------------------------------------------------------------------------------
-- Checks if the parse window scaling is set.
------------------------------------------------------------------------------------------------------
Parse.Window.Is_Scaling_Set = function()
    return Parse.Window.Scaling_Set
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the parse window scaling update flag.
-- ------------------------------------------------------------------------------------------------------
---@param scaling boolean
-- ------------------------------------------------------------------------------------------------------
Parse.Window.Set_Scaling_Flag = function(scaling)
    Parse.Window.Scaling_Set = scaling
end