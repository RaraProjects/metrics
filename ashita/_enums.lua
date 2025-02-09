---@enum Ashita.ChatMode
Ashita.ChatMode =
{
    PARTY      = 1,
    LINKSHELL  = 2,
    LINKSHELL2 = 3,
    SAY        = 4,
}

---@enum Ashita.PlayerAttributes
Ashita.PlayerAttributes =
{
    TP        = "TP",
    PET_TP    = "Pet TP",
    IS_ZONING = "Is Zoning",
}

---@enum Ashita.TargetString
Ashita.TargetString =
{
    ME     = "me",
    TARGET = "t",
    PET    = "pet",
}

---@enum Ashita.AbilityOffset
Ashita.AbilityOffset =
{
    ABILITY = 512,
    PET     = 512,
}

---@enum Ashita.AbilityType
Ashita.AbilityType =
{
    NORMAL             = 1,
    PET_LOGISTICS      = 2,
    PET_ABILITY        = 6,     -- Rage Blood Pacts and Wyvern Breaths (damaging and healing)
    BLOOD_PACT_WARD    = 10,
    CURING_WALTZ       = 12,
    STEP               = 13,
    ANIMATING_FLOURISH = 14,
    SPECTRAL_JIG       = 16,
    BUILDING_FLOURISH  = 17,
    RUNE_ENCHANTMENT   = 21,
    SWIPE              = 23,
}

---@enum Ashita.EntityType
Ashita.EntityType =
{
    MAINPLAYER  = 525,
    OTHERPLAYER = 1,
    NPC         = 2,
    IN_PARTY    = 13,
    IN_ALLIANCE = 9,
    MOB         = 16,
    TRUST       = 4366,
    PET         = 258,
}

---@enum Ashita.AttackAnimation
Ashita.AttackAnimation =
{
    MELEE_MAIN    = 0,
    MELEE_OFFHAND = 1,
    MELEE_KICK    = 2,
    MELEE_KICK_2  = 3,
    DAKEN         = 4,
}

---@enum Ashita.AttackReaction
Ashita.AttackReaction =
{
    GUARD        = 2,
    SHIELD_BLOCK = 4,
}

---@enum Ashita.EffectAnimation
Ashita.EffectAnimation =
{
    FIRE         = 1,
    ICE          = 2,
    WIND         = 3,
    EARTH        = 4,
    THUNDER      = 5,
    WATER        = 6,
    LIGHT        = 7,
    DARK         = 8,
    SLEEP        = 9,
    POISON       = 10,
    PARALYZE     = 11,
    BLIND        = 12,
    SILENCE      = 13,
    STUN         = 16,
    CURSE        = 17,
    DEFENSE_DOWN = 18,
    DRAIN        = 21,
    ASPIR        = 22,
    HASTE        = 23,
}

---@enum Ashita.Message
Ashita.Message =
{
    MELEE_HIT                               = 1,
    SPELL_DAMAGE_HIT                        = 2,     -- Dia, Fire,
    MOB_KILL                                = 6,
    SPELL_HP_RECOVERY_PRIMARY               = 7,     -- Magic Fruit
    MELEE_MISS                              = 15,
    DEATH_FALL                              = 20,
    HP_RECOVERED                            = 24,    -- AOE recipients of healing abiility.
    IS_PARALYZED                            = 29,
    THIRD_EYE_ANTICIPATION                  = 30,
    SHADOW_ABSORPTION                       = 31,
    PERFECT_DODGE                           = 32,
    MELEE_COUNTER                           = 33,
    SPIKE_DAMAGE                            = 44,
    CRITICAL_HIT                            = 67,
    MELEE_PARRY                             = 70,
    SPELL_NO_EFFECT                         = 75,    -- Drain on undead, Dispel when there is no defbuff
    IS_PARALYZED_2                          = 84,
    SPELL_RESIST                            = 85,
    WARP                                    = 93,    -- "Vanishes"
    DEATH                                   = 97,
    ABILITY_USED                            = 100,   -- "Target uses Ability"
    ABILITY_RECOVER_HP                      = 102,   -- Chakra, Reward
    IS_INTIMIDATED                          = 106,
    ABILITY_DAMAGE_1                        = 110,   -- Shield Bash, Weapon Bash, Fire Shot, Chi Blast, Eagle Eye Shot
    SPELL_EFFECT_FAIL                       = 114,
    STEAL_SUCCESS                           = 125,
    GIL_MUG                                 = 129,
    ABILITY_REMOVE_STATUS_EFFECT_PRIMARY    = 159,   -- Geist Wall
    ENDEBUFF                                = 160,
    ENDRAIN                                 = 161,
    ENASPIR                                 = 162,
    ENDAMAGE                                = 163,
    WEAPONSKILL_DAMAGE                      = 185,   -- PUP Ranged Attack, Avatar Rage, Mob/Pet TP
    WEAPONSKILL_HP_DRAIN                    = 187,   -- Vampiric Lash
    WEAPONSKILL_MISS                        = 188,   -- Mob TP
    WEAPONSKILL_NO_EFFECT                   = 189,   -- Demonic Howl used when player has Haste buff.
    WEAPONSKILL_MP_DRAIN                    = 225,   -- Energy Steal
    WEAPONSKILL_TP_DRAIN                    = 226,   -- TP Drainkiss
    SPELL_HP_DRAIN                          = 227,   -- Drain, Blood Drain (BLU)
    SPELL_MP_DRAIN                          = 228,   -- Aspir, MP Drainkiss (BLU)
    ADDITIONAL_DAMAGE                       = 229,
    SPELL_BUFF_PRIMARY                      = 230,   -- "Target gains the effect of Buff"; Phalanx
    SPELL_ENFEEBLE_LAND                     = 236,   -- "Target is Debuff"; Slow
    SPELL_ENFEEBLE_LAND_2                   = 237,   -- "Target receives the effect of Debuff"; Burn
    ABILITY_HEALING_HP_2                    = 238,   -- Healing Ruby
    WEAPONSKILL_DEBUFF                      = 242,   -- Snatch Morsel (Colibri), Ultrasonics
    SPELL_MAGIC_BURST_PRIMARY               = 252,
    SPELL_HP_RECOVERY_ADDITIONAL            = 263,
    TAKES_DAMAGE                            = 264,   -- AOE like 1,000 needles, Cyclone, or Blizzaga
    SPELL_MAGIC_BURST_ADDITIONAL            = 265,
    SPELL_BUFF_ADDITIONAL                   = 266,
    SPELL_MAGIC_BURST_ENFEEBLE_PRIMARY      = 268,
    SPELL_MAGIC_BURST_ENFEEBLE_ADDITIONAL   = 269,
    SPELL_MAGIC_BURST_ENFEEBLE_PRIMARY_2    = 271,
    SPELL_MAGIC_BURST_ENFEEBLE_ADDITIONAL_2 = 272,
    SPELL_MAGIC_BURST_HP_DRAIN              = 274,
    SPELL_MAGIC_BURST_MP_DRAIN              = 275,
    TARGET_STATUS                           = 277,   -- AOE debuffs like Frightful Roar
    SPELL_RESIST_2                          = 284,
    ABILITY_RECOVER_HP_3                    = 306,   -- Waltz
    ABILITY_DAMAGE_2                        = 317,   -- Jump, High Jump, Wyvern Breaths
    ABILITY_RECOVER_HP_4                    = 318,   -- Wyvern Healing
    ABSORB_STR                              = 329,
    ABSORB_DEX                              = 330,
    ABSORB_VIT                              = 331,
    ABSORB_AGI                              = 332,
    ABSORB_INT                              = 333,
    ABSORB_MND                              = 334,
    ABSORB_CHR                              = 335,
    SPELL_REMOVE_STATUS_EFFECT_PRIMARY      = 341,
    SPELL_REMOVE_STATUS_EFFECT_PRIMARY_2    = 342,
    SPELL_REMOVE_STATUS_EFFECT_ADDITIONAL   = 343,
    SPELL_REMOVE_STATUS_EFFECT_ADDITIONAL_2 = 343,
    RANGE_HIT                               = 352,
    RANGE_CRITICAL_HIT                      = 353,
    RANGE_MISS                              = 354,
    ABILITY_TP_REDUCTION                    = 362,
    MOB_HEAL_MELEE                          = 373,
    ABILITY_MAGIC_BURST                     = 379,
    MOB_HEAL_RANGED                         = 382,
    MOB_HEAL_SKILLCHAIN_LIGHT               = 385,
    MOB_HEAL_SKILLCHAIN_DARK                = 386,
    MOB_HEAL_SKILLCHAIN_GRAVITATION         = 387,
    MOB_HEAL_SKILLCHAIN_FRAGMENTATION       = 388,
    MOB_HEAL_SKILLCHAIN_DISTORTION          = 389,
    MOB_HEAL_SKILLCHAIN_FUSION              = 390,
    MOB_HEAL_SKILLCHAIN_COMPRESSION         = 391,
    MOB_HEAL_SKILLCHAIN_LIQUEFACTION        = 392,
    MOB_HEAL_SKILLCHAIN_INDURATION          = 393,
    MOB_HEAL_SKILLCHAIN_REVERBERATION       = 394,
    MOB_HEAL_SKILLCHAIN_TRANSFIXION         = 395,
    MOB_HEAL_SKILLCHAIN_SCISSION            = 396,
    MOB_HEAL_SKILLCHAIN_DETONATION          = 397,
    MOB_HEAL_SKILLCHAIN_IMPACTION           = 398,
    PHANTOM_ROLL_FIRST                      = 420,
    PHANTOM_ROLL_EFFECT                     = 421,
    PHANTOM_ROLL_REROLL                     = 424,
    PHANTOM_ROLL_NO_EFFECT                  = 425,
    PHANTOM_ROLL_BUST                       = 426,
    ABSORB_TP                               = 454,
    ABSORB_ACCURACY                         = 533,
    GIL_TARGET                              = 565,
    RANGE_SQUARE_HIT                        = 576,
    RANGE_TRUESTRIKE                        = 577,
    GIL_ACTOR                               = 582,
    ABILITY_REMOVE_STATUS_EFFECT_PRIMARY_2  = 647,
    SPELL_COMPLETE_RESIST                   = 655,
    MANEUVER_NO_OVERLOAD                    = 798,
    MANEUVER_OVERLOAD                       = 799,
}