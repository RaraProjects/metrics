Res.WS = T{}

-- Based off of weapons_skills.lua from Windower.
Res.WS.Missing = T{
    [260]  = {id = 260,  english = "Spirit Jump"},
    [293]  = {id = 293,  english = "Soul Jump"},
    [329]  = {id = 329,  english = "Intervene"},
    [3502] = {id = 3502, english = "Nott"}
}

-- Based off of weapons_skills.lua from Windower.
Res.WS.Abilities = T{
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

-- Based off of weapons_skills.lua from Windower.
Res.WS.MP_Drain = T{
    [21]  = {id=21,en="Energy Steal",ja="エナジースティール",element=7,icon_id=596,prefix="/weaponskill",range=2,skill=2,skillchain_a="",skillchain_b="",skillchain_c="",targets=32},
    [22]  = {id=22,en="Energy Drain",ja="エナジードレイン",element=7,icon_id=596,prefix="/weaponskill",range=2,skill=2,skillchain_a="",skillchain_b="",skillchain_c="",targets=32},
    [163] = {id=163,en="Starlight",ja="スターライト",element=6,icon_id=628,prefix="/weaponskill",range=2,skill=11,skillchain_a="",skillchain_b="",skillchain_c="",targets=1},
    [164] = {id=164,en="Moonlight",ja="ムーンライト",element=6,icon_id=628,prefix="/weaponskill",range=2,skill=11,skillchain_a="",skillchain_b="",skillchain_c="",targets=1},
    [183] = {id=183,en="Spirit Taker",ja="スピリットテーカー",element=6,icon_id=631,prefix="/weaponskill",range=2,skill=12,skillchain_a="",skillchain_b="",skillchain_c="",targets=32},
}

Res.WS.Skillchains = T{
    [229] = 'DRG Jump Effect',
    [288] = 'Light',       [289] = 'Darkness', 
    [290] = 'Gravitation', [291] = 'Fragmentation', [292] = 'Distortion', [293] = 'Fusion',
    [294] = 'Compression', [295] = 'Liquefaction',  [296] = 'Induration', [297] = 'Reverberation', 
    [298] = 'Transfixion', [299] = 'Scission',      [300] = 'Detonation', [301] = 'Impaction',
    [385] = 'Light',       [386] = 'Darkness',
    [767] = 'Radiance',    [768] = 'Umbra'
}