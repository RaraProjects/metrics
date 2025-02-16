Hub = {}

require("modules.hub.config")

Hub.Name   = "Hub"
Hub.Title  = "Metrics"
Hub.Module = "Hub"
Hub.File   = "hub"

------------------------------------------------------------------------------------------------------
-- Initializes the Hub screen.
------------------------------------------------------------------------------------------------------
---@param settings? table settings that come from the Ashita settings_update event.
------------------------------------------------------------------------------------------------------
Hub.Initialize = function(settings)
    -- Get saved settings from file.
    Hub.Settings = settings or Settings_File.load(Hub.Config.Defaults, Hub.File)

    -- Create the Hub Window.
    Hub.Window = Window:New({
        Name     = Hub.Name,
        Title    = Hub.Title,
        Module   = Hub.Module,
        Settings = Hub.Settings,
    })
end

------------------------------------------------------------------------------------------------------
-- Populate the data in the monitor window.
------------------------------------------------------------------------------------------------------
Hub.Content = function()
    -- If Multi Window mode is enabled then just show the buttons here. The rest of the content is handled
    -- in the primary screen refresh event.
    if Window_Manager.Settings.Multi_Window then
        Hub.Buttons()

    -- Only show the Mini or Nano mode if they are enabled while in Single Window mode.
    else
        if Parse.Config.Is_Nano_Mode() or Parse.Config.Is_Mini_Mode() then
            Parse.Content()
        else
            Hub.Single_Window()
        end
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
    UI.SameLine() Hub.Loot_Button()
    UI.SameLine() Hub.Report_Button()
    UI.SameLine() Hub.Settings_Button()
    UI.SameLine() Hub.Debug_Button()
    UI.SameLine() Hub.Toggle_All_Button()
end

------------------------------------------------------------------------------------------------------
-- Shows Metrics in a single window with tabs.
------------------------------------------------------------------------------------------------------
Hub.Single_Window = function()
    if UI.BeginTabBar("Tabs", Window_Manager.Tabs.Flags) then
        if UI.BeginTabItem(Parse.Name, false, Window_Manager.Is_Module_Active(Parse.Name)) then
            Window_Manager.Clear_Module_Switch(Parse.Name)
            Parse.Content()
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
        if UI.BeginTabItem(Loot.Name, false, Window_Manager.Is_Module_Active(Loot.Name)) then
            Window_Manager.Clear_Module_Switch(Loot.Name)
            Loot.Content()
            UI.EndTabItem()
        end
        if UI.BeginTabItem(Report.Name, false, Window_Manager.Is_Module_Active(Report.Name)) then
            Window_Manager.Clear_Module_Switch(Report.Name)
            Report.Content()
            UI.EndTabItem()
        end
        if UI.BeginTabItem(Config.Name, false, Window_Manager.Is_Module_Active(Config.Name)) then
            Window_Manager.Clear_Module_Switch(Config.Name)
            Config.ActiveSettingsWindow = Config.ModuleFile.CONFIG
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
        if Window_Manager.Settings.Multi_Window then Parse.Window.Toggle_Visibility() end
        Window_Manager.Settings.Active_Window = Parse.Name
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
        if Window_Manager.Settings.Multi_Window then Focus.Window.Toggle_Visibility() end
        Window_Manager.Settings.Active_Window = Focus.Name
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
        if Window_Manager.Settings.Multi_Window then Blog.Window.Toggle_Visibility() end
        Window_Manager.Settings.Active_Window = Blog.Name
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
        if Window_Manager.Settings.Multi_Window then XP.Window.Toggle_Visibility() end
        Window_Manager.Settings.Active_Window = XP.Name
    end
    if not active then UI.PopStyleColor(3) end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Loot window visibility.
------------------------------------------------------------------------------------------------------
Hub.Loot_Button = function()
    local active = Loot.Window.Is_Visible()
    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.INACTIVE)
    end
    if UI.Button(Loot.Name) then
        if Window_Manager.Settings.Multi_Window then Loot.Window.Toggle_Visibility() end
        Window_Manager.Settings.Active_Window = Loot.Name
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
        if Window_Manager.Settings.Multi_Window then Report.Window.Toggle_Visibility() end
        Window_Manager.Settings.Active_Window = Report.Name
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
        if not (Config.Window.Is_Visible() and Config.ActiveSettingsWindow ~= Config.ModuleFile.CONFIG) then
            if Window_Manager.Settings.Multi_Window then Config.Window.Toggle_Visibility() end
        end
        Window_Manager.Settings.Active_Window = Config.Name
        Config.ActiveSettingsWindow = Config.ModuleFile.CONFIG
    end
    if not active then UI.PopStyleColor(3) end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Debug window visibility.
------------------------------------------------------------------------------------------------------
Hub.Debug_Button = function()
    if not Debug.Is_Enabled() then return nil end
    local active = Debug.Window.Is_Visible()
    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.INACTIVE)
    end
    if UI.Button(Debug.Name) then
        if Window_Manager.Settings.Multi_Window then Debug.Window.Toggle_Visibility() end
        Window_Manager.Settings.Active_Window = Debug.Name
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
