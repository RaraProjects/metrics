------------------------------------------------------------------------------------------------------
-- Subscribe to addon commands.
-- Influenced by HXUI: https://github.com/tirem/HXUI
------------------------------------------------------------------------------------------------------
ashita.events.register('command', 'command_cb', function (e)
    local commandArgs = e.command:lower():args()
---@diagnostic disable-next-line: undefined-field
    if table.contains({ "/metrics" }, commandArgs[1]) or table.contains({ "/met" }, commandArgs[1]) then
        local argument   = commandArgs[2]
        local subCommand = commandArgs[3]

        -- Help Text
        if not argument then
            if Config.ActiveSettingsWindow ~= Config.ModuleFile.CONFIG and Config.Window.IsVisible() then
                Config.ActiveSettingsWindow = Config.ModuleFile.CONFIG

            elseif Config.ActiveSettingsWindow ~= Config.ModuleFile.CONFIG and not Config.Window.IsVisible() then
                Config.ActiveSettingsWindow = Config.ModuleFile.CONFIG
                Config.Window.Show()

            elseif Config.ActiveSettingsWindow == Config.ModuleFile.CONFIG then
                Config.Window.ToggleVisibility()
            end

        -- General Settings
        elseif argument == "show" or argument == "s" then
            if not WindowManager.IsMasked() then
                Hub.Window.Show()
            end

            WindowManager.ToggleMask()

        elseif argument == "hub" then
            Hub.Window.ToggleVisibility()

        elseif argument == "debug" then
            Debug.Toggle()

        elseif argument == "nano" or argument == "n" then
            Parse.Config.EnableNanoMode()

        elseif argument == "mini" or argument == "m" then
            Parse.Config.EnableMiniMode()

        elseif argument == "reset" or argument == "r" then
            DB.Initialize(true)
            Blog.Initialize()

        elseif argument == "full" or argument == "f" then
            Parse.Config.EnabledFullMode()

        elseif argument == "pet" or argument == "p" then
            Parse.Config.TogglePet()

        elseif argument == "clock" or argument == "c" then
            Parse.Config.ToggleClock()

        elseif argument == "percent" then
            Focus.Config.PercentToggle()

        elseif argument == "dps" then
            Parse.Config.ToggleDPS()

        elseif argument == "speed" then
            Parse.Config.ToggleMeleeDelay()

        elseif argument == "throttle" then
            Throttle.Toggle()

        elseif argument == "lurk" then
            Parse.Config.ToggleLurkMode()

        elseif argument == "mouse" then
            WindowManager.ToggleMouse()

        -- XP
        elseif argument == "xp" and subCommand then
            if subCommand == "mini" then
                XP.Config.ToggleMiniMode()
            end

        -- General reports.
        elseif argument == "report" or argument == "rep" then
            local reportType = commandArgs[3]

            if reportType == "total" then
                Report.Publishing.Overall()

            elseif reportType == "melee" then
                Report.Publishing.DamageByType(DB.Trackable.MELEE_OVERALL)

            elseif reportType == "ws" then
                Report.Publishing.DamageByType(DB.Trackable.WEAPONSKILL)

            elseif reportType == "healing" then
                Report.Publishing.DamageByType(DB.Trackable.ALL_HEAL)
            end

        -- Primary module switching.
        elseif argument == "team" or argument == "parse" then
            Parse.Window.MakeActive()

        elseif argument == "focus" then
            Focus.Window.MakeActive()

        elseif argument == "log" or argument == "bl" then
            Blog.Window.MakeActive()

        elseif argument == "xp" then
            XP.Window.MakeActive()

        elseif argument == "report" or argument == "rep" then
            Report.Window.MakeActive()

        -- Player selection
        elseif argument == "player" or argument == "pl" then
            local playerString = commandArgs[3]

            if playerString then
                DB.Widgets.PlayerSwitch(playerString)
            end

        -- Focus tab switching.
        elseif argument == "melee" then
            Focus.Tabs.Switch[Focus.Tabs.Names.MELEE] = ImGuiTabItemFlags_SetSelected

        elseif argument == "ranged" then
            Focus.Tabs.Switch[Focus.Tabs.Names.RANGED] = ImGuiTabItemFlags_SetSelected

        elseif argument == "ws" or argument == "weaponskill" then
            Focus.Tabs.Switch[Focus.Tabs.Names.WS] = ImGuiTabItemFlags_SetSelected

        elseif argument == "magic" then
            Focus.Tabs.Switch[Focus.Tabs.Names.MAGIC] = ImGuiTabItemFlags_SetSelected

        elseif argument == "ability" or argument == "abil" then
            Focus.Tabs.Switch[Focus.Tabs.Names.ABILITIES] = ImGuiTabItemFlags_SetSelected

        elseif (argument == "pet" or argument == "p") and WindowManager.Tabs.Active == Focus.Name then
            Focus.Tabs.Switch[Focus.Tabs.Names.PETS] = ImGuiTabItemFlags_SetSelected

        elseif argument == "defense" or argument == "def" then
            Focus.Tabs.Switch[Focus.Tabs.Names.DEFENSE] = ImGuiTabItemFlags_SetSelected
        end
    end
end)