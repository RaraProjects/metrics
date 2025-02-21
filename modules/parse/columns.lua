Parse.Column_Content = {}

-- Focus
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Focus_Jump end,
    Header    = function() return "Focus" end,
    Content   = function(player_name) Column.Util.Focus(player_name) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Job
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Jobs end,
    Header    = function() return "Job" end,
    Content   = function(player_name) Column.String.Job(player_name, Parse.Settings.Hide_Subjob) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Name
table.insert(Parse.Column_Content, {
    Condition = function() return not Parse.Config.Is_Nano_Mode() end,
    Header    = function() return "Name" end,
    Content   = function(player_name) Column.String.Format_Name(player_name) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = true,
    Is_Nano   = false,
})

-- Total
table.insert(Parse.Column_Content, {
    Condition = function() return true end,
    Header    = function() return "Total" end,
    Content   = function(player_name) Column.Damage.Total(player_name, false, true) end,
    Total     = function() Column.Damage.Parse_Total(true) end,
    Is_Mini   = true,
    Is_Nano   = true,
})

-- %Total
table.insert(Parse.Column_Content, {
    Condition = function() return true end,
    Header    = function() return "%Total" end,
    Content   = function(player_name) Column.Damage.Total(player_name, true, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = true,
    Is_Nano   = true,
})

-- Melee Delay
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Melee_Delay end,
    Header    = function() return "s/Melee" end,
    Content   = function(player_name) Column.Attack_Speed.Get(player_name, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- DPS
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_DPS end,
    Header    = function() return DB.DPS.ColumnHeader() end,
    Content   = function(player_name) Column.Attack_Speed.Get(player_name, true) end,
    Total     = function() Column.Damage.Parse_DPS(true) end,
    Is_Mini   = true,
    Is_Nano   = true,
})

-- Recent Accuracy
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Accuracy_Recent end,
    Header    = function() return "%A." .. Metrics.Model.Running_Accuracy_Limit end,
    Content   = function(player_name) Column.Acc.Recent(player_name, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = true,
    Is_Nano   = true,
})

-- Total Accuracy
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Accuracy_Combined end,
    Header    = function() return "%A.Total" end,
    Content   = function(player_name) Column.Acc.ByType(player_name, DB.Enum.COMBINED, nil, false, nil, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Crit
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Crit_Combined end,
    Header    = function() return "%Crit" end,
    Content   = function(player_name) Column.Acc.ByType(player_name, DB.Enum.COMBINED, 0, true, nil, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Melee Damage
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Total_Melee end,
    Header    = function() return "Melee" end,
    Content   = function(player_name) Column.Damage.ByType(player_name, DB.Trackable.MELEE_OVERALL, nil, nil, false, true) end,
    Total     = function() Column.Damage.Trackable_Total(DB.Trackable.MELEE_OVERALL, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Melee Accuracy
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Accuracy_Melee end,
    Header    = function() return "%M.Acc" end,
    Content   = function(player_name) Column.Acc.ByType(player_name, DB.Trackable.MELEE_OVERALL, nil, false, nil, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Melee Crit Rate
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Crit_Melee end,
    Header    = function() return "%M.Crit" end,
    Content   = function(player_name) Column.Acc.ByType(player_name, DB.Trackable.MELEE_OVERALL, 0, true, nil, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Weaponskill Damage
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Total_Weaponskill end,
    Header    = function() return "WS" end,
    Content   = function(player_name) Column.Damage.ByType(player_name, DB.Trackable.WEAPONSKILL, nil, nil, false, true) end,
    Total     = function() Column.Damage.Trackable_Total(DB.Trackable.WEAPONSKILL, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Weaponskill Average
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Weaponskill_Average end,
    Header    = function() return "WS Avg." end,
    Content   = function(player_name) Column.Damage.ByTypeAverage(player_name, DB.Trackable.WEAPONSKILL, nil, nil, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Weaponskill Accuracy
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Accuracy_Weaponskill end,
    Header    = function() return "%WS.Acc" end,
    Content   = function(player_name) Column.General.Fraction(player_name, DB.Trackable.WEAPONSKILL, DB.Metric.HITS_ON_USE, DB.Metric.ATTEMPTS_ON_USE, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Weaponskill TP
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Weaponskill_TP end,
    Header    = function() return "WS ~TP." end,
    Content   = function(player_name) Column.Damage.Per_Unit_Average(player_name, DB.Trackable.WEAPONSKILL, DB.Metric.TP_SPENT, nil, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Skillchain Damage
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Total_Skillchain end,
    Header    = function() return "SC" end,
    Content   = function(player_name) Column.Damage.ByType(player_name, DB.Trackable.SKILLCHAIN, nil, nil, false, true) end,
    Total     = function() Column.Damage.Trackable_Total(DB.Trackable.SKILLCHAIN, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Ranged Damage
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Total_Ranged end,
    Header    = function() return "Ranged" end,
    Content   = function(player_name) Column.Damage.ByType(player_name, DB.Trackable.RANGED_OVERALL, nil, nil, false, true) end,
    Total     = function() Column.Damage.Trackable_Total(DB.Trackable.RANGED_OVERALL, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Ranged Accuracy
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Accuracy_Ranged end,
    Header    = function() return "%R.Acc" end,
    Content   = function(player_name) Column.Acc.ByType(player_name, DB.Trackable.RANGED_OVERALL, nil, false, nil, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Ranged Crit Rate
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Crit_Ranged end,
    Header    = function() return "%R.Crit" end,
    Content   = function(player_name) Column.Acc.ByType(player_name, DB.Trackable.RANGED_OVERALL, 0, true, nil, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Ranged Distance
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Ranged_Distance end,
    Header    = function() return "R.Dist" end,
    Content   = function(player_name) Column.Damage.ShotDistance(player_name, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Nuking Damage
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Total_Nuking end,
    Header    = function() return "Nuking" end,
    Content   = function(player_name) Column.Damage.ByType(player_name, DB.Trackable.SPELLS_NUKING, nil, nil, false, true) end,
    Total     = function() Column.Damage.Trackable_Total(DB.Trackable.SPELLS_NUKING, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Job Ability Damage
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Total_Ability end,
    Header    = function() return "JA" end,
    Content   = function(player_name) Column.Damage.ByType(player_name, DB.Trackable.ABILITY_DAMAGING, nil, nil, false, true) end,
    Total     = function() Column.Damage.Trackable_Total(DB.Trackable.ABILITY_DAMAGING, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Pet Damage
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Pet_Total end,
    Header    = function() return "P.Total" end,
    Content   = function(player_name) Column.Damage.ByType(player_name, DB.Trackable.PET_OVERALL, nil, nil, false, true) end,
    Total     = function() Column.Damage.Trackable_Total(DB.Trackable.PET_OVERALL, true) end,
    Is_Mini   = true,
    Is_Nano   = false,
})

-- Pet Accuracy
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Pet_Accuracy end,
    Header    = function() return "%P.Acc" end,
    Content   = function(player_name) Column.Acc.ByType(player_name, DB.Trackable.PET_MELEE_DISCRETE, nil, false, nil, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = true,
    Is_Nano   = false,
})

-- Total Pet Melee Damage
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Pet_Melee end,
    Header    = function() return "P.Melee" end,
    Content   = function(player_name) Column.Damage.ByType(player_name, DB.Trackable.PET_MELEE_OVERALL, nil, nil, false, true) end,
    Total     = function() Column.Damage.Trackable_Total(DB.Trackable.PET_MELEE_OVERALL, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Pet Ranged Damage
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Pet_Ranged end,
    Header    = function() return "P.RA" end,
    Content   = function(player_name) Column.Damage.ByType(player_name, DB.Trackable.PET_RANGED_OVERALL, nil, nil, false, true) end,
    Total     = function() Column.Damage.Trackable_Total(DB.Trackable.PET_RANGED_OVERALL, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Pet TP Damage
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Pet_TP_Move end,
    Header    = function() return "P.TP" end,
    Content   = function(player_name) Column.Damage.ByType(player_name, DB.Trackable.PET_TP, nil, nil, false, true) end,
    Total     = function() Column.Damage.Trackable_Total(DB.Trackable.PET_TP, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Pet Healing
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Pet_Healing end,
    Header    = function() return "P.Heals" end,
    Content   = function(player_name) Column.Damage.ByType(player_name, DB.Trackable.PET_HEALING, nil, nil, false, true) end,
    Total     = function() Column.Damage.Trackable_Total(DB.Trackable.PET_HEALING, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Healing
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Total_Healing end,
    Header    = function() return "Healing" end,
    Content   = function(player_name) Column.Healing.Total(player_name, false, true) end,
    Total     = function() Column.Damage.Trackable_Total(DB.Trackable.ALL_HEAL, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Damage Taken
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Damage_Taken end,
    Header    = function() return "DT" end,
    Content   = function(player_name) Column.Defense.DamageTakenByType(player_name, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, false, true) end,
    Total     = function() Column.Damage.Trackable_Total(DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Deaths
table.insert(Parse.Column_Content, {
    Condition = function() return Parse.Settings.Show_Player_Deaths end,
    Header    = function() return "Deaths" end,
    Content   = function(player_name) Column.Proc.Deaths(player_name, true) end,
    Total     = function() Column.Damage.Trackable_Total(DB.Trackable.DEATH, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})