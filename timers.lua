local timers = { }

timers.Timers = { }

timers.Types =
{
    METRICS   = "Total Runtime",
    PARSE     = "Active Time",
    AUTOPAUSE = "Auto-Pause",
    AUTOSAVE  = "Auto-Save",
    DPS       = "DPS",
    CHAIN     = "Chain",
    ZONE      = "Zone",
}

timers.Tresholds =
{
    AUTOPAUSE = 5,
}

------------------------------------------------------------------------------------------------------
-- Start the timer.
------------------------------------------------------------------------------------------------------
---@param name string name of the timer to check.
------------------------------------------------------------------------------------------------------
timers.Start = function(name)
    name = name or "Default"

    if not timers.Timers[name] then
        timers.Timers[name] =
        {
            Start    = os.time(),
            Duration = 0,
            Paused   = false
        }
    end
end

------------------------------------------------------------------------------------------------------
-- Pause the timer.
------------------------------------------------------------------------------------------------------
---@param name string name of the timer to check.
------------------------------------------------------------------------------------------------------
timers.Pause = function(name)
    if timers.Timers[name] then
        if not timers.Timers[name].Paused then
            local newDuration = os.time() - timers.Timers[name].Start

            timers.Timers[name].Paused   = true
            timers.Timers[name].Duration = timers.Timers[name].Duration + newDuration
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Unpause the timer.
------------------------------------------------------------------------------------------------------
---@param name string name of the timer to check.
------------------------------------------------------------------------------------------------------
timers.Unpause = function(name)
    if timers.Timers[name] then
        if timers.Timers[name].Paused then
            timers.Timers[name].Start  = os.time()
            timers.Timers[name].Paused = false
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Checks if a timer is paused.
------------------------------------------------------------------------------------------------------
---@param name string name of the timer to check.
---@return boolean
------------------------------------------------------------------------------------------------------
timers.IsPaused = function(name)
    if timers.Timers[name] then
        return timers.Timers[name].Paused
    end

    return false
end

------------------------------------------------------------------------------------------------------
-- Resets the timer.
------------------------------------------------------------------------------------------------------
---@param name string name of the timer to check.
------------------------------------------------------------------------------------------------------
timers.Reset = function(name)
    timers.Timers[name] = nil
    timers.Start(name)
end

------------------------------------------------------------------------------------------------------
-- Gets the duration for a timer.
------------------------------------------------------------------------------------------------------
---@param name string name of the timer to check.
---@return number
------------------------------------------------------------------------------------------------------
timers.GetDuration = function(name)
    local duration = 0

    if timers.Timers[name] then
        duration = timers.Timers[name].Duration

        if not timers.Timers[name].Paused then
            local start = timers.Timers[name].Start
            local now   = os.time()

            duration = duration + (now - start)
        end
    end

    return duration
end

------------------------------------------------------------------------------------------------------
-- Check the timer.
------------------------------------------------------------------------------------------------------
---@param name       string  name of the timer to check.
---@param countdown? boolean true: count down; false: count up
---@return string
------------------------------------------------------------------------------------------------------
timers.Check = function(name, countdown)
    if timers.Timers[name] then
        local duration = timers.GetDuration(name)

        if countdown then
            return timers.Format((countdown * 60) - duration)
        else
            return timers.Format(duration)
        end
    end

    return timers.Format()
end

------------------------------------------------------------------------------------------------------
-- Take an action when a timer passes its threshold.
------------------------------------------------------------------------------------------------------
---@param name string name of the timer to check.
------------------------------------------------------------------------------------------------------
timers.Cycle = function(name)
    local duration = timers.GetDuration(name)

    if name == Timers.Types.AUTOPAUSE then
        if duration > timers.Tresholds.AUTOPAUSE then
            timers.Pause(Timers.Types.PARSE)
        end

    elseif name == Timers.Types.DPS then
        if duration > DB.DPS.SnapshotTime then
            DB.DPS.CreateSnapshot()
            timers.Reset(Timers.Types.DPS)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Formats the display timer.
------------------------------------------------------------------------------------------------------
---@param time?     number  duration in seconds.
---@param hideHour? boolean
---@return string
------------------------------------------------------------------------------------------------------
timers.Format = function(time, hideHour)
    if not time then
        return "00:00"
    end

    local hour          = string.format("%02.f", math.floor(time / 3600))
    local minute        = string.format("%02.f", math.floor((time / 60) - (hour * 60)))
    local second        = string.format("%02.f", math.floor(time % 60))
    local formattedTime = minute .. ":" .. second

    if not hideHour then
        formattedTime = hour .. ":" .. formattedTime
    end

    return formattedTime
end

return timers