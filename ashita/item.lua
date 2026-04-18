Ashita.Item = { }

-- ------------------------------------------------------------------------------------------------------
-- Get an item's name.
-- ------------------------------------------------------------------------------------------------------
---@param itemId integer
---@return string
-- ------------------------------------------------------------------------------------------------------
Ashita.Item.GetItemName = function(itemId)
    if not itemId then
        Debug.Error.Add(Debug.Error.ERROR, "Ashita.Item.GetItemName", string.format("Parameter \"id\" was nil."))
        return 'Error'
    end

    local item = AshitaCore:GetResourceManager():GetItemById(itemId)

    if not item or not item.Name or not item.Name[1] then
        return "Error"
    end

    return item.Name[3]
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