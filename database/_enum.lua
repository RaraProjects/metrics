DB.Enum = T{}

DB.Enum.Mode = T{
    INC = "inc",
	SET = "set",
}

DB.Enum.Trackable = T{
    TOTAL               = "Total",
    TOTAL_NO_SC         = "No SC Total",
    MELEE               = "Melee",               -- Melee
    MELEE_MAIN          = "Melee Mainhand",
    MELEE_OFFHAND       = "Melee Offhand",
    MELEE_KICK          = "Melee Kicks",
    PET_MELEE           = "Pet Melee",
    PET_MELEE_DISCRETE  = "Pet Melee Discrete",
    RANGED              = "Ranged",              -- Ranged
    PET_RANGED          = "Pet Ranged",
    THROWING            = "Throwing",
    WS                  = "Weaponskills",        -- TP Action
    PET_WS              = "Pet Weaponskills",
    SC                  = "Skillchains",
    ABILITY             = "Abilities",           -- Ability
    PET                 = "Pet",                 -- Pets
    PET_ABILITY         = "Pet Ability",         
    PET_HEAL            = "Pet Healing",
    PET_NUKE            = "Pet Nuking",
    PET_ENFEEBLING      = "Pet Enfeebling",
    PET_MP_DRAIN        = "Pet MP Drain",
    PET_MAGIC           = "Pet Magic",
    MAGIC               = "Spells",              -- Magic
    ENSPELL             = "Enspell",
    ENDRAIN             = "Endrain",
    ENASPIR             = "Enaspir",
    NUKE                = "Nuking",
    HEALING             = "Healing",
    ENFEEBLE            = "Enfeebling",
    MP_DRAIN            = "MP Drain",
    OUTGOING_SPIKE_DMG  = "Outgoing Spike Damage",
    DAMAGE_TAKEN_TOTAL  = "Total Damage Taken", -- Defense
    DMG_TAKEN_TOTAL_PET = "Total Pet Damage Taken",
    MELEE_DMG_TAKEN     = "Melee Damage Taken",
    MELEE_PET_DMG_TAKEN = "Melee Pet Damage Taken",
    DEF_EVASION         = "Evasion",
    DEF_PARRY           = "Parry",
    DEF_SHADOWS         = "Shadow Absorption",
    DEF_COUNTER         = "Counter",
    DEF_GUARD           = "Guard",
    DEF_BLOCK           = "Shield Block",
    DEF_CRIT            = "Crits Taken",
    INCOMING_SPIKE_DMG  = "Incoming Spike Damage",
    SPELL_DMG_TAKEN     = "Spell Damage Taken",
    SPELL_PET_DMG_TAKEN = "Spell Pet Damage Taken",
    DEF_MP_DRAIN        = "Player MP Drained",
    DEF_ENFEEBLE        = "Player Enfeebled",
    -- SPELL_ENF_RESIST   = "Enfeeble Resist"
    TP_DMG_TAKEN        = "TP Move Damage Taken",
    PET_TP_DMG_TAKEN    = "Pet TP Move Damage Taken",
    DEATH               = "Death",               -- Misc
    DEFAULT             = "Default",
}

DB.Enum.Metric = T{
    TOTAL        = "Total",
    COUNT        = "Attempts",
    HIT_COUNT    = "Hits",
    SQUARE_COUNT = "Square Count",
    TRUE_COUNT   = "Truestrike Count",
    CRIT_COUNT   = "Crit Count",
    CRIT_DAMAGE  = "Crit Damage",
    MISS_COUNT   = "Misses",
    SHADOWS      = "Shadow Absorption",
    MOB_HEAL     = "Mob Heal",
    MIN          = "Min",
    MAX          = "Max",
    BURST_COUNT  = "Burst Count",
    BURST_DAMAGE = "Burst Damage",
    OVERCURE     = "Overcure",
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
    IGNORE      = 'ignore',
	COMBINED    = 'combined',
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
    ["Curaga II"]  = 300,	-- 213
    ["Curaga III"] = 400,
    ["Curaga IV"]  = 500,
    ["Curaga V"]   = 800,
}

DB.Healing_Max = T{
    ["Cure"]       = 50,
    ["Cure II"]    = 150,
    ["Cure III"]   = 250,
    ["Cure IV"]    = 500,
    ["Cure V"]     = 1300,
    ["Cure VI"]    = 1500,
    ["Curaga"]     = 150,
    ["Curaga II"]  = 300,
    ["Curaga III"] = 400,
    ["Curaga IV"]  = 500,
    ["Curaga V"]   = 800,
}