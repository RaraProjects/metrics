Throttle = { }

Throttle.Enabled     = true
Throttle.Mod         = 15
Throttle.Tick        = 0
Throttle.NeedRefresh = true

------------------------------------------------------------------------------------------------------
-- Provides a gate to throttle performance intensive calculations.
------------------------------------------------------------------------------------------------------
Throttle.Throttle = function()
    Throttle.Tick = (Throttle.Tick + 1) % Throttle.Mod
    Throttle.NeedRefresh = Throttle.Tick == 0
end

------------------------------------------------------------------------------------------------------
-- Returns whether throttling is enabled or not.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Throttle.IsEnabled = function()
    return Throttle.Enabled
end

------------------------------------------------------------------------------------------------------
-- Toggle whether throttling is turned on or off.
------------------------------------------------------------------------------------------------------
Throttle.Toggle = function()
    Throttle.Enabled = not Throttle.Enabled
end

------------------------------------------------------------------------------------------------------
-- Returns whether the caller is permitted to perform its calculation or not.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Throttle.AllowCalculation = function()
    return Throttle.NeedRefresh
end

------------------------------------------------------------------------------------------------------
-- Blocks calculation until the next throttle window opens up.
------------------------------------------------------------------------------------------------------
Throttle.Block = function()
    Throttle.NeedRefresh = false
end