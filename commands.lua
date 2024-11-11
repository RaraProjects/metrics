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
            if Config.Settings_Mode ~= Config.Enum.File.CONFIG and Config.Window.Is_Visible() then
                Config.Settings_Mode = Config.Enum.File.CONFIG
            elseif Config.Settings_Mode ~= Config.Enum.File.CONFIG and not Config.Window.Is_Visible() then
                Config.Settings_Mode = Config.Enum.File.CONFIG
                Config.Window.Show()
            elseif Config.Settings_Mode == Config.Enum.File.CONFIG then
                Config.Window.Toggle_Visibility()
            end

        -- General Settings
        elseif arg == "show" or arg == "s" then
            Window_Manager.Toggle_Mask()
        elseif arg == "hub" then
            Hub.Window.Toggle_Visibility()
        elseif arg == "debug" then
            Debug.Toggle()
        elseif arg == "nano" or arg == "n" then
            Parse.Nano.Toggle()
        elseif arg == "mini" or arg == "m" then
            Parse.Mini.Toggle()
        elseif arg == "reset" or arg == "r" then
            DB.Initialize(true)
        elseif arg == "full" or arg == "f" then
            Parse.Full.Enable()
        elseif (arg == "pet" or arg == "p") then
            Parse.Config.Toggle_Pet()
        elseif arg == "clock" or arg == "c" then
            Parse.Config.Toggle_Clock()
        elseif arg == "percent" then
            Focus.Config.Percent_Toggle()
        elseif arg == "dps" then
            Metrics.Parse.DPS = not Metrics.Parse.DPS
            Parse.Util.Calculate_Column_Flags()
        elseif arg == "speed" then
            Metrics.Parse.Attack_Speed = not Metrics.Parse.Attack_Speed
            Parse.Util.Calculate_Column_Flags()
        elseif arg == "throttle" then
            Throttle.Toggle()
        elseif arg == "lurk" then
            Metrics.Parse.Lurk_Mode = not Metrics.Parse.Lurk_Mode
        elseif arg == "mouse" then
            Window_Manager.Toggle_Mouse()

        -- XP
        elseif arg == "xp" and sub_command then
            if sub_command == "mini" then
                Metrics.XP.XP_Mini = not Metrics.XP.XP_Mini
            end

        -- General reports.
        elseif arg == "report" or arg == "rep" then
            local report_type = command_args[3]
            if report_type == "total" then
                Report.Publishing.Total_Damage()
            elseif report_type == "acc" then
                Report.Publishing.Accuracy()
            elseif report_type == "melee" then
                Report.Publishing.Damage_By_Type(DB.Enum.Trackable.MELEE)
            elseif report_type == "ws" then
                Report.Publishing.Damage_By_Type(DB.Enum.Trackable.WS)
            elseif report_type == "healing" then
                Report.Publishing.Damage_By_Type(DB.Enum.Trackable.HEALING)
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
            Debug.Error.Add("Metrics Command: " .. tostring(arg) .. " " .. tostring(command_args[3]))
            if player_string then
                DB.Widgets.Util.Player_Switch(player_string)
            end

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