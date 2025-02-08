XP.Tracking = {}

XP.Tracking.Main_Job = 0

XP.Tracking.Metric = {
    Experience_Total   = 0,
    Experience_Base    = 0,
    Experience_Boosted = 0,
    Limit_Total        = 0,
    Limit_Base         = 0,
    Limit_Boosted      = 0,
    Capacity_Current   = 0,
    Capacity_Base      = 0,
    Exemplar_Current   = 0,
    Exemplar_Max       = 0,
    Exemplar_Base      = 0,
    Max_Chain          = 0,
}

XP.Tracking.Per_Kill_Max_Windows = 6
XP.Tracking.Kill_Time_Threshold = 10 * 60    -- Seconds

XP.Tracking.Last_XP_Gain_Time = 0
XP.Tracking.Last_CP_Gain_Time = 0
XP.Tracking.Last_EP_Gain_Time = 0
XP.Tracking.Kill_Times_XP = {}
XP.Tracking.Kill_Times_CP = {}
XP.Tracking.Kill_Times_EP = {}

XP.Tracking.Per_Kill_Base_XP_Only   = {}
XP.Tracking.Per_Kill_Boost_Only     = {}
XP.Tracking.Per_Kill_Base_And_Boost = {}
XP.Tracking.Per_Kill_Capacity_Base  = {}
XP.Tracking.Per_Kill_Exemplar_Base  = {}

XP.Tracking.Show_Debug = false -- Shows debug information when enabled.

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
        Capacity_Current   = 0,
        Capacity_Base      = 0,
        Exemplar_Current   = 0,
        Exemplar_Max       = 0,
        Exemplar_Base      = 0,
        Max_Chain          = 0,
    }

    XP.Tracking.Last_XP_Gain_Time = 0
    XP.Tracking.Last_CP_Gain_Time = 0
    XP.Tracking.Last_EP_Gain_Time = 0
    XP.Tracking.Kill_Times_XP = {}
    XP.Tracking.Kill_Times_CP = {}
    XP.Tracking.Kill_Times_EP = {}

    XP.Tracking.Per_Kill_Base_And_Boost = {}
    XP.Tracking.Per_Kill_Boost_Only     = {}
    XP.Tracking.Per_Kill_Base_XP_Only   = {}
    XP.Tracking.Per_Kill_Capacity_Base  = {}
    XP.Tracking.Per_Kill_Exemplar_Base  = {}
end

-- ------------------------------------------------------------------------------------------------------
-- CP needs to be tracked manually.
-- ------------------------------------------------------------------------------------------------------
---@param data table
-- ------------------------------------------------------------------------------------------------------
XP.Tracking.Update_CP_Into_Level = function(data)
    local parsed_packet = Ashita.Packets.CapacityAndLimitUpdate(data)
    if parsed_packet.capacity_points_into_level then
        XP.Tracking.Metric.Capacity_Current = parsed_packet.capacity_points_into_level
    end
end

-- ------------------------------------------------------------------------------------------------------
-- EP needs to be tracked manually.
-- ------------------------------------------------------------------------------------------------------
---@param data table
-- ------------------------------------------------------------------------------------------------------
XP.Tracking.Update_EP_Into_Level = function(data)
    local parsed_packet = Ashita.Packets.StatUpdate(data)
    if parsed_packet.exemplar_points_into_level and parsed_packet.exemplar_level_max then
        XP.Tracking.Metric.Exemplar_Current = parsed_packet.exemplar_points_into_level
        XP.Tracking.Metric.Exemplar_Max     = parsed_packet.exemplar_level_max
    end
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

    -- Average XP
    local elements = #XP.Tracking.Per_Kill_Base_And_Boost
    if elements > XP.Tracking.Per_Kill_Max_Windows then
        table.remove(XP.Tracking.Per_Kill_Base_And_Boost)
        table.remove(XP.Tracking.Per_Kill_Boost_Only)
        table.remove(XP.Tracking.Per_Kill_Base_XP_Only)
    end
    table.insert(XP.Tracking.Per_Kill_Base_And_Boost, 1, base_xp + bonus_xp)
    table.insert(XP.Tracking.Per_Kill_Boost_Only, 1, bonus_xp)
    table.insert(XP.Tracking.Per_Kill_Base_XP_Only, 1, base_xp)

    return base_xp, bonus_xp
end

-- ------------------------------------------------------------------------------------------------------
-- Tally's total capacity points.
-- ------------------------------------------------------------------------------------------------------
---@param amount integer
---@return integer
-- ------------------------------------------------------------------------------------------------------
XP.Tracking.Add_Total_CP = function(amount)
    if not amount then amount = 0 end

    XP.Tracking.Metric.Capacity_Base = XP.Tracking.Metric.Capacity_Base + amount

    -- Need to keep track of current CP in level because the Ashita data only refreshes when viewing the JP screen.
    XP.Tracking.Metric.Capacity_Current = XP.Tracking.Metric.Capacity_Current + amount
    if XP.Tracking.Metric.Capacity_Current > 30000 then XP.Tracking.Metric.Capacity_Current = XP.Tracking.Metric.Capacity_Current - 30000 end

    local elements = #XP.Tracking.Per_Kill_Capacity_Base
    if elements > XP.Tracking.Per_Kill_Max_Windows then table.remove(XP.Tracking.Per_Kill_Capacity_Base) end
    table.insert(XP.Tracking.Per_Kill_Capacity_Base, 1, amount)

    return amount
end

-- ------------------------------------------------------------------------------------------------------
-- Tally's total exemplar points.
-- ------------------------------------------------------------------------------------------------------
---@param amount integer
---@return integer
-- ------------------------------------------------------------------------------------------------------
XP.Tracking.Add_Total_EP = function(amount)
    if not amount then amount = 0 end

    XP.Tracking.Metric.Exemplar_Base = XP.Tracking.Metric.Exemplar_Base + amount

    -- Need to keep track of current CP in level because the Ashita data only refreshes when viewing the JP screen.
    XP.Tracking.Metric.Exemplar_Current = XP.Tracking.Metric.Exemplar_Current + amount
    if XP.Tracking.Metric.Exemplar_Current > 30000 then XP.Tracking.Metric.Exemplar_Current = XP.Tracking.Metric.Exemplar_Current - XP.Tracking.Metric.Exemplar_Max end

    local elements = #XP.Tracking.Per_Kill_Exemplar_Base
    if elements > XP.Tracking.Per_Kill_Max_Windows then table.remove(XP.Tracking.Per_Kill_Exemplar_Base) end
    table.insert(XP.Tracking.Per_Kill_Exemplar_Base, 1, amount)

    return amount
end

-- ------------------------------------------------------------------------------------------------------
-- Handles mob kill time tracking.
-- This gets called when an XP message comes in (from a kill).
-- ------------------------------------------------------------------------------------------------------
---@param last_xp_time integer
---@param time_table table pointer
---@return integer
-- ------------------------------------------------------------------------------------------------------
XP.Tracking.Set_Kill_Time = function(last_xp_time, time_table)
    local duration = os.time() - last_xp_time
    if duration < XP.Tracking.Kill_Time_Threshold then       -- Throw out afk/break times.
        local elements = #time_table
        if elements >= XP.Tracking.Per_Kill_Max_Windows then table.remove(time_table) end
        table.insert(time_table, 1, duration)
    end

    return  os.time()
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


    UI.PushStyleColor(ImGuiCol_TableRowBg, Window_Manager.Theme.Table_Row_Bg)
    UI.PushStyleColor(ImGuiCol_TableRowBgAlt, Window_Manager.Theme.Table_Row_Bg)
    if UI.BeginTable("Current XP", 5, table_flags) then
        UI.TableSetupColumn("Metric", flags)
        UI.TableSetupColumn("EXP",    flags)
        UI.TableSetupColumn("Limit",  flags)
        UI.TableSetupColumn("CP",     flags)
        UI.TableSetupColumn("EP",     flags)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total XP Gained")
        UI.TableNextColumn() UI.Text(tostring(XP.Tracking.Metric.Experience_Base))
        UI.TableNextColumn() UI.Text(tostring(XP.Tracking.Metric.Limit_Base))
        UI.TableNextColumn() UI.Text(tostring(XP.Tracking.Metric.Capacity_Base))
        UI.TableNextColumn() UI.Text(tostring(XP.Tracking.Metric.Exemplar_Base))

        UI.TableNextColumn() UI.Text("Current")
        UI.TableNextColumn() UI.Text(tostring(Ashita.Player.Current_XP()))
        UI.TableNextColumn() UI.Text(tostring(Ashita.Player.Current_Limit()))
        UI.TableNextColumn() UI.Text(tostring(XP.Tracking.Metric.Capacity_Current))
        UI.TableNextColumn() UI.Text(tostring(XP.Tracking.Metric.Exemplar_Current))

        UI.TableNextColumn() UI.Text("TNL")
        UI.TableNextColumn() UI.Text(XP.Columns.TNL(XP.Type.EXPERIENCE))
        UI.TableNextColumn() UI.Text(XP.Columns.TNL(XP.Type.LIMIT))
        UI.TableNextColumn() UI.Text(XP.Columns.TNL(XP.Type.CAPACITY))
        UI.TableNextColumn() UI.Text(XP.Columns.TNL(XP.Type.EXEMPLAR))

        UI.TableNextColumn() UI.Text("Average XP/Kill")
        UI.TableNextColumn() UI.Text(string.format("%.2f", (XP.Columns.Average_XP(XP.Type.EXPERIENCE))))
        UI.TableNextColumn() UI.Text(string.format("%.2f", (XP.Columns.Average_XP(XP.Type.LIMIT))))
        UI.TableNextColumn() UI.Text(string.format("%.2f", (XP.Columns.Average_XP(XP.Type.CAPACITY))))
        UI.TableNextColumn() UI.Text(string.format("%.2f", (XP.Columns.Average_XP(XP.Type.EXEMPLAR))))

        UI.TableNextColumn() UI.Text("XP/hr")
        UI.TableNextColumn() UI.Text(tostring(XP.Columns.Average_Rate(XP.Type.EXPERIENCE)))
        UI.TableNextColumn() UI.Text(tostring(XP.Columns.Average_Rate(XP.Type.LIMIT)))
        UI.TableNextColumn() UI.Text(tostring(XP.Columns.Average_Rate(XP.Type.CAPACITY)))
        UI.TableNextColumn() UI.Text(tostring(XP.Columns.Average_Rate(XP.Type.EXEMPLAR)))

        UI.EndTable()
    end

    local xp_kill_entries = #XP.Tracking.Kill_Times_XP
    if xp_kill_entries > 0 then
        if UI.BeginTable("Kill Speed XP", 2 + xp_kill_entries, table_flags) then
            UI.TableSetupColumn("Type", flags)
            UI.TableSetupColumn("Current XP Window", flags)
            for i, _ in ipairs(XP.Tracking.Kill_Times_XP) do UI.TableSetupColumn(tostring(i), flags) end
            UI.TableHeadersRow()

            UI.TableNextColumn() UI.Text("Kill Times")
            UI.TableNextColumn() UI.Text(Timers.Format(os.time() - XP.Tracking.Last_XP_Gain_Time))
            for _, v in ipairs(XP.Tracking.Kill_Times_XP) do UI.TableNextColumn() UI.Text(Timers.Format(v)) end

            UI.TableNextColumn() UI.Text("Base Only")
            for _, v in ipairs(XP.Tracking.Per_Kill_Base_XP_Only) do UI.TableNextColumn() UI.Text(string.format("%.1f", v)) end

            UI.TableNextColumn() UI.Text("Boost Only")
            for _, v in ipairs(XP.Tracking.Per_Kill_Boost_Only) do UI.TableNextColumn() UI.Text(string.format("%.1f", v)) end

            UI.TableNextColumn() UI.Text("Base + Boost")
            for _, v in ipairs(XP.Tracking.Per_Kill_Base_And_Boost) do UI.TableNextColumn() UI.Text(tostring(v)) end

            UI.EndTable()
        end
    end

    local cp_kill_entries = #XP.Tracking.Kill_Times_CP
    if cp_kill_entries > 0 then
        if UI.BeginTable("Kill Speed CP", 1 + cp_kill_entries, table_flags) then
            UI.TableSetupColumn("Current CP Window", flags)
            for i, _ in ipairs(XP.Tracking.Kill_Times_CP) do UI.TableSetupColumn(tostring(i), flags) end
            UI.TableHeadersRow()

            UI.TableNextColumn() UI.Text(Timers.Format(os.time() - XP.Tracking.Last_CP_Gain_Time))
            for _, v in ipairs(XP.Tracking.Kill_Times_CP) do UI.TableNextColumn() UI.Text(Timers.Format(v)) end

            UI.EndTable()
        end
    end

    local ep_kill_entries = #XP.Tracking.Kill_Times_EP
    if ep_kill_entries > 0 then
        if UI.BeginTable("Kill Speed CP", 1 + ep_kill_entries, table_flags) then
            UI.TableSetupColumn("Current CP Window", flags)
            for i, _ in ipairs(XP.Tracking.Kill_Times_EP) do UI.TableSetupColumn(tostring(i), flags) end
            UI.TableHeadersRow()

            UI.TableNextColumn() UI.Text(Timers.Format(os.time() - XP.Tracking.Last_EP_Gain_Time))
            for _, v in ipairs(XP.Tracking.Kill_Times_EP) do UI.TableNextColumn() UI.Text(Timers.Format(v)) end

            UI.EndTable()
        end
    end

    UI.PopStyleColor(2)
end