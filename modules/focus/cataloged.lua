Focus.Catalog = {}

Focus.Catalog.Table_Flags  = Window_Manager.Table.Flags.Fixed_Borders
Focus.Catalog.Column_Flags = Column.Flags.None
Focus.Catalog.Column_Width = Column.Widths.Standard

------------------------------------------------------------------------------------------------------
-- Sets up the table for abilities inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the data model.
---@param action_string string header title for the name column.
------------------------------------------------------------------------------------------------------
Focus.Catalog.Abilities = function(player_name, trackable, action_string)
    if not DB.Tracking.Trackable[trackable] then return nil end
    if not DB.Tracking.Trackable[trackable][player_name] then return nil end

    local table_flags = Focus.Catalog.Table_Flags
    local col_flags   = Focus.Catalog.Column_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    if UI.BeginTable(trackable, 7, table_flags) then
        UI.TableSetupColumn(action_string, col_flags, name_width)
        UI.TableSetupColumn("Total",       col_flags, width)
        UI.TableSetupColumn("Uses",        col_flags, width)
        UI.TableSetupColumn("Accuracy",    col_flags, width)
        UI.TableSetupColumn("Average",     col_flags, width)
        UI.TableSetupColumn("Minimum",     col_flags, width)
        UI.TableSetupColumn("Maximum",     col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
        local action_name
        local row = 1
        for _, data in ipairs(sorted_damage) do
            action_name = data[1]
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(action_name)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.TOTAL, action_name)
            UI.TableNextColumn() Column.Single.Attempts(player_name, action_name, trackable)
            UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable, 0, false, action_name)
            Focus.Catalog.Avg_Min_Max(player_name, action_name, trackable)
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
    local focus_type = DB.Trackable.ABILITY_GENERAL
    if not DB.Tracking.Trackable[focus_type] then return nil end
    if not DB.Tracking.Trackable[focus_type][player_name] then return nil end

    local table_flags = Focus.Catalog.Table_Flags
    local col_flags   = Focus.Catalog.Column_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    if UI.BeginTable(focus_type, 2, table_flags) then
        UI.TableSetupColumn("General", col_flags, name_width)
        UI.TableSetupColumn("Uses",    col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, focus_type)
        local action_name
        local row = 1
        for _, data in ipairs(sorted_damage) do
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
    local col_flags   = Focus.Catalog.Column_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    if not suffix then suffix = "" end
    if UI.BeginTable(focus_type, 6, table_flags) then
        UI.TableSetupColumn("Endamage" .. suffix, col_flags, name_width)
        UI.TableSetupColumn("Total",   col_flags, width)
        UI.TableSetupColumn("Procs",   col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("Minimum", col_flags, width)
        UI.TableSetupColumn("Maximum", col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, focus_type)
        local action_name
        for _, data in ipairs(sorted_damage) do
            action_name = data[1]
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(action_name)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, focus_type, DB.Metric.TOTAL, action_name)
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
    local col_flags   = Focus.Catalog.Column_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    if not suffix then suffix = "" end
    if UI.BeginTable(focus_type, 2, table_flags) then
        UI.TableSetupColumn("Endebuff" .. suffix, col_flags, name_width)
        UI.TableSetupColumn("Procs", col_flags, width)
        UI.TableHeadersRow()

        local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, focus_type)
        local action_name
        for _, data in ipairs(sorted_damage) do
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
---@param trackable string
------------------------------------------------------------------------------------------------------
Focus.Catalog.Min = function(player_name, action_name, trackable)
    local min = DB.Catalog.Get(player_name, trackable, action_name, DB.Metric.MIN)
    if min == DB.Enum.MAX_DAMAGE then
        Column.Damage.By_Type(player_name, trackable, DB.Enum.IGNORE, action_name)
    else
        Column.Damage.By_Type(player_name, trackable, DB.Metric.MIN, action_name)
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Average, Minimum, and Maximum columns for a cataloged action.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param trackable string
------------------------------------------------------------------------------------------------------
Focus.Catalog.Avg_Min_Max = function(player_name, action_name, trackable)
    UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, trackable, action_name)
    UI.TableNextColumn() Focus.Catalog.Min(player_name, action_name, trackable)
    UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable, DB.Metric.MAX, action_name)
end