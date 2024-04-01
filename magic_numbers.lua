-- Regular Colors
C_White        = '\\cs(255,255,255)'
C_Red          = '\\cs(255,0,0)'
C_Orange       = '\\cs(255,146,3)'
C_Red          = '\\cs(255,0,0)'
C_Green        = '\\cs(39,238,17)'
C_Yellow       = '\\cs(255,198,0)'
C_Bright_Green = '\\cs(3,252,3)'
C_Gray         = '\\cs(125,125,125)'

-- Elemental Colors
Elemental_Colors = {
    [0] = '\\cs(255,0,0)',      -- Fire
    [1] = '\\cs(0,229,255)',    -- Blizzard
    [2] = '\\cs(0,209,80)',     -- Aero
    [3] = '\\cs(156,86,0)',     -- Stone
    [4] = '\\cs(200,0,240)',    -- Thunder
    [5] = '\\cs(31,117,255)',   -- Water
    [6] = '\\cs(255,255,255)',  -- Light
    [7] = '\\cs(255,0,255)',    -- Dark
}

-- Used to cycle through party nodes with a for loop.
-- PT = {
--     [0] = 'p0',
--     [1] = 'p1',
--     [2] = 'p2',
--     [3] = 'p3',
--     [4] = 'p4',
--     [5] = 'p5',
-- }

-- PT2 = {
--     [0] = 'a10',
--     [1] = 'a11',
--     [2] = 'a12',
--     [3] = 'a13',
--     [4] = 'a14',
--     [5] = 'a15',
-- }

-- PT3 = {
--     [0] = 'a20',
--     [1] = 'a21',
--     [2] = 'a22',
--     [3] = 'a23',
--     [4] = 'a24',
--     [5] = 'a25',
-- }

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


Important_Buffs = {
    [33]  = {id = 33,  name = "Haste"},
    [39]  = {id = 39,  name = "Aquaveil",  spell_id = 55,  spell_name = "Aqualveil"},
    [40]  = {id = 40,  name = "Protect",   spell_id = 129, spell_name = "Protectra V"},
    [41]  = {id = 41,  name = "Shell",     spell_id = 134, spell_name = "Shellra V"},
    [42]  = {id = 42,  name = "Regen"},
    [43]  = {id = 43,  name = "Refresh"},
    [105] = {id = 105, name = "Barwater",  spell_id = 71,  spell_name = "Barwatera"},
    [113] = {id = 113, name = "Reraise",   spell_id = 848, spell_name = "Reraise IV"},
    [116] = {id = 116, name = "Phalanx"},
    [122] = {id = 122, name = "AGI Boost", spell_id = 482, spell_name = "Boost AGI"},
    [265] = {id = 265, name = "Flurry"},
    [275] = {id = 275, name = "Auspice",   spell_id = 96,  spell_name = "Auspice"},
    [432] = {id = 432, name = "Temper"},
    [596] = {id = 596, name = "Voidstorm"},
}

Enspell_Elements = {
    [1] = {id = 1, en = "Fire"},
    [2] = {id = 2, en = "Blizzard"},
    [3] = {id = 3, en = "Aero"},
    [4] = {id = 4, en = "Stone"},
    [5] = {id = 5, en = "Water"},
    [6] = {id = 6, en = "Thunder"},
}

Buff_Spell_List = {

}