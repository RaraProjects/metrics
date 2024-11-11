Overview.Parse = T{}

------------------------------------------------------------------------------------------------------
-- Overview Content
------------------------------------------------------------------------------------------------------
Overview.Parse.Content = function()
    Parse.Widgets.Mask_Names()
    UI.SameLine() UI.Text(" ") UI.SameLine() Focus.Config.Percent_Details()
    Overview.Parse.Settings()
    UI.Separator()
    if Metrics.Overview.Timer then Overview.Parse.Clock() end
    if Metrics.Overview.Melee then Overview.Parse.Melee() end
    if Metrics.Overview.Ranged then Overview.Parse.Ranged() end
    if Metrics.Overview.WS then Overview.Parse.Weaponskills() end
    if Metrics.Overview.Nuke then Overview.Parse.Nukes() end
    if Metrics.Overview.Pets then Overview.Parse.Pets() end
    if Metrics.Overview.Healing then Overview.Parse.Healing() end
    if Metrics.Overview.Defense then Overview.Parse.Defense() end
    if Metrics.Overview.Mobs_Defeated then Overview.Parse.Monsters_Defeated() end
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

        UI.TableNextColumn() if UI.Checkbox("Timer", {Metrics.Overview.Timer}) then Metrics.Overview.Timer = not Metrics.Overview.Timer end
        UI.TableNextColumn() if UI.Checkbox("Melee", {Metrics.Overview.Melee}) then Metrics.Overview.Melee = not Metrics.Overview.Melee end
        UI.TableNextColumn() if UI.Checkbox("Ranged", {Metrics.Overview.Ranged}) then Metrics.Overview.Ranged = not Metrics.Overview.Ranged end
        UI.TableNextColumn() if UI.Checkbox("Weaponskills", {Metrics.Overview.WS}) then Metrics.Overview.WS = not Metrics.Overview.WS end
        UI.TableNextColumn() if UI.Checkbox("Nuking", {Metrics.Overview.Nuke}) then Metrics.Overview.Nuke = not Metrics.Overview.Nuke end
        UI.TableNextColumn() if UI.Checkbox("Pets", {Metrics.Overview.Pets}) then Metrics.Overview.Pets = not Metrics.Overview.Pets end
        UI.TableNextColumn() if UI.Checkbox("Healing", {Metrics.Overview.Healing}) then Metrics.Overview.Healing = not Metrics.Overview.Healing end
        UI.TableNextColumn() if UI.Checkbox("Defense", {Metrics.Overview.Defense}) then Metrics.Overview.Defense = not Metrics.Overview.Defense end
        UI.TableNextColumn() if UI.Checkbox("Mobs Defeated", {Metrics.Overview.Mobs_Defeated}) then Metrics.Overview.Mobs_Defeated = not Metrics.Overview.Mobs_Defeated end

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

    local trackable = DB.Enum.Trackable.MELEE
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
                local damage = DB.Data.Get(player_name, trackable, Column.Metric.TOTAL)
                if damage > 0 then
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.Format_Name(player_name)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.Proc.Crit_Rate(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.COUNT)
                    UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.MIN)
                    UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.MAX)
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

    local trackable = DB.Enum.Trackable.RANGED
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
                local damage = DB.Data.Get(player_name, trackable, Column.Metric.TOTAL)
                if damage > 0 then
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.Format_Name(player_name)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.Proc.Crit_Rate(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.Shot_Distance(player_name)
                    UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.COUNT)
                    UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.MIN)
                    UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.MAX)
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

    local trackable = DB.Enum.Trackable.WS
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
                local damage = DB.Data.Get(player_name, trackable, Column.Metric.TOTAL)
                if damage > 0 then
                    -- Player Overall
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.Format_Name(player_name)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.Average_TP(player_name)
                    UI.TableNextColumn() Column.General.Fraction(player_name, trackable, DB.Enum.Metric.TOTAL, DB.Enum.Metric.TP_SPENT, false, false, true)
                    UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.COUNT)
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    Window_Manager.Table_Row_Color(1)
                    row = row + 1

                    -- Specific Weaponskills
                    if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
                        DB.Lists.Sort.Catalog_Damage(player_name, trackable)
                        for _, single_data in ipairs(DB.Sorted.Catalog_Damage) do
                            action_name = single_data[1]

                            UI.TableNextRow()
                            UI.TableNextColumn() UI.Text("> " .. tostring(action_name))
                            UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.TOTAL)
                            UI.TableNextColumn() Column.General.Percent_Party_Total_Action(player_name, action_name, trackable)
                            UI.TableNextColumn() Column.Single.Average(player_name, action_name, trackable)
                            UI.TableNextColumn() Column.Single.Acc(player_name, action_name, trackable)
                            UI.TableNextColumn() Column.Single.Average_TP(player_name, action_name)
                            UI.TableNextColumn() Column.Single.Damage_Per_Unit(player_name, action_name, trackable, DB.Enum.Metric.TP_SPENT)
                            UI.TableNextColumn() Column.Single.Attempts(player_name, action_name, trackable)
                            UI.TableNextColumn() Focus.Catalog.Min(player_name, action_name, trackable)
                            UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.MAX)
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

    local trackable = DB.Enum.Trackable.NUKE
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
                local damage = DB.Data.Get(player_name, trackable, Column.Metric.TOTAL)
                if damage > 0 then
                    -- Player Overall
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.Format_Name(player_name)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.BURST_COUNT)
                    UI.TableNextColumn() Column.Spell.Unit_Per_MP(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.HIT_COUNT)
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    Window_Manager.Table_Row_Color(1)
                    row = row + 1

                    -- Specific Nuke Spells
                    if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
                        DB.Lists.Sort.Catalog_Damage(player_name, trackable)
                        for _, single_data in ipairs(DB.Sorted.Catalog_Damage) do
                            action_name = single_data[1]

                            UI.TableNextRow()
                            UI.TableNextColumn() UI.Text("> " .. tostring(action_name))
                            UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.TOTAL)
                            UI.TableNextColumn() Column.General.Percent_Party_Total_Action(player_name, action_name, trackable)
                            UI.TableNextColumn() Column.Single.Average(player_name, action_name, trackable)
                            UI.TableNextColumn() Column.Single.Bursts(player_name, action_name)
                            UI.TableNextColumn() Column.Single.Damage_Per_Unit(player_name, action_name, trackable, DB.Enum.Metric.MP_SPENT)
                            UI.TableNextColumn() Column.Single.Attempts(player_name, action_name, trackable)
                            UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.MIN)
                            UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.MAX)
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

    local trackable = DB.Enum.Trackable.PET

    if UI.BeginTable("Pets", 8, table_flags) then
        UI.TableSetupColumn("Pet",      col_flags, name_width)
        UI.TableSetupColumn("Damage",   col_flags, width)
        UI.TableSetupColumn("%Party",   col_flags, width)
        UI.TableSetupColumn("Accuracy", col_flags, width)
        UI.TableSetupColumn("%Player",  col_flags, width)
        UI.TableSetupColumn("%Melee",   col_flags, width)
        UI.TableSetupColumn("%WS",      col_flags, width)
        UI.TableSetupColumn("%Ability", col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Damage_By_Type(trackable)
        local row = 1
        for rank, data in ipairs(sorted_damage) do
            if rank <= Parse.Config.Rank_Cutoff() then
                local player_name = data[1]
                local damage = DB.Data.Get(player_name, trackable, Column.Metric.TOTAL)
                if damage > 0 then
                    -- Player overall pet damage.
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.Format_Name(player_name)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, trackable)
                    UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Enum.Trackable.PET_MELEE_DISCRETE)
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_MELEE, true)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_WS, true)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_ABILITY, true)
                    Window_Manager.Table_Row_Color(1)
                    row = row + 1

                    -- Specific Pets
                    local pet_name = DB.Enum.Values.DEBUG
                    DB.Lists.Populate.Pet_Damage(player_name)
                    for _, pet_data in ipairs(DB.Sorted.Pet_Damage) do
                        pet_name = pet_data[1]
                        UI.TableNextRow()
                        UI.TableNextColumn() UI.Text("> " .. tostring(pet_name))
                        UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, trackable)
                        UI.TableNextColumn() Column.General.Percent_Party_Total_Pet(player_name, pet_name, trackable)
                        UI.TableNextColumn() Column.Acc.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_MELEE_DISCRETE)
                        UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, trackable, true)
                        UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_MELEE, true)
                        UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_WS, true)
                        UI.TableNextColumn() Column.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_ABILITY, true)
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

    local trackable = DB.Enum.Trackable.HEALING
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
                local damage = DB.Data.Get(player_name, trackable, Column.Metric.TOTAL)
                if damage > 0 then
                    -- Player Overall
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.Format_Name(player_name)
                    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, trackable)
                    UI.TableNextColumn() Column.Healing.Overcure(player_name)
                    UI.TableNextColumn() Column.Spell.Unit_Per_MP(player_name, trackable)
                    UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.HIT_COUNT)
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    Window_Manager.Table_Row_Color(1)
                    row = row + 1

                    -- Specific Healing Spells
                    if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
                        DB.Lists.Sort.Catalog_Damage(player_name, trackable)
                        for _, single_data in ipairs(DB.Sorted.Catalog_Damage) do
                            action_name = single_data[1]

                            UI.TableNextRow()
                            UI.TableNextColumn() UI.Text("> " .. tostring(action_name))
                            UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.TOTAL)
                            UI.TableNextColumn() Column.General.Percent_Party_Total_Action(player_name, action_name, trackable)
                            UI.TableNextColumn() Column.Single.Average(player_name, action_name, trackable)
                            UI.TableNextColumn() Column.Single.Overcure(player_name, action_name)
                            UI.TableNextColumn() Column.Single.Damage_Per_Unit(player_name, action_name, trackable, DB.Enum.Metric.MP_SPENT)
                            UI.TableNextColumn() Column.Single.Attempts(player_name, action_name, trackable)
                            UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.MIN)
                            UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.MAX)
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

    local trackable = DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL
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
                local damage = DB.Data.Get(player_name, trackable, Column.Metric.TOTAL)
                if damage > 0 then
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.Format_Name(player_name)
                    UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL)
                    UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, trackable)
                    UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, DB.Enum.Trackable.HEALING_RECEIVED)
                    UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.MELEE_DMG_TAKEN, true)
                    UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.SPELL_DMG_TAKEN, true)
                    UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.TP_DMG_TAKEN, true)
                    UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_EVASION)
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
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if UI.BeginTable("Mobs Defeated", 2, table_flags) then
        UI.TableSetupColumn("Mob Name", col_flags, name_width)
        UI.TableSetupColumn("Defeated", col_flags, width)
        UI.TableHeadersRow()

        local mobs_defeated = 0
        for mob_name, count in pairs(DB.Tracking.Defeated_Mobs) do
            UI.TableNextColumn() UI.Text(tostring(mob_name))
            UI.TableNextColumn() UI.Text(tostring(count))
            mobs_defeated = mobs_defeated + 1
        end
        if mobs_defeated == 0 then
            UI.TableNextColumn() UI.Text("None")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end