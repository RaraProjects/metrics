Hub = T{}

Hub.Title  = "Metrics"
Hub.Module = "Hub"
Hub.Window = Window:New({Title = Hub.Title, Module = Hub.Module})

require("modules.hub.config")

------------------------------------------------------------------------------------------------------
-- Populate the data in the monitor window.
------------------------------------------------------------------------------------------------------
Hub.Content = function()
    local nano_mode = Parse.Nano.Is_Enabled()
    local mini_mode = Parse.Mini.Is_Enabled()
    if Metrics.Window.Multi_Window then
        Hub.Multi_Window()
    elseif nano_mode then
        Parse.Nano.Populate()
    elseif mini_mode then
        Parse.Mini.Populate()
    else
        Hub.Single_Window()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows the window control buttons.
------------------------------------------------------------------------------------------------------
Hub.Buttons = function()
    UI.SameLine() Hub.Parse_Button()
    UI.SameLine() Hub.Focus_Button()
    UI.SameLine() Hub.Battle_Log_Button()
    UI.SameLine() Hub.XP_Button()
    UI.SameLine() Hub.Report_Button()
    UI.SameLine() Hub.Settings_Button()
    UI.SameLine() Hub.Toggle_All_Button()
end

------------------------------------------------------------------------------------------------------
-- Allows Metrics to be broken into individual windows.
------------------------------------------------------------------------------------------------------
Hub.Multi_Window = function()
    Hub.Buttons()
end

------------------------------------------------------------------------------------------------------
-- Shows Metrics in a single window with tabs.
------------------------------------------------------------------------------------------------------
Hub.Single_Window = function()
    if UI.BeginTabBar("Tabs", Window_Manager.Tabs.Flags) then
        if UI.BeginTabItem(Parse.Name, false, Window_Manager.Is_Module_Active(Parse.Name)) then
            Window_Manager.Clear_Module_Switch(Parse.Name)
            Parse.Full.Populate()
            UI.EndTabItem()
        end
        if UI.BeginTabItem(Focus.Name, false, Window_Manager.Is_Module_Active(Focus.Name)) then
            Window_Manager.Clear_Module_Switch(Focus.Name)
            Focus.Content()
            UI.EndTabItem()
        end
        if UI.BeginTabItem(Blog.Name, false, Window_Manager.Is_Module_Active(Blog.Name)) then
            Window_Manager.Clear_Module_Switch(Blog.Name)
            Blog.Content()
            UI.EndTabItem()
        end
        if UI.BeginTabItem(XP.Name, false, Window_Manager.Is_Module_Active(XP.Name)) then
            Window_Manager.Clear_Module_Switch(XP.Name)
            XP.Content()
            UI.EndTabItem()
        end
        if UI.BeginTabItem(Report.Name, false, Window_Manager.Is_Module_Active(Report.Name)) then
            Window_Manager.Clear_Module_Switch(Report.Name)
            Report.Content()
            UI.EndTabItem()
        end
        if UI.BeginTabItem(Config.Name, false, Window_Manager.Is_Module_Active(Config.Name)) then
            Window_Manager.Clear_Module_Switch(Config.Name)
            Config.Content()
            UI.EndTabItem()
        end
        UI.EndTabBar()
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Parse window visibility.
------------------------------------------------------------------------------------------------------
Hub.Parse_Button = function()
    local active = Parse.Window.Is_Visible()
    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.INACTIVE)
    end
    if UI.Button(Parse.Name) then
        if Metrics.Window.Multi_Window then Parse.Window.Toggle_Visibility() end
        Metrics.Window.Active_Window = Parse.Name
    end
    if not active then UI.PopStyleColor(3) end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Focus window visibility.
------------------------------------------------------------------------------------------------------
Hub.Focus_Button = function()
    local active = Focus.Window.Is_Visible()
    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.INACTIVE)
    end
    if UI.Button(Focus.Name) then
        if Metrics.Window.Multi_Window then Focus.Window.Toggle_Visibility() end
        Metrics.Window.Active_Window = Focus.Name
    end
    if not active then UI.PopStyleColor(3) end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Battle Log window visibility.
------------------------------------------------------------------------------------------------------
Hub.Battle_Log_Button = function()
    local active = Blog.Window.Is_Visible()
    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.INACTIVE)
    end
    if UI.Button(Blog.Name) then
        if Metrics.Window.Multi_Window then Blog.Window.Toggle_Visibility() end
        Metrics.Window.Active_Window = Blog.Name
    end
    if not active then UI.PopStyleColor(3) end
end

------------------------------------------------------------------------------------------------------
-- Toggles the XP window visibility.
------------------------------------------------------------------------------------------------------
Hub.XP_Button = function()
    local active = XP.Window.Is_Visible()
    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.INACTIVE)
    end
    if UI.Button(XP.Name) then
        if Metrics.Window.Multi_Window then XP.Window.Toggle_Visibility() end
        Metrics.Window.Active_Window = XP.Name
    end
    if not active then UI.PopStyleColor(3) end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Report window visibility.
------------------------------------------------------------------------------------------------------
Hub.Report_Button = function()
    local active = Report.Window.Is_Visible()
    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.INACTIVE)
    end
    if UI.Button(Report.Name) then
        if Metrics.Window.Multi_Window then Report.Window.Toggle_Visibility() end
        Metrics.Window.Active_Window = Report.Name
    end
    if not active then UI.PopStyleColor(3) end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Settings window visibility.
------------------------------------------------------------------------------------------------------
Hub.Settings_Button = function()
    local active = Config.Window.Is_Visible()
    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.INACTIVE)
    end
    if UI.Button(Config.Name) then
        -- Don't toggle off if config window is open and not showing settings.
        if not (Config.Window.Is_Visible() and Config.Settings_Mode ~= Config.Enum.File.CONFIG) then
            if Metrics.Window.Multi_Window then Config.Window.Toggle_Visibility() end
        end
        Metrics.Window.Active_Window = Config.Name
        Config.Settings_Mode = Config.Enum.File.CONFIG
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
        XP.Window.Hide()
        Report.Window.Hide()
    end
end
