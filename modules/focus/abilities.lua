Focus.Abilities = {}

------------------------------------------------------------------------------------------------------
-- Loads data to the ability drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param hide_publish? boolean
------------------------------------------------------------------------------------------------------
Focus.Abilities.Display = function(player_name, hide_publish)
    local ability_total = DB.Data.Get(player_name, DB.Trackable.ABILITY_DAMAGING,    DB.Metric.ATTEMPTS_ON_USE)
    local rolls         = DB.Data.Get(player_name, DB.Trackable.PHANTOM_ROLL,        DB.Metric.ATTEMPTS_ON_USE)
    local maneuvers     = DB.Data.Get(player_name, DB.Trackable.MANEUVER,            DB.Metric.ATTEMPTS_ON_USE)
    local healing_total = DB.Data.Get(player_name, DB.Trackable.ABILITY_HEALING,     DB.Metric.ATTEMPTS_ON_USE)
    local mp_recovery   = DB.Data.Get(player_name, DB.Trackable.ABILITY_MP_RECOVERY, DB.Metric.ATTEMPTS_ON_USE)
    local misc_count    = DB.Data.Get(player_name, DB.Trackable.ABILITY_GENERAL,     DB.Metric.ATTEMPTS_ON_USE)

    local has_data = rolls > 0 or maneuvers > 0 or ability_total > 0 or healing_total > 0 or mp_recovery > 0 or misc_count > 0

    if has_data then
        if ability_total > 0 then Focus.Abilities.Damaging(player_name, DB.Trackable.ABILITY_DAMAGING, "Damaging") end
        if rolls > 0         then Focus.Abilities.Phantom_Roll(player_name, true) end
        if maneuvers > 0     then Focus.Abilities.Mauevers(player_name) end
        if healing_total > 0 then Focus.Abilities.Damaging(player_name, DB.Trackable.ABILITY_HEALING, "Healing") end
        if mp_recovery > 0   then Focus.Abilities.Damaging(player_name, DB.Trackable.ABILITY_MP_RECOVERY, "MP Recovery") end
        if misc_count > 0 then
            if Focus.Settings.Show_Misc_Actions then
                Focus.Abilities.Abilities_General(player_name)
            else
                UI.Text("Enable Misc. Actions to see additional data.")
            end
        end
        if not hide_publish then Focus.Abilities.Publish(player_name, ability_total, healing_total) end
    else
        UI.Text("No ability data available for this player.")
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for abilities inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the data model.
---@param header string header title for the name column.
---@param make_brief? boolean
------------------------------------------------------------------------------------------------------
Focus.Abilities.Damaging = function(player_name, trackable, header, make_brief)
    if not DB.Tracking.Trackable[trackable] then return nil end
    if not DB.Tracking.Trackable[trackable][player_name] then return nil end

    local table_flags = Focus.Catalog.Table_Flags
    local col_flags   = Focus.Catalog.Column_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local columns = 8
    if make_brief then columns = 3 end

    if UI.BeginTable(trackable, columns, table_flags) then
        UI.TableSetupColumn(header,     col_flags, name_width)
        UI.TableSetupColumn("Average",  col_flags, width)
        if not make_brief then UI.TableSetupColumn("%Player",  col_flags, width) end
        if not make_brief then UI.TableSetupColumn("Accuracy", col_flags, width) end
        UI.TableSetupColumn("Uses",     col_flags, width)
        if not make_brief then UI.TableSetupColumn("Total",    col_flags, width) end
        if not make_brief then UI.TableSetupColumn("Minimum",  col_flags, width) end
        if not make_brief then UI.TableSetupColumn("Maximum",  col_flags, width) end
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn()                        Column.Damage.By_Type_Average(player_name, trackable)
        if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, DB.Metric.TOTAL, nil, true) end
        if not make_brief then UI.TableNextColumn() Column.Acc.By_Type(player_name,            trackable) end
        UI.TableNextColumn()                        Column.Damage.Attempts(player_name,        trackable)
        if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, DB.Metric.TOTAL) end
        if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, DB.Metric.MIN) end
        if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, DB.Metric.MAX) end
        Window_Manager.Table_Row_Color(1)

        local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
        local action_name
        for _, data in ipairs(sorted_damage) do
            action_name = data[1]
            UI.TableNextColumn() UI.Text("- " .. action_name)
            UI.TableNextColumn()                        Column.Damage.By_Type_Average(player_name, trackable, nil, action_name)
            if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, DB.Metric.TOTAL, action_name, true) end
            if not make_brief then UI.TableNextColumn() Column.Acc.By_Type(player_name,            trackable, nil, nil, action_name) end
            UI.TableNextColumn()                        Column.Damage.Attempts(player_name,        trackable, nil, action_name)
            if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, DB.Metric.TOTAL, action_name) end
            if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, DB.Metric.MIN, action_name) end
            if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, DB.Metric.MAX, action_name) end
            Window_Manager.Table_Row_Color(0)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for general abilities inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Abilities.Abilities_General = function(player_name)
    local trackable = DB.Trackable.ABILITY_GENERAL
    if not DB.Tracking.Trackable[trackable] then return nil end
    if not DB.Tracking.Trackable[trackable][player_name] then return nil end

    local table_flags = Focus.Catalog.Table_Flags
    local col_flags   = Focus.Catalog.Column_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    if UI.BeginTable(trackable, 2, table_flags) then
        UI.TableSetupColumn("General", col_flags, name_width)
        UI.TableSetupColumn("Uses", col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
        local action_name
        local row = 1
        for _, data in ipairs(sorted_damage) do
            action_name = data[1]
            UI.TableNextColumn() UI.Text(action_name)
            UI.TableNextColumn() Column.Damage.Attempts(player_name, trackable, nil, action_name)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for general abilities inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Abilities.Mauevers = function(player_name)
    local trackable = DB.Trackable.MANEUVER
    if not DB.Tracking.Trackable[trackable] then return nil end
    if not DB.Tracking.Trackable[trackable][player_name] then return nil end

    local table_flags = Focus.Catalog.Table_Flags
    local col_flags   = Focus.Catalog.Column_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    if UI.BeginTable(trackable, 3, table_flags) then
        UI.TableSetupColumn("Maneuver", col_flags, name_width)
        UI.TableSetupColumn("Uses", col_flags, width)
        UI.TableSetupColumn("Overload", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.Attempts(player_name, trackable)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.OVERLOAD)
        Window_Manager.Table_Row_Color(1)

        local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
        local action_name
        for _, data in ipairs(sorted_damage) do
            action_name = data[1]
            UI.TableNextColumn() UI.Text("- " .. action_name)
            UI.TableNextColumn() Column.Damage.Attempts(player_name, trackable, nil, action_name)
            UI.TableNextColumn() Column.Damage.By_Type(player_name,  trackable, DB.Metric.OVERLOAD, action_name)
            Window_Manager.Table_Row_Color(0)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows phantom roll overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param full? boolean
------------------------------------------------------------------------------------------------------
Focus.Abilities.Phantom_Roll = function(player_name, full)
    if not player_name then return nil end
    local trackable = DB.Trackable.PHANTOM_ROLL
    if not DB.Tracking.Trackable[trackable] then return nil end
    if not DB.Tracking.Trackable[trackable][player_name] then return nil end

    local col_flags   = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local columns = 5
    if full then columns = columns + 2 end

    if UI.BeginTable("Phantom Roll", columns, table_flags) then
        UI.TableSetupColumn("Phantom Roll", col_flags, name_width)
        UI.TableSetupColumn("Rolls", col_flags, width)
        if full then UI.TableSetupColumn("Re-Rolls", col_flags, width) end
        UI.TableSetupColumn("%Lucky", col_flags, width)
        if full then UI.TableSetupColumn("%Lucky 11", col_flags, width) end
        UI.TableSetupColumn("%Unlucky", col_flags, width)
        UI.TableSetupColumn("%Busts", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn()              Column.Damage.Attempts(player_name,  trackable, nil, nil, true)
        if full then UI.TableNextColumn() Column.Damage.By_Type(player_name,   trackable, DB.Metric.REROLL) end
        UI.TableNextColumn()              Column.Acc.Phantom_Roll(player_name, DB.Metric.LUCKY)
        if full then UI.TableNextColumn() Column.Acc.Phantom_Roll(player_name, DB.Metric.LUCKY_11) end
        UI.TableNextColumn()              Column.Acc.Phantom_Roll(player_name, DB.Metric.UNLUCKY)
        UI.TableNextColumn()              Column.Acc.Phantom_Roll(player_name, DB.Metric.BUSTS)
        Window_Manager.Table_Row_Color(1)

        local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
        local action_name
        for _, data in ipairs(sorted_damage) do
            action_name = data[1]
            UI.TableNextColumn() UI.Text("- " .. action_name)
            UI.TableNextColumn()              Column.Damage.Attempts(player_name,  trackable, nil, action_name, true)
            if full then UI.TableNextColumn() Column.Damage.By_Type(player_name,   trackable, DB.Metric.REROLL, action_name) end
            UI.TableNextColumn()              Column.Acc.Phantom_Roll(player_name, DB.Metric.LUCKY, action_name)
            if full then UI.TableNextColumn() Column.Acc.Phantom_Roll(player_name, DB.Metric.LUCKY_11, action_name) end
            UI.TableNextColumn()              Column.Acc.Phantom_Roll(player_name, DB.Metric.UNLUCKY, action_name)
            UI.TableNextColumn()              Column.Acc.Phantom_Roll(player_name, DB.Metric.BUSTS, action_name)
            Window_Manager.Table_Row_Color(0)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows ability overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param ability_list table
------------------------------------------------------------------------------------------------------
Focus.Abilities.From_List = function(player_name, ability_list)
    if not player_name or not ability_list then return nil end

    local col_flags   = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    if UI.BeginTable("Ability", 2, table_flags) then
        UI.TableSetupColumn("Abilities", col_flags, name_width)
        UI.TableSetupColumn("Uses", col_flags, width)
        UI.TableHeadersRow()

        local row = 1
        for _, ability_name in ipairs(ability_list) do
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(ability_name)
            UI.TableNextColumn() Column.Damage.Attempts(player_name, DB.Trackable.ABILITY_OVERALL, nil, ability_name)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up ability publishing buttons from within the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param ability_total number
---@param healing_total number
------------------------------------------------------------------------------------------------------
Focus.Abilities.Publish = function(player_name, ability_total, healing_total)
    if ability_total > 0 then
        Report.Widgets.Button(player_name, DB.Trackable.ABILITY_DAMAGING, "Publish Abilities")
    end
    if healing_total > 0 then
        if ability_total > 0 then UI.SameLine() UI.Text(" ") UI.SameLine() end
        Report.Widgets.Button(player_name, DB.Trackable.ABILITY_HEALING, "Publish Healing")
    end
end