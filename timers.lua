local timers = T{}

timers.Timers = T{}

timers.Enum = T{}
timers.Enum.Names = T{
    PARSE = "Metrics",
    AUTOPAUSE = "Auto-Pause",
    AUTOSAVE = "Auto-Save",
}

timers.Tresholds = T{
    AUTOPAUSE = 5,
}

------------------------------------------------------------------------------------------------------
-- Start the timer.
------------------------------------------------------------------------------------------------------
---@param name string name of the timer to check.
------------------------------------------------------------------------------------------------------
timers.Start = function(name)
    if not name then name = "Default" end
    if not timers.Timers[name] then
        timers.Timers[name] = T{
            Start = os.time(),
            Duration = 0,
            Paused = false
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
            local new_duration = os.time() - timers.Timers[name].Start
            timers.Timers[name].Paused = true
            timers.Timers[name].Duration = timers.Timers[name].Duration + new_duration
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
            timers.Timers[name].Start = os.time()
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
timers.Is_Paused = function(name)
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
------------------------------------------------------------------------------------------------------
timers.Get_Duration = function(name)
    local duration = 0
    if timers.Timers[name] then
        duration = timers.Timers[name].Duration
        if not timers.Timers[name].Paused then
            local start = timers.Timers[name].Start
            local now = os.time()
            duration = duration + (now - start)
        end
    end
    return duration
end

------------------------------------------------------------------------------------------------------
-- Check the timer.
------------------------------------------------------------------------------------------------------
---@param name string name of the timer to check.
---@param countdown? boolean true: count down; false: count up
---@return string
------------------------------------------------------------------------------------------------------
timers.Check = function(name, countdown)
    if timers.Timers[name] then
        local duration = timers.Get_Duration(name)
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
    local duration = timers.Get_Duration(name)
    if name == Timers.Enum.Names.AUTOPAUSE then
        if duration > timers.Tresholds.AUTOPAUSE then
            timers.Pause(timers.Enum.Names.PARSE)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Formats the display timer.
------------------------------------------------------------------------------------------------------
---@param time? number duration in seconds.
---@return string
------------------------------------------------------------------------------------------------------
timers.Format = function(time)
    if not time then return '00:00' end
    local hour, minute, second
    hour   = string.format("%02.f", math.floor(time / 3600))
    minute = string.format("%02.f", math.floor((time / 60) - (hour * 60)))
    second = string.format("%02.f", math.floor(time % 60))
    return hour .. ":" .. minute .. ":" .. second
end

return timers