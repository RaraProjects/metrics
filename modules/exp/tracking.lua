XP.Tracking = {}

XP.Tracking.Metric = {
    Experience_Total   = 0,
    Experience_Base    = 0,
    Experience_Boosted = 0,
    Limit_Total        = 0,
    Limit_Base         = 0,
    Limit_Boosted      = 0,
    Max_Chain          = 0,
}

XP.Tracking.Kill_Times = {}
XP.Tracking.Kill_Time_Threshold = 10 * 60    -- Seconds
XP.Tracking.Per_Kill_Base_And_Boost = {}
XP.Tracking.Per_Kill_Base_XP_Only = {}
XP.Tracking.Per_Kill_Max_Windows = 6
XP.Tracking.Last_XP_Gain_Time = 0

XP.Tracking.Show_Debug    = false -- Shows debug information when enabled.

-- ------------------------------------------------------------------------------------------------------
-- Initializes XP Tracking.
-- ------------------------------------------------------------------------------------------------------
XP.Tracking.Initialize = function()
    XP.Tracking.Metric = {
        Experience_Total   = 0,
        Experience_Base    = 0,
        Experience_Boosted = 0,
        Limit_Total        = 0,
        Limit_Base         = 0,
        Limit_Boosted      = 0,
        Max_Chain          = 0,
    }

    XP.Tracking.Kill_Times = {}
    XP.Tracking.Per_Kill_Base_And_Boost = {}
    XP.Tracking.Per_Kill_Base_XP_Only   = {}
    XP.Tracking.Last_XP_Gain_Time       = 0
end

-- ------------------------------------------------------------------------------------------------------
-- Tally's total experience / limit points.
-- ------------------------------------------------------------------------------------------------------
---@param amount integer
---@param type integer
---@return integer, integer
-- ------------------------------------------------------------------------------------------------------
XP.Tracking.Add_Total_XP = function(amount, type)
    if not type or type == XP.Type.ERROR then return 0, 0 end
    if not amount then amount = 0 end

    -- Handle dedication bonus xp.
    XP.Dedication.Check()
    local base_xp  = amount
    local bonus_xp = 0
    if XP.Dedication.Is_Active and XP.Settings.Boost_Item_Rate > 0 then
        base_xp  = amount / (1 + (XP.Settings.Boost_Item_Rate / 100))
        bonus_xp = amount - base_xp
    end

    -- Increment the XP totals. These are client session specific.
    if type == XP.Type.EXPERIENCE then
        XP.Tracking.Metric.Experience_Base    = XP.Tracking.Metric.Experience_Base + base_xp
        XP.Tracking.Metric.Experience_Boosted = XP.Tracking.Metric.Experience_Boosted + bonus_xp
        XP.Tracking.Metric.Experience_Total   = XP.Tracking.Metric.Experience_Base + XP.Tracking.Metric.Experience_Boosted
    elseif type == XP.Type.LIMIT then
        XP.Tracking.Metric.Limit_Base    = XP.Tracking.Metric.Limit_Base + base_xp
        XP.Tracking.Metric.Limit_Boosted = XP.Tracking.Metric.Limit_Boosted + bonus_xp
        XP.Tracking.Metric.Limit_Total   = XP.Tracking.Metric.Limit_Base + XP.Tracking.Metric.Limit_Boosted
    end

    -- This is XP type agnositic and persists across client sessions.
    XP.Settings.Boost_XP_Acquired = XP.Settings.Boost_XP_Acquired + bonus_xp

    -- Average XP and Kill Times
    local elements = #XP.Tracking.Per_Kill_Base_And_Boost
    if elements > XP.Tracking.Per_Kill_Max_Windows then
        table.remove(XP.Tracking.Per_Kill_Base_And_Boost)
        table.remove(XP.Tracking.Per_Kill_Base_XP_Only)
    end
    table.insert(XP.Tracking.Per_Kill_Base_And_Boost, 1, base_xp + bonus_xp)
    table.insert(XP.Tracking.Per_Kill_Base_XP_Only, 1, base_xp)

    return base_xp, bonus_xp
end

-- ------------------------------------------------------------------------------------------------------
-- Handles mob kill time tracking.
-- This gets called when an XP message comes in (from a kill).
-- ------------------------------------------------------------------------------------------------------
XP.Tracking.Set_Kill_Time = function()
    local duration = os.time() - XP.Tracking.Last_XP_Gain_Time
    if duration < XP.Tracking.Kill_Time_Threshold then       -- Throw out afk/break times.
        local elements = #XP.Tracking.Kill_Times
        if elements >= XP.Tracking.Per_Kill_Max_Windows then table.remove(XP.Tracking.Kill_Times) end
        table.insert(XP.Tracking.Kill_Times, 1, duration)
    end

    -- Update last kill time to now.
    XP.Tracking.Last_XP_Gain_Time = os.time()
end

-- ------------------------------------------------------------------------------------------------------
-- Shows XP tracking (debug) information.
-- Debug mode needs to be enabled in order to turn this on.
-- ------------------------------------------------------------------------------------------------------
XP.Tracking.Debug_Content = function()
    if not XP.Tracking.Show_Debug then return nil end

    local flags       = Column.Flags.None
    local table_flags = XP.Table_Flags
    table_flags       = bit.bor(table_flags, ImGuiTableFlags_RowBg)

    local kill_entries = #XP.Tracking.Kill_Times
    UI.PushStyleColor(ImGuiCol_TableRowBg, Window_Manager.Theme.Table_Row_Bg)
    if UI.BeginTable("Kill Speed", 1 + kill_entries, table_flags) then
        UI.TableSetupColumn("Current", flags)
        for i, _ in ipairs(XP.Tracking.Kill_Times) do UI.TableSetupColumn(tostring(i), flags) end
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text(Timers.Format(os.time() - XP.Tracking.Last_XP_Gain_Time))
        for _, v in ipairs(XP.Tracking.Kill_Times) do UI.TableNextColumn() UI.Text(Timers.Format(v)) end

        UI.EndTable()
    end
    UI.PopStyleColor(1)
end