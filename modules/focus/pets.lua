Focus.Pets = {}

------------------------------------------------------------------------------------------------------
-- Loads data to the pet drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Pets.Display = function(player_name)
    Focus.Pets.Total(player_name)
    Focus.Pets.Damage_Taken(player_name)

    -- Pet specific subtabs.
    local pet_total   = DB.Data.Get(player_name, DB.Trackable.PET_OVERALL, DB.Metric.TOTAL)
    local pet_healing = DB.Data.Get(player_name, DB.Trackable.PET_HEALING, DB.Metric.TOTAL)
    if (pet_total <= 0 and pet_healing <= 0) or not DB.Tracking.InitializedPets[player_name] then return nil end

    if UI.BeginTabBar("Pet Tabs", Window_Manager.Tabs.Flags) then
        for pet_name, _ in pairs(DB.Tracking.InitializedPets[player_name]) do
            if UI.BeginTabItem(pet_name) then
                Focus.Pets.Pet_Sub_Tab(player_name, pet_name)
                UI.EndTabItem()
            end
        end
        UI.EndTabBar()
    end
end

------------------------------------------------------------------------------------------------------
-- Displays the breakdown of pet damage.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Pets.Total = function(player_name)
    local col_flags   = Column.Flags.None
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local name_width  = Column.Widths.Name
    local width        = Column.Widths.Standard

    local row = 1
    if UI.BeginTable("Pets Melee", 4, table_flags) then
        UI.TableSetupColumn("Pets Overall", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, width)
        UI.TableSetupColumn("%Player", col_flags, width)
        UI.TableSetupColumn("Accuracy", col_flags, width)
        UI.TableHeadersRow()

        local trackable = DB.Trackable.PET_OVERALL
        UI.TableNextColumn() UI.Text("Total Damage")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, nil, nil, true)
        UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable)
        Window_Manager.TableRowColor(row)
        row = row + 1

        local damage_types = {}
        table.insert(damage_types, {header = "Melee",   trackable = DB.Trackable.PET_MELEE_OVERALL})
        table.insert(damage_types, {header = "Ranged",  trackable = DB.Trackable.PET_RANGED_OVERALL})
        table.insert(damage_types, {header = "Magic",   trackable = DB.Trackable.PET_NUKING})
        table.insert(damage_types, {header = "TP Move", trackable = DB.Trackable.PET_TP})

        for _, data in ipairs(damage_types) do
            if DB.Data.Get(player_name, data.trackable, DB.Metric.TOTAL) > 0 then
                UI.TableNextColumn() UI.Text("- " .. data.header)
                UI.TableNextColumn() Column.Damage.By_Type(player_name, data.trackable)
                UI.TableNextColumn() Column.Damage.By_Type(player_name, data.trackable, nil, nil, true)
                UI.TableNextColumn() Column.Acc.By_Type(player_name, data.trackable)
                Window_Manager.TableRowColor(row)
                row = row + 1
            end
        end

        local healing = DB.Data.Get(player_name, DB.Trackable.PET_HEALING, DB.Metric.TOTAL)
        if healing > 0 then
            UI.TableNextColumn() UI.Text("Healing")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_HEALING)
            UI.TableNextColumn() Column.Damage.Healing_Player(player_name, nil, DB.Trackable.PET_HEALING)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.TableRowColor(row)
            row = row + 1
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows damage taken breakdown.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Pets.Damage_Taken = function(player_name)
    local col_flags   = Column.Flags.None
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local row = 1
    if UI.BeginTable("Pet Damage Taken", 2, table_flags) then
        UI.TableSetupColumn("Damage Taken", col_flags, name_width)
        UI.TableSetupColumn("Pet HP-", col_flags, width)
        UI.TableHeadersRow()

        local damage_types = {}
        table.insert(damage_types, {header = "Total Damage", trackable = DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET, damage = -1})
        table.insert(damage_types, {header = "- Melee",      trackable = DB.Trackable.DEF_MELEE_PET,              damage = 0})
        table.insert(damage_types, {header = "- Magic",      trackable = DB.Trackable.DEF_NUKING_PET,             damage = 0})
        table.insert(damage_types, {header = "- TP Move",    trackable = DB.Trackable.DEF_TP_MOVE_PET,            damage = 0})

        for _, data in ipairs(damage_types) do
            if DB.Data.Get(player_name, data.trackable, DB.Metric.TOTAL) > data.damage then
                UI.TableNextColumn() UI.Text(data.header)
                UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, data.trackable)
                Window_Manager.TableRowColor(row)
                row = row + 1
            end
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for a pet trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string owner of the pet.
---@param pet_name string
------------------------------------------------------------------------------------------------------
Focus.Pets.Pet_Sub_Tab = function(player_name, pet_name)
    if not DB.Tracking.InitializedPets[player_name] then
        Debug.Error.Add(Debug.Error.ERROR, "Focus.Pets.Single", "Tried to loop through pets of unitialized player in the focus window.")
        return nil
    end

    Focus.Pets.Pet_Specific_Total(player_name, pet_name)
    Focus.Pets.Pet_Specific_TP_Moves(player_name, pet_name, DB.Trackable.PET_TP, "TP Move")

    local trackable = DB.Trackable.PET_NUKING
    local nuking = DB.PetData.Get(player_name, pet_name, trackable, DB.Metric.TOTAL) > 0
    if nuking then Focus.Pets.Pet_Specific_TP_Moves(player_name, pet_name, trackable, "Nuking") end

    trackable = DB.Trackable.PET_ENFEEBLING
    local enfeeble = DB.PetData.Get(player_name, pet_name, trackable, DB.Metric.HITS_ON_USE) > 0
    if enfeeble then Focus.Pets.Pet_Specific_Non_Damaging_Spells(player_name, pet_name, trackable, "Enfeebling") end

    trackable = DB.Trackable.PET_HEALING
    local healing = DB.PetData.Get(player_name, pet_name, trackable, DB.Metric.TOTAL) > 0
    if healing then Focus.Pets.Pet_Specific_TP_Moves(player_name, pet_name, trackable, "Healing") end

    trackable = DB.Trackable.PET_SPELL_BUFFS
    local buffs = DB.PetData.Get(player_name, pet_name, trackable, DB.Metric.HITS_ON_USE) > 0
    if buffs then Focus.Pets.Pet_Specific_Non_Damaging_Spells(player_name, pet_name, trackable, "Buffs", true) end
end

------------------------------------------------------------------------------------------------------
-- Breaks down individual pet damage.
------------------------------------------------------------------------------------------------------
---@param player_name string owner of the pet.
---@param pet_name string
------------------------------------------------------------------------------------------------------
Focus.Pets.Pet_Specific_Total = function(player_name, pet_name)
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local col_flags   = Column.Flags.None
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local row = 1
    if UI.BeginTable(pet_name, 5, table_flags) then
        UI.TableSetupColumn("Damage Type", col_flags, name_width)
        UI.TableSetupColumn("Damage",      col_flags, width)
        UI.TableSetupColumn("%Player",     col_flags, width)
        UI.TableSetupColumn("%Pet",        col_flags, width)
        UI.TableSetupColumn("Accuracy",    col_flags, width)
        UI.TableHeadersRow()

        local trackable = DB.Trackable.PET_OVERALL
        UI.TableNextColumn() UI.Text("Total Damage")
        UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, trackable)
        UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, trackable, true, nil, true)
        UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, trackable, true)
        UI.TableNextColumn() Column.Acc.By_Type_Pet(player_name, pet_name, trackable)
        Window_Manager.TableRowColor(row)
        row = row + 1

        local damage_types = {}
        table.insert(damage_types, {header = "Melee",   trackable = DB.Trackable.PET_MELEE_OVERALL})
        table.insert(damage_types, {header = "Ranged",  trackable = DB.Trackable.PET_RANGED_OVERALL})
        table.insert(damage_types, {header = "Magic",   trackable = DB.Trackable.PET_NUKING})
        table.insert(damage_types, {header = "TP Move", trackable = DB.Trackable.PET_TP})

        for _, data in ipairs(damage_types) do
            if DB.PetData.Get(player_name, pet_name, data.trackable, DB.Metric.TOTAL) > 0 then
                UI.TableNextColumn() UI.Text("- " .. data.header)
                UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, data.trackable)
                UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, data.trackable, true, nil, true)
                UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, data.trackable, true)
                UI.TableNextColumn() Column.Acc.By_Type_Pet(player_name, pet_name, data.trackable)
                Window_Manager.TableRowColor(row)
                row = row + 1
            end
        end

        local pet_healing = DB.PetData.Get(player_name, pet_name, DB.Trackable.PET_HEALING, DB.Metric.TOTAL)
        if pet_healing > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Healing")
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_HEALING)
            UI.TableNextColumn() Column.Damage.Healing_Player(player_name, pet_name, DB.Trackable.PET_HEALING)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.TableRowColor(row)
            row = row + 1
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Lists out specific pet's TP moves.
------------------------------------------------------------------------------------------------------
---@param player_name string owner of the pet.
---@param pet_name string
---@param trackable string
---@param header string
------------------------------------------------------------------------------------------------------
Focus.Pets.Pet_Specific_TP_Moves = function(player_name, pet_name, trackable, header)
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local col_flags   = Column.Flags.None
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    if not trackable then trackable = DB.Trackable.PET_TP end
    local damage_string = "Damage"
    if trackable == DB.Trackable.PET_HEALING then damage_string = "HP+" end

    if UI.BeginTable(pet_name.." single", 8, table_flags) then
        UI.TableSetupColumn(tostring(header), col_flags, name_width)
        UI.TableSetupColumn("Average",     col_flags, width)
        UI.TableSetupColumn("Accuracy",    col_flags, width)
        UI.TableSetupColumn("Attempts",    col_flags, width)
        UI.TableSetupColumn("~TP",         col_flags, width)
        UI.TableSetupColumn(damage_string, col_flags, width)
        UI.TableSetupColumn("Minimum",     col_flags, width)
        UI.TableSetupColumn("Maximum",     col_flags, width)
        UI.TableHeadersRow()

        local row = 1
        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.Pet_Average(player_name, pet_name, trackable)
        UI.TableNextColumn() Column.Acc.By_Type_Pet(player_name, pet_name, trackable)
        UI.TableNextColumn() Column.Damage.Pet_Attempts(player_name, pet_name, trackable)
        UI.TableNextColumn() Column.Damage.Average_Pet_TP(player_name, pet_name, trackable)
        UI.TableNextColumn() Column.Damage.By_Type_Pet(player_name, pet_name, trackable)
        UI.TableNextColumn() Column.Damage.By_Type_Pet(player_name, pet_name, trackable, DB.Metric.MIN)
        UI.TableNextColumn() Column.Damage.By_Type_Pet(player_name, pet_name, trackable, DB.Metric.MAX)
        Window_Manager.TableRowColor(row)
        row = row + 1

        local sortedDamage = DB.Lists.GetSortedPetCatalogDamage(player_name, pet_name)
        for _, data in ipairs(sortedDamage) do
            local action_name = data[1]
            local action_trackable = data[3]
            if trackable == action_trackable then
                UI.TableNextColumn() UI.Text("- " .. action_name)
                UI.TableNextColumn() Column.Damage.Pet_Average(player_name, pet_name, action_trackable, action_name)
                UI.TableNextColumn() Column.Acc.By_Type_Pet(player_name, pet_name, action_trackable, action_name)
                UI.TableNextColumn() Column.Damage.Pet_Attempts(player_name, pet_name, action_trackable, action_name)
                UI.TableNextColumn() Column.Damage.Average_Pet_TP(player_name, pet_name, action_trackable, action_name)
                UI.TableNextColumn() Column.Damage.By_Type_Pet(player_name, pet_name, action_trackable, nil, action_name)
                UI.TableNextColumn() Column.Damage.By_Type_Pet(player_name, pet_name, action_trackable, DB.Metric.MIN, action_name)
                UI.TableNextColumn() Column.Damage.By_Type_Pet(player_name, pet_name, action_trackable, DB.Metric.MAX, action_name)
                Window_Manager.TableRowColor(row)
                row = row + 1
            end
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Lists out specific pet's TP moves.
------------------------------------------------------------------------------------------------------
---@param player_name string owner of the pet.
---@param pet_name string
---@param trackable string
---@param header string
---@param is_buff? boolean
------------------------------------------------------------------------------------------------------
Focus.Pets.Pet_Specific_Non_Damaging_Spells = function(player_name, pet_name, trackable, header, is_buff)
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local col_flags   = Column.Flags.None
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    if not trackable then trackable = DB.Trackable.PET_ENFEEBLING end

    local columns = 4
    if is_buff then columns = 2 end

    if UI.BeginTable(pet_name.." single", columns, table_flags) then
        UI.TableSetupColumn(tostring(header), col_flags, name_width)
        if not is_buff then UI.TableSetupColumn("Average",  col_flags, width) end
        if not is_buff then UI.TableSetupColumn("Accuracy", col_flags, width) end
        UI.TableSetupColumn("Attempts",    col_flags, width)
        UI.TableHeadersRow()

        local row = 1
        UI.TableNextColumn() UI.Text("Total")
        if not is_buff then UI.TableNextColumn() Column.Damage.Pet_Average(player_name, pet_name, trackable) end
        if not is_buff then UI.TableNextColumn() Column.Acc.By_Type_Pet(player_name, pet_name, trackable) end
        UI.TableNextColumn() Column.Damage.Pet_Attempts(player_name, pet_name, trackable)
        Window_Manager.TableRowColor(row)
        row = row + 1

        local sortedDamage = DB.Lists.GetSortedPetCatalogDamage(player_name, pet_name)
        for _, data in ipairs(sortedDamage) do
            local action_name = data[1]
            local action_trackable = data[3]
            if trackable == action_trackable then
                UI.TableNextColumn() UI.Text("- " .. action_name)
                if not is_buff then UI.TableNextColumn() Column.Damage.Pet_Average(player_name, pet_name, action_trackable, action_name) end
                if not is_buff then UI.TableNextColumn() Column.Acc.By_Type_Pet(player_name, pet_name, action_trackable, action_name) end
                UI.TableNextColumn() Column.Damage.Pet_Attempts(player_name, pet_name, action_trackable, action_name)
                Window_Manager.TableRowColor(row)
                row = row + 1
            end
        end

        UI.EndTable()
    end
end