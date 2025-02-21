Hub = { }

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
    Hub.Window = Window:New
    ({
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
    if WindowManager.Settings.Multi_Window then
        Hub.Buttons()

    -- Only show the Mini or Nano mode if they are enabled while in Single Window mode.
    else
        if Parse.Config.IsNanoMode() or Parse.Config.IsMiniMode() then
            Parse.Content()
        else
            Hub.SingleWindow()
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Shows the window control buttons.
------------------------------------------------------------------------------------------------------
Hub.Buttons = function()
    UI.SameLine() Hub.ParseButton()
    UI.SameLine() Hub.FocusButton()
    UI.SameLine() Hub.BattleLogButton()
    UI.SameLine() Hub.XpButton()
    UI.SameLine() Hub.LootButton()
    UI.SameLine() Hub.ReportButton()
    UI.SameLine() Hub.SettingsButton()
    UI.SameLine() Hub.DebugButton()
    UI.SameLine() Hub.ToggleAllButton()
end

------------------------------------------------------------------------------------------------------
-- Shows Metrics in a single window with tabs.
------------------------------------------------------------------------------------------------------
Hub.SingleWindow = function()
    if UI.BeginTabBar("Tabs", WindowManager.Tabs.Flags) then
        if UI.BeginTabItem(Parse.Name, false, WindowManager.IsModuleActive(Parse.Name)) then
            WindowManager.ClearModuleSwitch(Parse.Name)
            Parse.Content()
            UI.EndTabItem()
        end

        if UI.BeginTabItem(Focus.Name, false, WindowManager.IsModuleActive(Focus.Name)) then
            WindowManager.ClearModuleSwitch(Focus.Name)
            Focus.Content()
            UI.EndTabItem()
        end

        if UI.BeginTabItem(Blog.Name, false, WindowManager.IsModuleActive(Blog.Name)) then
            WindowManager.ClearModuleSwitch(Blog.Name)
            Blog.Content()
            UI.EndTabItem()
        end

        if UI.BeginTabItem(XP.Name, false, WindowManager.IsModuleActive(XP.Name)) then
            WindowManager.ClearModuleSwitch(XP.Name)
            XP.Content()
            UI.EndTabItem()
        end

        if UI.BeginTabItem(Loot.Name, false, WindowManager.IsModuleActive(Loot.Name)) then
            WindowManager.ClearModuleSwitch(Loot.Name)
            Loot.Content()
            UI.EndTabItem()
        end

        if UI.BeginTabItem(Report.Name, false, WindowManager.IsModuleActive(Report.Name)) then
            WindowManager.ClearModuleSwitch(Report.Name)
            Report.Content()
            UI.EndTabItem()
        end

        if UI.BeginTabItem(Config.Name, false, WindowManager.IsModuleActive(Config.Name)) then
            WindowManager.ClearModuleSwitch(Config.Name)
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
Hub.ParseButton = function()
    local active = Parse.Window.IsVisible()

    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.INACTIVE)
    end

    if UI.Button(Parse.Name) then
        if WindowManager.Settings.Multi_Window then
            Parse.Window.ToggleVisibility()
        end

        WindowManager.Settings.Active_Window = Parse.Name
    end

    if not active then
        UI.PopStyleColor(3)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Focus window visibility.
------------------------------------------------------------------------------------------------------
Hub.FocusButton = function()
    local active = Focus.Window.IsVisible()

    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.INACTIVE)
    end

    if UI.Button(Focus.Name) then
        if WindowManager.Settings.Multi_Window then
            Focus.Window.ToggleVisibility()
        end

        WindowManager.Settings.Active_Window = Focus.Name
    end

    if not active then
        UI.PopStyleColor(3)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Battle Log window visibility.
------------------------------------------------------------------------------------------------------
Hub.BattleLogButton = function()
    local active = Blog.Window.IsVisible()

    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.INACTIVE)
    end

    if UI.Button(Blog.Name) then
        if WindowManager.Settings.Multi_Window then
            Blog.Window.ToggleVisibility()
        end

        WindowManager.Settings.Active_Window = Blog.Name
    end

    if not active then
        UI.PopStyleColor(3)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the XP window visibility.
------------------------------------------------------------------------------------------------------
Hub.XpButton = function()
    local active = XP.Window.IsVisible()

    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.INACTIVE)
    end

    if UI.Button(XP.Name) then
        if WindowManager.Settings.Multi_Window then
            XP.Window.ToggleVisibility()
        end

        WindowManager.Settings.Active_Window = XP.Name
    end

    if not active then
        UI.PopStyleColor(3)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Loot window visibility.
------------------------------------------------------------------------------------------------------
Hub.LootButton = function()
    local active = Loot.Window.IsVisible()

    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.INACTIVE)
    end

    if UI.Button(Loot.Name) then
        if WindowManager.Settings.Multi_Window then
            Loot.Window.ToggleVisibility()
        end

        WindowManager.Settings.Active_Window = Loot.Name
    end

    if not active then
        UI.PopStyleColor(3)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Report window visibility.
------------------------------------------------------------------------------------------------------
Hub.ReportButton = function()
    local active = Report.Window.IsVisible()

    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.INACTIVE)
    end

    if UI.Button(Report.Name) then
        if WindowManager.Settings.Multi_Window then
            Report.Window.ToggleVisibility()
        end

        WindowManager.Settings.Active_Window = Report.Name
    end

    if not active then
        UI.PopStyleColor(3)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Settings window visibility.
------------------------------------------------------------------------------------------------------
Hub.SettingsButton = function()
    local active = Config.Window.IsVisible()

    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.INACTIVE)
    end

    if UI.Button(Config.Name) then
        -- Don't toggle off if config window is open and not showing settings.
        if not (Config.Window.IsVisible() and Config.ActiveSettingsWindow ~= Config.ModuleFile.CONFIG) then
            if WindowManager.Settings.Multi_Window then
                Config.Window.ToggleVisibility()
            end
        end

        WindowManager.Settings.Active_Window = Config.Name
        Config.ActiveSettingsWindow = Config.ModuleFile.CONFIG
    end

    if not active then
        UI.PopStyleColor(3)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Debug window visibility.
------------------------------------------------------------------------------------------------------
Hub.DebugButton = function()
    if not Debug.IsEnabled() then
        return nil
    end

    local active = Debug.Window.IsVisible()

    if not active then
        UI.PushStyleColor(ImGuiCol_Button, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Res.Colors.Basic.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Res.Colors.Basic.INACTIVE)
    end

    if UI.Button(Debug.Name) then
        if WindowManager.Settings.Multi_Window then
            Debug.Window.ToggleVisibility()
        end

        WindowManager.Settings.Active_Window = Debug.Name
    end

    if not active then
        UI.PopStyleColor(3)
    end
end

------------------------------------------------------------------------------------------------------
-- Hides or shows all windows.
------------------------------------------------------------------------------------------------------
Hub.ToggleAllButton = function()
    if UI.Button("X") then
        Blog.Window.Hide()
        Config.Window.Hide()
        Focus.Window.Hide()
        Parse.Window.Hide()
        XP.Window.Hide()
        Report.Window.Hide()
    end
end