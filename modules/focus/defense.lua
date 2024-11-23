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
    Focus.Overview.Healing_Received(player_name)
    UI.Separator()

    Focus.Defense.Single(player_name, DB.Trackable.DEF_TP_MOVE)
    Focus.Defense.Single(player_name, DB.Trackable.DEF_NUKING)
    if Metrics.Focus.Show_Misc_Actions then Focus.Defense.Single(player_name, DB.Trackable.DEF_NO_DAMAGE_SPELLS) end
end

------------------------------------------------------------------------------------------------------
-- Shows damage taken breakdown.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Defense.Damage_Taken = function(player_name)
    local col_flags = Column.Flags.None
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local columns = 4
    local pet_dt = DB.Data.Get(player_name, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET, DB.Metric.TOTAL)
    if pet_dt > 0 then columns = 5 end

    local row = 1
    if UI.BeginTable("Damage Taken", columns, table_flags) then
        UI.TableSetupColumn("Damage Taken", col_flags, name_width)
        UI.TableSetupColumn("HP-", col_flags, width)
        UI.TableSetupColumn("%Player", col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        if pet_dt > 0 then UI.TableSetupColumn("Pet HP-", col_flags, width) end
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL)
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, true)
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        if pet_dt > 0 then UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET) end
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        UI.TableNextColumn() UI.Text("Melee")
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_MELEE)
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_MELEE, true)
        UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, DB.Trackable.DEF_UNMITIGATED)
        if pet_dt > 0 then UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_MELEE_PET) end
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        UI.TableNextColumn() UI.Text("Magic")
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_NUKING)
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_NUKING, true)
        UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, DB.Trackable.DEF_NUKING)
        if pet_dt > 0 then UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_NUKING_PET) end
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        UI.TableNextColumn() UI.Text("Mob TP")
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_TP_MOVE)
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_TP_MOVE, true)
        UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, DB.Trackable.DEF_TP_MOVE)
        if pet_dt > 0 then UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_TP_MOVE_PET) end
        Window_Manager.Table_Row_Color(row)
        row = row + 1

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
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local row = 1
    if UI.BeginTable("Other Damage", 5, table_flags) then
        UI.TableSetupColumn("Aux. Defense", col_flags, name_width)
        UI.TableSetupColumn("HP-", col_flags, width)
        UI.TableSetupColumn("%Player", col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("%Proc", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Crits")
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_CRITICAL)
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_CRITICAL, true)
        UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, DB.Trackable.DEF_CRITICAL)
        UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Trackable.DEF_CRITICAL)
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        local counter = DB.Data.Get(player_name, DB.Trackable.DEF_COUNTERED, DB.Metric.TOTAL)
        if counter > 0 then
            UI.TableNextColumn() UI.Text("Countered")
            UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_COUNTERED)
            UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_COUNTERED, true)
            UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, DB.Trackable.DEF_COUNTERED)
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Trackable.DEF_COUNTERED)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local spikes = DB.Data.Get(player_name, DB.Trackable.DEF_SPIKES, DB.Metric.TOTAL)
        if spikes > 0 then
            UI.TableNextColumn() UI.Text("Spikes")
            UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_SPIKES)
            UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_SPIKES, true)
            UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, DB.Trackable.DEF_SPIKES)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
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
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local row = 1
    if UI.BeginTable("Defense", 5, table_flags) then
        UI.TableSetupColumn("Mitigation", col_flags, name_width)
        UI.TableSetupColumn("~HP Saved", col_flags, width)
        UI.TableSetupColumn("%Proc", col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("%DT-", col_flags, width)
        UI.TableHeadersRow()

        local evade = DB.Data.Get(player_name, DB.Trackable.DEF_EVASION, DB.Metric.HIT_COUNT)
        if evade > 0 then
            UI.TableNextColumn() UI.Text("Evasion")
            UI.TableNextColumn() Column.Defense.Damage_Mitigation(player_name, DB.Trackable.DEF_EVASION)
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Trackable.DEF_EVASION)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local parry = DB.Data.Get(player_name, DB.Trackable.DEF_PARRY, DB.Metric.HIT_COUNT)
        if parry > 0 then
            UI.TableNextColumn() UI.Text("Parry")
            UI.TableNextColumn() Column.Defense.Damage_Mitigation(player_name, DB.Trackable.DEF_PARRY)
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Trackable.DEF_PARRY)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local shadows = DB.Data.Get(player_name, DB.Trackable.DEF_SHADOWS, DB.Metric.HIT_COUNT)
        if shadows > 0 then
            UI.TableNextColumn() UI.Text("Shadows")
            UI.TableNextColumn() Column.Defense.Damage_Mitigation(player_name, DB.Trackable.DEF_SHADOWS)
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Trackable.DEF_SHADOWS)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local third_eye = DB.Data.Get(player_name, DB.Trackable.DEF_THIRD_EYE_ANTICIPATION, DB.Metric.HIT_COUNT)
        if third_eye > 0 then
            UI.TableNextColumn() UI.Text("Third Eye")
            UI.TableNextColumn() Column.Defense.Damage_Mitigation(player_name, DB.Trackable.DEF_THIRD_EYE_ANTICIPATION)
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Trackable.DEF_THIRD_EYE_ANTICIPATION)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local counter = DB.Data.Get(player_name, DB.Trackable.MELEE_COUNTER, DB.Metric.HIT_COUNT)
        if counter > 0 then
            UI.TableNextColumn() UI.Text("Counter")
            UI.TableNextColumn() Column.Defense.Damage_Mitigation(player_name, DB.Trackable.MELEE_COUNTER)
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Trackable.MELEE_COUNTER)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local guard = DB.Data.Get(player_name, DB.Trackable.DEF_GUARD, DB.Metric.HIT_COUNT)
        if guard > 0 then
            UI.TableNextColumn() UI.Text("Guard")
            UI.TableNextColumn() Column.Defense.Damage_Mitigation(player_name, DB.Trackable.DEF_GUARD)
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Trackable.DEF_GUARD)
            UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, DB.Trackable.DEF_GUARD)
            UI.TableNextColumn() Column.Defense.Damage_Reduction(player_name, DB.Trackable.DEF_GUARD)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local shield = DB.Data.Get(player_name, DB.Trackable.DEF_SHIELD_BLOCK, DB.Metric.HIT_COUNT)
        if shield > 0 then
            UI.TableNextColumn() UI.Text("Shield Block")
            UI.TableNextColumn() Column.Defense.Damage_Mitigation(player_name, DB.Trackable.DEF_SHIELD_BLOCK)
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Trackable.DEF_SHIELD_BLOCK)
            UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, DB.Trackable.DEF_SHIELD_BLOCK)
            UI.TableNextColumn() Column.Defense.Damage_Reduction(player_name, DB.Trackable.DEF_SHIELD_BLOCK)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        if (evade + parry + shadows + counter + guard + shield) == 0 then
            UI.TableNextColumn() UI.Text("None Yet")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
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
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local col_flags = Column.Flags.None
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    -- Error Protection
    if not DB.Tracking.Trackable[focus_type] then return nil end
    if not DB.Tracking.Trackable[focus_type][player_name] then return nil end

    local action_string = "TP Move"
    if focus_type == DB.Trackable.DEF_NUKING or focus_type == DB.Trackable.DEF_NO_DAMAGE_SPELLS then
        action_string = "Spell"
    end

    if UI.BeginTable(focus_type, 6, table_flags) then
        UI.TableSetupColumn(action_string, col_flags, name_width)
        UI.TableSetupColumn("Tries", col_flags, width)
        UI.TableSetupColumn("Total", col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("Minimum", col_flags, width)
        UI.TableSetupColumn("Maximum", col_flags, width)
        UI.TableHeadersRow()

        DB.Lists.Sort.Catalog_Damage(player_name, focus_type)
        local action_name
        local row = 1
        for _, data in ipairs(DB.Sorted.Catalog_Damage) do
            action_name = data[1]
            Focus.Defense.Single_Row(player_name, action_name, focus_type)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
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
    UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, DB.Metric.TOTAL)

    UI.TableNextColumn() Column.Single.Average(player_name, action_name, focus_type)
    local min = DB.Catalog.Get(player_name, focus_type, action_name, DB.Metric.MIN)
    if min == 100000 then
        UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, DB.Enum.IGNORE)
    else
        UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, DB.Metric.MIN)
    end
    UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, DB.Metric.MAX)
end