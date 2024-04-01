local l = {}

l.WS = {}
l.Ability = {}
l.Spell = {}

-- weapon_skills.lua is missing some nodes
l.WS.Missing_WS = {
    [260]  = {id = 260,  english = "Spirit Jump"},
    [293]  = {id = 293,  english = "Soul Jump"},
    [329]  = {id = 329,  english = "Intervene"},
    [3502] = {id = 3502, english = "Nott"}
}

-- Gale Axe is taken as Jump.
-- Avalance Axe is taken as High Jump.

-- Capture abilities that come in through the WS packet.
l.WS.WS_Abilities = {
    [66]   = {id = 66,   english = "Jump"},
    [67]   = {id = 67,   english = "High Jump"},
    [260]  = {id = 260,  english = "Spirit Jump"},
    [293]  = {id = 293,  english = "Soul Jump"},
}

l.WS.Skillchains = {
    [229] = 'DRG Jump Effect',
    [288] = 'Light',       [289] = 'Darkness', 
    [290] = 'Gravitation', [291] = 'Fragmentation', [292] = 'Distortion', [293] = 'Fusion',
    [294] = 'Compression', [295] = 'Liquefaction',  [296] = 'Induration', [297] = 'Reverberation', 
    [298] = 'Transfixion', [299] = 'Scission',      [300] = 'Detonation', [301] = 'Impaction',
    [385] = 'Light',       [386] = 'Darkness',
    [767] = 'Radiance',    [768] = 'Umbra'
}

l.Ability.Damaging = {
    [26]  = {id = 26,  en = "Eagle Eye Shot"},
    [28]  = {id = 28,  en = "Mijin Gakure"},
    [45]  = {id = 45,  en = "Mug"},
    [46]  = {id = 46,  en = "Shield Bash"},
    [66]  = {id = 66,  en = "Jump"},
    [67]  = {id = 67,  en = "High Jump"},
    [77]  = {id = 77,  en = "Weapon Bash"},
    [82]  = {id = 82,  en = "Chi Blast"},
    [125] = {id = 125, en = "Fire Shot"},
    [126] = {id = 126, en = "Ice Shot"},
    [127] = {id = 127, en = "Wind Shot"},
    [128] = {id = 128, en = "Earth Shot"},
    [129] = {id = 129, en = "Thunder Shot"},
    [130] = {id = 130, en = "Water Shot"},
    [131] = {id = 131, en = "Light Shot"},
    [132] = {id = 132, en = "Dark Shot"},
    [260] = {id = 260, en = "Spirit Jump"},
    [293] = {id = 293, en = "Soul Jump"},
    [344] = {id = 344, en = "Swipe"},
    [368] = {id = 368, en = "Lunge"},
}

l.Spell.Healing = {
    [1]   = {id = 1,   en = "Cure"},
    [2]   = {id = 2,   en = "Cure II"},
    [3]   = {id = 3,   en = "Cure III"},
    [4]   = {id = 4,   en = "Cure IV"},
    [5]   = {id = 5,   en = "Cure V"},
    [6]   = {id = 6,   en = "Cure VI"},
    [7]   = {id = 7,   en = "Curaga"},
    [8]   = {id = 8,   en = "Curaga II"},
    [9]   = {id = 9,   en = "Curaga III"},
    [10]  = {id = 10,  en = "Curaga IV"},
    [11]  = {id = 11,  en = "Curaga V"},
    [593] = {id = 593, en = "Magic Fruit"},
    [581] = {id = 581, en = "Healing Breeze"},
}

l.Spell.Damaging = {
    -- Light Elemental Magic
    [21]  = {id = 21,  en = "Holy"},
    [22]  = {id = 22,  en = "Holy II"},
    [28]  = {id = 28,  en = "Banish"},
    [29]  = {id = 29,  en = "Banish II"},
    [30]  = {id = 30,  en = "Banish III"},
    [31]  = {id = 31,  en = "Banish IV"},
    [32]  = {id = 32,  en = "Banish V"},
    [38]  = {id = 38,  en = "Banishga"},
    [39]  = {id = 39,  en = "Banishga II"},
    [40]  = {id = 40,  en = "Banishga III"},
    [41]  = {id = 41,  en = "Banishga IV"},
    [42]  = {id = 42,  en = "Banishga V"},

    -- Fire Elemental Magic
    [144] = {id = 144, en = "Fire"},
    [145] = {id = 145, en = "Fire II"},
    [146] = {id = 146, en = "Fire III"},
    [147] = {id = 147, en = "Fire IV"},
    [148] = {id = 148, en = "Fire V"},
    [849] = {id = 849, en = "Fire VI"},
    [174] = {id = 174, en = "Firaga"},
    [175] = {id = 175, en = "Firaga II"},
    [176] = {id = 176, en = "Firaga III"},
    [177] = {id = 177, en = "Firaga IV"},
    [178] = {id = 178, en = "Firaga V"},
    [204] = {id = 204, en = "Flare"},
    [205] = {id = 205, en = "Flare II"},
    [496] = {id = 496, en = "Firaja"},

    -- Ice Elemental Magic
    [149] = {id = 149, en = "Blizzard"},
    [150] = {id = 150, en = "Blizzard II"},
    [151] = {id = 151, en = "Blizzard III"},
    [152] = {id = 152, en = "Blizzard IV"},
    [153] = {id = 153, en = "Blizzard V"},
    [850] = {id = 850, en = "Blizzard VI"},
    [179] = {id = 179, en = "Blizzaga"},
    [180] = {id = 180, en = "Blizzaga II"},
    [181] = {id = 181, en = "Blizzaga III"},
    [182] = {id = 182, en = "Blizzaga IV"},
    [183] = {id = 183, en = "Blizzaga V"},
    [206] = {id = 206, en = "Freeze"},
    [207] = {id = 207, en = "Freeze II"},
    [497] = {id = 497, en = "Blizzaja"},

    -- Wind Elemental Magic
    [154] = {id = 154, en = "Aero"},
    [155] = {id = 155, en = "Aero II"},
    [156] = {id = 156, en = "Aero III"},
    [157] = {id = 157, en = "Aero IV"},
    [158] = {id = 158, en = "Aero V"},
    [851] = {id = 851, en = "Aero VI"},
    [184] = {id = 184, en = "Aeroga"},
    [185] = {id = 185, en = "Aeroga II"},
    [186] = {id = 186, en = "Aeroga III"},
    [187] = {id = 187, en = "Aeroga IV"},
    [188] = {id = 188, en = "Aeroga V"},
    [208] = {id = 208, en = "Tornado"},
    [209] = {id = 209, en = "Tornado II"},
    [498] = {id = 498, en = "Aeroja"},

    -- Earth Elemental Magic
    [159] = {id = 159, en = "Stone"},
    [160] = {id = 160, en = "Stone II"},
    [161] = {id = 161, en = "Stone III"},
    [162] = {id = 162, en = "Stone IV"},
    [163] = {id = 163, en = "Stone V"},
    [852] = {id = 852, en = "Stone VI"},
    [189] = {id = 189, en = "Stonega"},
    [190] = {id = 190, en = "Stonega II"},
    [191] = {id = 191, en = "Stonega III"},
    [192] = {id = 192, en = "Stonega IV"},
    [193] = {id = 193, en = "Stonega V"},
    [210] = {id = 210, en = "Quake"},
    [211] = {id = 211, en = "Quake II"},
    [499] = {id = 499, en = "Stoneja"},

    -- Thunder Elemental Magic
    [164] = {id = 164, en = "Thunder"},
    [165] = {id = 165, en = "Thunder II"},
    [166] = {id = 166, en = "Thunder III"},
    [167] = {id = 167, en = "Thunder IV"},
    [168] = {id = 168, en = "Thunder V"},
    [853] = {id = 853, en = "Thunder VI"},
    [194] = {id = 194, en = "Thundaga"},
    [195] = {id = 195, en = "Thundaga II"},
    [196] = {id = 196, en = "Thundaga III"},
    [197] = {id = 197, en = "Thundaga IV"},
    [198] = {id = 198, en = "Thundaga V"},
    [212] = {id = 212, en = "Burst"},
    [213] = {id = 213, en = "Burst II"},
    [500] = {id = 500, en = "Thundaja"},

    -- Water Elemental Magic
    [169] = {id = 169, en = "Water"},
    [170] = {id = 170, en = "Water II"},
    [171] = {id = 171, en = "Water III"},
    [172] = {id = 172, en = "Water IV"},
    [173] = {id = 173, en = "Water V"},
    [854] = {id = 854, en = "Water VI"},
    [199] = {id = 199, en = "Waterga"},
    [200] = {id = 200, en = "Waterga II"},
    [201] = {id = 201, en = "Waterga III"},
    [202] = {id = 202, en = "Waterga IV"},
    [203] = {id = 203, en = "Waterga V"},
    [214] = {id = 214, en = "Flood"},
    [215] = {id = 215, en = "Flood II"},
    [501] = {id = 501, en = "Waterja"},

    -- Dark Elemental Magic
    [245] = {id = 245, en = "Drain"},
    [246] = {id = 246, en = "Drain II"},
    [880] = {id = 880, en = "Drain III"},
    [367] = {id = 367, en = "Death"},
    [219] = {id = 219, en = "Comet"},
    [503] = {id = 503, en = "Impact"},
    [502] = {id = 502, en = "Kaustra"},

    -- Non-elemental Magic
    [218] = {id = 218, en = "Meteor"},

    -- BLU Magic
    [708] = {id = 708, en = "Subduction"},
    [720] = {id = 720, en = "Spectral Floe"},
    [721] = {id = 721, en = "Anvil Lightning"},
    [722] = {id = 722, en = "Entomb"},
    [727] = {id = 727, en = "Silent Storm"},
    [728] = {id = 728, en = "Tenebral Crush"},
    [736] = {id = 736, en = "Thunderbolt"},

    -- GEO nukes
    [828] = {id = 828, en = "Fira"},
    [829] = {id = 829, en = "Fira II"},
    [865] = {id = 865, en = "Fira III"},
    [830] = {id = 830, en = "Blizzara"},
    [831] = {id = 831, en = "Blizzara II"},
    [866] = {id = 866, en = "Blizzara III"},
    [832] = {id = 832, en = "Aera"},
    [833] = {id = 833, en = "Aera II"},
    [867] = {id = 867, en = "Aera III"},
    [834] = {id = 834, en = "Stonera"},
    [835] = {id = 835, en = "Stonera II"},
    [868] = {id = 868, en = "Stonera III"},
    [836] = {id = 836, en = "Thundara"},
    [837] = {id = 837, en = "Thundara II"},
    [869] = {id = 869, en = "Thundara III"},
    [838] = {id = 838, en = "Watera"},
    [839] = {id = 839, en = "Watera II"},
    [870] = {id = 870, en = "Watera III"},

    -- Helix
    [278] = {id = 278, en = "Geohelix"},
    [279] = {id = 279, en = "Hydrohelix"},
    [280] = {id = 280, en = "Anemohelix"},
    [281] = {id = 281, en = "Pyrohelix"},
    [282] = {id = 282, en = "Cryohelix"},
    [283] = {id = 283, en = "Ionohelix"},
    [284] = {id = 284, en = "Noctohelix"},
    [285] = {id = 285, en = "Luminohelix"},
    [885] = {id = 885, en = "Geohelix II"},
    [886] = {id = 886, en = "Hydrohelix II"},
    [887] = {id = 887, en = "Anemohelix II"},
    [888] = {id = 888, en = "Pyrohelix II"},
    [889] = {id = 889, en = "Cryohelix II"},
    [890] = {id = 890, en = "Ionohelix II"},
    [891] = {id = 891, en = "Noctohelix II"},
    [892] = {id = 892, en = "Luminohelix II"},

    -- Ninjustsu Nukes
    [320] = {id = 320, en = "Katon: Ichi"},
    [321] = {id = 321, en = "Katon: Ni"},
    [322] = {id = 322, en = "Katon: San"},
    [323] = {id = 323, en = "Hyoton: Ichi"},
    [324] = {id = 324, en = "Hyoton: Ni"},
    [325] = {id = 325, en = "Hyoton: San"},
    [326] = {id = 326, en = "Huton: Ichi"},
    [327] = {id = 327, en = "Huton: Ni"},
    [328] = {id = 328, en = "Huton: San"},
    [329] = {id = 329, en = "Doton: Ichi"},
    [330] = {id = 330, en = "Doton: Ni"},
    [331] = {id = 331, en = "Doton: San"},
    [332] = {id = 332, en = "Raiton: Ichi"},
    [333] = {id = 333, en = "Raiton: Ni"},
    [334] = {id = 334, en = "Raiton: San"},
    [335] = {id = 335, en = "Suiton: Ichi"},
    [336] = {id = 336, en = "Suiton: Ni"},
    [337] = {id = 337, en = "Suiton: San"},
}

return l