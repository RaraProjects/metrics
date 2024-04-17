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

-- Capture abilities that come in through the WS packet.
l.WS.WS_Abilities = {
    [26]   = {id = 26,   english = "Eagle Eye Shot"},
    [41]   = {id = 41,   english = "Steal"},
    [45]   = {id = 45,   english = "Mug"},
    [46]   = {id = 46,   english = "Shield Bash"},
    [57]   = {id = 57,   english = "Shadowbind"},
    [66]   = {id = 66,   english = "Jump"},
    [67]   = {id = 67,   english = "High Jump"},
    [68]   = {id = 68,   english = "Super Jump"},
    [77]   = {id = 77,   english = "Weapon Bash"},
    [228]  = {id = 228,  english = "Despoil"},
    [260]  = {id = 260,  english = "Spirit Jump"},
    [293]  = {id = 293,  english = "Soul Jump"},
    [329]  = {id = 329,  english = "Intervene"},
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
    [538] = {id = 538, old_id = 26,  en = "Eagle Eye Shot"},
    [540] = {id = 540, old_id = 28,  en = "Mijin Gakure"},
    [558] = {id = 558, old_id = 46,  en = "Shield Bash"},
    [578] = {id = 578, old_id = 66,  en = "Jump"},
    [579] = {id = 579, old_id = 67,  en = "High Jump"},
    [580] = {id = 579, old_id = 68,  en = "Super Jump"},
    [589] = {id = 589, old_id = 77,  en = "Weapon Bash"},
    [594] = {id = 594, old_id = 82,  en = "Chi Blast"},
    [637] = {id = 637, old_id = 125, en = "Fire Shot"},
    [638] = {id = 638, old_id = 126, en = "Ice Shot"},
    [639] = {id = 639, old_id = 127, en = "Wind Shot"},
    [640] = {id = 640, old_id = 128, en = "Earth Shot"},
    [641] = {id = 641, old_id = 129, en = "Thunder Shot"},
    [642] = {id = 642, old_id = 130, en = "Water Shot"},
    -- [643] = {id = 643, old_id = 131, en = "Light Shot"}, -- Doesn't actually do any damage.
    -- [644] = {id = 644, old_id = 132, en = "Dark Shot"},  -- Doesn't actually do any damage.
    [772] = {id = 772, old_id = 260, en = "Spirit Jump"},
    [805] = {id = 805, old_id = 293, en = "Soul Jump"},
    [841] = {id = 841              , en = "Intervene"}
}

l.Ability.Wyvern_Breath = {
    [646] = {id=900,en="Flame Breath",ja="フレイムブレス"},
    [647] = {id=901,en="Frost Breath",ja="フロストブレス"},
    [648] = {id=902,en="Gust Breath",ja="ガストブレス"},
    [649] = {id=903,en="Sand Breath",ja="サンドブレス"},
    [650] = {id=904,en="Lightning Breath",ja="ライトニングブレス"},
    [651] = {id=905,en="Hydro Breath",ja="ハイドロブレス"},
}

l.Ability.Wyvern_Healing = {
    [639] = {id=639,en="Healing Breath IV"},
    [640] = {id=894,en="Healing Breath",ja="ヒールブレス"},
    [641] = {id=895,en="Healing Breath II",ja="ヒールブレスII"},
    [642] = {id=896,en="Healing Breath III",ja="ヒールブレスIII"},
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
    [230] = {id = 230, en = "Bio"},
    [231] = {id = 231, en = "Bio II"},
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

l.Ability.Ward = {
    -- Fenrir
    [833] = {id=530,en="Lunar Cry",ja="ルナークライ",element=7,icon_id=341,mp_cost=41,prefix="/pet",range=9,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
    [834] = {id=532,en="Ecliptic Growl",ja="上弦の唸り",duration=180,element=7,icon_id=341,mp_cost=46,prefix="/pet",range=12,recast_id=174,targets=1,tp_cost=0,type="BloodPactWard"},
    [835] = {id=531,en="Lunar Roar",ja="ルナーロア",element=7,icon_id=341,mp_cost=27,prefix="/pet",range=4,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
    [837] = {id=533,en="Ecliptic Howl",ja="下弦の咆哮",duration=180,element=7,icon_id=341,mp_cost=57,prefix="/pet",range=12,recast_id=174,targets=1,tp_cost=0,type="BloodPactWard"},
    -- Ifrit
    [844] = {id=548,en="Crimson Howl",ja="紅蓮の咆哮",duration=60,element=0,icon_id=342,mp_cost=84,prefix="/pet",range=12,recast_id=174,status=68,targets=1,tp_cost=0,type="BloodPactWard"},
    -- Titan
    [853] = {id=564,en="Earthen Ward",ja="大地の守り",duration=900,element=3,icon_id=343,mp_cost=92,prefix="/pet",range=12,recast_id=174,status=37,targets=1,tp_cost=0,type="BloodPactWard"},
    -- Leviathan
    [861] = {id=579,en="Spring Water",ja="湧水",element=5,icon_id=344,mp_cost=99,prefix="/pet",range=12,recast_id=174,targets=1,tp_cost=0,type="BloodPactWard"},
    [862] = {id=580,en="Slowga",ja="スロウガ",element=5,icon_id=344,mp_cost=48,prefix="/pet",range=4,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
    -- Garuda
    [869] = {id=594,en="Whispering Wind",ja="風の囁き",element=2,icon_id=345,mp_cost=119,prefix="/pet",range=12,recast_id=174,targets=1,tp_cost=0,type="BloodPactWard"},
    [870] = {id=595,en="Hastega",ja="ヘイスガ",duration=180,element=2,icon_id=345,mp_cost=129,prefix="/pet",range=12,recast_id=174,status=33,targets=1,tp_cost=0,type="BloodPactWard"},
    [871] = {id=596,en="Aerial Armor",ja="真空の鎧",duration=900,element=2,icon_id=345,mp_cost=92,prefix="/pet",range=12,recast_id=174,status=36,targets=1,tp_cost=0,type="BloodPactWard"},
    -- Shiva
    [878] = {id=610,en="Frost Armor",ja="凍てつく鎧",duration=180,element=1,icon_id=346,mp_cost=63,prefix="/pet",range=12,recast_id=174,status=35,targets=1,tp_cost=0,type="BloodPactWard"},
    [879] = {id=611,en="Sleepga",ja="スリプガ",element=1,icon_id=346,mp_cost=54,prefix="/pet",range=4,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
    -- Ramuh
    [887] = {id=626,en="Rolling Thunder",ja="雷鼓",duration=120,element=4,icon_id=347,mp_cost=52,prefix="/pet",range=12,recast_id=174,status=98,targets=1,tp_cost=0,type="BloodPactWard"},
    [889] = {id=628,en="Lightning Armor",ja="雷電の鎧",duration=180,element=4,icon_id=347,mp_cost=91,prefix="/pet",range=12,recast_id=174,status=38,targets=1,tp_cost=0,type="BloodPactWard"},
    -- Carbuncle
    [906] = {id=512,en="Healing Ruby",ja="ルビーの癒し",element=6,icon_id=340,mp_cost=6,prefix="/pet",range=12,recast_id=174,targets=5,tp_cost=0,type="BloodPactWard"},
    [908] = {id=514,en="Shining Ruby",ja="ルビーの輝き",duration=180,element=6,icon_id=340,mp_cost=44,prefix="/pet",range=12,recast_id=174,status=154,targets=1,tp_cost=0,type="BloodPactWard"},
    [909] = {id=515,en="Glittering Ruby",ja="ルビーの煌き",element=6,icon_id=340,mp_cost=62,prefix="/pet",range=12,recast_id=174,targets=1,tp_cost=0,type="BloodPactWard"},
    [911] = {id=517,en="Healing Ruby II",ja="ルビーの癒しII",element=6,icon_id=340,mp_cost=124,prefix="/pet",range=12,recast_id=174,targets=1,tp_cost=0,type="BloodPactWard"},
    -- Diabolos
    [1904] = {id=657,en="Somnolence",ja="ソムノレンス",element=7,icon_id=348,mp_cost=30,prefix="/pet",range=4,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
    [1905] = {id=660,en="Noctoshield",ja="ノクトシールド",duration=180,element=7,icon_id=348,mp_cost=92,prefix="/pet",range=12,recast_id=174,status=116,targets=1,tp_cost=0,type="BloodPactWard"},
    [1906] = {id=659,en="Ultimate Terror",ja="アルティメットテラー",element=7,icon_id=348,mp_cost=27,prefix="/pet",range=4,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
    [1907] = {id=661,en="Dream Shroud",ja="ドリームシュラウド",duration=180,element=7,icon_id=348,mp_cost=121,prefix="/pet",range=12,recast_id=174,status=190,targets=1,tp_cost=0,type="BloodPactWard"},
    [1908] = {id=658,en="Nightmare",ja="ナイトメア",element=7,icon_id=348,mp_cost=42,prefix="/pet",range=4,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
}

l.Ability.Avatar_Healing = {
    -- Leviathan
    [861] = {id=579,en="Spring Water",ja="湧水",element=5,icon_id=344,mp_cost=99,prefix="/pet",range=12,recast_id=174,targets=1,tp_cost=0,type="BloodPactWard"},
    -- Garuda
    [869] = {id=594,en="Whispering Wind",ja="風の囁き",element=2,icon_id=345,mp_cost=119,prefix="/pet",range=12,recast_id=174,targets=1,tp_cost=0,type="BloodPactWard"},
    -- Carbuncle
    [906] = {id=512,en="Healing Ruby",ja="ルビーの癒し",element=6,icon_id=340,mp_cost=6,prefix="/pet",range=12,recast_id=174,targets=5,tp_cost=0,type="BloodPactWard"},
    [911] = {id=517,en="Healing Ruby II",ja="ルビーの癒しII",element=6,icon_id=340,mp_cost=124,prefix="/pet",range=12,recast_id=174,targets=1,tp_cost=0,type="BloodPactWard"},
}

l.Ability.Rage = {
    -- Fenrir
    [831] = {id=528,en="Moonlit Charge",ja="ムーンリットチャージ",element=7,icon_id=341,mp_cost=17,prefix="/pet",range=2,recast_id=173,skillchain_a="Compression",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [832] = {id=529,en="Crescent Fang",ja="クレセントファング",element=7,icon_id=341,mp_cost=19,prefix="/pet",range=2,recast_id=173,skillchain_a="Transfixion",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [836] = {id=534,en="Eclipse Bite",ja="エクリプスバイト",element=7,icon_id=341,mp_cost=109,prefix="/pet",range=2,recast_id=173,skillchain_a="Gravitation",skillchain_b="Scission",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [838] = {id=536,en="Howling Moon",ja="ハウリングムーン",element=7,icon_id=341,mp_cost=0,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [839] = {id=839,en="UNK Avatar Ability 839"},
    -- Fenrir
    [840] = {id=544,en="Punch",ja="パンチ",element=0,icon_id=342,mp_cost=9,prefix="/pet",range=2,recast_id=173,skillchain_a="Liquefaction",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [841] = {id=545,en="Fire II",ja="ファイアII",element=0,icon_id=342,mp_cost=24,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [842] = {id=546,en="Burning Strike",ja="バーニングストライク",element=0,icon_id=342,mp_cost=48,prefix="/pet",range=2,recast_id=173,skillchain_a="Impaction",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [843] = {id=547,en="Double Punch",ja="ダブルパンチ",element=0,icon_id=342,mp_cost=56,prefix="/pet",range=2,recast_id=173,skillchain_a="Compression",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [845] = {id=549,en="Fire IV",ja="ファイアIV",element=0,icon_id=342,mp_cost=118,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [846] = {id=550,en="Flaming Crush",ja="フレイムクラッシュ",element=0,icon_id=342,mp_cost=164,prefix="/pet",range=2,recast_id=173,skillchain_a="Fusion",skillchain_b="Reverberation",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [847] = {id=847,en="UNK Avatar Ability 847"},
    [848] = {id=552,en="Inferno",ja="インフェルノ",element=0,icon_id=342,mp_cost=0,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    -- Titan
    [849] = {id=560,en="Rock Throw",ja="ロックスロー",element=3,icon_id=343,mp_cost=10,prefix="/pet",range=9,recast_id=173,skillchain_a="Scission",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [850] = {id=561,en="Stone II",ja="ストーンII",element=3,icon_id=343,mp_cost=24,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [851] = {id=562,en="Rock Buster",ja="ロックバスター",element=3,icon_id=343,mp_cost=39,prefix="/pet",range=2,recast_id=173,skillchain_a="Reverberation",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [852] = {id=563,en="Megalith Throw",ja="メガリススロー",element=3,icon_id=343,mp_cost=62,prefix="/pet",range=9,recast_id=173,skillchain_a="Induration",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [854] = {id=565,en="Stone IV",ja="ストーンIV",element=3,icon_id=343,mp_cost=118,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [855] = {id=566,en="Mountain Buster",ja="マウンテンバスター",element=3,icon_id=343,mp_cost=164,prefix="/pet",range=2,recast_id=173,skillchain_a="Gravitation",skillchain_b="Induration",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [856] = {id=856,en="UNK Avatar Ability 856"},
    [857] = {id=568,en="Earthen Fury",ja="アースフューリー",element=3,icon_id=343,mp_cost=0,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    -- Leviathan
    [858] = {id=576,en="Barracuda Dive",ja="バラクーダダイブ",element=5,icon_id=344,mp_cost=8,prefix="/pet",range=2,recast_id=173,skillchain_a="Reverberation",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [859] = {id=577,en="Water II",ja="ウォータII",element=5,icon_id=344,mp_cost=24,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [860] = {id=578,en="Tail Whip",ja="テールウィップ",element=5,icon_id=344,mp_cost=49,prefix="/pet",range=2,recast_id=173,skillchain_a="Detonation",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [863] = {id=581,en="Water IV",ja="ウォータIV",element=5,icon_id=344,mp_cost=118,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [864] = {id=582,en="Spinning Dive",ja="スピニングダイブ",element=5,icon_id=344,mp_cost=164,prefix="/pet",range=2,recast_id=173,skillchain_a="Distortion",skillchain_b="Detonation",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [865] = {id=865,en="UNK Avatar Ability 865"},
    [866] = {id=584,en="Tidal Wave",ja="タイダルウェイブ",element=5,icon_id=344,mp_cost=0,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    -- Garuda
    [867] = {id=592,en="Claw",ja="クロー",element=2,icon_id=345,mp_cost=7,prefix="/pet",range=2,recast_id=173,skillchain_a="Detonation",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [868] = {id=593,en="Aero II",ja="エアロII",element=2,icon_id=345,mp_cost=24,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [872] = {id=597,en="Aero IV",ja="エアロIV",element=2,icon_id=345,mp_cost=118,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [873] = {id=598,en="Predator Claws",ja="プレデタークロー",element=2,icon_id=345,mp_cost=164,prefix="/pet",range=2,recast_id=173,skillchain_a="Fragmentation",skillchain_b="Scission",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [874] = {id=874,en="UNK Avatar Ability 874"},
    [875] = {id=600,en="Aerial Blast",ja="エリアルブラスト",element=2,icon_id=345,mp_cost=0,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    -- Shiva
    [876] = {id=608,en="Axe Kick",ja="アクスキック",element=1,icon_id=346,mp_cost=10,prefix="/pet",range=2,recast_id=173,skillchain_a="Induration",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [877] = {id=609,en="Blizzard II",ja="ブリザドII",element=1,icon_id=346,mp_cost=24,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [880] = {id=612,en="Double Slap",ja="ダブルスラップ",element=1,icon_id=346,mp_cost=96,prefix="/pet",range=2,recast_id=173,skillchain_a="Scission",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [881] = {id=613,en="Blizzard IV",ja="ブリザドIV",element=1,icon_id=346,mp_cost=118,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [882] = {id=614,en="Rush",ja="ラッシュ",element=1,icon_id=346,mp_cost=164,prefix="/pet",range=2,recast_id=173,skillchain_a="Distortion",skillchain_b="Scission",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [883] = {id=883,en="UNK Avatar Ability 883"},
    [884] = {id=616,en="Diamond Dust",ja="ダイヤモンドダスト",element=1,icon_id=346,mp_cost=0,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    -- Ramuh
    [885] = {id=624,en="Shock Strike",ja="ショックストライク",element=4,icon_id=347,mp_cost=6,prefix="/pet",range=2,recast_id=173,skillchain_a="Impaction",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [886] = {id=625,en="Thunder II",ja="サンダーII",element=4,icon_id=347,mp_cost=24,prefix="/pet",range=8,recast_id=173,targets=32,tp_cost=0,type="BloodPactRage"},
    [888] = {id=627,en="Thunderspark",ja="サンダースパーク",element=4,icon_id=347,mp_cost=38,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [890] = {id=629,en="Thunder IV",ja="サンダーIV",element=4,icon_id=347,mp_cost=118,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [891] = {id=630,en="Chaotic Strike",ja="カオスストライク",element=4,icon_id=347,mp_cost=164,prefix="/pet",range=2,recast_id=173,skillchain_a="Fragmentation",skillchain_b="Transfixion",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [892] = {id=892,en="UNK Avatar Ability 892"},
    [893] = {id=632,en="Judgment Bolt",ja="ジャッジボルト",element=4,icon_id=347,mp_cost=0,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    -- Carbuncle
    [907] = {id=513,en="Poison Nails",ja="ポイズンネイル",element=6,icon_id=340,mp_cost=11,prefix="/pet",range=2,recast_id=173,skillchain_a="Transfixion",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [910] = {id=516,en="Meteorite",ja="プチメテオ",element=6,icon_id=340,mp_cost=108,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [912] = {id=518,en="Searing Light",ja="シアリングライト",element=6,icon_id=340,mp_cost=0,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    -- Cait Sith
    -- [519] = {id=519,en="Holy Mist",ja="ホーリーミスト",element=6,icon_id=340,mp_cost=152,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    -- [520] = {id=520,en="Soothing Ruby",ja="ルビーの安らぎ",element=6,icon_id=340,mp_cost=74,prefix="/pet",range=12,recast_id=174,targets=1,tp_cost=0,type="BloodPactWard"},
    -- [521] = {id=521,en="Regal Scratch",ja="リーガルスクラッチ",element=6,icon_id=351,mp_cost=5,prefix="/pet",range=2,recast_id=173,skillchain_a="Scission",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    -- [522] = {id=522,en="Mewing Lullaby",ja="ミュインララバイ",element=6,icon_id=351,mp_cost=61,prefix="/pet",range=4,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
    -- [523] = {id=523,en="Eerie Eye",ja="イアリーアイ",element=6,icon_id=351,mp_cost=134,prefix="/pet",range=2,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
    -- [524] = {id=524,en="Level ? Holy",ja="レベル？ホーリー",element=6,icon_id=351,mp_cost=235,prefix="/pet",range=9,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    -- [525] = {id=525,en="Raise II",ja="レイズII",element=6,icon_id=351,mp_cost=160,prefix="/pet",range=12,recast_id=174,targets=5,tp_cost=0,type="BloodPactWard"},
    -- [526] = {id=526,en="Reraise II",ja="リレイズII",duration=3600,element=6,icon_id=351,mp_cost=80,prefix="/pet",range=12,recast_id=174,status=113,targets=5,tp_cost=0,type="BloodPactWard"},
    -- [527] = {id=527,en="Altana's Favor",ja="アルタナフェーバー",duration=3600,element=6,icon_id=351,mp_cost=0,prefix="/pet",range=12,recast_id=174,status=113,targets=1,tp_cost=0,type="BloodPactWard"},
    -- Diabolos
    [1154] = {id=656,en="Camisado",ja="カミサドー",element=7,icon_id=348,mp_cost=20,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [1909] = {id=892,en="UNK Avatar Ability 1909"},
    [1910] = {id=662,en="Nether Blast",ja="ネザーブラスト",element=7,icon_id=348,mp_cost=109,prefix="/pet",range=9,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [1911] = {id=664,en="Ruinous Omen",ja="ルイナスオーメン",element=7,icon_id=348,mp_cost=0,prefix="/pet",range=4,recast_id=173,targets=32,tp_cost=0,type="BloodPactRage"},
    -- [665] = {id=665,en="Night Terror",ja="ナイトテラー",element=7,icon_id=348,mp_cost=177,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    -- [666] = {id=666,en="Pavor Nocturnus",ja="パボルノクターナス",element=7,icon_id=348,mp_cost=246,prefix="/pet",range=9,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
    -- [667] = {id=667,en="Blindside",ja="ブラインドサイド",element=7,icon_id=348,mp_cost=147,prefix="/pet",range=8,recast_id=173,skillchain_a="Gravitation",skillchain_b="Transfixion",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    -- [668] = {id=668,en="Deconstruction",ja="ディコンストラクション",element=7,icon_id=23,mp_cost=0,prefix="/pet",range=12,recast_id=0,targets=32,tp_cost=0,type="BloodPactRage"},
    -- [669] = {id=669,en="Chronoshift",ja="クロノシフト",element=7,icon_id=23,mp_cost=0,prefix="/pet",range=0,recast_id=0,targets=32,tp_cost=0,type="BloodPactRage"},
    -- Odin
    -- [670] = {id=670,en="Zantetsuken",ja="斬鉄剣",element=7,icon_id=349,mp_cost=0,prefix="/pet",range=8,recast_id=0,targets=32,tp_cost=0,type="BloodPactRage"},
    -- Alexander
    -- [671] = {id=671,en="Perfect Defense",ja="絶対防御",element=7,icon_id=350,mp_cost=0,prefix="/pet",range=0,recast_id=0,targets=32,tp_cost=0,type="BloodPactRage"},
}

l.Ability.Monster_Damaging = {
    -- Rabbit
    [257] = {id=257,en="Foot Kick",ja="フットキック",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [258] = {id=258,en="Dust Cloud",ja="土煙",element=3,icon_id=43,monster_level=10,prefix="/monsterskill",range=2,targets=32,tp_cost=800},
    [259] = {id=259,en="Whirl Claws",ja="爪旋風脚",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=8,targets=32,tp_cost=1800},
    -- Sheep
    [260] = {id=260,en="Lamb Chop",ja="頭突き",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=2,targets=32,tp_cost=1300},
    [262] = {id=262,en="Sheep Charge",ja="シープチャージ",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=800},
    -- Ram
    [266] = {id=266,en="Ram Charge",ja="ラムチャージ",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [267] = {id=267,en="Rumble",ja="地鳴り",element=3,icon_id=43,monster_level=20,prefix="/monsterskill",range=8,targets=32,tp_cost=800},
    [268] = {id=268,en="Great Bleat",ja="大咆哮",element=6,icon_id=46,monster_level=-1,prefix="/monsterskill",range=8,targets=32,tp_cost=9999},
    [269] = {id=269,en="Petribreath",ja="ペトロブレス",element=3,icon_id=43,monster_level=40,prefix="/monsterskill",range=9,targets=32,tp_cost=2000},
    -- Tiger
    [271] = {id=271,en="Razor Fang",ja="レイザーファング",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1500},
    [272] = {id=272,en="Claw Cyclone",ja="クローサイクロン",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=9,targets=32,tp_cost=1800},
    -- Antlion
    [273] = {id=273,en="Sandblast",ja="サンドブラスト",element=7,icon_id=47,monster_level=1,prefix="/monsterskill",range=7,targets=32,tp_cost=600},
    [274] = {id=274,en="Sandpit",ja="サンドピット",element=1,icon_id=41,monster_level=10,prefix="/monsterskill",range=2,targets=32,tp_cost=600},
    [275] = {id=275,en="Venom Spray",ja="ベノムスプレー",element=5,icon_id=45,monster_level=20,prefix="/monsterskill",range=8,targets=32,tp_cost=800},
    [276] = {id=276,en="Mandibular Bite",ja="M.バイト",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=2,targets=32,tp_cost=1200},
    -- Dhalmel
    [278] = {id=278,en="Stomping",ja="ストンピング",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    -- Opo Opo
    [283] = {id=283,en="Vicious Claw",ja="ビシャスクロー",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1300},
    [284] = {id=284,en="Stone Throw",ja="投石",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=9,targets=32,tp_cost=1200},
    [285] = {id=285,en="Spinning Claw",ja="スピニングクロー",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=8,targets=32,tp_cost=1800},
    [286] = {id=286,en="Claw Storm",ja="クローストーム",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=2,targets=32,tp_cost=1500},
    [288] = {id=288,en="Eye Scratch",ja="アイスクラッチ",element=6,icon_id=46,monster_level=50,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    -- Treant
    [290] = {id=290,en="Drill Branch",ja="ドリルブランチ",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=2,targets=32,tp_cost=1200},
    [291] = {id=291,en="Pinecone Bomb",ja="まつぼっくり爆弾",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=8,targets=32,tp_cost=1200},
    [292] = {id=292,en="Leafstorm",ja="リーフストーム",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    [293] = {id=293,en="Entangle",ja="エンタングル",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    -- Mandragora
    [294] = {id=294,en="Head Butt",ja="ヘッドバット",element=6,icon_id=46,monster_level=50,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [296] = {id=296,en="Wild Oats",ja="種まき",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=9,targets=32,tp_cost=500},
    [298] = {id=298,en="Leaf Dagger",ja="リーフダガー",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=9,targets=32,tp_cost=800},
    -- Funguar
    [300] = {id=300,en="Frogkick",ja="フロッグキック",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [302] = {id=302,en="Queasyshroom",ja="マヨイタケ",element=7,icon_id=47,monster_level=20,prefix="/monsterskill",range=9,targets=32,tp_cost=1000},
    [303] = {id=303,en="Numbshroom",ja="シビレタケ",element=7,icon_id=47,monster_level=30,prefix="/monsterskill",range=9,targets=32,tp_cost=1200},
    [304] = {id=304,en="Shakeshroom",ja="オドリタケ",element=7,icon_id=47,monster_level=40,prefix="/monsterskill",range=9,targets=32,tp_cost=1000},
    [305] = {id=305,en="Silence Gas",ja="サイレスガス",element=7,icon_id=47,monster_level=50,prefix="/monsterskill",range=9,targets=32,tp_cost=1500},
    [306] = {id=306,en="Dark Spore",ja="ダークスポア",element=7,icon_id=47,monster_level=60,prefix="/monsterskill",range=9,targets=32,tp_cost=1200},
    -- Morbol
    [307] = {id=307,en="Impale",ja="くしざし",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [308] = {id=308,en="Vampiric Lash",ja="吸血ムチ",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [309] = {id=309,en="Somersault",ja="サマーソルト",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=2,targets=32,tp_cost=1300},
    [310] = {id=310,en="Bad Breath",ja="臭い息",element=3,icon_id=43,monster_level=30,prefix="/monsterskill",range=9,targets=32,tp_cost=2000},
    [311] = {id=311,en="Sweet Breath",ja="甘い息",element=7,icon_id=47,monster_level=20,prefix="/monsterskill",range=9,targets=32,tp_cost=1500},
    -- Cactuar
    [312] = {id=312,en="Needleshot",ja="ニードルショット",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=12,targets=32,tp_cost=1000},
    [313] = {id=313,en="1000 Needles",ja="針千本",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=8,targets=32,tp_cost=1300},
    -- Bee
    [319] = {id=319,en="Sharp Sting",ja="シャープスティング",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=12,targets=32,tp_cost=1000},
    [321] = {id=321,en="Final Sting",ja="ファイナルスピア",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=9,targets=32,tp_cost=2000},
    -- Beetle    
    [322] = {id=322,en="Power Attack",ja="パワーアタック",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [324] = {id=324,en="Rhino Attack",ja="ライノアタック",element=6,icon_id=46,monster_level=40,prefix="/monsterskill",range=2,targets=32,tp_cost=1200},
    -- Crawler
    [328] = {id=328,en="Poison Breath",ja="ポイズンブレス",element=5,icon_id=45,monster_level=20,prefix="/monsterskill",range=9,targets=32,tp_cost=1200},
    -- Scorpion
    [330] = {id=330,en="Numbing Breath",ja="ナムブレス",element=1,icon_id=41,monster_level=50,prefix="/monsterskill",range=9,targets=32,tp_cost=1500},
    [331] = {id=331,en="Cold Breath",ja="コールドブレス",element=1,icon_id=41,monster_level=20,prefix="/monsterskill",range=9,targets=32,tp_cost=1200},
    [332] = {id=332,en="Mandible Bite",ja="マンディブルバイト",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [333] = {id=333,en="Poison Sting",ja="ポイズンスティング",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=2,targets=32,tp_cost=800},
    [334] = {id=334,en="Death Scissors",ja="デスシザース",element=6,icon_id=46,monster_level=50,prefix="/monsterskill",range=2,targets=32,tp_cost=2000},
    [335] = {id=335,en="Wild Rage",ja="大暴れ",element=6,icon_id=46,monster_level=40,prefix="/monsterskill",range=8,targets=32,tp_cost=1300},
    [336] = {id=336,en="Earth Pounder",ja="アースパウンダー",element=3,icon_id=43,monster_level=30,prefix="/monsterskill",range=8,targets=32,tp_cost=1200},
    [337] = {id=337,en="Sharp Strike",ja="シャープストライク",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=0,targets=1,tp_cost=800},
    -- Diremite
    [338] = {id=338,en="Double Claw",ja="ダブルクロー",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [339] = {id=339,en="Grapple",ja="グラップル",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=7,targets=32,tp_cost=1500},
    [341] = {id=341,en="Spinning Top",ja="スピニングトップ",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=8,targets=32,tp_cost=1200},
    -- Lizard    
    [342] = {id=342,en="Tail Blow",ja="テイルブロー",element=6,icon_id=46,monster_level=70,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [343] = {id=343,en="Fireball",ja="ファイアボール",element=0,icon_id=40,monster_level=1,prefix="/monsterskill",range=9,targets=32,tp_cost=1000},
    [344] = {id=344,en="Blockhead",ja="ブロックヘッド",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=2,targets=32,tp_cost=1500},
    [345] = {id=345,en="Brain Crush",ja="ブレインクラッシュ",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=2,targets=32,tp_cost=1200},
    [347] = {id=347,en="Plaguebreath",ja="プレイグブレス",element=5,icon_id=45,monster_level=50,prefix="/monsterskill",range=2,targets=32,tp_cost=1500},
    -- Raptor
    [350] = {id=350,en="Ripper Fang",ja="リッパーファング",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [351] = {id=351,en="Foul Breath",ja="ファウルブレス",element=0,icon_id=40,monster_level=40,prefix="/monsterskill",range=9,targets=32,tp_cost=1500},
    [352] = {id=352,en="Frost Breath",ja="フロストブレス",element=1,icon_id=41,monster_level=40,prefix="/monsterskill",range=9,targets=32,tp_cost=1500},
    [353] = {id=353,en="Thunderbolt",ja="サンダーボルト",element=4,icon_id=44,monster_level=30,prefix="/monsterskill",range=9,targets=32,tp_cost=1500},
    [354] = {id=354,en="Chomp Rush",ja="噛みつきラッシュ",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [355] = {id=355,en="Scythe Tail",ja="サイズテール",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=2,targets=32,tp_cost=1200},
    -- Bugard    
    [356] = {id=356,en="Tail Roll",ja="テールロール",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=7,targets=32,tp_cost=1000},
    [357] = {id=357,en="Tusk",ja="タスク",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=2,targets=32,tp_cost=2000},
    [359] = {id=359,en="Bone Crunch",ja="ボーンクランチ",element=6,icon_id=46,monster_level=50,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    -- Bat
    [364] = {id=364,en="Blood Drain",ja="吸血",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    -- Triple Bat
    [365] = {id=365,en="Jet Stream",ja="ジェットストリーム",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=9,targets=32,tp_cost=1000},
    -- Greater Bird
    [366] = {id=366,en="Blind Vortex",ja="ブラインヴォルテクス",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [367] = {id=367,en="Giga Scream",ja="ギガスクリーム",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [368] = {id=368,en="Dread Dive",ja="ドレッドダイヴ",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [370] = {id=370,en="Stormwind",ja="ストームウィンド",element=2,icon_id=42,monster_level=40,prefix="/monsterskill",range=8,targets=32,tp_cost=1500},
    -- Cockatrice
    [371] = {id=371,en="Hammer Beak",ja="ハンマービーク",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [372] = {id=372,en="Poison Pick",ja="ポイズンピック",element=6,icon_id=46,monster_level=40,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    -- Leech
    [376] = {id=376,en="Suction",ja="吸着",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [377] = {id=377,en="Acid Mist",ja="アシッドミスト",element=5,icon_id=45,monster_level=30,prefix="/monsterskill",range=8,targets=32,tp_cost=1200},
    [378] = {id=378,en="Sand Breath",ja="サンドブレス",element=3,icon_id=43,monster_level=20,prefix="/monsterskill",range=7,targets=32,tp_cost=1200},
    [379] = {id=379,en="Drainkiss",ja="ドレインキッス",element=6,icon_id=46,monster_level=50,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [383] = {id=383,en="Brain Drain",ja="ブレインドレイン",element=7,icon_id=47,monster_level=60,prefix="/monsterskill",range=2,targets=32,tp_cost=1500},
    --Slime
    [384] = {id=384,en="Fluid Spread",ja="フルイドスプレッド",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=7,targets=32,tp_cost=1000},
    [385] = {id=385,en="Fluid Toss",ja="フルイドスルー",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=9,targets=32,tp_cost=800},
    [386] = {id=386,en="Digest",ja="消化",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    -- Hecteyes
    [390] = {id=390,en="Death Ray",ja="デスレイ",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=9,targets=32,tp_cost=1000},
    -- Crab
    [394] = {id=394,en="Bubble Shower",ja="バブルシャワー",element=5,icon_id=45,monster_level=20,prefix="/monsterskill",range=12,targets=32,tp_cost=1500},
    [396] = {id=396,en="Big Scissors",ja="ビッグシザー",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=800},
    -- Pugil
    [400] = {id=400,en="Aqua Ball",ja="アクアボール",element=5,icon_id=45,monster_level=10,prefix="/monsterskill",range=9,targets=32,tp_cost=1000},
    [401] = {id=401,en="Splash Breath",ja="スプラッシュブレス",element=5,icon_id=45,monster_level=20,prefix="/monsterskill",range=9,targets=32,tp_cost=1200},
    [402] = {id=402,en="Screwdriver",ja="スクリュードライバー",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=2,targets=32,tp_cost=800},
    -- Sea Monk
    [405] = {id=405,en="Tentacle",ja="触手",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [406] = {id=406,en="Ink Jet",ja="インクジェット",element=7,icon_id=47,monster_level=10,prefix="/monsterskill",range=9,targets=32,tp_cost=1200},
    [408] = {id=408,en="Cross Attack",ja="クロスアタック",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=2,targets=32,tp_cost=1500},
    [410] = {id=410,en="Maelstrom",ja="メイルシュトロム",element=5,icon_id=45,monster_level=60,prefix="/monsterskill",range=7,targets=32,tp_cost=1200},
    [411] = {id=411,en="Whirlwind",ja="旋風",element=2,icon_id=42,monster_level=50,prefix="/monsterskill",range=7,targets=32,tp_cost=1200},
    -- Coeurl  
    [412] = {id=412,en="Petri. Breath",ja="石の吐息",element=3,icon_id=43,monster_level=40,prefix="/monsterskill",range=2,targets=32,tp_cost=800},
    [414] = {id=414,en="Pounce",ja="パウンス",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=2,targets=32,tp_cost=1200},
    [415] = {id=415,en="Charged Whisker",ja="チャージドホイスカー",element=4,icon_id=44,monster_level=50,prefix="/monsterskill",range=8,targets=32,tp_cost=1500},
    -- Buffalo 
    [416] = {id=416,en="Rampant Gnaw",ja="ランパントナウ",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=2,targets=32,tp_cost=1500},
    [417] = {id=417,en="Big Horn",ja="ビッグホーン",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [418] = {id=418,en="Snort",ja="スノート",element=2,icon_id=42,monster_level=20,prefix="/monsterskill",range=7,targets=32,tp_cost=1000},
    -- Uragnite
    [423] = {id=423,en="Palsynyxis",ja="パルジーニクシス",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [424] = {id=424,en="Painful Whip",ja="ペインフルウィップ",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},    
    -- Eft    
    [429] = {id=429,en="Nimble Snap",ja="ニンブルスナップ",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=2,targets=32,tp_cost=1500},
    [430] = {id=430,en="Cyclotail",ja="サイクロテール",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=8,targets=32,tp_cost=1300},
    -- Hippogryph
    [431] = {id=431,en="Back Heel",ja="バックヒール",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1200},
    [434] = {id=434,en="Choke Breath",ja="チョークブレス",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=7,targets=32,tp_cost=1000},
    -- Goobbue
    [436] = {id=436,en="Blow",ja="ブロー",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [437] = {id=437,en="Beatdown",ja="ビートダウン",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [438] = {id=438,en="Uppercut",ja="アッパーカット",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=2,targets=32,tp_cost=1500},
    -- Lesser Bird 
    [442] = {id=442,en="Helldive",ja="ヘルダイブ",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=800},
    [443] = {id=443,en="Wing Cutter",ja="ウィングカッター",element=2,icon_id=42,monster_level=10,prefix="/monsterskill",range=9,targets=32,tp_cost=800},
    -- Behemoth
    [444] = {id=444,en="Wild Horn",ja="ワイルドホーン",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=9,targets=32,tp_cost=1000},
    [445] = {id=445,en="Thunderbolt",ja="サンダーボルト",element=4,icon_id=44,monster_level=40,prefix="/monsterskill",range=12,targets=32,tp_cost=2000},
    [446] = {id=446,en="Shock Wave",ja="衝撃波",element=2,icon_id=42,monster_level=10,prefix="/monsterskill",range=9,targets=32,tp_cost=1000},
    [449] = {id=449,en="Meteor",ja="メテオ",element=6,icon_id=46,monster_level=50,prefix="/monsterskill",range=12,targets=32,tp_cost=3000},
    -- Pugil    
    [450] = {id=450,en="Recoil Dive",ja="リコイルダイブ",element=6,icon_id=46,monster_level=60,prefix="/monsterskill",range=9,targets=32,tp_cost=1250},
    -- Damselfly
    [453] = {id=453,en="Cursed Sphere",ja="カースドスフィア",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=9,targets=32,tp_cost=1000},
    [454] = {id=454,en="Venom",ja="毒液",element=5,icon_id=45,monster_level=1,prefix="/monsterskill",range=9,targets=32,tp_cost=700},
    -- Snow Rabbit    
    [455] = {id=455,en="Snow Cloud",ja="雪煙",element=1,icon_id=41,monster_level=40,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    -- Sapling
    [456] = {id=456,en="Sprout Spin",ja="スプラウトスピン",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=8,targets=32,tp_cost=1200},
    [458] = {id=458,en="Sprout Smack",ja="スプラウトスマック",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    -- Scorpion    
    [459] = {id=459,en="Venom Breath",ja="ベノムブレス",element=1,icon_id=41,monster_level=60,prefix="/monsterskill",range=12,targets=32,tp_cost=800},
    [460] = {id=460,en="Critical Bite",ja="クリティカルバイト",element=6,icon_id=46,monster_level=60,prefix="/monsterskill",range=2,targets=32,tp_cost=1300},
    [461] = {id=461,en="Venom Sting",ja="ベノムスティング",element=6,icon_id=46,monster_level=80,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [462] = {id=462,en="Stasis",ja="ステーシス",element=6,icon_id=46,monster_level=80,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [463] = {id=463,en="Venom Storm",ja="ベノムストーム",element=6,icon_id=46,monster_level=70,prefix="/monsterskill",range=12,targets=32,tp_cost=1000},
    [464] = {id=464,en="Earthbreaker",ja="アースブレイカー",element=3,icon_id=43,monster_level=90,prefix="/monsterskill",range=12,targets=32,tp_cost=1500},
    -- Manticore
    [466] = {id=466,en="Deadly Hold",ja="デッドリーホールド",element=6,icon_id=46,monster_level=60,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [467] = {id=467,en="Tail Swing",ja="テールスイング",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [468] = {id=468,en="Tail Smash",ja="テールスマッシュ",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [469] = {id=469,en="Heat Breath",ja="火炎の息",element=0,icon_id=40,monster_level=30,prefix="/monsterskill",range=9,targets=32,tp_cost=1000},
    [471] = {id=471,en="Great Sandstorm",ja="大砂塵",element=2,icon_id=42,monster_level=40,prefix="/monsterskill",range=9,targets=32,tp_cost=1000},
    [472] = {id=472,en="Great Whirlwind",ja="大旋風",element=2,icon_id=42,monster_level=50,prefix="/monsterskill",range=9,targets=32,tp_cost=1200},
    -- Tortoise
    [474] = {id=474,en="Head Butt",ja="ヘッドバット",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1000},
    [475] = {id=475,en="Tortoise Stomp",ja="トータスストンプ",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=2,targets=32,tp_cost=1200},
    [477] = {id=477,en="Earth Breath",ja="アースブレス",element=3,icon_id=43,monster_level=40,prefix="/monsterskill",range=9,targets=32,tp_cost=1000},
    [478] = {id=478,en="Aqua Breath",ja="アクアブレス",element=5,icon_id=45,monster_level=50,prefix="/monsterskill",range=9,targets=32,tp_cost=1000},
    -- Spider
    [479] = {id=479,en="Sickle Slash",ja="シックルスラッシュ",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=2,targets=32,tp_cost=1200},
    [480] = {id=480,en="Acid Spray",ja="アシッドスプレー",element=5,icon_id=45,monster_level=1,prefix="/monsterskill",range=9,targets=32,tp_cost=800},
    -- Sabotender
    [483] = {id=483,en="10,000 Needles",ja="針万本",element=6,icon_id=46,monster_level=-1,prefix="/monsterskill",range=8,targets=32,tp_cost=9999},
    -- Triple Bat
    [487] = {id=487,en="Turbulence",ja="タービュレンス",element=2,icon_id=42,monster_level=30,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    -- Lesser Bird
    [488] = {id=488,en="Broad. Barrage",ja="ボロードサイド.B",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=2,targets=32,tp_cost=800},
    [489] = {id=489,en="Blind. Barrage",ja="ブラインドサイド.B",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=2,targets=32,tp_cost=800},
    [490] = {id=490,en="Damnation Dive",ja="ダムネーションダイブ",element=6,icon_id=46,monster_level=40,prefix="/monsterskill",range=7,targets=32,tp_cost=1500},
    -- Slime
    [491] = {id=491,en="Mucus Spread",ja="ミューカススプレッド",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=6,targets=32,tp_cost=750},
    [492] = {id=492,en="Epoxy Spread",ja="イポクシースプレッド",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=6,targets=32,tp_cost=750},
    -- Hippogryph
    [494] = {id=494,en="Hoof Volley",ja="フーフボレー",element=6,icon_id=46,monster_level=50,prefix="/monsterskill",range=2,targets=32,tp_cost=2000},
    -- Cockatrice
    [496] = {id=496,en="Toxic Pick",ja="トクシックピック",element=6,icon_id=46,monster_level=50,prefix="/monsterskill",range=2,targets=32,tp_cost=1500},
    -- [497] = {id=497,en="Crossthrash",ja="クロススラッシュ",element=6,icon_id=46,monster_level=40,prefix="/monsterskill",range=9,targets=32,tp_cost=1800},
    -- [498] = {id=498,en="Knife Edge Circle",ja="ナイフエッジサークル",element=6,icon_id=46,monster_level=40,prefix="/monsterskill",range=8,targets=32,tp_cost=1300},
    -- [499] = {id=499,en="Train Fall",ja="トレインフォール",element=6,icon_id=46,monster_level=50,prefix="/monsterskill",range=2,targets=32,tp_cost=2000},
    -- [500] = {id=500,en="Viscid Secretion",ja="粘粘",element=3,icon_id=43,monster_level=40,prefix="/monsterskill",range=7,targets=32,tp_cost=1200},
    -- [501] = {id=501,en="Wild Ginseng",ja="ワイルドジンセン",element=6,icon_id=46,monster_level=50,prefix="/monsterskill",range=0,targets=1,tp_cost=1200},
    -- [502] = {id=502,en="Hungry Crunch",ja="ハングリークランチ",element=6,icon_id=46,monster_level=60,prefix="/monsterskill",range=2,targets=32,tp_cost=1800},
    -- [503] = {id=503,en="Mighty Snort",ja="マイティースノート",element=2,icon_id=42,monster_level=50,prefix="/monsterskill",range=7,targets=32,tp_cost=1200},
    -- [504] = {id=504,en="Soul Accretion",ja="ソウルアクリーション",element=6,icon_id=46,monster_level=40,prefix="/monsterskill",range=2,targets=32,tp_cost=1300},
    -- [505] = {id=505,en="Miasmic Breath",ja="臭い酒息",element=6,icon_id=46,monster_level=50,prefix="/monsterskill",range=12,targets=32,tp_cost=1800},
    -- [506] = {id=506,en="Putrid Breath",ja="忌まわしい嘆息",element=6,icon_id=46,monster_level=60,prefix="/monsterskill",range=12,targets=32,tp_cost=1500},
    -- Sabotender
    [507] = {id=507,en="2,000 Needles",ja="針弐千本",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=8,targets=32,tp_cost=1900},
    [508] = {id=508,en="4,000 Needles",ja="針四千本",element=6,icon_id=46,monster_level=40,prefix="/monsterskill",range=8,targets=32,tp_cost=2500},
    -- [509] = {id=509,en="Predatory Glare",ja="プレダトリグレア",element=6,icon_id=46,monster_level=60,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    -- [510] = {id=510,en="Vile Belch",ja="おくび",element=6,icon_id=46,monster_level=40,prefix="/monsterskill",range=8,targets=32,tp_cost=1500},
    -- Orobon
    [512] = {id=512,en="Seismic Tail",ja="セイズミックテール",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=8,targets=32,tp_cost=2000},
    [513] = {id=513,en="Seaspray",ja="潮泡",element=5,icon_id=45,monster_level=10,prefix="/monsterskill",range=8,targets=32,tp_cost=1500},
    [514] = {id=514,en="Leeching Current",ja="渦潮",element=6,icon_id=46,monster_level=50,prefix="/monsterskill",range=9,targets=32,tp_cost=1800},
    -- [515] = {id=515,en="Pecking Flurry",ja="ペッキングフラリー",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=4,targets=32,tp_cost=1000},
    -- Marid
    [519] = {id=519,en="Onrush",ja="オンラッシュ",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    [520] = {id=520,en="Stampede",ja="轟足",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=2,targets=32,tp_cost=1500},
    [521] = {id=521,en="Flailing Trunk",ja="薙鼻",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=8,targets=32,tp_cost=1600},
    -- [524] = {id=524,en="Yawn",ja="ヤーン",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    -- [525] = {id=525,en="Wing Slap",ja="ウィングスラップ",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=2,targets=32,tp_cost=1500},
    -- [526] = {id=526,en="Beak Lunge",ja="ビークランジ",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=7,targets=32,tp_cost=1200},
    -- [527] = {id=527,en="Frigid Shuffle",ja="クールダンス",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    -- [528] = {id=528,en="Wing Whirl",ja="貝独楽",element=2,icon_id=42,monster_level=40,prefix="/monsterskill",range=8,targets=32,tp_cost=1500},
    -- Cerberus     
    [529] = {id=529,en="Lava Spit",ja="ラヴァスピット",element=0,icon_id=40,monster_level=1,prefix="/monsterskill",range=12,targets=32,tp_cost=1000},
    [530] = {id=530,en="Sulfurous Breath",ja="サルファラスブレス",element=0,icon_id=40,monster_level=10,prefix="/monsterskill",range=8,targets=32,tp_cost=1200},
    [533] = {id=533,en="Gates of Hades",ja="ゲーツオブハデス",element=0,icon_id=40,monster_level=60,prefix="/monsterskill",range=12,targets=32,tp_cost=2500},
    -- [534] = {id=534,en="Incinerate",ja="インシナレート",element=0,icon_id=40,monster_level=30,prefix="/monsterskill",range=8,targets=32,tp_cost=1200},
    -- [535] = {id=535,en="Vampiric Root",ja="ヴァンピリックルート",element=6,icon_id=46,monster_level=70,prefix="/monsterskill",range=7,targets=32,tp_cost=1500},
    -- Wamouracampa
    [537] = {id=537,en="Vitriolic Spray",ja="V.スプレー",element=0,icon_id=40,monster_level=20,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    [538] = {id=538,en="Thermal Pulse",ja="サーマルパルス",element=0,icon_id=40,monster_level=30,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    [539] = {id=539,en="Cannonball",ja="キャノンボール",element=3,icon_id=43,monster_level=20,prefix="/monsterskill",range=7,targets=32,tp_cost=1000},
    -- [541] = {id=541,en="Vitriolic Shower",ja="V.シャワー",element=0,icon_id=40,monster_level=40,prefix="/monsterskill",range=8,targets=32,tp_cost=1500},
    -- Flan
    [545] = {id=545,en="Amorphic Spikes",ja="槍玉",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=7,targets=32,tp_cost=1000},
    [546] = {id=546,en="Amorphic Scythe",ja="鎌かけ",element=6,icon_id=46,monster_level=40,prefix="/monsterskill",range=7,targets=32,tp_cost=1000},
    -- [548] = {id=548,en="Feeble Bleat",ja="小咆哮",element=6,icon_id=46,monster_level=50,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    -- [549] = {id=549,en="Frenzy Pollen",ja="フレンジーポレン",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=0,targets=1,tp_cost=3000},
    -- Wamoura
    [550] = {id=550,en="Magma Fan",ja="マグマファン",element=0,icon_id=40,monster_level=50,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    [551] = {id=551,en="Erratic Flutter",ja="エラチックフラッター",element=0,icon_id=40,monster_level=60,prefix="/monsterskill",range=9,targets=32,tp_cost=1500},
    [553] = {id=553,en="Erosion Dust",ja="妖鱗粉",element=0,icon_id=40,monster_level=80,prefix="/monsterskill",range=12,targets=32,tp_cost=1000},
    [555] = {id=555,en="Fire Break",ja="ファイアブレーク",element=0,icon_id=40,monster_level=95,prefix="/monsterskill",range=8,targets=32,tp_cost=2000},
    -- [556] = {id=556,en="Abominable Belch",ja="長大息",element=6,icon_id=46,monster_level=60,prefix="/monsterskill",range=9,targets=32,tp_cost=1500},
    -- Wivre
    [557] = {id=557,en="Batterhorn",ja="バッターホーン",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=7,targets=32,tp_cost=1500},
    [561] = {id=561,en="Crippling Slam",ja="クリップリングスラム",element=6,icon_id=46,monster_level=40,prefix="/monsterskill",range=8,targets=32,tp_cost=2000},
    -- Peiste
    [562] = {id=562,en="Aqua Fortis",ja="アクアフォーティス",element=5,icon_id=45,monster_level=30,prefix="/monsterskill",range=12,targets=32,tp_cost=1300},
    [563] = {id=563,en="Regurgitation",ja="リガージテーション",element=5,icon_id=45,monster_level=20,prefix="/monsterskill",range=12,targets=32,tp_cost=1300},
    [564] = {id=564,en="Delta Thrust",ja="デルタスラスト",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=4,targets=32,tp_cost=1200},
    [566] = {id=566,en="Calcifying Mist",ja="C.ミスト",element=5,icon_id=45,monster_level=40,prefix="/monsterskill",range=12,targets=32,tp_cost=1800},
    -- Gnat
    [567] = {id=567,en="Insipid Nip",ja="インシピッドニップ",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=7,targets=32,tp_cost=1000},
    [568] = {id=568,en="Pandemic Nip",ja="パンデミックニップ",element=6,icon_id=46,monster_level=-1,prefix="/monsterskill",range=7,targets=32,tp_cost=9999},
    -- Rafflesia
    [572] = {id=572,en="Seedspray",ja="シードスプレー",element=3,icon_id=43,monster_level=10,prefix="/monsterskill",range=8,targets=32,tp_cost=1200},
    [575] = {id=575,en="Bloody Caress",ja="ブラッディカレス",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=7,targets=32,tp_cost=1200},
    -- Gnole
    [576] = {id=576,en="Fevered Pitch",ja="フィーバードピッチ",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=7,targets=32,tp_cost=1000},
    [579] = {id=579,en="Nox Blast",ja="ノックスブラスト",element=7,icon_id=47,monster_level=10,prefix="/monsterskill",range=8,targets=32,tp_cost=1500},
    [580] = {id=580,en="Asuran Claws",ja="アシュラクロー",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1800},
    -- Ladybug
    [582] = {id=582,en="Sudden Lunge",ja="サドンランジ",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=4,targets=32,tp_cost=1000},
    [585] = {id=585,en="Spiral Spin",ja="スパイラルスピン",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=9,targets=32,tp_cost=1000},
    [586] = {id=586,en="Spiral Burst",ja="スパイラルバースト",element=0,icon_id=40,monster_level=40,prefix="/monsterskill",range=9,targets=32,tp_cost=1200},
    -- Slug
    [587] = {id=587,en="Fuscous Ooze",ja="ファスカスウーズ",element=5,icon_id=45,monster_level=10,prefix="/monsterskill",range=8,targets=32,tp_cost=2000},
    [588] = {id=588,en="Purulent Ooze",ja="ピュルラントウーズ",element=5,icon_id=45,monster_level=1,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    [589] = {id=589,en="Corrosive Ooze",ja="コローシブウーズ",element=5,icon_id=45,monster_level=20,prefix="/monsterskill",range=8,targets=32,tp_cost=1500},
    -- Sandworm
    [591] = {id=591,en="Dustvoid",ja="ダストヴォイド",element=2,icon_id=42,monster_level=1,prefix="/monsterskill",range=9,targets=32,tp_cost=1000},
    [592] = {id=592,en="Slaverous Gale",ja="スラヴェラスゲイル",element=3,icon_id=43,monster_level=10,prefix="/monsterskill",range=9,targets=32,tp_cost=2000},
    [593] = {id=593,en="Aeolian Void",ja="イオリアンヴォイド",element=2,icon_id=42,monster_level=20,prefix="/monsterskill",range=9,targets=32,tp_cost=1800},
    -- Lynx
    [598] = {id=598,en="Blink of Peril",ja="ブリンクオブペリル",element=6,icon_id=46,monster_level=-1,prefix="/monsterskill",range=8,targets=32,tp_cost=9999},
    -- Scorpion
    [600] = {id=600,en="Hell Scissors",ja="ヘルシザース",element=6,icon_id=46,monster_level=-1,prefix="/monsterskill",range=2,targets=32,tp_cost=9999},
    -- Behemoth
    [602] = {id=602,en="Amnesic Blast",ja="アムネジクブラスト",element=7,icon_id=47,monster_level=60,prefix="/monsterskill",range=10,targets=32,tp_cost=2000},
    -- Mandragora
    [603] = {id=603,en="Demonic Flower",ja="夢狂花",element=6,icon_id=46,monster_level=60,prefix="/monsterskill",range=4,targets=32,tp_cost=1000},
    -- [604] = {id=604,en="Bloody Beak",ja="ブラッディビーク",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=6,targets=32,tp_cost=1300},
    -- [605] = {id=605,en="Warped Wail",ja="ワープドウェール",element=6,icon_id=46,monster_level=-1,prefix="/monsterskill",range=12,targets=32,tp_cost=2000},
    -- [606] = {id=606,en="Reaving Wind",ja="リービンウィンド",element=2,icon_id=42,monster_level=20,prefix="/monsterskill",range=9,targets=32,tp_cost=1500},
    -- [607] = {id=607,en="Storm Wing",ja="ストームウィング",element=2,icon_id=42,monster_level=1,prefix="/monsterskill",range=12,targets=32,tp_cost=1300},
    -- [608] = {id=608,en="Calamitous Wind",ja="カラミティウィンド",element=2,icon_id=42,monster_level=30,prefix="/monsterskill",range=12,targets=32,tp_cost=1700},
    -- [609] = {id=609,en="Severing Fang",ja="セヴァリンファング",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=4,targets=32,tp_cost=1500},
    -- Ruszor
    [610] = {id=610,en="Aqua Blast",ja="アクアブラスト",element=5,icon_id=45,monster_level=10,prefix="/monsterskill",range=10,targets=32,tp_cost=1500},
    [611] = {id=611,en="Frozen Mist",ja="フローズンミスト",element=1,icon_id=41,monster_level=30,prefix="/monsterskill",range=8,targets=32,tp_cost=3000},
    [612] = {id=612,en="Hydro Wave",ja="ハイドロウェーブ",element=5,icon_id=45,monster_level=40,prefix="/monsterskill",range=8,targets=32,tp_cost=2500},
    -- [613] = {id=613,en="Ice Guillotine",ja="アイスギロティン",element=1,icon_id=41,monster_level=50,prefix="/monsterskill",range=5,targets=32,tp_cost=2000},
    -- [614] = {id=614,en="Aqua Cannon",ja="アクアキャノン",element=5,icon_id=45,monster_level=60,prefix="/monsterskill",range=11,targets=32,tp_cost=2000},
    -- [615] = {id=615,en="Venom Shower",ja="ベノムシャワー",element=5,icon_id=45,monster_level=60,prefix="/monsterskill",range=12,targets=32,tp_cost=2500},
    -- [616] = {id=616,en="Mega Scissors",ja="メガシザース",element=6,icon_id=46,monster_level=50,prefix="/monsterskill",range=8,targets=32,tp_cost=2000},
    -- [617] = {id=617,en="Cytokinesis",ja="サイトキネシス",element=6,icon_id=46,monster_level=40,prefix="/monsterskill",range=12,targets=32,tp_cost=1500},
    -- [618] = {id=618,en="Gravitic Horn",ja="グラビティホーン",element=6,icon_id=46,monster_level=-1,prefix="/monsterskill",range=12,targets=32,tp_cost=9999},
    -- [619] = {id=619,en="Quake Blast",ja="クエイクブラスト",element=3,icon_id=43,monster_level=50,prefix="/monsterskill",range=12,targets=32,tp_cost=2000},
    -- Slime
    [620] = {id=620,en="Fluid Spread",ja="フルイドスプレッド",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=7,targets=32,tp_cost=1000},
    [621] = {id=621,en="Fluid Toss",ja="フルイドスルー",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=9,targets=32,tp_cost=800},
    -- [622] = {id=622,en="Dissolve",ja="ディゾルブ",element=6,icon_id=46,monster_level=50,prefix="/monsterskill",range=8,targets=32,tp_cost=3000},
    [623] = {id=623,en="Mucus Spread",ja="ミューカススプレッド",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=6,targets=32,tp_cost=750},
    [624] = {id=624,en="Epoxy Spread",ja="イポクシースプレッド",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=6,targets=32,tp_cost=750},
    -- [625] = {id=625,en="Thousand Spears",ja="サウザンドスピア",element=6,icon_id=46,monster_level=80,prefix="/monsterskill",range=8,targets=32,tp_cost=2000},
    -- [626] = {id=626,en="Phaeosynthesis",ja="闇合成",element=7,icon_id=47,monster_level=80,prefix="/monsterskill",range=2,targets=1,tp_cost=2000},
    -- [627] = {id=627,en="Testudo Tremor",ja="テストゥドトレマー",element=3,icon_id=43,monster_level=60,prefix="/monsterskill",range=9,targets=32,tp_cost=2000},
    -- [628] = {id=628,en="Ecliptic Meteor",ja="エクリプスメテオ",element=7,icon_id=47,monster_level=70,prefix="/monsterskill",range=9,targets=32,tp_cost=2000},
    -- [629] = {id=629,en="Tepal Twist",ja="テパルツイスト",element=6,icon_id=46,monster_level=-1,prefix="/monsterskill",range=8,targets=32,tp_cost=9999},
    -- [630] = {id=630,en="Bloom Fouette",ja="ブルームフェッテ",element=6,icon_id=46,monster_level=-1,prefix="/monsterskill",range=8,targets=32,tp_cost=9999},
    -- [631] = {id=631,en="Petalback Spin",ja="ペタルバックスピン",element=6,icon_id=46,monster_level=90,prefix="/monsterskill",range=7,targets=32,tp_cost=2000},
    -- [632] = {id=632,en="Mortal Blast",ja="モータルブラスト",element=6,icon_id=46,monster_level=-1,prefix="/monsterskill",range=8,targets=32,tp_cost=9999},
    -- Sandworm
    [633] = {id=633,en="Gorge",ja="ゴージ",element=6,icon_id=46,monster_level=-1,prefix="/monsterskill",range=9,targets=32,tp_cost=1500},
    [634] = {id=634,en="Disgorge",ja="ディスゴージ",element=3,icon_id=43,monster_level=-1,prefix="/monsterskill",range=9,targets=32,tp_cost=1500},
    -- [635] = {id=635,en="Agaricus",ja="アガリクス",element=7,icon_id=47,monster_level=70,prefix="/monsterskill",range=9,targets=32,tp_cost=2000},
    -- [636] = {id=636,en="Terminal Sting",ja="ターミナルスピア",element=6,icon_id=46,monster_level=-1,prefix="/monsterskill",range=9,targets=32,tp_cost=9999},
    -- [637] = {id=637,en="Booming Bleat",ja="ブーミングブリート",element=6,icon_id=46,monster_level=-1,prefix="/monsterskill",range=8,targets=32,tp_cost=9999},
    -- [638] = {id=638,en="Vacant Gaze",ja="ベイカントゲイズ",element=6,icon_id=46,monster_level=70,prefix="/monsterskill",range=9,targets=32,tp_cost=1500},
    -- [639] = {id=639,en="Psyche Suction",ja="サイキサクション",element=6,icon_id=46,monster_level=70,prefix="/monsterskill",range=9,targets=32,tp_cost=2000},
    -- [640] = {id=640,en="Vermilion Wind",ja="V.ウィンド",element=2,icon_id=42,monster_level=40,prefix="/monsterskill",range=10,targets=32,tp_cost=1500},
    -- [641] = {id=641,en="Tyrant Tusk",ja="タイラントタスク",element=7,icon_id=47,monster_level=-1,prefix="/monsterskill",range=8,targets=32,tp_cost=9999},
    -- [642] = {id=642,en="Virulent Haze",ja="ビルレントヘイズ",element=3,icon_id=43,monster_level=50,prefix="/monsterskill",range=8,targets=32,tp_cost=1200},
    -- [643] = {id=643,en="Torment Tusk",ja="トーメントタスク",element=7,icon_id=47,monster_level=-1,prefix="/monsterskill",range=8,targets=32,tp_cost=9999},
    -- [644] = {id=644,en="Tarsal Slam",ja="ターサルスラム",element=6,icon_id=46,monster_level=-1,prefix="/monsterskill",range=8,targets=32,tp_cost=9999},
    -- [645] = {id=645,en="Acheron Flame",ja="アケロンフレイム",element=0,icon_id=40,monster_level=60,prefix="/monsterskill",range=12,targets=32,tp_cost=3000},
    -- [646] = {id=646,en="Dread Wind",ja="ドレッドウィンド",element=2,icon_id=42,monster_level=50,prefix="/monsterskill",range=12,targets=32,tp_cost=2500},
    -- [647] = {id=647,en="Telsonic Tempest",ja="T.テンペスト",element=2,icon_id=42,monster_level=99,prefix="/monsterskill",range=8,targets=32,tp_cost=2000},
    -- [648] = {id=648,en="Preter. Gleam",ja="クイエセンスグリーム",element=6,icon_id=46,monster_level=80,prefix="/monsterskill",range=8,targets=32,tp_cost=1800},
    -- [649] = {id=649,en="Chupa Blossom",ja="チュパブロッサム",element=7,icon_id=47,monster_level=60,prefix="/monsterskill",range=8,targets=32,tp_cost=3000},
    -- [650] = {id=650,en="Blighted Bouquet",ja="ブライテッドブーケ",element=5,icon_id=45,monster_level=60,prefix="/monsterskill",range=11,targets=32,tp_cost=1800},
    -- [651] = {id=651,en="Booming Bomb.",ja="B.ボンビネーション",element=6,icon_id=46,monster_level=50,prefix="/monsterskill",range=11,targets=32,tp_cost=1800},
    -- [652] = {id=652,en="Gush o' Goo",ja="グッシュ・オ・グー",element=5,icon_id=45,monster_level=50,prefix="/monsterskill",range=8,targets=32,tp_cost=1800},
    -- Apkallu
    [654] = {id=654,en="Wing Slap",ja="ウィングスラップ",element=6,icon_id=46,monster_level=30,prefix="/monsterskill",range=2,targets=32,tp_cost=1500},
    [655] = {id=655,en="Beak Lunge",ja="ビークランジ",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=7,targets=32,tp_cost=1200},
    [657] = {id=657,en="Wing Whirl",ja="貝独楽",element=2,icon_id=42,monster_level=40,prefix="/monsterskill",range=8,targets=32,tp_cost=1500},
    -- [658] = {id=658,en="Whiteout",ja="ホワイトアウト",element=1,icon_id=41,monster_level=50,prefix="/monsterskill",range=12,targets=32,tp_cost=3000},
    -- [659] = {id=659,en="Keratinous Crush",ja="ケラチナスクラッシュ",element=3,icon_id=43,monster_level=-1,prefix="/monsterskill",range=10,targets=32,tp_cost=9999},
    -- [660] = {id=660,en="Rhinowrecker",ja="ライノレッカー",element=6,icon_id=46,monster_level=50,prefix="/monsterskill",range=8,targets=32,tp_cost=2200},
    -- Colibri
    [661] = {id=661,en="Tropic Tenor",ja="トロピカルテノール",element=6,icon_id=46,monster_level=40,prefix="/monsterskill",range=10,targets=32,tp_cost=2000},
    -- [662] = {id=662,en="Searing Effulgence",ja="S.エッファルジェンス",element=6,icon_id=46,monster_level=50,prefix="/monsterskill",range=8,targets=32,tp_cost=1800},
    -- [663] = {id=663,en="Tarichutoxin",ja="タリチャトクシン",element=5,icon_id=45,monster_level=50,prefix="/monsterskill",range=8,targets=32,tp_cost=1500},
    -- [664] = {id=664,en="Caliginosity",ja="カリギノシティー",element=7,icon_id=47,monster_level=70,prefix="/monsterskill",range=9,targets=32,tp_cost=2000},
    -- Chapuli 
    [666] = {id=666,en="Sensilla Blades",ja="センシラブレード",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    [667] = {id=667,en="Tegmina Buffet",ja="テグミナバフェット",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=4,targets=32,tp_cost=1000},
    [668] = {id=668,en="Sanguinary Slash",ja="サングインスラッシュ",element=6,icon_id=46,monster_level=20,prefix="/monsterskill",range=10,targets=32,tp_cost=1000},
    -- [669] = {id=669,en="Orthopterror",ja="オーソプテラー",element=6,icon_id=46,monster_level=40,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    -- Twitherym
    [670] = {id=670,en="Temp. Upheaval",ja="T.アップヒーヴ",element=2,icon_id=42,monster_level=1,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    [671] = {id=671,en="Slice 'n' Dice",ja="スライスンダイス",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    -- [673] = {id=673,en="Smould. Swarm",ja="S.スウォーム",element=0,icon_id=40,monster_level=30,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    -- [674] = {id=674,en="Foul Waters",ja="ファウルウォーター",element=5,icon_id=45,monster_level=1,prefix="/monsterskill",range=10,targets=32,tp_cost=1000},
    -- [675] = {id=675,en="Pestilent Plume",ja="ペステレントプルーム",element=7,icon_id=47,monster_level=10,prefix="/monsterskill",range=10,targets=32,tp_cost=1000},
    -- [676] = {id=676,en="Deadening Haze",ja="デッドヘイズ",element=5,icon_id=45,monster_level=20,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    -- [677] = {id=677,en="Venomous Vapor",ja="ヴェノムヴェイパー",element=5,icon_id=45,monster_level=30,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    -- [678] = {id=678,en="Retinal Glare",ja="レテナグレア",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    -- [679] = {id=679,en="Sylvan Slumber",ja="シルバンスランバー",element=7,icon_id=47,monster_level=10,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    -- [680] = {id=680,en="Crushing Gaze",ja="クラッシングゲイズ",element=2,icon_id=42,monster_level=20,prefix="/monsterskill",range=8,targets=32,tp_cost=1000},
    -- [681] = {id=681,en="Vaskania",ja="バスカニア",element=7,icon_id=47,monster_level=-1,prefix="/monsterskill",range=8,targets=32,tp_cost=9999},
    -- [682] = {id=682,en="Whirling Inferno",ja="W.インフェルノ",element=0,icon_id=40,monster_level=50,prefix="/monsterskill",range=9,targets=32,tp_cost=1800},
    -- [683] = {id=683,en="Benumbing Blaze",ja="ベナムブレイズ",element=0,icon_id=40,monster_level=99,prefix="/monsterskill",range=9,targets=32,tp_cost=2500},
    -- [688] = {id=688,en="Frizz",ja="メラ",element=0,icon_id=40,monster_level=1,prefix="/monsterskill",range=12,targets=32,tp_cost=1000},
    -- [689] = {id=689,en="Jittering Jig",ja="情熱の律動",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=1,tp_cost=700},
    -- [690] = {id=690,en="Romp",ja="ロンプ",element=6,icon_id=46,monster_level=10,prefix="/monsterskill",range=4,targets=32,tp_cost=700},
    -- [691] = {id=691,en="Frenetic Flurry",ja="熱狂撃",element=6,icon_id=46,monster_level=1,prefix="/monsterskill",range=2,targets=32,tp_cost=1500},
}




return l