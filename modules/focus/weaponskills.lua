Focus.WS = {}

------------------------------------------------------------------------------------------------------
-- Loads data to the weaponskill and skillchain drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param hide_publish? boolean
------------------------------------------------------------------------------------------------------
Focus.WS.Display = function(player_name, hide_publish)
    local trackable_ws = DB.Trackable.WEAPONSKILL
    local trackable_mp = DB.Trackable.WEAPONSKILL_MP_DRAIN
    local trackable_sc = DB.Trackable.SKILLCHAIN

    local weaponskills_found   = DB.Tracking.Trackable[trackable_ws] and DB.Tracking.Trackable[trackable_ws][player_name]
    local mp_weaponskill_found = DB.Tracking.Trackable[trackable_mp] and DB.Tracking.Trackable[trackable_mp][player_name]
    local skillchains_found    = DB.Tracking.Trackable[trackable_sc] and DB.Tracking.Trackable[trackable_sc][player_name]

    -- No data found message.
    if not weaponskills_found and not skillchains_found and not mp_weaponskill_found then
        UI.Text("No weaponskill or skillchain data available for this player.")
    end

    -- Display the weaponskill and skillchain data.
    if weaponskills_found   then Focus.WS.Weaponskill(player_name) end
    if mp_weaponskill_found then Focus.WS.Weaponskill(player_name, nil, true) end
    if skillchains_found    then Focus.WS.Skillchains(player_name) end

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
---@param make_brief? boolean
---@param is_mp_drain? boolean
------------------------------------------------------------------------------------------------------
Focus.WS.Weaponskill = function(player_name, make_brief, is_mp_drain)
    local trackable = DB.Trackable.WEAPONSKILL
    if is_mp_drain then trackable = DB.Trackable.WEAPONSKILL_MP_DRAIN end

    if not DB.Tracking.Trackable[trackable] then return nil end
    if not DB.Tracking.Trackable[trackable][player_name] then return nil end

    local table_flags = Focus.Catalog.Table_Flags
    local col_flags   = Focus.Catalog.Column_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local columns = 10
    if make_brief then columns = 4 end

    local header = "Weaponskill"
    if is_mp_drain then header = header .. " (MP)" end

    if UI.BeginTable(trackable, columns, table_flags) then
        UI.TableSetupColumn(header,     col_flags, name_width)
        UI.TableSetupColumn("Average",  col_flags, width)
        if not make_brief then UI.TableSetupColumn("%Player",  col_flags, width) end
        UI.TableSetupColumn("Accuracy", col_flags, width)
        if not make_brief then UI.TableSetupColumn("Attempts", col_flags, width) end
        if not make_brief then UI.TableSetupColumn("Damage",   col_flags, width) end
        if not make_brief then UI.TableSetupColumn("DMG/TP",   col_flags, width) end
        UI.TableSetupColumn("~TP",      col_flags, width)
        if not make_brief then UI.TableSetupColumn("Minimum",  col_flags, width) end
        if not make_brief then UI.TableSetupColumn("Maximum",  col_flags, width) end
        UI.TableHeadersRow()

        -- All Weaponskills
        local row = 1
        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn()                        Column.Damage.By_Type_Average(player_name,  trackable)
        if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,          trackable, nil, nil, true) end
        UI.TableNextColumn()                        Column.Acc.By_Type(player_name,             trackable)
        if not make_brief then UI.TableNextColumn() Column.Damage.Attempts(player_name,         trackable) end
        if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,          trackable) end
        if not make_brief then UI.TableNextColumn() Column.Damage.Per_Unit(player_name,         trackable, DB.Metric.TP_SPENT) end
        UI.TableNextColumn()                        Column.Damage.Per_Unit_Average(player_name, trackable, DB.Metric.TP_SPENT)
        if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,          trackable, DB.Metric.MIN) end
        if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,          trackable, DB.Metric.MAX) end
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        -- Specific Weaponskills
        local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
        local action_name
        for _, data in ipairs(sorted_damage) do
            action_name = data[1]
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("- " .. action_name)
            UI.TableNextColumn()                        Column.Damage.By_Type_Average(player_name,  trackable, nil, action_name)
            if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,          trackable, nil, action_name, true) end
            UI.TableNextColumn()                        Column.Acc.By_Type(player_name,             trackable, nil, false, action_name)
            if not make_brief then UI.TableNextColumn() Column.Damage.Attempts(player_name,         trackable, nil, action_name) end
            if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,          trackable, nil, action_name) end
            if not make_brief then UI.TableNextColumn() Column.Damage.Per_Unit(player_name,         trackable, DB.Metric.TP_SPENT, action_name) end
            UI.TableNextColumn()                        Column.Damage.Per_Unit_Average(player_name, trackable, DB.Metric.TP_SPENT, action_name)
            if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,          trackable, DB.Metric.MIN, action_name) end
            if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,          trackable, DB.Metric.MAX, action_name) end
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
---@param make_brief? boolean
------------------------------------------------------------------------------------------------------
Focus.WS.Skillchains = function(player_name, make_brief)
    local trackable = DB.Trackable.SKILLCHAIN
    if not DB.Tracking.Trackable[trackable] then return nil end
    if not DB.Tracking.Trackable[trackable][player_name] then return nil end

    local table_flags = Focus.Catalog.Table_Flags
    local col_flags   = Focus.Catalog.Column_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local columns = 7
    if make_brief then columns = 3 end
    local including_skillchain = Parse.Config.Include_SC_Damage()
    if including_skillchain and not make_brief then columns = columns + 1 end

    if UI.BeginTable(trackable, columns, table_flags) then
        UI.TableSetupColumn("Skillchain", col_flags, name_width)
        if not make_brief then UI.TableSetupColumn("Average", col_flags, width) end
        if including_skillchain then UI.TableSetupColumn("%Player", col_flags, width) end
        UI.TableSetupColumn("Opened",     col_flags, width)
        UI.TableSetupColumn("Closed",     col_flags, width)
        if not make_brief then UI.TableSetupColumn("Total",   col_flags, width) end
        if not make_brief then UI.TableSetupColumn("Minimum", col_flags, width) end
        if not make_brief then UI.TableSetupColumn("Maximum", col_flags, width) end
        UI.TableHeadersRow()

        -- All Skillchains
        local row = 1
        UI.TableNextColumn() UI.Text("Total")
        if not make_brief then UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable) end
        if including_skillchain then UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, nil, nil, true) end
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.SKILLCHAIN_OPENED)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.SKILLCHAIN_CLOSED)
        if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable) end
        if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MIN) end
        if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MAX) end
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        -- Specific Skillchains
        local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
        local action_name
        for _, data in ipairs(sorted_damage) do
            action_name = data[1]
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("- " .. action_name)
            if not make_brief then UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable, nil, action_name) end
            if including_skillchain then UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.TOTAL, action_name, true) end
            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.SKILLCHAIN_OPENED, action_name)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.SKILLCHAIN_CLOSED, action_name)
            if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.TOTAL, action_name) end
            if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MIN, action_name) end
            if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MAX, action_name) end
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        UI.EndTable()
    end
end