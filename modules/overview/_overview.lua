Overview = { }

require("modules.overview.config")
require("modules.overview.parse")
require("modules.overview.focus")

Overview.Name   = "Overview"
Overview.Title  = "Metrics - Overview"
Overview.Module = "Overview"
Overview.File   = "overview"

Overview.Modes =
{
    PARSE = "Parse",
    FOCUS = "Focus",
    BLOG  = "Battle Log",
}

Overview.ActiveMode = Overview.Modes.PARSE

------------------------------------------------------------------------------------------------------
-- Initializes the Hub screen.
------------------------------------------------------------------------------------------------------
---@param settings? table settings that come from the Ashita settings_update event.
------------------------------------------------------------------------------------------------------
Overview.Initialize = function(settings)
    -- Get saved settings from file.
    Overview.Settings = settings or SettingsFile.load(Overview.Config.Defaults, Overview.File)

    -- Create the Overview Window.
    Overview.Window = Window:New
    ({
        Name       = Overview.Name,
        Title      = Overview.Title,
        Module     = Overview.Module,
        Settings   = Overview.Settings,
        Show_Title = true,
    })
end

------------------------------------------------------------------------------------------------------
-- Opens a new window to show all tabs as a vertical column.
------------------------------------------------------------------------------------------------------
Overview.Content = function()
    if Overview.ActiveMode == Overview.Modes.PARSE then
        Overview.Parse.Content()

    elseif Overview.ActiveMode == Overview.Modes.FOCUS then
        local playerName = DB.Widgets.GetPlayerFocus()

        if playerName == DB.Enum.NONE then
            Focus.ScreenshotMode[1] = false
            return nil
        end

        Overview.Focus.Content(playerName)

    else
        UI.Text("No content.")
    end
end

------------------------------------------------------------------------------------------------------
-- Button that opens the overview window with focus content.
------------------------------------------------------------------------------------------------------
Overview.ScreenshotButton = function()
    if UI.SmallButton("Screenshot") then
        if Overview.ActiveMode == Overview.Modes.FOCUS then
            Overview.Window.ToggleVisibility()
        else
            Overview.Window.Show()
            Overview.ActiveMode = Overview.Modes.FOCUS
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Button that opens the overview window with parse content.
------------------------------------------------------------------------------------------------------
Overview.OverviewButton = function()
    if UI.SmallButton("Overview") then
        if Overview.ActiveMode == Overview.Modes.PARSE then
            Overview.Window.ToggleVisibility()
        else
            Overview.Window.Show()
            Overview.ActiveMode = Overview.Modes.PARSE
        end
    end
end