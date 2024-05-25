Focus.Defense = T{}

------------------------------------------------------------------------------------------------------
-- Loads data to the defense drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Defense.Display = function(player_name)
    Focus.Defense.Damage_Taken(player_name)
    Focus.Defense.Other_Damage(player_name)
    Focus.Defense.Mitigation(player_name)
    Focus.Defense.Single(player_name, DB.Enum.Trackable.TP_DMG_TAKEN)
    Focus.Defense.Single(player_name, DB.Enum.Trackable.SPELL_DMG_TAKEN)
    if Metrics.Focus.Show_Misc_Actions then Focus.Defense.Single(player_name, DB.Enum.Trackable.DEF_NO_DMG_SPELLS) end
end

------------------------------------------------------------------------------------------------------
-- Shows damage taken breakdown.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Defense.Damage_Taken = function(player_name)
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
end

------------------------------------------------------------------------------------------------------
-- Shows miscellaneous damage breakdown.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Defense.Other_Damage = function(player_name)
    local col_flags = Column.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local name_width = Column.Widths.Standard
    local damage_width = Column.Widths.Damage

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
end

------------------------------------------------------------------------------------------------------
-- Shows miscellaneous damage breakdown.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Defense.Mitigation = function(player_name)
    local col_flags = Column.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local name_width = Column.Widths.Standard
    local damage_width = Column.Widths.Damage

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

------------------------------------------------------------------------------------------------------
-- Sets up the table for a trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param focus_type string a trackable from the data model.
------------------------------------------------------------------------------------------------------
Focus.Defense.Single = function(player_name, focus_type)
    if not focus_type then return nil end
    local table_flags = Window.Table.Flags.Fixed_Borders
    local col_flags = Column.Flags.None
    local name_width = Column.Widths.Standard
    local short_width = Column.Widths.Percent
    local damage_width = Column.Widths.Damage

    -- Error Protection
    if not DB.Tracking.Trackable[focus_type] then return nil end
    if not DB.Tracking.Trackable[focus_type][player_name] then return nil end

    local action_string = "TP Move"
    if focus_type == DB.Enum.Trackable.SPELL_DMG_TAKEN or focus_type == DB.Enum.Trackable.DEF_NO_DMG_SPELLS then
        action_string = "Spell"
    end

    if UI.BeginTable(focus_type, 6, table_flags) then
        UI.TableSetupColumn(action_string, col_flags, name_width)
        UI.TableSetupColumn("Tries", col_flags, short_width)
        UI.TableSetupColumn("Total", col_flags, damage_width)
        UI.TableSetupColumn("Average", col_flags, damage_width)
        UI.TableSetupColumn("Minimum", col_flags, damage_width)
        UI.TableSetupColumn("Maximum", col_flags, damage_width)
        UI.TableHeadersRow()

        DB.Lists.Sort.Catalog_Damage(player_name, focus_type)
        local action_name
        for _, data in ipairs(DB.Sorted.Catalog_Damage) do
            action_name = data[1]
            Focus.Defense.Single_Row(player_name, action_name, focus_type)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to a row for a trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param focus_type string a trackable from the data model.
------------------------------------------------------------------------------------------------------
Focus.Defense.Single_Row = function(player_name, action_name, focus_type)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(action_name)
    UI.TableNextColumn() Column.Single.Attempts(player_name, action_name, focus_type)
    UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.TOTAL)

    UI.TableNextColumn() Column.Single.Average(player_name, action_name, focus_type)
    local min = DB.Catalog.Get(player_name, focus_type, action_name, DB.Enum.Metric.MIN)
    if min == 100000 then
        UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, DB.Enum.Values.IGNORE)
    else
        UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.MIN)
    end
    UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.MAX)
end