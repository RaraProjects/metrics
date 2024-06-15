DB.DPS = T{}

DB.DPS.DPS = T{}
DB.DPS.Snapshots = T{}          -- [player_name][snapshot index]
DB.DPS.Snapshot_Time = 3		-- Seconds between each snapshot
DB.DPS.Snapshot_Count = 3		-- Max number of snapshots

DB.DPS.DPS_Graph = T{}
DB.DPS.DPS_Graph_Length = 10

-----------------------------------------------------------------------------------------------------
-- Increments DPS buffer.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param damage number
------------------------------------------------------------------------------------------------------
DB.DPS.Inc_Buffer = function(player_name, damage)
    if not player_name or not damage then return nil end
    if not DB.Tracking.Running_Damage[player_name] then DB.Tracking.Running_Damage[player_name] = 0 end
	DB.Tracking.Running_Damage[player_name] = DB.Tracking.Running_Damage[player_name] + damage
end

------------------------------------------------------------------------------------------------------
-- Gets a player's current DPS buffer amount.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
DB.DPS.Get_Buffer = function(player_name)
    if not player_name then return 0 end
    if not DB.Tracking.Running_Damage[player_name] then return 0 end
    return DB.Tracking.Running_Damage[player_name]
end

------------------------------------------------------------------------------------------------------
-- Clears the DPS buffer for a player.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
DB.DPS.Clear_Buffer = function(player_name)
    DB.Tracking.Running_Damage[player_name] = 0
end

------------------------------------------------------------------------------------------------------
-- Takes a snapshot of all the DPS buffers.
------------------------------------------------------------------------------------------------------
DB.DPS.Create_Snapshot = function()
    if not Metrics.Parse.DPS then return nil end

    -- Create the Snapshots
    for player_name, _ in pairs(DB.Tracking.Initialized_Players) do
        if not DB.DPS.Snapshots[player_name] then DB.DPS.Snapshots[player_name] = T{} end
        if not DB.DPS.DPS_Graph[player_name] then DB.DPS.DPS_Graph[player_name] = T{} end
        local buffer_damage = DB.DPS.Get_Buffer(player_name)

        -- Raw DPS
        table.insert(DB.DPS.Snapshots[player_name], 1, buffer_damage)
        if #DB.DPS.Snapshots[player_name] > DB.DPS.Snapshot_Count then
            table.remove(DB.DPS.Snapshots[player_name], DB.DPS.Snapshot_Count + 1)
        end

        -- Graph DPS
        table.insert(DB.DPS.DPS_Graph[player_name], 1, buffer_damage)
        if #DB.DPS.DPS_Graph[player_name] > DB.DPS.DPS_Graph_Length then
            table.remove(DB.DPS.DPS_Graph[player_name], DB.DPS.DPS_Graph_Length + 1)
        end

        DB.DPS.Clear_Buffer(player_name)
    end

    -- Average out the snapshots to create DPS
    for player_name, snapshots in pairs(DB.DPS.Snapshots) do
        local total_damage = 0
        local string = ""
        for index, damage in pairs(snapshots) do
            total_damage = total_damage + damage
            string = string .. " " .. tostring(damage) .. "-" .. tostring(index)
        end
        local dps = total_damage / (DB.DPS.Snapshot_Time * DB.DPS.Snapshot_Count)
        DB.DPS.DPS[player_name] = dps
    end
end

------------------------------------------------------------------------------------------------------
-- Get a player's DPS.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@return number
------------------------------------------------------------------------------------------------------
DB.DPS.Get_DPS = function(player_name)
    if Metrics.Parse.Global_DPS then
        local total_damage = Column.Damage.Raw_Total_Player_Damage(player_name)
        local duration = Timers.Get_Duration(Timers.Enum.Names.PARSE)
        if duration == 0 then duration = 1 end
        return total_damage / duration
    else
        if not DB.DPS.DPS[player_name] then return 0 end
        return DB.DPS.DPS[player_name]
    end
end

------------------------------------------------------------------------------------------------------
-- Get a player's DPS for the graph.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
DB.DPS.Get_DPS_Graph = function(player_name)
    if DB.DPS.DPS_Graph[player_name] then
        return DB.DPS.DPS_Graph[player_name]
    end
    return {0}
end