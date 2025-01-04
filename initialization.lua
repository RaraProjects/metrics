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
Settings_File.register(Parse.File, "settings_update", function(settings)
    if settings ~= nil then
        Parse.Initialize(settings)
        Settings_File.save(Parse.File)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Focus settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Focus.File, "settings_update", function(settings)
    if settings ~= nil then
        Focus.Initialize(settings)
        Settings_File.save(Focus.File)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Battle Log settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Blog.File, "settings_update", function(settings)
    if settings ~= nil then
        Blog.Initialize(settings)
        Settings_File.save(Blog.File)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Window settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Config.Enum.File.WINDOW, "settings_update", function(settings)
    if settings ~= nil then
        Window_Manager.Settings = settings
        Window_Manager.Theme.Is_Set = false
        Window_Manager.Settings_Reset()
        Settings_File.save(Config.Enum.File.WINDOW)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific EXP settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(XP.File, "settings_update", function(settings)
    if settings ~= nil then
        XP.Initialize(settings)
        XP.Is_Initialized = false
        Settings_File.save(XP.File)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Loot settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Loot.File, "settings_update", function(settings)
    if settings ~= nil then
        Loot.Initialize(settings)
        Settings_File.save(Loot.File)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Report settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Report.File, "settings_update", function(settings)
    if settings ~= nil then
        Report.Initialize(settings)
        Settings_File.save(Report.File)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Overview settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Overview.File, "settings_update", function(settings)
    if settings ~= nil then
        Overview.Initialize(settings)
        Settings_File.save(Overview.File)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Hub settings.
------------------------------------------------------------------------------------------------------
Settings_File.register(Hub.File, "settings_update", function(settings)
    if settings ~= nil then
        Hub.Initialize(settings)
        Settings_File.save(Hub.File)
    end
end)

------------------------------------------------------------------------------------------------------
-- Load settings when the addon is loaded.
------------------------------------------------------------------------------------------------------
ashita.events.register('load', 'load_cb', function()
    Metrics = T{
        Model  = Settings_File.load(DB.Defaults, Config.Enum.File.DATABASE),
    }

    Metrics.Debug = {}
    Metrics.Debug.Visible = {false}

    -- Initialize modules. Even though a settings update will occur after this, the initialization needs
    -- to happen here to avoid running into nil settings tables in the Ashita settings cache.
    local modules = {
        XP,
        Hub,
        Blog,
        Loot,
        Parse,
        Focus,
        Config,
        Report,
        Overview,
        DB,
        Window_Manager
    }
    for _, module in ipairs(modules) do module.Initialize() end

    Ashita.Party.Need_Refresh = true

    -- Start the clock.
    Timers.Start(Timers.Enum.Names.METRICS)
    Timers.Start(Timers.Enum.Names.PARSE)
    Timers.Start(Timers.Enum.Names.AUTOPAUSE)
    Timers.Start(Timers.Enum.Names.DPS)
    Timers.Start(Timers.Enum.Names.ZONE)

    _Globals.Initialized = true
end)

------------------------------------------------------------------------------------------------------
-- Save settings when the addon is unloaded.
------------------------------------------------------------------------------------------------------
ashita.events.register('unload', 'unload_cb', function()
    Settings_File.save(Config.Enum.File.DATABASE)
    Settings_File.save(Parse.File)
    Settings_File.save(Focus.File)
    Settings_File.save(Blog.File)
    Settings_File.save(XP.File)
    Settings_File.save(Loot.File)
    Settings_File.save(Config.Enum.File.WINDOW)
    Settings_File.save(Report.File)
    Settings_File.save(Overview.File)
    Settings_File.save(Hub.File)
    Settings_File.save(Config.File)

    if Report.Settings.Auto_Save then
        File.Save_Data()
        File.Save_Battlelog()
    end
end)