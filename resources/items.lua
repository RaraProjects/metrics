Res.Items = T{}

Res.Items.Dedication = T{
    [0]     = {name = "Unknown",          boost = -1,  max = -1},
    [8191]  = {name = "Wandering Heroes", boost = 75,  max = 10000},
    [15793] = {name = "Anniversary Ring", boost = 100, max = 3000},
    [15763] = {name = "Emperor Band",     boost = 75,  max = 2250},
    [15762] = {name = "Empress Band",     boost = 50,  max = 1000},
    [15761] = {name = "Chariot Band",     boost = 100, max = 4000},
}

-- Used for item dropdown selection.
Res.Items.Dedication_Selection = T{
    [1] = "Chariot Band",       -- 15761
    [2] = "Emperor Band",       -- 15763
    [3] = "Empress Band",       -- 15762
    [4] = "Wandering Heroes",   -- 8191
    [5] = "Anniversary Ring",   -- 15793
}

Res.Items.Dedication_Name_To_ID = T{
    ["Chariot Band"]     = 15761,
    ["Emperor Band"]     = 15763,
    ["Empress Band"]     = 15762,
    ["Wandering Heroes"] = 8191,
    ["Anniversary Ring"] = 15793,
}