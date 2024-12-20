Focus.Defense = {}

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
    local col_flags   = Column.Flags.None
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local columns = 5
    local pet_dt = DB.Data.Get(player_name, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET, DB.Metric.TOTAL)
    if pet_dt > 0 then columns = columns + 1 end

    local row = 1
    if UI.BeginTable("Damage Taken", columns, table_flags) then
        UI.TableSetupColumn("Damage Taken", col_flags, name_width)
        UI.TableSetupColumn("HP-",          col_flags, width)
        UI.TableSetupColumn("%Party",       col_flags, width)
        UI.TableSetupColumn("%Player",      col_flags, width)
        UI.TableSetupColumn("Average",      col_flags, width)
        if pet_dt > 0 then UI.TableSetupColumn("Pet HP-", col_flags, width) end
        UI.TableHeadersRow()

        local defense_trackables = {
            [1] = {header = "Total",  trackable = DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, trackable_pet = DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET},
            [2] = {header = "Melee",  trackable = DB.Trackable.DEF_MELEE,              trackable_pet = DB.Trackable.DEF_MELEE_PET},
            [3] = {header = "Ranged", trackable = DB.Trackable.DEF_RANGED,             trackable_pet = DB.Trackable.DEF_RANGED_PET},
            [4] = {header = "Magic",  trackable = DB.Trackable.DEF_NUKING,             trackable_pet = DB.Trackable.DEF_NUKING_PET},
            [5] = {header = "Mob TP", trackable = DB.Trackable.DEF_TP_MOVE,            trackable_pet = DB.Trackable.DEF_TP_MOVE_PET},
        }

        for _, data in ipairs(defense_trackables) do
            UI.TableNextColumn() UI.Text(data.header)
            UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, data.trackable)
            UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, data.trackable)
            UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, data.trackable, true)
            UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, data.trackable)
            if pet_dt > 0 then UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, data.trackable_pet) end
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
Focus.Defense.Other_Damage = function(player_name)
    local col_flags   = Column.Flags.None
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local row = 1
    if UI.BeginTable("Other Damage", 5, table_flags) then
        UI.TableSetupColumn("Aux. Defense", col_flags, name_width)
        UI.TableSetupColumn("HP-",          col_flags, width)
        UI.TableSetupColumn("%Player",      col_flags, width)
        UI.TableSetupColumn("Average",      col_flags, width)
        UI.TableSetupColumn("%Proc",        col_flags, width)
        UI.TableHeadersRow()

        local aux_trackables = {
            [1] = {header = "Crits",     trackable = DB.Trackable.DEF_CRITICAL,  threshold = 1},
            [2] = {header = "Countered", trackable = DB.Trackable.DEF_COUNTERED, threshold = DB.Data.Get(player_name, DB.Trackable.DEF_COUNTERED, DB.Metric.TOTAL)},
            [3] = {header = "Spikes",    trackable = DB.Trackable.DEF_SPIKES,    threshold = DB.Data.Get(player_name, DB.Trackable.DEF_SPIKES, DB.Metric.TOTAL)},
        }

        for _, data in ipairs(aux_trackables) do
            if data.threshold > 0 then
                UI.TableNextColumn() UI.Text(data.header)
                UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, data.trackable)
                UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, data.trackable, true)
                UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, data.trackable)
                UI.TableNextColumn() Column.Acc.By_Type(player_name, data.trackable, 0)
                Window_Manager.Table_Row_Color(row)
                row = row + 1
            end
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
    local col_flags   = Column.Flags.None
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local row = 1
    if UI.BeginTable("Defense", 5, table_flags) then
        UI.TableSetupColumn("Mitigation", col_flags, name_width)
        UI.TableSetupColumn("~HP Saved",  col_flags, width)
        UI.TableSetupColumn("%Proc",      col_flags, width)
        UI.TableSetupColumn("Average",    col_flags, width)
        UI.TableSetupColumn("%DT-",       col_flags, width)
        UI.TableHeadersRow()

        -- Full Mitigation
        local full_mitigation_trackables = {
            [1] = {header = "Evasion",   trackable = DB.Trackable.DEF_EVASION},
            [2] = {header = "Parry",     trackable = DB.Trackable.DEF_PARRY},
            [3] = {header = "Shadows",   trackable = DB.Trackable.DEF_SHADOWS},
            [4] = {header = "Third Eye", trackable = DB.Trackable.DEF_THIRD_EYE_ANTICIPATION},
            [5] = {header = "Counter",   trackable = DB.Trackable.MELEE_COUNTER},
        }

        local mitigation_found = false
        for _, data in ipairs(full_mitigation_trackables) do
            if DB.Data.Get(player_name, data.trackable, DB.Metric.HITS_ON_TARGET) > 0 then
                UI.TableNextColumn() UI.Text(data.header)
                UI.TableNextColumn() Column.Defense.Damage_Mitigation(player_name, data.trackable)
                UI.TableNextColumn() Column.Acc.By_Type(player_name, data.trackable, 0)
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                Window_Manager.Table_Row_Color(row)
                row = row + 1
                mitigation_found = true
            end
        end

        -- Partial Mitigation
        local partial_mitigation_trackables = {
            [1] = {header = "Guard",        trackable = DB.Trackable.DEF_GUARD},
            [2] = {header = "Shield Block", trackable = DB.Trackable.DEF_SHIELD_BLOCK},
        }

        for _, data in ipairs(partial_mitigation_trackables) do
            if DB.Data.Get(player_name, data.trackable, DB.Metric.HITS_ON_TARGET) > 0 then
                UI.TableNextColumn() UI.Text(data.header)
                UI.TableNextColumn() Column.Defense.Damage_Mitigation(player_name, data.trackable)
                UI.TableNextColumn() Column.Acc.By_Type(player_name, data.trackable, 0)
                UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, data.trackable)
                UI.TableNextColumn() Column.Defense.Damage_Reduction(player_name, data.trackable)
                Window_Manager.Table_Row_Color(row)
                row = row + 1
                mitigation_found = true
            end
        end

        -- No mitigation was found.
        if not mitigation_found then
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
    local col_flags   = Column.Flags.None
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    -- Error Protection
    if not DB.Tracking.Trackable[focus_type] then return nil end
    if not DB.Tracking.Trackable[focus_type][player_name] then return nil end

    local action_string = "TP Move"
    if focus_type == DB.Trackable.DEF_NUKING or focus_type == DB.Trackable.DEF_NO_DAMAGE_SPELLS then
        action_string = "Spell"
    end

    if UI.BeginTable(focus_type, 6, table_flags) then
        UI.TableSetupColumn(action_string, col_flags, name_width)
        UI.TableSetupColumn("Tries",   col_flags, width)
        UI.TableSetupColumn("Total",   col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("Minimum", col_flags, width)
        UI.TableSetupColumn("Maximum", col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, focus_type)
        local action_name
        local row = 1
        for _, data in ipairs(sorted_damage) do
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
---@param trackable string a trackable from the data model.
------------------------------------------------------------------------------------------------------
Focus.Defense.Single_Row = function(player_name, action_name, trackable)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(action_name)
    UI.TableNextColumn() Column.Damage.Attempts(player_name, trackable, action_name)
    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.TOTAL, action_name)

    UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable, action_name)
    local min = DB.Catalog.Get(player_name, trackable, action_name, DB.Metric.MIN)
    if min == 100000 then
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Enum.IGNORE, action_name)
    else
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MIN, action_name)
    end
    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MAX, action_name)
end