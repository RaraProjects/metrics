Ashita.Item = { }

-- ------------------------------------------------------------------------------------------------------
-- Get an item's name.
-- ------------------------------------------------------------------------------------------------------
---@param itemId integer
---@return string
-- ------------------------------------------------------------------------------------------------------
Ashita.Item.GetItemName = function(itemId)
    local item = AshitaCore:GetResourceManager():GetItemById(itemId)
    if not item then
        return "Unknown"
    end

    local itemName = item.Name[1]
    if not itemName then
        return DB.Enum.DEBUG
    end

    return itemName
end

-- ------------------------------------------------------------------------------------------------------
-- Checks a piece of gear's level.
-- ------------------------------------------------------------------------------------------------------
---@param itemName string
---@return number
-- ------------------------------------------------------------------------------------------------------
Ashita.Item.GetItemLevel = function(itemName)
    local item = AshitaCore:GetResourceManager():GetItemByName(itemName, 0)
    if not item or not item.Level then
        return 0
    end

    return item.Level
end