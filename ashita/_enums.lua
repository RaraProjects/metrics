Ashita.Enum = {}

Ashita.Enum.Chat = {
    PARTY      = 1,
    LINKSHELL  = 2,
    LINKSHELL2 = 3,
    SAY        = 4,
}

Ashita.Enum.Player_Attributes = {
    TP       = "TP",
    PET_TP   = "Pet TP",
    ISZONING = "IsZoning",
}

Ashita.Enum.Targets = {
    ME       = "me",
    TARGET   = "t",
    PET      = "pet",
}

Ashita.Enum.Ability_Offsets = {
    ABILITY = 512,
    PET  = 512,
}

Ashita.Enum.Spawn_Flags = {
    MAINPLAYER  = 525,
    OTHERPLAYER = 1,
    NPC         = 2,
    IN_PARTY    = 13,
    IN_ALLIANCE = 9,
    MOB         = 16,
    TRUST       = 4366,
    PET         = 258,
}

Ashita.Enum.Ability = {
    NORMAL        = 1,  -- Type: Normal Ability
    PETLOGISTICS  = 2,  -- Type: Fight, Heel, Stay, etc.
    BLOODPACTRAGE = 6,  -- Type:
    BLOODPACTWARD = 10, -- Type:
    PETABILITY    = 18, -- Type: Offensive BST/SMN ability.
}

-- Animation IDs from incoming packet 0x028 (Action Packet).
Ashita.Enum.Animation = {
    MELEE_MAIN    = 0,
    MELEE_OFFHAND = 1,
    MELEE_KICK    = 2,
    MELEE_KICK2   = 3,
    DAKEN         = 4,
}

Ashita.Enum.Reaction = {
    GUARD        = 2,
    SHIELD_BLOCK = 4,
}

Ashita.Enum.Effect_Animation = {
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
Ashita.Enum.Message = {
    HIT                    = 1,
    SPELL_DAMAGE_HIT       = 2,     -- Dia, Fire,
    MOBHEAL3               = 3,
    MOB_KILL               = 6,
    SPELL_HP_RECOVERY      = 7,     -- Magic Fruit
    MOBHEAL373             = 373,
    MISS                   = 15,
    DEATH_FALL             = 20,
    HP_RECOVERED           = 24,    -- AOE recipients of healing abiility.
    IS_PARALYZED           = 29,
    THIRD_EYE_ANTICIPATION = 30,
    SHADOWS                = 31,
    DODGE                  = 32,
    COUNTER                = 33,
    SPIKE_DMG              = 44,
    CRIT                   = 67,
    PARRY                  = 70,
    SPELL_NO_EFFECT        = 75,    -- Drain on undead, Dispel when there is no defbuff
    IS_PARALYZED_2         = 84,
    SPELL_RESIST           = 85,
    WARP                   = 93,    -- "Vanishes"
    DEATH                  = 97,
    ABILITY_USED           = 100,   -- "Target uses Ability"
    ABILITY_RECOVER_HP     = 102,   -- Chakra, Reward
    IS_INTIMIDATED         = 106,
    ABILITY_DAMAGE_1       = 110,   -- Shield Bash, Weapon Bash, Fire Shot, Chi Blast, Eagle Eye Shot
    EFFECT_FAIL            = 114,
    ABILITY_DISPEL         = 159,   -- Geist Wall
    ENDEBUFF               = 160,
    ENDRAIN                = 161,
    ENASPIR                = 162,
    ENDAMAGE               = 163,
    WEAPONSKILL_DAMAGE     = 185,   -- PUP Ranged Attack, Avatar Rage, Mob/Pet TP
    WEAPONSKILL_HP_DRAIN   = 187,   -- Vampiric Lash
    WEAPONSKILL_MISS       = 188,   -- Mob TP
    WEAPONSKILL_MP_DRAIN   = 225,   -- Energy Steal
    WEAPONSKILL_TP_DRAIN   = 226,   -- TP Drainkiss
    SPELL_HP_DRAIN         = 227,   -- Drain, Blood Drain (BLU)
    SPELL_MP_DRAIN         = 228,   -- Aspir, MP Drainkiss (BLU)
    ENSPELL                = 229,
    SPELL_BUFF             = 230,   -- "Target gains the effect of Buff"; Phalanx
    SPELL_ENFEEBLE_LAND    = 236,   -- "Target is Debuff"; Slow
    SPELL_ENFEEBLE_LAND_2  = 237,   -- "Target receives the effect of Debuff"; Burn
    ABILITY_HEALING_HP_2   = 238,   -- Healing Ruby
    WEAPONSKILL_DEBUFF     = 242,   -- Snatch Morsel (Colibri), Ultrasonics
    SPELL_MAGIC_BURST      = 252,
    TAKES_DAMAGE           = 264,   -- AOE like 1,000 needles, Cyclone, or BLizzaga
    ENF_BURST              = 271,
    TARGET_STATUS          = 277,   -- AOE debuffs like Frightful Roar
    SPELL_RESIST_2               = 284,
    ABILITY_RECOVER_HP_3   = 306,   -- Waltz
    ABILITY_DAMAGE_2       = 317,   -- Jump, High Jump, Wyvern Breaths
    ABILITY_RECOVER_HP_4   = 318,   -- Wyvern Healing
    ABSORB_STR             = 329,
    ABSORB_DEX             = 330,
    ABSORB_VIT             = 331,
    ABSORB_AGI             = 332,
    ABSORB_INT             = 333,
    ABSORB_MND             = 334,
    ABSORB_CHR             = 335,
    MAGIC_ERASE            = 341,
    RANGEHIT               = 352,
    RANGECRIT              = 353,
    RANGEMISS              = 354,
    ABILITY_TP_REDUCTION   = 362,
    COR_BUST               = 426,
    ABSORB_TP              = 454,
    ABSORB_ACC             = 533,
    SQUARE                 = 576,
    TRUE                   = 577,
    COMP_RESIST            = 655,
    MANEUVER_NO_OVERLOAD   = 798,
    OVERLOAD               = 799,
}