XP.Columns = T{}

XP.Columns.Display_Count = 2

-- ------------------------------------------------------------------------------------------------------
-- Calculates the number of columns to show in the table.
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Count = function()
    local columns = 2
    if Metrics.Parse.Base_Rate     then columns = columns + 1 end
    if Metrics.Parse.Time_To_Level then columns = columns + 1 end
    if Metrics.Parse.To_Next_Level then columns = columns + 1 end
    if Metrics.Parse.Total_XP      then columns = columns + 1 end
    if Metrics.Parse.XP_Boost_Item then columns = columns + 1 end
    if Metrics.Parse.XP_Boost_Rate then columns = columns + 1 end
    if Metrics.Parse.XP_Boost_Max  then columns = columns + 1 end
    XP.Columns.Display_Count = columns
end

-- ------------------------------------------------------------------------------------------------------
-- Get chain timer.
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Chain = function()
    return tostring(XP.Chains.Current) .. "->" .. tostring(XP.Chains.Current + 1) .. " " .. tostring(XP.Chains.Timer())
end

-- ------------------------------------------------------------------------------------------------------
-- Get total experience / limit points.
-- ------------------------------------------------------------------------------------------------------
---@param type string
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
-- Calculates the estimated time to level given XP rate.
-- ------------------------------------------------------------------------------------------------------
---@param type string
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Time_To_Level = function(type)
    if not type then type = XP.Type.EXPERIENCE end
    local rate_minute = XP.Local.Get_Rate(type) / 3600
    local tnl = Ashita.Player.Exp_TNL()
    if type == XP.Type.LIMIT then tnl = Ashita.Player.Exp_TNM() end
    if rate_minute == 0 then return "---" end
    local now = os.time()
    local estimated_time = XP.Last_XP_Time + (tnl / rate_minute)
    return Timers.Format(estimated_time - now)
end

-- ------------------------------------------------------------------------------------------------------
-- Displays how far the player is through their dedication charge.
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Dedication_Progress = function()
    if not XP.Is_Dedication_Active then return "None" end
    local bonus_xp = XP.Metric.Experience_Boosted + XP.Metric.Limit_Boosted
    local max_xp = XP.Dedication_Max
    local denominator = tostring(max_xp)
    if not max_xp or max_xp <= 0 then denominator = "???" end
    return string.format("%d", bonus_xp) .. "/" .. denominator
end

-- ------------------------------------------------------------------------------------------------------
-- Displays how much the dedication bonus is.
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Dedication_Bonus = function()
    local rate = XP.Dedication_Rate
    if rate < 0 then return "???" end
    return tostring(rate) .. "%"
end