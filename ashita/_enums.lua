Ashita.Enum = T{}


Ashita.Enum.Chat = T{
    PARTY     = "/p",
    LINKSHELL = "/l",
    SAY       = "/s",
}

Ashita.Enum.Player_Attributes = T{
    TP       = "TP",
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

-- Message IDs from incoming packet 0x029 (Action Message).
Ashita.Enum.Message = T{
    HIT        = 1,
    MOBHEAL3   = 3,
    MOB_KILL   = 6,
    MOBHEAL373 = 373,
    MISS       = 15,
    DEATH_FALL = 20,
    SHADOWS    = 31,
    DODGE      = 32,
    CRIT       = 67,
    DEATH      = 97,
    ENDRAIN    = 161,
    ENASPIR    = 162,
    RANGEPUP   = 185,
    ENSPELL    = 229,
    ENF_LAND   = 236,
    BURST      = 252,
    ENF_BURST  = 271,
    RANGEHIT   = 352,
    RANGECRIT  = 353,
    RANGEMISS  = 354,
    SQUARE     = 576,
    TRUE       = 577,
}