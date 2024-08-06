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
        Window.Theme.Is_Set = false

        Window.Reset_Position = true
        Hub.Need_Position_Reset = true
        Parse.Window.Need_Position_Reset = true
        Focus.Window.Need_Position_Reset = true
        Focus.Window.Screenshot_Need_Position_Reset = true
        Blog.Window.Need_Position_Reset = true
        Report.Window.Need_Position_Reset = true
        Config.Window.Need_Position_Reset = true
        XP.Window.Need_Position_Reset = true

        Window.Scaling_Set = false
        Hub.Scaling_Set = false
        Parse.Window.Scaling_Set = false
        Focus.Window.Scaling_Set = false
        Focus.Window.Screenshot_Scaling_Set = false
        Blog.Window.Scaling_Set = false
        Report.Window.Scaling_Set = false
        Config.Window.Scaling_Set = false
        XP.Window.Scaling_Set = false

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
-- Check for character switches. Reloads character specific Parse settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Config.Enum.File.REPORT, "settings_update", function(settings)
    if settings ~= nil then
        Metrics.Report = settings
        Settings_File.save(Config.Enum.File.REPORT)
    end
end)

------------------------------------------------------------------------------------------------------
-- Load settings when the addon is loaded.
------------------------------------------------------------------------------------------------------
ashita.events.register('load', 'load_cb', function()
    Metrics = T{
        Window = Settings_File.load(Window.Defaults, Config.Enum.File.WINDOW),
        Parse  = Settings_File.load(Parse.Config.Defaults, Config.Enum.File.PARSE),
        Focus  = Settings_File.load(Focus.Config.Defaults, Config.Enum.File.FOCUS),
        Blog   = Settings_File.load(Blog.Config.Defaults, Config.Enum.File.BLOG),
        XP     = Settings_File.load(XP.Config.Defaults, Config.Enum.File.EXP),
        Model  = Settings_File.load(DB.Defaults, Config.Enum.File.DATABASE),
        Report = Settings_File.load(Report.Config.Defaults, Config.Enum.File.REPORT),
    }

    -- Initialize Modules
    DB.Initialize()
    Parse.Initialize()
    Ashita.Party.Need_Refresh = true
    Window.IO.MouseDrawCursor = Metrics.Window.Show_Mouse

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

    if Metrics.Report.Auto_Save then
        File.Save_Data()
        File.Save_Catalog()
        File.Save_Battlelog()
    end
end)