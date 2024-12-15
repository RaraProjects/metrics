Focus.Pets = T{}

------------------------------------------------------------------------------------------------------
-- Loads data to the pet drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Pets.Display = function(player_name)
    local col_flags = Column.Flags.None
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local pet_total = DB.Data.Get(player_name, DB.Trackable.PET_OVERALL, DB.Metric.TOTAL)

    local row = 1
    if UI.BeginTable("Pets Melee", 4, table_flags) then
        UI.TableSetupColumn("Offense Type", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, width)
        UI.TableSetupColumn("%Player", col_flags, width)
        UI.TableSetupColumn("Accuracy", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_OVERALL)
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        local melee = DB.Data.Get(player_name, DB.Trackable.PET_MELEE_OVERALL, DB.Metric.TOTAL)
        if melee > 0 then
            UI.TableNextColumn() UI.Text("Melee")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_MELEE_OVERALL)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_MELEE_OVERALL, true)
            UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.PET_MELEE_DISCRETE)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local ranged = DB.Data.Get(player_name, DB.Trackable.PET_RANGED_OVERALL, DB.Metric.TOTAL)
        if ranged > 0 then
            UI.TableNextColumn() UI.Text("Ranged")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_RANGED_OVERALL)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_RANGED_OVERALL, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local nuke = DB.Data.Get(player_name, DB.Trackable.PET_NUKING, DB.Metric.TOTAL)
        if nuke > 0 then
            UI.TableNextColumn() UI.Text("Magic")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_NUKING)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_NUKING, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local healing = DB.Data.Get(player_name, DB.Trackable.PET_HEALING, DB.Metric.TOTAL)
        if healing > 0 then
            UI.TableNextColumn() UI.Text("Healing")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_HEALING)
            UI.TableNextColumn() Column.Damage.Healing_Player(player_name, nil, DB.Trackable.PET_HEALING)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local ws = DB.Data.Get(player_name, DB.Trackable.PET_TP, DB.Metric.TOTAL)
        if ws > 0 then
            UI.TableNextColumn() UI.Text("TP Move")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_TP)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_TP, true)
            UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.PET_TP)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        UI.EndTable()
    end

    Focus.Pets.Damage_Taken(player_name)

    if pet_total > 0 then
        if DB.Tracking.Initialized_Pets[player_name] then
            if UI.BeginTabBar("Pet Tabs", Window_Manager.Tabs.Flags) then
                for pet_name, _ in pairs(DB.Tracking.Initialized_Pets[player_name]) do
                    if UI.BeginTabItem(pet_name) then
                        Focus.Pets.Single(player_name, pet_name)
                        UI.EndTabItem()
                    end
                end
                UI.EndTabBar()
            end
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Shows damage taken breakdown.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Pets.Damage_Taken = function(player_name)
    local col_flags = Column.Flags.None
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local row = 1
    if UI.BeginTable("Pet Damage Taken", 2, table_flags) then
        UI.TableSetupColumn("Damage Taken", col_flags, name_width)
        UI.TableSetupColumn("Pet HP-", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET)
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        UI.TableNextColumn() UI.Text("Melee")
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_MELEE_PET)
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        UI.TableNextColumn() UI.Text("Magic")
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_NUKING_PET)
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        UI.TableNextColumn() UI.Text("Mob TP")
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_TP_MOVE_PET)
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for a pet trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string owner of the pet.
------------------------------------------------------------------------------------------------------
Focus.Pets.Single = function(player_name, pet_name)
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local col_flags = Column.Flags.None
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if not DB.Tracking.Initialized_Pets[player_name] then
        Debug.Error.Add(Debug.Error.ERROR, "Focus.Pets.Single", "Tried to loop through pets of unitialized player in the focus window.")
        return nil
    end

    local row = 1
    if UI.BeginTable(pet_name, 5, table_flags) then
        UI.TableSetupColumn("Damage Type", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, width)
        UI.TableSetupColumn("%Player", col_flags, width)
        UI.TableSetupColumn("%Pet", col_flags, width)
        UI.TableSetupColumn("Accuracy", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_OVERALL)
        UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_OVERALL, true, nil, true)
        UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_OVERALL, true)
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        local pet_melee = DB.Pet_Data.Get(player_name, pet_name, DB.Trackable.PET_MELEE_OVERALL, DB.Metric.TOTAL)
        if pet_melee > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Melee")
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_MELEE_OVERALL)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_MELEE_OVERALL, true, nil, true)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_MELEE_OVERALL, true)
            UI.TableNextColumn() Column.Acc.By_Type_Pet(player_name, pet_name, DB.Trackable.PET_MELEE_DISCRETE)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local pet_ranged = DB.Pet_Data.Get(player_name, pet_name, DB.Trackable.PET_RANGED_OVERALL, DB.Metric.TOTAL)
        if pet_ranged > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Ranged")
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_RANGED_OVERALL)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_RANGED_OVERALL, true, nil, true)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_RANGED_OVERALL, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local pet_ws = DB.Pet_Data.Get(player_name, pet_name, DB.Trackable.PET_TP, DB.Metric.TOTAL)
        if pet_ws > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("TP Move")
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_TP)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_TP, true, nil, true)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_TP, true)
            UI.TableNextColumn() Column.Acc.By_Type_Pet(player_name, pet_name, DB.Trackable.PET_TP)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local pet_magic = DB.Pet_Data.Get(player_name, pet_name, DB.Trackable.PET_NUKING, DB.Metric.TOTAL)
        if pet_magic > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Magic")
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_NUKING)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_NUKING, true, nil, true)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_NUKING, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local pet_healing = DB.Pet_Data.Get(player_name, pet_name, DB.Trackable.PET_HEALING, DB.Metric.TOTAL)
        if pet_healing > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Healing")
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_HEALING)
            UI.TableNextColumn() Column.Damage.Healing_Player(player_name, pet_name, DB.Trackable.PET_HEALING)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end
        UI.EndTable()
    end

    if UI.BeginTable(pet_name.." single", 8, table_flags) then
        UI.TableSetupColumn("Action Name", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, width)
        UI.TableSetupColumn("~TP", col_flags, width)
        UI.TableSetupColumn("Accuracy", col_flags, width)
        UI.TableSetupColumn("Attempts", col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("Minimum", col_flags, width)
        UI.TableSetupColumn("Maximum", col_flags, width)
        UI.TableHeadersRow()

        local has_data = false
        row = 1
        DB.Lists.Sort.Pet_Catalog_Damage(player_name, pet_name)
        for _, data in ipairs(DB.Sorted.Pet_Catalog_Damage) do
            has_data = true
            local action_name = data[1]
            local trackable = data[3]
            Focus.Pets.Single_Row(player_name, pet_name, action_name, trackable)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end
        if not has_data then
            Focus.Pets.Single_Blank_Row()
            Window_Manager.Table_Row_Color(row)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to a row for a pet trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param pet_name string
---@param action_name string
---@param trackable string a trackable from the data model.
------------------------------------------------------------------------------------------------------
Focus.Pets.Single_Row = function(player_name, pet_name, action_name, trackable)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(action_name)
    UI.TableNextColumn() Column.Single.Pet_Damage(player_name, pet_name, action_name, trackable, DB.Metric.TOTAL)
    UI.TableNextColumn() Column.Single.Average_Pet_TP(player_name, pet_name, trackable, action_name)
    UI.TableNextColumn() Column.Single.Pet_Acc(player_name, pet_name, action_name, trackable)
    UI.TableNextColumn() Column.Single.Pet_Attempts(player_name, pet_name, action_name, trackable)
    UI.TableNextColumn() Column.Single.Pet_Average(player_name, pet_name, action_name, trackable)

    local min = DB.Pet_Catalog.Get(player_name, pet_name, trackable, action_name, DB.Metric.MIN)
    if min == DB.Enum.MAX_DAMAGE then
        UI.TableNextColumn() Column.Single.Pet_Damage(player_name, pet_name, action_name, trackable, DB.Enum.IGNORE)
    else
        UI.TableNextColumn() Column.Single.Pet_Damage(player_name, pet_name, action_name, trackable, DB.Metric.MIN)
    end

    UI.TableNextColumn() Column.Single.Pet_Damage(player_name, pet_name, action_name, trackable, DB.Metric.MAX)
end

------------------------------------------------------------------------------------------------------
-- Creates a blank table row for when pets haven't done ability yet, but you can still see their data.
------------------------------------------------------------------------------------------------------
Focus.Pets.Single_Blank_Row = function()
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("None")
    UI.TableNextColumn() UI.Text("0")
    UI.TableNextColumn() UI.Text("0")
    UI.TableNextColumn() UI.Text("0")
    UI.TableNextColumn() UI.Text("0")
    UI.TableNextColumn() UI.Text("0")
    UI.TableNextColumn() UI.Text("0")
end