H.Item = { }

-- ------------------------------------------------------------------------------------------------------
-- Parse the finish item use packet.
-- ------------------------------------------------------------------------------------------------------
---@param action   table action packet data.
---@param actorMob table
-- ------------------------------------------------------------------------------------------------------
H.Item.Action = function(action, actorMob)
    if not action or not actorMob or not Ashita.Mob.IsMe(actorMob.name) then
        return nil
    end

    local itemId = action.param
    local dedicationItem = Res.Items.Dedication[itemId]

    -- Set dedication status (XP Boost) if a dedication item was used.
    if dedicationItem then
        XP.Dedication.Set(dedicationItem, true)
    end
end