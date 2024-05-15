Parse.Widgets = T{}

------------------------------------------------------------------------------------------------------
-- Shows the parse duration clock.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Clock = function()
    if Metrics.Team.Settings.Show_Clock then
        UI.SameLine() UI.Text(" ") UI.SameLine()
        local pause_string = ""
        if Timers.Is_Paused(Timers.Enum.Names.PARSE) then pause_string = " (paused)" end
        UI.Text("Duration: " .. tostring(Timers.Check("Metrics"))) UI.SameLine() UI.Text(pause_string) Parse.Widgets.Timer_Duration_Help_Text()
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the settings showing for the battle log.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Settings_Button = function()
    if UI.SmallButton("Settings") then
        Parse.Config.Show_Settings = not Parse.Config.Show_Settings
    end
end

------------------------------------------------------------------------------------------------------
-- Pauses the parse timer.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Pause = function()
    if Timers.Timers[Timers.Enum.Names.PARSE] then
        if Timers.Timers[Timers.Enum.Names.PARSE].Paused then
            if UI.SmallButton("Unpause") then
                Timers.Start(Timers.Enum.Names.PARSE)
            end
        else
            if UI.SmallButton("Pause") then
                Timers.Pause(Timers.Enum.Names.PARSE)
            end
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether skillchain damage is included in damage displays.
------------------------------------------------------------------------------------------------------
Parse.Widgets.SC_Damage = function()
    if UI.Checkbox("Include SC Damage", {Metrics.Team.Settings.Include_SC_Damage}) then
        Metrics.Team.Settings.Include_SC_Damage = not Metrics.Team.Settings.Include_SC_Damage
        Parse.Util.Calculate_Column_Flags()
    end
    UI.SameLine() Window.Widgets.HelpMarker("The player that closes the skill chain gets the damage credit. "
                                    .. "You can choose to exclude skillchain damage from the parse display. "
                                    .. "You won't lose any data by toggling this. There is a track where "
                                    .. "skillchains are included and one where they aren't. This just toggles "
                                    .. "between the two.")
end

------------------------------------------------------------------------------------------------------
-- Toggles whether or not numbers are shown in condensed format or not.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Condensed_Numbers = function()
    if UI.Checkbox("Short Numbers", {Metrics.Team.Settings.Condensed_Numbers}) then
        Metrics.Team.Settings.Condensed_Numbers = not Metrics.Team.Settings.Condensed_Numbers
        Parse.Util.Calculate_Column_Flags()
    end
    UI.SameLine() Window.Widgets.HelpMarker("1.2K instead of 1,200.")
end

------------------------------------------------------------------------------------------------------
-- Sets the running accuracy buffer limit.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Acc_Limit = function()
    local acc_limit = {[1] = Metrics.Model.Running_Accuracy_Limit}
    UI.SetNextItemWidth(Parse.Config.Slider_Width)
    if UI.DragInt("Running Accuracy Limit", acc_limit, 0.1, 10, 50, "%d", ImGuiSliderFlags_None) then
        Metrics.Model.Running_Accuracy_Limit = acc_limit[1]
        DB.Tracking.Running_Accuracy = {}
    end
    UI.SameLine() Window.Widgets.HelpMarker("Running accuracy calculates based off of {X} many attack attempts.")
end

------------------------------------------------------------------------------------------------------
-- Sets how many players can be shown on the Team screen.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Player_Limit = function()
    UI.SetNextItemWidth(Parse.Config.Slider_Width)
    local cutoff = {[1] = Metrics.Team.Settings.Rank_Cutoff}
    if UI.DragInt("Player Limit", cutoff, 0.1, 0, 18, "%d", ImGuiSliderFlags_None) then
        Metrics.Team.Settings.Rank_Cutoff = cutoff[1]
    end
    UI.SameLine() Window.Widgets.HelpMarker("How many players are listed on the Team table.")
end

------------------------------------------------------------------------------------------------------
-- Shows the help text for the player filter.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Timer_Duration_Help_Text = function()
    UI.SameLine() Window.Widgets.HelpMarker("The duration timer will auto-pause after " .. tostring(Timers.Tresholds.AUTOPAUSE)
                                        .. " seconds of no actions. The timer will auto restart after someone affiliated with you "
                                        .. "(in your party or alliance) takes an action. Data collection does NOT stop while "
                                        .. "paused! The duration and auto-pause is to help you see how long your group has actually "
                                        .. "been active and to help with possible DPS calculations in the future. \n")
end