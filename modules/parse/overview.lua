Parse.Overview = T{}

------------------------------------------------------------------------------------------------------
-- Populates the Parse overview.
------------------------------------------------------------------------------------------------------
Parse.Overview.Populate = function()
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local trackable = DB.Enum.Trackable.WS
    local action_name

    if UI.BeginTable("WS", 8, table_flags) then
        UI.TableSetupColumn("Name", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, width)
        UI.TableSetupColumn("Count", col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("Accuracy", col_flags, width)
        UI.TableSetupColumn("~TP", col_flags, width)
        UI.TableSetupColumn("Minimum", col_flags, width)
        UI.TableSetupColumn("Maximum", col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Damage_By_Type(trackable)
        for rank, data in ipairs(sorted_damage) do
            if rank <= Parse.Config.Rank_Cutoff() then
                local player_name = data[1]
                local damage = data[2]

                -- Player Overall
                UI.TableNextRow()
                UI.TableNextColumn() Column.String.Format_Name(player_name)
                UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
                UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Enum.Metric.COUNT)
                UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, trackable)
                UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable)
                UI.TableNextColumn() Column.Damage.Average_TP(player_name)
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                Parse.Overview.Row_Color(1)

                -- Specific Weaponskills
                if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
                    DB.Lists.Sort.Catalog_Damage(player_name, trackable)
                    for _, single_data in ipairs(DB.Sorted.Catalog_Damage) do
                        action_name = single_data[1]

                        UI.TableNextRow()
                        UI.TableNextColumn() UI.Text("> " .. tostring(action_name))
                        UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.TOTAL)
                        UI.TableNextColumn() Column.Single.Attempts(player_name, action_name, trackable)
                        UI.TableNextColumn() Column.Single.Average(player_name, action_name, trackable)
                        UI.TableNextColumn() Column.Single.Acc(player_name, action_name, trackable)
                        UI.TableNextColumn() Column.Single.Average_TP(player_name, action_name)
                        UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.MIN)
                        UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Enum.Metric.MAX)
                        Parse.Overview.Row_Color(0)
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
Parse.Overview.Row_Color = function(rank)
    local x, y, z, w = UI.GetStyleColorVec4(ImGuiCol_TableRowBg)
    if (rank % 2) == 0 then x, y, z, w = UI.GetStyleColorVec4(ImGuiCol_TableRowBgAlt) end
    local row_color = UI.GetColorU32({x, y, z, w})
    UI.TableSetBgColor(ImGuiTableBgTarget_RowBg0, row_color)
end