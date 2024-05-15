Focus.WS = T{}

------------------------------------------------------------------------------------------------------
-- Loads data to the weaponskill and skillchain drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.WS.Display = function(player_name)
    -- GUI configuration
    local col_flags = Column.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local name_width = Column.Widths.Standard
    local damage_width = Column.Widths.Damage
    local percent_width = Column.Widths.Percent

    -- Data setup
    local trackable_ws = DB.Enum.Trackable.WS
    local trackable_sc = DB.Enum.Trackable.SC

    -- Basic stats
    if UI.BeginTable("WS and SC", 4, table_flags) then
        UI.TableSetupColumn("Type", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Damage %", col_flags, damage_width)
        UI.TableSetupColumn("Accuracy", col_flags, damage_width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Weaponskills")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable_ws)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable_ws, true)
        UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable_ws)

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Skillchains")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable_sc)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable_sc, true)
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
    if show_ws_publish then
        Report.Widgets.Button(player_name, trackable_ws, "Publish Weaponskills")
    end
    if show_sc_publish then
        UI.SameLine() UI.Text(" ") UI.SameLine()
        Report.Widgets.Button(player_name, trackable_sc, "Publish Skillchains")
    end
end