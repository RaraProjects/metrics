Parse.Widgets = {}

------------------------------------------------------------------------------------------------------
-- Shows the parse duration clock.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Clock = function()
    if Parse.Settings.Show_Clock then
        local pause_string = ""
        if Timers.Is_Paused(Timers.Enum.Names.PARSE) then pause_string = " (||)" end
        UI.Text("Total: " .. tostring(Timers.Check(Timers.Enum.Names.METRICS)))
        UI.SameLine() UI.Text(" ") UI.SameLine()
        UI.SameLine() UI.Text("Active: " .. tostring(Timers.Check(Timers.Enum.Names.PARSE)))
        UI.SameLine() UI.Text(pause_string) Parse.Help.Timer_Duration_Help_Text()
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the settings showing for the parse window.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Settings_Button = function()
    if UI.SmallButton("Settings") then
        Config.Button_Toggle(Config.Enum.File.PARSE)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the mob filter showing for the parse window.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Filter_Button = function()
    if UI.SmallButton("Filters") then
        Parse.Settings.Show_Filter = not Parse.Settings.Show_Filter
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles player name masking.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Mask_Names = function()
    if UI.SmallButton("Mask Names") then
        Parse.Settings.Mask_Names = not Parse.Settings.Mask_Names
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the duration timer showing for the parse window.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Timer_Button = function()
    if UI.SmallButton("Timer") then
        Parse.Settings.Show_Clock = not Parse.Settings.Show_Clock
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Confirmation button showing for the parse window.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Reset_Button = function()
    if UI.SmallButton("Reset") then
        Parse.Confirmation = not Parse.Confirmation
    end
end

------------------------------------------------------------------------------------------------------
-- Confirms database reset.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Reset_Confirmation_Button = function()
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
-- Sets the running accuracy buffer limit.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Acc_Limit = function()
    local acc_limit = {[1] = Metrics.Model.Running_Accuracy_Limit}
    UI.SetNextItemWidth(Parse.Config.Slider_Width)
    if UI.DragInt("Recent Accuracy Lookback", acc_limit, 0.1, 10, 50, "%d", ImGuiSliderFlags_None) then
        Metrics.Model.Running_Accuracy_Limit = acc_limit[1]
        DB.Tracking.RunningAccuracy = {}
    end
    UI.SameLine() Window_Manager.Widgets.HelpMarker("Recent accuracy calculates based off of {X} many attack attempts.")
end

------------------------------------------------------------------------------------------------------
-- Sets how many players can be shown on the Team screen.
------------------------------------------------------------------------------------------------------
Parse.Widgets.Player_Limit = function()
    UI.SetNextItemWidth(Parse.Config.Slider_Width)
    local cutoff = {[1] = Parse.Settings.Rank_Cutoff}
    if UI.DragInt("Player Limit", cutoff, 0.1, 0, 18, "%d", ImGuiSliderFlags_None) then
        Parse.Settings.Rank_Cutoff = cutoff[1]
    end
    UI.SameLine() Window_Manager.Widgets.HelpMarker("How many players are listed on the Team table.")
end