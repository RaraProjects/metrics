Focus.Catalog = { }

Focus.Catalog.TableFlags  = WindowManager.Table.Flags.FixedBorders
Focus.Catalog.ColumnFlags = Column.Flags.None

------------------------------------------------------------------------------------------------------
-- Sets up the table for a endamage inside the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable a trackable from the data model.
---@param suffix?    string       append a suffix to the header to help distinguish between melee and ranged.
------------------------------------------------------------------------------------------------------
Focus.Catalog.Endamage = function(playerName, trackable, suffix)
    if not DB.Tracking.Trackables[trackable] or not DB.Tracking.Trackables[trackable][playerName] then
        return nil
    end

    local colFlags  = Focus.Catalog.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard

    suffix       = suffix or ""
    local header = string.format("Endamage %s", suffix)

    if UI.BeginTable(trackable, 7, Focus.Catalog.TableFlags) then
        UI.TableSetupColumn(header,    colFlags, nameWidth)
        UI.TableSetupColumn("Average", colFlags, width)
        UI.TableSetupColumn("%Player", colFlags, width)
        UI.TableSetupColumn("Procs",   colFlags, width)
        UI.TableSetupColumn("Total",   colFlags, width)
        UI.TableSetupColumn("Minimum", colFlags, width)
        UI.TableSetupColumn("Maximum", colFlags, width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, trackable)
        UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, nil, nil, true)
        UI.TableNextColumn() Column.Damage.Hits(playerName,   trackable, nil, true)
        UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.TOTAL)
        UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.MIN)
        UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.MAX)
        WindowManager.TableRowColor(1)

        local sortedDamage = DB.Lists.GetSortedPlayerCatalogDamage(playerName, trackable)

        for _, data in ipairs(sortedDamage) do
            local actionName = data[1]

            UI.TableNextColumn() UI.Text(string.format("- %s", actionName))
            UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, trackable, nil, actionName)
            UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, nil, actionName, true)
            UI.TableNextColumn() Column.Damage.Hits(playerName, trackable, actionName, true)
            UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.TOTAL, actionName)
            UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.MIN, actionName)
            UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.MAX, actionName)

            WindowManager.TableRowColor(0)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for endebuff inside the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable a trackable from the data model.
---@param suffix?    string       append a suffix to the header to help distinguish between melee and ranged.
------------------------------------------------------------------------------------------------------
Focus.Catalog.Endebuff = function(playerName, trackable, suffix)
    if not DB.Tracking.Trackables[trackable] or not DB.Tracking.Trackables[trackable][playerName] then
        return nil
    end

    local colFlags  = Focus.Catalog.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard

    suffix       = suffix or ""
    local header = string.format("Endebuff %s", suffix)

    if UI.BeginTable(trackable, 2, Focus.Catalog.TableFlags) then
        UI.TableSetupColumn(header,  colFlags, nameWidth)
        UI.TableSetupColumn("Procs", colFlags, width)
        UI.TableHeadersRow()

        local sortedDamage = DB.Lists.GetSortedPlayerCatalogDamage(playerName, trackable)

        for _, data in ipairs(sortedDamage) do
            local actionName = data[1]

            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(actionName)
            UI.TableNextColumn() Column.Damage.Hits(playerName, trackable, actionName, true)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Minimum column for a cataloged action.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param actionName string
---@param trackable  DB.Trackable
------------------------------------------------------------------------------------------------------
Focus.Catalog.Min = function(playerName, actionName, trackable)
    local min = DB.Catalog.Get(playerName, trackable, actionName, DB.Metric.MIN)

    if min == DB.Enum.MAX_DAMAGE then
        Column.Damage.ByType(playerName, trackable, DB.Enum.IGNORE, actionName)
    else
        Column.Damage.ByType(playerName, trackable, DB.Metric.MIN, actionName)
    end
end