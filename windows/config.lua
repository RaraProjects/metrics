local widgets = require('windows.widgets')
local config  = { }

config.settingKeys =
{
    ALPHA                 = 'Alpha',
    SCALING               = 'Window_Scaling',
    THEME_ID              = 'Style',
    SHOW_TITLE            = 'Show_Title',
    SHOW_MOUSE            = 'Show_Mouse',
    MULTI_WINDOW          = 'Multi_Window',
    ACTIVE_WINDOW         = 'Active_Window',
    HUB_X                 = 'Hub_X',
    HUB_Y                 = 'Hub_Y',
    SCREENSHOT_X          = 'Screenshot_X',
    SCREENSHOT_Y          = 'Screenshot_Y',
    CONFIG_WINDOW_VISIBLE = 'Config_Window_Visible',
    CONFIG_X              = 'Config_X',
    CONFIG_Y              = 'Config_Y',
}

config.Defaults = T{
    Alpha                 = 1.0,
    Window_Scaling        = 1.0,
    Style                 = 0,
    Show_Title            = false,
    Show_Mouse            = false,
    Multi_Window          = false,
    Active_Window         = 'Parse',
    Hub_X                 = 100,
    Hub_Y                 = 100,
    Screenshot_X          = 100,
    Screenshot_Y          = 100,
    Config_Window_Visible = { false },
    Config_X              = 100,
    Config_Y              = 100,
}

config.settings = { }

------------------------------------------------------------------------------------------------------
-- Updates the settings table from Ashita settings_update event.
------------------------------------------------------------------------------------------------------
---@param settings table
------------------------------------------------------------------------------------------------------
config.UpdateSettingsFromLoad = function(settings)
    config.settings = settings
end

------------------------------------------------------------------------------------------------------
-- Load window manager settings.
------------------------------------------------------------------------------------------------------
config.LoadSettings = function()
    config.settings = SettingsFile.load(config.Defaults, 'window')
end

------------------------------------------------------------------------------------------------------
-- Returns a pointer to the configuration settings.
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
config.GetSettings = function()
    return config.settings
end

------------------------------------------------------------------------------------------------------
-- Returns a pointer to the configuration keys.
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
config.GetKeys = function()
    return config.settingKeys
end

------------------------------------------------------------------------------------------------------
-- Returns whether the window manager is in multi-window mode or not.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
config.IsMultiWindow = function()
    return config.settings[config.settingKeys.MULTI_WINDOW]
end

------------------------------------------------------------------------------------------------------
-- Returns the current window scaling.
------------------------------------------------------------------------------------------------------
---@return number
------------------------------------------------------------------------------------------------------
config.GetScaling = function()
    return config.settings[config.settingKeys.SCALING]
end

------------------------------------------------------------------------------------------------------
-- Returns the current window transparency.
------------------------------------------------------------------------------------------------------
---@return number
------------------------------------------------------------------------------------------------------
config.GetTransparency = function()
    return config.settings[config.settingKeys.ALPHA]
end

------------------------------------------------------------------------------------------------------
-- Should windows show titles or not.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
config.IsShowingTitles = function()
    return config.settings[config.settingKeys.SHOW_TITLE]
end

------------------------------------------------------------------------------------------------------
-- Resets visual settings in the window.
------------------------------------------------------------------------------------------------------
config.Reset = function()
    config.settings.Alpha          = config.Defaults.Alpha
    config.settings.Window_Scaling = config.Defaults.Window_Scaling
    config.settings.Show_Title     = config.Defaults.Show_Title
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the GUI.
------------------------------------------------------------------------------------------------------
config.Display = function()
    if UI.BeginTable('GUI Setings', 2) then
        -- Title Bar
        UI.TableNextColumn()
        if UI.Checkbox('Show Title Bar', {config.settings.Show_Title}) then
            config.settings.Show_Title = not config.settings.Show_Title
        end
        widgets.HelpMarker('Enables a window header that allows you to collapse the window.')

        -- Show Mouse
        UI.TableNextColumn()
        if UI.Checkbox('Show Mouse', {config.settings.Show_Mouse}) then
            WindowManager.ToggleMouse()
        end
        widgets.HelpMarker('There are a lot of click targets in Metrics. If you can\'t see your mouse when hovering over ' ..
                                   'the windows of ImGui based addons and would like to then give this a try. It will show your regular ' ..
                                   'Windows mouse on top of your regular in game cursor.')

        -- Multi Window
        UI.TableNextColumn()
        if UI.Checkbox('Multi Window', {config.settings.Multi_Window}) then
            config.settings.Multi_Window = not config.settings.Multi_Window
            if config.settings.Multi_Window then
                config.settings.Active_Window = nil
                Config.Window.Show()
            else
                config.settings.Active_Window = Config.Name
                Hub.Window.Show()
                Config.Window.Hide()
            end
        end
        widgets.HelpMarker('Have mutliple tabs open at once by enabling multiple windows. Be cautious running at ' ..
                                                'higher FPS with multiple windows open. It may affect performance.')

        UI.EndTable()
    end

    UI.Separator()
    WindowManager.ThemeSelectionContent()

    UI.Separator()

    -- Alpha
    widgets.slider(
        {
            label        = 'Window Transparence',
            settingTable = config.settings,
            settingName  = 'Alpha',
            min          = 0.2,
            max          = 1.0,
            help         = 'Adjust the window transparency.',
        }
    )

    -- Scaling
    widgets.slider(
        {
            label        = 'Window Scaling',
            settingTable = config.settings,
            settingName  = 'Window_Scaling',
            min          = 0.7,
            max          = 3.0,
            help         = 'Adjust window element size.',
        }
    )
end

local function validateSettingsKeys(defaults, keys)
    for name, key in pairs(keys) do
        if defaults[key] == nil then
            Ashita.Chat.Echo(string.format('Window Config Error! Key: %s', name))
        end
    end
end

validateSettingsKeys(config.Defaults, config.settingKeys)

return config
