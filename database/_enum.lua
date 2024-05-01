DB.Enum = T{}

DB.Enum.Mode = T{
    INC = "inc",
	SET = "set",
}

DB.Enum.Trackable = T{
    TOTAL              = "Total",
    TOTAL_NO_SC        = "No SC Total",
    MELEE              = "Melee",
    MELEE_MAIN         = "Melee Mainhand",
    MELEE_OFFHAND      = "Melee Offhand",
    MELEE_KICK         = "Melee Kicks",
    PET_MELEE          = "Pet Melee",
    PET_MELEE_DISCRETE = "pet_melee_discrete",
    RANGED             = "Ranged",
    PET_RANGED         = "Pet Ranged",
    THROWING           = "Throwing",
    WS                 = "Weaponskills",
    PET_WS             = "Pet Weaponskills",
    SC                 = "Skillchains",
    ABILITY            = "Abilities",
    PET_ABILITY        = "Pet Ability",
    PET_HEAL           = "Pet Healing",
    PET_NUKE           = "Pet Nuking",
    PET_ENFEEBLING     = "Pet Enfeebling",
    PET_MP_DRAIN       = "Pet MP Drain",
    PET_MAGIC          = "Pet Magic",
    MAGIC              = "Spells",
    ENSPELL            = "Enspell",
    ENDRAIN            = "Endrain",
    ENASPIR            = "Enaspir",
    NUKE               = "Nuking",
    HEALING            = "Healing",
    ENFEEBLE           = "Enfeebling",
    MP_DRAIN           = "MP Drain",
    PET                = "Pet",
    DEATH              = "Death",
    DEFAULT            = "Default",
}

DB.Enum.Metric = T{
    TOTAL        = "Total",
    COUNT        = "count",
    HIT_COUNT    = "hits",
    SQUARE_COUNT = "Square Count",
    TRUE_COUNT   = "Truestrike Count",
    CRIT_COUNT   = "crits",
    CRIT_DAMAGE  = "crit damage",
    MISS_COUNT   = "misses",
    SHADOWS      = "shadows",
    MOB_HEAL     = "mob heal",
    MIN          = "min",
    MAX          = "max",
    BURST_COUNT  = "burst count",
    BURST_DAMAGE = "burst damage",
    OVERCURE     = "overcure",
    MP_SPENT     = "MP Spent",
}

DB.Enum.Pet_Single_Trackable = T{
	PET_WS         = DB.Enum.Trackable.PET_WS,
	PET_ABILITY    = DB.Enum.Trackable.PET_ABILITY,
	PET_HEAL       = DB.Enum.Trackable.PET_HEAL,
	PET_NUKE       = DB.Enum.Trackable.PET_NUKE,
	PET_ENFEEBLING = DB.Enum.Trackable.PET_ENFEEBLING,
	PET_MP_DRAIN   = DB.Enum.Trackable.PET_MP_DRAIN,
	PET_MAGIC      = DB.Enum.Trackable.PET_MAGIC,
}

DB.Enum.Values = T{
    CATALOG     = "catalog",
	PET_CATALOG = "pet_catalog",
    DEBUG       = "Debug",
    MAX_DAMAGE  = 100000,
}

DB.Enum.HEALING = T{
    ["Cure"]       = 50,	-- 35
    ["Cure II"]    = 150, 	-- 102
    ["Cure III"]   = 250, 	-- 212
    ["Cure IV"]    = 500,	-- 430
    ["Cure V"]     = 1300,
    ["Cure VI"]    = 1500,
    ["Curaga"]     = 150,	-- 102
    ["Curaga II"]  = 400,	-- 213
    ["Curaga III"] = 800,
    ["Curaga IV"]  = 1000,
    ["Curaga V"]   = 1300,
}

DB.Healing_Max = T{
    ["Cure"]       = 50,
    ["Cure II"]    = 150,
    ["Cure III"]   = 250,
    ["Cure IV"]    = 500,
    ["Cure V"]     = 1300,
    ["Cure VI"]    = 1500,
    ["Curaga"]     = 150,
    ["Curaga II"]  = 400,
    ["Curaga III"] = 800,
    ["Curaga IV"]  = 1000,
    ["Curaga V"]   = 1300,
}