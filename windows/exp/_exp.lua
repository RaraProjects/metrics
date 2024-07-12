XP = T{}
-- ASB Code: /src/map/utils/charutils.cpp->AddExperiencePoints
-- ASB Code: /src/map/utils/charutils.cpp->DistributeExperiencePoints
-- https://github.com/Shinzaku/Points

XP.Type = T{
    ERROR      = 0,
    EXPERIENCE = 1,
    LIMIT      = 2,
}

XP.Messages = T{}
XP.Messages.EXP = T{
    [8]   = true,   -- No chain
    [253] = true,   -- Chain
}
XP.Messages.LP = T{
    [371] = true,   -- No chain
    [372] = true,   -- Chain
}
XP.Messages.Chain = T{
    [253] = true,   -- Experience points
    [372] = true,   -- Limit points
}

XP.Metric = T{
    Experience_Total   = 0,
    Experience_Base    = 0,
    Experience_Boosted = 0,
    Limit_Total        = 0,
    Limit_Base         = 0,
    Limit_Boosted      = 0,
    Max_Chain          = 0,
}

XP.Global = T{}

XP.Kill_Times = T{}
XP.Kill_Time_Threshold = 10 * 60    -- Seconds
XP.XP_Per_Kill = T{}
XP.XP_Per_Kill_Base = T{}
XP.XP_Per_Kill_Limit = 6
XP.Last_XP_Time = 0

XP.Is_Dedication_Active = true
XP.Dedication_Item  = "None"
XP.Dedication_Rate  = 0
XP.Dedication_Max   = 0
XP.Dedication_Total = 0

XP.Is_Initialized = false
XP.Display_Mode = XP.Type.EXPERIENCE
XP.Show_Additional_Info = false
XP.Confirmation = false

require("windows.exp.window")
require("windows.exp.columns")
require("windows.exp.config")
require("windows.exp.tracking")
require("windows.exp.chains")

-- ------------------------------------------------------------------------------------------------------
-- Initializes the XP module.
-- ------------------------------------------------------------------------------------------------------
XP.Initialize = function()
    if not XP.Is_Initialized then
        XP.Columns.Count()
        XP.Local.Initialize()
        XP.Mode_Check()
        XP.Check_Dedication()
        XP.Metric = T{
            Experience_Total   = 0,
            Experience_Base    = 0,
            Experience_Boosted = 0,
            Limit_Total        = 0,
            Limit_Base         = 0,
            Limit_Boosted      = 0,
            Max_Chain          = 0,
        }
        XP.XP_Per_Kill = T{}
        XP.XP_Per_Kill_Base = T{}
        XP.Last_XP_Time = 0
        XP.Is_Initialized = true
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Primary XP driving function.
-- ------------------------------------------------------------------------------------------------------
---@param data any
-- ------------------------------------------------------------------------------------------------------
XP.Parse = function(data)
    if not data then return nil end
    local parsed = Ashita.Packets.EXP(data)
    if not parsed then return nil end

    local xp_amount = parsed.xp_amount
    local chain = parsed.chain_count
    local message_id = parsed.message_id

    local xp_type = XP.Get_XP_Type(message_id)
    local base_xp, bonus_xp = XP.Add_Total_XP(xp_amount, xp_type)   -- Add XP to sum total.

    XP.Set_Kill_Time()
    XP.Chains.Start(chain)                                          -- Handle chains.
    XP.Local.Add_XP(base_xp, bonus_xp, xp_type)                     -- XP per hour tracking.
end

-- ------------------------------------------------------------------------------------------------------
-- Populates the XP window.
-- ------------------------------------------------------------------------------------------------------
XP.Populate = function()
    XP.Config.Settings_Button()
    UI.SameLine() UI.Text(" ") UI.SameLine() XP.Tracking_Button()
    UI.SameLine() UI.Text(" ") UI.SameLine() XP.Reset_Button()
    if XP.Confirmation then UI.SameLine() UI.Text(" ") UI.SameLine() XP.Reset_Confirmation_Button() end

    XP.Mode_Check()
    XP.Check_Dedication()
    XP.XP_Table(XP.Display_Mode)
    XP.Tracking()

    if Window.Can_Bar_Load() then
        XP.Level_Progress_Bar()
        XP.Boost_Progress_Bar()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the experience points rows.
-- ------------------------------------------------------------------------------------------------------
XP.XP_Table = function(xp_type)
    local flags = Column.Flags.None
    local table_flags = XP.Window.Table_Flags
    table_flags = bit.bor(table_flags, ImGuiTableFlags_RowBg)
    if not xp_type then xp_type = XP.Type.EXPERIENCE end

    local type_string = "XP"
    local level_string = "L"
    local tnl = Ashita.Player.Exp_TNL()
    if xp_type == XP.Type.LIMIT then
        type_string = "LP"
        level_string = "M"
        tnl = Ashita.Player.Exp_TNM()
    end

    UI.PushStyleColor(ImGuiCol_TableRowBg, Window.Theme.Table_Row_Bg)
    if UI.BeginTable("XP Metrics", XP.Columns.Display_Count, table_flags) then
        UI.TableSetupColumn("Chain", flags)
        UI.TableSetupColumn("*" .. type_string .. "/hr", flags)
        if Metrics.Parse.Base_Rate     then UI.TableSetupColumn(type_string .. "/hr", flags) end
        if Metrics.Parse.Time_To_Level then UI.TableSetupColumn("~TT" .. level_string, flags) end
        if Metrics.Parse.To_Next_Level then UI.TableSetupColumn("TN" .. level_string, flags) end
        if Metrics.Parse.Kill_Speed    then UI.TableSetupColumn("~K-Time", flags) end
        if Metrics.Parse.Average_XP    then UI.TableSetupColumn("~K-XP", flags) end
        if Metrics.Parse.Total_XP      then UI.TableSetupColumn("Total", flags) end
        if Metrics.Parse.Max_Chain     then UI.TableSetupColumn("Max Chain", flags) end
        if Metrics.Parse.Zone_Time     then UI.TableSetupColumn("Zone Time", flags) end
        if Metrics.Parse.XP_Boost_Item then UI.TableSetupColumn("Bonus", flags) end
        if Metrics.Parse.XP_Boost_Rate then UI.TableSetupColumn("Bonus %", flags) end
        if Metrics.Parse.XP_Boost_Max  then UI.TableSetupColumn("Bonus Max", flags) end
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(XP.Columns.Chain())
        UI.TableNextColumn() UI.Text(XP.Columns.Average_Rate())
        if Metrics.Parse.Base_Rate     then UI.TableNextColumn() UI.Text(XP.Columns.Average_Rate(true)) end
        if Metrics.Parse.Time_To_Level then UI.TableNextColumn() UI.Text(XP.Columns.Time_To_Level(xp_type)) end
        if Metrics.Parse.To_Next_Level then UI.TableNextColumn() UI.Text(XP.Columns.TNL(xp_type)) end
        if Metrics.Parse.Kill_Speed then
            local kill_time = XP.Columns.Average_Kill_Time()
            if kill_time < 0 then
                UI.TableNextColumn() UI.Text("--:--")
            else
                UI.TableNextColumn() UI.Text(Timers.Format(kill_time, true))
            end
        end
        if Metrics.Parse.Average_XP    then UI.TableNextColumn() UI.Text(string.format("%d", XP.Columns.Average_XP())) end
        if Metrics.Parse.Total_XP      then UI.TableNextColumn() UI.Text(XP.Columns.Total_XP(xp_type)) end
        if Metrics.Parse.Max_Chain     then UI.TableNextColumn() UI.Text(XP.Columns.Max_Chain()) end
        if Metrics.Parse.Zone_Time     then UI.TableNextColumn() UI.Text(XP.Columns.Zone_Time()) end
        if Metrics.Parse.XP_Boost_Item then UI.TableNextColumn() UI.Text(tostring(XP.Dedication_Item)) end
        if Metrics.Parse.XP_Boost_Rate then UI.TableNextColumn() UI.Text(XP.Columns.Dedication_Bonus()) end
        if Metrics.Parse.XP_Boost_Max  then UI.TableNextColumn() UI.Text(XP.Columns.Dedication_Progress()) end

        UI.EndTable()
    end
    UI.PopStyleColor(1)
end

-- ------------------------------------------------------------------------------------------------------
-- Shows XP tracking information.
-- ------------------------------------------------------------------------------------------------------
XP.Tracking = function()
    if not XP.Local.Show_Windows then return nil end
    local flags = Column.Flags.None
    if XP.Display_Mode == XP.Type.EXPERIENCE then
        if UI.BeginTable("EXP Tracking", 3 + XP.Local.Bucket_Max, XP.Window.Table_Flags) then
            UI.TableSetupColumn("Cycle", flags)
            UI.TableSetupColumn("Scaling", flags)
            UI.TableSetupColumn("Total", flags)
            for i, _ in ipairs(XP.Local.EXP_Base_Buckets) do UI.TableSetupColumn(tostring(i), flags) end
            UI.TableHeadersRow()

            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(Timers.Check(Timers.Enum.Names.EXP))
            UI.TableNextColumn() UI.Text(tostring((1 / XP.Local.Window_Length()) * 3600))
            UI.TableNextColumn() UI.Text(tostring(XP.Local.XP_In_Window(XP.Type.EXPERIENCE)))
            for _, v in ipairs(XP.Local.EXP_Base_Buckets) do UI.TableNextColumn() UI.Text(tostring(v)) end

            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(Timers.Check(Timers.Enum.Names.EXP))
            UI.TableNextColumn() UI.Text(tostring((1 / XP.Local.Window_Length()) * 3600))
            UI.TableNextColumn() UI.Text(tostring(XP.Local.XP_In_Window(XP.Type.EXPERIENCE)))
            for _, v in ipairs(XP.Local.EXP_Buckets) do UI.TableNextColumn() UI.Text(tostring(v)) end

            UI.EndTable()
        end
    else
        if UI.BeginTable("LP Tracking", 3 + XP.Local.Bucket_Max, XP.Window.Table_Flags) then
            UI.TableSetupColumn("Cycle", flags)
            UI.TableSetupColumn("Scaling", flags)
            UI.TableSetupColumn("Total", flags)
            for i, _ in ipairs(XP.Local.EXP_Base_Buckets) do UI.TableSetupColumn(tostring(i), flags) end
            UI.TableHeadersRow()

            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(Timers.Check(Timers.Enum.Names.EXP))
            UI.TableNextColumn() UI.Text(tostring((1 / XP.Local.Window_Length()) * 3600))
            UI.TableNextColumn() UI.Text(tostring(XP.Local.XP_In_Window(XP.Type.LIMIT)))
            for _, v in ipairs(XP.Local.LP_Base_Buckets) do UI.TableNextColumn() UI.Text(tostring(v)) end

            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(Timers.Check(Timers.Enum.Names.EXP))
            UI.TableNextColumn() UI.Text(tostring((1 / XP.Local.Window_Length()) * 3600))
            UI.TableNextColumn() UI.Text(tostring(XP.Local.XP_In_Window(XP.Type.LIMIT)))
            for _, v in ipairs(XP.Local.LP_Buckets) do UI.TableNextColumn() UI.Text(tostring(v)) end

            UI.EndTable()
        end
    end

    local kill_max = #XP.Kill_Times
    if UI.BeginTable("Kill Speed", 1 + kill_max, XP.Window.Table_Flags) then
        UI.TableSetupColumn("Current", flags)
        for i, _ in ipairs(XP.Kill_Times) do UI.TableSetupColumn(tostring(i), flags) end
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(Timers.Format(os.time() - XP.Last_XP_Time))
        for _, v in ipairs(XP.Kill_Times) do UI.TableNextColumn() UI.Text(Timers.Format(v)) end

        UI.EndTable()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the additional information rows.
-- ------------------------------------------------------------------------------------------------------
XP.Additional_Info = function()
    if XP.Show_Additional_Info then
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Max Chain")
        UI.TableNextColumn() UI.Text(tostring(XP.Metric.Max_Chain))

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Chain Time")
        UI.TableNextColumn() UI.Text(tostring(XP.Chains.Duration))

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Addon Runtime")
        UI.TableNextColumn() UI.Text(Timers.Check(Timers.Enum.Names.METRICS))
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the XP is either XP or limit points.
-- ------------------------------------------------------------------------------------------------------
---@param message_id integer
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Get_XP_Type = function(message_id)
    if not message_id then return XP.Type.ERROR end
    if XP.Messages.EXP[message_id] then return XP.Type.EXPERIENCE end
    if XP.Messages.LP[message_id] then return XP.Type.LIMIT end
    return XP.Type.ERROR
end

-- ------------------------------------------------------------------------------------------------------
-- Sets XP display mode.
-- ------------------------------------------------------------------------------------------------------
XP.Mode_Check = function()
    if Ashita.Player.Exp_TNL() == 1 then
        XP.Display_Mode = XP.Type.LIMIT
    else
        XP.Display_Mode = XP.Type.EXPERIENCE
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Handles mob kill time tracking.
-- ------------------------------------------------------------------------------------------------------
XP.Set_Kill_Time = function()
    local duration = os.time() - XP.Last_XP_Time
    if duration < XP.Kill_Time_Threshold then       -- Throw out afk/break times.
        local elements = #XP.Kill_Times
        if elements >= XP.XP_Per_Kill_Limit then
            table.remove(XP.Kill_Times)
        end
        table.insert(XP.Kill_Times, 1, duration)
    end
    XP.Last_XP_Time = os.time()
end

-- ------------------------------------------------------------------------------------------------------
-- Tally's total experience / limit points.
-- ------------------------------------------------------------------------------------------------------
---@param amount integer
---@param type string
---@return integer, integer
-- ------------------------------------------------------------------------------------------------------
XP.Add_Total_XP = function(amount, type)
    if not type or type == XP.Type.ERROR then return 0, 0 end
    if not amount then amount = 0 end

    -- Handle dedication bonus xp.
    XP.Check_Dedication()
    local base_xp = amount
    local bonus_xp = 0
    if XP.Is_Dedication_Active and XP.Dedication_Rate > 0 then
        base_xp = amount / (1 + (XP.Dedication_Rate / 100))
        bonus_xp = amount - base_xp
    end

    -- Total Metrics
    if type == XP.Type.EXPERIENCE then
        XP.Metric.Experience_Base = XP.Metric.Experience_Base + base_xp
        XP.Metric.Experience_Boosted = XP.Metric.Experience_Boosted + bonus_xp
        XP.Metric.Experience_Total = XP.Metric.Experience_Base + XP.Metric.Experience_Boosted
    elseif type == XP.Type.LIMIT then
        XP.Metric.Limit_Base = XP.Metric.Limit_Base + base_xp
        XP.Metric.Limit_Boosted = XP.Metric.Limit_Boosted + bonus_xp
        XP.Metric.Limit_Total = XP.Metric.Limit_Base + XP.Metric.Limit_Boosted
    end

    -- Average XP and Kill Times
    local elements = #XP.XP_Per_Kill
    if elements > XP.XP_Per_Kill_Limit then
        table.remove(XP.XP_Per_Kill)
        table.remove(XP.XP_Per_Kill_Base)
    end
    table.insert(XP.XP_Per_Kill, 1, base_xp + bonus_xp)
    table.insert(XP.XP_Per_Kill_Base, 1, base_xp)

    return base_xp, bonus_xp
end

-- ------------------------------------------------------------------------------------------------------
-- Checks level progress.
-- ------------------------------------------------------------------------------------------------------
---@return number
-- ------------------------------------------------------------------------------------------------------
XP.Level_Progress = function()
    local current_xp = Ashita.Player.Current_XP()
    local level_xp = Ashita.Player.Level_XP()
    if XP.Display_Mode == XP.Type.LIMIT then
        current_xp = Ashita.Player.Limit_XP()
        level_xp = 10000
    end
    if not current_xp or not level_xp or level_xp == 0 then return 0 end
    return current_xp / level_xp
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if dedication is active.
-- ------------------------------------------------------------------------------------------------------
XP.Check_Dedication = function()
    XP.Is_Dedication_Active = Ashita.Player.Has_Buff(Ashita.Player.Buffs.DEDICATION)

    -- Addon is loaded and dedication is active; don't know the details of the item used.
    if XP.Is_Dedication_Active and XP.Dedication_Item == "None" then
        XP.Dedication_Item = "Unknown"
        XP.Dedication_Rate = -1
        XP.Dedication_Max  = -1

    -- Dedication is not active.
    elseif not XP.Is_Dedication_Active then
        XP.Clear_Dedication()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Checks dedication progress.
-- ------------------------------------------------------------------------------------------------------
---@return number
-- ------------------------------------------------------------------------------------------------------
XP.Dedication_Progress = function()
    if not XP.Is_Dedication_Active then return 0 end
    local bonus_xp = XP.Metric.Experience_Boosted + XP.Metric.Limit_Boosted
    local max_xp = XP.Dedication_Max
    if not max_xp or max_xp == 0 then max_xp = 1 end
    return bonus_xp / max_xp
end

-- ------------------------------------------------------------------------------------------------------
-- Sets dedication flags.
-- ------------------------------------------------------------------------------------------------------
---@param item? table
-- ------------------------------------------------------------------------------------------------------
XP.Set_Dedication = function(item)
    if item and item.name then
        XP.Is_Dedication_Active = true
        XP.Dedication_Item = item.name
        XP.Dedication_Rate = item.boost
        XP.Dedication_Max  = item.max
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Clears dedication flags.
-- ------------------------------------------------------------------------------------------------------
XP.Clear_Dedication = function()
    XP.Dedication_Item = "None"
    XP.Dedication_Rate = 0
    XP.Dedication_Max  = 0
end

-- ------------------------------------------------------------------------------------------------------
-- Returns how much xp per unit time where time is the total time the Metrics has been active.
-- This will be a really big number early on.
-- ------------------------------------------------------------------------------------------------------
---@param type? string
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Global.Calculate = function(type)
    local xp = XP.Metric.Experience_Total
    if type == XP.Type.LIMIT then xp = XP.Metric.Limit_Total end
    local addon_active_time = Timers.Get_Duration(Timers.Enum.Names.METRICS)    -- seconds
    if not addon_active_time or addon_active_time == 0 then return tostring(0) end
    addon_active_time = addon_active_time / 3600                                -- convert to hours
    return string.format("%d", xp / addon_active_time)                          -- xp per hour
end

------------------------------------------------------------------------------------------------------
-- Displays the level progress bar.
------------------------------------------------------------------------------------------------------
XP.Level_Progress_Bar = function()
    if Metrics.Parse.XP_Progress then
        local color = Res.Colors.Get_XP(XP.Display_Mode)
        UI.PushStyleColor(ImGuiCol_PlotHistogram, color)
        UI.ProgressBar(XP.Level_Progress(), {-1, 8}, "")
        UI.PopStyleColor(1)
    end
end

------------------------------------------------------------------------------------------------------
-- Displays the boost progress bar.
------------------------------------------------------------------------------------------------------
XP.Boost_Progress_Bar = function()
    if Metrics.Parse.Boost_Progress and XP.Is_Dedication_Active and XP.Dedication_Rate > 0 then
        UI.ProgressBar(XP.Dedication_Progress(), {-1, 8}, "")
    end
end

------------------------------------------------------------------------------------------------------
-- Sets display mode to experience.
------------------------------------------------------------------------------------------------------
XP.EXP_Button = function()
    if UI.SmallButton("EXP") then
        XP.Display_Mode = XP.Type.EXPERIENCE
    end
end

------------------------------------------------------------------------------------------------------
-- Sets display mode to limit.
------------------------------------------------------------------------------------------------------
XP.Limit_Button = function()
    if UI.SmallButton("Limit") then
        XP.Display_Mode = XP.Type.LIMIT
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles XP tracking information showing.
------------------------------------------------------------------------------------------------------
XP.Tracking_Button = function()
    if UI.SmallButton("Tracking") then
        XP.Local.Show_Windows = not XP.Local.Show_Windows
        Window.Set_Bar_Delay()
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Confirmation button showing for the XP window.
------------------------------------------------------------------------------------------------------
XP.Reset_Button = function()
    if UI.SmallButton("Reset") then
        XP.Confirmation = not XP.Confirmation
    end
end

------------------------------------------------------------------------------------------------------
-- Confirms XP reset.
------------------------------------------------------------------------------------------------------
XP.Reset_Confirmation_Button = function()
    if UI.SmallButton("I'm sure.") then
        XP.Is_Initialized = false
        XP.Confirmation = false
    end
end