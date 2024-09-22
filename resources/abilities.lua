Res.Abilities = T{}

Res.Abilities.CHIVALRY = 670

-- Based off of job_abilities.lua from Windower.
Res.Abilities.Damaging = T{
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
    [841] = {id = 841              , en = "Intervene"},
}

-- Based off of job_abilities.lua from Windower.
Res.Abilities.Maneuvers = T{
    [141] = {id=141,en="Fire Maneuver",ja="ファイアマニューバ",element=0,icon_id=505,mp_cost=0,prefix="/pet",range=0,recast_id=210,targets=1,tp_cost=0,type="PetCommand"},
    [142] = {id=142,en="Ice Maneuver",ja="アイスマニューバ",element=1,icon_id=506,mp_cost=0,prefix="/pet",range=0,recast_id=210,targets=1,tp_cost=0,type="PetCommand"},
    [143] = {id=143,en="Wind Maneuver",ja="ウィンドマニューバ",element=2,icon_id=507,mp_cost=0,prefix="/pet",range=0,recast_id=210,targets=1,tp_cost=0,type="PetCommand"},
    [144] = {id=144,en="Earth Maneuver",ja="アースマニューバ",element=3,icon_id=508,mp_cost=0,prefix="/pet",range=0,recast_id=210,targets=1,tp_cost=0,type="PetCommand"},
    [145] = {id=145,en="Thunder Maneuver",ja="サンダーマニューバ",element=4,icon_id=509,mp_cost=0,prefix="/pet",range=0,recast_id=210,targets=1,tp_cost=0,type="PetCommand"},
    [146] = {id=146,en="Water Maneuver",ja="ウォータマニューバ",element=5,icon_id=510,mp_cost=0,prefix="/pet",range=0,recast_id=210,targets=1,tp_cost=0,type="PetCommand"},
    [147] = {id=147,en="Light Maneuver",ja="ライトマニューバ",element=6,icon_id=511,mp_cost=0,prefix="/pet",range=0,recast_id=210,targets=1,tp_cost=0,type="PetCommand"},
    [148] = {id=148,en="Dark Maneuver",ja="ダークマニューバ",element=7,icon_id=512,mp_cost=0,prefix="/pet",range=0,recast_id=210,targets=1,tp_cost=0,type="PetCommand"},
}

-- Based off of job_abilities.lua from Windower.
Res.Abilities.Phantom_Roll = T{
    [98] = {id=98,en="Fighter's Roll",ja="ファイターズロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=310,targets=1,tp_cost=0,type="CorsairRoll"},
    [99] = {id=99,en="Monk's Roll",ja="モンクスロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=311,targets=1,tp_cost=0,type="CorsairRoll"},
    [100] = {id=100,en="Healer's Roll",ja="ヒーラーズロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=312,targets=1,tp_cost=0,type="CorsairRoll"},
    [101] = {id=101,en="Wizard's Roll",ja="ウィザーズロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=313,targets=1,tp_cost=0,type="CorsairRoll"},
    [102] = {id=102,en="Warlock's Roll",ja="ワーロックスロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=314,targets=1,tp_cost=0,type="CorsairRoll"},
    [103] = {id=103,en="Rogue's Roll",ja="ローグズロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=315,targets=1,tp_cost=0,type="CorsairRoll"},
    [104] = {id=104,en="Gallant's Roll",ja="ガランツロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=316,targets=1,tp_cost=0,type="CorsairRoll"},
    [105] = {id=105,en="Chaos Roll",ja="カオスロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=317,targets=1,tp_cost=0,type="CorsairRoll"},
    [106] = {id=106,en="Beast Roll",ja="ビーストロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=318,targets=1,tp_cost=0,type="CorsairRoll"},
    [107] = {id=107,en="Choral Roll",ja="コーラルロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=319,targets=1,tp_cost=0,type="CorsairRoll"},
    [108] = {id=108,en="Hunter's Roll",ja="ハンターズロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=320,targets=1,tp_cost=0,type="CorsairRoll"},
    [109] = {id=109,en="Samurai Roll",ja="サムライロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=321,targets=1,tp_cost=0,type="CorsairRoll"},
    [110] = {id=110,en="Ninja Roll",ja="ニンジャロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=322,targets=1,tp_cost=0,type="CorsairRoll"},
    [111] = {id=111,en="Drachen Roll",ja="ドラケンロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=323,targets=1,tp_cost=0,type="CorsairRoll"},
    [112] = {id=112,en="Evoker's Roll",ja="エボカーズロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=324,targets=1,tp_cost=0,type="CorsairRoll"},
    [113] = {id=113,en="Magus's Roll",ja="メガスズロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=325,targets=1,tp_cost=0,type="CorsairRoll"},
    [114] = {id=114,en="Corsair's Roll",ja="コルセアズロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=326,targets=1,tp_cost=0,type="CorsairRoll"},
    [115] = {id=115,en="Puppet Roll",ja="パペットロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=327,targets=1,tp_cost=0,type="CorsairRoll"},
    [116] = {id=116,en="Dancer's Roll",ja="ダンサーロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=328,targets=1,tp_cost=0,type="CorsairRoll"},
    [117] = {id=117,en="Scholar's Roll",ja="スカラーロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=329,targets=1,tp_cost=0,type="CorsairRoll"},
    [118] = {id=118,en="Bolter's Roll",ja="ボルターズロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=330,targets=1,tp_cost=0,type="CorsairRoll"},
    [119] = {id=119,en="Caster's Roll",ja="キャスターズロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=331,targets=1,tp_cost=0,type="CorsairRoll"},
    [120] = {id=120,en="Courser's Roll",ja="コアサーズロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=332,targets=1,tp_cost=0,type="CorsairRoll"},
    [121] = {id=121,en="Blitzer's Roll",ja="ブリッツァロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=333,targets=1,tp_cost=0,type="CorsairRoll"},
    [122] = {id=122,en="Tactician's Roll",ja="タクティックロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=334,targets=1,tp_cost=0,type="CorsairRoll"},
    [302] = {id=302,en="Allies' Roll",ja="アライズロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=335,targets=1,tp_cost=0,type="CorsairRoll"},
    [303] = {id=303,en="Miser's Roll",ja="マイザーロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=336,targets=1,tp_cost=0,type="CorsairRoll"},
    [304] = {id=304,en="Companion's Roll",ja="コンパニオンロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=337,targets=1,tp_cost=0,type="CorsairRoll"},
    [305] = {id=305,en="Avenger's Roll",ja="カウンターロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=338,targets=1,tp_cost=0,type="CorsairRoll"},
    [390] = {id=390,en="Naturalist's Roll",ja="ナチュラリストロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=339,targets=1,tp_cost=0,type="CorsairRoll"},
    [391] = {id=391,en="Runeist's Roll",ja="ルーニストロール",duration=300,element=1,icon_id=485,mp_cost=0,prefix="/jobability",range=0,recast_id=193,status=600,targets=1,tp_cost=0,type="CorsairRoll"},
}

Res.Abilities.Phantom_Roll_Lucky = T{
    [98]  = {lucky = 5, unlucky = 9},  -- Fighters
    [99]  = {lucky = 3, unlucky = 7},  -- Monks
    [100] = {lucky = 3, unlucky = 7},  -- Healers
    [101] = {lucky = 5, unlucky = 9},  -- Wizards
    [102] = {lucky = 4, unlucky = 8},  -- Warlocks
    [103] = {lucky = 5, unlucky = 9},  -- Rogues
    [104] = {lucky = 3, unlucky = 7},  -- Gallants
    [105] = {lucky = 4, unlucky = 8},  -- Chaos
    [106] = {lucky = 4, unlucky = 8},  -- Beast
    [107] = {lucky = 2, unlucky = 6},  -- Choral
    [108] = {lucky = 4, unlucky = 8},  -- Hunters
    [109] = {lucky = 2, unlucky = 6},  -- Samurai
    [110] = {lucky = 4, unlucky = 8},  -- Ninja
    [111] = {lucky = 4, unlucky = 8},  -- Drachen
    [112] = {lucky = 5, unlucky = 9},  -- Evokers
    [113] = {lucky = 2, unlucky = 6},  -- Magus
    [114] = {lucky = 5, unlucky = 9},  -- Corsairs
    [115] = {lucky = 3, unlucky = 7},  -- Puppet
    [116] = {lucky = 3, unlucky = 7},  -- Dancer
    [117] = {lucky = 2, unlucky = 6},  -- Scholars
    [118] = {lucky = 3, unlucky = 9},  -- Bolters
    [119] = {lucky = 2, unlucky = 7},  -- Casters
    [120] = {lucky = 3, unlucky = 9},  -- Coursers
    [121] = {lucky = 4, unlucky = 9},  -- Blitzers
    [122] = {lucky = 5, unlucky = 8},  -- Tacticians
    [302] = {lucky = 3, unlucky = 10}, -- Allies
    [303] = {lucky = 5, unlucky = 7},  -- Misers
    [304] = {lucky = 2, unlucky = 10}, -- Companions
    [305] = {lucky = 4, unlucky = 8},  -- Avengers
    [390] = {lucky = 3, unlucky = 7},  -- Naturalists
    [391] = {lucky = 4, unlucky = 8},  -- Runeist
}

-- Based off of job_abilities.lua from Windower.
Res.Abilities.Healing = T{
    [541] = {id = 541, oldid = 29, en = "Spirit Surge"},
    [550] = {id = 550, oldid = 38, en = "Chakra"},
    [702] = {id = 702, oldid = 190, en = "Curing Waltz"},
    [703] = {id = 703, oldid = 191, en = "Curing Waltz II"},
    [704] = {id = 704, oldid = 192, en = "Curing Waltz III"},
    [705] = {id = 705, oldid = 193, en = "Curing Waltz IV"},
    [707] = {id = 707, oldid = 195, en = "Divine Waltz"},
}

-- Based off of job_abilities.lua from Windower.
Res.Abilities.Pet_Healing = T{
    [590] = {id = 590, oldid = 78,  en = "Reward"},
    [592] = {id = 592, oldid = 80,  en = "Spirit Link"},
    [649] = {id = 649, oldid = 137, en = "Repair"},
}

-- Based off of job_abilities.lua from Windower.
Res.Abilities.MP_Recovery = T{
    [666] = {id = 666, oldid = 154, en = "Devotion"},
    [670] = {id = 670, oldid = 158, en = "Chivalry"},
}

-- Based off of job_abilities.lua from Windower.
Res.Abilities.Pet_Commands = T{
    [69] = {id=69,en="Fight",ja="たたかえ",element=6,icon_id=423,mp_cost=0,prefix="/pet",range=11,recast_id=100,targets=32,tp_cost=0,type="PetCommand"},
    [70] = {id=70,en="Heel",ja="もどれ",element=6,icon_id=423,mp_cost=0,prefix="/pet",range=11,recast_id=101,targets=1,tp_cost=0,type="PetCommand"},
    [71] = {id=71,en="Leave",ja="かえれ",element=6,icon_id=423,mp_cost=0,prefix="/pet",range=11,recast_id=101,targets=1,tp_cost=0,type="PetCommand"},
    [72] = {id=72,en="Sic",ja="ほんきだせ",element=6,icon_id=423,mp_cost=0,prefix="/pet",range=3,recast_id=102,targets=3,tp_cost=0,type="PetCommand"},
    [73] = {id=73,en="Stay",ja="まってろ",element=6,icon_id=423,mp_cost=0,prefix="/pet",range=11,recast_id=101,targets=1,tp_cost=0,type="PetCommand"},
    [87] = {id=87,en="Dismiss",ja="送還",element=6,icon_id=464,mp_cost=0,prefix="/pet",range=0,recast_id=161,targets=1,tp_cost=0,type="PetCommand"},
    [88] = {id=88,en="Assault",ja="神獣の攻撃",element=6,icon_id=473,mp_cost=0,prefix="/pet",range=12,recast_id=170,targets=32,tp_cost=0,type="PetCommand"},
    [89] = {id=89,en="Retreat",ja="神獣の退避",element=6,icon_id=474,mp_cost=0,prefix="/pet",range=0,recast_id=171,targets=1,tp_cost=0,type="PetCommand"},
    [90] = {id=90,en="Release",ja="神獣の帰還",element=6,icon_id=475,mp_cost=0,prefix="/pet",range=0,recast_id=172,targets=1,tp_cost=0,type="PetCommand"},
    [91] = {id=91,en="Blood Pact: Rage",ja="契約の履行:幻術",element=6,icon_id=477,mp_cost=0,prefix="/pet",range=12,recast_id=173,targets=1,tp_cost=0,type="PetCommand"},
    [136] = {id=136,en="Activate",ja="アクティベート",element=6,icon_id=500,mp_cost=0,prefix="/jobability",range=0,recast_id=205,targets=1,tp_cost=0,type="JobAbility"},
    [138] = {id=138,en="Deploy",ja="ディプロイ",element=6,icon_id=502,mp_cost=0,prefix="/pet",range=11,recast_id=207,targets=32,tp_cost=0,type="PetCommand"},
    [139] = {id=139,en="Deactivate",ja="ディアクティベート",element=6,icon_id=503,mp_cost=0,prefix="/pet",range=0,recast_id=208,targets=1,tp_cost=0,type="PetCommand"},
    [140] = {id=140,en="Retrieve",ja="リトリーブ",element=6,icon_id=504,mp_cost=0,prefix="/pet",range=0,recast_id=209,targets=1,tp_cost=0,type="PetCommand"},
    [512] = {id=512,en="Healing Ruby",ja="ルビーの癒し",element=6,icon_id=340,mp_cost=6,prefix="/pet",range=12,recast_id=174,targets=5,tp_cost=0,type="BloodPactWard"},
    [513] = {id=513,en="Poison Nails",ja="ポイズンネイル",element=6,icon_id=340,mp_cost=11,prefix="/pet",range=2,recast_id=173,skillchain_a="Transfixion",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [514] = {id=514,en="Shining Ruby",ja="ルビーの輝き",duration=180,element=6,icon_id=340,mp_cost=44,prefix="/pet",range=12,recast_id=174,status=154,targets=1,tp_cost=0,type="BloodPactWard"},
    [515] = {id=515,en="Glittering Ruby",ja="ルビーの煌き",element=6,icon_id=340,mp_cost=62,prefix="/pet",range=12,recast_id=174,targets=1,tp_cost=0,type="BloodPactWard"},
    [516] = {id=516,en="Meteorite",ja="プチメテオ",element=6,icon_id=340,mp_cost=108,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [517] = {id=517,en="Healing Ruby II",ja="ルビーの癒しII",element=6,icon_id=340,mp_cost=124,prefix="/pet",range=12,recast_id=174,targets=1,tp_cost=0,type="BloodPactWard"},
    [518] = {id=518,en="Searing Light",ja="シアリングライト",element=6,icon_id=340,mp_cost=0,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [519] = {id=519,en="Holy Mist",ja="ホーリーミスト",element=6,icon_id=340,mp_cost=152,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [520] = {id=520,en="Soothing Ruby",ja="ルビーの安らぎ",element=6,icon_id=340,mp_cost=74,prefix="/pet",range=12,recast_id=174,targets=1,tp_cost=0,type="BloodPactWard"},
    [521] = {id=521,en="Regal Scratch",ja="リーガルスクラッチ",element=6,icon_id=351,mp_cost=5,prefix="/pet",range=2,recast_id=173,skillchain_a="Scission",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [522] = {id=522,en="Mewing Lullaby",ja="ミュインララバイ",element=6,icon_id=351,mp_cost=61,prefix="/pet",range=4,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
    [523] = {id=523,en="Eerie Eye",ja="イアリーアイ",element=6,icon_id=351,mp_cost=134,prefix="/pet",range=2,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
    [524] = {id=524,en="Level ? Holy",ja="レベル？ホーリー",element=6,icon_id=351,mp_cost=235,prefix="/pet",range=9,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [525] = {id=525,en="Raise II",ja="レイズII",element=6,icon_id=351,mp_cost=160,prefix="/pet",range=12,recast_id=174,targets=5,tp_cost=0,type="BloodPactWard"},
    [526] = {id=526,en="Reraise II",ja="リレイズII",duration=3600,element=6,icon_id=351,mp_cost=80,prefix="/pet",range=12,recast_id=174,status=113,targets=5,tp_cost=0,type="BloodPactWard"},
    [527] = {id=527,en="Altana's Favor",ja="アルタナフェーバー",duration=3600,element=6,icon_id=351,mp_cost=0,prefix="/pet",range=12,recast_id=174,status=113,targets=1,tp_cost=0,type="BloodPactWard"},
    [528] = {id=528,en="Moonlit Charge",ja="ムーンリットチャージ",element=7,icon_id=341,mp_cost=17,prefix="/pet",range=2,recast_id=173,skillchain_a="Compression",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [529] = {id=529,en="Crescent Fang",ja="クレセントファング",element=7,icon_id=341,mp_cost=19,prefix="/pet",range=2,recast_id=173,skillchain_a="Transfixion",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [530] = {id=530,en="Lunar Cry",ja="ルナークライ",element=7,icon_id=341,mp_cost=41,prefix="/pet",range=9,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
    [531] = {id=531,en="Lunar Roar",ja="ルナーロア",element=7,icon_id=341,mp_cost=27,prefix="/pet",range=4,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
    [532] = {id=532,en="Ecliptic Growl",ja="上弦の唸り",duration=180,element=7,icon_id=341,mp_cost=46,prefix="/pet",range=12,recast_id=174,targets=1,tp_cost=0,type="BloodPactWard"},
    [533] = {id=533,en="Ecliptic Howl",ja="下弦の咆哮",duration=180,element=7,icon_id=341,mp_cost=57,prefix="/pet",range=12,recast_id=174,targets=1,tp_cost=0,type="BloodPactWard"},
    [534] = {id=534,en="Eclipse Bite",ja="エクリプスバイト",element=7,icon_id=341,mp_cost=109,prefix="/pet",range=2,recast_id=173,skillchain_a="Gravitation",skillchain_b="Scission",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [536] = {id=536,en="Howling Moon",ja="ハウリングムーン",element=7,icon_id=341,mp_cost=0,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [537] = {id=537,en="Lunar Bay",ja="ルナーベイ",element=7,icon_id=341,mp_cost=174,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [538] = {id=538,en="Heavenward Howl",ja="ヘヴンズハウル",duration=60,element=7,icon_id=341,mp_cost=96,prefix="/pet",range=12,recast_id=174,targets=1,tp_cost=0,type="BloodPactWard"},
    [539] = {id=539,en="Impact",ja="インパクト",element=7,icon_id=341,mp_cost=222,prefix="/pet",range=9,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [544] = {id=544,en="Punch",ja="パンチ",element=0,icon_id=342,mp_cost=9,prefix="/pet",range=2,recast_id=173,skillchain_a="Liquefaction",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [545] = {id=545,en="Fire II",ja="ファイアII",element=0,icon_id=342,mp_cost=24,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [546] = {id=546,en="Burning Strike",ja="バーニングストライク",element=0,icon_id=342,mp_cost=48,prefix="/pet",range=2,recast_id=173,skillchain_a="Impaction",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [547] = {id=547,en="Double Punch",ja="ダブルパンチ",element=0,icon_id=342,mp_cost=56,prefix="/pet",range=2,recast_id=173,skillchain_a="Compression",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [548] = {id=548,en="Crimson Howl",ja="紅蓮の咆哮",duration=60,element=0,icon_id=342,mp_cost=84,prefix="/pet",range=12,recast_id=174,status=68,targets=1,tp_cost=0,type="BloodPactWard"},
    [549] = {id=549,en="Fire IV",ja="ファイアIV",element=0,icon_id=342,mp_cost=118,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [550] = {id=550,en="Flaming Crush",ja="フレイムクラッシュ",element=0,icon_id=342,mp_cost=164,prefix="/pet",range=2,recast_id=173,skillchain_a="Fusion",skillchain_b="Reverberation",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [551] = {id=551,en="Meteor Strike",ja="メテオストライク",element=0,icon_id=342,mp_cost=182,prefix="/pet",range=9,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [552] = {id=552,en="Inferno",ja="インフェルノ",element=0,icon_id=342,mp_cost=0,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [553] = {id=553,en="Inferno Howl",ja="灼熱の咆哮",duration=60,element=0,icon_id=342,mp_cost=72,prefix="/pet",range=12,recast_id=174,status=94,targets=1,tp_cost=0,type="BloodPactWard"},
    [554] = {id=554,en="Conflag Strike",ja="コンフラグストライク",element=0,icon_id=342,mp_cost=141,prefix="/pet",range=9,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [560] = {id=560,en="Rock Throw",ja="ロックスロー",element=3,icon_id=343,mp_cost=10,prefix="/pet",range=9,recast_id=173,skillchain_a="Scission",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [561] = {id=561,en="Stone II",ja="ストーンII",element=3,icon_id=343,mp_cost=24,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [562] = {id=562,en="Rock Buster",ja="ロックバスター",element=3,icon_id=343,mp_cost=39,prefix="/pet",range=2,recast_id=173,skillchain_a="Reverberation",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [563] = {id=563,en="Megalith Throw",ja="メガリススロー",element=3,icon_id=343,mp_cost=62,prefix="/pet",range=9,recast_id=173,skillchain_a="Induration",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [564] = {id=564,en="Earthen Ward",ja="大地の守り",duration=900,element=3,icon_id=343,mp_cost=92,prefix="/pet",range=12,recast_id=174,status=37,targets=1,tp_cost=0,type="BloodPactWard"},
    [565] = {id=565,en="Stone IV",ja="ストーンIV",element=3,icon_id=343,mp_cost=118,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [566] = {id=566,en="Mountain Buster",ja="マウンテンバスター",element=3,icon_id=343,mp_cost=164,prefix="/pet",range=2,recast_id=173,skillchain_a="Gravitation",skillchain_b="Induration",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [567] = {id=567,en="Geocrush",ja="ジオクラッシュ",element=3,icon_id=343,mp_cost=182,prefix="/pet",range=9,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [568] = {id=568,en="Earthen Fury",ja="アースフューリー",element=3,icon_id=343,mp_cost=0,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [569] = {id=569,en="Earthen Armor",ja="大地の鎧",duration=60,element=3,icon_id=343,mp_cost=156,prefix="/pet",range=12,recast_id=174,status=458,targets=1,tp_cost=0,type="BloodPactWard"},
    [570] = {id=570,en="Crag Throw",ja="クラッグスロー",element=3,icon_id=343,mp_cost=124,prefix="/pet",range=9,recast_id=173,skillchain_a="Gravitation",skillchain_b="Scission",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [576] = {id=576,en="Barracuda Dive",ja="バラクーダダイブ",element=5,icon_id=344,mp_cost=8,prefix="/pet",range=2,recast_id=173,skillchain_a="Reverberation",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [577] = {id=577,en="Water II",ja="ウォータII",element=5,icon_id=344,mp_cost=24,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [578] = {id=578,en="Tail Whip",ja="テールウィップ",element=5,icon_id=344,mp_cost=49,prefix="/pet",range=2,recast_id=173,skillchain_a="Detonation",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [579] = {id=579,en="Spring Water",ja="湧水",element=5,icon_id=344,mp_cost=99,prefix="/pet",range=12,recast_id=174,targets=1,tp_cost=0,type="BloodPactWard"},
    [580] = {id=580,en="Slowga",ja="スロウガ",element=5,icon_id=344,mp_cost=48,prefix="/pet",range=4,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
    [581] = {id=581,en="Water IV",ja="ウォータIV",element=5,icon_id=344,mp_cost=118,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [582] = {id=582,en="Spinning Dive",ja="スピニングダイブ",element=5,icon_id=344,mp_cost=164,prefix="/pet",range=2,recast_id=173,skillchain_a="Distortion",skillchain_b="Detonation",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [583] = {id=583,en="Grand Fall",ja="グランドフォール",element=5,icon_id=344,mp_cost=182,prefix="/pet",range=9,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [584] = {id=584,en="Tidal Wave",ja="タイダルウェイブ",element=5,icon_id=344,mp_cost=0,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [585] = {id=585,en="Tidal Roar",ja="タイダルロア",element=5,icon_id=344,mp_cost=138,prefix="/pet",range=4,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
    [586] = {id=586,en="Soothing Current",ja="スージングカレント",duration=180,element=5,icon_id=344,mp_cost=95,prefix="/pet",range=12,recast_id=174,status=586,targets=1,tp_cost=0,type="BloodPactWard"},
    [592] = {id=592,en="Claw",ja="クロー",element=2,icon_id=345,mp_cost=7,prefix="/pet",range=2,recast_id=173,skillchain_a="Detonation",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [593] = {id=593,en="Aero II",ja="エアロII",element=2,icon_id=345,mp_cost=24,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [594] = {id=594,en="Whispering Wind",ja="風の囁き",element=2,icon_id=345,mp_cost=119,prefix="/pet",range=12,recast_id=174,targets=1,tp_cost=0,type="BloodPactWard"},
    [595] = {id=595,en="Hastega",ja="ヘイスガ",duration=180,element=2,icon_id=345,mp_cost=129,prefix="/pet",range=12,recast_id=174,status=33,targets=1,tp_cost=0,type="BloodPactWard"},
    [596] = {id=596,en="Aerial Armor",ja="真空の鎧",duration=900,element=2,icon_id=345,mp_cost=92,prefix="/pet",range=12,recast_id=174,status=36,targets=1,tp_cost=0,type="BloodPactWard"},
    [597] = {id=597,en="Aero IV",ja="エアロIV",element=2,icon_id=345,mp_cost=118,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [598] = {id=598,en="Predator Claws",ja="プレデタークロー",element=2,icon_id=345,mp_cost=164,prefix="/pet",range=2,recast_id=173,skillchain_a="Fragmentation",skillchain_b="Scission",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [599] = {id=599,en="Wind Blade",ja="ウインドブレード",element=2,icon_id=345,mp_cost=182,prefix="/pet",range=9,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [600] = {id=600,en="Aerial Blast",ja="エリアルブラスト",element=2,icon_id=345,mp_cost=0,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [601] = {id=601,en="Fleet Wind",ja="真空の具足",duration=120,element=2,icon_id=345,mp_cost=114,prefix="/pet",range=12,recast_id=174,status=176,targets=1,tp_cost=0,type="BloodPactWard"},
    [602] = {id=602,en="Hastega II",ja="ヘイスガII",duration=180,element=2,icon_id=345,mp_cost=248,prefix="/pet",range=12,recast_id=174,status=33,targets=1,tp_cost=0,type="BloodPactWard"},
    [608] = {id=608,en="Axe Kick",ja="アクスキック",element=1,icon_id=346,mp_cost=10,prefix="/pet",range=2,recast_id=173,skillchain_a="Induration",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [609] = {id=609,en="Blizzard II",ja="ブリザドII",element=1,icon_id=346,mp_cost=24,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [610] = {id=610,en="Frost Armor",ja="凍てつく鎧",duration=180,element=1,icon_id=346,mp_cost=63,prefix="/pet",range=12,recast_id=174,status=35,targets=1,tp_cost=0,type="BloodPactWard"},
    [611] = {id=611,en="Sleepga",ja="スリプガ",element=1,icon_id=346,mp_cost=54,prefix="/pet",range=4,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
    [612] = {id=612,en="Double Slap",ja="ダブルスラップ",element=1,icon_id=346,mp_cost=96,prefix="/pet",range=2,recast_id=173,skillchain_a="Scission",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [613] = {id=613,en="Blizzard IV",ja="ブリザドIV",element=1,icon_id=346,mp_cost=118,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [614] = {id=614,en="Rush",ja="ラッシュ",element=1,icon_id=346,mp_cost=164,prefix="/pet",range=2,recast_id=173,skillchain_a="Distortion",skillchain_b="Scission",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [615] = {id=615,en="Heavenly Strike",ja="ヘヴンリーストライク",element=1,icon_id=346,mp_cost=182,prefix="/pet",range=9,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [616] = {id=616,en="Diamond Dust",ja="ダイヤモンドダスト",element=1,icon_id=346,mp_cost=0,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [617] = {id=617,en="Diamond Storm",ja="ダイヤモンドストーム",element=1,icon_id=346,mp_cost=138,prefix="/pet",range=4,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
    [618] = {id=618,en="Crystal Blessing",ja="クリスタルブレシング",duration=180,element=1,icon_id=346,mp_cost=201,prefix="/pet",range=12,recast_id=174,status=587,targets=1,tp_cost=0,type="BloodPactWard"},
    [624] = {id=624,en="Shock Strike",ja="ショックストライク",element=4,icon_id=347,mp_cost=6,prefix="/pet",range=2,recast_id=173,skillchain_a="Impaction",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [625] = {id=625,en="Thunder II",ja="サンダーII",element=4,icon_id=347,mp_cost=24,prefix="/pet",range=8,recast_id=173,targets=32,tp_cost=0,type="BloodPactRage"},
    [626] = {id=626,en="Rolling Thunder",ja="雷鼓",duration=120,element=4,icon_id=347,mp_cost=52,prefix="/pet",range=12,recast_id=174,status=98,targets=1,tp_cost=0,type="BloodPactWard"},
    [627] = {id=627,en="Thunderspark",ja="サンダースパーク",element=4,icon_id=347,mp_cost=38,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [628] = {id=628,en="Lightning Armor",ja="雷電の鎧",duration=180,element=4,icon_id=347,mp_cost=91,prefix="/pet",range=12,recast_id=174,status=38,targets=1,tp_cost=0,type="BloodPactWard"},
    [629] = {id=629,en="Thunder IV",ja="サンダーIV",element=4,icon_id=347,mp_cost=118,prefix="/pet",range=8,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [630] = {id=630,en="Chaotic Strike",ja="カオスストライク",element=4,icon_id=347,mp_cost=164,prefix="/pet",range=2,recast_id=173,skillchain_a="Fragmentation",skillchain_b="Transfixion",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [631] = {id=631,en="Thunderstorm",ja="サンダーストーム",element=4,icon_id=347,mp_cost=182,prefix="/pet",range=9,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [632] = {id=632,en="Judgment Bolt",ja="ジャッジボルト",element=4,icon_id=347,mp_cost=0,prefix="/pet",range=4,recast_id=173,skillchain_a="",skillchain_b="",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
    [633] = {id=633,en="Shock Squall",ja="スタンガ",element=4,icon_id=347,mp_cost=67,prefix="/pet",range=9,recast_id=174,targets=32,tp_cost=0,type="BloodPactWard"},
    [634] = {id=634,en="Volt Strike",ja="ボルトストライク",element=4,icon_id=347,mp_cost=229,prefix="/pet",range=2,recast_id=173,skillchain_a="Fragmentation",skillchain_b="Scission",skillchain_c="",targets=32,tp_cost=0,type="BloodPactRage"},
}