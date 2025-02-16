------------------------------------------------------------------------------------------------------
-- Subscribe to addon commands.
-- Influenced by HXUI: https://github.com/tirem/HXUI
------------------------------------------------------------------------------------------------------
ashita.events.register('command', 'command_cb', function (e)
    local command_args = e.command:lower():args()
---@diagnostic disable-next-line: undefined-field
    if table.contains({"/metrics"}, command_args[1]) or table.contains({"/met"}, command_args[1]) then
        local arg = command_args[2]
        local sub_command = command_args[3]

        -- Help Text
        if not arg then
            if Config.ActiveSettingsWindow ~= Config.ModuleFile.CONFIG and Config.Window.Is_Visible() then
                Config.ActiveSettingsWindow = Config.ModuleFile.CONFIG
            elseif Config.ActiveSettingsWindow ~= Config.ModuleFile.CONFIG and not Config.Window.Is_Visible() then
                Config.ActiveSettingsWindow = Config.ModuleFile.CONFIG
                Config.Window.Show()
            elseif Config.ActiveSettingsWindow == Config.ModuleFile.CONFIG then
                Config.Window.Toggle_Visibility()
            end

        -- General Settings
        elseif arg == "show" or arg == "s" then
            if not Window_Manager.Is_Masked() then Hub.Window.Show() end
            Window_Manager.Toggle_Mask()
        elseif arg == "hub" then
            Hub.Window.Toggle_Visibility()
        elseif arg == "debug" then
            Debug.Toggle()
        elseif arg == "nano" or arg == "n" then
            Parse.Config.Enable_Nano_Mode()
        elseif arg == "mini" or arg == "m" then
            Parse.Config.Enable_Mini_Mode()
        elseif arg == "reset" or arg == "r" then
            DB.Initialize(true)
            Blog.Initialize()
        elseif arg == "full" or arg == "f" then
            Parse.Config.Enabled_Full_Mode()
        elseif (arg == "pet" or arg == "p") then
            Parse.Config.Toggle_Pet()
        elseif arg == "clock" or arg == "c" then
            Parse.Config.Toggle_Clock()
        elseif arg == "percent" then
            Focus.Config.Percent_Toggle()
        elseif arg == "dps" then
            Parse.Config.Toggle_DPS()
        elseif arg == "speed" then
            Parse.Config.Toggle_Melee_Delay()
        elseif arg == "throttle" then
            Throttle.Toggle()
        elseif arg == "lurk" then
            Parse.Config.Toggle_Lurk_Mode()
        elseif arg == "mouse" then
            Window_Manager.Toggle_Mouse()

        -- XP
        elseif arg == "xp" and sub_command then
            if sub_command == "mini" then XP.Config.Toggle_Mini_Mode() end

        -- General reports.
        elseif arg == "report" or arg == "rep" then
            local report_type = command_args[3]
            if report_type == "total" then
                Report.Publishing.Overall()
            elseif report_type == "melee" then
                Report.Publishing.Damage_By_Type(DB.Trackable.MELEE_OVERALL)
            elseif report_type == "ws" then
                Report.Publishing.Damage_By_Type(DB.Trackable.WEAPONSKILL)
            elseif report_type == "healing" then
                Report.Publishing.Damage_By_Type(DB.Trackable.ALL_HEAL)
            end

        -- Primary module switching.
        elseif arg == "team" or arg == "parse" then Parse.Window.Make_Active()
        elseif arg == "focus" then                  Focus.Window.Make_Active()
        elseif arg == "log" or arg == "bl" then     Blog.Window.Make_Active()
        elseif arg == "xp" then                     XP.Window.Make_Active()
        elseif arg == "report" or arg == "rep" then Report.Window.Make_Active()

        -- Player selection
        elseif arg == "player" or arg == "pl" then
            local player_string = command_args[3]
            if player_string then DB.Widgets.PlayerSwitch(player_string) end

        -- Focus tab switching.
        elseif arg == "melee" then
            Focus.Tabs.Switch[Focus.Tabs.Names.MELEE] = ImGuiTabItemFlags_SetSelected
        elseif arg == "ranged" then
            Focus.Tabs.Switch[Focus.Tabs.Names.RANGED] = ImGuiTabItemFlags_SetSelected
        elseif arg == "ws" or arg == "weaponskill" then
            Focus.Tabs.Switch[Focus.Tabs.Names.WS] = ImGuiTabItemFlags_SetSelected
        elseif arg == "magic" then
            Focus.Tabs.Switch[Focus.Tabs.Names.MAGIC] = ImGuiTabItemFlags_SetSelected
        elseif arg == "ability" or arg == "abil" then
            Focus.Tabs.Switch[Focus.Tabs.Names.ABILITIES] = ImGuiTabItemFlags_SetSelected
        elseif (arg == "pet" or arg == "p") and Window_Manager.Tabs.Active == Focus.Name then
            Focus.Tabs.Switch[Focus.Tabs.Names.PETS] = ImGuiTabItemFlags_SetSelected
        elseif arg == "defense" or arg == "def" then
            Focus.Tabs.Switch[Focus.Tabs.Names.DEFENSE] = ImGuiTabItemFlags_SetSelected
        end
    end
end)