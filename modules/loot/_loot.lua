Loot = { }

require("modules.loot.config")

Loot.Name   = "Loot"
Loot.Title  = "Metrics - Loot"
Loot.Module = "Loot"
Loot.File   = "loot"

Loot.Pool              = { }  -- Mirrors the in-game item pool
Loot.ItemBuffer        = { }  -- Used as text input.
Loot.SortedItemsAll    = { }
Loot.SortedItemsPlayer = { }
Loot.SortedItemsMob    = { }

------------------------------------------------------------------------------------------------------
-- Initializes the Focus screen.
------------------------------------------------------------------------------------------------------
---@param settings? table settings that come from the Ashita settings_update event.
------------------------------------------------------------------------------------------------------
Loot.Initialize = function(settings)
    -- Get saved settings from file.
    Loot.Settings = settings or SettingsFile.load(Loot.Config.Defaults, Loot.File)

    -- Create the Focus Window.
    Loot.Window = Window:New
    ({
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
    Loot.Config.LootModeDropdown()
    Loot.Config.ItemFilterInput()

    local lootModes =
    {
        [1] = Loot.AllItems,
        [2] = Loot.PlayerItems,
        [3] = Loot.MobItems,
    }

    local displayFunction = lootModes[Loot.Settings.Loot_Mode]

    if displayFunction and type(displayFunction) == "function" then
        displayFunction()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Pickup special messages like getting gil from chests.
-- ------------------------------------------------------------------------------------------------------
---@param data table
-- ------------------------------------------------------------------------------------------------------
Loot.SpecialMessage = function(data)
    local messageData = Ashita.Packets.SpecialMessage(data)

    if not messageData then
        return nil
    end

    local param     = messageData.Param1
    local messageId = messageData.Message_ID

    -- TO DO:
    -- Messages that can mean GIL_OBTAINED based on zone.
    -- 228,  6391, 6404, 6413, 6426, 6435, 6437, 6446, 6531, 6550
    -- 6554, 6560, 6570, 6572, 6576, 6580, 6581, 6596, 6599, 6913
    -- 6923, 7132, 10974
end

-- ------------------------------------------------------------------------------------------------------
-- File which item dropped.
-- ------------------------------------------------------------------------------------------------------
---@param data table
-- ------------------------------------------------------------------------------------------------------
Loot.Dropped = function(data)
    local dropData = Ashita.Packets.ItemDrop(data)

    -- Upon logging in, there are 10 blank dropped item packets (probably one for each treasure slot).
    if not dropData or dropData.Dropper_Index == 0 then
        return nil
    end

    local itemName = Ashita.Item.GetItemName(dropData.Item)
    Loot.Pool[dropData.Index] = itemName

    local mob     = Ashita.Mob.GetMobByIndex(dropData.Dropper_Index)
    local mobName = mob and mob.name or DB.Enum.DEBUG

    -- Track total drops.
    DB.Tracking.TotalItems[itemName] = (DB.Tracking.TotalItems[itemName] or 0) + 1

    -- Track mob specific drops.
    DB.Tracking.DropRates[mobName] = DB.Tracking.DropRates[mobName]  or { }
    DB.Tracking.DropRates[mobName][itemName] = (DB.Tracking.DropRates[mobName][itemName] or 0) + 1

    -- Sort the items alphabetically.
    Loot.SortedItemsAll = { }
    for item in pairs(DB.Tracking.TotalItems) do
        table.insert(Loot.SortedItemsAll, item)
    end

    table.sort(Loot.SortedItemsAll, function(a, b) return a < b end)

    Loot.SortedItemsMob = Loot.SortNestedTable(DB.Tracking.DropRates)
end

-- ------------------------------------------------------------------------------------------------------
-- Add items that were stolen.
-- ------------------------------------------------------------------------------------------------------
Loot.NonDrop = function(recipientName, itemName, itemCount)
    DB.Tracking.TotalItems[itemName] = (DB.Tracking.TotalItems[itemName] or 0) + itemCount

    Loot.SortedItemsAll = { }
    for item in pairs(DB.Tracking.TotalItems) do
        table.insert(Loot.SortedItemsAll, item)
    end

    table.sort(Loot.SortedItemsAll, function(a, b) return a < b end)

    Loot.AddReceivedItem(recipientName, itemName, itemCount)
end

-- ------------------------------------------------------------------------------------------------------
-- File who obtained the item.
-- ------------------------------------------------------------------------------------------------------
---@param data table
-- ------------------------------------------------------------------------------------------------------
Loot.Obtained = function(data)
    local dropData = Ashita.Packets.ItemAction(data)

    if not dropData then
        return nil
    end

    -- Only care about items being obtained or floored.
    local isDrop        = dropData.Drop
    local recipientName = "Floor"

    -- Lotting/Passing actions.
    if isDrop == 0 then
        return nil

    -- Player obtains item.
    elseif isDrop == 1 then
        local recipientIndex = dropData.Highest_Lotter_Index
        local recipientMob   = Ashita.Mob.GetMobByIndex(recipientIndex) or { name = DB.Enum.DEBUG }
        recipientName        = recipientMob.name

    -- Floor obtains item.
    elseif isDrop == 2 then
        -- Do nothing.

    end

    local itemName = Loot.Pool[dropData.Index] or "Unknown"
    Loot.Pool[dropData.Index] = nil

    Loot.AddReceivedItem(recipientName, itemName, 1)
end

-- ------------------------------------------------------------------------------------------------------
-- Add a player received item (or gil).
-- ------------------------------------------------------------------------------------------------------
---@param recipientName string
---@param itemName      string
---@param itemCount?    integer
-- ------------------------------------------------------------------------------------------------------
Loot.AddReceivedItem = function(recipientName, itemName, itemCount)
    recipientName = recipientName or "Unknown"
    itemCount     = itemCount or 1

    DB.Tracking.ReceivedItems[recipientName] = DB.Tracking.ReceivedItems[recipientName] or { }
    DB.Tracking.ReceivedItems[recipientName][itemName] = (DB.Tracking.ReceivedItems[recipientName][itemName] or 0) + itemCount

    -- Sort the items alphabetically.
    Loot.SortedItemsPlayer = Loot.SortNestedTable(DB.Tracking.ReceivedItems)
end

-- ------------------------------------------------------------------------------------------------------
-- Sort nested tables.
-- ------------------------------------------------------------------------------------------------------
---@param unsortedTable table
-- ------------------------------------------------------------------------------------------------------
Loot.SortNestedTable = function(unsortedTable)
    local sortedTable    = { }
    local sortedEntities = { }

    -- Sort the entities first.
    for entityName in pairs(unsortedTable) do
        table.insert(sortedEntities, entityName)
    end

    table.sort(sortedEntities)

    -- Sort the items within each entity.
    for _, entityName in ipairs(sortedEntities) do
        local items       = unsortedTable[entityName]
        local sortedItems = { }

        for itemName in pairs(items) do
            table.insert(sortedItems, itemName)
        end

        table.sort(sortedItems)

        sortedTable[entityName] = sortedItems
    end

    return sortedTable
end

-- ------------------------------------------------------------------------------------------------------
-- Shows all loot.
-- ------------------------------------------------------------------------------------------------------
Loot.AllItems = function()
    local colFlags   = Focus.ColumnFlags
    local tableFlags = Focus.TableFlags
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard

    if UI.BeginTable("All Loot", 2, tableFlags) then
        UI.TableSetupColumn("Item",  colFlags, nameWidth)
        UI.TableSetupColumn("Drops", colFlags, width)
        UI.TableHeadersRow()

        local itemsObtained = 0

        -- Player
        for _, itemName in pairs(Loot.SortedItemsAll) do
            if Loot.Config.ShowItem(itemName) then
                UI.TableNextColumn() UI.Text(tostring(itemName))
                UI.TableNextColumn() UI.Text(tostring(DB.Tracking.TotalItems[itemName]))
                WindowManager.TableRowColor(1)
            end

            itemsObtained = itemsObtained + 1
        end

        if itemsObtained == 0 then
            UI.TableNextColumn() UI.Text("None Yet")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows player loot.
-- ------------------------------------------------------------------------------------------------------
Loot.PlayerItems = function()
    local colFlags   = Focus.ColumnFlags
    local tableFlags = Focus.TableFlags
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard

    if UI.BeginTable("Player Loot", 2, tableFlags) then
        UI.TableSetupColumn("Player Loot", colFlags, nameWidth)
        UI.TableSetupColumn("Drops",       colFlags, width)
        UI.TableHeadersRow()

        local itemsObtained = 0

        -- Player
        for playerName, itemData in pairs(Loot.SortedItemsPlayer) do
            UI.TableNextColumn() UI.Text(tostring(playerName))
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            WindowManager.TableRowColor(1)

            -- Items
            for _, itemName  in pairs(itemData) do
                if Loot.Config.ShowItem(itemName) and DB.Tracking.ReceivedItems[playerName] and DB.Tracking.ReceivedItems[playerName][itemName] then
                    UI.TableNextColumn() UI.Text(string.format("- %s", tostring(itemName)))
                    UI.TableNextColumn() UI.Text(tostring(DB.Tracking.ReceivedItems[playerName][itemName]))
                    WindowManager.TableRowColor(0)
                end
            end

            itemsObtained = itemsObtained + 1
        end

        if itemsObtained == 0 then
            UI.TableNextColumn() UI.Text("None Yet")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows mob loot.
-- ------------------------------------------------------------------------------------------------------
Loot.MobItems = function()
    local colFlags   = Focus.ColumnFlags
    local tableFlags = Focus.TableFlags
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard

    if UI.BeginTable("Mob Loot", 3, tableFlags) then
        UI.TableSetupColumn("Mob Loot", colFlags, nameWidth)
        UI.TableSetupColumn("Count",    colFlags, width)
        UI.TableSetupColumn("%Drop",    colFlags, width)
        UI.TableHeadersRow()

        local mobsDefeated = 0

        -- Mob
        for _, mobName in pairs(DB.Lists.Mobs) do
            if DB.Tracking.DefeatedMobs[mobName] then
                local mobDeaths = DB.Tracking.DefeatedMobs[mobName]

                UI.TableNextColumn() UI.Text(tostring(mobName))
                UI.TableNextColumn() UI.Text(tostring(mobDeaths))
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                WindowManager.TableRowColor(1)

                -- Items
                if Loot.SortedItemsMob[mobName] and DB.Tracking.DropRates[mobName] then
                    for _, itemName in pairs(Loot.SortedItemsMob[mobName]) do
                        if Loot.Config.ShowItem(itemName) and DB.Tracking.DropRates[mobName][itemName] then
                            local dropCount = DB.Tracking.DropRates[mobName][itemName]
                            UI.TableNextColumn() UI.Text(string.format("- %s", tostring(itemName)))
                            UI.TableNextColumn() UI.Text(tostring(dropCount))
                            UI.TableNextColumn() UI.Text(Column.String.FormatPercent(dropCount, mobDeaths))
                            WindowManager.TableRowColor(0)
                        end
                    end
                end
            end

            mobsDefeated = mobsDefeated + 1
        end

        if mobsDefeated == 0 then
            UI.TableNextColumn() UI.Text("None Yet")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end