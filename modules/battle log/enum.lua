---@enum Blog.Enum
Blog.Enum =
{
    IGNORE            = "ignore",
    MAGIC_BURST       = "BURST!",
    MISS              = "MISS!",
    MOB_DEATH         = "Defeated",
    NO_EFFECT         = "No Effect",
    NO_PET            = "No Pet",
    NOT_APPLICABLE    = "---",
    PLAYER_DEATH      = "Died",
    RESIST            = "Resist!",
    UNKNOWN           = "Unknown",
    MAX_BLOG_ENTRIES  = 100000,
    TRUNCATE_TOTAL    = 15,
    TRUNCATE_PLAYER   = 11,             -- Length needed to show the JOB##/JOB## string.
    TRUNCATE_PET      = 3,
    TRUNCATE_ACTION   = 16,
    TRUNCATE_DAMAGE   = 5,
    SLIDER_WIDTH_THRESHOLD = 100,
    SLIDER_WIDTH_PAGE      = 60,
}

-- Used for blog filtering.
---@enum Blog.ActionType
Blog.ActionType =
{
    ABILITY         = "Ability",
    ALL_HEALING     = "Healing",
    DEBUFF_REMOVAL  = "Debuff Removal",
    DISPEL          = "Dispel",
    MAGIC_OFFENSIVE = "Offensive Magic",
    MAGIC_ENFEEBLE  = "Enfeeble",
    MAGIC_MISC      = "Misc Spells",
    MELEE           = "Melee",
    MOB_DEATH       = "Mob Death",
    MOB_MELEE       = "Mob Melee",
    MOB_RANGED      = "Mob Ranged",
    MOB_TP          = "Mob TP",
    MOB_SPELL       = "Mob Spell",
    PET_COMMAND     = "Pet Command",
    PET_MELEE       = "Pet Melee",
    PET_TP          = "Pet Weaponskill",
    PHANTOM_ROLL    = "Phantom_Rolls",
    PLAYER_DEATH    = "Death",
    RANGED          = "Ranged",
    SKILLCHAIN      = "Skillchain",
    SONG_BUFFS      = "Bard Song Buffs",
    WEAPONSKILL     = "Weaponskill",
    XP              = "XP Gained",
    ZONE            = "Zone",
}