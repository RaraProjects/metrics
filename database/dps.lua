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
        local duration    = math.max(Timers.GetDuration(Timers.Enum.Names.PARSE), 1)    -- Prevent division by zero.

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
-- Creates a dropdown menu to show only damage done by a certain entity.
------------------------------------------------------------------------------------------------------
---@param width integer
------------------------------------------------------------------------------------------------------
DB.DPS.Dropdown = function(width)
    local list  = DB.DPS.Modes
    local flags = DB.Widgets.Dropdown.Flags

    UI.SetNextItemWidth(width)

    if UI.BeginCombo(DB.DPS.ModeHeader, list[DB.DPS.ModeIndex] or DB.DPS.Modes[1], flags) then
        for index, mode in ipairs(list) do
            local isSelected = DB.DPS.ModeIndex == index

            if UI.Selectable(mode, isSelected) then
                DB.DPS.ModeIndex = index
                DB.DPS.Mode = mode
            end

            if isSelected then
                UI.SetItemDefaultFocus()
            end
        end
        UI.EndCombo()
    end

    UI.SameLine() Window_Manager.Widgets.HelpMarker
    (
        "Average DPS is your total damage divided by the parse duration timer. The timer only runs while actions " ..
        "are taking place by your affiliates near you so idle time by the party won't hurt your DPS by much. " ..
        "Average DPS is smoother and averaged over a longer period. It won't drop over time as long as no one is taking a battle action. \n \n" ..
        "Recent DPS is spikey and closer to the present. Actions you do right now matter more. " ..
        "For example, if you were to stop taking actions for {X} amount of seconds your DPS would drop to zero. " ..
        "Use Recent DPS mode if you're more interested in what's happening right now."
    )
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