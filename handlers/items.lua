H.Item = T{}

-- ------------------------------------------------------------------------------------------------------
-- Parse the finish item use packet.
-- ------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table
-- ------------------------------------------------------------------------------------------------------
H.Item.Action = function(action, actor_mob)
    if not action then return nil end
    if not actor_mob then return nil end
    if not Ashita.Mob.Is_Me(actor_mob.name) then return nil end
    local item_id = action.param
    local dedication_item = Res.Items.Get_Dedication(item_id)
    if dedication_item then XP.Dedication.Set(dedication_item, true) end
end