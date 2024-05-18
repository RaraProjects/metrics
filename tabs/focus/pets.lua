Focus.Pets = T{}

------------------------------------------------------------------------------------------------------
-- Loads data to the pet drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Pets.Display = function(player_name)
    local col_flags = Column.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local name_width = Column.Widths.Standard
    local damage_width = Column.Widths.Damage

    local pet_total = DB.Data.Get(player_name, DB.Enum.Trackable.PET, DB.Enum.Metric.TOTAL)

    if UI.BeginTable("Pets Melee", 4, table_flags) then
        UI.TableSetupColumn("Type", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Damage %", col_flags, damage_width)
        UI.TableSetupColumn("Accuracy", col_flags, damage_width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET)
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")

        local melee = DB.Data.Get(player_name, DB.Enum.Trackable.PET_MELEE, DB.Enum.Metric.TOTAL)
        if melee > 0 then
            UI.TableNextColumn() UI.Text("Melee")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_MELEE)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_MELEE, true)
            UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Enum.Trackable.PET_MELEE_DISCRETE)
        end

        local ranged = DB.Data.Get(player_name, DB.Enum.Trackable.PET_RANGED, DB.Enum.Metric.TOTAL)
        if ranged > 0 then
            UI.TableNextColumn() UI.Text("Ranged")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_RANGED)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_RANGED, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        local nuke = DB.Data.Get(player_name, DB.Enum.Trackable.PET_NUKE, DB.Enum.Metric.TOTAL)
        if nuke > 0 then
            UI.TableNextColumn() UI.Text("Magic")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_NUKE)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_NUKE, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        local healing = DB.Data.Get(player_name, DB.Enum.Trackable.PET_HEAL, DB.Enum.Metric.TOTAL)
        if healing > 0 then
            UI.TableNextColumn() UI.Text("Healing")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_HEAL)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_HEAL, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        local ws = DB.Data.Get(player_name, DB.Enum.Trackable.PET_WS, DB.Enum.Metric.TOTAL)
        if ws > 0 then
            UI.TableNextColumn() UI.Text("Weaponskill")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_WS)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_WS, true)
            UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Enum.Trackable.PET_WS)
        end

        local ability = DB.Data.Get(player_name, DB.Enum.Trackable.PET_ABILITY, DB.Enum.Metric.TOTAL)
        if ability > 0 then
            UI.TableNextColumn() UI.Text("Ability")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_ABILITY)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_ABILITY, true)
            UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Enum.Trackable.PET_ABILITY)
        end

        UI.EndTable()
    end

    if pet_total > 0 then
        if UI.BeginTabBar("Pet Tabs", Window.Tabs.Flags) then
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

------------------------------------------------------------------------------------------------------
-- Sets up the table for a pet trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string owner of the pet.
------------------------------------------------------------------------------------------------------
Focus.Pets.Single = function(player_name, pet_name)
    local table_flags = Window.Table.Flags.Fixed_Borders
    local col_flags = Column.Flags.None
    local name_width = Column.Widths.Standard
    local damage_width = Column.Widths.Damage
    local percent_width = Column.Widths.Percent

    if not DB.Tracking.Initialized_Pets[player_name] then
        _Debug.Error.Add("Display.Pet_Single_Data: Tried to loop through pets of unitialized player in the focus window.")
        return nil
    end

    if UI.BeginTable(pet_name, 5, table_flags) then
        UI.TableSetupColumn("Type", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Damage %", col_flags, percent_width)
        UI.TableSetupColumn("Pet %", col_flags, percent_width)
        UI.TableSetupColumn("Accuracy", col_flags, percent_width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET)
        UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET, true, nil, true)
        UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET, true)
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")

        local pet_melee = DB.Pet_Data.Get(player_name, pet_name, DB.Enum.Trackable.PET_MELEE, DB.Enum.Metric.TOTAL)
        if pet_melee > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Melee")
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_MELEE)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_MELEE, true, nil, true)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_MELEE, true)
            UI.TableNextColumn() Column.Acc.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_MELEE_DISCRETE)
        end

        local pet_ranged = DB.Pet_Data.Get(player_name, pet_name, DB.Enum.Trackable.PET_RANGED, DB.Enum.Metric.TOTAL)
        if pet_ranged > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Ranged")
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_RANGED)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_RANGED, true, nil, true)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_RANGED, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        local pet_ws = DB.Pet_Data.Get(player_name, pet_name, DB.Enum.Trackable.PET_WS, DB.Enum.Metric.TOTAL)
        if pet_ws > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Weaponskill")
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_WS)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_WS, true, nil, true)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_WS, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        local pet_ability = DB.Pet_Data.Get(player_name, pet_name, DB.Enum.Trackable.PET_ABILITY, DB.Enum.Metric.TOTAL)
        if pet_ability > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Ability")
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_ABILITY)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_ABILITY, true, nil, true)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_ABILITY, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        local pet_magic = DB.Pet_Data.Get(player_name, pet_name, DB.Enum.Trackable.PET_NUKE, DB.Enum.Metric.TOTAL)
        if pet_magic > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Magic")
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_NUKE)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_NUKE, true, nil, true)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_NUKE, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        local pet_healing = DB.Pet_Data.Get(player_name, pet_name, DB.Enum.Trackable.PET_HEAL, DB.Enum.Metric.TOTAL)
        if pet_healing > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Healing")
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_HEAL)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_HEAL, true, nil, true)
            UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_HEAL, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end
        UI.EndTable()
    end

    if UI.BeginTable(pet_name.." single", 7, table_flags) then
        UI.TableSetupColumn("Action Name", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Attempts", col_flags, percent_width)
        UI.TableSetupColumn("Accuracy", col_flags, percent_width)
        UI.TableSetupColumn("Average", col_flags, damage_width)
        UI.TableSetupColumn("Min.", col_flags, damage_width)
        UI.TableSetupColumn("Max.", col_flags, damage_width)
        UI.TableHeadersRow()

        local has_data = false
        DB.Lists.Sort.Pet_Catalog_Damage(player_name, pet_name)
        for _, data in ipairs(DB.Sorted.Pet_Catalog_Damage) do
            has_data = true
            local action_name = data[1]
            local trackable = data[3]
            Focus.Pets.Single_Row(player_name, pet_name, action_name, trackable)
        end
        if not has_data then
            Focus.Pets.Single_Blank_Row()
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
    UI.TableNextColumn() Column.Single.Pet_Damage(player_name, pet_name, action_name, trackable, DB.Enum.Metric.TOTAL)
    UI.TableNextColumn() Column.Single.Pet_Attempts(player_name, pet_name, action_name, trackable)
    UI.TableNextColumn() Column.Single.Pet_Acc(player_name, pet_name, action_name, trackable)
    UI.TableNextColumn() Column.Single.Pet_Average(player_name, pet_name, action_name, trackable)

    local min = DB.Pet_Catalog.Get(player_name, pet_name, trackable, action_name, DB.Enum.Metric.MIN)
    if min == DB.Enum.Values.MAX_DAMAGE then
        UI.TableNextColumn() Column.Single.Pet_Damage(player_name, pet_name, action_name, trackable, DB.Enum.Values.IGNORE)
    else
        UI.TableNextColumn() Column.Single.Pet_Damage(player_name, pet_name, action_name, trackable, DB.Enum.Metric.MIN)
    end

    UI.TableNextColumn() Column.Single.Pet_Damage(player_name, pet_name, action_name, trackable, DB.Enum.Metric.MAX)
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
end