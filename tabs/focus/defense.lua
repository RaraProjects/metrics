Focus.Defense = T{}

------------------------------------------------------------------------------------------------------
-- Loads data to the defense drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Defense.Display = function(player_name)
    local col_flags = Column.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local name_width = Column.Widths.Standard
    local damage_width = Column.Widths.Damage

    if UI.BeginTable("Damage Taken", 3, table_flags) then
        UI.TableSetupColumn("Damage Taken", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Damage %", col_flags, damage_width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL)
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")

        UI.TableNextColumn() UI.Text("Melee")
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.MELEE_DMG_TAKEN)
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.MELEE_DMG_TAKEN, true)

        UI.TableNextColumn() UI.Text("Magic")
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.SPELL_DMG_TAKEN)
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.SPELL_DMG_TAKEN, true)

        UI.TableNextColumn() UI.Text("Mob TP")
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.TP_DMG_TAKEN)
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.TP_DMG_TAKEN, true)

        UI.EndTable()
    end

    if UI.BeginTable("Other Damage", 3, table_flags) then
        UI.TableSetupColumn("Misc. Defense", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Damage %", col_flags, damage_width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Crits")
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.DEF_CRIT)
        UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_CRIT)

        local pet = DB.Data.Get(player_name, DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET, DB.Enum.Metric.TOTAL)
        if pet > 0 then
            UI.TableNextColumn() UI.Text("Pet")
            UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        local spikes = DB.Data.Get(player_name, DB.Enum.Trackable.INCOMING_SPIKE_DMG, DB.Enum.Metric.TOTAL)
        if spikes > 0 then
            UI.TableNextColumn() UI.Text("Spikes")
            UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.INCOMING_SPIKE_DMG)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end

    local columns = 3
    if Metrics.Focus.Show_Mitigation_Details then columns = 5 end

    if UI.BeginTable("Defense", columns, table_flags) then
        UI.TableSetupColumn("Mitigation", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Rate (%)", col_flags, damage_width)
        if Metrics.Focus.Show_Mitigation_Details then
            UI.TableSetupColumn("Procs", col_flags, damage_width)
            UI.TableSetupColumn("Chances", col_flags, damage_width)
        end
        UI.TableHeadersRow()

        local evade = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_EVASION, DB.Enum.Metric.HIT_COUNT)
        if evade > 0 then
            UI.TableNextColumn() UI.Text("Evasion")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_EVASION)
            if Metrics.Focus.Show_Mitigation_Details then
                UI.TableNextColumn() Column.Defense.Proc_Count(player_name, DB.Enum.Trackable.DEF_EVASION)
                UI.TableNextColumn() Column.Defense.Total_Count(player_name, DB.Enum.Trackable.DEF_EVASION)
            end
        end

        local parry = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_PARRY, DB.Enum.Metric.HIT_COUNT)
        if parry > 0 then
            UI.TableNextColumn() UI.Text("Parry")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_PARRY)
            if Metrics.Focus.Show_Mitigation_Details then
                UI.TableNextColumn() Column.Defense.Proc_Count(player_name, DB.Enum.Trackable.DEF_PARRY)
                UI.TableNextColumn() Column.Defense.Total_Count(player_name, DB.Enum.Trackable.DEF_PARRY)
            end
        end

        local shadows = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_SHADOWS, DB.Enum.Metric.HIT_COUNT)
        if shadows > 0 then
            UI.TableNextColumn() UI.Text("Shadows")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_SHADOWS)
            if Metrics.Focus.Show_Mitigation_Details then
                UI.TableNextColumn() Column.Defense.Proc_Count(player_name, DB.Enum.Trackable.DEF_SHADOWS)
                UI.TableNextColumn() Column.Defense.Total_Count(player_name, DB.Enum.Trackable.DEF_SHADOWS)
            end
        end

        local counter = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_COUNTER, DB.Enum.Metric.HIT_COUNT)
        if counter > 0 then
            UI.TableNextColumn() UI.Text("Counter")
            UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.DEF_COUNTER)
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_COUNTER)
            if Metrics.Focus.Show_Mitigation_Details then
                UI.TableNextColumn() Column.Defense.Proc_Count(player_name, DB.Enum.Trackable.DEF_COUNTER)
                UI.TableNextColumn() Column.Defense.Total_Count(player_name, DB.Enum.Trackable.DEF_COUNTER)
            end
        end

        local guard = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_GUARD, DB.Enum.Metric.HIT_COUNT)
        if guard > 0 then
            UI.TableNextColumn() UI.Text("Guard")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_GUARD)
            if Metrics.Focus.Show_Mitigation_Details then
                UI.TableNextColumn() Column.Defense.Proc_Count(player_name, DB.Enum.Trackable.DEF_GUARD)
                UI.TableNextColumn() Column.Defense.Total_Count(player_name, DB.Enum.Trackable.DEF_GUARD)
            end
        end

        local shield = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_BLOCK, DB.Enum.Metric.HIT_COUNT)
        if shield > 0 then
            UI.TableNextColumn() UI.Text("Shield Block")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_BLOCK)
            if Metrics.Focus.Show_Mitigation_Details then
                UI.TableNextColumn() Column.Defense.Proc_Count(player_name, DB.Enum.Trackable.DEF_BLOCK)
                UI.TableNextColumn() Column.Defense.Total_Count(player_name, DB.Enum.Trackable.DEF_BLOCK)
            end
        end

        if (evade + parry + shadows + counter + guard + shield) == 0 then
            UI.TableNextColumn() UI.Text("None Yet")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            if Metrics.Focus.Show_Mitigation_Details then
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            end
        end

        UI.EndTable()
    end
end