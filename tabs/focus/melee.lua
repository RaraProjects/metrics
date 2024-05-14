Focus.Melee = T{}

------------------------------------------------------------------------------------------------------
-- Loads data to the melee drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Melee.Display = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local name_width = Window.Columns.Widths.Standard
    local damage_width = Window.Columns.Widths.Damage
    local percent_width = Window.Columns.Widths.Percent

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
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE, true)
        UI.TableNextColumn() Col.Acc.By_Type(player_name, DB.Enum.Trackable.MELEE)
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")

        -- Main-Hand
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Main-Hand")
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE_MAIN)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE_MAIN, true)
        UI.TableNextColumn() Col.Acc.By_Type(player_name, DB.Enum.Trackable.MELEE_MAIN)
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")

        -- Off-Hand
        if off_hand > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Off-Hand")
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE_OFFHAND)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE_OFFHAND, true)
            UI.TableNextColumn() Col.Acc.By_Type(player_name, DB.Enum.Trackable.MELEE_OFFHAND)
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        end

        -- Kick Attacks
        if kick_damage > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Kick Attacks")
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE_KICK)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE_KICK, true)
            UI.TableNextColumn() Col.Acc.By_Type(player_name, DB.Enum.Trackable.MELEE_KICK)
            UI.TableNextColumn() Col.Kick.Rate(player_name)
        end

        -- Counter
        if counter_damage > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Counter")
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.DEF_COUNTER)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.DEF_COUNTER, true)
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() Col.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_COUNTER)
        end

        -- Critical Hits
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Crits")
        UI.TableNextColumn() Col.Crit.Damage(player_name, DB.Enum.Trackable.MELEE)
        UI.TableNextColumn() Col.Crit.Damage(player_name, DB.Enum.Trackable.MELEE, true)
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        UI.TableNextColumn() Col.Crit.Rate(player_name, DB.Enum.Trackable.MELEE)

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
                UI.TableNextColumn() UI.Text(Col.String.Format_Number(mob_heal))
            end

            if shadows > 0 then
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text("Shadows")
                UI.TableNextColumn() UI.Text(Col.String.Format_Number(shadows))
            end

            if enspell > 0 then
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text("En-Spell")
                UI.TableNextColumn() UI.Text(Col.String.Format_Number(enspell))
            end

            if endrain > 0 then
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text("En-Drain")
                UI.TableNextColumn() UI.Text(Col.String.Format_Number(endrain))
            end

            if enaspir > 0 then
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text("En-Aspir")
                UI.TableNextColumn() UI.Text(Col.String.Format_Number(enaspir))
            end
            UI.EndTable()
        end
    end
end