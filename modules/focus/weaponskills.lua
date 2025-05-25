Focus.WS = { }

------------------------------------------------------------------------------------------------------
-- Loads data to the weaponskill and skillchain drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName   string
---@param hidePublish? boolean
------------------------------------------------------------------------------------------------------
Focus.WS.Display = function(playerName, hidePublish)
    local trackableWS = DB.Trackable.WEAPONSKILL
    local trackableMP = DB.Trackable.WEAPONSKILL_MP_DRAIN
    local trackableSC = DB.Trackable.SKILLCHAIN

    local weaponskillsFound  = DB.Tracking.Trackables[trackableWS] and DB.Tracking.Trackables[trackableWS][playerName]
    local mpWeaponskillFound = DB.Tracking.Trackables[trackableMP] and DB.Tracking.Trackables[trackableMP][playerName]
    local skillchainsFound   = DB.Tracking.Trackables[trackableSC] and DB.Tracking.Trackables[trackableSC][playerName]

    -- No data found message.
    if not weaponskillsFound and not skillchainsFound and not mpWeaponskillFound then
        UI.Text("No weaponskill or skillchain data available for this player.")
    end

    -- Display the weaponskill and skillchain data.
    if weaponskillsFound  then Focus.WS.Weaponskill(playerName) end
    if mpWeaponskillFound then Focus.WS.Weaponskill(playerName, nil, true) end
    if skillchainsFound   then Focus.WS.Skillchains(playerName) end

    -- Publish buttons
    if not hidePublish then
        if weaponskillsFound then
            Report.Widgets.Button(playerName, trackableWS, "Publish Weaponskills")
        end

        if skillchainsFound then
            -- SCH skillchains do not require weaponskills. Avoid same-lining with the table.
            if weaponskillsFound then
                UI.SameLine()
            end

            UI.Text(" ") UI.SameLine()

            Report.Widgets.Button(playerName, trackableSC, "Publish Skillchains")
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for the weaponskill list inside the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param makeBrief? boolean
---@param isMpDrain? boolean
------------------------------------------------------------------------------------------------------
Focus.WS.Weaponskill = function(playerName, makeBrief, isMpDrain)
    local trackable = isMpDrain and DB.Trackable.WEAPONSKILL_MP_DRAIN or DB.Trackable.WEAPONSKILL

    if not DB.Tracking.Trackables[trackable] or not DB.Tracking.Trackables[trackable][playerName] then
        return nil
    end

    local colFlags  = Focus.Catalog.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard
    local columns   = makeBrief and 4 or 10

    local header = "Weaponskill"
    if isMpDrain then header = string.format("%s (MP)", header) end

    if UI.BeginTable(trackable, columns, Focus.Catalog.TableFlags) then
        UI.TableSetupColumn(header,     colFlags, nameWidth)
        UI.TableSetupColumn("Average",  colFlags, width)
        if not makeBrief then UI.TableSetupColumn("%Player",  colFlags, width) end
        UI.TableSetupColumn("Accuracy", colFlags, width)
        if not makeBrief then UI.TableSetupColumn("Attempts", colFlags, width) end
        if not makeBrief then UI.TableSetupColumn("Damage",   colFlags, width) end
        if not makeBrief then UI.TableSetupColumn("DMG/TP",   colFlags, width) end
        UI.TableSetupColumn("~TP",      colFlags, width)
        if not makeBrief then UI.TableSetupColumn("Minimum",  colFlags, width) end
        if not makeBrief then UI.TableSetupColumn("Maximum",  colFlags, width) end
        UI.TableHeadersRow()

        -- All Weaponskills
        UI.TableNextColumn()                       UI.Text("Total")
        UI.TableNextColumn()                       Column.Damage.ByTypeAverage(playerName,  trackable)
        if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,         trackable, nil, nil, true) end
        UI.TableNextColumn()                       Column.Acc.ByType(playerName,            trackable)
        if not makeBrief then UI.TableNextColumn() Column.Damage.Attempts(playerName,       trackable) end
        if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,         trackable) end
        if not makeBrief then UI.TableNextColumn() Column.Damage.PerUnit(playerName,        trackable, DB.Metric.TP_SPENT) end
        UI.TableNextColumn()                       Column.Damage.PerUnitAverage(playerName, trackable, DB.Metric.TP_SPENT)
        if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,         trackable, DB.Metric.MIN) end
        if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,         trackable, DB.Metric.MAX) end
        WindowManager.TableRowColor(1)

        -- Specific Weaponskills
        local sortedDamage = DB.Lists.GetSortedCatalogDamage(playerName, trackable)

        for _, data in ipairs(sortedDamage) do
            local actionName = data[1]

            UI.TableNextRow()
            UI.TableNextColumn()                       UI.Text(string.format("- %s", actionName))
            UI.TableNextColumn()                       Column.Damage.ByTypeAverage(playerName,  trackable, nil, actionName)
            if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,         trackable, nil, actionName, true) end
            UI.TableNextColumn()                       Column.Acc.ByType(playerName,            trackable, nil, false, actionName)
            if not makeBrief then UI.TableNextColumn() Column.Damage.Attempts(playerName,       trackable, nil, actionName) end
            if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,         trackable, nil, actionName) end
            if not makeBrief then UI.TableNextColumn() Column.Damage.PerUnit(playerName,        trackable, DB.Metric.TP_SPENT, actionName) end
            UI.TableNextColumn()                       Column.Damage.PerUnitAverage(playerName, trackable, DB.Metric.TP_SPENT, actionName)
            if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,         trackable, DB.Metric.MIN, actionName) end
            if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,         trackable, DB.Metric.MAX, actionName) end
            WindowManager.TableRowColor(0)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for the skillchain list inside the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param makeBrief? boolean
------------------------------------------------------------------------------------------------------
Focus.WS.Skillchains = function(playerName, makeBrief)
    local trackable = DB.Trackable.SKILLCHAIN

    if not DB.Tracking.Trackables[trackable] or not DB.Tracking.Trackables[trackable][playerName] then
        return nil
    end

    local colFlags  = Focus.Catalog.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard

    local columns = makeBrief and 3 or 7
    local includingSkillchain = Parse.Config.IncludeSkillchainDamage()

    if includingSkillchain and not makeBrief then
        columns = columns + 1
    end

    if UI.BeginTable(trackable, columns, Focus.Catalog.TableFlags) then
        UI.TableSetupColumn("Skillchain", colFlags, nameWidth)
        if not makeBrief then UI.TableSetupColumn("Average", colFlags, width) end
        if includingSkillchain then UI.TableSetupColumn("%Player", colFlags, width) end
        UI.TableSetupColumn("Opened",     colFlags, width)
        UI.TableSetupColumn("Closed",     colFlags, width)
        if not makeBrief then UI.TableSetupColumn("Total",   colFlags, width) end
        if not makeBrief then UI.TableSetupColumn("Minimum", colFlags, width) end
        if not makeBrief then UI.TableSetupColumn("Maximum", colFlags, width) end
        UI.TableHeadersRow()

        -- All Skillchains
        UI.TableNextColumn() UI.Text("Total")
        if not makeBrief then UI.TableNextColumn()       Column.Damage.ByTypeAverage(playerName, trackable) end
        if includingSkillchain then UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, nil, nil, true) end
        UI.TableNextColumn()                             Column.Damage.ByType(playerName, trackable, DB.Metric.SKILLCHAIN_OPENED)
        UI.TableNextColumn()                             Column.Damage.ByType(playerName, trackable, DB.Metric.SKILLCHAIN_CLOSED)
        if not makeBrief then UI.TableNextColumn()       Column.Damage.ByType(playerName, trackable) end
        if not makeBrief then UI.TableNextColumn()       Column.Damage.ByType(playerName, trackable, DB.Metric.MIN) end
        if not makeBrief then UI.TableNextColumn()       Column.Damage.ByType(playerName, trackable, DB.Metric.MAX) end
        WindowManager.TableRowColor(1)

        -- Specific Skillchains
        local sortedDamage = DB.Lists.GetSortedCatalogDamage(playerName, trackable)

        for _, data in ipairs(sortedDamage) do
            local actionName = data[1]

            UI.TableNextRow()
            UI.TableNextColumn()                             UI.Text(string.format("- %s", actionName))
            if not makeBrief then UI.TableNextColumn()       Column.Damage.ByTypeAverage(playerName, trackable, nil, actionName) end
            if includingSkillchain then UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.TOTAL, actionName, true) end
            UI.TableNextColumn()                             Column.Damage.ByType(playerName, trackable, DB.Metric.SKILLCHAIN_OPENED, actionName)
            UI.TableNextColumn()                             Column.Damage.ByType(playerName, trackable, DB.Metric.SKILLCHAIN_CLOSED, actionName)
            if not makeBrief then UI.TableNextColumn()       Column.Damage.ByType(playerName, trackable, DB.Metric.TOTAL, actionName) end
            if not makeBrief then UI.TableNextColumn()       Column.Damage.ByType(playerName, trackable, DB.Metric.MIN, actionName) end
            if not makeBrief then UI.TableNextColumn()       Column.Damage.ByType(playerName, trackable, DB.Metric.MAX, actionName) end
            WindowManager.TableRowColor(0)
        end

        UI.EndTable()
    end
end