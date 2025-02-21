Focus.Ranged = { }

------------------------------------------------------------------------------------------------------
-- Loads data to the ranged drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Ranged.Display = function(playerName)
    local endamage    = DB.Data.Get(playerName, DB.Trackable.RANGED_ENDAMAGE, DB.Metric.TOTAL)
    local endebuff    = DB.Data.Get(playerName, DB.Trackable.RANGED_ENDEBUFF, DB.Metric.HITS_ON_TARGET)
    local endrain     = DB.Data.Get(playerName, DB.Trackable.RANGED_ENDRAIN,  DB.Metric.HITS_ON_TARGET)
    local enaspir     = DB.Data.Get(playerName, DB.Trackable.RANGED_ENASPIR,  DB.Metric.HITS_ON_TARGET)
    local paralyzed   = DB.Data.Get(playerName, DB.Trackable.ALL_PARALYZE,    DB.Metric.HITS_ON_USE)
    local intimidated = DB.Data.Get(playerName, DB.Trackable.ALL_INTIMIDATE,  DB.Metric.HITS_ON_USE)

    Focus.Ranged.Total(playerName)
    Focus.Ranged.Auxiliary(playerName, endamage, endrain, enaspir)
    Focus.Ranged.MinMax(playerName)

    if paralyzed > 0 or intimidated > 0 then
        Focus.Melee.ActionBlocked(playerName, paralyzed, intimidated)
    end

    if endebuff > 0 or endamage > 0 then UI.Separator() end
    if endebuff > 0 then Focus.Catalog.Endebuff(playerName, DB.Trackable.RANGED_ENDEBUFF) end
    if endamage > 0 then Focus.Catalog.Endamage(playerName, DB.Trackable.RANGED_ENDAMAGE) end
end

------------------------------------------------------------------------------------------------------
-- Build total ranged damage table.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param makeBrief? boolean
------------------------------------------------------------------------------------------------------
Focus.Ranged.Total = function(playerName, makeBrief)
    local colFlags  = Focus.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard
    local trackable = DB.Trackable.RANGED_OVERALL

    if UI.BeginTable("Ranged", 5, Focus.TableFlags) then
        if makeBrief then
            UI.TableSetupColumn("Ranged Overall", colFlags, nameWidth)
            UI.TableSetupColumn("Average",  colFlags, width)
            UI.TableSetupColumn("Accuracy", colFlags, width)
            UI.TableSetupColumn("%Crit",    colFlags, width)
            UI.TableSetupColumn("Distance", colFlags, width)
        else
            UI.TableSetupColumn("Ranged Overall", colFlags, nameWidth)
            UI.TableSetupColumn("Damage",   colFlags, width)
            UI.TableSetupColumn("%Player",  colFlags, width)
            UI.TableSetupColumn("Accuracy", colFlags, width)
            UI.TableSetupColumn("Distance", colFlags, width)
        end
        UI.TableHeadersRow()

        if makeBrief then
            UI.TableNextColumn() UI.Text("Total")
            UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, trackable)
            UI.TableNextColumn() Column.Acc.ByType(playerName, trackable)
            UI.TableNextColumn() Column.Acc.ByType(playerName, trackable, 0, true)
            UI.TableNextColumn() Column.Damage.ShotDistance(playerName)
        else
            UI.TableNextColumn() UI.Text("Total")
            UI.TableNextColumn() Column.Damage.ByType(playerName, trackable)
            UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, nil, nil, true)
            UI.TableNextColumn() Column.Acc.ByType(playerName, trackable)
            UI.TableNextColumn() Column.Damage.ShotDistance(playerName)
        end
        WindowManager.TableRowColor(1)

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Build misc. ranged damage table.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param endamage   number
---@param endrain    number
---@param enaspir    number
------------------------------------------------------------------------------------------------------
Focus.Ranged.Auxiliary = function(playerName, endamage, endrain, enaspir)
    local colFlags  = Focus.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard
    local trackable = DB.Trackable.RANGED_OVERALL

    local shadows = DB.Data.Get(playerName, trackable, DB.Metric.SHADOW_ABSORPTION)
    local row     = 1

    if UI.BeginTable("Aux. Ranged", 4, Focus.TableFlags) then
        UI.TableSetupColumn("Ranged Auxiliary", colFlags, nameWidth)
        UI.TableSetupColumn("Average", colFlags, width)
        UI.TableSetupColumn("%Player", colFlags, width)
        UI.TableSetupColumn("%Proc",   colFlags, width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Crits")
        UI.TableNextColumn() Column.Damage.AverageByTypeCriticalOnly(playerName, trackable)
        UI.TableNextColumn() Column.Damage.ByTypeCrit(playerName, trackable, true)
        UI.TableNextColumn() Column.Acc.ByType(playerName, trackable, 0, true)
        WindowManager.TableRowColor(row)
        row = row + 1

        -- Data columns for damage that contributes to total damage without a proc rate.
        local extraDamageData = { }
        if endamage > 0 then table.insert(extraDamageData, { header = "En-Damage", trackable = DB.Trackable.RANGED_ENDAMAGE }) end
        if endrain > 0  then table.insert(extraDamageData, { header = "En-Drain",  trackable = DB.Trackable.RANGED_ENDRAIN  }) end

        for _, data in ipairs(extraDamageData) do
            UI.TableNextColumn() UI.Text(data.header)
            UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, data.trackable)
            UI.TableNextColumn() Column.Damage.ByType(playerName, data.trackable, nil, nil, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        -- Non-damaging data columns.
        if enaspir > 0 then
            UI.TableNextColumn() UI.Text("En-Aspir")
            UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, DB.Trackable.RANGED_ENASPIR)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        -- Effects that carry a damage value but do not contribute to player damage.
        if DB.Data.Get(playerName, trackable, DB.Metric.MOB_HEALING) > 0 then
            UI.TableNextColumn() UI.Text("Mob Heal")
            UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, trackable, DB.Metric.MOB_HEALING)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        -- Effects that just need a counter (per shot).
        local onShot = { }
        if shadows > 0 then table.insert(onShot, { header = "Shadows", trackable = trackable, metric = DB.Metric.SHADOW_ABSORPTION }) end

        for _, data in ipairs(onShot) do
            UI.TableNextColumn() UI.Text(tostring(data.header))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() Column.General.Fraction(playerName, data.trackable, data.metric, DB.Metric.HITS_ON_TARGET)
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows min, max, average damage for melee attacks.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Ranged.MinMax = function(playerName)
    local colFlags  = Focus.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard
    local row       = 1

    if UI.BeginTable("Min Max Ranged", 5, Focus.TableFlags) then
        UI.TableSetupColumn("MMA w/ Crit", colFlags, nameWidth)
        UI.TableSetupColumn("Average", colFlags, width)
        UI.TableSetupColumn("%Player", colFlags, width)
        UI.TableSetupColumn("Minimum", colFlags, width)
        UI.TableSetupColumn("Maximum", colFlags, width)
        UI.TableHeadersRow()

        local squareHit  = DB.Data.Get(playerName, DB.Trackable.RANGED_SQUARE_HIT,  DB.Metric.TOTAL)
        local trueStrike = DB.Data.Get(playerName, DB.Trackable.RANGED_TRUE_STRIKE, DB.Metric.TOTAL)

        -- Strike specific data.
        local damageTypes =
        {
            { header = "Regular Hit",  trackable = DB.Trackable.RANGED_OVERALL }
        }

        if squareHit > 0  then table.insert(damageTypes, { header = "Square Hit",  trackable = DB.Trackable.RANGED_SQUARE_HIT  }) end
        if trueStrike > 0 then table.insert(damageTypes, { header = "True Strike", trackable = DB.Trackable.RANGED_TRUE_STRIKE }) end

        for _, data in ipairs(damageTypes) do
            UI.TableNextColumn() UI.Text(data.header)
            UI.TableNextColumn() Column.Damage.AverageByTypeExcludeCritical(playerName, data.trackable)
            UI.TableNextColumn() Column.Damage.ByType(playerName, data.trackable, nil, nil, true)
            UI.TableNextColumn() Column.Damage.ByType(playerName, data.trackable, DB.Metric.MIN)
            UI.TableNextColumn() Column.Damage.ByType(playerName, data.trackable, DB.Metric.MAX)
            WindowManager.TableRowColor(row)

            UI.TableNextColumn() UI.Text("- Critical")
            UI.TableNextColumn() Column.Damage.AverageByTypeCriticalOnly(playerName, data.trackable)
            UI.TableNextColumn() Column.Damage.ByTypeCrit(playerName, data.trackable, true)
            UI.TableNextColumn() Column.Damage.ByType(playerName, data.trackable, DB.Metric.CRITICAL_MIN)
            UI.TableNextColumn() Column.Damage.ByType(playerName, data.trackable, DB.Metric.CRITICAL_MAX)
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        UI.EndTable()
    end
end
