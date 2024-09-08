DB.Attack_Speed = T{}

DB.Attack_Speed.Players = T{}
DB.Attack_Speed.Timestamp = T{}
DB.Attack_Speed.Max_Windows = 3
DB.Attack_Speed.Timeout = 15    -- Treshold in seconds to throw away a value (in between pulls or something).

------------------------------------------------------------------------------------------------------
-- Resets the attack speed globals.
------------------------------------------------------------------------------------------------------
DB.Attack_Speed.Reset = function()
    DB.Attack_Speed.Players = T{}
    DB.Attack_Speed.Timestamp = T{}
end

------------------------------------------------------------------------------------------------------
-- Keeps a tally of the player's attack speed.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
DB.Attack_Speed.Update = function(player_name)
    if not DB.Tracking.Running_Attack_Speed[player_name] then
		Debug.Error.Add("Attack_Speed.Update: {" .. tostring(player_name) .. "} is missing in Tracking.Attack_Speed.")
		return false
	end

    -- Capture the rate.
    local rate = 0
    local skip = false
    local timestamp = DB.Attack_Speed.Timestamp[player_name]
    if timestamp then
        rate = Socket.gettime() - timestamp
        if rate > DB.Attack_Speed.Timeout then skip = true end
    else
        skip = true
    end
    timestamp = Socket.gettime()
    DB.Attack_Speed.Timestamp[player_name] = timestamp
    if skip then return false end

    -- Add the new speed to the attack speed tracking buckets.
    local size = #DB.Tracking.Running_Attack_Speed[player_name]
    if size >= DB.Attack_Speed.Max_Windows then table.remove(DB.Tracking.Running_Attack_Speed[player_name], DB.Attack_Speed.Max_Windows) end
	table.insert(DB.Tracking.Running_Attack_Speed[player_name], 1, rate)
    local new_size = #DB.Tracking.Running_Attack_Speed[player_name]

    -- Average the attack speed.
    local total = 0
    for _, attack_speed in pairs(DB.Tracking.Running_Attack_Speed[player_name]) do
        total = total + attack_speed
    end
    local average = total / new_size
    DB.Attack_Speed.Players[player_name] = average

	return true
end

------------------------------------------------------------------------------------------------------
-- Retrieves a player's attack speed.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
DB.Attack_Speed.Get = function(player_name)
    local speed = DB.Attack_Speed.Players[player_name]
    if not speed then speed = 0 end
    return speed
end