Focus.Melee = { }

------------------------------------------------------------------------------------------------------
-- Loads data to the melee drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Melee.Display = function(playerName)
    local endamage    = DB.Data.Get(playerName, DB.Trackable.MELEE_ENDAMAGE, DB.Metric.TOTAL)
    local endebuff    = DB.Data.Get(playerName, DB.Trackable.MELEE_ENDEBUFF, DB.Metric.HITS_ON_USE)
    local paralyzed   = DB.Data.Get(playerName, DB.Trackable.ALL_PARALYZE,   DB.Metric.HITS_ON_USE)
    local intimidated = DB.Data.Get(playerName, DB.Trackable.ALL_INTIMIDATE, DB.Metric.HITS_ON_USE)
    local hasMulti    = DB.Data.Get(playerName, DB.Trackable.MELEE_OVERALL,  DB.Metric.MULTI_ATTACK_HIT_ON_USE) > 0

    Focus.Melee.Total(playerName)
    Focus.Melee.Auxiliary(playerName, endamage)
    Focus.Melee.MinMax(playerName)

    if paralyzed > 0 or intimidated > 0 then
        Focus.Melee.ActionBlocked(playerName, paralyzed, intimidated)
    end

    if hasMulti then
        Focus.Melee.MultiAttack(playerName)
    end

    if endebuff > 0 or endamage > 0 then UI.Separator() end
    if endebuff > 0 then Focus.Catalog.Endebuff(playerName, DB.Trackable.MELEE_ENDEBUFF) end
    if endamage > 0 then Focus.Catalog.Endamage(playerName, DB.Trackable.MELEE_ENDAMAGE) end
end

------------------------------------------------------------------------------------------------------
-- Build total melee damage table.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param makeBrief? boolean
------------------------------------------------------------------------------------------------------
Focus.Melee.Total = function(playerName, makeBrief)
    local colFlags   = Focus.ColumnFlags
    local tableFlags = Focus.TableFlags
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard

    local offHand       = DB.Data.Get(playerName, DB.Trackable.MELEE_OFF_HAND,     DB.Metric.TOTAL)
    local kickDamage    = DB.Data.Get(playerName, DB.Trackable.MELEE_KICK_ATTACKS, DB.Metric.TOTAL)
    local counterDamage = DB.Data.Get(playerName, DB.Trackable.MELEE_COUNTER,      DB.Metric.TOTAL)
    local hasMulti      = DB.Data.Get(playerName, DB.Trackable.MELEE_OVERALL,      DB.Metric.MULTI_ATTACK_HIT_ON_USE) > 0
    local columns       = makeBrief and 4 or 5

    if hasMulti then
        columns = columns + 1
    end

    if UI.BeginTable("Total Melee", columns, tableFlags) then
        UI.TableSetupColumn("Melee Overall", colFlags, nameWidth)
        if makeBrief then
            UI.TableSetupColumn("Average",  colFlags, width)
            UI.TableSetupColumn("Accuracy", colFlags, width)
            UI.TableSetupColumn("%Crit",    colFlags, width)
            if hasMulti then UI.TableSetupColumn("%Multi", colFlags, width) end
        else
            UI.TableSetupColumn("Damage",   colFlags, width)
            UI.TableSetupColumn("%Player",  colFlags, width)
            UI.TableSetupColumn("Accuracy", colFlags, width)
            UI.TableSetupColumn("%Crit",    colFlags, width)
            if hasMulti then UI.TableSetupColumn("%Multi", colFlags, width) end
        end
        UI.TableHeadersRow()

        local fullData =
        {
            { header = "Total",       trackable = DB.Trackable.MELEE_OVERALL, total = true },
            { header = "- Main-Hand", trackable = DB.Trackable.MELEE_MAIN_HAND             },
        }

        if offHand > 0    then table.insert(fullData, { header = "- Off-Hand",     trackable = DB.Trackable.MELEE_OFF_HAND     }) end
        if kickDamage > 0 then table.insert(fullData, { header = "- Kick Attacks", trackable = DB.Trackable.MELEE_KICK_ATTACKS }) end

        for _, data in ipairs(fullData) do
            UI.TableNextColumn() UI.Text(data.header)
            if makeBrief then
                UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, data.trackable)
                UI.TableNextColumn() Column.Acc.ByType(playerName, data.trackable)
                UI.TableNextColumn() Column.Acc.ByType(playerName, data.trackable, 0, true)
                if hasMulti then UI.TableNextColumn() Column.Acc.MultiAttack(playerName, data.trackable, DB.Metric.MULTI_ATTACK_HIT_ON_USE, data.total) end
            else
                UI.TableNextColumn() Column.Damage.ByType(playerName, data.trackable)
                UI.TableNextColumn() Column.Damage.ByType(playerName, data.trackable, nil, nil, true)
                UI.TableNextColumn() Column.Acc.ByType(playerName, data.trackable)
                UI.TableNextColumn() Column.Acc.ByType(playerName, data.trackable, 0, true)
                if hasMulti then UI.TableNextColumn() Column.Acc.MultiAttack(playerName, data.trackable, DB.Metric.MULTI_ATTACK_HIT_ON_USE, data.total) end
            end

            if data.header == "Total" then
                WindowManager.TableRowColor(1)
            else
                WindowManager.TableRowColor(0)
            end
        end

        -- Counter doesn't have the accuracy column.
        if counterDamage > 0 then
            local trackable = DB.Trackable.MELEE_COUNTER

            UI.TableNextColumn() UI.Text("Counter")
            if makeBrief then
                UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, trackable)
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                UI.TableNextColumn() Column.Acc.ByType(playerName, trackable, 0, true)
                if hasMulti then UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---") end
            else
                UI.TableNextColumn() Column.Damage.ByType(playerName, trackable)
                UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, nil, nil, true)
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                UI.TableNextColumn() Column.Acc.ByType(playerName, trackable, 0, true)
                if hasMulti then UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---") end
            end
            WindowManager.TableRowColor(0)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Build auxiliary melee damage table.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param endamage   number
------------------------------------------------------------------------------------------------------
Focus.Melee.Auxiliary = function(playerName, endamage)
    local colFlags   = Focus.ColumnFlags
    local tableFlags = Focus.TableFlags
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard

    local shadows = DB.Data.Get(playerName, DB.Trackable.MELEE_OVERALL,  DB.Metric.SHADOW_ABSORPTION)
    local enspell = DB.Data.Get(playerName, DB.Trackable.MELEE_ENSPELL,  DB.Metric.TOTAL)
    local endrain = DB.Data.Get(playerName, DB.Trackable.MELEE_ENDRAIN,  DB.Metric.TOTAL)
    local enaspir = DB.Data.Get(playerName, DB.Trackable.MELEE_ENASPIR,  DB.Metric.TOTAL)
    local counter = DB.Data.Get(playerName, DB.Trackable.MELEE_COUNTER,  DB.Metric.TOTAL)

    local row = 1

    if UI.BeginTable("Aux. Melee", 4, tableFlags) then
        UI.TableSetupColumn("Melee Auxiliary", colFlags, nameWidth)
        UI.TableSetupColumn("Average", colFlags, width)
        UI.TableSetupColumn("%Player", colFlags, width)
        UI.TableSetupColumn("%Proc",   colFlags, width)
        UI.TableHeadersRow()

        -- All data columns.
        local fullData =
        {
            { header = "Crits", trackable = DB.Trackable.MELEE_OVERALL }
        }

        if counter > 0 then table.insert(fullData, { header = "Counter", trackable = DB.Trackable.MELEE_COUNTER }) end

        for _, data in ipairs(fullData) do
            UI.TableNextColumn() UI.Text(data.header)
            UI.TableNextColumn() Column.Damage.AverageByTypeCriticalOnly(playerName, data.trackable)
            UI.TableNextColumn() Column.Damage.ByTypeCrit(playerName, data.trackable, true)
            UI.TableNextColumn() Column.Acc.ByType(playerName, data.trackable, 0, true)
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        -- Damaging additional effects.
        local enspellData = { }
        if endamage > 0 then table.insert(enspellData, { header = "En-Damage", trackable = DB.Trackable.MELEE_ENDAMAGE }) end
        if enspell > 0  then table.insert(enspellData, { header = "En-Spell",  trackable = DB.Trackable.MELEE_ENSPELL  }) end

        for _, data in ipairs(enspellData) do
            UI.TableNextColumn() UI.Text(data.header)
            UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, data.trackable)
            UI.TableNextColumn() Column.Damage.ByType(playerName, data.trackable, nil, nil, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        -- Non-damage additional effects.
        local addEffects = { }

        if endrain > 0 then table.insert(addEffects, { header = "En-Drain", trackable = DB.Trackable.MELEE_ENDRAIN }) end
        if enaspir > 0 then table.insert(addEffects, { header = "En-Aspir", trackable = DB.Trackable.MELEE_ENASPIR }) end

        for _, data in ipairs(addEffects) do
            UI.TableNextColumn() UI.Text(data.header)
            UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, data.trackable)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        -- Effects that carry a damage value but do not contribute to player damage.
        local trackable = DB.Trackable.MELEE_OVERALL
        if DB.Data.Get(playerName, trackable, DB.Metric.MOB_HEALING) > 0 then
            UI.TableNextColumn() UI.Text("Mob Heal")
            UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, trackable, DB.Metric.MOB_HEALING)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        -- Effects that just need a counter (per swing).
        local onSwing = { }
        if shadows > 0 then table.insert(onSwing, { header = "Shadows", trackable = DB.Trackable.MELEE_OVERALL, metric = DB.Metric.SHADOW_ABSORPTION }) end

        for _, data in ipairs(onSwing) do
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
-- Shows paralyzed, intimidated, etc.
------------------------------------------------------------------------------------------------------
---@param playerName  string
---@param paralyzed   integer
---@param intimidated integer
------------------------------------------------------------------------------------------------------
Focus.Melee.ActionBlocked = function(playerName, paralyzed, intimidated)
    local colFlags   = Focus.ColumnFlags
    local tableFlags = Focus.TableFlags
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard

    local row = 1

    if UI.BeginTable("Blocked", 2, tableFlags) then
        UI.TableSetupColumn("Action Blocked", colFlags, nameWidth)
        UI.TableSetupColumn("Count", colFlags, width)
        UI.TableHeadersRow()

        local blocked = { }
        if paralyzed > 0   then table.insert(blocked, { header = "Paralyzed",   trackable = DB.Trackable.ALL_PARALYZE,   metric = DB.Metric.HITS_ON_USE }) end
        if intimidated > 0 then table.insert(blocked, { header = "Intimidated", trackable = DB.Trackable.ALL_INTIMIDATE, metric = DB.Metric.HITS_ON_USE }) end

        for _, data in ipairs(blocked) do
            UI.TableNextColumn() UI.Text(tostring(data.header))
            UI.TableNextColumn() UI.Text(Column.String.FormatNumber(DB.Data.Get(playerName, data.trackable, data.metric)))
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
Focus.Melee.MinMax = function(playerName)
    local colFlags   = Focus.ColumnFlags
    local tableFlags = Focus.TableFlags
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard

    local offHand = DB.Data.Get(playerName, DB.Trackable.MELEE_OFF_HAND, DB.Metric.TOTAL)
    local kick    = DB.Data.Get(playerName, DB.Trackable.MELEE_KICK_ATTACKS, DB.Metric.TOTAL)
    local counter = DB.Data.Get(playerName, DB.Trackable.MELEE_COUNTER, DB.Metric.TOTAL)

    local row = 1

    if UI.BeginTable("Min Max Melee", 5, tableFlags) then
        UI.TableSetupColumn("MMA w/ Crit", colFlags, nameWidth)
        UI.TableSetupColumn("Average",     colFlags, width)
        UI.TableSetupColumn("%Player",     colFlags, width)
        UI.TableSetupColumn("Minimum",     colFlags, width)
        UI.TableSetupColumn("Maximum",     colFlags, width)
        UI.TableHeadersRow()

        local damageTypes =
        {
            { header = "Main-Hand", trackable = DB.Trackable.MELEE_MAIN_HAND },
        }

        if offHand > 0 then table.insert(damageTypes, { header = "Off-Hand", trackable = DB.Trackable.MELEE_OFF_HAND     }) end
        if kick > 0    then table.insert(damageTypes, { header = "Kick",     trackable = DB.Trackable.MELEE_KICK_ATTACKS }) end
        if counter > 0 then table.insert(damageTypes, { header = "Counter",  trackable = DB.Trackable.MELEE_COUNTER      }) end

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

------------------------------------------------------------------------------------------------------
-- Build melee multi-attack rate table.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Melee.MultiAttack = function(playerName)
    local colFlags   = Focus.ColumnFlags
    local tableFlags = Focus.TableFlags
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard

    local columns = 5

    if UI.BeginTable("Multi-Attack", columns, tableFlags) then
        UI.TableSetupColumn("Multi-Attack", colFlags, nameWidth)
        UI.TableSetupColumn("Main-Hand\n%Proc",   colFlags, width)
        UI.TableSetupColumn("Main-Hand\n%Player", colFlags, width)
        UI.TableSetupColumn("Off-Hand\n%Proc",    colFlags, width)
        UI.TableSetupColumn("Off-Hand\n%Player",  colFlags, width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Acc.MultiAttack(playerName, DB.Trackable.MELEE_MAIN_HAND, DB.Metric.MULTI_ATTACK_HIT_ON_USE)
        UI.TableNextColumn() Column.Damage.ByType(playerName,   DB.Trackable.MELEE_MAIN_HAND, DB.Metric.MULTI_ATTACK_TOTAL, nil, true)
        UI.TableNextColumn() Column.Acc.MultiAttack(playerName, DB.Trackable.MELEE_OFF_HAND,  DB.Metric.MULTI_ATTACK_HIT_ON_USE)
        UI.TableNextColumn() Column.Damage.ByType(playerName,   DB.Trackable.MELEE_OFF_HAND,  DB.Metric.MULTI_ATTACK_TOTAL, nil, true)
        WindowManager.TableRowColor(1)

        local multiAttackMetrics =
        {
            { count = DB.Metric.MULTI_ATTACK_2, damage = DB.Metric.MULTI_ATTACK_2_DAMAGE },
            { count = DB.Metric.MULTI_ATTACK_3, damage = DB.Metric.MULTI_ATTACK_3_DAMAGE },
            { count = DB.Metric.MULTI_ATTACK_4, damage = DB.Metric.MULTI_ATTACK_4_DAMAGE },
            { count = DB.Metric.MULTI_ATTACK_5, damage = DB.Metric.MULTI_ATTACK_5_DAMAGE },
            { count = DB.Metric.MULTI_ATTACK_6, damage = DB.Metric.MULTI_ATTACK_6_DAMAGE },
            { count = DB.Metric.MULTI_ATTACK_7, damage = DB.Metric.MULTI_ATTACK_7_DAMAGE },
            { count = DB.Metric.MULTI_ATTACK_8, damage = DB.Metric.MULTI_ATTACK_8_DAMAGE },
        }

        for _, data in ipairs(multiAttackMetrics) do
            if DB.Tracking.MultiAttack[playerName] and DB.Tracking.MultiAttack[playerName][data.count] then
                UI.TableNextColumn() UI.Text(string.format("- %s", data.count))
                UI.TableNextColumn() Column.Acc.MultiAttack(playerName, DB.Trackable.MELEE_MAIN_HAND, data.count)
                UI.TableNextColumn() Column.Damage.ByType(playerName,   DB.Trackable.MELEE_MAIN_HAND, data.damage, nil, true)
                UI.TableNextColumn() Column.Acc.MultiAttack(playerName, DB.Trackable.MELEE_OFF_HAND,  data.count)
                UI.TableNextColumn() Column.Damage.ByType(playerName,   DB.Trackable.MELEE_OFF_HAND,  data.damage, nil, true)
                WindowManager.TableRowColor(0)
            end
        end

        UI.EndTable()
    end
end