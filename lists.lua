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

l.WS.MP_Drain = {
    [21]  = {id=21,en="Energy Steal",ja="エナジースティール",element=7,icon_id=596,prefix="/weaponskill",range=2,skill=2,skillchain_a="",skillchain_b="",skillchain_c="",targets=32},
    [22]  = {id=22,en="Energy Drain",ja="エナジードレイン",element=7,icon_id=596,prefix="/weaponskill",range=2,skill=2,skillchain_a="",skillchain_b="",skillchain_c="",targets=32},
    [163] = {id=163,en="Starlight",ja="スターライト",element=6,icon_id=628,prefix="/weaponskill",range=2,skill=11,skillchain_a="",skillchain_b="",skillchain_c="",targets=1},
    [164] = {id=164,en="Moonlight",ja="ムーンライト",element=6,icon_id=628,prefix="/weaponskill",range=2,skill=11,skillchain_a="",skillchain_b="",skillchain_c="",targets=1},
    [183] = {id=183,en="Spirit Taker",ja="スピリットテーカー",element=6,icon_id=631,prefix="/weaponskill",range=2,skill=12,skillchain_a="",skillchain_b="",skillchain_c="",targets=32},
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

l.Spell.Enspell_Type = {
    [1] = "Enfire",
    [2] = "Enblizzard",
    [3] = "Enaero",
    [4] = "Enstone",
    [5] = "Enthunder",
    [6] = "Enwater",
    [7] = "Enlight",
    [8] = "Endark",
    [21] = "Endrain",
    [22] = "Enaspir",
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

-- From spells.lua
l.Spell.Enspell = {
    [100] = {id=100,en="Enfire",ja="エンファイア",cast_time=3,duration=180,element=0,icon_id=172,icon_id_nq=0,levels={[5]=24},mp_cost=12,overwrites={100,101,102,103,104,105},prefix="/magic",range=0,recast=10,recast_id=100,requirements=1,skill=34,status=94,targets=1,type="WhiteMagic"},
    [101] = {id=101,en="Enblizzard",ja="エンブリザド",cast_time=3,duration=180,element=1,icon_id=173,icon_id_nq=1,levels={[5]=22},mp_cost=12,overwrites={100,101,102,103,104,105},prefix="/magic",range=0,recast=10,recast_id=101,requirements=1,skill=34,status=95,targets=1,type="WhiteMagic"},
    [102] = {id=102,en="Enaero",ja="エンエアロ",cast_time=3,duration=180,element=2,icon_id=174,icon_id_nq=2,levels={[5]=20},mp_cost=12,overwrites={100,101,102,103,104,105},prefix="/magic",range=0,recast=10,recast_id=102,requirements=1,skill=34,status=96,targets=1,type="WhiteMagic"},
    [103] = {id=103,en="Enstone",ja="エンストーン",cast_time=3,duration=180,element=3,icon_id=175,icon_id_nq=3,levels={[5]=18},mp_cost=12,overwrites={100,101,102,103,104,105},prefix="/magic",range=0,recast=10,recast_id=103,requirements=1,skill=34,status=97,targets=1,type="WhiteMagic"},
    [104] = {id=104,en="Enthunder",ja="エンサンダー",cast_time=3,duration=180,element=4,icon_id=176,icon_id_nq=4,levels={[5]=16},mp_cost=12,overwrites={100,101,102,103,104,105},prefix="/magic",range=0,recast=10,recast_id=104,requirements=1,skill=34,status=98,targets=1,type="WhiteMagic"},
    [105] = {id=105,en="Enwater",ja="エンウォータ",cast_time=3,duration=180,element=5,icon_id=177,icon_id_nq=5,levels={[5]=27},mp_cost=12,overwrites={100,101,102,103,104,105},prefix="/magic",range=0,recast=10,recast_id=105,requirements=1,skill=34,status=99,targets=1,type="WhiteMagic"},
}

-- From spells.lua
l.Spell.Spikes = {
    [249] = {id=249,en="Blaze Spikes",ja="ブレイズスパイク",cast_time=3,duration=180,element=0,icon_id=307,icon_id_nq=8,levels={[4]=10,[5]=20,[20]=30,[22]=45},mp_cost=8,prefix="/magic",range=0,recast=10,recast_id=249,requirements=0,skill=34,status=34,targets=1,type="BlackMagic"},
    [250] = {id=250,en="Ice Spikes",ja="アイススパイク",cast_time=3,duration=180,element=1,icon_id=308,icon_id_nq=9,levels={[4]=20,[5]=40,[20]=50,[22]=65},mp_cost=16,prefix="/magic",range=0,recast=10,recast_id=250,requirements=0,skill=34,status=35,targets=1,type="BlackMagic"},
    [251] = {id=251,en="Shock Spikes",ja="ショックスパイク",cast_time=3,duration=180,element=4,icon_id=306,icon_id_nq=12,levels={[4]=30,[5]=60,[20]=70,[22]=85},mp_cost=24,prefix="/magic",range=0,recast=10,recast_id=251,requirements=0,skill=34,status=38,targets=1,type="BlackMagic"},
    [277] = {id=277,en="Dread Spikes",ja="ドレッドスパイク",cast_time=3,duration=180,element=7,icon_id=309,icon_id_nq=15,levels={[8]=71},mp_cost=78,prefix="/magic",range=0,recast=52,recast_id=277,requirements=0,skill=37,status=173,targets=1,type="BlackMagic"},
}

-- From spells.lua
l.Spell.Enfeebling = {
    [56] = {id=56,en="Slow",ja="スロウ",cast_time=2,duration=180,element=3,icon_id=141,icon_id_nq=3,levels={[3]=13,[5]=13},mp_cost=15,prefix="/magic",range=12,recast=20,recast_id=56,requirements=0,skill=35,status=13,targets=32,type="WhiteMagic"},
    [58] = {id=58,en="Paralyze",ja="パライズ",cast_time=3,duration=120,element=1,icon_id=144,icon_id_nq=1,levels={[3]=4,[5]=6},mp_cost=6,prefix="/magic",range=12,recast=10,recast_id=58,requirements=0,skill=35,status=4,targets=32,type="WhiteMagic"},
    [59] = {id=59,en="Silence",ja="サイレス",cast_time=3,duration=120,element=2,icon_id=146,icon_id_nq=2,levels={[3]=15,[5]=18},mp_cost=16,prefix="/magic",range=12,recast=10,recast_id=59,requirements=0,skill=35,status=6,targets=32,type="WhiteMagic"},
    [79] = {id=79,en="Slow II",ja="スロウII",cast_time=3,duration=180,element=3,icon_id=142,icon_id_nq=3,levels={[5]=75},mp_cost=45,overwrites={56,344,345,346},prefix="/magic",range=12,recast=20,recast_id=79,requirements=0,skill=35,status=13,targets=32,type="WhiteMagic"},
    [80] = {id=80,en="Paralyze II",ja="パライズII",cast_time=3,duration=120,element=1,icon_id=145,icon_id_nq=1,levels={[5]=75},mp_cost=36,overwrites={58,341,342,343},prefix="/magic",range=12,recast=20,recast_id=80,requirements=0,skill=35,status=4,targets=32,type="WhiteMagic"},
    [98] = {id=98,en="Repose",ja="リポーズ",cast_time=3,duration=90,element=6,icon_id=159,icon_id_nq=6,levels={[3]=48},mp_cost=26,overwrites={253},prefix="/magic",range=12,recast=30,recast_id=98,requirements=0,skill=32,status=2,targets=32,type="WhiteMagic"},
    [112] = {id=112,en="Flash",ja="フラッシュ",cast_time=0.5,element=6,icon_id=158,icon_id_nq=6,levels={[3]=45,[7]=37,[22]=45},mp_cost=25,prefix="/magic",range=12,recast=45,recast_id=112,requirements=0,skill=32,targets=32,type="WhiteMagic"},
    [242] = {id=242,en="Absorb-ACC",ja="アブゾアキュル",cast_time=0.5,element=7,icon_id=326,icon_id_nq=15,levels={[8]=61},mp_cost=33,prefix="/magic",range=12,recast=60,recast_id=242,requirements=0,skill=37,targets=32,type="BlackMagic"},
    [243] = {id=243,en="Absorb-Attri",ja="アブゾアトリ",cast_time=0.5,element=7,icon_id=326,icon_id_nq=15,levels={[8]=91},mp_cost=33,prefix="/magic",range=12,recast=60,recast_id=243,requirements=0,skill=37,targets=32,type="BlackMagic"},
    [252] = {id=252,en="Stun",ja="スタン",cast_time=0.5,element=4,icon_id=317,icon_id_nq=12,levels={[4]=45,[8]=37},mp_cost=25,prefix="/magic",range=12,recast=45,recast_id=252,requirements=2,skill=37,targets=32,type="BlackMagic"},
    [253] = {id=253,en="Sleep",ja="スリプル",cast_time=2.5,duration=60,element=7,icon_id=310,icon_id_nq=15,levels={[4]=20,[5]=25,[8]=30,[20]=30,[21]=35},mp_cost=19,prefix="/magic",range=12,recast=30,recast_id=253,requirements=6,skill=35,status=2,targets=32,type="BlackMagic"},
    [254] = {id=254,en="Blind",ja="ブライン",cast_time=2,duration=180,element=7,icon_id=233,icon_id_nq=15,levels={[4]=4,[5]=8},mp_cost=5,prefix="/magic",range=12,recast=10,recast_id=254,requirements=2,skill=35,status=5,targets=32,type="BlackMagic"},
    [255] = {id=255,en="Break",ja="ブレイク",cast_time=3,duration=30,element=3,icon_id=221,icon_id_nq=11,levels={[4]=85,[5]=87,[8]=95,[20]=90},mp_cost=39,prefix="/magic",range=12,recast=30,recast_id=255,requirements=6,skill=35,status=7,targets=32,type="BlackMagic"},
    [256] = {id=256,en="Virus",ja="ウィルス",cast_time=1.5,element=0,icon_id=328,icon_id_nq=8,levels={[4]=1},mp_cost=10,prefix="/magic",range=12,recast=10,recast_id=256,requirements=0,skill=35,targets=32,type="BlackMagic",unlearnable=true},
    [257] = {id=257,en="Curse",ja="カーズ",cast_time=3,element=7,icon_id=329,icon_id_nq=15,levels={[4]=1},mp_cost=10,prefix="/magic",range=12,recast=10,recast_id=257,requirements=0,skill=37,status=9,targets=32,type="BlackMagic",unlearnable=true},
    [258] = {id=258,en="Bind",ja="バインド",cast_time=2,duration=60,element=1,icon_id=235,icon_id_nq=9,levels={[4]=7,[5]=11,[8]=20},mp_cost=8,prefix="/magic",range=12,recast=40,recast_id=258,requirements=2,skill=35,status=11,targets=32,type="BlackMagic"},
    [259] = {id=259,en="Sleep II",ja="スリプルII",cast_time=3,duration=90,element=7,icon_id=311,icon_id_nq=15,levels={[4]=41,[5]=46,[8]=56,[20]=65,[21]=70},mp_cost=29,overwrites={253,273},prefix="/magic",range=12,recast=30,recast_id=259,requirements=6,skill=35,status=2,targets=32,type="BlackMagic"},
    [260] = {id=260,en="Dispel",ja="ディスペル",cast_time=3,element=7,icon_id=316,icon_id_nq=15,levels={[5]=32,[20]=32},mp_cost=25,prefix="/magic",range=12,recast=10,recast_id=260,requirements=6,skill=35,targets=32,type="BlackMagic"},
    [266] = {id=266,en="Absorb-STR",ja="アブゾースト",cast_time=0.5,element=7,icon_id=326,icon_id_nq=15,levels={[8]=43},mp_cost=33,prefix="/magic",range=12,recast=60,recast_id=266,requirements=2,skill=37,targets=32,type="BlackMagic"},
    [267] = {id=267,en="Absorb-DEX",ja="アブゾデック",cast_time=0.5,element=7,icon_id=326,icon_id_nq=15,levels={[8]=41},mp_cost=33,prefix="/magic",range=12,recast=60,recast_id=267,requirements=2,skill=37,targets=32,type="BlackMagic"},
    [268] = {id=268,en="Absorb-VIT",ja="アブゾバイト",cast_time=0.5,element=7,icon_id=326,icon_id_nq=15,levels={[8]=35},mp_cost=33,prefix="/magic",range=12,recast=60,recast_id=268,requirements=2,skill=37,targets=32,type="BlackMagic"},
    [269] = {id=269,en="Absorb-AGI",ja="アブゾアジル",cast_time=0.5,element=7,icon_id=326,icon_id_nq=15,levels={[8]=37},mp_cost=33,prefix="/magic",range=12,recast=60,recast_id=269,requirements=2,skill=37,targets=32,type="BlackMagic"},
    [270] = {id=270,en="Absorb-INT",ja="アブゾイン",cast_time=0.5,element=7,icon_id=326,icon_id_nq=15,levels={[8]=39},mp_cost=33,prefix="/magic",range=12,recast=60,recast_id=270,requirements=2,skill=37,targets=32,type="BlackMagic"},
    [271] = {id=271,en="Absorb-MND",ja="アブゾマイン",cast_time=0.5,element=7,icon_id=326,icon_id_nq=15,levels={[8]=31},mp_cost=33,prefix="/magic",range=12,recast=60,recast_id=271,requirements=2,skill=37,targets=32,type="BlackMagic"},
    [272] = {id=272,en="Absorb-CHR",ja="アブゾカリス",cast_time=0.5,element=7,icon_id=326,icon_id_nq=15,levels={[8]=33},mp_cost=33,prefix="/magic",range=12,recast=60,recast_id=272,requirements=2,skill=37,targets=32,type="BlackMagic"},
    [273] = {id=273,en="Sleepga",ja="スリプガ",cast_time=3,duration=60,element=7,icon_id=312,icon_id_nq=15,levels={[4]=31},mp_cost=38,prefix="/magic",range=12,recast=30,recast_id=273,requirements=0,skill=35,status=2,targets=32,type="BlackMagic"},
    [274] = {id=274,en="Sleepga II",ja="スリプガII",cast_time=3.5,duration=90,element=7,icon_id=313,icon_id_nq=15,levels={[4]=56},mp_cost=58,overwrites={253,273},prefix="/magic",range=12,recast=45,recast_id=274,requirements=0,skill=35,status=2,targets=32,type="BlackMagic"},
    [275] = {id=275,en="Absorb-TP",ja="アブゾタック",cast_time=0.5,element=7,icon_id=326,icon_id_nq=15,levels={[8]=45},mp_cost=33,prefix="/magic",range=12,recast=60,recast_id=275,requirements=2,skill=37,targets=32,type="BlackMagic"},
    [276] = {id=276,en="Blind II",ja="ブラインII",cast_time=3,duration=180,element=7,icon_id=234,icon_id_nq=15,levels={[5]=75},mp_cost=31,overwrites={254,347,348,349},prefix="/magic",range=12,recast=20,recast_id=276,requirements=0,skill=35,status=5,targets=32,type="BlackMagic"},
    [286] = {id=286,en="Addle",ja="アドル",cast_time=2,duration=120,element=0,icon_id=171,icon_id_nq=0,levels={[3]=93,[5]=83},mp_cost=36,prefix="/magic",range=12,recast=20,recast_id=286,requirements=0,skill=35,status=21,targets=32,type="WhiteMagic"},
    [287] = {id=287,en="Klimaform",ja="虚誘掩殺の策",cast_time=3,duration=300,element=7,icon_id=551,icon_id_nq=15,levels={[20]=46},mp_cost=30,prefix="/magic",range=12,recast=52,recast_id=287,requirements=2,skill=37,status=407,targets=1,type="BlackMagic"},
    [319] = {id=319,en="Aisha: Ichi",ja="哀車の術:壱",cast_time=4,duration=120,element=5,icon_id=-1,icon_id_nq=29,levels={[13]=78},mp_cost=0,prefix="/ninjutsu",range=11,recast=30,recast_id=319,requirements=0,skill=39,status=147,targets=32,type="Ninjutsu"},
    [341] = {id=341,en="Jubaku: Ichi",ja="呪縛の術:壱",cast_time=4,element=1,icon_id=-1,icon_id_nq=25,levels={[13]=30},mp_cost=0,prefix="/ninjutsu",range=11,recast=30,recast_id=341,requirements=0,skill=39,status=4,targets=32,type="Ninjutsu"},
    [342] = {id=342,en="Jubaku: Ni",ja="呪縛の術:弐",cast_time=1.5,element=1,icon_id=-1,icon_id_nq=25,levels={[13]=55},mp_cost=0,overwrites={341},prefix="/ninjutsu",range=11,recast=45,recast_id=342,requirements=0,skill=39,status=4,targets=32,type="Ninjutsu",unlearnable=true},
    [343] = {id=343,en="Jubaku: San",ja="呪縛の術:参",cast_time=12,element=1,icon_id=-1,icon_id_nq=25,levels={},mp_cost=0,overwrites={341,342},prefix="/ninjutsu",range=11,recast=60,recast_id=343,requirements=0,skill=39,status=4,targets=32,type="Ninjutsu",unlearnable=true},
    [344] = {id=344,en="Hojo: Ichi",ja="捕縄の術:壱",cast_time=4,element=3,icon_id=-1,icon_id_nq=27,levels={[13]=23},mp_cost=0,prefix="/ninjutsu",range=11,recast=30,recast_id=344,requirements=0,skill=39,status=13,targets=32,type="Ninjutsu"},
    [345] = {id=345,en="Hojo: Ni",ja="捕縄の術:弐",cast_time=1.5,element=3,icon_id=-1,icon_id_nq=27,levels={[13]=48},mp_cost=0,overwrites={344},prefix="/ninjutsu",range=11,recast=45,recast_id=345,requirements=0,skill=39,status=13,targets=32,type="Ninjutsu"},
    [346] = {id=346,en="Hojo: San",ja="捕縄の術:参",cast_time=12,element=3,icon_id=-1,icon_id_nq=27,levels={[13]=73},mp_cost=0,overwrites={344,345},prefix="/ninjutsu",range=11,recast=60,recast_id=346,requirements=0,skill=39,status=13,targets=32,type="Ninjutsu",unlearnable=true},
    [347] = {id=347,en="Kurayami: Ichi",ja="暗闇の術:壱",cast_time=4,element=7,icon_id=-1,icon_id_nq=31,levels={[13]=19},mp_cost=0,prefix="/ninjutsu",range=11,recast=30,recast_id=347,requirements=0,skill=39,status=5,targets=32,type="Ninjutsu"},
    [348] = {id=348,en="Kurayami: Ni",ja="暗闇の術:弐",cast_time=1.5,element=7,icon_id=-1,icon_id_nq=31,levels={[13]=44},mp_cost=0,overwrites={347},prefix="/ninjutsu",range=11,recast=45,recast_id=348,requirements=0,skill=39,status=5,targets=32,type="Ninjutsu"},
    [349] = {id=349,en="Kurayami: San",ja="暗闇の術:参",cast_time=12,element=7,icon_id=-1,icon_id_nq=31,levels={[13]=69},mp_cost=0,overwrites={347,348},prefix="/ninjutsu",range=11,recast=60,recast_id=349,requirements=0,skill=39,status=5,targets=32,type="Ninjutsu",unlearnable=true},
    [365] = {id=365,en="Breakga",ja="ブレクガ",cast_time=3.5,duration=30,element=3,icon_id=222,icon_id_nq=11,levels={[4]=95},mp_cost=78,prefix="/magic",range=12,recast=45,recast_id=365,requirements=0,skill=35,status=7,targets=32,type="BlackMagic"},
    [366] = {id=366,en="Graviga",ja="グラビガ",cast_time=2,element=2,icon_id=-1,icon_id_nq=24,levels={},mp_cost=48,prefix="/magic",range=12,recast=60,recast_id=366,requirements=0,skill=35,targets=32,type="BlackMagic"},
    [376] = {id=376,en="Horde Lullaby",ja="魔物達のララバイ",cast_time=2,duration=45,element=6,icon_id=-1,icon_id_nq=38,levels={[10]=27},mp_cost=0,prefix="/song",range=11,recast=24,recast_id=376,requirements=0,skill=40,status=2,targets=32,type="BardSong"},
    [377] = {id=377,en="Horde Lullaby II",ja="魔物達のララバイII",cast_time=2,duration=90,element=6,icon_id=-1,icon_id_nq=38,levels={[10]=92},mp_cost=0,overwrites={376,463},prefix="/song",range=11,recast=24,recast_id=377,requirements=0,skill=40,status=2,targets=32,type="BardSong"},
    [421] = {id=421,en="Battlefield Elegy",ja="戦場のエレジー",cast_time=2,duration=120,element=3,icon_id=-1,icon_id_nq=35,levels={[10]=39},mp_cost=0,prefix="/song",range=12,recast=24,recast_id=421,requirements=0,skill=40,status=194,targets=32,type="BardSong"},
    [422] = {id=422,en="Carnage Elegy",ja="修羅のエレジー",cast_time=2,duration=180,element=3,icon_id=-1,icon_id_nq=35,levels={[10]=59},mp_cost=0,overwrites={421},prefix="/song",range=12,recast=24,recast_id=422,requirements=0,skill=40,status=194,targets=32,type="BardSong"},
    [423] = {id=423,en="Massacre Elegy",ja="地獄のエレジー",cast_time=2,duration=240,element=3,icon_id=-1,icon_id_nq=35,levels={},mp_cost=0,overwrites={421,422},prefix="/song",range=12,recast=24,recast_id=423,requirements=0,skill=40,status=194,targets=32,type="BardSong"},
    [454] = {id=454,en="Fire Threnody",ja="炎のスレノディ",cast_time=2,duration=60,element=5,icon_id=-1,icon_id_nq=37,levels={[10]=20},mp_cost=0,prefix="/song",range=12,recast=24,recast_id=454,requirements=0,skill=40,status=217,targets=32,type="BardSong"},
    [455] = {id=455,en="Ice Threnody",ja="氷のスレノディ",cast_time=2,duration=60,element=0,icon_id=-1,icon_id_nq=32,levels={[10]=22},mp_cost=0,prefix="/song",range=12,recast=24,recast_id=455,requirements=0,skill=40,status=217,targets=32,type="BardSong"},
    [456] = {id=456,en="Wind Threnody",ja="風のスレノディ",cast_time=2,duration=60,element=1,icon_id=-1,icon_id_nq=33,levels={[10]=18},mp_cost=0,prefix="/song",range=12,recast=24,recast_id=456,requirements=0,skill=40,status=217,targets=32,type="BardSong"},
    [457] = {id=457,en="Earth Threnody",ja="土のスレノディ",cast_time=2,duration=60,element=2,icon_id=-1,icon_id_nq=34,levels={[10]=14},mp_cost=0,prefix="/song",range=12,recast=24,recast_id=457,requirements=0,skill=40,status=217,targets=32,type="BardSong"},
    [458] = {id=458,en="Ltng. Threnody",ja="雷のスレノディ",cast_time=2,duration=60,element=3,icon_id=-1,icon_id_nq=35,levels={[10]=24},mp_cost=0,prefix="/song",range=12,recast=24,recast_id=458,requirements=0,skill=40,status=217,targets=32,type="BardSong"},
    [459] = {id=459,en="Water Threnody",ja="水のスレノディ",cast_time=2,duration=60,element=4,icon_id=-1,icon_id_nq=36,levels={[10]=16},mp_cost=0,prefix="/song",range=12,recast=24,recast_id=459,requirements=0,skill=40,status=217,targets=32,type="BardSong"},
    [460] = {id=460,en="Light Threnody",ja="光のスレノディ",cast_time=2,duration=60,element=7,icon_id=-1,icon_id_nq=39,levels={[10]=10},mp_cost=0,prefix="/song",range=12,recast=24,recast_id=460,requirements=0,skill=40,status=217,targets=32,type="BardSong"},
    [461] = {id=461,en="Dark Threnody",ja="闇のスレノディ",cast_time=2,duration=60,element=6,icon_id=-1,icon_id_nq=38,levels={[10]=12},mp_cost=0,prefix="/song",range=12,recast=24,recast_id=461,requirements=0,skill=40,status=217,targets=32,type="BardSong"},
    [462] = {id=462,en="Magic Finale",ja="魔法のフィナーレ",cast_time=2,element=6,icon_id=-1,icon_id_nq=38,levels={[10]=33},mp_cost=0,prefix="/song",range=12,recast=24,recast_id=462,requirements=0,skill=40,targets=32,type="BardSong"},
    [463] = {id=463,en="Foe Lullaby",ja="魔物のララバイ",cast_time=2,duration=45,element=6,icon_id=-1,icon_id_nq=38,levels={[10]=16},mp_cost=0,prefix="/song",range=12,recast=24,recast_id=463,requirements=0,skill=40,status=2,targets=32,type="BardSong"},
    [471] = {id=471,en="Foe Lullaby II",ja="魔物のララバイII",cast_time=2,duration=90,element=6,icon_id=-1,icon_id_nq=38,levels={[10]=83},mp_cost=0,overwrites={376,463},prefix="/song",range=12,recast=24,recast_id=471,requirements=0,skill=40,status=2,targets=32,type="BardSong"},
    [472] = {id=472,en="Pining Nocturne",ja="恋情のノクターン",cast_time=2,duration=120,element=0,icon_id=-1,icon_id_nq=32,levels={[10]=95},mp_cost=0,prefix="/song",range=12,recast=24,recast_id=472,requirements=0,skill=40,status=223,targets=32,type="BardSong"},
    [508] = {id=508,en="Yurin: Ichi",ja="幽林の術:壱",cast_time=4,element=7,icon_id=-1,icon_id_nq=31,levels={[13]=83},mp_cost=0,prefix="/ninjutsu",range=11,recast=30,recast_id=508,requirements=0,skill=39,status=168,targets=32,type="Ninjutsu"},
}

l.Spell.DoT = {
    [23]  = {id=23,en="Dia",ja="ディア",cast_time=1,duration=60,element=6,icon_id=99,icon_id_nq=6,levels={[3]=3,[5]=1},mp_cost=7,prefix="/magic",range=12,recast=5,recast_id=23,requirements=0,skill=35,status=134,targets=32,type="WhiteMagic"},
    [24]  = {id=24,en="Dia II",ja="ディアII",cast_time=1.5,duration=120,element=6,icon_id=100,icon_id_nq=6,levels={[3]=36,[5]=31},mp_cost=30,overwrites={23,230},prefix="/magic",range=12,recast=6,recast_id=24,requirements=0,skill=35,status=134,targets=32,type="WhiteMagic"},
    [25]  = {id=25,en="Dia III",ja="ディアIII",cast_time=2,duration=180,element=6,icon_id=202,icon_id_nq=6,levels={[5]=75},mp_cost=45,overwrites={23,24,230,231},prefix="/magic",range=12,recast=7,recast_id=25,requirements=0,skill=35,status=134,targets=32,type="WhiteMagic"},
    [26]  = {id=26,en="Dia IV",ja="ディアIV",cast_time=2.5,duration=90,element=6,icon_id=-1,icon_id_nq=6,levels={},mp_cost=164,overwrites={23,24,25,230,231,232},prefix="/magic",range=12,recast=8,recast_id=26,requirements=0,skill=35,status=134,targets=32,type="WhiteMagic"},
    [27]  = {id=27,en="Dia V",ja="ディアV",cast_time=3,element=6,icon_id=-1,icon_id_nq=6,levels={},mp_cost=217,prefix="/magic",range=12,recast=9,recast_id=27,requirements=0,skill=35,targets=32,type="WhiteMagic"},
    [33]  = {id=33,en="Diaga",ja="ディアガ",cast_time=1.5,element=6,icon_id=101,icon_id_nq=6,levels={[3]=18,[5]=15},mp_cost=12,prefix="/magic",range=12,recast=6,recast_id=33,requirements=0,skill=35,targets=32,type="WhiteMagic"},
    [34]  = {id=34,en="Diaga II",ja="ディアガII",cast_time=1.75,element=6,icon_id=-1,icon_id_nq=6,levels={[3]=52,[5]=45},mp_cost=60,prefix="/magic",range=12,recast=6.25,recast_id=34,requirements=0,skill=35,targets=32,type="WhiteMagic",unlearnable=true},
    [35]  = {id=35,en="Diaga III",ja="ディアガIII",cast_time=2,element=6,icon_id=-1,icon_id_nq=6,levels={[5]=75},mp_cost=120,prefix="/magic",range=12,recast=6.5,recast_id=35,requirements=0,skill=35,targets=32,type="WhiteMagic",unlearnable=true},
    [36]  = {id=36,en="Diaga IV",ja="ディアガIV",cast_time=2.25,element=6,icon_id=-1,icon_id_nq=6,levels={},mp_cost=180,prefix="/magic",range=12,recast=6.75,recast_id=36,requirements=0,skill=35,targets=32,type="WhiteMagic"},
    [37]  = {id=37,en="Diaga V",ja="ディアガV",cast_time=2.5,element=6,icon_id=-1,icon_id_nq=6,levels={},mp_cost=240,prefix="/magic",range=12,recast=7,recast_id=37,requirements=0,skill=35,targets=32,type="WhiteMagic"},
    [220] = {id=220,en="Poison",ja="ポイズン",cast_time=1,duration=90,element=5,icon_id=223,icon_id_nq=13,levels={[4]=3,[5]=5,[8]=6},mp_cost=5,prefix="/magic",range=12,recast=5,recast_id=220,requirements=2,skill=35,status=3,targets=32,type="BlackMagic"},
    [221] = {id=221,en="Poison II",ja="ポイズンII",cast_time=1,duration=120,element=5,icon_id=224,icon_id_nq=13,levels={[4]=43,[5]=46,[8]=46},mp_cost=38,overwrites={220,350,351,352},prefix="/magic",range=12,recast=5,recast_id=221,requirements=2,skill=35,status=3,targets=32,type="BlackMagic"},
    [222] = {id=222,en="Poison III",ja="ポイズンIII",cast_time=1,element=5,icon_id=225,icon_id_nq=13,levels={},mp_cost=72,prefix="/magic",range=12,recast=5,recast_id=222,requirements=0,skill=35,targets=32,type="BlackMagic"},
    [223] = {id=223,en="Poison IV",ja="ポイズンIV",cast_time=1,element=5,icon_id=226,icon_id_nq=13,levels={},mp_cost=106,prefix="/magic",range=12,recast=5,recast_id=223,requirements=0,skill=35,targets=32,type="BlackMagic"},
    [224] = {id=224,en="Poison V",ja="ポイズンV",cast_time=1,element=5,icon_id=227,icon_id_nq=13,levels={},mp_cost=140,prefix="/magic",range=12,recast=5,recast_id=224,requirements=0,skill=35,targets=32,type="BlackMagic"},
    [225] = {id=225,en="Poisonga",ja="ポイゾガ",cast_time=2,element=5,icon_id=228,icon_id_nq=13,levels={[4]=24,[8]=26},mp_cost=44,prefix="/magic",range=12,recast=10,recast_id=225,requirements=0,skill=35,targets=32,type="BlackMagic"},
    [226] = {id=226,en="Poisonga II",ja="ポイゾガII",cast_time=2,element=5,icon_id=229,icon_id_nq=13,levels={[4]=64,[8]=66},mp_cost=112,prefix="/magic",range=12,recast=10,recast_id=226,requirements=0,skill=35,targets=32,type="BlackMagic",unlearnable=true},
    [227] = {id=227,en="Poisonga III",ja="ポイゾガIII",cast_time=2,element=5,icon_id=230,icon_id_nq=13,levels={},mp_cost=180,prefix="/magic",range=12,recast=10,recast_id=227,requirements=0,skill=35,targets=32,type="BlackMagic"},
    [228] = {id=228,en="Poisonga IV",ja="ポイゾガIV",cast_time=2,element=5,icon_id=231,icon_id_nq=13,levels={},mp_cost=248,prefix="/magic",range=12,recast=10,recast_id=228,requirements=0,skill=35,targets=32,type="BlackMagic"},
    [229] = {id=229,en="Poisonga V",ja="ポイゾガV",cast_time=2,element=5,icon_id=232,icon_id_nq=13,levels={},mp_cost=314,prefix="/magic",range=12,recast=10,recast_id=229,requirements=0,skill=35,targets=32,type="BlackMagic"},
    [230] = {id=230,en="Bio",ja="バイオ",cast_time=1.5,duration=60,element=7,icon_id=291,icon_id_nq=15,levels={[4]=10,[5]=10,[8]=15},mp_cost=15,overwrites={23},prefix="/magic",range=12,recast=5,recast_id=230,requirements=2,skill=37,status=135,targets=32,type="BlackMagic"},
    [231] = {id=231,en="Bio II",ja="バイオII",cast_time=1.5,duration=120,element=7,icon_id=292,icon_id_nq=15,levels={[4]=35,[5]=36,[8]=40},mp_cost=36,overwrites={23,24,230},prefix="/magic",range=12,recast=5,recast_id=231,requirements=2,skill=37,status=135,targets=32,type="BlackMagic"},
    [232] = {id=232,en="Bio III",ja="バイオIII",cast_time=1.5,duration=30,element=7,icon_id=293,icon_id_nq=15,levels={[5]=75},mp_cost=54,overwrites={23,24,25,230,231},prefix="/magic",range=12,recast=15,recast_id=232,requirements=0,skill=37,status=135,targets=32,type="BlackMagic"},
    [233] = {id=233,en="Bio IV",ja="バイオIV",cast_time=1.5,element=7,icon_id=294,icon_id_nq=15,levels={},mp_cost=154,prefix="/magic",range=12,recast=5,recast_id=233,requirements=0,skill=37,targets=32,type="BlackMagic"},
    [234] = {id=234,en="Bio V",ja="バイオV",cast_time=1.5,element=7,icon_id=295,icon_id_nq=15,levels={},mp_cost=197,prefix="/magic",range=12,recast=5,recast_id=234,requirements=0,skill=37,targets=32,type="BlackMagic"},
    [235] = {id=235,en="Burn",ja="バーン",cast_time=2.5,duration=90,element=0,icon_id=304,icon_id_nq=8,levels={[4]=24},mp_cost=25,overwrites={236},prefix="/magic",range=12,recast=10,recast_id=235,requirements=0,skill=36,status=128,targets=32,type="BlackMagic"},
    [236] = {id=236,en="Frost",ja="フロスト",cast_time=2.5,duration=90,element=1,icon_id=301,icon_id_nq=9,levels={[4]=22},mp_cost=25,overwrites={237},prefix="/magic",range=12,recast=10,recast_id=236,requirements=0,skill=36,status=129,targets=32,type="BlackMagic"},
    [237] = {id=237,en="Choke",ja="チョーク",cast_time=2.5,duration=90,element=2,icon_id=303,icon_id_nq=10,levels={[4]=20},mp_cost=25,overwrites={238},prefix="/magic",range=12,recast=10,recast_id=237,requirements=0,skill=36,status=130,targets=32,type="BlackMagic"},
    [238] = {id=238,en="Rasp",ja="ラスプ",cast_time=2.5,duration=90,element=3,icon_id=300,icon_id_nq=11,levels={[4]=18},mp_cost=25,overwrites={239},prefix="/magic",range=12,recast=10,recast_id=238,requirements=0,skill=36,status=131,targets=32,type="BlackMagic"},
    [239] = {id=239,en="Shock",ja="ショック",cast_time=2.5,duration=90,element=4,icon_id=302,icon_id_nq=12,levels={[4]=16},mp_cost=25,overwrites={240},prefix="/magic",range=12,recast=10,recast_id=239,requirements=0,skill=36,status=132,targets=32,type="BlackMagic"},
    [240] = {id=240,en="Drown",ja="ドラウン",cast_time=2.5,duration=90,element=5,icon_id=305,icon_id_nq=13,levels={[4]=27},mp_cost=25,overwrites={235},prefix="/magic",range=12,recast=10,recast_id=240,requirements=0,skill=36,status=133,targets=32,type="BlackMagic"},
    [278] = {id=278,en="Geohelix",ja="土門の計",cast_time=5,duration=230,element=3,icon_id=566,icon_id_nq=11,levels={[20]=18},mp_cost=26,prefix="/magic",range=12,recast=45,recast_id=278,requirements=0,skill=36,status=186,targets=32,type="BlackMagic"},
    [279] = {id=279,en="Hydrohelix",ja="水門の計",cast_time=5,duration=230,element=5,icon_id=568,icon_id_nq=13,levels={[20]=20},mp_cost=26,prefix="/magic",range=12,recast=45,recast_id=279,requirements=0,skill=36,status=186,targets=32,type="BlackMagic"},
    [280] = {id=280,en="Anemohelix",ja="風門の計",cast_time=5,duration=230,element=2,icon_id=565,icon_id_nq=10,levels={[20]=22},mp_cost=26,prefix="/magic",range=12,recast=45,recast_id=280,requirements=0,skill=36,status=186,targets=32,type="BlackMagic"},
    [281] = {id=281,en="Pyrohelix",ja="火門の計",cast_time=5,duration=230,element=0,icon_id=563,icon_id_nq=8,levels={[20]=24},mp_cost=26,prefix="/magic",range=12,recast=45,recast_id=281,requirements=0,skill=36,status=186,targets=32,type="BlackMagic"},
    [282] = {id=282,en="Cryohelix",ja="氷門の計",cast_time=5,duration=230,element=1,icon_id=564,icon_id_nq=9,levels={[20]=26},mp_cost=26,prefix="/magic",range=12,recast=45,recast_id=282,requirements=0,skill=36,status=186,targets=32,type="BlackMagic"},
    [283] = {id=283,en="Ionohelix",ja="雷門の計",cast_time=5,duration=230,element=4,icon_id=567,icon_id_nq=12,levels={[20]=28},mp_cost=26,prefix="/magic",range=12,recast=45,recast_id=283,requirements=0,skill=36,status=186,targets=32,type="BlackMagic"},
    [284] = {id=284,en="Noctohelix",ja="闇門の計",cast_time=5,duration=230,element=7,icon_id=570,icon_id_nq=15,levels={[20]=30},mp_cost=26,prefix="/magic",range=12,recast=45,recast_id=284,requirements=0,skill=36,status=186,targets=32,type="BlackMagic"},
    [285] = {id=285,en="Luminohelix",ja="光門の計",cast_time=5,duration=230,element=6,icon_id=569,icon_id_nq=14,levels={[20]=32},mp_cost=26,prefix="/magic",range=12,recast=45,recast_id=285,requirements=0,skill=36,status=186,targets=32,type="BlackMagic"},
    [350] = {id=350,en="Dokumori: Ichi",ja="毒盛の術:壱",cast_time=4,element=5,icon_id=-1,icon_id_nq=29,levels={[13]=27},mp_cost=0,prefix="/ninjutsu",range=11,recast=30,recast_id=350,requirements=0,skill=39,status=3,targets=32,type="Ninjutsu"},
    [351] = {id=351,en="Dokumori: Ni",ja="毒盛の術:弐",cast_time=1.5,element=5,icon_id=-1,icon_id_nq=29,levels={[13]=52},mp_cost=0,overwrites={350},prefix="/ninjutsu",range=11,recast=45,recast_id=351,requirements=0,skill=39,status=3,targets=32,type="Ninjutsu",unlearnable=true},
    [352] = {id=352,en="Dokumori: San",ja="毒盛の術:参",cast_time=12,element=5,icon_id=-1,icon_id_nq=29,levels={},mp_cost=0,overwrites={350,351},prefix="/ninjutsu",range=11,recast=60,recast_id=352,requirements=0,skill=39,status=3,targets=32,type="Ninjutsu",unlearnable=true},
    [368] = {id=368,en="Foe Requiem",ja="魔物のレクイエム",cast_time=2,duration=60,element=6,icon_id=-1,icon_id_nq=38,levels={[10]=7},mp_cost=0,prefix="/song",range=11,recast=24,recast_id=368,requirements=0,skill=40,status=192,targets=32,type="BardSong"},
    [369] = {id=369,en="Foe Requiem II",ja="魔物のレクイエムII",cast_time=2,duration=120,element=6,icon_id=-1,icon_id_nq=38,levels={[10]=17},mp_cost=0,overwrites={368},prefix="/song",range=11,recast=24,recast_id=369,requirements=0,skill=40,status=192,targets=32,type="BardSong"},
    [370] = {id=370,en="Foe Requiem III",ja="魔物のレクイエムIII",cast_time=2,duration=120,element=6,icon_id=-1,icon_id_nq=38,levels={[10]=37},mp_cost=0,overwrites={368,369},prefix="/song",range=11,recast=24,recast_id=370,requirements=0,skill=40,status=192,targets=32,type="BardSong"},
    [371] = {id=371,en="Foe Requiem IV",ja="魔物のレクイエムIV",cast_time=2,duration=120,element=6,icon_id=-1,icon_id_nq=38,levels={[10]=47},mp_cost=0,overwrites={368,369,370},prefix="/song",range=11,recast=24,recast_id=371,requirements=0,skill=40,status=192,targets=32,type="BardSong"},
    [372] = {id=372,en="Foe Requiem V",ja="魔物のレクイエムV",cast_time=2,duration=120,element=6,icon_id=-1,icon_id_nq=38,levels={[10]=57},mp_cost=0,overwrites={368,369,370,371},prefix="/song",range=11,recast=24,recast_id=372,requirements=0,skill=40,status=192,targets=32,type="BardSong"},
    [373] = {id=373,en="Foe Requiem VI",ja="魔物のレクイエムVI",cast_time=2,duration=120,element=6,icon_id=-1,icon_id_nq=38,levels={[10]=67},mp_cost=0,overwrites={368,369,370,371,372},prefix="/song",range=11,recast=24,recast_id=373,requirements=0,skill=40,status=192,targets=32,type="BardSong"},
    [374] = {id=374,en="Foe Requiem VII",ja="魔物のレクイエムVII",cast_time=2,duration=120,element=6,icon_id=-1,icon_id_nq=38,levels={[10]=76},mp_cost=0,overwrites={368,369,370,371,372,373},prefix="/song",range=11,recast=24,recast_id=374,requirements=0,skill=40,status=192,targets=32,type="BardSong"},
    [375] = {id=375,en="Foe Requiem VIII",ja="魔物のレクイエムVIII",cast_time=2,duration=120,element=6,icon_id=-1,icon_id_nq=38,levels={},mp_cost=0,overwrites={368,369,370,371,372,373,374},prefix="/song",range=11,recast=24,recast_id=375,requirements=0,skill=40,status=192,targets=32,type="BardSong"},
}

l.Spell.MP_Drain = {
    [247] = {id=247,en="Aspir",ja="アスピル",cast_time=3,element=7,icon_id=238,icon_id_nq=15,levels={[4]=25,[8]=20,[20]=36,[21]=30},mp_cost=10,prefix="/magic",range=12,recast=60,recast_id=247,requirements=2,skill=37,targets=32,type="BlackMagic"},
    [248] = {id=248,en="Aspir II",ja="アスピルII",cast_time=3,element=7,icon_id=239,icon_id_nq=15,levels={[4]=83,[8]=78,[20]=97,[21]=90},mp_cost=5,prefix="/magic",range=12,recast=11,recast_id=248,requirements=2,skill=37,targets=32,type="BlackMagic"},
    [881] = {id=881,en="Aspir III",ja="アスピルIII",cast_time=3,element=7,icon_id=657,icon_id_nq=15,levels={[4]=550,[21]=550},mp_cost=2,prefix="/magic",range=12,recast=26,recast_id=881,requirements=0,skill=37,targets=32,type="BlackMagic"},
}

l.Spell.AOE = {
    [7]   = {id = 7,   en = "Curaga"},
    [8]   = {id = 8,   en = "Curaga II"},
    [9]   = {id = 9,   en = "Curaga III"},
    [10]  = {id = 10,  en = "Curaga IV"},
    [11]  = {id = 11,  en = "Curaga V"},
    [38]  = {id = 38,  en = "Banishga"},
    [39]  = {id = 39,  en = "Banishga II"},
    [40]  = {id = 40,  en = "Banishga III"},
    [41]  = {id = 41,  en = "Banishga IV"},
    [42]  = {id = 42,  en = "Banishga V"},
    [174] = {id = 174, en = "Firaga"},
    [175] = {id = 175, en = "Firaga II"},
    [176] = {id = 176, en = "Firaga III"},
    [177] = {id = 177, en = "Firaga IV"},
    [178] = {id = 178, en = "Firaga V"},
    [496] = {id = 496, en = "Firaja"},
    [179] = {id = 179, en = "Blizzaga"},
    [180] = {id = 180, en = "Blizzaga II"},
    [181] = {id = 181, en = "Blizzaga III"},
    [182] = {id = 182, en = "Blizzaga IV"},
    [183] = {id = 183, en = "Blizzaga V"},
    [497] = {id = 497, en = "Blizzaja"},
    [184] = {id = 184, en = "Aeroga"},
    [185] = {id = 185, en = "Aeroga II"},
    [186] = {id = 186, en = "Aeroga III"},
    [187] = {id = 187, en = "Aeroga IV"},
    [188] = {id = 188, en = "Aeroga V"},
    [498] = {id = 498, en = "Aeroja"},
    [189] = {id = 189, en = "Stonega"},
    [190] = {id = 190, en = "Stonega II"},
    [191] = {id = 191, en = "Stonega III"},
    [192] = {id = 192, en = "Stonega IV"},
    [193] = {id = 193, en = "Stonega V"},
    [499] = {id = 499, en = "Stoneja"},
    [194] = {id = 194, en = "Thundaga"},
    [195] = {id = 195, en = "Thundaga II"},
    [196] = {id = 196, en = "Thundaga III"},
    [197] = {id = 197, en = "Thundaga IV"},
    [198] = {id = 198, en = "Thundaga V"},
    [500] = {id = 500, en = "Thundaja"},
    [199] = {id = 199, en = "Waterga"},
    [200] = {id = 200, en = "Waterga II"},
    [201] = {id = 201, en = "Waterga III"},
    [202] = {id = 202, en = "Waterga IV"},
    [203] = {id = 203, en = "Waterga V"},
    [501] = {id = 501, en = "Waterja"},
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
    [833] = {id=833,en="Lunar Cry",ja="ルナークライ"},
    [834] = {id=834,en="Ecliptic Growl",ja="上弦の唸り"},
    [835] = {id=835,en="Lunar Roar",ja="ルナーロア"},
    [837] = {id=837,en="Ecliptic Howl",ja="下弦の咆哮"},
    -- Ifrit
    [844] = {id=844,en="Crimson Roar",ja="紅蓮の咆哮"},
    -- Titan
    [853] = {id=853,en="Earthen Ward",ja="大地の守り"},
    -- Leviathan (Spring Water is Refresh on Horizon)
    [861] = {id=861,en="Spring Water",ja="湧水"},
    [862] = {id=862,en="Slowga",ja="スロウガ"},
    -- Garuda
    [869] = {id=869,en="Whispering Wind",ja="風の囁き"},
    [870] = {id=870,en="Hastega",ja="ヘイスガ"},
    [871] = {id=871,en="Aerial Armor",ja="真空の鎧"},
    -- Shiva
    [878] = {id=878,en="Frost Armor",ja="凍てつく鎧"},
    [879] = {id=879,en="Sleepga",ja="スリプガ"},
    -- Ramuh
    [887] = {id=887,en="Rolling Thunder",ja="雷鼓"},
    [889] = {id=889,en="Lightning Armor",ja="雷電の鎧"},
    -- Carbuncle
    [906] = {id=906,en="Healing Ruby",ja="ルビーの癒し"},
    [908] = {id=908,en="Shining Ruby",ja="ルビーの輝き"},
    [909] = {id=909,en="Glittering Ruby",ja="ルビーの煌き"},
    [911] = {id=911,en="Healing Ruby II",ja="ルビーの癒しII"},
    -- Diabolos
    [1904] = {id=1904,en="Somnolence",ja="ソムノレンス"},
    [1905] = {id=1905,en="Noctoshield",ja="ノクトシールド"},
    [1906] = {id=1906,en="Ultimate Terror",ja="アルティメットテラー"},
    [1907] = {id=1907,en="Dream Shroud",ja="ドリームシュラウド"},
    [1908] = {id=1908,en="Nightmare",ja="ナイトメア"},
}

l.Ability.Avatar_Healing = {
    -- Garuda
    [869] = {id=869,en="Whispering Wind",ja="風の囁き"},
    -- Carbuncle
    [906] = {id=906,en="Healing Ruby",ja="ルビーの癒し"},
    [911] = {id=911,en="Healing Ruby II",ja="ルビーの癒しII"},
}

l.Ability.Rage = {
    -- Fenrir
    [831] = {id=831,en="Moonlit Charge",ja="ムーンリットチャージ"},
    [832] = {id=832,en="Crescent Fang",ja="クレセントファング"},
    [836] = {id=836,en="Eclipse Bite",ja="エクリプスバイト"},
    [838] = {id=838,en="Howling Moon",ja="（ハウリングムーン）",skillchain_a="Darkness",skillchain_b="Distortion",skillchain_c=""},
    [839] = {id=839,en="Howling Moon",ja="ハウリングムーン",skillchain_a="Darkness",skillchain_b="Distortion",skillchain_c=""},
    -- Ifrit
    [840] = {id=840,en="Punch",ja="パンチ"},
    [841] = {id=841,en="Fire II",ja="ファイアII"},
    [842] = {id=842,en="Burning Strike",ja="バーニングストライク"},
    [843] = {id=843,en="Double Punch",ja="ダブルパンチ"},
    [845] = {id=845,en="Fire IV",ja="ファイアIV"},
    [846] = {id=846,en="Flaming Crush",ja="フレイムクラッシュ"},
    [847] = {id=847,en="Meteor Strike",ja="メテオストライク"},
    [848] = {id=848,en="Inferno",ja="インフェルノ"},
    -- Titan
    [849] = {id=849,en="Rock Throw",ja="ロックスロー"},
    [850] = {id=850,en="Stone II",ja="ストーンII"},
    [851] = {id=851,en="Rock Buster",ja="ロックバスター"},
    [852] = {id=852,en="Megalith Throw",ja="メガリススロー"},
    [854] = {id=854,en="Stone IV",ja="ストーンIV"},
    [855] = {id=855,en="Mountain Buster",ja="マウンテンバスター"},
    [856] = {id=856,en="Geocrush",ja="ジオクラッシュ"},
    [857] = {id=857,en="Earthen Fury",ja="アースフューリー"},
    -- Leviathan
    [858] = {id=858,en="Barracuda Dive",ja="バラクーダダイブ"},
    [859] = {id=859,en="Water II",ja="ウォータII"},
    [860] = {id=860,en="Tail Whip",ja="テールウィップ"},
    [863] = {id=863,en="Water IV",ja="ウォータIV"},
    [864] = {id=864,en="Spinning Dive",ja="スピニングダイブ"},
    [865] = {id=865,en="Grand Fall",ja="グランドフォール"},
    [866] = {id=866,en="Tidal Wave",ja="タイダルウェイブ"},
    -- Garuda
    [867] = {id=867,en="Claw",ja="クロー"},
    [868] = {id=868,en="Aero II",ja="エアロII"},
    [872] = {id=872,en="Aero IV",ja="エアロIV"},
    [873] = {id=873,en="Predator Claws",ja="プレデタークロー"},
    [874] = {id=874,en="Wind Blade",ja="ウインドブレード"},
    [875] = {id=875,en="Aerial Blast",ja="エリアルブラスト"},
    -- Shiva
    [876] = {id=876,en="Axe Kick",ja="アクスキック"},
    [877] = {id=877,en="Blizzard II",ja="ブリザドII"},
    [880] = {id=880,en="Double Slap",ja="ダブルスラップ"},
    [881] = {id=881,en="Blizzard IV",ja="ブリザドIV"},
    [882] = {id=882,en="Rush",ja="ラッシュ"},
    [883] = {id=883,en="Heavenly Strike",ja="ヘヴンリーストライク"},
    [884] = {id=884,en="Diamond Dust",ja="ダイヤモンドダスト"},
    -- Ramuh
    [885] = {id=885,en="Shock Strike",ja="ショックストライク"},
    [886] = {id=886,en="Thunder II",ja="サンダーII"},
    [888] = {id=888,en="Thunderspark",ja="サンダースパーク"},
    [890] = {id=890,en="Thunder IV",ja="サンダーIV"},
    [891] = {id=891,en="Chaotic Strike",ja="カオスストライク"},
    [892] = {id=892,en="Thunderstorm",ja="サンダーストーム"},
    [893] = {id=893,en="Judgment Bolt",ja="ジャッジボルト"},
    -- Carbuncle
    [907] = {id=907,en="Poison Nails",ja="ポイズンネイル"},
    [910] = {id=910,en="Meteorite",ja="プチメテオ"},
    [912] = {id=912,en="Searing Light",ja="シアリングライト"},
    -- Diabolos
    [1903] = {id=1903,en="Camisado",ja="カミサドー"},
    [1909] = {id=1909,en="Cacodemonia",ja="カコデモニア"},
    [1910] = {id=1910,en="Nether Blast",ja="ネザーブラスト"},
    [1911] = {id=1911,en="Ruinous Omen",ja="ルイナスオーメン"},
    [3554] = {id=3554,en="Night Terror",ja="ナイトテラー"},
    [3555] = {id=3555,en="Ruinous Omen",ja="ルイナスオーメン"},
}

-- Derived from monster_abilities.lua
l.Ability.Pet_Damaging = {
    -- Rabbit
    [257] = {id=257,en="Foot Kick",ja="フットキック"},
    [258] = {id=258,en="Dust Cloud",ja="土煙"},
    [259] = {id=259,en="Whirl Claws",ja="爪旋風脚"},
    -- Sheep
    [260] = {id=260,en="Lamb Chop",ja="頭突き"},
    [262] = {id=262,en="Sheep Charge",ja="シープチャージ"},
    -- Ram
    [266] = {id=266,en="Ram Charge",ja="ラムチャージ"},
    [267] = {id=267,en="Rumble",ja="地鳴り"},
    [268] = {id=268,en="Great Bleat",ja="大咆哮"},
    [269] = {id=269,en="Petribreath",ja="ペトロブレス"},
    -- Tiger
    [271] = {id=271,en="Razor Fang",ja="レイザーファング"},
    [273] = {id=273,en="Claw Cyclone",ja="クローサイクロン"},
    -- Sheep
    [274] = {id=274,en="Sheep Charge",ja="シープチャージ"},
    -- Antlion
    [275] = {id=275,en="Sandblast",ja="サンドブラスト"},
    [276] = {id=276,en="Sandpit",ja="サンドピット"},
    [277] = {id=277,en="Venom Spray",ja="ベノムスプレー"},
    [279] = {id=279,en="Mandibular Bite",ja="マンディビュラバイト"},
    -- Dhalmel
    [281] = {id=281,en="Stomping",ja="ストンピング"},
    -- Opo-opo
    [288] = {id=288,en="Vicious Claw",ja="ビシャスクロー"},
    [289] = {id=289,en="Stone Throw",ja="投石"},
    [290] = {id=290,en="Spinning Claw",ja="スピニングクロー"},
    [291] = {id=291,en="Claw Storm",ja="クローストーム"},
    [294] = {id=294,en="Eye Scratch",ja="アイスクラッチ"},
    -- Treant
    [296] = {id=296,en="Drill Branch",ja="ドリルブランチ"},
    [297] = {id=297,en="Pinecone Bomb",ja="まつぼっくり爆弾"},
    [298] = {id=298,en="Leafstorm",ja="リーフストーム"},
    [299] = {id=299,en="Entangle",ja="エンタングル"},
    -- Mandragora
    [300] = {id=300,en="Head Butt",ja="ヘッドバット"},
    [302] = {id=302,en="Wild Oats",ja="種まき"},
    [305] = {id=305,en="Leaf Dagger",ja="リーフダガー"},
    -- Funguar
    [308] = {id=308,en="Frogkick",ja="フロッグキック"},
    [310] = {id=310,en="Queasyshroom",ja="マヨイタケ"},
    [311] = {id=311,en="Numbshroom",ja="シビレタケ"},
    [312] = {id=312,en="Shakeshroom",ja="オドリタケ"},
    [314] = {id=314,en="Silence Gas",ja="サイレスガス"},
    [315] = {id=315,en="Dark Spore",ja="ダークスポア"},
    -- Morbol
    [316] = {id=316,en="Impale",ja="くしざし"},
    [317] = {id=317,en="Vampiric Lash",ja="吸血ムチ"},
    [318] = {id=318,en="Somersault",ja="サマーソルト"},
    [319] = {id=319,en="Bad Breath",ja="臭い息"},
    [320] = {id=320,en="Sweet Breath",ja="甘い息"},
    -- Cactuar
    [321] = {id=321,en="Needleshot",ja="ニードルショット"},
    [322] = {id=322,en="1,000 Needles",ja="針千本"},
    -- Bee
    [334] = {id=334,en="Sharp Sting",ja="シャープスティング"},
    [336] = {id=336,en="Final Sting",ja="ファイナルスピア"},
    -- Beetle
    [338] = {id=338,en="Power Attack",ja="パワーアタック"},
    [340] = {id=340,en="Rhino Attack",ja="ライノアタック"},
    -- Crawler
    [345] = {id=345,en="Poison Breath",ja="ポイズンブレス"},
    -- Scorpion
    [348] = {id=348,en="Numbing Breath",ja="ナムブレス"},
    [349] = {id=349,en="Cold Breath",ja="コールドブレス"},
    [350] = {id=350,en="Mandible Bite",ja="マンディブルバイト"},
    [351] = {id=351,en="Poison Sting",ja="ポイズンスティング"},
    [353] = {id=353,en="Death Scissors",ja="デスシザース"},
    [354] = {id=354,en="Wild Rage",ja="大暴れ"},
    [355] = {id=355,en="Earth Pounder",ja="アースパウンダー"},
    [356] = {id=356,en="Sharp Strike",ja="シャープストライク"},
    -- Diremite
    [362] = {id=362,en="Double Claw",ja="ダブルクロー"},
    [363] = {id=363,en="Grapple",ja="グラップル"},
    [365] = {id=365,en="Spinning Top",ja="スピニングトップ"},
    -- Lizard
    [366] = {id=366,en="Tail Blow",ja="テイルブロー"},
    [367] = {id=367,en="Fireball",ja="ファイアボール"},
    [368] = {id=368,en="Blockhead",ja="ブロックヘッド"},
    [369] = {id=369,en="Brain Crush",ja="ブレインクラッシュ"},
    [371] = {id=371,en="Plaguebreath",ja="プレイグブレス"},
    -- Raptor
    [374] = {id=374,en="Ripper Fang",ja="リッパーファング"},
    [376] = {id=376,en="Foul Breath",ja="ファウルブレス"},
    [377] = {id=377,en="Frost Breath",ja="フロストブレス"},
    [378] = {id=378,en="Thunderbolt",ja="サンダーボルト"},
    [379] = {id=379,en="Chomp Rush",ja="噛みつきラッシュ"},
    [380] = {id=380,en="Scythe Tail",ja="サイズテール"},
    -- Bugard
    [382] = {id=382,en="Tail Roll",ja="テールロール"},
    [383] = {id=383,en="Tusk",ja="タスク"},
    [385] = {id=385,en="Bone Crunch",ja="ボーンクランチ"},
    -- Bat
    [394] = {id=394,en="Blood Drain",ja="吸血"},
    -- Triple Bat
    [395] = {id=395,en="Jet Stream",ja="ジェットストリーム"},
    -- Greater Bird
    [399] = {id=399,en="Blind Vortex",ja="ブラインヴォルテクス"},
    [400] = {id=400,en="Giga Scream",ja="ギガスクリーム"},
    [401] = {id=401,en="Dread Dive",ja="ドレッドダイヴ"},
    [403] = {id=403,en="Stormwind",ja="ストームウィンド"},
    -- Cockatrice
    [406] = {id=406,en="Hammer Beak",ja="ハンマービーク"},
    [407] = {id=407,en="Poison Pick",ja="ポイズンピック"},
    -- Leech
    [414] = {id=414,en="Suction",ja="吸着"},
    [415] = {id=415,en="Acid Mist",ja="アシッドミスト"},
    [416] = {id=416,en="Sand Breath",ja="サンドブレス"},
    [417] = {id=417,en="Drainkiss",ja="ドレインキッス"},
    [423] = {id=423,en="Brain Drain",ja="ブレインドレイン"},
    -- Worm
    [424] = {id=424,en="Full-force Blow",ja="渾身の一撃"},
    [425] = {id=425,en="Gastric Bomb",ja="消化液弾"},
    [426] = {id=426,en="Sandspin",ja="土竜巻"},
    [427] = {id=427,en="Tremors",ja="震動"},
    -- Slime
    [431] = {id=431,en="Fluid Spread",ja="フルイドスプレッド"},
    [432] = {id=432,en="Fluid Toss",ja="フルイドスルー"},
    [433] = {id=433,en="Digest",ja="消化"},
    -- Hecteyes
    [437] = {id=437,en="Death Ray",ja="デスレイ"},
    -- Crab
    [442] = {id=442,en="Bubble Shower",ja="バブルシャワー"},
    [444] = {id=444,en="Big Scissors",ja="ビッグシザー"},
    -- Pugil
    [450] = {id=450,en="Aqua Ball",ja="アクアボール"},
    [451] = {id=451,en="Splash Breath",ja="スプラッシュブレス"},
    [452] = {id=452,en="Screwdriver",ja="スクリュードライバー"},
    -- Sea Monk
    [456] = {id=456,en="Tentacle",ja="触手"},
    [458] = {id=458,en="Ink Jet",ja="インクジェット"},
    [460] = {id=460,en="Cross Attack",ja="クロスアタック"},
    [461] = {id=461,en="Regeneration",ja="リジェネレーション"},
    [462] = {id=462,en="Maelstrom",ja="メイルシュトロム"},
    [463] = {id=463,en="Whirlwind",ja="旋風"},
    -- Skeleton
    [478] = {id=478,en="Hell Slash",ja="ヘルスラッシュ"},
    [484] = {id=484,en="Black Cloud",ja="ブラッククラウド"},
    [485] = {id=485,en="Blood Saber",ja="ブラッドセイバー"},
    -- Coeurl
    [480] = {id=480,en="Petrifactive Breath",ja="石の吐息"},
    [482] = {id=482,en="Pounce",ja="パウンス"},
    [483] = {id=483,en="Charged Whisker",ja="チャージドホイスカー"},
    -- Buffalo
    [493] = {id=493,en="Rampant Gnaw",ja="ランパントナウ"},
    [494] = {id=494,en="Big Horn",ja="ビッグホーン"},
    [495] = {id=495,en="Snort",ja="スノート"},
    -- Uragnite
    [504] = {id=504,en="Gas Shell",ja="ガスシェル"},
    [507] = {id=507,en="Painful Whip",ja="ペインフルウィップ"},
    -- Eft
    [518] = {id=518,en="Nimble Snap",ja="ニンブルスナップ"},
    [519] = {id=519,en="Cyclotail",ja="サイクロテール"},
    -- Hippogryph
    [576] = {id=576,en="Back Heel",ja="バックヒール"},
    [579] = {id=579,en="Choke Breath",ja="チョークブレス"},
    -- Goobbue
    [581] = {id=581,en="Blow",ja="ブロー"},
    [583] = {id=583,en="Beatdown",ja="ビートダウン"},
    [584] = {id=584,en="Uppercut",ja="アッパーカット"},
    -- Lesser Bird
    [622] = {id=622,en="Helldive",ja="ヘルダイブ"},
    [623] = {id=623,en="Wing Cutter",ja="ウィングカッター"},
    -- Behemoth
    [628] = {id=628,en="Wild Horn",ja="ワイルドホーン"},
    [629] = {id=629,en="Thunderbolt",ja="サンダーボルト"},
    [631] = {id=631,en="Shock Wave",ja="衝撃波"},
    [634] = {id=634,en="Meteor",ja="メテオ"},
    -- Damselfly
    [659] = {id=659,en="Cursed Sphere",ja="カースドスフィア"},
    [660] = {id=660,en="Venom",ja="毒液"},
    -- Snow Rabbit
    [661] = {id=661,en="Snow Cloud",ja="雪煙"},
    -- Sapling
    [685] = {id=685,en="Sprout Spin",ja="スプラウトスピン"},
    [686] = {id=686,en="Slumber Powder",ja="グーグーパウダー"},
    [687] = {id=687,en="Sprout Smack",ja="スプラウトスマック"},
    -- Spider
    [810] = {id=810,en="Sickle Slash",ja="シックルスラッシュ"},
    [811] = {id=811,en="Acid Spray",ja="アシッドスプレー"},
    -- Wamouracampa
    [1816] = {id=1816,en="Vitriolic Spray",ja="ヴィットリアリクスプレー"},
    [1817] = {id=1817,en="Thermal Pulse",ja="サーマルパルス"},
    [1818] = {id=1818,en="Cannonball",ja="キャノンボール"},
    -- Ladybug
    [2178] = {id=2178,en="Sudden Lunge",ja="サドンランジ"},
    [2181] = {id=2181,en="Spiral Spin",ja="スパイラルスピン"},
    [2182] = {id=2182,en="Spiral Burst",ja="スパイラルバースト"},
    -- Slug
    [2183] = {id=2183,en="Fuscous Ooze",ja="ファスカスウーズ"},
    [2184] = {id=2184,en="Purulent Ooze",ja="ピュルラントウーズ"},
    [2185] = {id=2185,en="Corrosive Ooze",ja="コローシブウーズ"},
    -- Lynx
    [2209] = {id=2209,en="Blink of Peril",ja="ブリンクオブペリル"},
    -- Chapuli 
    [2946] = {id=2946,en="Sensilla Blades",ja="センシラブレード"},
    [2947] = {id=2947,en="Tegmina Buffet",ja="テグミナバフェット"},
    [2948] = {id=2948,en="Sanguinary Slash",ja="サングインスラッシュ"},
}

return l