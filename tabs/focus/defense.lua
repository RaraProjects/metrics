Focus.Defense = T{}

------------------------------------------------------------------------------------------------------
-- Loads data to the defense drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Defense.Display = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local name_width = Window.Columns.Widths.Standard
    local damage_width = Window.Columns.Widths.Damage

    if UI.BeginTable("Damage Taken", 3, table_flags) then
        UI.TableSetupColumn("Damage Taken", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Damage %", col_flags, damage_width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL)
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")

        UI.TableNextColumn() UI.Text("Melee")
        UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.MELEE_DMG_TAKEN)
        UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.MELEE_DMG_TAKEN, true)

        UI.TableNextColumn() UI.Text("Magic")
        UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.SPELL_DMG_TAKEN)
        UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.SPELL_DMG_TAKEN, true)

        UI.TableNextColumn() UI.Text("Mob TP")
        UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.TP_DMG_TAKEN)
        UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.TP_DMG_TAKEN, true)

        UI.EndTable()
    end

    if UI.BeginTable("Other Damage", 3, table_flags) then
        UI.TableSetupColumn("Misc. Defense", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Damage %", col_flags, damage_width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Crits")
        UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.DEF_CRIT)
        UI.TableNextColumn() Col.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_CRIT)

        local pet = DB.Data.Get(player_name, DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET, DB.Enum.Metric.TOTAL)
        if pet > 0 then
            UI.TableNextColumn() UI.Text("Pet")
            UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET)
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        end

        local spikes = DB.Data.Get(player_name, DB.Enum.Trackable.INCOMING_SPIKE_DMG, DB.Enum.Metric.TOTAL)
        if spikes > 0 then
            UI.TableNextColumn() UI.Text("Spikes")
            UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.INCOMING_SPIKE_DMG)
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        end

        UI.EndTable()
    end

    if UI.BeginTable("Defense", 3, table_flags) then
        UI.TableSetupColumn("Mitigation", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Rate (%)", col_flags, damage_width)
        UI.TableHeadersRow()

        local evade = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_EVASION, DB.Enum.Metric.HIT_COUNT)
        if evade > 0 then
            UI.TableNextColumn() UI.Text("Evasion")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() Col.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_EVASION)
        end

        local parry = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_PARRY, DB.Enum.Metric.HIT_COUNT)
        if parry > 0 then
            UI.TableNextColumn() UI.Text("Parry")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() Col.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_PARRY)
        end

        local shadows = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_SHADOWS, DB.Enum.Metric.HIT_COUNT)
        if shadows > 0 then
            UI.TableNextColumn() UI.Text("Shadows")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() Col.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_SHADOWS)
        end

        local counter = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_COUNTER, DB.Enum.Metric.HIT_COUNT)
        if counter > 0 then
            UI.TableNextColumn() UI.Text("Counter")
            UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.DEF_COUNTER)
            UI.TableNextColumn() Col.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_COUNTER)
        end

        local guard = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_GUARD, DB.Enum.Metric.HIT_COUNT)
        if guard > 0 then
            UI.TableNextColumn() UI.Text("Guard")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() Col.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_GUARD)
        end

        local shield = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_BLOCK, DB.Enum.Metric.HIT_COUNT)
        if shield > 0 then
            UI.TableNextColumn() UI.Text("Shield Block")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() Col.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_BLOCK)
        end

        if (evade + parry + shadows + counter + guard + shield) == 0 then
            UI.TableNextColumn() UI.Text("None Yet")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        end

        UI.EndTable()
    end
end