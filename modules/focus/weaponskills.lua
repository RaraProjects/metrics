Focus.WS = {}

------------------------------------------------------------------------------------------------------
-- Loads data to the weaponskill and skillchain drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param hide_publish? boolean
------------------------------------------------------------------------------------------------------
Focus.WS.Display = function(player_name, hide_publish)
    local trackable_ws = DB.Trackable.WEAPONSKILL
    local trackable_sc = DB.Trackable.SKILLCHAIN

    local weaponskills_found = DB.Tracking.Trackable[trackable_ws] and DB.Tracking.Trackable[trackable_ws][player_name]
    local skillchains_found  = DB.Tracking.Trackable[trackable_sc] and DB.Tracking.Trackable[trackable_sc][player_name]

    -- No data found message.
    if not weaponskills_found and not skillchains_found then
        UI.Text("No weaponskill or skillchain data available for this player.")
    end

    -- Display the weaponskill and skillchain data.
    if weaponskills_found then Focus.WS.Weaponskill(player_name, trackable_ws) end
    if skillchains_found  then Focus.WS.Skillchains(player_name, trackable_sc) end

    -- Publish buttons
    if not hide_publish then
        if weaponskills_found then
            Report.Widgets.Button(player_name, trackable_ws, "Publish Weaponskills")
        end
        if skillchains_found then
            UI.SameLine() UI.Text(" ") UI.SameLine()
            Report.Widgets.Button(player_name, trackable_sc, "Publish Skillchains")
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for the weaponskill list inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the data model.
------------------------------------------------------------------------------------------------------
Focus.WS.Weaponskill = function(player_name, trackable)
    if not DB.Tracking.Trackable[trackable] then return nil end
    if not DB.Tracking.Trackable[trackable][player_name] then return nil end

    local table_flags = Focus.Catalog.Table_Flags
    local col_flags   = Focus.Catalog.Column_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    if UI.BeginTable(trackable, 10, table_flags) then
        UI.TableSetupColumn("Weaponskill", col_flags, name_width)
        UI.TableSetupColumn("Average",     col_flags, width)
        UI.TableSetupColumn("%Player",     col_flags, width)
        UI.TableSetupColumn("Accuracy",    col_flags, width)
        UI.TableSetupColumn("Attempts",    col_flags, width)
        UI.TableSetupColumn("Total",       col_flags, width)
        UI.TableSetupColumn("DMG/TP",      col_flags, width)
        UI.TableSetupColumn("~TP",         col_flags, width)
        UI.TableSetupColumn("Minimum",     col_flags, width)
        UI.TableSetupColumn("Maximum",     col_flags, width)
        UI.TableHeadersRow()

        -- All Weaponskills
        local row = 1
        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, nil, nil, true)
        UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable)
        UI.TableNextColumn() Column.Single.Attempts(player_name, nil, trackable)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
        UI.TableNextColumn() Column.Damage.Per_Unit(player_name, trackable, DB.Metric.TP_SPENT)
        UI.TableNextColumn() Column.Single.Per_Unit_Average(player_name, trackable, DB.Metric.TP_SPENT)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MIN)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MAX)
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        -- Specific Weaponskills
        local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
        local action_name
        for _, data in ipairs(sorted_damage) do
            action_name = data[1]
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(action_name)
            UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable, action_name)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, nil, action_name, true)
            UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable, nil, false, action_name)
            UI.TableNextColumn() Column.Single.Attempts(player_name, action_name, trackable)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, nil, action_name)
            UI.TableNextColumn() Column.Damage.Per_Unit(player_name, trackable, DB.Metric.TP_SPENT, action_name)
            UI.TableNextColumn() Column.Single.Per_Unit_Average(player_name, trackable, DB.Metric.TP_SPENT, action_name)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MIN, action_name)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MAX, action_name)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for the skillchain list inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the data model.
------------------------------------------------------------------------------------------------------
Focus.WS.Skillchains = function(player_name, trackable)
    if not DB.Tracking.Trackable[trackable] then return nil end
    if not DB.Tracking.Trackable[trackable][player_name] then return nil end

    local table_flags = Focus.Catalog.Table_Flags
    local col_flags   = Focus.Catalog.Column_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local columns = 7
    local including_skillchain = Parse.Config.Include_SC_Damage()
    if including_skillchain then columns = columns + 1 end

    if UI.BeginTable(trackable, columns, table_flags) then
        UI.TableSetupColumn("Skillchain", col_flags, name_width)
        UI.TableSetupColumn("Average",    col_flags, width)
        if including_skillchain then UI.TableSetupColumn("%Player", col_flags, width) end
        UI.TableSetupColumn("Opened",     col_flags, width)
        UI.TableSetupColumn("Closed",     col_flags, width)
        UI.TableSetupColumn("Total",      col_flags, width)
        UI.TableSetupColumn("Minimum",    col_flags, width)
        UI.TableSetupColumn("Maximum",    col_flags, width)
        UI.TableHeadersRow()

        -- All Skillchains
        local row = 1
        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable)
        if including_skillchain then UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, nil, nil, true) end
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.SKILLCHAIN_OPENED)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.SKILLCHAIN_CLOSED)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MIN)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MAX)
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        -- Specific Skillchains
        local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
        local action_name
        for _, data in ipairs(sorted_damage) do
            action_name = data[1]
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(action_name)
            UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable, action_name)
            if including_skillchain then UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.TOTAL, action_name, true) end
            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.SKILLCHAIN_OPENED, action_name)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.SKILLCHAIN_CLOSED, action_name)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.TOTAL, action_name)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MIN, action_name)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MAX, action_name)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        UI.EndTable()
    end
end