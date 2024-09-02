Focus.Ranged = T{}

------------------------------------------------------------------------------------------------------
-- Loads data to the ranged drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Ranged.Display = function(player_name)
    local endamage = DB.Data.Get(player_name, DB.Enum.Trackable.ENDAMAGE_R, DB.Enum.Metric.TOTAL)
    local endebuff = DB.Data.Get(player_name, DB.Enum.Trackable.ENDEBUFF_R, DB.Enum.Metric.HIT_COUNT)
    local endrain  = DB.Data.Get(player_name, DB.Enum.Trackable.ENDRAIN_R,  DB.Enum.Metric.HIT_COUNT)
    local enaspir  = DB.Data.Get(player_name, DB.Enum.Trackable.ENDASPIR_R, DB.Enum.Metric.HIT_COUNT)

    Focus.Ranged.Total(player_name)
    Focus.Ranged.Auxiliary(player_name, endamage, endrain, enaspir)

    if endebuff > 0 or endamage > 0 then UI.Separator() end
    if endebuff > 0 then Focus.Catalog.Endebuff(player_name, DB.Enum.Trackable.ENDEBUFF_R) end
    if endamage > 0 then Focus.Catalog.Endamage(player_name, DB.Enum.Trackable.ENDAMAGE_R) end
end

------------------------------------------------------------------------------------------------------
-- Build total ranged damage table.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Ranged.Total = function(player_name)
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard
    local trackable = DB.Enum.Trackable.RANGED

    if UI.BeginTable("Ranged", 4, table_flags) then
        UI.TableSetupColumn("Ranged", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, width)
        UI.TableSetupColumn("Damage %", col_flags, width)
        UI.TableSetupColumn("Accuracy", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, true)
        UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable)

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Build misc. ranged damage table.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param endamage number
---@param endrain number
---@param enaspir number
------------------------------------------------------------------------------------------------------
Focus.Ranged.Auxiliary = function(player_name, endamage, endrain, enaspir)
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard
    local trackable = DB.Enum.Trackable.RANGED

    if UI.BeginTable("Aux. Ranged", 4, table_flags) then
        UI.TableSetupColumn("Auxiliary", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, width)
        UI.TableSetupColumn("Damage %", col_flags, width)
        UI.TableSetupColumn("Rate", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Crit. Hits")
        UI.TableNextColumn() Column.Proc.Crit_Damage(player_name, trackable)
        UI.TableNextColumn() Column.Proc.Crit_Damage(player_name, trackable, true)
        UI.TableNextColumn() Column.Proc.Crit_Rate(player_name, trackable)

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Square Hit")
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable, nil, DB.Enum.Metric.SQUARE_COUNT)

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Truestrike")
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable, nil, DB.Enum.Metric.TRUE_COUNT)

        if endamage > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("En-Damage")
            UI.TableNextColumn() UI.Text(Column.String.Format_Number(endamage))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        if endrain > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("En-Drain")
            UI.TableNextColumn() UI.Text(Column.String.Format_Number(endrain))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        if enaspir > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("En-Aspir")
            UI.TableNextColumn() UI.Text(Column.String.Format_Number(enaspir))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

