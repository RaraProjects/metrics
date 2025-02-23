Parse.Widgets = { }

------------------------------------------------------------------------------------------------------
-- Shows the parse duration clock.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Clock = function()
    if Parse.Settings.Show_Clock then
        local pauseString = ""

        if Timers.IsPaused(Timers.Types.PARSE) then
            pauseString = " (||)"
        end

        UI.Text(string.format("Total: %s", tostring(Timers.Check(Timers.Types.METRICS))))
        UI.SameLine() UI.Text(" ") UI.SameLine()
        UI.SameLine() UI.Text(string.format("Active: %s", tostring(Timers.Check(Timers.Types.PARSE))))
        UI.SameLine() UI.Text(pauseString) Parse.Help.TimerDurationHelpText()
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the settings showing for the parse window.
------------------------------------------------------------------------------------------------------
Parse.Widgets.SettingsButton = function()
    if UI.SmallButton("Settings") then
        Config.ButtonToggle(Config.ModuleFile.PARSE)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the mob filter showing for the parse window.
------------------------------------------------------------------------------------------------------
Parse.Widgets.FilterButton = function()
    if UI.SmallButton("Filters") then
        Parse.Settings.Show_Filter = not Parse.Settings.Show_Filter
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles player name masking.
------------------------------------------------------------------------------------------------------
Parse.Widgets.MaskNames = function()
    if UI.SmallButton("Mask Names") then
        Parse.Settings.Mask_Names = not Parse.Settings.Mask_Names
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the duration timer showing for the parse window.
------------------------------------------------------------------------------------------------------
Parse.Widgets.TimerButton = function()
    if UI.SmallButton("Timer") then
        Parse.Settings.Show_Clock = not Parse.Settings.Show_Clock
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Confirmation button showing for the parse window.
------------------------------------------------------------------------------------------------------
Parse.Widgets.ResetButton = function()
    if UI.SmallButton("Reset") then
        Parse.Confirmation = not Parse.Confirmation
    end
end

------------------------------------------------------------------------------------------------------
-- Confirms database reset.
------------------------------------------------------------------------------------------------------
Parse.Widgets.ResetConfirmationButton = function()
    if UI.SmallButton("I'm sure.") then
        DB.Initialize(true)
        Blog.Initialize()
        Parse.Confirmation = false
    end
end

------------------------------------------------------------------------------------------------------
-- Pauses the parse timer.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Pause = function()
    if Timers.Timers[Timers.Types.PARSE] then
        if Timers.Timers[Timers.Types.PARSE].Paused then
            if UI.SmallButton("Unpause") then
                Timers.Start(Timers.Types.PARSE)
            end
        else
            if UI.SmallButton("Pause") then
                Timers.Pause(Timers.Types.PARSE)
            end
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Sets the running accuracy buffer limit.
------------------------------------------------------------------------------------------------------
Parse.Widgets.AccLimit = function()
    local accLimit = { Metrics.Model.Running_Accuracy_Limit }

    UI.SetNextItemWidth(Parse.Config.Slider_Width)

    if UI.DragInt("Recent Accuracy Lookback", accLimit, 0.1, 10, 50, "%d", ImGuiSliderFlags_None) then
        Metrics.Model.Running_Accuracy_Limit = accLimit[1]
        DB.Tracking.RunningAccuracy = { }
    end

    WindowManager.Widgets.HelpMarker("Recent accuracy calculates based off of {X} many attack attempts.")
end

------------------------------------------------------------------------------------------------------
-- Sets how many players can be shown on the Team screen.
------------------------------------------------------------------------------------------------------
Parse.Widgets.PlayerLimit = function()
    UI.SetNextItemWidth(Parse.Config.Slider_Width)
    local cutoff = { Parse.Settings.Rank_Cutoff }

    if UI.DragInt("Player Limit", cutoff, 0.1, 0, 18, "%d", ImGuiSliderFlags_None) then
        Parse.Settings.Rank_Cutoff = cutoff[1]
    end

    WindowManager.Widgets.HelpMarker("How many players are listed on the Team table.")
end