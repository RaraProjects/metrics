XP.Columns = T{}

XP.Columns.Display_Count = 2

-- ------------------------------------------------------------------------------------------------------
-- Calculates the number of columns to show in the table.
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Count = function()
    local columns = 2
    if Metrics.XP.XP_Job        then columns = columns + 1 end
    if Metrics.XP.Base_Rate     then columns = columns + 1 end
    if Metrics.XP.Kill_Speed    then columns = columns + 1 end
    if Metrics.XP.Average_XP    then columns = columns + 1 end
    if Metrics.XP.Time_To_Level then columns = columns + 1 end
    if Metrics.XP.To_Next_Level then columns = columns + 1 end
    if Metrics.XP.Total_XP      then columns = columns + 1 end
    if Metrics.XP.Max_Chain     then columns = columns + 1 end
    if Metrics.XP.Zone_Time     then columns = columns + 1 end
    if Metrics.XP.XP_Boost_Item then columns = columns + 1 end
    if Metrics.XP.XP_Boost_Rate then columns = columns + 1 end
    if Metrics.XP.XP_Boost_Max  then columns = columns + 1 end
    XP.Columns.Display_Count = columns
    Window.Set_Bar_Delay()
end

-- ------------------------------------------------------------------------------------------------------
-- Creates a column that shows the player's level, job, and subjob with color.
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Job = function()
    local job_data = Ashita.Player.Job_Data()
    local main_string = job_data.main .. string.format("%02d", job_data.main_level)
    local sub_string = job_data.sub .. string.format("%02d", job_data.sub_level)
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
-- Returns the player's tnl/tnm.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.TNL = function(xp_type)
    local current = Ashita.Player.Current_XP()
    local needed = Ashita.Player.Level_XP()
    if xp_type == XP.Type.LIMIT then
        current = Ashita.Player.Limit_XP()
        needed = 10000
    end
    if current == 0 then current = 1 end
    local tnl = needed - current
    return string.format("%d", tnl)
end

-- ------------------------------------------------------------------------------------------------------
-- Get total experience / limit points.
-- ------------------------------------------------------------------------------------------------------
---@param type string
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Total_XP = function(type)
    local return_string = ""

    -- Split mode: Base XP (+Bonus XP)
    if XP.Config.Total_Mode == "Split" then
        local base_xp = XP.Metric.Experience_Base
        local bonus_xp = XP.Metric.Experience_Boosted
        if type == XP.Type.LIMIT then
            base_xp = XP.Metric.Limit_Base
            bonus_xp = XP.Metric.Limit_Boosted
        end
        return_string = string.format("%d", base_xp) .. " (+" .. string.format("%d", bonus_xp) .. ")"

    -- Combined mode: Total XP
    else
        local total_xp = XP.Metric.Experience_Total
        if type == XP.Type.LIMIT then total_xp = XP.Metric.Limit_Total end
        return_string = string.format("%d", total_xp)
    end

    return return_string
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the average kill time in seconds.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Average_Kill_Time = function()
    if XP.Last_XP_Time == 0 then return -1 end
    local duration = os.time() - XP.Last_XP_Time
    local total = 0
    local count = 0
    for _, time in ipairs(XP.Kill_Times) do
        total = total + time
        count = count + 1
    end
    if count == 0 then return duration end
    local average = total / count
    return average
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the average XP per kill.
-- ------------------------------------------------------------------------------------------------------
---@param base_only? boolean
---@return number
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Average_XP = function(base_only)
    if XP.Last_XP_Time == 0 then return 0 end
    local total = 0
    local count = 0
    if base_only then
        for _, time in ipairs(XP.XP_Per_Kill_Base) do
            total = total + time
            count = count + 1
        end
    else
        for _, time in ipairs(XP.XP_Per_Kill) do
            total = total + time
            count = count + 1
        end
    end
    if count == 0 then return 0 end
    return total / count
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the average XP per hour.
-- ------------------------------------------------------------------------------------------------------
---@param base_only? boolean
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Average_Rate = function(base_only)
    if XP.Last_XP_Time == 0 then return string.format("%d", 0) end
    local average_xp = XP.Columns.Average_XP(base_only)
    if average_xp <= 0 then return string.format("%d", 0) end
    local kill_speed = XP.Columns.Average_Kill_Time()
    if kill_speed <= 0 then return string.format("%d", 0) end
    local final = (average_xp / kill_speed) * 3600
    if final > 99999 then final = 99999 end
    local return_string = string.format("%d", final)
    if not base_only and XP.Dedication.Is_Active then return_string = return_string .. "*" end
    return return_string
end

-- ------------------------------------------------------------------------------------------------------
-- Calculates the estimated time to level given XP rate.
-- ------------------------------------------------------------------------------------------------------
---@param type? string
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Time_To_Level = function(type)
    local color = Res.Colors.Basic.WHITE
    if XP.Last_XP_Time == 0 then return UI.TextColored(color, "--:--:--") end
    local duration = os.time() - XP.Last_XP_Time

    if not type then type = XP.Type.EXPERIENCE end
    local tnl = Ashita.Player.Exp_TNL()
    if type == XP.Type.LIMIT then tnl = Ashita.Player.Exp_TNM() end

    local average_xp = XP.Columns.Average_XP()
    if average_xp <= 0 then return UI.TextColored(color, "--:--:--") end

    color = Res.Colors.Basic.WHITE
    local kill_speed = XP.Columns.Average_Kill_Time()
    local kills_needed = tnl / average_xp
    local total_time = kill_speed * kills_needed
    local final_time = total_time - duration
    if final_time < 0 then final_time = 0 end
    return UI.TextColored(color, Timers.Format(final_time))
end

-- ------------------------------------------------------------------------------------------------------
-- Calculates the estimated time to level given XP rate.
-- ------------------------------------------------------------------------------------------------------
---@param type? string
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Time_To_Level_Local = function(type)
    if not type then type = XP.Type.EXPERIENCE end
    local rate_minute = XP.Local.Get_Rate(type) / 3600
    local tnl = Ashita.Player.Exp_TNL()
    if type == XP.Type.LIMIT then tnl = Ashita.Player.Exp_TNM() end
    if rate_minute == 0 then return "---" end
    local now = os.time()
    local estimated_time = XP.Last_XP_Time + (tnl / rate_minute)
    local time_remaining = estimated_time - now
    if time_remaining < 0 then return Timers.Format(0) end
    return Timers.Format(time_remaining)
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the max chain.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Max_Chain = function()
    return tostring(XP.Metric.Max_Chain)
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
    local bonus_xp = Metrics.XP.Boost_EXP
    local max_xp = Metrics.XP.Boost_Item_Max
    local denominator = tostring(max_xp)
    if not max_xp or max_xp <= 0 then denominator = "???" end
    return string.format("%d", bonus_xp) .. "/" .. denominator
end

-- ------------------------------------------------------------------------------------------------------
-- Displays how much the dedication bonus is.
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Dedication_Bonus = function()
    local rate = Metrics.XP.Boost_Item_Rate
    if rate < 0 then return "???" end
    return tostring(rate) .. "%"
end