------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Database settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Config.Enum.File.DATABASE, "settings_update", function(settings)
    if settings ~= nil then
        Metrics.Model = settings
        Settings_File.save(Config.Enum.File.DATABASE)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Parse settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Config.Enum.File.PARSE, "settings_update", function(settings)
    if settings ~= nil then
        Metrics.Parse = settings
        Parse.Util.Calculate_Column_Flags()
        Settings_File.save(Config.Enum.File.PARSE)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Focus settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Config.Enum.File.FOCUS, "settings_update", function(settings)
    if settings ~= nil then
        Metrics.Focus = settings
        Settings_File.save(Config.Enum.File.FOCUS)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Battle Log settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Config.Enum.File.BLOG, "settings_update", function(settings)
    if settings ~= nil then
        Metrics.Blog = settings
        Settings_File.save(Config.Enum.File.BLOG)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Window settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Config.Enum.File.WINDOW, "settings_update", function(settings)
    if settings ~= nil then
        Metrics.Window = settings
        Window_Manager.Theme.Is_Set = false
        Window_Manager.Settings_Reset()
        Settings_File.save(Config.Enum.File.WINDOW)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific EXP settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Config.Enum.File.EXP, "settings_update", function(settings)
    if settings ~= nil then
        Metrics.XP = settings
        XP.Is_Initialized = false
        Settings_File.save(Config.Enum.File.EXP)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Report settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Config.Enum.File.REPORT, "settings_update", function(settings)
    if settings ~= nil then
        Metrics.Report = settings
        Settings_File.save(Config.Enum.File.REPORT)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Overview settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Config.Enum.File.OVERVIEW, "settings_update", function(settings)
    if settings ~= nil then
        Metrics.Overview = settings
        Settings_File.save(Config.Enum.File.OVERVIEW)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Hub settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Config.Enum.File.HUB, "settings_update", function(settings)
    if settings ~= nil then
        Metrics.Hub = settings
        Settings_File.save(Config.Enum.File.HUB)
    end
end)

------------------------------------------------------------------------------------------------------
-- Load settings when the addon is loaded.
------------------------------------------------------------------------------------------------------
ashita.events.register('load', 'load_cb', function()
    Metrics = T{
        Model    = Settings_File.load(DB.Defaults,                    Config.Enum.File.DATABASE),
        Window   = Settings_File.load(Window_Manager.Config.Defaults, Config.Enum.File.WINDOW),
        Parse    = Settings_File.load(Parse.Config.Defaults,          Config.Enum.File.PARSE),
        Focus    = Settings_File.load(Focus.Config.Defaults,          Config.Enum.File.FOCUS),
        Blog     = Settings_File.load(Blog.Config.Defaults,           Config.Enum.File.BLOG),
        XP       = Settings_File.load(XP.Config.Defaults,             Config.Enum.File.EXP),
        Report   = Settings_File.load(Report.Config.Defaults,         Config.Enum.File.REPORT),
        Overview = Settings_File.load(Overview.Config.Defaults,       Config.Enum.File.OVERVIEW),
        Hub      = Settings_File.load(Hub.Config.Defaults,            Config.Enum.File.HUB),
        Config   = Settings_File.load(Config.Defaults,                Config.Enum.File.CONFIG),
    }
    Metrics.Debug = T{}
    Metrics.Debug.Visible = {false}

    -- Initialize Modules
    DB.Initialize()
    Parse.Initialize()
    Ashita.Party.Need_Refresh = true
    Window_Manager.Show_Mouse_Refresh = true
    XP.Window.Set_Background(Metrics.XP.Show_Background)

    -- Start the clock.
    Timers.Start(Timers.Enum.Names.METRICS)
    Timers.Start(Timers.Enum.Names.PARSE)
    Timers.Start(Timers.Enum.Names.AUTOPAUSE)
    Timers.Start(Timers.Enum.Names.DPS)
    Timers.Start(Timers.Enum.Names.EXP)
    Timers.Start(Timers.Enum.Names.ZONE)

    _Globals.Initialized = true
end)

------------------------------------------------------------------------------------------------------
-- Save settings when the addon is unloaded.
------------------------------------------------------------------------------------------------------
ashita.events.register('unload', 'unload_cb', function ()
    Settings_File.save(Config.Enum.File.DATABASE)
    Settings_File.save(Config.Enum.File.PARSE)
    Settings_File.save(Config.Enum.File.FOCUS)
    Settings_File.save(Config.Enum.File.BLOG)
    Settings_File.save(Config.Enum.File.EXP)
    Settings_File.save(Config.Enum.File.WINDOW)
    Settings_File.save(Config.Enum.File.REPORT)
    Settings_File.save(Config.Enum.File.OVERVIEW)
    Settings_File.save(Config.Enum.File.HUB)
    Settings_File.save(Config.Enum.File.CONFIG)

    if Metrics.Report.Auto_Save then
        File.Save_Data()
        File.Save_Catalog()
        File.Save_Battlelog()
    end
end)