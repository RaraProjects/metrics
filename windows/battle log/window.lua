Blog.Window = T{}

Blog.Window.Name = "Metrics - Battle Log"
Blog.Window.Need_Position_Reset = true
Blog.Window.Scaling_Set = false

------------------------------------------------------------------------------------------------------
-- Populate the data in the monitor window.
------------------------------------------------------------------------------------------------------
Blog.Window.Populate = function()
    if not Ashita.States.Zoning and Metrics.Window.Blog_Window_Visible[1] then

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

        if UI.Begin(Blog.Window.Name, Metrics.Window.Blog_Window_Visible, window_flags) then
            Metrics.Window.Blog_X, Metrics.Window.Blog_Y = UI.GetWindowPos()
            Blog.Window.Set_Scaling()
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
    Metrics.Window.Blog_Window_Visible[1] = not Metrics.Window.Blog_Window_Visible[1]
end

------------------------------------------------------------------------------------------------------
-- Hides the battle log window.
------------------------------------------------------------------------------------------------------
Blog.Window.Hide = function()
    Metrics.Window.Blog_Window_Visible[1] = false
end

------------------------------------------------------------------------------------------------------
-- Sets the battle log window scaling.
------------------------------------------------------------------------------------------------------
Blog.Window.Set_Scaling = function()
    if not Blog.Window.Is_Scaling_Set() then
        UI.SetWindowFontScale(Window.Get_Scaling())
        Blog.Window.Set_Scaling_Flag(true)
    end
end

------------------------------------------------------------------------------------------------------
-- Checks if the battle log window scaling is set.
------------------------------------------------------------------------------------------------------
Blog.Window.Is_Scaling_Set = function()
    return Blog.Window.Scaling_Set
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the window scaling update flag.
-- ------------------------------------------------------------------------------------------------------
---@param scaling boolean
-- ------------------------------------------------------------------------------------------------------
Blog.Window.Set_Scaling_Flag = function(scaling)
    Blog.Window.Scaling_Set = scaling
end