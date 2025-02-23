Parse.ColumnContent = { }

-- Focus
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Focus_Jump end,
    Header    = function() return "Focus" end,
    Content   = function(playerName) Column.Util.Focus(playerName) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Job
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Jobs end,
    Header    = function() return "Job" end,
    Content   = function(playerName) Column.String.Job(playerName, Parse.Settings.Hide_Subjob) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Name
table.insert(Parse.ColumnContent,
{
    Condition = function() return not Parse.Config.IsNanoMode() end,
    Header    = function() return "Name" end,
    Content   = function(playerName) Column.String.FormatName(playerName) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = true,
    Is_Nano   = false,
})

-- Total
table.insert(Parse.ColumnContent,
{
    Condition = function() return true end,
    Header    = function() return "Total" end,
    Content   = function(playerName) Column.Damage.Total(playerName, false, true) end,
    Total     = function() Column.Damage.ParseTotal(true) end,
    Is_Mini   = true,
    Is_Nano   = true,
})

-- %Total
table.insert(Parse.ColumnContent,
{
    Condition = function() return true end,
    Header    = function() return "%Total" end,
    Content   = function(playerName) Column.Damage.Total(playerName, true, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = true,
    Is_Nano   = true,
})

-- Melee Delay
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Melee_Delay end,
    Header    = function() return "s/Melee" end,
    Content   = function(playerName) Column.AttackSpeed.Get(playerName, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- DPS
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_DPS end,
    Header    = function() return DB.DPS.ColumnHeader() end,
    Content   = function(playerName) Column.AttackSpeed.Get(playerName, true) end,
    Total     = function() Column.Damage.ParseDPS(true) end,
    Is_Mini   = true,
    Is_Nano   = true,
})

-- Recent Accuracy
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Accuracy_Recent end,
    Header    = function() return string.format("%%A.%d", Metrics.Model.Running_Accuracy_Limit) end,
    Content   = function(playerName) Column.Acc.Recent(playerName, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = true,
    Is_Nano   = true,
})

-- Total Accuracy
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Accuracy_Combined end,
    Header    = function() return "%A.Total" end,
    Content   = function(playerName) Column.Acc.ByType(playerName, DB.Enum.COMBINED, nil, false, nil, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Crit
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Crit_Combined end,
    Header    = function() return "%Crit" end,
    Content   = function(playerName) Column.Acc.ByType(playerName, DB.Enum.COMBINED, 0, true, nil, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Melee Damage
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Total_Melee end,
    Header    = function() return "Melee" end,
    Content   = function(playerName) Column.Damage.ByType(playerName, DB.Trackable.MELEE_OVERALL, nil, nil, false, true) end,
    Total     = function() Column.Damage.TrackableTotal(DB.Trackable.MELEE_OVERALL, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Melee Accuracy
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Accuracy_Melee end,
    Header    = function() return "%M.Acc" end,
    Content   = function(playerName) Column.Acc.ByType(playerName, DB.Trackable.MELEE_OVERALL, nil, false, nil, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Melee Crit Rate
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Crit_Melee end,
    Header    = function() return "%M.Crit" end,
    Content   = function(playerName) Column.Acc.ByType(playerName, DB.Trackable.MELEE_OVERALL, 0, true, nil, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Weaponskill Damage
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Total_Weaponskill end,
    Header    = function() return "WS" end,
    Content   = function(playerName) Column.Damage.ByType(playerName, DB.Trackable.WEAPONSKILL, nil, nil, false, true) end,
    Total     = function() Column.Damage.TrackableTotal(DB.Trackable.WEAPONSKILL, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Weaponskill Average
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Weaponskill_Average end,
    Header    = function() return "WS Avg." end,
    Content   = function(playerName) Column.Damage.ByTypeAverage(playerName, DB.Trackable.WEAPONSKILL, nil, nil, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Weaponskill Accuracy
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Accuracy_Weaponskill end,
    Header    = function() return "%WS.Acc" end,
    Content   = function(playerName) Column.General.Fraction(playerName, DB.Trackable.WEAPONSKILL, DB.Metric.HITS_ON_USE, DB.Metric.ATTEMPTS_ON_USE, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Weaponskill TP
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Weaponskill_TP end,
    Header    = function() return "WS ~TP." end,
    Content   = function(playerName) Column.Damage.PerUnitAverage(playerName, DB.Trackable.WEAPONSKILL, DB.Metric.TP_SPENT, nil, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Skillchain Damage
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Total_Skillchain end,
    Header    = function() return "SC" end,
    Content   = function(playerName) Column.Damage.ByType(playerName, DB.Trackable.SKILLCHAIN, nil, nil, false, true) end,
    Total     = function() Column.Damage.TrackableTotal(DB.Trackable.SKILLCHAIN, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Ranged Damage
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Total_Ranged end,
    Header    = function() return "Ranged" end,
    Content   = function(playerName) Column.Damage.ByType(playerName, DB.Trackable.RANGED_OVERALL, nil, nil, false, true) end,
    Total     = function() Column.Damage.TrackableTotal(DB.Trackable.RANGED_OVERALL, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Ranged Accuracy
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Accuracy_Ranged end,
    Header    = function() return "%R.Acc" end,
    Content   = function(playerName) Column.Acc.ByType(playerName, DB.Trackable.RANGED_OVERALL, nil, false, nil, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Ranged Crit Rate
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Crit_Ranged end,
    Header    = function() return "%R.Crit" end,
    Content   = function(playerName) Column.Acc.ByType(playerName, DB.Trackable.RANGED_OVERALL, 0, true, nil, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Ranged Distance
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Ranged_Distance end,
    Header    = function() return "R.Dist" end,
    Content   = function(playerName) Column.Damage.ShotDistance(playerName, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Nuking Damage
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Total_Nuking end,
    Header    = function() return "Nuking" end,
    Content   = function(playerName) Column.Damage.ByType(playerName, DB.Trackable.SPELLS_NUKING, nil, nil, false, true) end,
    Total     = function() Column.Damage.TrackableTotal(DB.Trackable.SPELLS_NUKING, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Job Ability Damage
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Total_Ability end,
    Header    = function() return "JA" end,
    Content   = function(playerName) Column.Damage.ByType(playerName, DB.Trackable.ABILITY_DAMAGING, nil, nil, false, true) end,
    Total     = function() Column.Damage.TrackableTotal(DB.Trackable.ABILITY_DAMAGING, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Pet Damage
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Pet_Total end,
    Header    = function() return "P.Total" end,
    Content   = function(playerName) Column.Damage.ByType(playerName, DB.Trackable.PET_OVERALL, nil, nil, false, true) end,
    Total     = function() Column.Damage.TrackableTotal(DB.Trackable.PET_OVERALL, true) end,
    Is_Mini   = true,
    Is_Nano   = false,
})

-- Pet Accuracy
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Pet_Accuracy end,
    Header    = function() return "%P.Acc" end,
    Content   = function(playerName) Column.Acc.ByType(playerName, DB.Trackable.PET_MELEE_DISCRETE, nil, false, nil, true) end,
    Total     = function() UI.Text(" ") end,
    Is_Mini   = true,
    Is_Nano   = false,
})

-- Total Pet Melee Damage
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Pet_Melee end,
    Header    = function() return "P.Melee" end,
    Content   = function(playerName) Column.Damage.ByType(playerName, DB.Trackable.PET_MELEE_OVERALL, nil, nil, false, true) end,
    Total     = function() Column.Damage.TrackableTotal(DB.Trackable.PET_MELEE_OVERALL, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Pet Ranged Damage
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Pet_Ranged end,
    Header    = function() return "P.RA" end,
    Content   = function(playerName) Column.Damage.ByType(playerName, DB.Trackable.PET_RANGED_OVERALL, nil, nil, false, true) end,
    Total     = function() Column.Damage.TrackableTotal(DB.Trackable.PET_RANGED_OVERALL, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Pet TP Damage
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Pet_TP_Move end,
    Header    = function() return "P.TP" end,
    Content   = function(playerName) Column.Damage.ByType(playerName, DB.Trackable.PET_TP, nil, nil, false, true) end,
    Total     = function() Column.Damage.TrackableTotal(DB.Trackable.PET_TP, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Pet Healing
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Pet_Healing end,
    Header    = function() return "P.Heals" end,
    Content   = function(playerName) Column.Damage.ByType(playerName, DB.Trackable.PET_HEALING, nil, nil, false, true) end,
    Total     = function() Column.Damage.TrackableTotal(DB.Trackable.PET_HEALING, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Healing
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Total_Healing end,
    Header    = function() return "Healing" end,
    Content   = function(playerName) Column.Healing.Total(playerName, false, true) end,
    Total     = function() Column.Damage.TrackableTotal(DB.Trackable.ALL_HEAL, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Total Damage Taken
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Damage_Taken end,
    Header    = function() return "DT" end,
    Content   = function(playerName) Column.Defense.DamageTakenByType(playerName, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, false, true) end,
    Total     = function() Column.Damage.TrackableTotal(DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})

-- Deaths
table.insert(Parse.ColumnContent,
{
    Condition = function() return Parse.Settings.Show_Player_Deaths end,
    Header    = function() return "Deaths" end,
    Content   = function(playerName) Column.Proc.Deaths(playerName, true) end,
    Total     = function() Column.Damage.TrackableTotal(DB.Trackable.DEATH, true) end,
    Is_Mini   = false,
    Is_Nano   = false,
})