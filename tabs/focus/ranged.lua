Focus.Ranged = T{}

------------------------------------------------------------------------------------------------------
-- Loads data to the ranged drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Ranged.Display = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local name_width = Window.Columns.Widths.Standard
    local damage_width = Window.Columns.Widths.Damage
    local percent_width = Window.Columns.Widths.Percent
    local trackable = DB.Enum.Trackable.RANGED

    if UI.BeginTable("Ranged", 5, table_flags) then
        UI.TableSetupColumn("Type", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Damage %", col_flags, damage_width)
        UI.TableSetupColumn("Accuracy", col_flags, damage_width)
        UI.TableSetupColumn("Rate", col_flags, percent_width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Ranged Total")
        UI.TableNextColumn() Col.Damage.By_Type(player_name, trackable)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, trackable, true)
        UI.TableNextColumn() Col.Acc.By_Type(player_name, trackable)
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Square Hit")
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        UI.TableNextColumn() Col.Acc.By_Type(player_name, trackable, nil, DB.Enum.Metric.SQUARE_COUNT)


        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Truestrike")
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        UI.TableNextColumn() Col.Acc.By_Type(player_name, trackable, nil, DB.Enum.Metric.TRUE_COUNT)

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Critical Hits")
        UI.TableNextColumn() Col.Crit.Damage(player_name, trackable)
        UI.TableNextColumn() Col.Crit.Damage(player_name, trackable, true)
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        UI.TableNextColumn() Col.Crit.Rate(player_name, trackable)
        UI.EndTable()
    end
end