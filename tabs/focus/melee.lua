Focus.Melee = T{}

------------------------------------------------------------------------------------------------------
-- Loads data to the melee drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Melee.Display = function(player_name)
    local off_hand = DB.Data.Get(player_name, DB.Enum.Trackable.MELEE_OFFHAND, DB.Enum.Metric.TOTAL)
    local kick_damage = DB.Data.Get(player_name, DB.Enum.Trackable.MELEE_KICK, DB.Enum.Metric.TOTAL)
    local counter_damage = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_COUNTER, DB.Enum.Metric.TOTAL)
    local endamage = DB.Data.Get(player_name, DB.Enum.Trackable.ENDAMAGE, DB.Enum.Metric.TOTAL)
    local endebuff = DB.Data.Get(player_name, DB.Enum.Trackable.ENDEBUFF, DB.Enum.Metric.HIT_COUNT)

    Focus.Melee.Total(player_name, off_hand, kick_damage, counter_damage)
    Focus.Melee.Auxiliary(player_name, endamage)
    Focus.Melee.Multi_Attack(player_name, kick_damage)

    if endebuff > 0 or endamage > 0 then UI.Separator() end
    if endebuff > 0 then Focus.Catalog.Endebuff(player_name, DB.Enum.Trackable.ENDEBUFF) end
    if endamage > 0 then Focus.Catalog.Endamage(player_name, DB.Enum.Trackable.ENDAMAGE) end
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

    if UI.BeginTable("Total Melee", 5, table_flags) then
        UI.TableSetupColumn("Melee", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, width)
        UI.TableSetupColumn("Damage %", col_flags, width)
        UI.TableSetupColumn("Accuracy", col_flags, width)
        UI.TableSetupColumn("Rate", col_flags, width)
        UI.TableHeadersRow()

        -- Total
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE, true)
        UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Enum.Trackable.MELEE)
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")

        -- Main-Hand
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Main-Hand")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE_MAIN)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE_MAIN, true)
        UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Enum.Trackable.MELEE_MAIN)
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")

        -- Off-Hand
        if off_hand > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Off-Hand")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE_OFFHAND)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE_OFFHAND, true)
            UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Enum.Trackable.MELEE_OFFHAND)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        -- Kick Attacks
        if kick_damage > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Kick Attacks")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE_KICK)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE_KICK, true)
            UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Enum.Trackable.MELEE_KICK)
            UI.TableNextColumn() Column.Proc.Kick_Rate(player_name)
        end

        -- Counter
        if counter_damage > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Counter")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.DEF_COUNTER)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.DEF_COUNTER, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_COUNTER)
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

    local mob_heal = DB.Data.Get(player_name, DB.Enum.Trackable.MELEE,   DB.Enum.Metric.MOB_HEAL)
    local shadows  = DB.Data.Get(player_name, DB.Enum.Trackable.MELEE,   DB.Enum.Metric.SHADOWS)
    local enspell  = DB.Data.Get(player_name, DB.Enum.Trackable.ENSPELL, DB.Enum.Metric.TOTAL)
    local endrain  = DB.Data.Get(player_name, DB.Enum.Trackable.ENDRAIN, DB.Enum.Metric.TOTAL)
    local enaspir  = DB.Data.Get(player_name, DB.Enum.Trackable.ENASPIR, DB.Enum.Metric.TOTAL)
    local guard    = DB.Data.Get(player_name, DB.Enum.Trackable.MELEE,   DB.Enum.Metric.GUARD)

    if UI.BeginTable("Aux. Melee", 4, table_flags) then
        UI.TableSetupColumn("Auxiliary", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, width)
        UI.TableSetupColumn("Damage %", col_flags, width)
        UI.TableSetupColumn("Rate", col_flags, width)
        UI.TableHeadersRow()

        -- Critical Hits
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Crits")
        UI.TableNextColumn() Column.Proc.Crit_Damage(player_name, DB.Enum.Trackable.MELEE)
        UI.TableNextColumn() Column.Proc.Crit_Damage(player_name, DB.Enum.Trackable.MELEE, true)
        UI.TableNextColumn() Column.Proc.Crit_Rate(player_name, DB.Enum.Trackable.MELEE)

        if guard > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Guarded")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() Column.Proc.Guard(player_name, DB.Enum.Trackable.MELEE)
        end

        if endamage > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("En-Damage")
            UI.TableNextColumn() UI.Text(Column.String.Format_Number(endamage))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        if enspell > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("En-Spell")
            UI.TableNextColumn() UI.Text(Column.String.Format_Number(enspell))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        if endrain > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("En-Drain")
            UI.TableNextColumn() UI.Text(Column.String.Format_Number(endrain))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        if enaspir > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("En-Aspir")
            UI.TableNextColumn() UI.Text(Column.String.Format_Number(enaspir))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end


        if mob_heal > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Mob Heal")
            UI.TableNextColumn() UI.Text(Column.String.Format_Number(mob_heal))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        if shadows > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Shadows")
            UI.TableNextColumn() UI.Text(Column.String.Format_Number(shadows))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Build melee multi-attack rate table.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param kick_damage number
------------------------------------------------------------------------------------------------------
Focus.Melee.Multi_Attack = function(player_name, kick_damage)
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local columns = 3
    if kick_damage > 0 then columns = 4 end
    if UI.BeginTable("Multi-Attack", columns, table_flags) then
        UI.TableSetupColumn("Multi-Attack", col_flags, name_width)
        UI.TableSetupColumn("Main-Hand", col_flags, width)
        UI.TableSetupColumn("Off-Hand", col_flags, width)
        if kick_damage > 0 then UI.TableSetupColumn("Kicks", col_flags, width) end
        UI.TableHeadersRow()

        local multi_attack_found = false
        if DB.Tracking.Multi_Attack[player_name][DB.Enum.Metric.MULT_ATK_1] then
            multi_attack_found = true
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(DB.Enum.Metric.MULT_ATK_1)
            UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_MAIN, DB.Enum.Metric.MULT_ATK_1)
            UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_OFFHAND, DB.Enum.Metric.MULT_ATK_1)
            if kick_damage > 0 then UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_KICK, DB.Enum.Metric.MULT_ATK_1) end
        end

        if DB.Tracking.Multi_Attack[player_name][DB.Enum.Metric.MULT_ATK_2] then
            multi_attack_found = true
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(DB.Enum.Metric.MULT_ATK_2)
            UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_MAIN, DB.Enum.Metric.MULT_ATK_2)
            UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_OFFHAND, DB.Enum.Metric.MULT_ATK_2)
            if kick_damage > 0 then UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_KICK, DB.Enum.Metric.MULT_ATK_2) end
        end

        if DB.Tracking.Multi_Attack[player_name][DB.Enum.Metric.MULT_ATK_3] then
            multi_attack_found = true
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(DB.Enum.Metric.MULT_ATK_3)
            UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_MAIN, DB.Enum.Metric.MULT_ATK_3)
            UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_OFFHAND, DB.Enum.Metric.MULT_ATK_3)
            if kick_damage > 0 then UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_KICK, DB.Enum.Metric.MULT_ATK_3) end
        end

        if DB.Tracking.Multi_Attack[player_name][DB.Enum.Metric.MULT_ATK_4] then
            multi_attack_found = true
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(DB.Enum.Metric.MULT_ATK_4)
            UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_MAIN, DB.Enum.Metric.MULT_ATK_4)
            UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_OFFHAND, DB.Enum.Metric.MULT_ATK_4)
            if kick_damage > 0 then UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_KICK, DB.Enum.Metric.MULT_ATK_4) end
        end

        if DB.Tracking.Multi_Attack[player_name][DB.Enum.Metric.MULT_ATK_5] then
            multi_attack_found = true
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(DB.Enum.Metric.MULT_ATK_5)
            UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_MAIN, DB.Enum.Metric.MULT_ATK_5)
            UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_OFFHAND, DB.Enum.Metric.MULT_ATK_5)
            if kick_damage > 0 then UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_KICK, DB.Enum.Metric.MULT_ATK_5) end
        end

        if DB.Tracking.Multi_Attack[player_name][DB.Enum.Metric.MULT_ATK_6] then
            multi_attack_found = true
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(DB.Enum.Metric.MULT_ATK_6)
            UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_MAIN, DB.Enum.Metric.MULT_ATK_6)
            UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_OFFHAND, DB.Enum.Metric.MULT_ATK_6)
            if kick_damage > 0 then UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_KICK, DB.Enum.Metric.MULT_ATK_6) end
        end

        if DB.Tracking.Multi_Attack[player_name][DB.Enum.Metric.MULT_ATK_7] then
            multi_attack_found = true
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(DB.Enum.Metric.MULT_ATK_7)
            UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_MAIN, DB.Enum.Metric.MULT_ATK_7)
            UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_OFFHAND, DB.Enum.Metric.MULT_ATK_7)
            if kick_damage > 0 then UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_KICK, DB.Enum.Metric.MULT_ATK_7) end
        end

        if DB.Tracking.Multi_Attack[player_name][DB.Enum.Metric.MULT_ATK_8] then
            multi_attack_found = true
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(DB.Enum.Metric.MULT_ATK_8)
            UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_MAIN, DB.Enum.Metric.MULT_ATK_8)
            UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_OFFHAND, DB.Enum.Metric.MULT_ATK_8)
            if kick_damage > 0 then UI.TableNextColumn() Column.Proc.Multi_Attack(player_name, DB.Enum.Trackable.MELEE_KICK, DB.Enum.Metric.MULT_ATK_8) end
        end

        if not multi_attack_found then
            UI.TableNextRow()
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "None")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            if kick_damage > 0 then UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---") end
        end

        UI.EndTable()
    end
end