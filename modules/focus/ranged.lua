Focus.Ranged = {}

------------------------------------------------------------------------------------------------------
-- Loads data to the ranged drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Ranged.Display = function(player_name)
    local endamage    = DB.Data.Get(player_name, DB.Trackable.RANGED_ENDAMAGE, DB.Metric.TOTAL)
    local endebuff    = DB.Data.Get(player_name, DB.Trackable.RANGED_ENDEBUFF, DB.Metric.HITS_ON_TARGET)
    local endrain     = DB.Data.Get(player_name, DB.Trackable.RANGED_ENDRAIN,  DB.Metric.HITS_ON_TARGET)
    local enaspir     = DB.Data.Get(player_name, DB.Trackable.RANGED_ENASPIR,  DB.Metric.HITS_ON_TARGET)
    local paralyzed   = DB.Data.Get(player_name, DB.Trackable.ALL_PARALYZE,    DB.Metric.HITS_ON_USE)
    local intimidated = DB.Data.Get(player_name, DB.Trackable.ALL_INTIMIDATE,  DB.Metric.HITS_ON_USE)

    Focus.Ranged.Total(player_name)
    Focus.Ranged.Auxiliary(player_name, endamage, endrain, enaspir)
    Focus.Ranged.Min_Max(player_name)
    if paralyzed > 0 or intimidated > 0 then Focus.Melee.ActionBlocked(player_name, paralyzed, intimidated) end

    if endebuff > 0 or endamage > 0 then UI.Separator() end
    if endebuff > 0 then Focus.Catalog.Endebuff(player_name, DB.Trackable.RANGED_ENDEBUFF) end
    if endamage > 0 then Focus.Catalog.Endamage(player_name, DB.Trackable.RANGED_ENDAMAGE) end
end

------------------------------------------------------------------------------------------------------
-- Build total ranged damage table.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param make_brief? boolean
------------------------------------------------------------------------------------------------------
Focus.Ranged.Total = function(player_name, make_brief)
    local col_flags   = Focus.ColumnFlags
    local table_flags = Focus.TableFlags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard
    local trackable   = DB.Trackable.RANGED_OVERALL

    local columns = 5

    if UI.BeginTable("Ranged", columns, table_flags) then
        if make_brief then
            UI.TableSetupColumn("Ranged Overall", col_flags, name_width)
            UI.TableSetupColumn("Average",   col_flags, width)
            UI.TableSetupColumn("Accuracy", col_flags, width)
            UI.TableSetupColumn("%Crit",    col_flags, width)
            UI.TableSetupColumn("Distance", col_flags, width)
        else
            UI.TableSetupColumn("Ranged Overall", col_flags, name_width)
            UI.TableSetupColumn("Damage",   col_flags, width)
            UI.TableSetupColumn("%Player",  col_flags, width)
            UI.TableSetupColumn("Accuracy", col_flags, width)
            UI.TableSetupColumn("Distance", col_flags, width)
        end
        UI.TableHeadersRow()

        if make_brief then
            UI.TableNextColumn() UI.Text("Total")
            UI.TableNextColumn() Column.Damage.ByTypeAverage(player_name, trackable)
            UI.TableNextColumn() Column.Acc.ByType(player_name, trackable)
            UI.TableNextColumn() Column.Acc.ByType(player_name, trackable, 0, true)
            UI.TableNextColumn() Column.Damage.Shot_Distance(player_name)
        else
            UI.TableNextColumn() UI.Text("Total")
            UI.TableNextColumn() Column.Damage.ByType(player_name, trackable)
            UI.TableNextColumn() Column.Damage.ByType(player_name, trackable, nil, nil, true)
            UI.TableNextColumn() Column.Acc.ByType(player_name, trackable)
            UI.TableNextColumn() Column.Damage.Shot_Distance(player_name)
        end
        WindowManager.TableRowColor(1)

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Build misc. ranged damage table.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param endamage number
---@param endrain number
---@param enaspir number
------------------------------------------------------------------------------------------------------
Focus.Ranged.Auxiliary = function(player_name, endamage, endrain, enaspir)
    local col_flags   = Focus.ColumnFlags
    local table_flags = Focus.TableFlags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard
    local trackable   = DB.Trackable.RANGED_OVERALL

    local shadows = DB.Data.Get(player_name, trackable, DB.Metric.SHADOW_ABSORPTION)

    local row = 1
    if UI.BeginTable("Aux. Ranged", 4, table_flags) then
        UI.TableSetupColumn("Ranged Auxiliary", col_flags, name_width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("%Player", col_flags, width)
        UI.TableSetupColumn("%Proc",   col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Crits")
        UI.TableNextColumn() Column.Damage.Average_By_Type_Critical_Only(player_name, trackable)
        UI.TableNextColumn() Column.Damage.By_Type_Crit(player_name, trackable, true)
        UI.TableNextColumn() Column.Acc.ByType(player_name, trackable, 0, true)
        WindowManager.TableRowColor(row)
        row = row + 1

        -- Data columns for damage that contributes to total damage without a proc rate.
        local extra_damage_data = {}
        if endamage > 0 then table.insert(extra_damage_data, {header = "En-Damage", trackable = DB.Trackable.RANGED_ENDAMAGE}) end
        if endrain > 0  then table.insert(extra_damage_data, {header = "En-Drain",  trackable = DB.Trackable.RANGED_ENDRAIN}) end

        for _, data in ipairs(extra_damage_data) do
            UI.TableNextColumn() UI.Text(data.header)
            UI.TableNextColumn() Column.Damage.ByTypeAverage(player_name, data.trackable)
            UI.TableNextColumn() Column.Damage.ByType(player_name, data.trackable, nil, nil, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        -- Non-damaging data columns.
        if enaspir > 0 then
            UI.TableNextColumn() UI.Text("En-Aspir")
            UI.TableNextColumn() Column.Damage.ByTypeAverage(player_name, DB.Trackable.RANGED_ENASPIR)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        -- Effects that carry a damage value but do not contribute to player damage.
        if DB.Data.Get(player_name, trackable, DB.Metric.MOB_HEALING) > 0 then
            UI.TableNextColumn() UI.Text("Mob Heal")
            UI.TableNextColumn() Column.Damage.ByTypeAverage(player_name, trackable, DB.Metric.MOB_HEALING)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        -- Effects that just need a counter (per shot).
        local on_shot = {}
        if shadows > 0 then table.insert(on_shot, {header = "Shadows", trackable = trackable, metric = DB.Metric.SHADOW_ABSORPTION}) end

        for _, data in ipairs(on_shot) do
            UI.TableNextColumn() UI.Text(tostring(data.header))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() Column.General.Fraction(player_name, data.trackable, data.metric, DB.Metric.HITS_ON_TARGET)
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows min, max, average damage for melee attacks.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Ranged.Min_Max = function(player_name)
    local col_flags   = Focus.ColumnFlags
    local table_flags = Focus.TableFlags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local row = 1
    if UI.BeginTable("Min Max Ranged", 5, table_flags) then
        UI.TableSetupColumn("MMA w/ Crit", col_flags, name_width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("%Player", col_flags, width)
        UI.TableSetupColumn("Minimum", col_flags, width)
        UI.TableSetupColumn("Maximum", col_flags, width)
        UI.TableHeadersRow()

        local square_hit  = DB.Data.Get(player_name, DB.Trackable.RANGED_SQUARE_HIT,  DB.Metric.TOTAL)
        local true_strike = DB.Data.Get(player_name, DB.Trackable.RANGED_TRUE_STRIKE, DB.Metric.TOTAL)

        -- Strike specific data.
        local damage_types = {}
        table.insert(damage_types, {header = "Regular Hit",  trackable = DB.Trackable.RANGED_OVERALL})
        if square_hit > 0  then table.insert(damage_types, {header = "Square Hit",  trackable = DB.Trackable.RANGED_SQUARE_HIT}) end
        if true_strike > 0 then table.insert(damage_types, {header = "True Strike", trackable = DB.Trackable.RANGED_TRUE_STRIKE}) end

        for _, data in ipairs(damage_types) do
            UI.TableNextColumn() UI.Text(data.header)
            UI.TableNextColumn() Column.Damage.Average_By_Type_Exclude_Critical(player_name, data.trackable)
            UI.TableNextColumn() Column.Damage.ByType(player_name, data.trackable, nil, nil, true)
            UI.TableNextColumn() Column.Damage.ByType(player_name, data.trackable, DB.Metric.MIN)
            UI.TableNextColumn() Column.Damage.ByType(player_name, data.trackable, DB.Metric.MAX)
            WindowManager.TableRowColor(row)

            UI.TableNextColumn() UI.Text("- Critical")
            UI.TableNextColumn() Column.Damage.Average_By_Type_Critical_Only(player_name, data.trackable)
            UI.TableNextColumn() Column.Damage.By_Type_Crit(player_name, data.trackable, true)
            UI.TableNextColumn() Column.Damage.ByType(player_name, data.trackable, DB.Metric.CRITICAL_MIN)
            UI.TableNextColumn() Column.Damage.ByType(player_name, data.trackable, DB.Metric.CRITICAL_MAX)
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        UI.EndTable()
    end
end
