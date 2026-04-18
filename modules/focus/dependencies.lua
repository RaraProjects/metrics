Focus.Dependencies = { }

------------------------------------------------------------------------------------------------------
-- Returns whether Horizon mode is enabled or not.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Focus.Dependencies.HorizonMode = function()
    if not Parse or not Parse.Settings then
        return false
    end

    return Parse.Settings.Is_Horizon
end