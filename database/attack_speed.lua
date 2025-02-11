DB.AttackSpeed = { }

DB.AttackSpeed.Players    = { }
DB.AttackSpeed.Timestamp  = { }
DB.AttackSpeed.MaxWindows = 3
DB.AttackSpeed.Timeout    = 15    -- Treshold in seconds to throw away a value (in between pulls or something).

------------------------------------------------------------------------------------------------------
-- Resets the attack speed globals.
------------------------------------------------------------------------------------------------------
DB.AttackSpeed.Reset = function()
    DB.AttackSpeed.Players   = { }
    DB.AttackSpeed.Timestamp = { }
end

------------------------------------------------------------------------------------------------------
-- Keeps a tally of the player's attack speed.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
DB.AttackSpeed.Update = function(playerName)
    playerName = playerName or DB.Enum.DEBUG
    local attackSpeedData = DB.Tracking.RunningAttackSpeed[playerName]

    if not attackSpeedData then
		local errorMessage = string.format("Player {%s} is missing from attack speed tracker.", tostring(playerName))
        Debug.Error.Add(Debug.Error.ERROR, "DB.Attack_Speed.Update", errorMessage)
		return false
	end

    -- Capture the rate.
    local timestamp = DB.AttackSpeed.Timestamp[playerName]
    local rate = 0
    local skip = false

    if timestamp then
        rate = Socket.gettime() - timestamp
        if rate > DB.AttackSpeed.Timeout then
            skip = true
        end
    else
        skip = true
    end

    DB.AttackSpeed.Timestamp[playerName] = Socket.gettime()

    if skip then
        return false
    end

    -- Add the new speed to the attack speed tracking buckets.
    if #attackSpeedData >= DB.AttackSpeed.MaxWindows then
        table.remove(attackSpeedData)
    end

	table.insert(attackSpeedData, 1, rate)


    -- Average the attack speed.
    local total = 0
    for _, speed in pairs(attackSpeedData) do
        total = total + speed
    end

    DB.AttackSpeed.Players[playerName] = total / #attackSpeedData

	return true
end

------------------------------------------------------------------------------------------------------
-- Retrieves a player's attack speed.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
DB.AttackSpeed.Get = function(playerName)
    playerName = playerName or DB.Enum.DEBUG

    return DB.AttackSpeed.Players[playerName] or 0
end