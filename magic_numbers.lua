-- Regular Colors
C_White        = '\\cs(255,255,255)'
C_Red          = '\\cs(255,0,0)'
C_Orange       = '\\cs(255,146,3)'
C_Red          = '\\cs(255,0,0)'
C_Green        = '\\cs(39,238,17)'
C_Yellow       = '\\cs(255,198,0)'
C_Bright_Green = '\\cs(3,252,3)'
C_Gray         = '\\cs(125,125,125)'

Ability_Filter = {
    ['Phototrophic Wrath'] = true,  -- 190
    ['Sonic Boom'] = true           -- 294
}

-- monster_ability.lua doesn't have these nodes
Mob_Ability_Filter = {
    [2954] = true,  -- Apex Cracklaw Melee
    [2955] = true,  -- Apex Cracklaw Melee
    [2956] = true,  -- Apex Cracklaw Melee
    [2959] = true,  -- Apex Cracklaw Melee
    [2960] = true,  -- Apex Cracklaw Melee
    [4166] = true,  -- Lady Lilith; Normal mode - first form ???
    [4189] = true,  -- Lady Lilith; Petaline Tempest
    [4190] = true,  -- Lady Lilith; Durance Whip
    [4191] = true,  -- Lady Lilith; Subjugating Slash
    [4192] = true,  -- Lady Lilith; Normal mode - first form ???
    [4193] = true,  -- Lady Lilith; Moonlight Veil
    [4205] = true,  -- Lady Lilith; Left handed melee with wing flare
    [4206] = true,  -- Lady Lilith; Left handed melee with reach out
    [4207] = true   -- Lady Lilith; Right handed melee with finger snap
}

Enspell_Elements = {
    [1] = {id = 1, en = "Fire"},
    [2] = {id = 2, en = "Blizzard"},
    [3] = {id = 3, en = "Aero"},
    [4] = {id = 4, en = "Stone"},
    [5] = {id = 5, en = "Water"},
    [6] = {id = 6, en = "Thunder"},
}