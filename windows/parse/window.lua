Parse.Window = T{}

Parse.Window.Name = "Metrics - Parse"
Parse.Window.Visible = {true}
Parse.Window.Need_Position_Reset = true

------------------------------------------------------------------------------------------------------
-- Populate the data in the monitor window.
------------------------------------------------------------------------------------------------------
Parse.Window.Populate = function()
    if not Ashita.States.Zoning and Parse.Window.Visible[1] then

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

        if UI.Begin(Parse.Window.Name, Parse.Window.Visible, window_flags) then
            Metrics.Window.Parse_X, Metrics.Window.Parse_Y = UI.GetWindowPos()
            Window.Set_Window_Scale()
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
    Parse.Window.Visible[1] = not Parse.Window.Visible[1]
end

------------------------------------------------------------------------------------------------------
-- Hides the parse window.
------------------------------------------------------------------------------------------------------
Parse.Window.Hide = function()
    Parse.Window.Visible[1] = false
end