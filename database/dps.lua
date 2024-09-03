DB.DPS = T{}

DB.DPS.DPS = T{}                -- [player_name]
DB.DPS.Max = T{}                -- [player_name]
DB.DPS.Snapshots = T{}          -- [player_name][snapshot index]
DB.DPS.Snapshot_Time = 3		-- Seconds between each snapshot
DB.DPS.Snapshot_Count = 3		-- Max number of snapshots

DB.DPS.DPS_Graph = T{}
DB.DPS.DPS_Graph_Length = 10

DB.DPS.Modes = T{
    [1] = "Average",
    [2] = "Recent",
}
DB.DPS.Mode = DB.DPS.Modes[1]   -- Average
DB.DPS.Mode_Index = 1
DB.DPS.Mode_Header = "DPS Mode"

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

        -- Max local DPS tracking
        if not DB.DPS.Max[player_name] then DB.DPS.Max[player_name] = 0 end
        if dps > DB.DPS.Max[player_name] then DB.DPS.Max[player_name] = dps end
    end
end

------------------------------------------------------------------------------------------------------
-- Get a player's DPS.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@return number
------------------------------------------------------------------------------------------------------
DB.DPS.Get_DPS = function(player_name)
    -- Average DPS
    if DB.DPS.Get_Mode() == DB.DPS.Modes[1] then
        local total_damage = Column.Damage.Raw_Total_Player_Damage(player_name)
        local duration = Timers.Get_Duration(Timers.Enum.Names.PARSE)
        if duration == 0 then duration = 1 end
        return total_damage / duration

    -- Recent DPS
    else
        if not DB.DPS.DPS[player_name] then return 0 end
        return DB.DPS.DPS[player_name]
    end
end

------------------------------------------------------------------------------------------------------
-- Get a player's maximum local DPS.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@return number
------------------------------------------------------------------------------------------------------
DB.DPS.Get_Max_DPS = function(player_name)
    if not DB.DPS.Max[player_name] then DB.DPS.Max[player_name] = 0 end
    return DB.DPS.Max[player_name]
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

------------------------------------------------------------------------------------------------------
-- Creates a dropdown menu to show only damage done by a certain entity.
------------------------------------------------------------------------------------------------------
---@param width integer
------------------------------------------------------------------------------------------------------
DB.DPS.Dropdown = function(width)
    local list = DB.DPS.Modes
    local flags = DB.Widgets.Dropdown.Flags
    UI.SetNextItemWidth(width)
    if list[1] then
        if UI.BeginCombo(DB.DPS.Mode_Header, list[DB.DPS.Mode_Index], flags) then
            for n = 1, #list, 1 do
                local is_selected = DB.DPS.Mode_Index == n
                if UI.Selectable(list[n], is_selected) then
                    DB.DPS.Mode_Index = n
                    DB.DPS.Mode = list[n]
                end
                if is_selected then UI.SetItemDefaultFocus() end
            end
            UI.EndCombo()
        end
    else
        if UI.BeginCombo(DB.DPS.Mode_Header, DB.DPS.Modes.AVERAGE, flags) then UI.EndCombo() end
    end
    UI.SameLine() Window_Manager.Widgets.HelpMarker(
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
DB.DPS.Get_Mode = function()
    return DB.DPS.Mode
end

------------------------------------------------------------------------------------------------------
-- Gets the DPS column header.
------------------------------------------------------------------------------------------------------
DB.DPS.Column_Header = function()
    local header = "DPS (R)"
    if DB.DPS.Get_Mode() == DB.DPS.Modes[1] then header = "DPS (A)" end
    return header
end