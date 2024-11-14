Ashita.Enum = T{}

Ashita.Enum.Chat = T{
    PARTY      = 1,
    LINKSHELL  = 2,
    LINKSHELL2 = 3,
    SAY        = 4,
}

Ashita.Enum.Player_Attributes = T{
    TP       = "TP",
    PET_TP   = "Pet TP",
    ISZONING = "IsZoning",
}

Ashita.Enum.Targets = T{
    ME       = "me",
    TARGET   = "t",
    PET      = "pet",
}

Ashita.Enum.Spawn_Flags = T{
    MAINPLAYER  = 525,
    OTHERPLAYER = 1,
    NPC         = 2,
    IN_PARTY    = 13,
    IN_ALLIANCE = 9,
    MOB         = 16,
    TRUST       = 4366,
    PET         = 258,
}

Ashita.Enum.Ability = T{
    NORMAL        = 1,  -- Type: Normal Ability
    PETLOGISTICS  = 2,  -- Type: Fight, Heel, Stay, etc.
    BLOODPACTRAGE = 6,  -- Type:
    BLOODPACTWARD = 10, -- Type:
    PETABILITY    = 18, -- Type: Offensive BST/SMN ability.
}

-- Animation IDs from incoming packet 0x028 (Action Packet).
Ashita.Enum.Animation = T{
    MELEE_MAIN    = 0,
    MELEE_OFFHAND = 1,
    MELEE_KICK    = 2,
    MELEE_KICK2   = 3,
    DAKEN         = 4,
}

Ashita.Enum.Reaction = T{
    GUARD        = 2,
    SHIELD_BLOCK = 4,
}

Ashita.Enum.Effect_Animation = T{
    FIRE     = 1,
    ICE      = 2,
    WIND     = 3,
    EARTH    = 4,
    THUNDER  = 5,
    WATER    = 6,
    LIGHT    = 7,
    DARK     = 8,
    SLEEP    = 9,
    POISON   = 10,
    PARALYZE = 11,
    BLIND    = 12,
    SILENCE  = 13,
    STUN     = 16,
    CURSE    = 17,
    DEF_DOWN = 18,
    DRAIN    = 21,
    ASPIR    = 22,
    HASTE    = 23,
}

-- Message IDs from incoming packet 0x029 (Action Message).
Ashita.Enum.Message = T{
    HIT         = 1,
    MOBHEAL3    = 3,
    MOB_KILL    = 6,
    MOBHEAL373  = 373,
    MISS        = 15,
    DEATH_FALL  = 20,
    SHADOWS     = 31,
    DODGE       = 32,
    COUNTER     = 33,
    SPIKE_DMG   = 44,
    CRIT        = 67,
    PARRY       = 70,
    NO_EFFECT   = 75,
    RESIST      = 85,
    DEATH       = 97,
    EFFECT_FAIL = 114,
    ENDEBUFF    = 160,
    ENDRAIN     = 161,
    ENASPIR     = 162,
    ENDAMAGE    = 163,
    RANGEPUP    = 185,
    MISS_TP     = 188,
    ENSPELL     = 229,
    ENF_LAND    = 236,
    ENF_LAND_2  = 237,
    BURST       = 252,
    ENF_BURST   = 271,
    RESIST_2    = 284,
    ABSORB_STR  = 329,
    ABSORB_DEX  = 330,
    ABSORB_VIT  = 331,
    ABSORB_AGI  = 332,
    ABSORB_INT  = 333,
    ABSORB_MND  = 334,
    ABSORB_CHR  = 335,
    MAGIC_ERASE = 341,
    RANGEHIT    = 352,
    RANGECRIT   = 353,
    RANGEMISS   = 354,
    COR_BUST    = 426,
    ABSORB_TP   = 454,
    ABSORB_ACC  = 533,
    SQUARE      = 576,
    TRUE        = 577,
    COMP_RESIST = 655,
    OVERLOAD    = 799,
}