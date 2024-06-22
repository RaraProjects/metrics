Blog.Window = T{}

Blog.Window.Name = "Metrics - Battle Log"
Blog.Window.Visible = {false}
Blog.Window.Need_Position_Reset = true

------------------------------------------------------------------------------------------------------
-- Populate the data in the monitor window.
------------------------------------------------------------------------------------------------------
Blog.Window.Populate = function()
    if not Ashita.States.Zoning and Blog.Window.Visible[1] then

        UI.PushStyleVar(ImGuiStyleVar_Alpha, Metrics.Window.Alpha)
        UI.PushStyleVar(ImGuiStyleVar_CellPadding, {10, 1})
        UI.PushStyleVar(ImGuiStyleVar_WindowPadding, {7, 3})
        UI.PushStyleVar(ImGuiStyleVar_ItemSpacing, {0, 5})
        UI.PushStyleVar(ImGuiStyleVar_ItemInnerSpacing, {5, 0})

        local window_flags = Window.Flags
        if not Metrics.Window.Show_Title then window_flags = bit.bor(window_flags, ImGuiWindowFlags_NoTitleBar) end

        -- Handle resetting the window position between characters.
        if Blog.Window.Need_Position_Reset then
            UI.SetNextWindowPos({Metrics.Window.Blog_X, Metrics.Window.Blog_Y}, ImGuiCond_Always)
            Blog.Window.Need_Position_Reset = false
        end

        if UI.Begin(Blog.Window.Name, Blog.Window.Visible, window_flags) then
            Metrics.Window.Blog_X, Metrics.Window.Blog_Y = UI.GetWindowPos()
            Window.Set_Window_Scale()
            Window.Theme.Set()
            Blog.Populate()
            UI.End()
        end

        UI.PopStyleVar(5)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles Battle Log window visibility.
------------------------------------------------------------------------------------------------------
Blog.Window.Toggle_Visibility = function()
    Blog.Window.Visible[1] = not Blog.Window.Visible[1]
end

------------------------------------------------------------------------------------------------------
-- Hides the battle log window.
------------------------------------------------------------------------------------------------------
Blog.Window.Hide = function()
    Blog.Window.Visible[1] = false
end