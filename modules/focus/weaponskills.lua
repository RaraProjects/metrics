Focus.WS = T{}

------------------------------------------------------------------------------------------------------
-- Loads data to the weaponskill and skillchain drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param hide_publish? boolean
------------------------------------------------------------------------------------------------------
Focus.WS.Display = function(player_name, hide_publish)
    local col_flags = Column.Flags.None
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local trackable_ws = DB.Enum.Trackable.WS
    local trackable_sc = DB.Enum.Trackable.SC

    if UI.BeginTable("WS and SC", 6, table_flags) then
        UI.TableSetupColumn("Type", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, width)
        UI.TableSetupColumn("Damage %", col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("Accuracy", col_flags, width)
        UI.TableSetupColumn("TP Spent", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Weaponskills")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable_ws)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable_ws, true)
        UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, DB.Enum.Trackable.WS)
        UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable_ws)
        UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable_ws, DB.Enum.Metric.TP_SPENT)

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Skillchains")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable_sc)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable_sc, true)
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        UI.EndTable()
    end

    -- Cataloged data
    local show_ws_publish = false
    local show_sc_publish = false
    if DB.Tracking.Trackable[DB.Enum.Trackable.WS] and DB.Tracking.Trackable[DB.Enum.Trackable.WS][player_name] then
        Focus.Catalog.Single(player_name, DB.Enum.Trackable.WS)
        show_ws_publish = true
    end

    if DB.Tracking.Trackable[DB.Enum.Trackable.SC] and DB.Tracking.Trackable[DB.Enum.Trackable.SC][player_name] then
        Focus.Catalog.Single(player_name, DB.Enum.Trackable.SC)
        show_sc_publish = true
    end

    -- Publish buttons
    if not hide_publish then
        if show_ws_publish then
            Report.Widgets.Button(player_name, trackable_ws, "Publish Weaponskills")
        end
        if show_sc_publish then
            UI.SameLine() UI.Text(" ") UI.SameLine()
            Report.Widgets.Button(player_name, trackable_sc, "Publish Skillchains")
        end
    end
end