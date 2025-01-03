Overview.Parse = {}

------------------------------------------------------------------------------------------------------
-- Overview Content
------------------------------------------------------------------------------------------------------
Overview.Parse.Content = function()
    Parse.Widgets.Mask_Names()
    UI.SameLine() UI.Text(" ") UI.SameLine() Focus.Config.Percent_Details()
    Overview.Parse.Settings()
    UI.Separator()
    if Overview.Settings.Show_Timer         then Overview.Parse.Clock() end
    if Overview.Settings.Show_Melee         then Overview.Parse.Melee() end
    if Overview.Settings.Show_Ranged        then Overview.Parse.Ranged() end
    if Overview.Settings.Weaponskills       then Overview.Parse.Weaponskills() end
    if Overview.Settings.Show_Nuking        then Overview.Parse.Nukes() end
    if Overview.Settings.Show_Pets          then Overview.Parse.Pets() end
    if Overview.Settings.Show_Healing       then Overview.Parse.Healing() end
    if Overview.Settings.Show_Defense       then Overview.Parse.Defense() end
    if Overview.Settings.Show_Mobs_Defeated then Overview.Parse.Monsters_Defeated() end
    Overview.Parse.Items_Obtained()
end

------------------------------------------------------------------------------------------------------
-- Parse Overview section selection.
------------------------------------------------------------------------------------------------------
Overview.Parse.Settings = function()
    local col_flags = Column.Flags.None
    local width = Column.Widths.Name

    if UI.BeginTable("Parse Overview", 5) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)
        UI.TableSetupColumn("Col 4", col_flags, width)
        UI.TableSetupColumn("Col 5", col_flags, width)

        UI.TableNextColumn() if UI.Checkbox("Timer",         {Overview.Settings.Show_Timer})         then Overview.Settings.Show_Timer         = not Overview.Settings.Show_Timer end
        UI.TableNextColumn() if UI.Checkbox("Melee",         {Overview.Settings.Show_Melee})         then Overview.Settings.Show_Melee         = not Overview.Settings.Show_Melee end
        UI.TableNextColumn() if UI.Checkbox("Ranged",        {Overview.Settings.Show_Ranged})        then Overview.Settings.Show_Ranged        = not Overview.Settings.Show_Ranged end
        UI.TableNextColumn() if UI.Checkbox("Weaponskills",  {Overview.Settings.Show_Weaponskills})  then Overview.Settings.Show_Weaponskills  = not Overview.Settings.Show_Weaponskills end
        UI.TableNextColumn() if UI.Checkbox("Nuking",        {Overview.Settings.Show_Nuking})        then Overview.Settings.Show_Nuking        = not Overview.Settings.Show_Nuking end
        UI.TableNextColumn() if UI.Checkbox("Pets",          {Overview.Settings.Show_Pets})          then Overview.Settings.Show_Pets          = not Overview.Settings.Show_Pets end
        UI.TableNextColumn() if UI.Checkbox("Healing",       {Overview.Settings.Show_Healing})       then Overview.Settings.Show_Healing       = not Overview.Settings.Show_Healing end
        UI.TableNextColumn() if UI.Checkbox("Defense",       {Overview.Settings.Show_Defense})       then Overview.Settings.Show_Defense       = not Overview.Settings.Show_Defense end
        UI.TableNextColumn() if UI.Checkbox("Mobs Defeated", {Overview.Settings.Show_Mobs_Defeated}) then Overview.Settings.Show_Mobs_Defeated = not Overview.Settings.Show_Mobs_Defeated end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Overview Clocks
------------------------------------------------------------------------------------------------------
Overview.Parse.Clock = function()
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if UI.BeginTable("Clocks", 2, table_flags) then
        UI.TableSetupColumn("Total Time", col_flags, name_width)
        UI.TableSetupColumn("Active Time", col_flags, name_width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(tostring(Timers.Check(Timers.Enum.Names.METRICS)))
        UI.TableNextColumn() UI.Text(tostring(Timers.Check(Timers.Enum.Names.PARSE)))

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Parse melee overview.
------------------------------------------------------------------------------------------------------
Overview.Parse.Melee = function()
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local trackable = DB.Trackable.MELEE_OVERALL
    if UI.BeginTable("Melee", 9, table_flags) then
        UI.TableSetupColumn("Melee",    col_flags, name_width)
        UI.TableSetupColumn("Damage",   col_flags, width)
        UI.TableSetupColumn("%Party",   col_flags, width)
        UI.TableSetupColumn("Average",  col_flags, width)
        UI.TableSetupColumn("Accuracy", col_flags, width)
        UI.TableSetupColumn("%Crit",    col_flags, width)
        UI.TableSetupColumn("Swings",   col_flags, width)
        UI.TableSetupColumn("Minimum",  col_flags, width)
        UI.TableSetupColumn("Maximum",  col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Damage_By_Type(trackable)
        local row = 1
        for rank, data in ipairs(sorted_damage) do
            if rank <= Parse.Config.Rank_Cutoff() then
                local player_name = data[1]
                local damage = DB.Data.Get(player_name, trackable, DB.Metric.TOTAL)
                if damage > 0 then
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.Format_Name(player_name)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable)
                    UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable, 0, true)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.ATTEMPTS_ON_USE)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MIN)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MAX)
                    Window_Manager.Table_Row_Color(row)
                    row = row + 1
                end
            end
        end
        if row == 1 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("No data")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Parse melee overview.
------------------------------------------------------------------------------------------------------
Overview.Parse.Ranged = function()
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local trackable = DB.Trackable.RANGED_OVERALL
    if UI.BeginTable("Ranged", 10, table_flags) then
        UI.TableSetupColumn("Ranged",    col_flags, name_width)
        UI.TableSetupColumn("Damage",    col_flags, width)
        UI.TableSetupColumn("%Party",    col_flags, width)
        UI.TableSetupColumn("Average",   col_flags, width)
        UI.TableSetupColumn("Accuracy",  col_flags, width)
        UI.TableSetupColumn("%Crit",     col_flags, width)
        UI.TableSetupColumn("Shot Dist", col_flags, width)
        UI.TableSetupColumn("Shots",     col_flags, width)
        UI.TableSetupColumn("Minimum",   col_flags, width)
        UI.TableSetupColumn("Maximum",   col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Damage_By_Type(trackable)
        local row = 1
        for rank, data in ipairs(sorted_damage) do
            if rank <= Parse.Config.Rank_Cutoff() then
                local player_name = data[1]
                local damage = DB.Data.Get(player_name, trackable, DB.Metric.TOTAL)
                if damage > 0 then
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.Format_Name(player_name)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable)
                    UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable, 0, true)
                    UI.TableNextColumn() Column.Damage.Shot_Distance(player_name)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.ATTEMPTS_ON_USE)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MIN)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MAX)
                    Window_Manager.Table_Row_Color(row)
                    row = row + 1
                end
            end
        end
        if row == 1 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("No data")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Parse weaponskill overview.
------------------------------------------------------------------------------------------------------
Overview.Parse.Weaponskills = function()
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local trackable = DB.Trackable.WEAPONSKILL
    local action_name

    if UI.BeginTable("WS", 10, table_flags) then
        UI.TableSetupColumn("Weaponskill", col_flags, name_width)
        UI.TableSetupColumn("Damage",      col_flags, width)
        UI.TableSetupColumn("%Party",      col_flags, width)
        UI.TableSetupColumn("Average",     col_flags, width)
        UI.TableSetupColumn("Accuracy",    col_flags, width)
        UI.TableSetupColumn("~TP",         col_flags, width)
        UI.TableSetupColumn("DMG/TP",      col_flags, width)
        UI.TableSetupColumn("Attempts",    col_flags, width)
        UI.TableSetupColumn("Minimum",     col_flags, width)
        UI.TableSetupColumn("Maximum",     col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Damage_By_Type(trackable)
        local row = 1
        for rank, data in ipairs(sorted_damage) do
            if rank <= Parse.Config.Rank_Cutoff() then
                local player_name = data[1]
                local damage = DB.Data.Get(player_name, trackable, DB.Metric.TOTAL)
                if damage > 0 then
                    -- Player Overall
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.Format_Name(player_name)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable)
                    UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.Per_Unit_Average(player_name, trackable, DB.Metric.TP_SPENT)
                    UI.TableNextColumn() Column.General.Fraction(player_name, trackable, DB.Metric.TOTAL, DB.Metric.TP_SPENT, false, false, true)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.ATTEMPTS_ON_USE)
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    Window_Manager.Table_Row_Color(1)
                    row = row + 1

                    -- Specific Weaponskills
                    if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
                        local sorted_catalog_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
                        for _, single_data in ipairs(sorted_catalog_damage) do
                            action_name = single_data[1]

                            UI.TableNextRow()
                            UI.TableNextColumn() UI.Text("> " .. tostring(action_name))
                            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.TOTAL, action_name)
                            UI.TableNextColumn() Column.General.Percent_Party_Total_Action(player_name, action_name, trackable)
                            UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable, nil, action_name)
                            UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable, nil, false, action_name)
                            UI.TableNextColumn() Column.Damage.Per_Unit_Average(player_name, trackable, DB.Metric.TP_SPENT, action_name)
                            UI.TableNextColumn() Column.Damage.Per_Unit(player_name, trackable, DB.Metric.TP_SPENT, action_name)
                            UI.TableNextColumn() Column.Damage.Attempts(player_name, trackable, nil, action_name)
                            UI.TableNextColumn() Focus.Catalog.Min(player_name, action_name, trackable)
                            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MAX, action_name)
                            Window_Manager.Table_Row_Color(0)
                        end
                    end
                end
            end
        end
        if row == 1 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("No data")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Parse nuking overview.
------------------------------------------------------------------------------------------------------
Overview.Parse.Nukes = function()
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local trackable = DB.Trackable.SPELLS_NUKING
    local action_name

    if UI.BeginTable("Nuke", 9, table_flags) then
        UI.TableSetupColumn("Nuke",    col_flags, name_width)
        UI.TableSetupColumn("Damage",  col_flags, width)
        UI.TableSetupColumn("%Party",  col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("Bursts",  col_flags, width)
        UI.TableSetupColumn("DMG/MP",  col_flags, width)
        UI.TableSetupColumn("Casts",   col_flags, width)
        UI.TableSetupColumn("Minimum", col_flags, width)
        UI.TableSetupColumn("Maximum", col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Damage_By_Type(trackable)
        local row = 1
        for rank, data in ipairs(sorted_damage) do
            if rank <= Parse.Config.Rank_Cutoff() then
                local player_name = data[1]
                local damage = DB.Data.Get(player_name, trackable, DB.Metric.TOTAL)
                if damage > 0 then
                    -- Player Overall
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.Format_Name(player_name)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MAGIC_BURST_COUNT)
                    UI.TableNextColumn() Column.Spell.Unit_Per_MP(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.HITS_ON_USE)
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    Window_Manager.Table_Row_Color(1)
                    row = row + 1

                    -- Specific Nuke Spells
                    if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
                        local sorted_catalog_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
                        for _, single_data in ipairs(sorted_catalog_damage) do
                            action_name = single_data[1]

                            UI.TableNextRow()
                            UI.TableNextColumn() UI.Text("> " .. tostring(action_name))
                            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.TOTAL, action_name)
                            UI.TableNextColumn() Column.General.Percent_Party_Total_Action(player_name, action_name, trackable)
                            UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable, nil, action_name)
                            UI.TableNextColumn() Column.Single.Bursts(player_name, action_name)
                            UI.TableNextColumn() Column.Damage.Per_Unit(player_name, trackable, DB.Metric.MP_SPENT, action_name)
                            UI.TableNextColumn() Column.Damage.Attempts(player_name, trackable, nil, action_name)
                            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MIN, action_name)
                            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MAX, action_name)
                            Window_Manager.Table_Row_Color(0)
                        end
                    end
                end
            end
        end
        if row == 1 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("No data")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Parse pet overview.
------------------------------------------------------------------------------------------------------
Overview.Parse.Pets = function()
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local trackable = DB.Trackable.PET_OVERALL

    if UI.BeginTable("Pets", 7, table_flags) then
        UI.TableSetupColumn("Pet",      col_flags, name_width)
        UI.TableSetupColumn("Damage",   col_flags, width)
        UI.TableSetupColumn("%Party",   col_flags, width)
        UI.TableSetupColumn("Accuracy", col_flags, width)
        UI.TableSetupColumn("%Player",  col_flags, width)
        UI.TableSetupColumn("%Melee",   col_flags, width)
        UI.TableSetupColumn("%TP Move", col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Damage_By_Type(trackable)
        local row = 1
        for rank, data in ipairs(sorted_damage) do
            if rank <= Parse.Config.Rank_Cutoff() then
                local player_name = data[1]
                local damage = DB.Data.Get(player_name, trackable, DB.Metric.TOTAL)
                if damage > 0 then
                    -- Player overall pet damage.
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.Format_Name(player_name)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, trackable)
                    UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.PET_MELEE_DISCRETE)
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_MELEE_OVERALL, nil, nil, true)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_TP, nil, nil, true)
                    Window_Manager.Table_Row_Color(1)
                    row = row + 1

                    -- Specific Pets
                    local pet_name = DB.Enum.DEBUG
                    DB.Lists.Populate.Pet_Damage(player_name)
                    for _, pet_data in ipairs(DB.Sorted.Pet_Damage) do
                        pet_name = pet_data[1]
                        UI.TableNextRow()
                        UI.TableNextColumn() UI.Text("> " .. tostring(pet_name))
                        UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, trackable)
                        UI.TableNextColumn() Column.General.Percent_Party_Total_Pet(player_name, pet_name, trackable)
                        UI.TableNextColumn() Column.Acc.By_Type_Pet(player_name, pet_name, DB.Trackable.PET_MELEE_DISCRETE)
                        UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, trackable, true)
                        UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_MELEE_OVERALL, true)
                        UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Trackable.PET_TP, true)
                        Window_Manager.Table_Row_Color(0)
                    end
                end
            end
        end
        if row == 1 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("No data")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Parse healing overview.
------------------------------------------------------------------------------------------------------
Overview.Parse.Healing = function()
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local trackable = DB.Trackable.SPELLS_HEALING
    local action_name

    if UI.BeginTable("Healing Magic", 9, table_flags) then
        UI.TableSetupColumn("Healing",  col_flags, name_width)
        UI.TableSetupColumn("HP+",      col_flags, width)
        UI.TableSetupColumn("%Party",   col_flags, width)
        UI.TableSetupColumn("Average",  col_flags, width)
        UI.TableSetupColumn("Overcure", col_flags, width)
        UI.TableSetupColumn("HP+/MP", col_flags, width)
        UI.TableSetupColumn("Casts",    col_flags, width)
        UI.TableSetupColumn("Minimum",  col_flags, width)
        UI.TableSetupColumn("Maximum",  col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Damage_By_Type(trackable)
        local row = 1
        for rank, data in ipairs(sorted_damage) do
            if rank <= Parse.Config.Rank_Cutoff() then
                local player_name = data[1]
                local damage = DB.Data.Get(player_name, trackable, DB.Metric.TOTAL)
                if damage > 0 then
                    -- Player Overall
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.Format_Name(player_name)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable)
                    UI.TableNextColumn() Column.Healing.Overcure(player_name)
                    UI.TableNextColumn() Column.Spell.Unit_Per_MP(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.HITS_ON_USE)
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    Window_Manager.Table_Row_Color(1)
                    row = row + 1

                    -- Specific Healing Spells
                    if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
                        local sorted_catalog_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
                        for _, single_data in ipairs(sorted_catalog_damage) do
                            action_name = single_data[1]

                            UI.TableNextRow()
                            UI.TableNextColumn() UI.Text("> " .. tostring(action_name))
                            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.TOTAL, action_name)
                            UI.TableNextColumn() Column.General.Percent_Party_Total_Action(player_name, action_name, trackable)
                            UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable, nil, action_name)
                            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.OVERCURE, action_name)
                            UI.TableNextColumn() Column.Damage.Per_Unit(player_name, trackable, DB.Metric.MP_SPENT, action_name)
                            UI.TableNextColumn() Column.Damage.Attempts(player_name, trackable, nil, action_name)
                            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MIN, action_name)
                            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MAX, action_name)
                            Window_Manager.Table_Row_Color(0)
                        end
                    end
                end
            end
        end
        if row == 1 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("No data")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Parse melee overview.
------------------------------------------------------------------------------------------------------
Overview.Parse.Defense = function()
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local trackable = DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL
    if UI.BeginTable("Defense", 8, table_flags) then
        UI.TableSetupColumn("Damage Taken", col_flags, name_width)
        UI.TableSetupColumn("HP-",      col_flags, width)
        UI.TableSetupColumn("%Party",   col_flags, width)
        UI.TableSetupColumn("%HP-Rec",  col_flags, width)
        UI.TableSetupColumn("%Melee",   col_flags, width)
        UI.TableSetupColumn("%Magic",   col_flags, width)
        UI.TableSetupColumn("%Mob TP",  col_flags, width)
        UI.TableSetupColumn("%Evasion", col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Damage_By_Type(trackable)
        local row = 1
        for rank, data in ipairs(sorted_damage) do
            if rank <= Parse.Config.Rank_Cutoff() then
                local player_name = data[1]
                local damage = DB.Data.Get(player_name, trackable, DB.Metric.TOTAL)
                if damage > 0 then
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.Format_Name(player_name)
                    UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL)
                    UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, trackable)
                    UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, DB.Trackable.DEF_HEALING_RECEIVED)
                    UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_MELEE, true)
                    UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_NUKING, true)
                    UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_TP_MOVE, true)
                    UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.DEF_EVASION_MELEE, 0)
                    Window_Manager.Table_Row_Color(row)
                    row = row + 1
                end
            end
        end
        if row == 1 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("No data")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Builds the monsters defeated section.
------------------------------------------------------------------------------------------------------
Overview.Parse.Monsters_Defeated = function()
    local col_flags   = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    if UI.BeginTable("Mobs Defeated", 3, table_flags) then
        UI.TableSetupColumn("Mobs & Drops", col_flags, name_width)
        UI.TableSetupColumn("Defeated",     col_flags, width)
        UI.TableSetupColumn("%Drop",        col_flags, width)
        UI.TableHeadersRow()

        local mobs_defeated = 0

        -- Mob
        for mob_name, mob_deaths in pairs(DB.Tracking.Defeated_Mobs) do
            UI.TableNextColumn() UI.Text(tostring(mob_name))
            UI.TableNextColumn() UI.Text(tostring(mob_deaths))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(1)

            -- Items
            if DB.Tracking.Drop_Rates[mob_name] then
                for item_name, drop_count in pairs(DB.Tracking.Drop_Rates[mob_name]) do
                    UI.TableNextColumn() UI.Text("- " .. tostring(item_name))
                    UI.TableNextColumn() UI.Text(tostring(drop_count))
                    UI.TableNextColumn() UI.Text(Column.String.Format_Percent(drop_count, mob_deaths))
                    Window_Manager.Table_Row_Color(0)
                end
            end

            mobs_defeated = mobs_defeated + 1
        end

        if mobs_defeated == 0 then
            UI.TableNextColumn() UI.Text("None Yet")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Builds the items obtained section.
------------------------------------------------------------------------------------------------------
Overview.Parse.Items_Obtained = function()
    local col_flags   = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    if UI.BeginTable("Items Obtained", 2, table_flags) then
        UI.TableSetupColumn("Players & Drops",  col_flags, name_width)
        UI.TableSetupColumn("Drops",            col_flags, width)
        UI.TableHeadersRow()

        local items_obtained = 0

        -- Player
        for player_name, item_data in pairs(DB.Tracking.Received_Items) do
            UI.TableNextColumn() UI.Text(tostring(player_name))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(1)

            -- Items
            for item_name, count in pairs(item_data) do
                UI.TableNextColumn() UI.Text("- " .. tostring(item_name))
                UI.TableNextColumn() UI.Text(tostring(count))
                Window_Manager.Table_Row_Color(0)
            end

            items_obtained = items_obtained + 1
        end

        if items_obtained == 0 then
            UI.TableNextColumn() UI.Text("None Yet")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end