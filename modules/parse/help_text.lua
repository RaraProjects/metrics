Parse.Help = { }

------------------------------------------------------------------------------------------------------
-- Shows the Horizon Mode help text.
------------------------------------------------------------------------------------------------------
Parse.Help.HorizonMode = function()
    WindowManager.Widgets.HelpMarker
    (
        "Are you playing on the Horizon server? Turn this off for retail. Horizon has some custom behavior and " ..
        "is capped at 75."
    )
end

------------------------------------------------------------------------------------------------------
-- Shows the Clock help text.
------------------------------------------------------------------------------------------------------
Parse.Help.HelpTextClock = function()
    WindowManager.Widgets.HelpMarker
    (
        "Show a timer of how long actions have been taking place."
    )
end

------------------------------------------------------------------------------------------------------
-- Shows the Skillchain Damage help text.
------------------------------------------------------------------------------------------------------
Parse.Help.HelpTextScDamage = function()
    WindowManager.Widgets.HelpMarker
    (
        "The player that closes the skill chain gets the damage credit. " ..
        "You can choose to exclude skillchain damage from the parse display. " ..
        "You won't lose any data by toggling this. There is a track where " ..
        "skillchains are included and one where they aren't. This just toggles " ..
        "between the two."
    )
end

------------------------------------------------------------------------------------------------------
-- Shows the Condensed Numbers help text.
------------------------------------------------------------------------------------------------------
Parse.Help.HelpTextCondensedNumbers = function()
    WindowManager.Widgets.HelpMarker
    (
        "1.2K instead of 1,200."
    )
end

------------------------------------------------------------------------------------------------------
-- Shows the Mask Names help text.
------------------------------------------------------------------------------------------------------
Parse.Help.HelpTextMaskNames = function()
    WindowManager.Widgets.HelpMarker
    (
        "Sometimes you want to take a screenshot but are concerned about other player's privacy. " ..
        "Use this setting to use the player's job instead of their name in name columns."
    )
end

------------------------------------------------------------------------------------------------------
-- Shows the Lurk Mode help text.
------------------------------------------------------------------------------------------------------
Parse.Help.HelpTextLurkMode = function()
    WindowManager.Widgets.HelpMarker
    (
        "!!! POSSIBLE NEGATIVE PERFORMANCE IMPACT !!!\n" ..
        "Track actions from entities outside of your party/alliance."
    )
end


------------------------------------------------------------------------------------------------------
-- Shows the Focus Jump help text.
------------------------------------------------------------------------------------------------------
Parse.Help.HelpTextFocusJump = function()
    WindowManager.Widgets.HelpMarker
    (
        "Provides a button that allows you to quickly jump to the Focus window to look into " ..
        "the specified player's stats more."
    )
end

------------------------------------------------------------------------------------------------------
-- Shows the help text for the player filter.
------------------------------------------------------------------------------------------------------
Parse.Help.TimerDurationHelpText = function()
    WindowManager.Widgets.HelpMarker
    (
        "The active timer will auto-pause after " .. tostring(Timers.Tresholds.AUTOPAUSE) ..
        " seconds of no actions. The timer will auto restart after someone affiliated with you " ..
        "(in your party or alliance) takes an action. Data collection does NOT stop while " ..
        "paused! The duration and auto-pause is to help you see how long your group has actually " ..
        "been active. \n"
    )
end