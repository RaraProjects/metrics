local timers = T{}

timers.Timers = T{}

timers.Enum = T{}
timers.Enum.Names = T{
    PARSE = "Metrics"
}

-- --------------------------------------------------------------------------
-- Start the timer.
-- --------------------------------------------------------------------------
---@param name string name of the timer to check.
-- --------------------------------------------------------------------------
timers.Start = function(name)
    if not name then name = "Default" end
    if not timers.Timers[name] then
        timers.Timers[name] = T{
            Start = os.time(),
            Duration = 0,
        }
    end
    timers.Timers[name].Start = os.time()
    timers.Timers[name].Paused = false
end

-- --------------------------------------------------------------------------
-- End the timer.
-- --------------------------------------------------------------------------
---@param name string name of the timer to check.
-- --------------------------------------------------------------------------
timers.Pause = function(name)
    if timers.Timers[name] then
        local new_duration = os.time() - timers.Timers[name].Start
        timers.Timers[name].Start = nil
        timers.Timers[name].Paused = true
        timers.Timers[name].Duration = timers.Timers[name].Duration + new_duration
    end
end

-- --------------------------------------------------------------------------
-- Resets the timer.
-- --------------------------------------------------------------------------
---@param name string name of the timer to check.
-- --------------------------------------------------------------------------
timers.Reset = function(name)
    timers.Timers[name] = nil
    timers.Start(name)
end

-- --------------------------------------------------------------------------
-- Check the timer.
-- --------------------------------------------------------------------------
---@param name string name of the timer to check.
---@param countdown? boolean true: count down; false: count up
---@return string
-- --------------------------------------------------------------------------
timers.Check = function(name, countdown)
    if timers.Timers[name] then
        local duration = timers.Timers[name].Duration
        if not timers.Timers[name].Paused then
            local start = timers.Timers[name].Start
            local now = os.time()
            duration = duration + (now - start)
        end
        if countdown then
            return timers.Format((countdown * 60) - duration)
        else
            return timers.Format(duration)
        end
    end
    return timers.Format()
end

-- --------------------------------------------------------------------------
-- Formats the display timer.
-- --------------------------------------------------------------------------
---@param time? number duration in seconds.
---@return string
-- --------------------------------------------------------------------------
timers.Format = function(time)
    if not time then return '00:00' end
    local hour, minute, second
    hour   = string.format("%02.f", math.floor(time / 3600))
    minute = string.format("%02.f", math.floor((time / 60) - (hour * 60)))
    second = string.format("%02.f", math.floor(time % 60))
    return hour .. ":" .. minute .. ":" .. second
end

return timers