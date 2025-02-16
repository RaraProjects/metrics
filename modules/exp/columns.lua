XP.Columns = { }

XP.Columns.DisplayCount = 2

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

    XP.Columns.DisplayCount = columns

    Window_Manager.SetBarDelay()
end

-- ------------------------------------------------------------------------------------------------------
-- Creates a column that shows the player's level, job, and subjob with color.
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Job = function()
    local jobData = Ashita.Player.JobData()
    local mainJob = string.format("%s%02d", jobData.main, jobData.main_level)
    local subJob  = string.format("%s%02d", jobData.sub, jobData.sub_level)

    UI.TextColored(jobData.main_color, mainJob)
    UI.SameLine() UI.Text("/") UI.SameLine()
    UI.TextColored(jobData.sub_color, subJob)
end

-- ------------------------------------------------------------------------------------------------------
-- Get chain timer.
-- ------------------------------------------------------------------------------------------------------
XP.Columns.Chain = function()
    local chainNumber = XP.Tracking.Chains.Current
    local chainString = string.format(" (%s)", (chainNumber < 0) and "-" or chainNumber)

    XP.Chains.Timer() UI.SameLine() UI.Text(chainString)
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the average kill time in seconds.
-- ------------------------------------------------------------------------------------------------------
---@param lastXpInstant integer
---@param killTimes     table
---@return integer
-- ------------------------------------------------------------------------------------------------------
XP.Columns.AverageKillTime = function(lastXpInstant, killTimes)
    if lastXpInstant == 0 then
        return -1
    end

    local duration = os.time() - lastXpInstant
    local count = #killTimes

    if count == 0 then
        return duration
    end

    local totalTime = 0

    for _, time in ipairs(killTimes) do
        totalTime = totalTime + time
    end

    return totalTime / count
end

-- ------------------------------------------------------------------------------------------------------
-- Get total experience / limit points.
-- ------------------------------------------------------------------------------------------------------
---@param xpType integer
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.TotalXP = function(xpType)
    -- Split mode: Base XP (+Bonus XP)
    if XP.Config.Total_Mode == "Split" then
        local baseXp  = (xpType == XP.Type.LIMIT) and XP.Tracking.Limit.Base or XP.Tracking.EXP.Base
        local bonusXp = (xpType == XP.Type.LIMIT) and XP.Tracking.Limit.Boosted or XP.Tracking.EXP.Boosted

        return string.format("%d (+%d)", baseXp, bonusXp)
    end

    -- Combined mode: Total XP
    local totalXp = (xpType == XP.Type.LIMIT) and XP.Tracking.Limit.Total or XP.Tracking.EXP.Total

    return string.format("%d", totalXp)
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the player's tnl/tnm.
-- ------------------------------------------------------------------------------------------------------
---@param xpType integer
---@param raw?   boolean
---@return integer|string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.TNL = function(xpType, raw)
    local xpData =
    {
        [XP.Type.EXPERIENCE] = function() return Ashita.Player.CurrentXP(),      Ashita.Player.LevelMaxXP() end,
        [XP.Type.LIMIT]      = function() return Ashita.Player.CurrentLimit(),   10000 end,
        [XP.Type.CAPACITY]   = function() return XP.Tracking.Capacity.Total,     30000 end,
        [XP.Type.EXEMPLAR]   = function() return XP.Tracking.Exemplar.IntoLevel, XP.Tracking.Exemplar.LevelMax end,
    }

    local current = 0
    local needed  = 0

    if xpData[xpType] then
        current, needed = xpData[xpType]()
    end

    current   = math.max(current, 1)
    local tnl = math.max(needed - current, 0)

    if raw then
        return tnl
    end

    return XP.Settings.Show_Level_Max and string.format("%d/%d", current, needed) or string.format("%d", tnl)
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the average XP per kill.
-- ------------------------------------------------------------------------------------------------------
---@param xpType     integer
---@param baseOnly?  boolean
---@param boostOnly? boolean
---@return number
-- ------------------------------------------------------------------------------------------------------
XP.Columns.AverageXP = function(xpType, baseOnly, boostOnly)
    local averageWindows = XP.Tracking.AverageWindows

    local xpData =
    {
        [XP.Type.EXPERIENCE] =
        {
            instant = XP.Tracking.EXP.LastXpInstant or 0,
            list    = (baseOnly and averageWindows.ExpBase) or (boostOnly and averageWindows.ExpBoost) or averageWindows.ExpTotal or { },
        },
        [XP.Type.LIMIT] =
        {
            instant = XP.Tracking.EXP.LastXpInstant or 0,
            list    = (baseOnly and averageWindows.ExpBase) or (boostOnly and averageWindows.ExpBoost) or averageWindows.ExpTotal or { },
        },
        [XP.Type.CAPACITY] =
        {
            instant = XP.Tracking.Capacity.LastXpInstant or 0,
            list    = averageWindows.CapacityBase or { },
        },
        [XP.Type.EXEMPLAR] =
        {
            instant = XP.Tracking.Exemplar.LastXpInstant or 0,
            list    = averageWindows.ExemplarBase or { },
        },
    }

    local data = xpData[xpType]

    if not data or data.instant == 0 or #data.list == 0 then
        return 0
    end

    local totalXP = 0

    for _, xpAmount in ipairs(data.list) do
        totalXP = totalXP + xpAmount
    end

    return totalXP / #data.list
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the average XP per hour.
-- ------------------------------------------------------------------------------------------------------
---@param xpType    integer
---@param baseOnly? boolean
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.AverageRate = function(xpType, baseOnly)
    local xpData =
    {
        [XP.Type.EXPERIENCE] = { XP.Tracking.EXP.LastXpInstant,      XP.Tracking.EXP.KillTimes,      true  },
        [XP.Type.LIMIT]      = { XP.Tracking.EXP.LastXpInstant,      XP.Tracking.EXP.KillTimes,      true  },
        [XP.Type.CAPACITY]   = { XP.Tracking.Capacity.LastXpInstant, XP.Tracking.Capacity.KillTimes, false },
        [XP.Type.EXEMPLAR]   = { XP.Tracking.Exemplar.LastXpInstant, XP.Tracking.Exemplar.KillTimes, false },
    }

    local data = xpData[xpType]

    if not data then
        return "0"
    end

    local lastXpInstant  = data[1] or 0
    local killTimes      = data[2] or { }
    local showDedication = data[3] or false

    -- Need to add some type checks here to satify the type restrictions on AverageKillTime.
    if not lastXpInstant or lastXpInstant == 0 then
        return "0"
    end

    -- Get the average experience points.
    local averageXp = XP.Columns.AverageXP(xpType, baseOnly)

    if averageXp <= 0 then
        return "0"
    end

    -- Get the average kill speed.
    local killSpeed = XP.Columns.AverageKillTime(lastXpInstant, killTimes)

    if killSpeed <= 0 then
        return "0"
    end

    -- Rate calculation.
    local xpRate     = (averageXp / killSpeed) * 3600
    local rateString = (xpRate >= 100000) and string.format("%dK", xpRate / 1000) or string.format("%d", xpRate)

    -- Append dedication icon if dedication is active.
    if not baseOnly and showDedication and XP.Dedication.IsActive then
        rateString = string.format("%s*", rateString)
    end

    return rateString
end

-- ------------------------------------------------------------------------------------------------------
-- Calculates the estimated time to level given XP rate.
-- ------------------------------------------------------------------------------------------------------
---@param xpType integer
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.TimeToLevel = function(xpType)
    local color = Res.Colors.Basic.WHITE

    local xpData =
    {
        [XP.Type.EXPERIENCE] = { XP.Tracking.EXP.LastXpInstant,      XP.Tracking.EXP.KillTimes      },
        [XP.Type.LIMIT]      = { XP.Tracking.EXP.LastXpInstant,      XP.Tracking.EXP.KillTimes      },
        [XP.Type.CAPACITY]   = { XP.Tracking.Capacity.LastXpInstant, XP.Tracking.Capacity.KillTimes },
        [XP.Type.EXEMPLAR]   = { XP.Tracking.Exemplar.LastXpInstant, XP.Tracking.Exemplar.KillTimes },
    }

    local data = xpData[xpType]

    if not data then
        return UI.TextColored(color, Timers.Format(0))
    end

    local lastXpGainTime = data[1] or 1
    local killTimes      = data[2] or { }
    local averageXp      = XP.Columns.AverageXP(xpType)

    if lastXpGainTime == 0 or averageXp <= 0 then
        return UI.TextColored(color, "--:--:--")
    end

    local duration    = os.time() - lastXpGainTime
    local tnl         = XP.Columns.TNL(xpType, true)
    local killSpeed   = XP.Columns.AverageKillTime(lastXpGainTime, killTimes)
    local killsNeeded = tnl / averageXp
    local totalTime   = killSpeed * killsNeeded
    local finalTime   = math.max(totalTime - duration, 0)

    return UI.TextColored(color, Timers.Format(finalTime))
end

-- ------------------------------------------------------------------------------------------------------
-- Calculates the estimated time to finish dedication given XP rate.
-- ------------------------------------------------------------------------------------------------------
---@param xpType? integer
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.TimeToFinishDedication = function(xpType)
    local color = Res.Colors.Basic.WHITE
    local exp   = XP.Tracking.EXP
    xpType      = xpType or XP.Type.EXPERIENCE

    if not XP.Dedication.IsActive or exp.LastXpInstant == 0 then
        return UI.TextColored(color, "--:--:--")
    end

    local duration       = os.time() - exp.LastXpInstant
    local boostRemaining = (xpType == XP.Type.LIMIT) and Ashita.Player.ExpTNM() or XP.Dedication.XpRemaining()
    local averageXp      = XP.Columns.AverageXP(xpType, nil, true)

    if averageXp <= 0 then
        return UI.TextColored(color, "--:--:--")
    end

    local killSpeed   = XP.Columns.AverageKillTime(exp.LastXpInstant, exp.KillTimes)
    local killsNeeded = boostRemaining / averageXp
    local totalTime   = killSpeed * killsNeeded
    local finalTime   = math.max(totalTime - duration, 0)

    return UI.TextColored(color, Timers.Format(finalTime))
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the max chain.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.MaxChain = function()
    return tostring(XP.Tracking.Chains.Max)
end

-- ------------------------------------------------------------------------------------------------------
-- Returns how long the player has been in the current zone.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Columns.ZoneTime = function()
    return Timers.Check(Timers.Enum.Names.ZONE)
end

-- ------------------------------------------------------------------------------------------------------
-- Displays how far the player is through their dedication charge.
-- ------------------------------------------------------------------------------------------------------
XP.Columns.DedicationProgress = function()
    if not XP.Dedication.IsActive then
        return "None"
    end

    local bonusXP     = XP.Settings.Boost_XP_Acquired
    local maxXP       = XP.Settings.Boost_Item_Max

    if not maxXP or maxXP <= 0 then
        return string.format("%d/???", bonusXP)
    end

    return string.format("%d/%d", bonusXP, maxXP)
end

-- ------------------------------------------------------------------------------------------------------
-- Displays how much the dedication bonus is.
-- ------------------------------------------------------------------------------------------------------
XP.Columns.DedicationBonus = function()
    local rate = XP.Settings.Boost_Item_Rate

    if rate < 0 then
        return "???"
    end

    return string.format("%d%%", rate)
end