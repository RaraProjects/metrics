Parse.Widgets = T{}

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
-- Shows the help text for the player filter.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Timer_Duration_Help_Text = function()
    UI.SameLine() Window.Widgets.HelpMarker("The duration timer will auto-pause after " .. tostring(Timers.Tresholds.AUTOPAUSE)
                                        .. " seconds of no actions. The timer will auto restart after someone affiliated with you "
                                        .. "(in your party or alliance) takes an action. Data collection does NOT stop while "
                                        .. "paused! The duration and auto-pause is to help you see how long your group has actually "
                                        .. "been active and to help with possible DPS calculations in the future. \n")
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