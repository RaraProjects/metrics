XP.Tracking = { }

XP.Tracking.PerKillMaxWindows = 6
XP.Tracking.KillTimeThreshold = 10 * 60    -- Seconds

XP.Tracking.ShowDebug = false -- Shows debug information when enabled.

-- ------------------------------------------------------------------------------------------------------
-- Initializes XP Tracking.
-- ------------------------------------------------------------------------------------------------------
XP.Tracking.Initialize = function()
    local function CreateXpTrackingTable()
        return
        {
            KillTimes     = { },
            LastXpInstant = 0,
            IntoLevel     = 0,
            LevelMax      = 0,
            Total         = 0,
            Base          = 0,
            Boosted       = 0,
        }
    end

    XP.Tracking.EXP      = CreateXpTrackingTable()
    XP.Tracking.Limit    = CreateXpTrackingTable()
    XP.Tracking.Capacity = CreateXpTrackingTable()
    XP.Tracking.Exemplar = CreateXpTrackingTable()

    XP.Tracking.Chains =
    {
        Current      = -1,
        IsActive     = false,
        StartInstant = 0,
        Duration     = 0,
        Max          = 0,
    }

    XP.Tracking.AverageWindows =
    {
        ExpTotal     = { },
        ExpBoost     = { },
        ExpBase      = { },
        CapacityBase = { },
        ExemplarBase = { },
    }
end

-- ------------------------------------------------------------------------------------------------------
-- Tally's total experience / limit points.
-- ------------------------------------------------------------------------------------------------------
---@param xpAmount integer
---@param xpType   integer
---@return integer, integer
-- ------------------------------------------------------------------------------------------------------
XP.Tracking.AddEXP = function(xpAmount, xpType)
    local trackingTables =
    {
        [XP.Type.EXPERIENCE] = XP.Tracking.EXP,
        [XP.Type.LIMIT]      = XP.Tracking.Limit,
    }

    if not xpType or not trackingTables[xpType] then
        Debug.Error.Add(Debug.Error.ERROR, "XP.Tracking.AddEXP", "Invalid XP Type.")
        return 0, 0
    end

    XP.Dedication.Refresh()
    xpAmount = xpAmount or 0

    -- Handle dedication bonus xp.
    local baseXp  = xpAmount
    local bonusXp = 0

    if XP.Dedication.IsActive and XP.Settings.Boost_Item_Rate > 0 then
        baseXp  = math.floor(xpAmount / (1 + (XP.Settings.Boost_Item_Rate / 100)))
        bonusXp = xpAmount - baseXp
    end

    -- Add message to battle log.
    XP.Blog(xpAmount, baseXp, bonusXp)

    -- Increment the XP totals. These are client session specific.
    local xpTracker = trackingTables[xpType]

    xpTracker.Total   = xpTracker.Total + (baseXp + bonusXp)
    xpTracker.Boosted = xpTracker.Boosted + bonusXp
    xpTracker.Base    = xpTracker.Base + baseXp

    -- This is XP type agnositic and persists across client sessions.
    XP.Settings.Boost_XP_Acquired = XP.Settings.Boost_XP_Acquired + bonusXp

    -- Average XP
    local averageWindows = XP.Tracking.AverageWindows

    if #averageWindows.ExpTotal > XP.Tracking.PerKillMaxWindows then
        table.remove(averageWindows.ExpTotal)
        table.remove(averageWindows.ExpBoost)
        table.remove(averageWindows.ExpBase)
    end

    table.insert(averageWindows.ExpTotal, 1, baseXp + bonusXp)
    table.insert(averageWindows.ExpBoost, 1, bonusXp)
    table.insert(averageWindows.ExpBase,  1, baseXp)

    return baseXp, bonusXp
end

-- ------------------------------------------------------------------------------------------------------
-- Tally's total capacity points.
-- ------------------------------------------------------------------------------------------------------
---@param amount integer
---@return integer
-- ------------------------------------------------------------------------------------------------------
XP.Tracking.AddCP = function(amount)
    amount = amount or 0

    local capacity       = XP.Tracking.Capacity
    local averageWindows = XP.Tracking.AverageWindows

    -- Increment the CP totals. These are client session specific.
    -- Need to keep track of current CP in level because the Ashita data only refreshes when viewing the JP screen.
    capacity.Base  = capacity.Base + amount
    capacity.Total = (capacity.Total + amount) % 30000

    if #averageWindows.CapacityBase > XP.Tracking.PerKillMaxWindows then
        table.remove(averageWindows.CapacityBase)
    end

    table.insert(averageWindows.CapacityBase, 1, amount)

    return amount
end

-- ------------------------------------------------------------------------------------------------------
-- Tally's total exemplar points.
-- ------------------------------------------------------------------------------------------------------
---@param amount integer
---@return integer
-- ------------------------------------------------------------------------------------------------------
XP.Tracking.AddEP = function(amount)
    amount = amount or 0

    local exemplar       = XP.Tracking.Exemplar
    local averageWindows = XP.Tracking.AverageWindows

    -- Increment the EP totals. These are client session specific.
    -- Need to keep track of current EP in level because the Ashita data only refreshes when viewing the JP screen.
    exemplar.Base      = exemplar.Base + amount
    exemplar.IntoLevel = (exemplar.IntoLevel + amount) % exemplar.LevelMax

    if #averageWindows.ExemplarBase > XP.Tracking.PerKillMaxWindows then
        table.remove(averageWindows.ExemplarBase)
    end

    table.insert(averageWindows.ExemplarBase, 1, amount)

    return amount
end

-- ------------------------------------------------------------------------------------------------------
-- Handles mob kill time tracking.
-- This gets called when an XP message comes in (from a kill).
-- ------------------------------------------------------------------------------------------------------
---@param lastXpTime integer
---@param timeTable  table   pointer
---@return integer
-- ------------------------------------------------------------------------------------------------------
XP.Tracking.AddKillTime = function(lastXpTime, timeTable)
    local duration = os.time() - lastXpTime

    if duration < XP.Tracking.KillTimeThreshold then       -- Throw out afk/break times.
        if #timeTable >= XP.Tracking.PerKillMaxWindows then
            table.remove(timeTable)
        end

        table.insert(timeTable, 1, duration)
    end

    return os.time()
end

-- ------------------------------------------------------------------------------------------------------
-- Shows XP tracking (debug) information.
-- Debug mode needs to be enabled in order to turn this on.
-- ------------------------------------------------------------------------------------------------------
XP.Tracking.DebugContent = function()
    if not XP.Tracking.ShowDebug then
        return nil
    end

    local flags      = Column.Flags.None
    local tableFlags = bit.bor(XP.TableFlags, ImGuiTableFlags_RowBg)
    local xpTypes    = XP.Type
    local exp        = XP.Tracking.EXP
    local limit      = XP.Tracking.Limit
    local capacity   = XP.Tracking.Capacity
    local exemplar   = XP.Tracking.Exemplar

    UI.PushStyleColor(ImGuiCol_TableRowBg, WindowManager.Theme.TableRowBg)
    UI.PushStyleColor(ImGuiCol_TableRowBgAlt, WindowManager.Theme.TableRowBg)

    if UI.BeginTable("Current XP", 5, tableFlags) then
        UI.TableSetupColumn("Metric", flags)
        UI.TableSetupColumn("EXP",    flags)
        UI.TableSetupColumn("Limit",  flags)
        UI.TableSetupColumn("CP",     flags)
        UI.TableSetupColumn("EP",     flags)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total XP Gained")
        UI.TableNextColumn() UI.Text(tostring(exp.Base))
        UI.TableNextColumn() UI.Text(tostring(limit.Base))
        UI.TableNextColumn() UI.Text(tostring(capacity.Base))
        UI.TableNextColumn() UI.Text(tostring(exemplar.Base))

        UI.TableNextColumn() UI.Text("Current")
        UI.TableNextColumn() UI.Text(tostring(Ashita.Player.CurrentXP()))
        UI.TableNextColumn() UI.Text(tostring(Ashita.Player.CurrentLimit()))
        UI.TableNextColumn() UI.Text(tostring(capacity.Total))
        UI.TableNextColumn() UI.Text(tostring(exemplar.IntoLevel))

        UI.TableNextColumn() UI.Text("TNL")
        UI.TableNextColumn() UI.Text(XP.Columns.TNL(xpTypes.EXPERIENCE))
        UI.TableNextColumn() UI.Text(XP.Columns.TNL(xpTypes.LIMIT))
        UI.TableNextColumn() UI.Text(XP.Columns.TNL(xpTypes.CAPACITY))
        UI.TableNextColumn() UI.Text(XP.Columns.TNL(xpTypes.EXEMPLAR))

        UI.TableNextColumn() UI.Text("Average XP/Kill")
        UI.TableNextColumn() UI.Text(string.format("%.2f", (XP.Columns.AverageXP(xpTypes.EXPERIENCE))))
        UI.TableNextColumn() UI.Text(string.format("%.2f", (XP.Columns.AverageXP(xpTypes.LIMIT))))
        UI.TableNextColumn() UI.Text(string.format("%.2f", (XP.Columns.AverageXP(xpTypes.CAPACITY))))
        UI.TableNextColumn() UI.Text(string.format("%.2f", (XP.Columns.AverageXP(xpTypes.EXEMPLAR))))

        UI.TableNextColumn() UI.Text("XP/hr")
        UI.TableNextColumn() UI.Text(tostring(XP.Columns.AverageRate(xpTypes.EXPERIENCE)))
        UI.TableNextColumn() UI.Text(tostring(XP.Columns.AverageRate(xpTypes.LIMIT)))
        UI.TableNextColumn() UI.Text(tostring(XP.Columns.AverageRate(xpTypes.CAPACITY)))
        UI.TableNextColumn() UI.Text(tostring(XP.Columns.AverageRate(xpTypes.EXEMPLAR)))

        UI.EndTable()
    end

    local xpKillEntries = #exp.KillTimes

    if xpKillEntries > 0 then
        local averageWindows = XP.Tracking.AverageWindows

        if UI.BeginTable("Kill Speed XP", 2 + xpKillEntries, tableFlags) then
            UI.TableSetupColumn("Type", flags)
            UI.TableSetupColumn("Current XP Window", flags)
            for i, _ in ipairs(exp.KillTimes) do UI.TableSetupColumn(tostring(i), flags) end
            UI.TableHeadersRow()

            UI.TableNextColumn() UI.Text("Kill Times")
            UI.TableNextColumn() UI.Text(Timers.Format(os.time() - exp.LastXpInstant))
            for _, v in ipairs(exp.KillTimes) do UI.TableNextColumn() UI.Text(Timers.Format(v)) end

            UI.TableNextColumn() UI.Text("Base Only")
            for _, v in ipairs(averageWindows.ExpBase) do UI.TableNextColumn() UI.Text(string.format("%.1f", v)) end

            UI.TableNextColumn() UI.Text("Boost Only")
            for _, v in ipairs(averageWindows.ExpBoost) do UI.TableNextColumn() UI.Text(string.format("%.1f", v)) end

            UI.TableNextColumn() UI.Text("Base + Boost")
            for _, v in ipairs(averageWindows.ExpTotal) do UI.TableNextColumn() UI.Text(tostring(v)) end

            UI.EndTable()
        end
    end

    local cpKillEntries = #capacity.KillTimes

    if cpKillEntries > 0 then
        if UI.BeginTable("Kill Speed CP", 1 + cpKillEntries, tableFlags) then
            UI.TableSetupColumn("Current CP Window", flags)
            for i, _ in ipairs(capacity.KillTimes) do UI.TableSetupColumn(tostring(i), flags) end
            UI.TableHeadersRow()

            UI.TableNextColumn() UI.Text(Timers.Format(os.time() - capacity.LastXpInstant))
            for _, v in ipairs(capacity.KillTimes) do UI.TableNextColumn() UI.Text(Timers.Format(v)) end

            UI.EndTable()
        end
    end

    local epKillEntries = #exemplar.KillTimes

    if epKillEntries > 0 then
        if UI.BeginTable("Kill Speed CP", 1 + epKillEntries, tableFlags) then
            UI.TableSetupColumn("Current CP Window", flags)
            for i, _ in ipairs(exemplar.KillTimes) do UI.TableSetupColumn(tostring(i), flags) end
            UI.TableHeadersRow()

            UI.TableNextColumn() UI.Text(Timers.Format(os.time() - exemplar.LastXpInstant))
            for _, v in ipairs(exemplar.KillTimes) do UI.TableNextColumn() UI.Text(Timers.Format(v)) end

            UI.EndTable()
        end
    end

    UI.PopStyleColor(2)
end