------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Database settings.
------------------------------------------------------------------------------------------------------
SettingsFile.register(Config.ModuleFile.DATABASE, 'settings_update', function(settings)
    if settings ~= nil then
        Metrics.Model = settings
        SettingsFile.save(Config.ModuleFile.DATABASE)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Parse settings.
------------------------------------------------------------------------------------------------------
SettingsFile.register(Parse.File, 'settings_update', function(settings)
    if settings ~= nil then
        Parse.Initialize(settings)
        SettingsFile.save(Parse.File)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Focus settings.
------------------------------------------------------------------------------------------------------
SettingsFile.register(Focus.File, 'settings_update', function(settings)
    if settings ~= nil then
        Focus.Initialize(settings)
        SettingsFile.save(Focus.File)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Battle Log settings.
------------------------------------------------------------------------------------------------------
SettingsFile.register(Blog.File, 'settings_update', function(settings)
    if settings ~= nil then
        Blog.Initialize(settings)
        SettingsFile.save(Blog.File)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Window settings.
------------------------------------------------------------------------------------------------------
SettingsFile.register(Config.ModuleFile.WINDOW, 'settings_update', function(settings)
    if settings ~= nil then
        WindowManager.UpdateSettingsFromLoad(settings)
        WindowManager.ResetTheme()
        WindowManager.SettingsReset()
        SettingsFile.save(Config.ModuleFile.WINDOW)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific EXP settings.
------------------------------------------------------------------------------------------------------
SettingsFile.register(XP.File, 'settings_update', function(settings)
    if settings ~= nil then
        XP.Initialize(settings)
        XP.IsInitialized = false
        SettingsFile.save(XP.File)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Loot settings.
------------------------------------------------------------------------------------------------------
SettingsFile.register(Loot.File, 'settings_update', function(settings)
    if settings ~= nil then
        Loot.Initialize(settings)
        SettingsFile.save(Loot.File)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Report settings.
------------------------------------------------------------------------------------------------------
SettingsFile.register(Report.File, 'settings_update', function(settings)
    if settings ~= nil then
        Report.Initialize(settings)
        SettingsFile.save(Report.File)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Overview settings.
------------------------------------------------------------------------------------------------------
SettingsFile.register(Overview.File, 'settings_update', function(settings)
    if settings ~= nil then
        Overview.Initialize(settings)
        SettingsFile.save(Overview.File)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific Hub settings.
------------------------------------------------------------------------------------------------------
SettingsFile.register(Hub.File, 'settings_update', function(settings)
    if settings ~= nil then
        Hub.Initialize(settings)
        SettingsFile.save(Hub.File)
    end
end)

------------------------------------------------------------------------------------------------------
-- Initialize spell trackable index for performance.
------------------------------------------------------------------------------------------------------
local InitializeSpellResources = function()
    -- Index spells once for performance.
    local spellTrackables =
    {
        [Res.Spells.MpDrain]       = DB.Trackable.SPELLS_MP_DRAIN,
        [Res.Spells.TpDrain]       = DB.Trackable.SPELLS_TP_DRAIN,
        [Res.Spells.Enspell]       = DB.Trackable.MELEE_ENSPELL,
        [Res.Spells.Spikes]        = DB.Trackable.SPELLS_SPIKE_DAMAGE,
        [Res.Spells.Healing]       = DB.Trackable.SPELLS_HEALING,
        [Res.Spells.DebuffRemoval] = DB.Trackable.SPELLS_DEBUFF_REMOVAL,
        [Res.Spells.Buffs]         = DB.Trackable.SPELLS_BUFFS,
        [Res.Spells.Enfeebling]    = DB.Trackable.SPELLS_ENFEEBLING,
        [Res.Spells.DoT]           = DB.Trackable.SPELLS_DOT,
        [Res.Spells.BuffSongs]     = DB.Trackable.SPELLS_BUFF_SONG,
        [Res.Spells.Damaging]      = DB.Trackable.SPELLS_NUKING,
    }

    for list, trackable in pairs(spellTrackables) do
        Res.Spells.MapSpellId(list, trackable)
    end

    Res.Spells.PetTrackableOverride =
    {
        [DB.Trackable.SPELLS_HEALING]    = DB.Trackable.PET_HEALING,
        [DB.Trackable.SPELLS_BUFFS]      = DB.Trackable.PET_SPELL_BUFFS,
        [DB.Trackable.SPELLS_ENFEEBLING] = DB.Trackable.PET_ENFEEBLING,
        [DB.Trackable.SPELLS_DOT]        = DB.Trackable.PET_DOT,
        [DB.Trackable.SPELLS_NUKING]     = DB.Trackable.PET_NUKING,
    }
end

------------------------------------------------------------------------------------------------------
-- Load settings when the addon is loaded.
------------------------------------------------------------------------------------------------------
ashita.events.register('load', 'load_cb', function()
    Metrics = T{
        Model  = SettingsFile.load(DB.Defaults, Config.ModuleFile.DATABASE),
    }

    Metrics.Debug = { }
    Metrics.Debug.Visible = { false }

    -- Initialize modules. Even though a settings update will occur after this, the initialization needs
    -- to happen here to avoid running into nil settings tables in the Ashita settings cache.
    local modules =
    {
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
        WindowManager,
    }

    for _, module in ipairs(modules) do
        module.Initialize()
    end

    Ashita.Party.NeedRefresh = true

    -- Start the clock.
    Timers.Start(Timers.Types.METRICS)
    Timers.Start(Timers.Types.PARSE)
    Timers.Start(Timers.Types.AUTOPAUSE)
    Timers.Start(Timers.Types.DPS)
    Timers.Start(Timers.Types.ZONE)

    InitializeSpellResources()

    DB.Data.BindGlobals()
    DB.Catalog.BindGlobals()

    _Globals.Initialized = true
end)

------------------------------------------------------------------------------------------------------
-- Save settings when the addon is unloaded.
------------------------------------------------------------------------------------------------------
ashita.events.register('unload', 'unload_cb', function()
    SettingsFile.save(Config.ModuleFile.DATABASE)
    SettingsFile.save(Parse.File)
    SettingsFile.save(Focus.File)
    SettingsFile.save(Blog.File)
    SettingsFile.save(XP.File)
    SettingsFile.save(Loot.File)
    SettingsFile.save(Config.ModuleFile.WINDOW)
    SettingsFile.save(Report.File)
    SettingsFile.save(Overview.File)
    SettingsFile.save(Hub.File)
    SettingsFile.save(Config.File)

    if Report.Settings.Auto_Save then
        File.SaveData()
        File.SaveBattlelog()
        File.SaveLoot()
    end
end)