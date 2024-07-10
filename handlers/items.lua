H.Item = T{}

-- ------------------------------------------------------------------------------------------------------
-- Parse the finish item use packet.
-- ------------------------------------------------------------------------------------------------------
---@param action table action packet data.
-- ------------------------------------------------------------------------------------------------------
H.Item.Action = function(action)
    if not action then return nil end
    local item_id = action.param
    local dedication_item = Res.Items.Get_Dedication(item_id)
    if dedication_item then XP.Set_Dedication(dedication_item) end
end