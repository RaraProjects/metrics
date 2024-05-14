Focus.Catalog = T{}

------------------------------------------------------------------------------------------------------
-- Sets up the table for a trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param focus_type string a trackable from the data model.
------------------------------------------------------------------------------------------------------
Focus.Catalog.Single = function(player_name, focus_type)
    if not focus_type then return nil end
    local table_flags = Window.Table.Flags.Fixed_Borders
    local col_flags = Window.Columns.Flags.None
    local width = Window.Columns.Widths.Standard

    -- Error Protection
    if not DB.Tracking.Trackable[focus_type] then return nil end
    if not DB.Tracking.Trackable[focus_type][player_name] then return nil end

    local acc_string = "Accuracy %"
    local damage_string = "Damage"
    local action_string = "Action"
    local attempt_string = "Attempts"
    if focus_type == DB.Enum.Trackable.MAGIC then
        action_string = "Spell"
        acc_string = "Bursts"
        attempt_string = "Casts (MP)"
    elseif focus_type == DB.Enum.Trackable.HEALING then
        action_string = "Spell"
        acc_string = "Overcure"
        damage_string = "Healing"
        attempt_string = "Casts (MP)"
    elseif focus_type == DB.Enum.Trackable.ABILITY or focus_type == DB.Enum.Trackable.PET_ABILITY or focus_type == DB.Enum.Trackable.PET_WS then
        action_string = "Ability"
    elseif focus_type == DB.Enum.Trackable.WS then
        action_string = "Weaponskill"
    elseif focus_type == DB.Enum.Trackable.SC then
        action_string = "Skillchain"
    end

    if UI.BeginTable(focus_type, 7, table_flags) then
        UI.TableSetupColumn(action_string, col_flags, width)
        UI.TableSetupColumn("Total " .. damage_string, col_flags, width)
        UI.TableSetupColumn(attempt_string, col_flags, width)
        UI.TableSetupColumn(acc_string, col_flags, width)
        UI.TableSetupColumn("Avg. " .. damage_string, col_flags, width)
        UI.TableSetupColumn("Min. " .. damage_string, col_flags, width)
        UI.TableSetupColumn("Max. " .. damage_string, col_flags, width)
        UI.TableHeadersRow()

        DB.Lists.Sort.Catalog_Damage(player_name, focus_type)
        local action_name
        for _, data in ipairs(DB.Sorted.Catalog_Damage) do
            action_name = data[1]
            Focus.Catalog.Single_Row(player_name, action_name, focus_type)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to a row for a trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param focus_type string a trackable from the data model.
------------------------------------------------------------------------------------------------------
Focus.Catalog.Single_Row = function(player_name, action_name, focus_type)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(action_name)
    UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.TOTAL)
    UI.TableNextColumn() Col.Single.Attempts(player_name, action_name, focus_type)

    -- Accuracy changes between what the trackable is. Accuracy for spells isn't useful.
    if focus_type == DB.Enum.Trackable.NUKE then
        UI.TableNextColumn() Col.Single.Bursts(player_name, action_name)
    elseif focus_type == DB.Enum.Trackable.HEALING then
        UI.TableNextColumn() Col.Single.Overcure(player_name, action_name)
    else
        UI.TableNextColumn() Col.Single.Acc(player_name, action_name, focus_type)
    end

    UI.TableNextColumn() Col.Single.Average(player_name, action_name, focus_type)
    local min = DB.Catalog.Get(player_name, focus_type, action_name, DB.Enum.Metric.MIN)
    if min == 100000 then
        UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, DB.Enum.Values.IGNORE)
    else
        UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.MIN)
    end
    UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.MAX)
end