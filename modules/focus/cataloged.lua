Focus.Catalog = T{}

Focus.Catalog.Table_Flags = Window_Manager.Table.Flags.Fixed_Borders
Focus.Catalog.Column_Flags = Column.Flags.None
Focus.Catalog.Column_Width = Column.Widths.Standard

------------------------------------------------------------------------------------------------------
-- Sets up the table for the weaponskill list inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param focus_type string a trackable from the data model.
------------------------------------------------------------------------------------------------------
Focus.Catalog.Weaponskill = function(player_name, focus_type)
    if not DB.Tracking.Trackable[focus_type] then return nil end
    if not DB.Tracking.Trackable[focus_type][player_name] then return nil end

    local table_flags = Focus.Catalog.Table_Flags
    local col_flags = Focus.Catalog.Column_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if UI.BeginTable(focus_type, 9, table_flags) then
        UI.TableSetupColumn("Weaponskill", col_flags, name_width)
        UI.TableSetupColumn("Total", col_flags, width)
        UI.TableSetupColumn("~TP", col_flags, width)
        UI.TableSetupColumn("DMG/TP", col_flags, width)
        UI.TableSetupColumn("Attempts", col_flags, width)
        UI.TableSetupColumn("Accuracy", col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("Minimum", col_flags, width)
        UI.TableSetupColumn("Maximum", col_flags, width)
        UI.TableHeadersRow()

        DB.Lists.Sort.Catalog_Damage(player_name, focus_type)
        local action_name
        local row = 1
        for _, data in ipairs(DB.Sorted.Catalog_Damage) do
            action_name = data[1]
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(action_name)
            UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.TOTAL)
            UI.TableNextColumn() Column.Single.Average_TP(player_name, action_name)
            UI.TableNextColumn() Column.Single.Damage_Per_Unit(player_name, action_name, focus_type, DB.Enum.Metric.TP_SPENT)
            UI.TableNextColumn() Column.Single.Attempts(player_name, action_name, focus_type)
            UI.TableNextColumn() Column.Single.Acc(player_name, action_name, focus_type)
            Focus.Catalog.Avg_Min_Max(player_name, action_name, focus_type)
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
---@param focus_type string a trackable from the data model.
------------------------------------------------------------------------------------------------------
Focus.Catalog.Skillchains = function(player_name, focus_type)
    if not DB.Tracking.Trackable[focus_type] then return nil end
    if not DB.Tracking.Trackable[focus_type][player_name] then return nil end

    local table_flags = Focus.Catalog.Table_Flags
    local col_flags = Focus.Catalog.Column_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if UI.BeginTable(focus_type, 7, table_flags) then
        UI.TableSetupColumn("Skillchain", col_flags, name_width)
        UI.TableSetupColumn("Total", col_flags, width)
        UI.TableSetupColumn("Opened", col_flags, width)
        UI.TableSetupColumn("Closed", col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("Minimum", col_flags, width)
        UI.TableSetupColumn("Maximum", col_flags, width)
        UI.TableHeadersRow()

        DB.Lists.Sort.Catalog_Damage(player_name, focus_type)
        local action_name
        local row = 1
        for _, data in ipairs(DB.Sorted.Catalog_Damage) do
            action_name = data[1]
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(action_name)
            UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.TOTAL)
            UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, H.Metric.SC_OPENED)
            UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, H.Metric.SC_CLOSED)
            Focus.Catalog.Avg_Min_Max(player_name, action_name, focus_type)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for abilities inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param focus_type string a trackable from the data model.
---@param action_string string header title for the name column.
------------------------------------------------------------------------------------------------------
Focus.Catalog.Abilities = function(player_name, focus_type, action_string)
    if not DB.Tracking.Trackable[focus_type] then return nil end
    if not DB.Tracking.Trackable[focus_type][player_name] then return nil end

    local table_flags = Focus.Catalog.Table_Flags
    local col_flags = Focus.Catalog.Column_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if UI.BeginTable(focus_type, 7, table_flags) then
        UI.TableSetupColumn(action_string, col_flags, name_width)
        UI.TableSetupColumn("Total",       col_flags, width)
        UI.TableSetupColumn("Uses",    col_flags, width)
        UI.TableSetupColumn("Accuracy",  col_flags, width)
        UI.TableSetupColumn("Average",     col_flags, width)
        UI.TableSetupColumn("Minimum",     col_flags, width)
        UI.TableSetupColumn("Maximum",     col_flags, width)
        UI.TableHeadersRow()

        DB.Lists.Sort.Catalog_Damage(player_name, focus_type)
        local action_name
        local row = 1
        for _, data in ipairs(DB.Sorted.Catalog_Damage) do
            action_name = data[1]
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(action_name)
            UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.TOTAL)
            UI.TableNextColumn() Column.Single.Attempts(player_name, action_name, focus_type)
            UI.TableNextColumn() Column.Single.Acc(player_name, action_name, focus_type)
            Focus.Catalog.Avg_Min_Max(player_name, action_name, focus_type)
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
Focus.Catalog.Abilities_General = function(player_name)
    local focus_type = H.Trackable.ABILITY_GENERAL
    if not DB.Tracking.Trackable[focus_type] then return nil end
    if not DB.Tracking.Trackable[focus_type][player_name] then return nil end

    local table_flags = Focus.Catalog.Table_Flags
    local col_flags = Focus.Catalog.Column_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if UI.BeginTable(focus_type, 2, table_flags) then
        UI.TableSetupColumn("General", col_flags, name_width)
        UI.TableSetupColumn("Uses",    col_flags, width)
        UI.TableHeadersRow()

        DB.Lists.Sort.Catalog_Damage(player_name, focus_type)
        local action_name
        local row = 1
        for _, data in ipairs(DB.Sorted.Catalog_Damage) do
            action_name = data[1]
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(action_name)
            UI.TableNextColumn() Column.Single.Attempts(player_name, action_name, focus_type)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end
        UI.EndTable()
    end
end


------------------------------------------------------------------------------------------------------
-- Sets up the table for a endamage inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param focus_type string a trackable from the data model.
---@param suffix? string append a suffix to the header to help distinguish between melee and ranged.
------------------------------------------------------------------------------------------------------
Focus.Catalog.Endamage = function(player_name, focus_type, suffix)
    if not DB.Tracking.Trackable[focus_type] then return nil end
    if not DB.Tracking.Trackable[focus_type][player_name] then return nil end

    local table_flags = Focus.Catalog.Table_Flags
    local col_flags = Focus.Catalog.Column_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if not suffix then suffix = "" end
    if UI.BeginTable(focus_type, 6, table_flags) then
        UI.TableSetupColumn("Endamage" .. suffix, col_flags, name_width)
        UI.TableSetupColumn("Total",   col_flags, width)
        UI.TableSetupColumn("Procs",   col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("Minimum", col_flags, width)
        UI.TableSetupColumn("Maximum", col_flags, width)
        UI.TableHeadersRow()

        DB.Lists.Sort.Catalog_Damage(player_name, focus_type)
        local action_name
        for _, data in ipairs(DB.Sorted.Catalog_Damage) do
            action_name = data[1]
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(action_name)
            UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.TOTAL)
            UI.TableNextColumn() Column.Single.Hit_Count(player_name, focus_type, action_name)
            Focus.Catalog.Avg_Min_Max(player_name, action_name, focus_type)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for endebuff inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param focus_type string a trackable from the data model.
---@param suffix? string append a suffix to the header to help distinguish between melee and ranged.
------------------------------------------------------------------------------------------------------
Focus.Catalog.Endebuff = function(player_name, focus_type, suffix)
    if not DB.Tracking.Trackable[focus_type] then return nil end
    if not DB.Tracking.Trackable[focus_type][player_name] then return nil end

    local table_flags = Focus.Catalog.Table_Flags
    local col_flags = Focus.Catalog.Column_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if not suffix then suffix = "" end
    if UI.BeginTable(focus_type, 2, table_flags) then
        UI.TableSetupColumn("Endebuff" .. suffix, col_flags, name_width)
        UI.TableSetupColumn("Procs", col_flags, width)
        UI.TableHeadersRow()

        DB.Lists.Sort.Catalog_Damage(player_name, focus_type)
        local action_name
        for _, data in ipairs(DB.Sorted.Catalog_Damage) do
            action_name = data[1]
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(action_name)
            UI.TableNextColumn() Column.Single.Hit_Count(player_name, focus_type, action_name)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Minimum column for a cataloged action.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param focus_type string
------------------------------------------------------------------------------------------------------
Focus.Catalog.Min = function(player_name, action_name, focus_type)
    local min = DB.Catalog.Get(player_name, focus_type, action_name, DB.Enum.Metric.MIN)
    if min == DB.Enum.Values.MAX_DAMAGE then
        Column.Single.Damage(player_name, action_name, focus_type, DB.Enum.Values.IGNORE)
    else
        Column.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.MIN)
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Average, Minimum, and Maximum columns for a cataloged action.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param focus_type string
------------------------------------------------------------------------------------------------------
Focus.Catalog.Avg_Min_Max = function(player_name, action_name, focus_type)
    UI.TableNextColumn() Column.Single.Average(player_name, action_name, focus_type)
    UI.TableNextColumn() Focus.Catalog.Min(player_name, action_name, focus_type)
    UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.MAX)
end