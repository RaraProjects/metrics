Focus.Melee = {}

------------------------------------------------------------------------------------------------------
-- Loads data to the melee drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Melee.Display = function(player_name)
    local endamage    = DB.Data.Get(player_name, DB.Trackable.MELEE_ENDAMAGE, DB.Metric.TOTAL)
    local endebuff    = DB.Data.Get(player_name, DB.Trackable.MELEE_ENDEBUFF, DB.Metric.HITS_ON_USE)
    local paralyzed   = DB.Data.Get(player_name, DB.Trackable.ALL_PARALYZE,   DB.Metric.HITS_ON_USE)
    local intimidated = DB.Data.Get(player_name, DB.Trackable.ALL_INTIMIDATE, DB.Metric.HITS_ON_USE)
    local has_multi   = DB.Data.Get(player_name, DB.Trackable.MELEE_OVERALL,  DB.Metric.MULTI_ATTACK_HIT_ON_USE) > 0

    Focus.Melee.Total(player_name)
    Focus.Melee.Auxiliary(player_name, endamage)
    Focus.Melee.Min_Max(player_name)
    if paralyzed > 0 or intimidated > 0 then Focus.Melee.Action_Blocked(player_name, paralyzed, intimidated) end
    if has_multi then Focus.Melee.Multi_Attack(player_name) end

    if endebuff > 0 or endamage > 0 then UI.Separator() end
    if endebuff > 0 then Focus.Catalog.Endebuff(player_name, DB.Trackable.MELEE_ENDEBUFF) end
    if endamage > 0 then Focus.Catalog.Endamage(player_name, DB.Trackable.MELEE_ENDAMAGE) end
end

------------------------------------------------------------------------------------------------------
-- Build total melee damage table.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param make_brief? boolean
------------------------------------------------------------------------------------------------------
Focus.Melee.Total = function(player_name, make_brief)
    local col_flags   = Focus.ColumnFlags
    local table_flags = Focus.TableFlags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local off_hand       = DB.Data.Get(player_name, DB.Trackable.MELEE_OFF_HAND,     DB.Metric.TOTAL)
    local kick_damage    = DB.Data.Get(player_name, DB.Trackable.MELEE_KICK_ATTACKS, DB.Metric.TOTAL)
    local counter_damage = DB.Data.Get(player_name, DB.Trackable.MELEE_COUNTER,      DB.Metric.TOTAL)
    local has_multi      = DB.Data.Get(player_name, DB.Trackable.MELEE_OVERALL, DB.Metric.MULTI_ATTACK_HIT_ON_USE) > 0

    local columns = 5
    if make_brief then columns = 4 end
    if has_multi then columns = columns + 1 end

    if UI.BeginTable("Total Melee", columns, table_flags) then
        UI.TableSetupColumn("Melee Overall", col_flags, name_width)
        if make_brief then
            UI.TableSetupColumn("Average",  col_flags, width)
            UI.TableSetupColumn("Accuracy", col_flags, width)
            UI.TableSetupColumn("%Crit",    col_flags, width)
            if has_multi then UI.TableSetupColumn("%Multi", col_flags, width) end
        else
            UI.TableSetupColumn("Damage",   col_flags, width)
            UI.TableSetupColumn("%Player",  col_flags, width)
            UI.TableSetupColumn("Accuracy", col_flags, width)
            UI.TableSetupColumn("%Crit",    col_flags, width)
            if has_multi then UI.TableSetupColumn("%Multi", col_flags, width) end
        end
        UI.TableHeadersRow()

        local full_data = {}
        table.insert(full_data, {header = "Total",       trackable = DB.Trackable.MELEE_OVERALL, total = true})
        table.insert(full_data, {header = "- Main-Hand", trackable = DB.Trackable.MELEE_MAIN_HAND})
        if off_hand > 0    then table.insert(full_data, {header = "- Off-Hand",     trackable = DB.Trackable.MELEE_OFF_HAND}) end
        if kick_damage > 0 then table.insert(full_data, {header = "- Kick Attacks", trackable = DB.Trackable.MELEE_KICK_ATTACKS}) end

        for _, data in ipairs(full_data) do
            UI.TableNextColumn() UI.Text(data.header)
            if make_brief then
                UI.TableNextColumn() Column.Damage.ByTypeAverage(player_name, data.trackable)
                UI.TableNextColumn() Column.Acc.ByType(player_name, data.trackable)
                UI.TableNextColumn() Column.Acc.ByType(player_name, data.trackable, 0, true)
                if has_multi then UI.TableNextColumn() Column.Acc.Multi_Attack(player_name, data.trackable, DB.Metric.MULTI_ATTACK_HIT_ON_USE, data.total) end
            else
                UI.TableNextColumn() Column.Damage.ByType(player_name, data.trackable)
                UI.TableNextColumn() Column.Damage.ByType(player_name, data.trackable, nil, nil, true)
                UI.TableNextColumn() Column.Acc.ByType(player_name, data.trackable)
                UI.TableNextColumn() Column.Acc.ByType(player_name, data.trackable, 0, true)
                if has_multi then UI.TableNextColumn() Column.Acc.Multi_Attack(player_name, data.trackable, DB.Metric.MULTI_ATTACK_HIT_ON_USE, data.total) end
            end
            if data.header == "Total" then
                WindowManager.TableRowColor(1)
            else
                WindowManager.TableRowColor(0)
            end
        end

        -- Counter doesn't have the accuracy column.
        if counter_damage > 0 then
            local trackable = DB.Trackable.MELEE_COUNTER
            UI.TableNextColumn() UI.Text("Counter")
            if make_brief then
                UI.TableNextColumn() Column.Damage.ByTypeAverage(player_name, trackable)
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                UI.TableNextColumn() Column.Acc.ByType(player_name, trackable, 0, true)
                if has_multi then UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---") end
            else
                UI.TableNextColumn() Column.Damage.ByType(player_name, trackable)
                UI.TableNextColumn() Column.Damage.ByType(player_name, trackable, nil, nil, true)
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                UI.TableNextColumn() Column.Acc.ByType(player_name, trackable, 0, true)
                if has_multi then UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---") end
            end
            WindowManager.TableRowColor(0)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Build auxiliary melee damage table.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param endamage number
------------------------------------------------------------------------------------------------------
Focus.Melee.Auxiliary = function(player_name, endamage)
    local col_flags   = Focus.ColumnFlags
    local table_flags = Focus.TableFlags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local shadows = DB.Data.Get(player_name, DB.Trackable.MELEE_OVERALL,  DB.Metric.SHADOW_ABSORPTION)
    local enspell = DB.Data.Get(player_name, DB.Trackable.MELEE_ENSPELL,  DB.Metric.TOTAL)
    local endrain = DB.Data.Get(player_name, DB.Trackable.MELEE_ENDRAIN,  DB.Metric.TOTAL)
    local enaspir = DB.Data.Get(player_name, DB.Trackable.MELEE_ENASPIR,  DB.Metric.TOTAL)
    local counter = DB.Data.Get(player_name, DB.Trackable.MELEE_COUNTER,  DB.Metric.TOTAL)

    local row = 1
    if UI.BeginTable("Aux. Melee", 4, table_flags) then
        UI.TableSetupColumn("Melee Auxiliary", col_flags, name_width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("%Player", col_flags, width)
        UI.TableSetupColumn("%Proc", col_flags, width)
        UI.TableHeadersRow()

        -- All data columns.
        local full_data = {}
        table.insert(full_data, {header = "Crits", trackable = DB.Trackable.MELEE_OVERALL})
        if counter > 0 then table.insert(full_data, {header = "Counter", trackable = DB.Trackable.MELEE_COUNTER}) end

        for _, data in ipairs(full_data) do
            UI.TableNextColumn() UI.Text(data.header)
            UI.TableNextColumn() Column.Damage.Average_By_Type_Critical_Only(player_name, data.trackable)
            UI.TableNextColumn() Column.Damage.By_Type_Crit(player_name, data.trackable, true)
            UI.TableNextColumn() Column.Acc.ByType(player_name, data.trackable, 0, true)
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        -- Damaging additional effects.
        local enspell_data = {}
        if endamage > 0 then table.insert(enspell_data, {header = "En-Damage", trackable = DB.Trackable.MELEE_ENDAMAGE}) end
        if enspell > 0  then table.insert(enspell_data, {header = "En-Spell",  trackable = DB.Trackable.MELEE_ENSPELL}) end

        for _, data in ipairs(enspell_data) do
            UI.TableNextColumn() UI.Text(data.header)
            UI.TableNextColumn() Column.Damage.ByTypeAverage(player_name, data.trackable)
            UI.TableNextColumn() Column.Damage.ByType(player_name, data.trackable, nil, nil, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        -- Non-damage additional effects.
        local add_effects = {}
        if endrain > 0 then table.insert(add_effects, {header = "En-Drain", trackable = DB.Trackable.MELEE_ENDRAIN}) end
        if enaspir > 0 then table.insert(add_effects, {header = "En-Aspir", trackable = DB.Trackable.MELEE_ENASPIR}) end

        for _, data in ipairs(add_effects) do
            UI.TableNextColumn() UI.Text(data.header)
            UI.TableNextColumn() Column.Damage.ByTypeAverage(player_name, data.trackable)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        -- Effects that carry a damage value but do not contribute to player damage.
        local trackable = DB.Trackable.MELEE_OVERALL
        if DB.Data.Get(player_name, trackable, DB.Metric.MOB_HEALING) > 0 then
            UI.TableNextColumn() UI.Text("Mob Heal")
            UI.TableNextColumn() Column.Damage.ByTypeAverage(player_name, trackable, DB.Metric.MOB_HEALING)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        -- Effects that just need a counter (per swing).
        local on_swing = {}
        if shadows > 0 then table.insert(on_swing, {header = "Shadows", trackable = DB.Trackable.MELEE_OVERALL, metric = DB.Metric.SHADOW_ABSORPTION}) end

        for _, data in ipairs(on_swing) do
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
-- Shows paralyzed, intimidated, etc.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param paralyzed integer
---@param intimidated integer
------------------------------------------------------------------------------------------------------
Focus.Melee.Action_Blocked = function(player_name, paralyzed, intimidated)
    local col_flags   = Focus.ColumnFlags
    local table_flags = Focus.TableFlags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local row = 1
    if UI.BeginTable("Blocked", 2, table_flags) then
        UI.TableSetupColumn("Action Blocked", col_flags, name_width)
        UI.TableSetupColumn("Count", col_flags, width)
        UI.TableHeadersRow()

        local blocked = {}
        if paralyzed > 0   then table.insert(blocked, {header = "Paralyzed",   trackable = DB.Trackable.ALL_PARALYZE,   metric = DB.Metric.HITS_ON_USE}) end
        if intimidated > 0 then table.insert(blocked, {header = "Intimidated", trackable = DB.Trackable.ALL_INTIMIDATE, metric = DB.Metric.HITS_ON_USE}) end

        for _, data in ipairs(blocked) do
            UI.TableNextColumn() UI.Text(tostring(data.header))
            UI.TableNextColumn() UI.Text(Column.String.FormatNumber(DB.Data.Get(player_name, data.trackable, data.metric)))
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
Focus.Melee.Min_Max = function(player_name)
    local col_flags   = Focus.ColumnFlags
    local table_flags = Focus.TableFlags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local off_hand = DB.Data.Get(player_name, DB.Trackable.MELEE_OFF_HAND, DB.Metric.TOTAL)
    local kick     = DB.Data.Get(player_name, DB.Trackable.MELEE_KICK_ATTACKS, DB.Metric.TOTAL)
    local counter  = DB.Data.Get(player_name, DB.Trackable.MELEE_COUNTER, DB.Metric.TOTAL)

    local row = 1
    if UI.BeginTable("Min Max Melee", 5, table_flags) then
        UI.TableSetupColumn("MMA w/ Crit", col_flags, name_width)
        UI.TableSetupColumn("Average",     col_flags, width)
        UI.TableSetupColumn("%Player",     col_flags, width)
        UI.TableSetupColumn("Minimum",     col_flags, width)
        UI.TableSetupColumn("Maximum",     col_flags, width)
        UI.TableHeadersRow()

        local damage_types = {}
        table.insert(damage_types, {header = "Main-Hand", trackable = DB.Trackable.MELEE_MAIN_HAND})
        if off_hand > 0 then table.insert(damage_types, {header = "Off-Hand", trackable = DB.Trackable.MELEE_OFF_HAND}) end
        if kick > 0     then table.insert(damage_types, {header = "Kick",     trackable = DB.Trackable.MELEE_KICK_ATTACKS}) end
        if counter > 0  then table.insert(damage_types, {header = "Counter",  trackable = DB.Trackable.MELEE_COUNTER}) end

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

------------------------------------------------------------------------------------------------------
-- Build melee multi-attack rate table.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Melee.Multi_Attack = function(player_name)
    local col_flags   = Focus.ColumnFlags
    local table_flags = Focus.TableFlags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local columns = 5
    if UI.BeginTable("Multi-Attack", columns, table_flags) then
        UI.TableSetupColumn("Multi-Attack", col_flags, name_width)
        UI.TableSetupColumn("Main-Hand\n%Proc",   col_flags, width)
        UI.TableSetupColumn("Main-Hand\n%Player", col_flags, width)
        UI.TableSetupColumn("Off-Hand\n%Proc",    col_flags, width)
        UI.TableSetupColumn("Off-Hand\n%Player",  col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Acc.Multi_Attack(player_name, DB.Trackable.MELEE_MAIN_HAND, DB.Metric.MULTI_ATTACK_HIT_ON_USE)
        UI.TableNextColumn() Column.Damage.ByType(player_name,   DB.Trackable.MELEE_MAIN_HAND, DB.Metric.MULTI_ATTACK_TOTAL, nil, true)
        UI.TableNextColumn() Column.Acc.Multi_Attack(player_name, DB.Trackable.MELEE_OFF_HAND,  DB.Metric.MULTI_ATTACK_HIT_ON_USE)
        UI.TableNextColumn() Column.Damage.ByType(player_name,   DB.Trackable.MELEE_OFF_HAND,  DB.Metric.MULTI_ATTACK_TOTAL, nil, true)
        WindowManager.TableRowColor(1)

        local multi_attack_metrics = {
            [1] = {count = DB.Metric.MULTI_ATTACK_2, damage = DB.Metric.MULTI_ATTACK_2_DAMAGE},
            [2] = {count = DB.Metric.MULTI_ATTACK_3, damage = DB.Metric.MULTI_ATTACK_3_DAMAGE},
            [3] = {count = DB.Metric.MULTI_ATTACK_4, damage = DB.Metric.MULTI_ATTACK_4_DAMAGE},
            [4] = {count = DB.Metric.MULTI_ATTACK_5, damage = DB.Metric.MULTI_ATTACK_5_DAMAGE},
            [5] = {count = DB.Metric.MULTI_ATTACK_6, damage = DB.Metric.MULTI_ATTACK_6_DAMAGE},
            [6] = {count = DB.Metric.MULTI_ATTACK_7, damage = DB.Metric.MULTI_ATTACK_7_DAMAGE},
            [7] = {count = DB.Metric.MULTI_ATTACK_8, damage = DB.Metric.MULTI_ATTACK_8_DAMAGE},
        }

        for _, data in ipairs(multi_attack_metrics) do
            if DB.Tracking.MultiAttack[player_name] and DB.Tracking.MultiAttack[player_name][data.count] then
                UI.TableNextColumn() UI.Text("- " .. data.count)
                UI.TableNextColumn() Column.Acc.Multi_Attack(player_name, DB.Trackable.MELEE_MAIN_HAND, data.count)
                UI.TableNextColumn() Column.Damage.ByType(player_name,   DB.Trackable.MELEE_MAIN_HAND, data.damage, nil, true)
                UI.TableNextColumn() Column.Acc.Multi_Attack(player_name, DB.Trackable.MELEE_OFF_HAND,  data.count)
                UI.TableNextColumn() Column.Damage.ByType(player_name,   DB.Trackable.MELEE_OFF_HAND,  data.damage, nil, true)
                WindowManager.TableRowColor(0)
            end
        end

        UI.EndTable()
    end
end