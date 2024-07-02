Hub = T{}

Hub.Name = "Metrics"
Hub.Visible = {true}
Hub.Need_Position_Reset = true
Hub.Scaling_Set = false

-- Need X and Y Position
-- Need window reposition flag.

------------------------------------------------------------------------------------------------------
-- Populate the data in the monitor window.
------------------------------------------------------------------------------------------------------
Hub.Populate = function()
    if not Ashita.States.Zoning and Hub.Visible[1] then

        UI.PushStyleVar(ImGuiStyleVar_Alpha, Metrics.Window.Alpha)
        UI.PushStyleVar(ImGuiStyleVar_CellPadding, {10, 1})
        UI.PushStyleVar(ImGuiStyleVar_WindowPadding, {7, 3})
        UI.PushStyleVar(ImGuiStyleVar_ItemSpacing, {0, 5})
        UI.PushStyleVar(ImGuiStyleVar_ItemInnerSpacing, {5, 0})

        -- Handle resetting the window position between characters.
        if Hub.Need_Position_Reset then
            UI.SetNextWindowPos({Metrics.Window.Hub_X, Metrics.Window.Hub_Y}, ImGuiCond_Always)
            Hub.Need_Position_Reset = false
        end

        if Window.Set_Mouse then
            Window.IO.MouseDrawCursor = Metrics.Window.Show_Mouse
            Window.Set_Mouse = false
        end

        local nano_mode = Parse.Nano.Is_Enabled()
        local mini_mode = Parse.Mini.Is_Enabled()
        local window_flags = Window.Flags
        if not Metrics.Window.Show_Title or nano_mode or mini_mode then
            window_flags = bit.bor(window_flags, ImGuiWindowFlags_NoTitleBar)
        end

        if UI.Begin(Hub.Name, Hub.Visible, window_flags) then
            Metrics.Window.Hub_X, Metrics.Window.Hub_Y = UI.GetWindowPos()
            Hub.Set_Scaling()
            Window.Theme.Set()

            if Metrics.Window.Multi_Window then
                Hub.Multi_Window()
            elseif nano_mode then
                Parse.Nano.Populate()
            elseif mini_mode then
                Parse.Mini.Populate()
            else
                Hub.Single_Window()
            end
            UI.End()
        end

        UI.PopStyleVar(5)
        Throttle.Block()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows the window control buttons.
------------------------------------------------------------------------------------------------------
Hub.Buttons = function()
    UI.SameLine() Hub.Parse_Button()
    UI.SameLine() Hub.Focus_Button()
    UI.SameLine() Hub.Battle_Log_Button()
    UI.SameLine() Hub.Report_Button()
    UI.SameLine() Hub.Settings_Button()
    UI.SameLine() Hub.Toggle_All_Button()
end

------------------------------------------------------------------------------------------------------
-- Allows Metrics to be broken into individual windows.
------------------------------------------------------------------------------------------------------
Hub.Multi_Window = function()
    Hub.Buttons()
    Parse.Window.Populate()
    Focus.Window.Populate()
    Blog.Window.Populate()
    Report.Window.Populate()
    Config.Window.Populate()
end

------------------------------------------------------------------------------------------------------
-- Shows Metrics in a single window with tabs.
------------------------------------------------------------------------------------------------------
Hub.Single_Window = function()
    if UI.BeginTabBar(Window.Tabs.Names.PARENT, Window.Tabs.Flags) then
        if UI.BeginTabItem(Parse.Tab_Name, false, Window.Tabs.Switch[Window.Tabs.Names.PARSE]) then
            Window.Tabs.Switch[Window.Tabs.Names.PARSE] = nil
            Window.Tabs.Active = Window.Tabs.Names.PARSE
            Parse.Full.Populate()
            UI.EndTabItem()
        end
        if UI.BeginTabItem(Focus.Tab_Name, false, Window.Tabs.Switch[Window.Tabs.Names.FOCUS]) then
            Window.Tabs.Switch[Window.Tabs.Names.FOCUS] = nil
            Window.Tabs.Active = Window.Tabs.Names.FOCUS
            Focus.Populate()
            UI.EndTabItem()
        end
        if UI.BeginTabItem(Window.Tabs.Names.BATTLELOG, false, Window.Tabs.Switch[Window.Tabs.Names.BATTLELOG]) then
            Window.Tabs.Switch[Window.Tabs.Names.BATTLELOG] = nil
            Window.Tabs.Active = Window.Tabs.Names.BATTLELOG
            Blog.Populate()
            UI.EndTabItem()
        end
        if UI.BeginTabItem(Window.Tabs.Names.REPORT, false, Window.Tabs.Switch[Window.Tabs.Names.REPORT]) then
            Window.Tabs.Switch[Window.Tabs.Names.REPORT] = nil
            Window.Tabs.Active = Window.Tabs.Names.REPORT
            Report.Populate()
            UI.EndTabItem()
        end
        if UI.BeginTabItem(Window.Tabs.Names.SETTINGS, false, Window.Tabs.Switch[Window.Tabs.Names.SETTINGS]) then
            Window.Tabs.Switch[Window.Tabs.Names.SETTINGS] = nil
            Window.Tabs.Active = Window.Tabs.Names.SETTINGS
            Config.Populate()
            UI.EndTabItem()
        end
        if _Debug.Is_Enabled() then
            if UI.BeginTabItem(Window.Tabs.Names.DEBUG) then
                _Debug.Populate()
                UI.EndTabItem()
            end
        end
        UI.EndTabBar()
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Parse window visibility.
------------------------------------------------------------------------------------------------------
Hub.Parse_Button = function()
    local active = Metrics.Window.Parse_Window_Visible[1]
    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.DIM)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.DIM)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.DIM)
    end
    if UI.Button(Window.Tabs.Names.PARSE) then
        if Metrics.Window.Multi_Window then Parse.Window.Toggle_Visibility() end
        Metrics.Window.Active_Window = Window.Tabs.Names.PARSE
    end
    if not active then UI.PopStyleColor(3) end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Focus window visibility.
------------------------------------------------------------------------------------------------------
Hub.Focus_Button = function()
    local active = Metrics.Window.Focus_Window_Visible[1]
    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.DIM)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.DIM)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.DIM)
    end
    if UI.Button(Window.Tabs.Names.FOCUS) then
        if Metrics.Window.Multi_Window then Focus.Window.Toggle_Visibility() end
        Metrics.Window.Active_Window = Window.Tabs.Names.FOCUS
    end
    if not active then UI.PopStyleColor(3) end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Battle Log window visibility.
------------------------------------------------------------------------------------------------------
Hub.Battle_Log_Button = function()
    local active = Metrics.Window.Blog_Window_Visible[1]
    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.DIM)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.DIM)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.DIM)
    end
    if UI.Button(Window.Tabs.Names.BATTLELOG) then
        if Metrics.Window.Multi_Window then Blog.Window.Toggle_Visibility() end
        Metrics.Window.Active_Window = Window.Tabs.Names.BATTLELOG
    end
    if not active then UI.PopStyleColor(3) end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Report window visibility.
------------------------------------------------------------------------------------------------------
Hub.Report_Button = function()
    local active = Metrics.Window.Report_Window_Visible[1]
    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.DIM)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.DIM)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.DIM)
    end
    if UI.Button(Window.Tabs.Names.REPORT) then
        if Metrics.Window.Multi_Window then Report.Window.Toggle_Visibility() end
        Metrics.Window.Active_Window = Window.Tabs.Names.REPORT
    end
    if not active then UI.PopStyleColor(3) end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Settings window visibility.
------------------------------------------------------------------------------------------------------
Hub.Settings_Button = function()
    local active = Metrics.Window.Config_Window_Visible[1]
    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.DIM)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.DIM)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.DIM)
    end
    if UI.Button(Window.Tabs.Names.SETTINGS) then
        if Metrics.Window.Multi_Window then Config.Window.Toggle_Visibility() end
        Metrics.Window.Active_Window = Window.Tabs.Names.SETTINGS
    end
    if not active then UI.PopStyleColor(3) end
end

------------------------------------------------------------------------------------------------------
-- Hides or shows all windows.
------------------------------------------------------------------------------------------------------
Hub.Toggle_All_Button = function()
    if UI.Button("X") then
        Blog.Window.Hide()
        Config.Window.Hide()
        Focus.Window.Hide()
        Parse.Window.Hide()
        Report.Window.Hide()
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles hub window visibility.
------------------------------------------------------------------------------------------------------
Hub.Toggle_Visibility = function()
    Hub.Visible[1] = not Hub.Visible[1]
end

------------------------------------------------------------------------------------------------------
-- Sets the hub window scaling.
------------------------------------------------------------------------------------------------------
Hub.Set_Scaling = function()
    if not Hub.Is_Scaling_Set() then
        UI.SetWindowFontScale(Window.Get_Scaling())
        Hub.Set_Scaling_Flag(true)
    end
end

------------------------------------------------------------------------------------------------------
-- Checks if the hub window scaling is set.
------------------------------------------------------------------------------------------------------
Hub.Is_Scaling_Set = function()
    return Hub.Scaling_Set
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the hub window scaling update flag.
-- ------------------------------------------------------------------------------------------------------
---@param scaling boolean
-- ------------------------------------------------------------------------------------------------------
Hub.Set_Scaling_Flag = function(scaling)
    Hub.Scaling_Set = scaling
end