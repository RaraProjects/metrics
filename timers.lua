local timers = {}

timers.Timers = {}

-- --------------------------------------------------------------------------
-- Start the timer.
-- --------------------------------------------------------------------------
---@param name string name of the timer to check.
-- --------------------------------------------------------------------------
timers.Start = function(name)
    if not name then name = "Default" end
    if not timers.Timers[name] then
        timers.Timers[name] = {}
    end
    timers.Timers[name].Start = os.time()
end

-- --------------------------------------------------------------------------
-- End the timer.
-- --------------------------------------------------------------------------
---@param name string name of the timer to check.
-- --------------------------------------------------------------------------
timers.End = function(name)
    if timers.Timers[name] then
        timers.Timers[name].Start = nil
    end
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
        local start = timers.Timers[name].Start
        local now = os.time()
        local duration = now - start
        if countdown then
            return timers.Format((countdown * 60) - duration)
        else
            return timers.Format(now - start)
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