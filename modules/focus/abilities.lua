Focus.Abilities = { }

------------------------------------------------------------------------------------------------------
-- Loads data to the ability drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName   string
---@param hidePublish? boolean
------------------------------------------------------------------------------------------------------
Focus.Abilities.Display = function(playerName, hidePublish)
    local abilityTotal = DB.Data.Get(playerName, DB.Trackable.ABILITY_DAMAGING,    DB.Metric.ATTEMPTS_ON_USE)
    local rolls        = DB.Data.Get(playerName, DB.Trackable.PHANTOM_ROLL,        DB.Metric.ATTEMPTS_ON_USE)
    local maneuvers    = DB.Data.Get(playerName, DB.Trackable.MANEUVER,            DB.Metric.ATTEMPTS_ON_USE)
    local healingTotal = DB.Data.Get(playerName, DB.Trackable.ABILITY_HEALING,     DB.Metric.ATTEMPTS_ON_USE)
    local mpRecovery   = DB.Data.Get(playerName, DB.Trackable.ABILITY_MP_RECOVERY, DB.Metric.ATTEMPTS_ON_USE)
    local miscCount    = DB.Data.Get(playerName, DB.Trackable.ABILITY_GENERAL,     DB.Metric.ATTEMPTS_ON_USE)

    local hasData = rolls > 0 or maneuvers > 0 or abilityTotal > 0 or healingTotal > 0 or mpRecovery > 0 or miscCount > 0

    if hasData then
        if abilityTotal > 0 then Focus.Abilities.Damaging(playerName, DB.Trackable.ABILITY_DAMAGING, "Damaging") end
        if rolls > 0        then Focus.Abilities.PhantomRoll(playerName, true) end
        if maneuvers > 0    then Focus.Abilities.Mauevers(playerName) end
        if healingTotal > 0 then Focus.Abilities.Damaging(playerName, DB.Trackable.ABILITY_HEALING, "Healing") end
        if mpRecovery > 0   then Focus.Abilities.Damaging(playerName, DB.Trackable.ABILITY_MP_RECOVERY, "MP Recovery") end
        if miscCount > 0    then
            if Focus.Settings.Show_Misc_Actions then
                Focus.Abilities.AbilitiesGeneral(playerName)
            else
                UI.Text("Enable Misc. Actions to see additional data.")
            end
        end

        if not hidePublish then
            Focus.Abilities.Publish(playerName, abilityTotal, healingTotal)
        end

    else
        UI.Text("No ability data available for this player.")
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for abilities inside the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable a trackable from the data model.
---@param header     string       header title for the name column.
---@param makeBrief? boolean
------------------------------------------------------------------------------------------------------
Focus.Abilities.Damaging = function(playerName, trackable, header, makeBrief)
    if not DB.Tracking.Trackables[trackable] or not DB.Tracking.Trackables[trackable][playerName] then
        return nil
    end

    local colFlags  = Focus.Catalog.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard

    if UI.BeginTable(trackable, makeBrief and 3 or 8, Focus.Catalog.TableFlags) then
        UI.TableSetupColumn(                      header,     colFlags, nameWidth)
        UI.TableSetupColumn(                      "Average",  colFlags, width)
        if not makeBrief then UI.TableSetupColumn("%Player",  colFlags, width) end
        if not makeBrief then UI.TableSetupColumn("Accuracy", colFlags, width) end
        UI.TableSetupColumn(                      "Uses",     colFlags, width)
        if not makeBrief then UI.TableSetupColumn("Total",    colFlags, width) end
        if not makeBrief then UI.TableSetupColumn("Minimum",  colFlags, width) end
        if not makeBrief then UI.TableSetupColumn("Maximum",  colFlags, width) end
        UI.TableHeadersRow()

        UI.TableNextColumn()                       UI.Text("Total")
        UI.TableNextColumn()                       Column.Damage.ByTypeAverage(playerName, trackable)
        if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, DB.Metric.TOTAL, nil, true) end
        if not makeBrief then UI.TableNextColumn() Column.Acc.ByType(playerName,           trackable) end
        UI.TableNextColumn()                       Column.Damage.Attempts(playerName,      trackable)
        if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, DB.Metric.TOTAL) end
        if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, DB.Metric.MIN) end
        if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, DB.Metric.MAX) end
        WindowManager.TableRowColor(1)

        local sortedDamage = DB.Lists.GetSortedCatalogDamage(playerName, trackable)

        for _, data in ipairs(sortedDamage) do
            local actionName = data[1]

            UI.TableNextColumn()                       UI.Text(string.format("- %s", actionName))
            UI.TableNextColumn()                       Column.Damage.ByTypeAverage(playerName, trackable, nil, actionName)
            if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, DB.Metric.TOTAL, actionName, true) end
            if not makeBrief then UI.TableNextColumn() Column.Acc.ByType(playerName,           trackable, nil, nil, actionName) end
            UI.TableNextColumn()                       Column.Damage.Attempts(playerName,      trackable, nil, actionName)
            if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, DB.Metric.TOTAL, actionName) end
            if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, DB.Metric.MIN, actionName) end
            if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, DB.Metric.MAX, actionName) end

            WindowManager.TableRowColor(0)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for general abilities inside the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Abilities.AbilitiesGeneral = function(playerName)
    local trackable = DB.Trackable.ABILITY_GENERAL

    if not playerName or not DB.Tracking.Trackables[trackable] or not DB.Tracking.Trackables[trackable][playerName] then
        return nil
    end

    local colFlags  = Focus.Catalog.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard

    if UI.BeginTable(trackable, 2, Focus.Catalog.TableFlags) then
        UI.TableSetupColumn("General", colFlags, nameWidth)
        UI.TableSetupColumn("Uses",    colFlags, width)
        UI.TableHeadersRow()

        local sortedDamage = DB.Lists.GetSortedCatalogDamage(playerName, trackable)
        local row = 1

        for _, data in ipairs(sortedDamage) do
            local actionName = data[1]

            UI.TableNextColumn() UI.Text(actionName)
            UI.TableNextColumn() Column.Damage.Attempts(playerName, trackable, nil, actionName)

            WindowManager.TableRowColor(row)
            row = row + 1
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for general abilities inside the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Abilities.Mauevers = function(playerName)
    local trackable = DB.Trackable.MANEUVER

    if not playerName or not DB.Tracking.Trackables[trackable] or not DB.Tracking.Trackables[trackable][playerName] then
        return nil
    end

    local colFlags  = Focus.Catalog.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard

    if UI.BeginTable(trackable, 3, Focus.Catalog.TableFlags) then
        UI.TableSetupColumn("Maneuver", colFlags, nameWidth)
        UI.TableSetupColumn("Uses",     colFlags, width)
        UI.TableSetupColumn("Overload", colFlags, width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.Attempts(playerName, trackable)
        UI.TableNextColumn() Column.Damage.ByType(playerName,   trackable, DB.Metric.OVERLOAD)
        WindowManager.TableRowColor(1)

        local sortedDamage = DB.Lists.GetSortedCatalogDamage(playerName, trackable)

        for _, data in ipairs(sortedDamage) do
            local actionName = data[1]

            UI.TableNextColumn() UI.Text(string.format("- %s", actionName))
            UI.TableNextColumn() Column.Damage.Attempts(playerName, trackable, nil, actionName)
            UI.TableNextColumn() Column.Damage.ByType(playerName,   trackable, DB.Metric.OVERLOAD, actionName)

            WindowManager.TableRowColor(0)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows phantom roll overview stats.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param full?      boolean
------------------------------------------------------------------------------------------------------
Focus.Abilities.PhantomRoll = function(playerName, full)
    local trackable = DB.Trackable.PHANTOM_ROLL

    if not playerName or not DB.Tracking.Trackables[trackable] or not DB.Tracking.Trackables[trackable][playerName] then
        return nil
    end

    local colFlags  = Focus.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard
    local columns   = 5 + (full and 2 or 0)

    if UI.BeginTable("Phantom Roll", columns, Focus.TableFlags) then
        UI.TableSetupColumn(             "Phantom Roll", colFlags, nameWidth)
        UI.TableSetupColumn(             "Rolls",        colFlags, width)
        if full then UI.TableSetupColumn("Re-Rolls",     colFlags, width) end
        UI.TableSetupColumn(             "%Lucky",       colFlags, width)
        if full then UI.TableSetupColumn("%Lucky 11",    colFlags, width) end
        UI.TableSetupColumn(             "%Unlucky",     colFlags, width)
        UI.TableSetupColumn(             "%Busts",       colFlags, width)
        UI.TableHeadersRow()

        UI.TableNextColumn()              UI.Text("Total")
        UI.TableNextColumn()              Column.Damage.Attempts(playerName,  trackable, nil, nil, true)
        if full then UI.TableNextColumn() Column.Damage.ByType(playerName,    trackable, DB.Metric.REROLL) end
        UI.TableNextColumn()              Column.Acc.PhantomRoll(playerName, DB.Metric.LUCKY)
        if full then UI.TableNextColumn() Column.Acc.PhantomRoll(playerName, DB.Metric.LUCKY_11) end
        UI.TableNextColumn()              Column.Acc.PhantomRoll(playerName, DB.Metric.UNLUCKY)
        UI.TableNextColumn()              Column.Acc.PhantomRoll(playerName, DB.Metric.BUSTS)
        WindowManager.TableRowColor(1)

        local sortedDamage = DB.Lists.GetSortedCatalogDamage(playerName, trackable)

        for _, data in ipairs(sortedDamage) do
            local actionName = data[1]

            UI.TableNextColumn()              UI.Text(string.format("- %s", actionName))
            UI.TableNextColumn()              Column.Damage.Attempts(playerName,  trackable, nil, actionName, true)
            if full then UI.TableNextColumn() Column.Damage.ByType(playerName,    trackable, DB.Metric.REROLL, actionName) end
            UI.TableNextColumn()              Column.Acc.PhantomRoll(playerName, DB.Metric.LUCKY, actionName)
            if full then UI.TableNextColumn() Column.Acc.PhantomRoll(playerName, DB.Metric.LUCKY_11, actionName) end
            UI.TableNextColumn()              Column.Acc.PhantomRoll(playerName, DB.Metric.UNLUCKY, actionName)
            UI.TableNextColumn()              Column.Acc.PhantomRoll(playerName, DB.Metric.BUSTS, actionName)

            WindowManager.TableRowColor(0)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows ability overview stats.
------------------------------------------------------------------------------------------------------
---@param playerName  string
---@param abilityList table
------------------------------------------------------------------------------------------------------
Focus.Abilities.FromList = function(playerName, abilityList)
    if not playerName or not abilityList then
        return nil
    end

    local colFlags  = Focus.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard

    if UI.BeginTable("Ability", 2, Focus.TableFlags) then
        UI.TableSetupColumn("Abilities", colFlags, nameWidth)
        UI.TableSetupColumn("Uses",      colFlags, width)
        UI.TableHeadersRow()

        local row = 1
        for _, abilityName in ipairs(abilityList) do
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(abilityName)
            UI.TableNextColumn() Column.Damage.Attempts(playerName, DB.Trackable.ABILITY_OVERALL, nil, abilityName)
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up ability publishing buttons from within the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName   string
---@param abilityTotal number
---@param healingTotal number
------------------------------------------------------------------------------------------------------
Focus.Abilities.Publish = function(playerName, abilityTotal, healingTotal)
    if abilityTotal > 0 then
        Report.Widgets.Button(playerName, DB.Trackable.ABILITY_DAMAGING, "Publish Abilities")
    end

    if healingTotal > 0 then
        if abilityTotal > 0 then
            UI.SameLine() UI.Text(" ") UI.SameLine()
        end

        Report.Widgets.Button(playerName, DB.Trackable.ABILITY_HEALING, "Publish Healing")
    end
end