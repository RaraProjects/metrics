Focus.Defense = {}

------------------------------------------------------------------------------------------------------
-- Loads data to the defense drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Defense.Display = function(player_name)
    Focus.Defense.Damage_Taken(player_name)
    Focus.Defense.Auxiliary(player_name)
    Focus.Defense.Mitigation(player_name)
    Focus.Defense.Healing_Received(player_name)
    UI.Separator()

    Focus.Defense.TP_Move(player_name, DB.Trackable.DEF_TP_MOVE)
    Focus.Defense.TP_Move(player_name, DB.Trackable.DEF_NUKING)
    if Metrics.Focus.Show_Misc_Actions then Focus.Defense.TP_Move(player_name, DB.Trackable.DEF_NO_DAMAGE_SPELLS) end
end

------------------------------------------------------------------------------------------------------
-- Shows damage taken breakdown.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param make_brief? boolean
------------------------------------------------------------------------------------------------------
Focus.Defense.Damage_Taken = function(player_name, make_brief)
    local col_flags   = Column.Flags.None
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local melee  = DB.Data.Get(player_name, DB.Trackable.DEF_MELEE,   DB.Metric.TOTAL)
    local ranged = DB.Data.Get(player_name, DB.Trackable.DEF_RANGED,  DB.Metric.TOTAL)
    local magic  = DB.Data.Get(player_name, DB.Trackable.DEF_NUKING,  DB.Metric.TOTAL)
    local tp     = DB.Data.Get(player_name, DB.Trackable.DEF_TP_MOVE, DB.Metric.TOTAL)
    local pet    = DB.Data.Get(player_name, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET, DB.Metric.TOTAL)

    local columns = 5
    if make_brief then columns = columns - 1 end
    if pet > 0 then columns = columns + 1 end

    local row = 1
    if UI.BeginTable("Damage Taken", columns, table_flags) then
        if make_brief then
            UI.TableSetupColumn("Damage Taken", col_flags, name_width)
            UI.TableSetupColumn("Average",      col_flags, width)
            UI.TableSetupColumn("%Party",       col_flags, width)
            UI.TableSetupColumn("HP-",          col_flags, width)
            if pet > 0 then UI.TableSetupColumn("Pet HP-", col_flags, width) end
        else
            UI.TableSetupColumn("Damage Taken", col_flags, name_width)
            UI.TableSetupColumn("Average",      col_flags, width)
            UI.TableSetupColumn("%Player",      col_flags, width)
            UI.TableSetupColumn("%Party",       col_flags, width)
            UI.TableSetupColumn("HP-",          col_flags, width)
            if pet > 0 then UI.TableSetupColumn("Pet HP-", col_flags, width) end
        end
        UI.TableHeadersRow()

        local defense_trackables = {
            [1] = {header = "Total",  trackable = DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, trackable_pet = DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET, damage = 1},
            [2] = {header = "- Melee",  trackable = DB.Trackable.DEF_MELEE,              trackable_pet = DB.Trackable.DEF_MELEE_PET,   damage = melee},
            [3] = {header = "- Ranged", trackable = DB.Trackable.DEF_RANGED,             trackable_pet = DB.Trackable.DEF_RANGED_PET,  damage = ranged},
            [4] = {header = "- Magic",  trackable = DB.Trackable.DEF_NUKING,             trackable_pet = DB.Trackable.DEF_NUKING_PET,  damage = magic},
            [5] = {header = "- Mob TP", trackable = DB.Trackable.DEF_TP_MOVE,            trackable_pet = DB.Trackable.DEF_TP_MOVE_PET, damage = tp},
        }

        for _, data in ipairs(defense_trackables) do
            if data.damage > 0 then
                UI.TableNextColumn() UI.Text(data.header)
                if make_brief then
                    UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, data.trackable)
                    UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, data.trackable)
                    UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, data.trackable)
                    if pet > 0 then UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, data.trackable_pet) end
                else
                    UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, data.trackable)
                    UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, data.trackable, true)
                    UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, data.trackable)
                    UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, data.trackable)
                    if pet > 0 then UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, data.trackable_pet) end
                end
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
Focus.Defense.Auxiliary = function(player_name)
    local col_flags   = Column.Flags.None
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local row = 1
    if UI.BeginTable("Defense Auxiliary", 5, table_flags) then
        UI.TableSetupColumn("Defense Auxiliary", col_flags, name_width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("%Player", col_flags, width)
        UI.TableSetupColumn("%Proc",   col_flags, width)
        UI.TableSetupColumn("HP-",     col_flags, width)
        UI.TableHeadersRow()

        local aux_trackables = {
            [1] = {header = "Crits",     trackable = DB.Trackable.DEF_CRITICAL,  threshold = 1},
            [2] = {header = "Countered", trackable = DB.Trackable.DEF_COUNTERED, threshold = DB.Data.Get(player_name, DB.Trackable.DEF_COUNTERED, DB.Metric.TOTAL)},
            [3] = {header = "Spikes",    trackable = DB.Trackable.DEF_SPIKES,    threshold = DB.Data.Get(player_name, DB.Trackable.DEF_SPIKES, DB.Metric.TOTAL)},
        }

        for _, data in ipairs(aux_trackables) do
            if data.threshold > 0 then
                UI.TableNextColumn() UI.Text(data.header)
                UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, data.trackable)
                UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, data.trackable, true)
                UI.TableNextColumn() Column.Acc.By_Type(player_name, data.trackable, 0)
                UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, data.trackable)
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
        UI.TableSetupColumn("%Proc",      col_flags, width)
        UI.TableSetupColumn("~HP Saved",  col_flags, width)
        UI.TableSetupColumn("~Damage",    col_flags, width)
        UI.TableSetupColumn("%DT-",       col_flags, width)
        UI.TableHeadersRow()

        -- Full Mitigation
        local full_mitigation_trackables = {}
        table.insert(full_mitigation_trackables, {header = "Evasion (Melee)",  trackable = DB.Trackable.DEF_EVASION_MELEE})
        table.insert(full_mitigation_trackables, {header = "Evasion (Ranged)", trackable = DB.Trackable.DEF_EVASION_RANGED})
        table.insert(full_mitigation_trackables, {header = "Evasion (TP)",     trackable = DB.Trackable.DEF_EVASION_TP_ACTION})
        table.insert(full_mitigation_trackables, {header = "Parry",            trackable = DB.Trackable.DEF_PARRY})
        table.insert(full_mitigation_trackables, {header = "Shadows (Melee)",  trackable = DB.Trackable.DEF_SHADOWS_MELEE})
        table.insert(full_mitigation_trackables, {header = "Shadows (Ranged)", trackable = DB.Trackable.DEF_SHADOWS_RANGED})
        table.insert(full_mitigation_trackables, {header = "Shadows (Magic)",  trackable = DB.Trackable.DEF_SHADOWS_MAGIC})
        table.insert(full_mitigation_trackables, {header = "Shadows (TP)",     trackable = DB.Trackable.DEF_SHADOWS_TP_ACTION})
        table.insert(full_mitigation_trackables, {header = "Third Eye",        trackable = DB.Trackable.DEF_THIRD_EYE_ANTICIPATION})
        table.insert(full_mitigation_trackables, {header = "Counter",          trackable = DB.Trackable.MELEE_COUNTER})

        local mitigation_found = false
        for _, data in ipairs(full_mitigation_trackables) do
            if DB.Data.Get(player_name, data.trackable, DB.Metric.HITS_ON_TARGET) > 0 then
                UI.TableNextColumn() UI.Text(data.header)
                UI.TableNextColumn() Column.Acc.By_Type(player_name, data.trackable, 0)
                UI.TableNextColumn() Column.Defense.Damage_Mitigation(player_name, data.trackable)
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
                UI.TableNextColumn() Column.Acc.By_Type(player_name, data.trackable, 0)
                UI.TableNextColumn() Column.Defense.Damage_Mitigation(player_name, data.trackable, data.ranged)
                UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, data.trackable)
                UI.TableNextColumn() Column.Defense.Damage_Reduction(player_name, data.trackable)
                Window_Manager.Table_Row_Color(row)
                row = row + 1
                mitigation_found = true
            end
        end

        -- No mitigation was found.
        -- A Total row doesn't work well with damage mitigation.
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
-- Shows healing received overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Defense.Healing_Received = function(player_name)
    if not player_name then return nil end

    -- Error Protection
    local trackable = DB.Trackable.DEF_HEALING_RECEIVED
    if not DB.Tracking.Trackable[trackable] then return nil end
    if not DB.Tracking.Trackable[trackable][player_name] then return nil end

    local col_flags   = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    if UI.BeginTable("Healing", 4, table_flags) then
        UI.TableSetupColumn("Healing Received", col_flags, name_width)
        UI.TableSetupColumn("HP+",     col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("MP-",     col_flags, width)
        UI.TableHeadersRow()

        local row = 1
        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.TOTAL)
        UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable)
        UI.TableNextColumn() Column.Spell.MP_Used(player_name, trackable)
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
        local action_name
        for _, data in ipairs(sorted_damage) do
            action_name = data[1]
            UI.TableNextColumn() UI.Text("- " .. action_name)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.TOTAL, action_name)
            UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable, nil, action_name)
            UI.TableNextColumn() Column.Spell.MP_Used_Catalog(player_name, trackable, action_name)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for a trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the data model.
------------------------------------------------------------------------------------------------------
Focus.Defense.TP_Move = function(player_name, trackable)
    if not trackable then return nil end
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local col_flags   = Column.Flags.None
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    -- Error Protection
    if not DB.Tracking.Trackable[trackable] then return nil end
    if not DB.Tracking.Trackable[trackable][player_name] then return nil end

    local action_string = "TP Move"
    local on_target = true
    if trackable == DB.Trackable.DEF_NUKING or trackable == DB.Trackable.DEF_NO_DAMAGE_SPELLS then
        action_string = "Spell"
        on_target = true
    end

    if UI.BeginTable(trackable, 6, table_flags) then
        UI.TableSetupColumn(action_string, col_flags, name_width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("Tries",   col_flags, width)
        UI.TableSetupColumn("Total",   col_flags, width)
        UI.TableSetupColumn("Minimum", col_flags, width)
        UI.TableSetupColumn("Maximum", col_flags, width)
        UI.TableHeadersRow()

        local row = 1
        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable)
        UI.TableNextColumn() Column.Damage.Attempts(player_name, trackable, nil, on_target)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.TOTAL)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MIN)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MAX)
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
        local action_name
        for _, data in ipairs(sorted_damage) do
            action_name = data[1]
            UI.TableNextColumn() UI.Text("- " .. action_name)
            UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable, nil, action_name)
            UI.TableNextColumn() Column.Damage.Attempts(player_name, trackable, action_name, on_target)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.TOTAL, action_name)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MIN, action_name)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MAX, action_name)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        UI.EndTable()
    end
end