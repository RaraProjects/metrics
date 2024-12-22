Parse.Help = {}

------------------------------------------------------------------------------------------------------
-- Shows the Clock help text.
------------------------------------------------------------------------------------------------------
Parse.Help.Help_Text_Clock = function()
    UI.SameLine() Window_Manager.Widgets.HelpMarker(
    "Show a timer of how long actions have been taking place.")
end

------------------------------------------------------------------------------------------------------
-- Shows the Skillchain Damage help text.
------------------------------------------------------------------------------------------------------
Parse.Help.Help_Text_SC_Damage = function()
    UI.SameLine() Window_Manager.Widgets.HelpMarker(
    "The player that closes the skill chain gets the damage credit. " ..
    "You can choose to exclude skillchain damage from the parse display. " ..
    "You won't lose any data by toggling this. There is a track where " ..
    "skillchains are included and one where they aren't. This just toggles " ..
    "between the two.")
end

------------------------------------------------------------------------------------------------------
-- Shows the Condensed Numbers help text.
------------------------------------------------------------------------------------------------------
Parse.Help.Help_Text_Condensed_Numbers = function()
    UI.SameLine() Window_Manager.Widgets.HelpMarker(
    "1.2K instead of 1,200.")
end

------------------------------------------------------------------------------------------------------
-- Shows the Mask Names help text.
------------------------------------------------------------------------------------------------------
Parse.Help.Help_Text_Mask_Names = function()
    UI.SameLine() Window_Manager.Widgets.HelpMarker(
    "Sometimes you want to take a screenshot but are concerned about other player's privacy. " ..
    "Use this setting to use the player's job instead of their name in name columns.")
end

------------------------------------------------------------------------------------------------------
-- Shows the Lurk Mode help text.
------------------------------------------------------------------------------------------------------
Parse.Help.Help_Text_Lurk_Mode = function()
    UI.SameLine() Window_Manager.Widgets.HelpMarker(
    "!!! POSSIBLE NEGATIVE PERFORMANCE IMPACT !!!\n" ..
    "Track actions from entities outside of your party/alliance.")
end


------------------------------------------------------------------------------------------------------
-- Shows the Focus Jump help text.
------------------------------------------------------------------------------------------------------
Parse.Help.Help_Text_Focus_Jump = function()
    UI.SameLine() Window_Manager.Widgets.HelpMarker(
    "Provides a button that allows you to quickly jump to the Focus window to look into " ..
    "the specified player's stats more.")
end