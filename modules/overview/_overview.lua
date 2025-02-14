Overview = {}

require("modules.overview.config")
require("modules.overview.parse")
require("modules.overview.focus")

Overview.Name   = "Overview"
Overview.Title  = "Metrics - Overview"
Overview.Module = "Overview"
Overview.File   = "overview"



Overview.Modes = {
    PARSE = "Parse",
    FOCUS = "Focus",
    BLOG  = "Battle Log",
}
Overview.Mode = Overview.Modes.PARSE

------------------------------------------------------------------------------------------------------
-- Initializes the Hub screen.
------------------------------------------------------------------------------------------------------
---@param settings? table settings that come from the Ashita settings_update event.
------------------------------------------------------------------------------------------------------
Overview.Initialize = function(settings)
    -- Get saved settings from file.
    Overview.Settings = settings or Settings_File.load(Overview.Config.Defaults, Overview.File)

    -- Create the Overview Window.
    Overview.Window = Window:New({
        Name     = Overview.Name,
        Title    = Overview.Title,
        Module   = Overview.Module,
        Settings = Overview.Settings,
        Show_Title = true,
    })
end

------------------------------------------------------------------------------------------------------
-- Opens a new window to show all tabs as a vertical column.
------------------------------------------------------------------------------------------------------
Overview.Content = function()
    if Overview.Mode == Overview.Modes.PARSE then
        Overview.Parse.Content()
    elseif Overview.Mode == Overview.Modes.FOCUS then
        local player_name = DB.Widgets.GetPlayerFocus()
        if player_name == DB.Enum.NONE then
            Focus.Screenshot_Mode[1] = false
            return nil
        end
        Overview.Focus.Content(player_name)
    else
        UI.Text("No content.")
    end
end

------------------------------------------------------------------------------------------------------
-- Button that opens the overview window with focus content.
------------------------------------------------------------------------------------------------------
Overview.Screenshot_Button = function()
    if UI.SmallButton("Screenshot") then
        if Overview.Mode == Overview.Modes.FOCUS then
            Overview.Window.Toggle_Visibility()
        else
            Overview.Window.Show()
            Overview.Mode = Overview.Modes.FOCUS
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Button that opens the overview window with parse content.
------------------------------------------------------------------------------------------------------
Overview.Overview_Button = function()
    if UI.SmallButton("Overview") then
        if Overview.Mode == Overview.Modes.PARSE then
            Overview.Window.Toggle_Visibility()
        else
            Overview.Window.Show()
            Overview.Mode = Overview.Modes.PARSE
        end
    end
end