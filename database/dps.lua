DB.DPS = { }

DB.DPS.DPS           = { }      -- [player_name]
DB.DPS.Max           = { }      -- [player_name]
DB.DPS.Snapshots     = { }      -- [player_name][snapshot index]
DB.DPS.SnapshotTime  = 3	    -- Seconds between each snapshot
DB.DPS.SnapshotCount = 3		-- Max number of snapshots

DB.DPS.Modes =
{
    [1] = "Average",
    [2] = "Recent",
}

DB.DPS.Mode       = DB.DPS.Modes[1]   -- Average
DB.DPS.ModeIndex  = 1
DB.DPS.ModeHeader = "DPS Mode"

-----------------------------------------------------------------------------------------------------
-- Increments DPS buffer.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param damage     integer
------------------------------------------------------------------------------------------------------
DB.DPS.IncBuffer = function(playerName, damage)
    if not playerName or not damage then
        return nil
    end

    DB.Tracking.RunningDamage[playerName] = (DB.Tracking.RunningDamage[playerName] or 0) + damage
end

------------------------------------------------------------------------------------------------------
-- Gets a player's current DPS buffer amount.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@return number
------------------------------------------------------------------------------------------------------
DB.DPS.GetBuffer = function(playerName)
    if not playerName or not DB.Tracking.RunningDamage[playerName] then
        return 0
    end

    return DB.Tracking.RunningDamage[playerName]
end

------------------------------------------------------------------------------------------------------
-- Clears the DPS buffer for a player.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
DB.DPS.ClearBuffer = function(playerName)
    if not playerName then
        return nil
    end

    DB.Tracking.RunningDamage[playerName] = 0
end

------------------------------------------------------------------------------------------------------
-- Takes a snapshot of all the DPS buffers.
------------------------------------------------------------------------------------------------------
DB.DPS.CreateSnapshot = function()
    -- Create the Snapshots
    for playerName, _ in pairs(DB.Tracking.InitializedPlayers) do
        local snapshots    = DB.DPS.Snapshots[playerName] or { }
        local bufferDamage = DB.DPS.GetBuffer(playerName)

        table.insert(snapshots, 1, bufferDamage)
        if #snapshots > DB.DPS.SnapshotCount then
            table.remove(snapshots, DB.DPS.SnapshotCount + 1)
        end

        DB.DPS.Snapshots[playerName] = snapshots
        DB.DPS.ClearBuffer(playerName)
    end

    -- Average out the snapshots to create DPS
    for playerName, snapshots in pairs(DB.DPS.Snapshots) do
        local totalDamage = 0

        for _, damage in pairs(snapshots) do
            totalDamage = totalDamage + damage
        end

        local dps = totalDamage / (DB.DPS.SnapshotTime * DB.DPS.SnapshotCount)
        DB.DPS.DPS[playerName] = dps
        DB.DPS.Max[playerName] = math.max(DB.DPS.Max[playerName] or 0, dps)
    end
end

------------------------------------------------------------------------------------------------------
-- Get a player's DPS.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@return number
------------------------------------------------------------------------------------------------------
DB.DPS.GetDPS = function(playerName)
    -- Average DPS
    if DB.DPS.GetMode() == DB.DPS.Modes[1] then
        local totalDamage = Column.Damage.RawTotalPlayerDamage(playerName)
        local duration    = math.max(Timers.GetDuration(Timers.Types.PARSE), 1)    -- Prevent division by zero.

        return totalDamage / duration
    end

    return DB.DPS.DPS[playerName] or 0
end

------------------------------------------------------------------------------------------------------
-- Get a player's maximum local DPS.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@return number
------------------------------------------------------------------------------------------------------
DB.DPS.GetMaxDPS = function(playerName)
    return DB.DPS.Max[playerName] or 0
end

------------------------------------------------------------------------------------------------------
-- Utility function for accessing the name of the current DPS mode.
------------------------------------------------------------------------------------------------------
DB.DPS.GetMode = function()
    return DB.DPS.Mode
end

------------------------------------------------------------------------------------------------------
-- Gets the DPS column header.
------------------------------------------------------------------------------------------------------
DB.DPS.ColumnHeader = function()
    return DB.DPS.GetMode() == DB.DPS.Modes[1] and "DPS (A)" or "DPS (R)"
end