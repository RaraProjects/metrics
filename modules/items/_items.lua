Loot = {}

require("modules.items.config")

Loot.Name   = "Loot"
Loot.Title  = "Metrics - Loot"
Loot.Module = "Loot"
Loot.File   = "loot"

Loot.Pool = {}
Loot.Item_Buffer = {}

Loot.Sorted_Items_All = {}
Loot.Sorted_Items_Player = {}
Loot.Sorted_Items_Mob = {}

------------------------------------------------------------------------------------------------------
-- Initializes the Focus screen.
------------------------------------------------------------------------------------------------------
---@param settings? table settings that come from the Ashita settings_update event.
------------------------------------------------------------------------------------------------------
Loot.Initialize = function(settings)
    -- Get saved settings from file.
    Loot.Settings = settings or Settings_File.load(Loot.Config.Defaults, Loot.File)

    -- Create the Focus Window.
    Loot.Window = Window:New({
        Name     = Loot.Name,
        Title    = Loot.Title,
        Module   = Loot.Module,
        Settings = Loot.Settings,
        Show_Title = true,
    })
end

------------------------------------------------------------------------------------------------------
-- Loads the loot data to the screen.
------------------------------------------------------------------------------------------------------
Loot.Content = function()

    Loot.Config.Loot_Mode_Dropdown()
    Loot.Config.Item_Filter_Input()

    if Loot.Settings.Loot_Mode == 1 then
        Loot.All_Items()

    elseif Loot.Settings.Loot_Mode == 2 then
        Loot.Player_Items()

    elseif Loot.Settings.Loot_Mode == 3 then
        Loot.Mob_Items()

    end
end

-- ------------------------------------------------------------------------------------------------------
-- File who obtained the item.
-- ------------------------------------------------------------------------------------------------------
---@param data table
-- ------------------------------------------------------------------------------------------------------
Loot.Dropped = function(data)
    local drop_data = Ashita.Packets.ItemDrop(data)
    if not drop_data then return nil end

    local item_name = Ashita.Item.GetItemName(drop_data.Item)
    Loot.Pool[drop_data.Index] = item_name

    local mob = Ashita.Mob.GetMobByIndex(drop_data.Dropper_Index)
    if not mob or not mob.name then return nil end
    local mob_name = mob.name

    -- Track total drops.
    if not DB.Tracking.TotalItems[item_name] then DB.Tracking.TotalItems[item_name] = 0 end
    DB.Tracking.TotalItems[item_name] = DB.Tracking.TotalItems[item_name] + 1

    -- Track mob specific drops.
    if not DB.Tracking.DropRates[mob_name] then DB.Tracking.DropRates[mob_name] = {} end
    if not DB.Tracking.DropRates[mob_name][item_name] then DB.Tracking.DropRates[mob_name][item_name] = 0 end
    DB.Tracking.DropRates[mob_name][item_name] = DB.Tracking.DropRates[mob_name][item_name] + 1

    -- Sort the items alphabetically.
    Loot.Sorted_Items_All = {}
    for item in pairs(DB.Tracking.TotalItems) do table.insert(Loot.Sorted_Items_All, item) end
    table.sort(Loot.Sorted_Items_All, function(a, b) return a < b end)

    Loot.Sorted_Items_Mob = Loot.Sort_Nested_Table(DB.Tracking.DropRates)
end

-- ------------------------------------------------------------------------------------------------------
-- File who obtained the item.
-- ------------------------------------------------------------------------------------------------------
---@param data table
-- ------------------------------------------------------------------------------------------------------
Loot.Obtained = function(data)
    local drop_data = Ashita.Packets.ItemAction(data)
    if not drop_data then return nil end

    -- Only care about items being obtained or floored.
    local is_drop = drop_data.Drop

    local recipient_name = "Floor"

    -- Lotting/Passing actions.
    if is_drop == 0 then
        return nil

    -- Player obtains item.
    elseif is_drop == 1 then
        local recipient_index = drop_data.Highest_Lotter_Index
        local recipient_mob = Ashita.Mob.GetMobByIndex(recipient_index)
        if not recipient_mob then return nil end
        recipient_name = recipient_mob.name

    -- Floor obtains item.
    elseif is_drop == 2 then
        -- Do nothing.

    end

    local item_name = Loot.Pool[drop_data.Index] or "Unknown"
    Loot.Pool[drop_data.Index] = nil

    Loot.Add_Received_Item(recipient_name, item_name, 1)
end

-- ------------------------------------------------------------------------------------------------------
-- Add a player received item (or gil).
-- ------------------------------------------------------------------------------------------------------
---@param recipient_name string
---@param item_name string
---@param item_count? integer
-- ------------------------------------------------------------------------------------------------------
Loot.Add_Received_Item = function(recipient_name, item_name, item_count)
    recipient_name = recipient_name or "Unknown"
    item_count = item_count or 1

    if not DB.Tracking.ReceivedItems[recipient_name] then DB.Tracking.ReceivedItems[recipient_name] = {} end
    if not DB.Tracking.ReceivedItems[recipient_name][item_name] then DB.Tracking.ReceivedItems[recipient_name][item_name] = 0 end
    DB.Tracking.ReceivedItems[recipient_name][item_name] = DB.Tracking.ReceivedItems[recipient_name][item_name] + item_count

    -- Sort the items alphabetically.
    Loot.Sorted_Items_Player = Loot.Sort_Nested_Table(DB.Tracking.ReceivedItems)
end

-- ------------------------------------------------------------------------------------------------------
-- Sort nested tables.
-- ------------------------------------------------------------------------------------------------------
---@param unsorted_table table
-- ------------------------------------------------------------------------------------------------------
Loot.Sort_Nested_Table = function(unsorted_table)
    local sorted_table = {}
    local sorted_entities = {}

    -- Sort the entities first.
    for entity_name in pairs(unsorted_table) do table.insert(sorted_entities, entity_name) end
    table.sort(sorted_entities)

    -- Sort the items within each entity.
    for _, entity_name in ipairs(sorted_entities) do
        sorted_table[entity_name] = {}
        local item_sort = {}
        for item_name in pairs(unsorted_table[entity_name]) do table.insert(item_sort, item_name) end
        table.sort(item_sort)
        for _, item_name in ipairs(item_sort) do table.insert(sorted_table[entity_name], item_name) end
    end

    return sorted_table
end

-- ------------------------------------------------------------------------------------------------------
-- Shows all loot.
-- ------------------------------------------------------------------------------------------------------
Loot.All_Items = function()
    local col_flags   = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    if UI.BeginTable("All Loot", 2, table_flags) then
        UI.TableSetupColumn("Item",  col_flags, name_width)
        UI.TableSetupColumn("Drops", col_flags, width)
        UI.TableHeadersRow()

        local items_obtained = 0

        -- Player
        for _, item_name in pairs(Loot.Sorted_Items_All) do
            if Loot.Config.Show_Item(item_name) then
                UI.TableNextColumn() UI.Text(tostring(item_name))
                UI.TableNextColumn() UI.Text(tostring(DB.Tracking.TotalItems[item_name]))
                Window_Manager.Table_Row_Color(1)
            end
            items_obtained = items_obtained + 1
        end

        if items_obtained == 0 then
            UI.TableNextColumn() UI.Text("None Yet")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows player loot.
-- ------------------------------------------------------------------------------------------------------
Loot.Player_Items = function()
    local col_flags   = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    if UI.BeginTable("Player Loot", 2, table_flags) then
        UI.TableSetupColumn("Player Loot", col_flags, name_width)
        UI.TableSetupColumn("Drops",       col_flags, width)
        UI.TableHeadersRow()

        local items_obtained = 0

        -- Player
        for player_name, item_data in pairs(Loot.Sorted_Items_Player) do
            UI.TableNextColumn() UI.Text(tostring(player_name))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(1)

            -- Items
            for _, item_name  in pairs(item_data) do
                if Loot.Config.Show_Item(item_name) and DB.Tracking.ReceivedItems[player_name] and DB.Tracking.ReceivedItems[player_name][item_name] then
                    UI.TableNextColumn() UI.Text("- " .. tostring(item_name))
                    UI.TableNextColumn() UI.Text(tostring(DB.Tracking.ReceivedItems[player_name][item_name]))
                    Window_Manager.Table_Row_Color(0)
                end
            end

            items_obtained = items_obtained + 1
        end

        if items_obtained == 0 then
            UI.TableNextColumn() UI.Text("None Yet")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows mob loot.
-- ------------------------------------------------------------------------------------------------------
Loot.Mob_Items = function()
    local col_flags   = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    if UI.BeginTable("Mob Loot", 3, table_flags) then
        UI.TableSetupColumn("Mob Loot", col_flags, name_width)
        UI.TableSetupColumn("Count",    col_flags, width)
        UI.TableSetupColumn("%Drop",    col_flags, width)
        UI.TableHeadersRow()

        local mobs_defeated = 0

        -- Mob
        for _, mob_name in pairs(DB.Lists.Mobs) do
            if DB.Tracking.DefeatedMobs[mob_name] then
                local mob_deaths = DB.Tracking.DefeatedMobs[mob_name]
                UI.TableNextColumn() UI.Text(tostring(mob_name))
                UI.TableNextColumn() UI.Text(tostring(mob_deaths))
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                Window_Manager.Table_Row_Color(1)

                -- Items
                if Loot.Sorted_Items_Mob[mob_name] and DB.Tracking.DropRates[mob_name] then
                    for _, item_name in pairs(Loot.Sorted_Items_Mob[mob_name]) do
                        if Loot.Config.Show_Item(item_name) and DB.Tracking.DropRates[mob_name][item_name] then
                            local drop_count = DB.Tracking.DropRates[mob_name][item_name]
                            UI.TableNextColumn() UI.Text("- " .. tostring(item_name))
                            UI.TableNextColumn() UI.Text(tostring(drop_count))
                            UI.TableNextColumn() UI.Text(Column.String.Format_Percent(drop_count, mob_deaths))
                            Window_Manager.Table_Row_Color(0)
                        end
                    end
                end
            end
            mobs_defeated = mobs_defeated + 1
        end

        if mobs_defeated == 0 then
            UI.TableNextColumn() UI.Text("None Yet")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end