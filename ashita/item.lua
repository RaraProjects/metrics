Ashita.Item = T{}

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