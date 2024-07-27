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
XP.Full_Bar_Height = 18
XP.Tiny_Bar_Height = 8

XP.Is_Initialized = false
XP.Display_Mode = XP.Type.EXPERIENCE
XP.Show_Additional_Info = false
XP.Confirmation = false

require("windows.exp.window")
require("windows.exp.columns")
require("windows.exp.config")
require("windows.exp.tracking")
require("windows.exp.chains")
require("windows.exp.dedication")

-- ------------------------------------------------------------------------------------------------------
-- Initializes the XP module.
-- ------------------------------------------------------------------------------------------------------
XP.Initialize = function()
    if not XP.Is_Initialized then
        XP.Dedication.Need_Defaulting = false
        XP.Dedication.Need_Clear = false
        XP.Columns.Count()
        XP.Local.Initialize()
        XP.Mode_Check()
        if Metrics.XP.Boost_Item_Rate <= 0 then
            XP.Dedication.Need_Defaulting = true
            XP.Dedication.Need_Clear = true
        end
        XP.Dedication.Check()
        XP.Metric = T{
            Experience_Total   = 0,
            Experience_Base    = 0,
            Experience_Boosted = 0,
            Limit_Total        = 0,
            Limit_Base         = 0,
            Limit_Boosted      = 0,
            Max_Chain          = 0,
        }
        XP.Kill_Times = T{}
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
    if xp_amount > 1000 then return nil end -- Ignore XP scrolls and ENM awards.

    local chain = parsed.chain_count
    local message_id = parsed.message_id

    local xp_type = XP.Get_XP_Type(message_id)
    if xp_type == XP.Type.ERROR then return nil end

    XP.Add_Total_XP(xp_amount, xp_type)     -- Add XP to sum total.
    XP.Set_Kill_Time()

    -- Handle chains for EM and above. I've observed 100 XP for EM mobs.
    if xp_amount >= 100 then XP.Chains.Start(chain) end
end

-- ------------------------------------------------------------------------------------------------------
-- Populates the XP window.
-- ------------------------------------------------------------------------------------------------------
XP.Populate = function()
    if not Metrics.XP.XP_Mini then
        XP.Config.Settings_Button()
        if _Debug.Is_Enabled() then UI.SameLine() UI.Text(" ") UI.SameLine() XP.Tracking_Button() end
        UI.SameLine() UI.Text(" ") UI.SameLine() XP.Reset_Button()
        if XP.Confirmation then UI.SameLine() UI.Text(" ") UI.SameLine() XP.Reset_Confirmation_Button() end
    end

    XP.Mode_Check()
    XP.XP_Table(XP.Display_Mode)
    XP.Tracking()

    if Window.Can_Bar_Load() then
        XP.Level_Progress_Bar()
        XP.Boost_Progress_Bar()
    else
        if Metrics.XP.XP_Progress or Metrics.XP.Boost_Progress then UI.Text("Loading...") end
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
    if xp_type == XP.Type.LIMIT then
        type_string = "LP"
        level_string = "M"
    end

    UI.PushStyleColor(ImGuiCol_TableRowBg, Window.Theme.Table_Row_Bg)
    if UI.BeginTable("XP Metrics", XP.Columns.Display_Count, table_flags) then
        if Metrics.XP.XP_Job then UI.TableSetupColumn("Job", flags) end
        UI.TableSetupColumn("Chain", flags)
        UI.TableSetupColumn("*" .. type_string .. "/hr", flags)
        if Metrics.XP.Base_Rate     then UI.TableSetupColumn(type_string .. "/hr", flags) end
        if Metrics.XP.Time_To_Level then UI.TableSetupColumn("~TT" .. level_string, flags) end
        if Metrics.XP.To_Next_Level then UI.TableSetupColumn("TN" .. level_string, flags) end
        if Metrics.XP.Kill_Speed    then UI.TableSetupColumn("Time/Kill", flags) end
        if Metrics.XP.Average_XP    then UI.TableSetupColumn("XP/Kill", flags) end
        if Metrics.XP.Total_XP      then UI.TableSetupColumn("Total", flags) end
        if Metrics.XP.Max_Chain     then UI.TableSetupColumn("Max Chain", flags) end
        if Metrics.XP.Zone_Time     then UI.TableSetupColumn("Zone Time", flags) end
        if Metrics.XP.XP_Boost_Item then UI.TableSetupColumn("Bonus", flags) end
        if Metrics.XP.XP_Boost_Rate then UI.TableSetupColumn("Bonus %", flags) end
        if Metrics.XP.XP_Boost_Max  then UI.TableSetupColumn("Bonus Max", flags) end
        UI.TableHeadersRow()

        UI.TableNextRow()
        if Metrics.XP.XP_Job then UI.TableNextColumn() XP.Columns.Job() end
        UI.TableNextColumn() XP.Columns.Chain()
        UI.TableNextColumn() UI.Text(XP.Columns.Average_Rate())
        if Metrics.XP.Base_Rate     then UI.TableNextColumn() UI.Text(XP.Columns.Average_Rate(true)) end
        if Metrics.XP.Time_To_Level then UI.TableNextColumn() XP.Columns.Time_To_Level(xp_type) end
        if Metrics.XP.To_Next_Level then UI.TableNextColumn() UI.Text(XP.Columns.TNL(xp_type)) end
        if Metrics.XP.Kill_Speed then
            local kill_time = XP.Columns.Average_Kill_Time()
            if kill_time < 0 then
                UI.TableNextColumn() UI.Text("--:--")
            else
                UI.TableNextColumn() UI.Text(Timers.Format(kill_time, true))
            end
        end
        if Metrics.XP.Average_XP    then UI.TableNextColumn() UI.Text(string.format("%d", XP.Columns.Average_XP())) end
        if Metrics.XP.Total_XP      then UI.TableNextColumn() UI.Text(XP.Columns.Total_XP(xp_type)) end
        if Metrics.XP.Max_Chain     then UI.TableNextColumn() UI.Text(XP.Columns.Max_Chain()) end
        if Metrics.XP.Zone_Time     then UI.TableNextColumn() UI.Text(XP.Columns.Zone_Time()) end
        if Metrics.XP.XP_Boost_Item then UI.TableNextColumn() UI.Text(tostring(Metrics.XP.Boost_Item_Name)) end
        if Metrics.XP.XP_Boost_Rate then UI.TableNextColumn() UI.Text(XP.Columns.Dedication_Bonus()) end
        if Metrics.XP.XP_Boost_Max  then UI.TableNextColumn() UI.Text(XP.Columns.Dedication_Progress()) end

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
    local table_flags = XP.Window.Table_Flags
    table_flags = bit.bor(table_flags, ImGuiTableFlags_RowBg)
    local kill_max = #XP.Kill_Times
    UI.PushStyleColor(ImGuiCol_TableRowBg, Window.Theme.Table_Row_Bg)
    if UI.BeginTable("Kill Speed", 1 + kill_max, table_flags) then
        UI.TableSetupColumn("Current", flags)
        for i, _ in ipairs(XP.Kill_Times) do UI.TableSetupColumn(tostring(i), flags) end
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(Timers.Format(os.time() - XP.Last_XP_Time))
        for _, v in ipairs(XP.Kill_Times) do UI.TableNextColumn() UI.Text(Timers.Format(v)) end

        UI.EndTable()
    end
    UI.PopStyleColor(1)
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
    XP.Dedication.Check()
    local base_xp = amount
    local bonus_xp = 0
    if XP.Dedication.Is_Active and Metrics.XP.Boost_Item_Rate > 0 then
        base_xp = amount / (1 + (Metrics.XP.Boost_Item_Rate / 100))
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
    Metrics.XP.Boost_EXP = Metrics.XP.Boost_EXP + bonus_xp

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
    if Metrics.XP.XP_Progress then
        local color = Res.Colors.Get_XP(XP.Display_Mode)
        local height = XP.Full_Bar_Height
        local caption = nil
        if Metrics.XP.Small_Bars then
            height = XP.Tiny_Bar_Height
            caption = ""
        end
        UI.PushStyleColor(ImGuiCol_PlotHistogram, color)
        UI.ProgressBar(XP.Level_Progress(), {-1, height}, caption)
        UI.PopStyleColor(1)
    end
end

------------------------------------------------------------------------------------------------------
-- Displays the boost progress bar.
------------------------------------------------------------------------------------------------------
XP.Boost_Progress_Bar = function()
    if Metrics.XP.Boost_Progress and XP.Dedication.Is_Active then
        local height = XP.Full_Bar_Height
        local caption = nil
        local progress = XP.Dedication.Progress()

        -- We know what dedication item was used.
        if Metrics.XP.Boost_Item_Rate > 0 then
            if Metrics.XP.Small_Bars then
                height = XP.Tiny_Bar_Height
                caption = ""
            end

        -- We DON'T know what dedication item was used.
        else
            caption = "Unknown dedication item used."
            progress = 0
        end

        UI.ProgressBar(progress, {-1, height}, caption)
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

------------------------------------------------------------------------------------------------------
-- Converts a codepoint to UTF8.
------------------------------------------------------------------------------------------------------
---@param codepoint any
---@return string
------------------------------------------------------------------------------------------------------
XP.Unicode_To_UTF8 = function(codepoint)
    if codepoint <= 0x7F then
        return string.char(codepoint)
    elseif codepoint <= 0x7FF then
        return string.char(0xC0 + math.floor(codepoint / 0x40), 0x80 + (codepoint % 0x40))
    elseif codepoint <= 0xFFFF then
        return string.char(0xE0 + math.floor(codepoint / 0x1000), 0x80 + (math.floor(codepoint / 0x40) % 0x40), 0x80 + (codepoint % 0x40))
    elseif codepoint <= 0x10FFFF then
        return string.char(0xF0 + math.floor(codepoint / 0x40000), 0x80 + (math.floor(codepoint / 0x1000) % 0x40), 0x80 + (math.floor(codepoint / 0x40) % 0x40), 0x80 + (codepoint % 0x40))
    else
        return "Codepoint out of range"
    end
end