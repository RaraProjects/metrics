Perf = { }

Perf.Profiles = { }

Perf.AverageLookback = 10

Perf.Enums =
{
    UI_RENDER       = 1,
    UI_PARSE        = 2,
    UI_FOCUS        = 3,
    UI_BATTLE_LOG   = 4,
    UI_OVERVIEW     = 5,
    UI_EXP          = 6,
    UI_LOOT         = 7,
    PARSE_GENERAL   = 8,
    PARSE_MELEE     = 9,
    PARSE_MELEE_DEF = 10,
    PARSE_RANGED    = 11,
    PARSE_SPELL     = 12,
    PARSE_SPELL_DEF = 13,
    PARSE_ABILITY   = 14,
    PARSE_PLAYER_TP = 15,
    PARSE_MOB_TP    = 16,
}

local typeNames =
{
    "UI Render",
    "UI Parse",
    "UI Focus",
    "UI Battle Log",
    "UI Overview",
    "UI EXP",
    "UI Loot",
    "Parse General",
    "Parse Melee",
    "Parse Melee Def.",
    "Parse Ranged",
    "Parse Spell",
    "Parse Spell Def.",
    "Parse Ability",
    "Parse Player TP",
    "Parse Mob TP",
}

------------------------------------------------------------------------------------------------------
-- Get the performance profile.
------------------------------------------------------------------------------------------------------
---@param perfType integer
---@return table
------------------------------------------------------------------------------------------------------
Perf.GetProfile = function(perfType)
    local profiles = Perf.Profiles

    if not profiles[perfType] then
        profiles[perfType] =
        {
            Count     = 0,
            Recent    = { },
            TotalTime = 0,
            MaxTime   = 0,
        }
    end

    return profiles[perfType]
end

------------------------------------------------------------------------------------------------------
-- Updates the recent average value.
------------------------------------------------------------------------------------------------------
---@param averageTable table
---@param newValue     number
------------------------------------------------------------------------------------------------------
Perf.UpdateRecentAverage = function(averageTable, newValue)
    table.insert(averageTable, newValue)

    if #averageTable > Perf.AverageLookback then
        table.remove(averageTable, 1)
    end
end

------------------------------------------------------------------------------------------------------
-- Calculates the average value.
------------------------------------------------------------------------------------------------------
---@param averageTable table
---@return number
------------------------------------------------------------------------------------------------------
Perf.CalculateRecentAverage = function(averageTable)
    local size  = #averageTable
    local total = 0

    if size == 0 then
        return 0
    end

    for _, value in ipairs(averageTable) do
        total = total + value
    end

    return total / size
end

------------------------------------------------------------------------------------------------------
-- Store the performance capture.
------------------------------------------------------------------------------------------------------
---@param perfType  integer
---@param start number
------------------------------------------------------------------------------------------------------
Perf.Capture = function(perfType, start)
    if not perfType or not start then
        return
    end

    local dt      = Socket.gettime() - start
    local profile = Perf.GetProfile(perfType)

    profile.Count     = profile.Count + 1
    profile.TotalTime = profile.TotalTime + dt
    profile.MaxTime   = math.max(profile.MaxTime, dt)
    Perf.UpdateRecentAverage(profile.Recent, dt)
end

------------------------------------------------------------------------------------------------------
-- Retrieve performance stats for display.
------------------------------------------------------------------------------------------------------
---@param perfType integer
---@return table
------------------------------------------------------------------------------------------------------
Perf.GetStats = function(perfType)
    local profile = Perf.GetProfile(perfType)

    if profile.Count == 0 then
        return
        {
            count   = 0,
            recent  = 0,
            average = 0,
            max     = 0,
        }
    end

    return
    {
        count   = profile.Count,
        recent  = profile.Recent,
        average = (profile.TotalTime / profile.Count) * 1000,
        max     = profile.MaxTime * 1000,
    }
end

------------------------------------------------------------------------------------------------------
-- Shows performance stats.
------------------------------------------------------------------------------------------------------
Perf.Populate = function()
    local colFlags = Column.Flags.None
    local row      = 1

    if UI.BeginTable("Performance", 5, WindowManager.Table.Flags.FixedBorders) then
        UI.TableSetupColumn("Type",       colFlags)
        UI.TableSetupColumn("Count",      colFlags)
        UI.TableSetupColumn("R.Avg (ms)", colFlags)
        UI.TableSetupColumn("T.Avg (ms)", colFlags)
        UI.TableSetupColumn("Max (ms)",   colFlags)
        UI.TableHeadersRow()

        for perfType = 1, #typeNames do
            local stats = Perf.GetStats(perfType)

            if stats and stats.count > 0 then
                UI.TableNextColumn() UI.Text(typeNames[perfType])
                UI.TableNextColumn() UI.Text(string.format("%d",   stats.count))
                UI.TableNextColumn() UI.Text(string.format("%.3f", Perf.CalculateRecentAverage(stats.recent) * 1000))
                UI.TableNextColumn() UI.Text(string.format("%.3f", stats.average))
                UI.TableNextColumn() UI.Text(string.format("%.3f", stats.max))
                WindowManager.TableRowColor(row)
                row = row + 1
            end
        end

        UI.EndTable()
    end
end
