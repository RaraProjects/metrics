Overview.Parse = T{}

------------------------------------------------------------------------------------------------------
-- Overview Content
------------------------------------------------------------------------------------------------------
Overview.Parse.Content = function()
    Overview.Parse.Settings()
    UI.Separator()
    if Metrics.Overview.Timer then Overview.Parse.Clock() end
    if Metrics.Overview.Melee then Overview.Parse.Melee() end
    if Metrics.Overview.Ranged then Overview.Parse.Ranged() end
    if Metrics.Overview.WS then Overview.Parse.Weaponskills() end
    if Metrics.Overview.Nuke then Overview.Parse.Nukes() end
end

------------------------------------------------------------------------------------------------------
-- Parse Overview section selection.
------------------------------------------------------------------------------------------------------
Overview.Parse.Settings = function()
    local col_flags = Column.Flags.None
    local width = Column.Widths.Standard

    if UI.BeginTable("Parse Overview", 5) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)
        UI.TableSetupColumn("Col 4", col_flags, width)
        UI.TableSetupColumn("Col 5", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Timer", {Metrics.Overview.Timer}) then
            Metrics.Overview.Timer = not Metrics.Overview.Timer
        end

        UI.TableNextColumn()
        if UI.Checkbox("Melee", {Metrics.Overview.Melee}) then
            Metrics.Overview.Melee = not Metrics.Overview.Melee
        end

        UI.TableNextColumn()
        if UI.Checkbox("Ranged", {Metrics.Overview.Ranged}) then
            Metrics.Overview.Ranged = not Metrics.Overview.Ranged
        end

        UI.TableNextColumn()
        if UI.Checkbox("WS", {Metrics.Overview.WS}) then
            Metrics.Overview.WS = not Metrics.Overview.WS
        end

        UI.TableNextColumn()
        if UI.Checkbox("Nuke", {Metrics.Overview.Nuke}) then
            Metrics.Overview.Nuke = not Metrics.Overview.Nuke
        end

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
    if UI.BeginTable("Melee", 10, table_flags) then
        UI.TableSetupColumn("Melee",    col_flags, name_width)
        UI.TableSetupColumn("Damage",   col_flags, width)
        UI.TableSetupColumn("%Total",   col_flags, width)
        UI.TableSetupColumn("Average",  col_flags, width)
        UI.TableSetupColumn("Accuracy", col_flags, width)
        UI.TableSetupColumn("%Crit",    col_flags, width)
        UI.TableSetupColumn("%Multi",   col_flags, width)
        UI.TableSetupColumn("Swings",   col_flags, width)
        UI.TableSetupColumn("Minimum",  col_flags, width)
        UI.TableSetupColumn("Maximum",  col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Damage_By_Type(trackable)
        for rank, data in ipairs(sorted_damage) do
            if rank <= Parse.Config.Rank_Cutoff() then
                local player_name = data[1]
                UI.TableNextRow()
                UI.TableNextColumn() Column.String.Format_Name(player_name)
                UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
                UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, true)
                UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, trackable)
                UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable)
                UI.TableNextColumn() Column.Proc.Crit_Rate(player_name, trackable)
                UI.TableNextColumn() Column.General.Fraction(player_name, trackable, DB.Enum.Metric.MULTI_TOTAL, DB.Enum.Metric.ROUNDS)
                UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.COUNT)
                UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.MIN)
                UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.MAX)
                Overview.Parse.Row_Color(rank)
            end
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
        UI.TableSetupColumn("%Total",    col_flags, width)
        UI.TableSetupColumn("Average",   col_flags, width)
        UI.TableSetupColumn("Accuracy",  col_flags, width)
        UI.TableSetupColumn("%Crit",     col_flags, width)
        UI.TableSetupColumn("Shot Dist", col_flags, width)
        UI.TableSetupColumn("Shots",     col_flags, width)
        UI.TableSetupColumn("Minimum",   col_flags, width)
        UI.TableSetupColumn("Maximum",   col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Damage_By_Type(trackable)
        for rank, data in ipairs(sorted_damage) do
            if rank <= Parse.Config.Rank_Cutoff() then
                local player_name = data[1]
                UI.TableNextRow()
                UI.TableNextColumn() Column.String.Format_Name(player_name)
                UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
                UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, true)
                UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, trackable)
                UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable)
                UI.TableNextColumn() Column.Proc.Crit_Rate(player_name, trackable)
                UI.TableNextColumn() Column.Damage.Shot_Distance(player_name)
                UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.COUNT)
                UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.MIN)
                UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.MAX)
                Overview.Parse.Row_Color(rank)
            end
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

    if UI.BeginTable("WS", 9, table_flags) then
        UI.TableSetupColumn("Weaponskill", col_flags, name_width)
        UI.TableSetupColumn("Damage",      col_flags, width)
        UI.TableSetupColumn("%Total",      col_flags, width)
        UI.TableSetupColumn("Average",     col_flags, width)
        UI.TableSetupColumn("Accuracy",    col_flags, width)
        UI.TableSetupColumn("~TP",         col_flags, width)
        UI.TableSetupColumn("Attempts",    col_flags, width)
        UI.TableSetupColumn("Minimum",     col_flags, width)
        UI.TableSetupColumn("Maximum",     col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Damage_By_Type(trackable)
        for rank, data in ipairs(sorted_damage) do
            if rank <= Parse.Config.Rank_Cutoff() then
                local player_name = data[1]

                -- Player Overall
                UI.TableNextRow()
                UI.TableNextColumn() Column.String.Format_Name(player_name)
                UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
                UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, true)
                UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, trackable)
                UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable)
                UI.TableNextColumn() Column.Damage.Average_TP(player_name)
                UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.COUNT)
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                Overview.Parse.Row_Color(1)

                -- Specific Weaponskills
                if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
                    DB.Lists.Sort.Catalog_Damage(player_name, trackable)
                    for _, single_data in ipairs(DB.Sorted.Catalog_Damage) do
                        action_name = single_data[1]

                        UI.TableNextRow()
                        UI.TableNextColumn() UI.Text("> " .. tostring(action_name))
                        UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.TOTAL)
                        UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.TOTAL, true)
                        UI.TableNextColumn() Column.Single.Average(player_name, action_name, trackable)
                        UI.TableNextColumn() Column.Single.Acc(player_name, action_name, trackable)
                        UI.TableNextColumn() Column.Single.Average_TP(player_name, action_name)
                        UI.TableNextColumn() Column.Single.Attempts(player_name, action_name, trackable)
                        UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.MIN)
                        UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.MAX)
                        Overview.Parse.Row_Color(0)
                    end
                end
            end
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Parse weaponskill overview.
------------------------------------------------------------------------------------------------------
Overview.Parse.Nukes = function()
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local trackable = DB.Enum.Trackable.NUKE
    local action_name

    if UI.BeginTable("Nuke", 9, table_flags) then
        UI.TableSetupColumn("Nuke",     col_flags, name_width)
        UI.TableSetupColumn("Damage",   col_flags, width)
        UI.TableSetupColumn("%Total",   col_flags, width)
        UI.TableSetupColumn("Average",  col_flags, width)
        UI.TableSetupColumn("Bursts",   col_flags, width)
        UI.TableSetupColumn("Efficacy", col_flags, width)
        UI.TableSetupColumn("Casts",    col_flags, width)
        UI.TableSetupColumn("Minimum",  col_flags, width)
        UI.TableSetupColumn("Maximum",  col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Damage_By_Type(trackable)
        for rank, data in ipairs(sorted_damage) do
            if rank <= Parse.Config.Rank_Cutoff() then
                local player_name = data[1]

                -- Player Overall
                UI.TableNextRow()
                UI.TableNextColumn() Column.String.Format_Name(player_name)
                UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
                UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, true)
                UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, trackable)
                UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.BURST_COUNT)
                UI.TableNextColumn() Column.Spell.Unit_Per_MP(player_name, DB.Enum.Trackable.NUKE)
                UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.HIT_COUNT)
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                Overview.Parse.Row_Color(1)

                -- Specific Weaponskills
                if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
                    DB.Lists.Sort.Catalog_Damage(player_name, trackable)
                    for _, single_data in ipairs(DB.Sorted.Catalog_Damage) do
                        action_name = single_data[1]

                        UI.TableNextRow()
                        UI.TableNextColumn() UI.Text("> " .. tostring(action_name))
                        UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.TOTAL)
                        UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.TOTAL, true)
                        UI.TableNextColumn() Column.Single.Average(player_name, action_name, trackable)
                        UI.TableNextColumn() Column.Single.Bursts(player_name, action_name)
                        UI.TableNextColumn() Column.Single.Damage_Per_MP(player_name, action_name, trackable)
                        UI.TableNextColumn() Column.Single.Attempts(player_name, action_name, trackable)
                        UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.MIN)
                        UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.MAX)
                        Overview.Parse.Row_Color(0)
                    end
                end
            end
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets the table row color.
------------------------------------------------------------------------------------------------------
---@param rank integer
------------------------------------------------------------------------------------------------------
Overview.Parse.Row_Color = function(rank)
    local x, y, z, w = UI.GetStyleColorVec4(ImGuiCol_TableRowBg)
    if (rank % 2) == 0 then x, y, z, w = UI.GetStyleColorVec4(ImGuiCol_TableRowBgAlt) end
    local row_color = UI.GetColorU32({x, y, z, w})
    UI.TableSetBgColor(ImGuiTableBgTarget_RowBg0, row_color)
end