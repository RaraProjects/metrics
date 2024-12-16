Focus.Melee = T{}

------------------------------------------------------------------------------------------------------
-- Loads data to the melee drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Melee.Display = function(player_name)
    local off_hand = DB.Data.Get(player_name, DB.Trackable.MELEE_OFF_HAND, DB.Metric.TOTAL)
    local kick_damage = DB.Data.Get(player_name, DB.Trackable.MELEE_KICK_ATTACKS, DB.Metric.TOTAL)
    local counter_damage = DB.Data.Get(player_name, DB.Trackable.MELEE_COUNTER, DB.Metric.TOTAL)
    local endamage = DB.Data.Get(player_name, DB.Trackable.MELEE_ENDAMAGE, DB.Metric.TOTAL)
    local endebuff = DB.Data.Get(player_name, DB.Trackable.MELEE_ENDEBUFF, DB.Metric.HITS_ON_USE)

    Focus.Melee.Total(player_name, off_hand, kick_damage, counter_damage)
    Focus.Melee.Min_Max(player_name)
    Focus.Melee.Auxiliary(player_name, endamage)
    Focus.Melee.Multi_Attack(player_name)

    if endebuff > 0 or endamage > 0 then UI.Separator() end
    if endebuff > 0 then Focus.Catalog.Endebuff(player_name, DB.Trackable.MELEE_ENDEBUFF) end
    if endamage > 0 then Focus.Catalog.Endamage(player_name, DB.Trackable.MELEE_ENDAMAGE) end
end

------------------------------------------------------------------------------------------------------
-- Build total melee damage table.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param off_hand number
---@param kick_damage number
---@param counter_damage number
------------------------------------------------------------------------------------------------------
Focus.Melee.Total = function(player_name, off_hand, kick_damage, counter_damage)
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local row = 1
    if UI.BeginTable("Total Melee", 5, table_flags) then
        UI.TableSetupColumn("Melee", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, width)
        UI.TableSetupColumn("%Player", col_flags, width)
        UI.TableSetupColumn("Accuracy", col_flags, width)
        UI.TableSetupColumn("%Proc", col_flags, width)
        UI.TableHeadersRow()

        -- Total
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.MELEE_OVERALL)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.MELEE_OVERALL, true)
        UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.MELEE_OVERALL)
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        -- Main-Hand
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Main-Hand")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.MELEE_MAIN_HAND)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.MELEE_MAIN_HAND, true)
        UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.MELEE_MAIN_HAND)
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        -- Off-Hand
        if off_hand > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Off-Hand")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.MELEE_OFF_HAND)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.MELEE_OFF_HAND, true)
            UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.MELEE_OFF_HAND)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        -- Kick Attacks
        if kick_damage > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Kick Attacks")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.MELEE_KICK_ATTACKS)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.MELEE_KICK_ATTACKS, true)
            UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.MELEE_KICK_ATTACKS)
            UI.TableNextColumn() Column.Acc.Proc_Per_Use(player_name, DB.Trackable.MELEE_KICK_ATTACKS, DB.Trackable.MELEE_OVERALL)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        -- Counter
        if counter_damage > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Counter")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.MELEE_COUNTER)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.MELEE_COUNTER, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.MELEE_COUNTER)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
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
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local mob_heal = DB.Data.Get(player_name, DB.Trackable.MELEE_OVERALL, DB.Metric.MOB_HEALING)
    local shadows  = DB.Data.Get(player_name, DB.Trackable.MELEE_OVERALL, DB.Metric.SHADOW_ABSORPTION)
    local enspell  = DB.Data.Get(player_name, DB.Trackable.MELEE_ENSPELL, DB.Metric.TOTAL)
    local endrain  = DB.Data.Get(player_name, DB.Trackable.MELEE_ENDRAIN, DB.Metric.TOTAL)
    local enaspir  = DB.Data.Get(player_name, DB.Trackable.MELEE_ENASPIR, DB.Metric.TOTAL)
    local counter  = DB.Data.Get(player_name, DB.Trackable.MELEE_COUNTER, DB.Metric.TOTAL)

    local row = 1
    if UI.BeginTable("Aux. Melee", 5, table_flags) then
        UI.TableSetupColumn("Auxiliary", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, width)
        UI.TableSetupColumn("%Player", col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("%Proc", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Crits")
        UI.TableNextColumn() Column.Proc.Crit_Damage(player_name, DB.Trackable.MELEE_OVERALL)
        UI.TableNextColumn() Column.Proc.Crit_Damage(player_name, DB.Trackable.MELEE_OVERALL, true)
        UI.TableNextColumn() Column.Proc.Crit_Average(player_name, DB.Trackable.MELEE_OVERALL)
        UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.MELEE_OVERALL, true)
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        if counter > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Counter")
            UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.MELEE_COUNTER)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.MELEE_COUNTER, true)
            UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, DB.Trackable.MELEE_COUNTER)
            UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.MELEE_COUNTER)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        if endamage > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("En-Damage")
            UI.TableNextColumn() UI.Text(Column.String.Format_Number(endamage))
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.MELEE_ENDAMAGE, true)
            UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, DB.Trackable.MELEE_ENDAMAGE)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        if enspell > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("En-Spell")
            UI.TableNextColumn() UI.Text(Column.String.Format_Number(enspell))
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.MELEE_ENSPELL, true)
            UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, DB.Trackable.MELEE_ENSPELL)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        if endrain > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("En-Drain")
            UI.TableNextColumn() UI.Text(Column.String.Format_Number(endrain))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, DB.Trackable.MELEE_ENDRAIN)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        if enaspir > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("En-Aspir")
            UI.TableNextColumn() UI.Text(Column.String.Format_Number(enaspir))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, DB.Trackable.MELEE_ENASPIR)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        if mob_heal > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Mob Heal")
            UI.TableNextColumn() UI.Text(Column.String.Format_Number(mob_heal))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        if shadows > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Shadows")
            UI.TableNextColumn() UI.Text(Column.String.Format_Number(shadows))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
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
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local off_hand = DB.Data.Get(player_name, DB.Trackable.MELEE_OFF_HAND, DB.Metric.TOTAL)
    local kick_damage = DB.Data.Get(player_name, DB.Trackable.MELEE_KICK_ATTACKS, DB.Metric.TOTAL)

    local row = 1
    if UI.BeginTable("Min Max Melee", 4, table_flags) then
        UI.TableSetupColumn("MMA", col_flags, name_width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("Minimum", col_flags, width)
        UI.TableSetupColumn("Maximum", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Main-Hand")
        UI.TableNextColumn() Column.Damage.Average_Non_Critical_Melee_By_Type(player_name, DB.Trackable.MELEE_MAIN_HAND)
        UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, DB.Trackable.MELEE_MAIN_HAND, DB.Metric.MIN)
        UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, DB.Trackable.MELEE_MAIN_HAND, DB.Metric.MAX)
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Main-Hand Crits")
        UI.TableNextColumn() Column.Proc.Crit_Average(player_name, DB.Trackable.MELEE_MAIN_HAND)
        UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, DB.Trackable.MELEE_MAIN_HAND, DB.Metric.CRITICAL_MIN)
        UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, DB.Trackable.MELEE_MAIN_HAND, DB.Metric.CRITICAL_MAX)
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        if off_hand > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Off-Hand")
            UI.TableNextColumn() Column.Damage.Average_Non_Critical_Melee_By_Type(player_name, DB.Trackable.MELEE_OFF_HAND)
            UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, DB.Trackable.MELEE_OFF_HAND, DB.Metric.MIN)
            UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, DB.Trackable.MELEE_OFF_HAND, DB.Metric.MAX)
            Window_Manager.Table_Row_Color(row)
            row = row + 1

            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Off-Hand Crits")
            UI.TableNextColumn() Column.Proc.Crit_Average(player_name, DB.Trackable.MELEE_OFF_HAND)
            UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, DB.Trackable.MELEE_OFF_HAND, DB.Metric.CRITICAL_MIN)
            UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, DB.Trackable.MELEE_OFF_HAND, DB.Metric.CRITICAL_MAX)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        if kick_damage > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Kick Attacks")
            UI.TableNextColumn() Column.Damage.Average_Non_Critical_Melee_By_Type(player_name, DB.Trackable.MELEE_KICK_ATTACKS)
            UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, DB.Trackable.MELEE_KICK_ATTACKS, DB.Metric.MIN)
            UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, DB.Trackable.MELEE_KICK_ATTACKS, DB.Metric.MAX)
            Window_Manager.Table_Row_Color(row)
            row = row + 1

            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Kick Attacks Crits")
            UI.TableNextColumn() Column.Proc.Crit_Average(player_name, DB.Trackable.MELEE_KICK_ATTACKS)
            UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, DB.Trackable.MELEE_KICK_ATTACKS, DB.Metric.CRITICAL_MIN)
            UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, DB.Trackable.MELEE_KICK_ATTACKS, DB.Metric.CRITICAL_MAX)
            Window_Manager.Table_Row_Color(row)
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
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local columns = 3
    local row = 1
    if UI.BeginTable("Multi-Attack", columns, table_flags) then
        UI.TableSetupColumn("Multi-Attack", col_flags, name_width)
        UI.TableSetupColumn("Main-Hand", col_flags, width)
        UI.TableSetupColumn("Off-Hand", col_flags, width)
        UI.TableHeadersRow()

        local multi_attack_found = false
        local multi_attack_metrics = {
            [1] = DB.Metric.MULTI_ATTACK_1,
            [2] = DB.Metric.MULTI_ATTACK_2,
            [3] = DB.Metric.MULTI_ATTACK_3,
            [4] = DB.Metric.MULTI_ATTACK_4,
            [5] = DB.Metric.MULTI_ATTACK_5,
            [6] = DB.Metric.MULTI_ATTACK_6,
            [7] = DB.Metric.MULTI_ATTACK_7,
            [8] = DB.Metric.MULTI_ATTACK_8,
        }

        for _, metric in ipairs(multi_attack_metrics) do
            if DB.Tracking.Multi_Attack[player_name] and DB.Tracking.Multi_Attack[player_name][metric] then
                multi_attack_found = true
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(metric)
                UI.TableNextColumn() Column.Acc.Multi_Attack(player_name, DB.Trackable.MELEE_MAIN_HAND, metric)
                UI.TableNextColumn() Column.Acc.Multi_Attack(player_name, DB.Trackable.MELEE_OFF_HAND, metric)
                Window_Manager.Table_Row_Color(row)
                row = row + 1
            end
        end

        if not multi_attack_found then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("None")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        UI.EndTable()
    end
end