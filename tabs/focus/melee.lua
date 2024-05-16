Focus.Melee = T{}

------------------------------------------------------------------------------------------------------
-- Loads data to the melee drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Melee.Display = function(player_name)
    local col_flags = Column.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local name_width = Column.Widths.Standard
    local damage_width = Column.Widths.Damage
    local percent_width = Column.Widths.Percent

    local off_hand = DB.Data.Get(player_name, DB.Enum.Trackable.MELEE_OFFHAND, DB.Enum.Metric.TOTAL)
    local kick_damage = DB.Data.Get(player_name, DB.Enum.Trackable.MELEE_KICK, DB.Enum.Metric.TOTAL)
    local counter_damage = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_COUNTER, DB.Enum.Metric.TOTAL)

    if UI.BeginTable("Melee Primary", 5, table_flags) then
        UI.TableSetupColumn("Type", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Damage %", col_flags, damage_width)
        UI.TableSetupColumn("Accuracy", col_flags, damage_width)
        UI.TableSetupColumn("Rate", col_flags, percent_width)
        UI.TableHeadersRow()

        -- Total
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Melee Total")
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

        -- Critical Hits
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Crits")
        UI.TableNextColumn() Column.Proc.Crit_Damage(player_name, DB.Enum.Trackable.MELEE)
        UI.TableNextColumn() Column.Proc.Crit_Damage(player_name, DB.Enum.Trackable.MELEE, true)
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        UI.TableNextColumn() Column.Proc.Crit_Rate(player_name, DB.Enum.Trackable.MELEE)

        UI.EndTable()
    end

    local columns = 3
    if kick_damage > 0 then columns = 4 end
    if UI.BeginTable("Multi-Attack", columns, table_flags) then
        UI.TableSetupColumn("Multi-Rank", col_flags, name_width)
        UI.TableSetupColumn("Main-Hand", col_flags, damage_width)
        UI.TableSetupColumn("Off-Hand", col_flags, damage_width)
        if kick_damage > 0 then UI.TableSetupColumn("Kicks", col_flags, damage_width) end
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

    local mob_heal = DB.Data.Get(player_name, DB.Enum.Trackable.MELEE, DB.Enum.Metric.MOB_HEAL)
    local shadows  = DB.Data.Get(player_name, DB.Enum.Trackable.MELEE, DB.Enum.Metric.SHADOWS)
    local enspell  = DB.Data.Get(player_name, DB.Enum.Trackable.ENSPELL, DB.Enum.Metric.TOTAL)
    local endrain  = DB.Data.Get(player_name, DB.Enum.Trackable.ENDRAIN, DB.Enum.Metric.TOTAL)
    local enaspir  = DB.Data.Get(player_name, DB.Enum.Trackable.ENASPIR, DB.Enum.Metric.TOTAL)

    if mob_heal > 0 or shadows > 0 or enspell > 0 or endrain > 0 or enaspir > 0 then
        if UI.BeginTable("Melee Misc.", 2, table_flags) then
            UI.TableSetupColumn("Type", col_flags, name_width)
            UI.TableSetupColumn("Damage", col_flags, damage_width)
            UI.TableHeadersRow()

            if mob_heal > 0 then
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text("Mob Heal")
                UI.TableNextColumn() UI.Text(Column.String.Format_Number(mob_heal))
            end

            if shadows > 0 then
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text("Shadows")
                UI.TableNextColumn() UI.Text(Column.String.Format_Number(shadows))
            end

            if enspell > 0 then
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text("En-Spell")
                UI.TableNextColumn() UI.Text(Column.String.Format_Number(enspell))
            end

            if endrain > 0 then
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text("En-Drain")
                UI.TableNextColumn() UI.Text(Column.String.Format_Number(endrain))
            end

            if enaspir > 0 then
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text("En-Aspir")
                UI.TableNextColumn() UI.Text(Column.String.Format_Number(enaspir))
            end
            UI.EndTable()
        end
    end
end