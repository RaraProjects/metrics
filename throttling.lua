Throttle = T{}
Throttle.Enabled = true
Throttle.Mod = 10
Throttle.Tick = 0
Throttle.Need_Refresh = true

------------------------------------------------------------------------------------------------------
-- Provides a gate to throttle performance intensive calculations.
------------------------------------------------------------------------------------------------------
Throttle.Throttle = function()
    Throttle.Tick = (Throttle.Tick + 1) % Throttle.Mod
    if Throttle.Tick == 0 then Throttle.Need_Refresh = true end
end

------------------------------------------------------------------------------------------------------
-- Returns whether throttling is enabled or not.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Throttle.Is_Enabled = function()
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
Throttle.Allow_Calculation = function()
    return Throttle.Need_Refresh
end

------------------------------------------------------------------------------------------------------
-- Blocks calculation until the next throttle window opens up.
------------------------------------------------------------------------------------------------------
Throttle.Block = function()
    Throttle.Need_Refresh = false
end