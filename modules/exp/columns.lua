XP.Columns = {}

XP.Columns.Display_Count = 2

-- ------------------------------------------------------------------------------------------------------
-- Calculates the number of columns to show in the table.
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Count = function()
    local columns = 2
    if XP.Settings.Show_Job                 then columns = columns + 1 end
    if XP.Settings.Show_Base_Rate           then columns = columns + 1 end
    if XP.Settings.Show_Kill_Rate           then columns = columns + 1 end
    if XP.Settings.Show_Average_XP          then columns = columns + 1 end
    if XP.Settings.Show_Time_To_Level       then columns = columns + 1 end
    if XP.Settings.Show_Boost_Time_To_Level then columns = columns + 1 end
    if XP.Settings.Show_TNL                 then columns = columns + 1 end
    if XP.Settings.Show_Capacity_Base_Rate  then columns = columns + 1 end
    if XP.Settings.Show_Time_To_Job_Point   then columns = columns + 1 end
    if XP.Settings.Show_TNJP                then columns = columns + 1 end
    if XP.Settings.Show_Exemplar_Base_Rate  then columns = columns + 1 end
    if XP.Settings.Show_Time_To_Mastery     then columns = columns + 1 end
    if XP.Settings.Show_TNML                then columns = columns + 1 end
    if XP.Settings.Show_Total_XP_Gained     then columns = columns + 1 end
    if XP.Settings.Show_Max_Chain           then columns = columns + 1 end
    if XP.Settings.Show_Zone_Time           then columns = columns + 1 end
    if XP.Settings.Show_Boost_Item          then columns = columns + 1 end
    if XP.Settings.Show_Boost_Rate          then columns = columns + 1 end
    if XP.Settings.Show_Boost_Max           then columns = columns + 1 end
    XP.Columns.Display_Count = columns
    Window_Manager.Set_Bar_Delay()
end

-- ------------------------------------------------------------------------------------------------------
-- Creates a column that shows the player's level, job, and subjob with color.
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Job = function()
    local job_data    = Ashita.Player.Job_Data()
    local main_string = job_data.main .. string.format("%02d", job_data.main_level)
    local sub_string  = job_data.sub .. string.format("%02d", job_data.sub_level)
    if job_data.sub == "NON" then sub_string = "" end

    UI.TextColored(job_data.main_color, main_string)
    UI.SameLine() UI.Text("/") UI.SameLine()
    UI.TextColored(job_data.sub_color, sub_string)
end

-- ------------------------------------------------------------------------------------------------------
-- Get chain timer.
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Chain = function()
    local chain = tostring(XP.Chains.Current)
    if XP.Chains.Current < 0 then chain = "-" end
    XP.Chains.Timer() UI.SameLine() UI.Text(" (" .. chain .. ")")
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the average kill time in seconds.
-- ------------------------------------------------------------------------------------------------------
---@param last_xp_time integer
---@param kill_times table
---@return integer
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Average_Kill_Time = function(last_xp_time, kill_times)
    if last_xp_time == 0 then return -1 end
    local duration = os.time() - last_xp_time
    local total = 0
    local count = 0
    for _, time in ipairs(kill_times) do
        total = total + time
        count = count + 1
    end
    if count == 0 then return duration end
    local average = total / count
    return average
end

-- ------------------------------------------------------------------------------------------------------
-- Get total experience / limit points.
-- ------------------------------------------------------------------------------------------------------
---@param type integer
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Total_XP = function(type)
    local return_string = ""

    -- Split mode: Base XP (+Bonus XP)
    if XP.Config.Total_Mode == "Split" then
        local base_xp  = XP.Tracking.Metric.Experience_Base
        local bonus_xp = XP.Tracking.Metric.Experience_Boosted
        if type == XP.Type.LIMIT then
            base_xp  = XP.Tracking.Metric.Limit_Base
            bonus_xp = XP.Tracking.Metric.Limit_Boosted
        end
        return_string = string.format("%d", base_xp) .. " (+" .. string.format("%d", bonus_xp) .. ")"

    -- Combined mode: Total XP
    else
        local total_xp = XP.Tracking.Metric.Experience_Total
        if type == XP.Type.LIMIT then total_xp = XP.Tracking.Metric.Limit_Total end
        return_string = string.format("%d", total_xp)
    end

    return return_string
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the player's tnl/tnm.
-- ------------------------------------------------------------------------------------------------------
---@param xp_type integer
---@param raw? boolean
---@return integer|string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.TNL = function(xp_type, raw)
    local current = 0
    local needed  = 0

    if xp_type == XP.Type.EXPERIENCE then
        current = Ashita.Player.Current_XP()
        needed  = Ashita.Player.Level_Max_XP()

    elseif xp_type == XP.Type.LIMIT then
        current = Ashita.Player.Current_Limit()
        needed = 10000

    elseif xp_type == XP.Type.CAPACITY then
        current = XP.Tracking.Metric.Capacity_Current
        needed  = 30000

    elseif xp_type == XP.Type.EXEMPLAR then
        current = XP.Tracking.Metric.Exemplar_Current
        needed  = XP.Tracking.Metric.Exemplar_Max
    end

    if current == 0 then current = 1 end

    local tnl = needed - current
    if raw then return tnl end

    -- Show Current/Max
    if XP.Settings.Show_Level_Max then return tostring(current) .. "/" .. tostring(needed) end
    return string.format("%d", tnl)
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the average XP per kill.
-- ------------------------------------------------------------------------------------------------------
---@param xp_type integer
---@param base_only? boolean
---@return number
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Average_XP = function(xp_type, base_only)
    local last_xp_gain_time = 0
    local xp_list = {}

    if xp_type == XP.Type.EXPERIENCE or xp_type == XP.Type.LIMIT then
        last_xp_gain_time = XP.Tracking.Last_XP_Gain_Time
        xp_list = XP.Tracking.Per_Kill_Base_And_Boost
        if base_only then xp_list = XP.Tracking.Per_Kill_Base_XP_Only end

    elseif xp_type == XP.Type.CAPACITY then
        last_xp_gain_time = XP.Tracking.Last_CP_Gain_Time
        xp_list = XP.Tracking.Per_Kill_Capacity_Base

    elseif xp_type == XP.Type.EXEMPLAR then
        last_xp_gain_time = XP.Tracking.Last_EP_Gain_Time
        xp_list = XP.Tracking.Per_Kill_Exemplar_Base
    end

    if last_xp_gain_time == 0 then return 0 end

    local total = 0
    local count = 0

    for _, xp_amount in ipairs(xp_list) do
        total = total + xp_amount
        count = count + 1
    end

    if count == 0 then return 0 end
    return total / count
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the average XP per hour.
-- ------------------------------------------------------------------------------------------------------
---@param xp_type integer
---@param base_only? boolean
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Average_Rate = function(xp_type, base_only)
    local last_xp_gain_time = 0
    local kill_times = {}
    local show_dedication = false

    if xp_type == XP.Type.EXPERIENCE or xp_type == XP.Type.LIMIT then
        last_xp_gain_time = XP.Tracking.Last_XP_Gain_Time
        kill_times = XP.Tracking.Kill_Times_XP
        show_dedication = true
        if base_only then kill_times = XP.Tracking.Per_Kill_Base_XP_Only end

    elseif xp_type == XP.Type.CAPACITY then
        last_xp_gain_time = XP.Tracking.Last_CP_Gain_Time
        kill_times = XP.Tracking.Kill_Times_CP

    elseif xp_type == XP.Type.EXEMPLAR then
        last_xp_gain_time = XP.Tracking.Last_EP_Gain_Time
        kill_times = XP.Tracking.Kill_Times_EP
    end

    if last_xp_gain_time == 0 then return string.format("%d", 0) end

    -- Get the average experience points.
    local average_xp = XP.Columns.Average_XP(xp_type, base_only)
    if average_xp <= 0 then return string.format("%d", 0) end

    -- Get the average kill speed.
    local kill_speed = XP.Columns.Average_Kill_Time(last_xp_gain_time, kill_times)
    if kill_speed <= 0 then return string.format("%d", 0) end

    -- Rate calculation.
    local final = (average_xp / kill_speed) * 3600

    local abbreviate = false
    if final >= 100000 then
        final = final / 1000
        abbreviate = true
    end

    local return_string = string.format("%d", final)

    if abbreviate then return_string = return_string .. "K" end
    if not base_only and show_dedication and XP.Dedication.Is_Active then return_string = return_string .. "*" end

    return return_string
end

-- ------------------------------------------------------------------------------------------------------
-- Calculates the estimated time to level given XP rate.
-- ------------------------------------------------------------------------------------------------------
---@param xp_type integer
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Time_To_Level = function(xp_type)
    if not xp_type then xp_type = XP.Type.EXPERIENCE end
    local color = Res.Colors.Basic.WHITE

    local last_xp_gain_time = 0
    local kill_times        = {}

    if xp_type == XP.Type.EXPERIENCE or xp_type == XP.Type.LIMIT then
        last_xp_gain_time = XP.Tracking.Last_XP_Gain_Time
        kill_times        = XP.Tracking.Kill_Times_XP

    elseif xp_type == XP.Type.CAPACITY then
        last_xp_gain_time = XP.Tracking.Last_CP_Gain_Time
        kill_times        = XP.Tracking.Kill_Times_CP

    elseif xp_type == XP.Type.EXEMPLAR then
        last_xp_gain_time = XP.Tracking.Last_EP_Gain_Time
        kill_times        = XP.Tracking.Kill_Times_EP

    else
        return UI.TextColored(color, Timers.Format(0))
    end

    if last_xp_gain_time == 0 then return UI.TextColored(color, "--:--:--") end

    local duration = os.time() - last_xp_gain_time
    local tnl      = XP.Columns.TNL(xp_type, true)

    local average_xp = XP.Columns.Average_XP(xp_type)
    if average_xp <= 0 then return UI.TextColored(color, "--:--:--") end

    color = Res.Colors.Basic.WHITE
    local kill_speed = XP.Columns.Average_Kill_Time(last_xp_gain_time, kill_times)

    local kills_needed = tnl / average_xp
    local total_time = kill_speed * kills_needed
    local final_time = total_time - duration
    if final_time < 0 then final_time = 0 end

    return UI.TextColored(color, Timers.Format(final_time))
end

-- ------------------------------------------------------------------------------------------------------
-- Calculates the estimated time to finish dedication given XP rate.
-- ------------------------------------------------------------------------------------------------------
---@param xp_type? integer
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Time_To_Finish_Dedication = function(xp_type)
    local color = Res.Colors.Basic.WHITE

    if not XP.Dedication.Is_Active or XP.Tracking.Last_XP_Gain_Time == 0 then return UI.TextColored(color, "--:--:--") end
    local duration = os.time() - XP.Tracking.Last_XP_Gain_Time

    if not xp_type then xp_type = XP.Type.EXPERIENCE end
    local dedication_remaining = XP.Dedication.XP_Remaining()
    if xp_type == XP.Type.LIMIT then dedication_remaining = Ashita.Player.Exp_TNM() end

    local average_xp = XP.Columns.Average_XP(xp_type)
    if average_xp <= 0 then return UI.TextColored(color, "--:--:--") end

    color = Res.Colors.Basic.WHITE
    local kill_speed = XP.Columns.Average_Kill_Time(XP.Tracking.Last_XP_Gain_Time, XP.Tracking.Kill_Times_XP)
    local kills_needed = dedication_remaining / average_xp
    local total_time = kill_speed * kills_needed
    local final_time = total_time - duration
    if final_time < 0 then final_time = 0 end
    return UI.TextColored(color, Timers.Format(final_time))
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the max chain.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Max_Chain = function()
    return tostring(XP.Tracking.Metric.Max_Chain)
end

-- ------------------------------------------------------------------------------------------------------
-- Returns how long the player has been in the current zone.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Zone_Time = function()
    return Timers.Check(Timers.Enum.Names.ZONE)
end

-- ------------------------------------------------------------------------------------------------------
-- Displays how far the player is through their dedication charge.
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Dedication_Progress = function()
    if not XP.Dedication.Is_Active then return "None" end
    local bonus_xp = XP.Settings.Boost_XP_Acquired
    local max_xp = XP.Settings.Boost_Item_Max
    local denominator = tostring(max_xp)
    if not max_xp or max_xp <= 0 then denominator = "???" end
    return string.format("%d", bonus_xp) .. "/" .. denominator
end

-- ------------------------------------------------------------------------------------------------------
-- Displays how much the dedication bonus is.
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Dedication_Bonus = function()
    local rate = XP.Settings.Boost_Item_Rate
    if rate < 0 then return "???" end
    return tostring(rate) .. "%"
end