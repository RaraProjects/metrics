Ashita.Item = {}

-- ------------------------------------------------------------------------------------------------------
-- Get an item's name.
-- ------------------------------------------------------------------------------------------------------
---@param item_id string
---@return string
-- ------------------------------------------------------------------------------------------------------
Ashita.Item.Get_Item_Name = function(item_id)
    local item = AshitaCore:GetResourceManager():GetItemById(item_id)
    if not item then return "Unknown" end

    local item_name = item.Name[1]
    if not item_name then return DB.Enum.DEBUG end
    return item_name
end

-- ------------------------------------------------------------------------------------------------------
-- Checks a piece of gear's level.
-- ------------------------------------------------------------------------------------------------------
---@param item_name string
---@return number
-- ------------------------------------------------------------------------------------------------------
Ashita.Item.Get_Item_Level = function(item_name)
    local item = AshitaCore:GetResourceManager():GetItemByName(item_name, 0)
    local item_level = item.Level
    if not item_level then return 0 end
    return item_level
end