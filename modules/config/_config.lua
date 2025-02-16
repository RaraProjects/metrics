Config = { }

Config.Defaults = T{
    X       = 100,
    Y       = 150,
    Visible = { false },
}

Config.ModuleFile =
{
    BLOG     = "blog",
    CONFIG   = "config",    -- Just used for Settings Mode.
    DATABASE = "database",
    EXP      = "exp",
    FOCUS    = "focus",
    HUB      = "hub",
    OVERVIEW = "overview",
    PARSE    = "parse",
    REPORT   = "report",
    WINDOW   = "window",
}

Config.Name   = "Settings"
Config.Title  = "Metrics - Help"
Config.Module = "Config"
Config.File   = "config"

Config.Section = { }
Config.Widget  = { }

Config.ActiveSettingsWindow = Config.ModuleFile.CONFIG
Config.WidthFull  = 120
Config.WidthShort = 75

------------------------------------------------------------------------------------------------------
-- Initializes the Settings screen.
------------------------------------------------------------------------------------------------------
---@param settings? table settings that come from the Ashita settings_update event.
------------------------------------------------------------------------------------------------------
Config.Initialize = function(settings)
    -- Get saved settings from file.
    Config.Settings = settings or Settings_File.load(Config.Defaults, Config.File)

    -- Create the Settings Window.
    Config.Window = Window:New
    ({
        Name       = Config.Name,
        Title      = Config.Title,
        Module     = Config.Module,
        Settings   = Config.Settings,
        Show_Title = true,
    })
end

------------------------------------------------------------------------------------------------------
-- Loads the settings data to the screen.
-- There is a single settings window that is shared between all modules.
-- Each module provides its own settings content.
------------------------------------------------------------------------------------------------------
Config.Content = function()
    local contentFunction =
    {
        [Config.ModuleFile.PARSE]  = Parse.Config.Display,
        [Config.ModuleFile.FOCUS]  = Focus.Config.Display,
        [Config.ModuleFile.BLOG]   = Blog.Config.Display,
        [Config.ModuleFile.EXP]    = XP.Config.Populate,
        [Config.ModuleFile.REPORT] = Report.Config.Display,
        [Config.ModuleFile.CONFIG] = Config.Display
    }

    local content = contentFunction[Config.ActiveSettingsWindow]

    if content and type(content) == "function" then
        content()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the Config screen.
------------------------------------------------------------------------------------------------------
Config.Display = function()
    local tabFlags = WindowManager.Tabs.Flags

    if UI.BeginTabBar("Focus Tabs", tabFlags) then
        if UI.BeginTabItem("Help", tabFlags) then
            Config.Section.TextCommands()
            UI.EndTabItem()
        end

        if UI.BeginTabItem("Focus", tabFlags) then
            Config.Section.Focus()
            UI.EndTabItem()
        end

        if UI.BeginTabItem("GUI", tabFlags) then
            WindowManager.Config.Display()
            UI.EndTabItem()
        end

        if UI.BeginTabItem("Revert", tabFlags) then
            Config.Section.Revert()
            UI.EndTabItem()
        end

        UI.EndTabBar()
    end
end

------------------------------------------------------------------------------------------------------
-- Revert and collapse setting buttons.
------------------------------------------------------------------------------------------------------
Config.Section.Revert = function()
    if UI.Button("Revert to Default Settings") then
        WindowManager.Config.Reset()
        Parse.Config.Reset()
        Focus.ResetSettings()
        Blog.Config.Reset()
        Report.Config.Reset()
        Metrics.Model.Running_Accuracy_Limit = DB.Defaults.Running_Accuracy_Limit
    end
end

------------------------------------------------------------------------------------------------------
-- Shows text commands the user can use.
------------------------------------------------------------------------------------------------------
Config.Section.TextCommands = function()
    if UI.BeginTable("Help General", 2, WindowManager.Table.Flags.Borders) then
        UI.TableSetupColumn("Col1")
        UI.TableSetupColumn("Col2")

        UI.TableNextColumn() UI.Text("GitHub")
        UI.TableNextColumn() UI.Text("https://github.com/RaraProjects/metrics")
        WindowManager.TableRowColor(1)

        UI.TableNextColumn() UI.Text("Discord")
        UI.TableNextColumn() UI.Text("https://discord.gg/u5yqUbR6R7")
        WindowManager.TableRowColor(0)

        UI.TableNextColumn() UI.Text("Version")
        UI.TableNextColumn() UI.Text(tostring(addon.version))
        WindowManager.TableRowColor(1)

        UI.TableNextColumn() UI.Text("Command")
        UI.TableNextColumn() UI.Text("/metrics or /met")
        WindowManager.TableRowColor(0)

        UI.EndTable()
    end

    if UI.CollapsingHeader("Commands: General") then
        if UI.BeginTable("General Commands", 3, WindowManager.Table.Flags.Borders) then
            UI.TableSetupColumn("Full",        Column.Flags.None, Config.WidthFull)
            UI.TableSetupColumn("Short",       Column.Flags.None, Config.WidthShort)
            UI.TableSetupColumn("Description", Column.Flags.None)
            UI.TableHeadersRow()

            UI.TableNextColumn() UI.Text("{none}")
            UI.TableNextColumn()
            UI.TableNextColumn() UI.Text("Toggles settings window.")
            WindowManager.TableRowColor(1)

            UI.TableNextColumn() UI.Text("reset")
            UI.TableNextColumn() UI.Text("r")
            UI.TableNextColumn() UI.Text("Clears the database.")
            WindowManager.TableRowColor(0)

            UI.TableNextColumn() UI.Text("show")
            UI.TableNextColumn() UI.Text("s")
            UI.TableNextColumn() UI.Text("Toggles window visibility.")
            WindowManager.TableRowColor(1)

            UI.TableNextColumn() UI.Text("percent")
            UI.TableNextColumn() UI.Text("")
            UI.TableNextColumn() UI.Text("Toggles showing numerators and denominators for percents.")
            WindowManager.TableRowColor(0)

            UI.TableNextColumn() UI.Text("mouse")
            UI.TableNextColumn() UI.Text("")
            UI.TableNextColumn() UI.Text("Toggles forcing the mouse to show over ImGui components.")
            WindowManager.TableRowColor(1)

            UI.EndTable()
        end
    end

    if UI.CollapsingHeader("Commands: Switch Tabs/Windows") then
        if UI.BeginTable("Switch Commands", 3, WindowManager.Table.Flags.Borders) then
            UI.TableSetupColumn("Full",        Column.Flags.None, Config.WidthFull)
            UI.TableSetupColumn("Short",       Column.Flags.None, Config.WidthShort)
            UI.TableSetupColumn("Description", Column.Flags.None)
            UI.TableHeadersRow()

            UI.TableNextColumn() UI.Text("parse")
            UI.TableNextColumn() UI.Text("")
            UI.TableNextColumn() UI.Text("Switch to the Parse tab.")
            WindowManager.TableRowColor(1)

            UI.TableNextColumn() UI.Text("focus")
            UI.TableNextColumn() UI.Text("")
            UI.TableNextColumn() UI.Text("Switch to the Focus tab.")
            WindowManager.TableRowColor(0)

            UI.TableNextColumn() UI.Text("log")
            UI.TableNextColumn() UI.Text("bl")
            UI.TableNextColumn() UI.Text("Switch to the Battle Log tab.")
            WindowManager.TableRowColor(1)

            UI.TableNextColumn() UI.Text("report")
            UI.TableNextColumn() UI.Text("rep")
            UI.TableNextColumn() UI.Text("Switch to the Report tab.")
            WindowManager.TableRowColor(0)

            UI.EndTable()
        end
    end

    if UI.CollapsingHeader("Commands: Parse") then
        if UI.BeginTable("Parse Commands", 3, WindowManager.Table.Flags.Borders) then
            UI.TableSetupColumn("Full",        Column.Flags.None, Config.WidthFull)
            UI.TableSetupColumn("Short",       Column.Flags.None, Config.WidthShort)
            UI.TableSetupColumn("Description", Column.Flags.None)
            UI.TableHeadersRow()

            UI.TableNextColumn() UI.Text("full")
            UI.TableNextColumn() UI.Text("f")
            UI.TableNextColumn() UI.Text("Shows Parse in full mode.")
            WindowManager.TableRowColor(1)

            UI.TableNextColumn() UI.Text("mini")
            UI.TableNextColumn() UI.Text("m")
            UI.TableNextColumn() UI.Text("Shows Parse in mini mode.")
            WindowManager.TableRowColor(0)

            UI.TableNextColumn() UI.Text("nano")
            UI.TableNextColumn() UI.Text("n")
            UI.TableNextColumn() UI.Text("Shows Parse in nano mode.")
            WindowManager.TableRowColor(1)

            UI.TableNextColumn() UI.Text("pet")
            UI.TableNextColumn() UI.Text("p")
            UI.TableNextColumn() UI.Text("Toggles pet columns in Parse (if not in Focus tab).")
            WindowManager.TableRowColor(0)

            UI.TableNextColumn() UI.Text("dps")
            UI.TableNextColumn() UI.Text("")
            UI.TableNextColumn() UI.Text("Toggles the DPS column.")
            WindowManager.TableRowColor(1)

            UI.TableNextColumn() UI.Text("speed")
            UI.TableNextColumn() UI.Text("")
            UI.TableNextColumn() UI.Text("Toggles the attack speed column.")
            WindowManager.TableRowColor(0)

            UI.TableNextColumn() UI.Text("clock")
            UI.TableNextColumn() UI.Text("c")
            UI.TableNextColumn() UI.Text("Toggles the duration timer visibility.")
            WindowManager.TableRowColor(1)

            UI.EndTable()
        end
    end

    if UI.CollapsingHeader("Commands: Focus") then
        if UI.BeginTable("Focus Commands", 3, WindowManager.Table.Flags.Borders) then
            UI.TableSetupColumn("Full",        Column.Flags.None, Config.WidthFull)
            UI.TableSetupColumn("Short",       Column.Flags.None, Config.WidthShort)
            UI.TableSetupColumn("Description", Column.Flags.None)
            UI.TableHeadersRow()

            UI.TableNextColumn() UI.Text("player {name}")
            UI.TableNextColumn() UI.Text("pl {name}")
            UI.TableNextColumn() UI.Text("Focus on a player in the Focus tab. Partial matching works.")
            WindowManager.TableRowColor(1)

            UI.TableNextColumn() UI.Text("melee")
            UI.TableNextColumn() UI.Text("")
            UI.TableNextColumn() UI.Text("Switch to Melee tab in Focus tab.")
            WindowManager.TableRowColor(0)

            UI.TableNextColumn() UI.Text("ranged")
            UI.TableNextColumn() UI.Text("")
            UI.TableNextColumn() UI.Text("Switch to Ranged tab in Focus tab.")
            WindowManager.TableRowColor(1)

            UI.TableNextColumn() UI.Text("weaponskill")
            UI.TableNextColumn() UI.Text("ws")
            UI.TableNextColumn() UI.Text("Switch to Weaponskill tab in Focus tab.")
            WindowManager.TableRowColor(0)

            UI.TableNextColumn() UI.Text("magic")
            UI.TableNextColumn() UI.Text("")
            UI.TableNextColumn() UI.Text("Switch to Magic tab in Focus tab.")
            WindowManager.TableRowColor(1)

            UI.TableNextColumn() UI.Text("ability")
            UI.TableNextColumn() UI.Text("")
            UI.TableNextColumn() UI.Text("Switch to Ability tab in Focus tab.")
            WindowManager.TableRowColor(0)

            UI.TableNextColumn() UI.Text("pet")
            UI.TableNextColumn() UI.Text("p")
            UI.TableNextColumn() UI.Text("Switch to Pet tab in Focus tab.")
            WindowManager.TableRowColor(1)

            UI.TableNextColumn() UI.Text("defense")
            UI.TableNextColumn() UI.Text("def")
            UI.TableNextColumn() UI.Text("Switch to Defense tab in Focus tab.")
            WindowManager.TableRowColor(0)

            UI.EndTable()
        end
    end

    if UI.CollapsingHeader("Commands: XP") then
        if UI.BeginTable("XP Commands", 3, WindowManager.Table.Flags.Borders) then
            UI.TableSetupColumn("Full",        Column.Flags.None, Config.WidthFull)
            UI.TableSetupColumn("Short",       Column.Flags.None, Config.WidthShort)
            UI.TableSetupColumn("Description", Column.Flags.None)
            UI.TableHeadersRow()

            UI.TableNextColumn() UI.Text("xp")
            UI.TableNextColumn() UI.Text("")
            UI.TableNextColumn() UI.Text("Toggles the XP window.")
            WindowManager.TableRowColor(1)

            UI.EndTable()
        end
    end

    if UI.CollapsingHeader("Commands: Report") then
        if UI.BeginTable("Report Commands", 3, WindowManager.Table.Flags.Borders) then
            UI.TableSetupColumn("Full",        Column.Flags.None, Config.WidthFull)
            UI.TableSetupColumn("Short",       Column.Flags.None, Config.WidthShort)
            UI.TableSetupColumn("Description", Column.Flags.None)
            UI.TableHeadersRow()

            UI.TableNextColumn() UI.Text("rep total")
            UI.TableNextColumn() UI.Text("")
            UI.TableNextColumn() UI.Text("Publishes total damage and accuracy report in chat.")
            WindowManager.TableRowColor(1)

            UI.TableNextColumn() UI.Text("rep melee")
            UI.TableNextColumn() UI.Text("")
            UI.TableNextColumn() UI.Text("Publishes melee report in chat.")
            WindowManager.TableRowColor(0)

            UI.TableNextColumn() UI.Text("rep ws")
            UI.TableNextColumn() UI.Text("")
            UI.TableNextColumn() UI.Text("Publishes weaponskill report in chat.")
            WindowManager.TableRowColor(1)

            UI.TableNextColumn() UI.Text("rep healing")
            UI.TableNextColumn() UI.Text("")
            UI.TableNextColumn() UI.Text("Publishes healing report in chat.")
            WindowManager.TableRowColor(0)

            UI.EndTable()
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the Focus screen.
------------------------------------------------------------------------------------------------------
Config.Section.Focus = function()
    local colFlags = Column.Flags.None

    UI.Text("Set max healing thresholds for overcure.")
    UI.BulletText("Otherwise Divine Seal will mess up the calculations.")
    UI.BulletText("Set each value to be about your max healing for each spell.")
    UI.BulletText("Values can also be a little more--just below Divine Seal values.")
    UI.BulletText("Curagas should be amount healed per person--not in total.")

    if UI.BeginTable("Battle Log", 2) then
        UI.TableSetupColumn("Col 1", colFlags)
        UI.TableSetupColumn("Col 2", colFlags)

        UI.TableNextColumn() Config.Widget.Healing("Cure")
        UI.TableNextColumn() Config.Widget.Healing("Curaga")
        UI.TableNextColumn() Config.Widget.Healing("Cure II")
        UI.TableNextColumn() Config.Widget.Healing("Curaga II")
        UI.TableNextColumn() Config.Widget.Healing("Cure III")
        UI.TableNextColumn() Config.Widget.Healing("Curaga III")
        UI.TableNextColumn() Config.Widget.Healing("Cure IV")
        UI.TableNextColumn() Config.Widget.Healing("Curaga IV")
        UI.TableNextColumn() Config.Widget.Healing("Cure V")
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Set the healing threshold defaults to prevent overcure with Divine Seal.
------------------------------------------------------------------------------------------------------
Config.Widget.Healing = function(spell)
    local healingThreshold = { DB.HealingMax[spell] }

    if UI.DragInt(spell, healingThreshold, 1, 0, 3000, "%d", ImGuiSliderFlags_None) then
        DB.HealingMax[spell] = healingThreshold[1]
    end
end

------------------------------------------------------------------------------------------------------
-- Allows toggling and mode switching with the UI buttons.
------------------------------------------------------------------------------------------------------
---@param settingsMode string
------------------------------------------------------------------------------------------------------
Config.ButtonToggle = function(settingsMode)
    if not settingsMode then
        return nil
    end

    if Config.Window.IsVisible() and Config.ActiveSettingsWindow == settingsMode then
        Config.Window.Hide()

    else
        Config.ActiveSettingsWindow = settingsMode
        Config.Window.Show()
    end
end