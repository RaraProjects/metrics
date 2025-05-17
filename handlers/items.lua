H.Item = { }

-- ------------------------------------------------------------------------------------------------------
-- Parse the begin item use packet.
-- ------------------------------------------------------------------------------------------------------
---@param action   table action packet data.
---@param actorMob table
-- ------------------------------------------------------------------------------------------------------
H.Item.Begin = function(action, actorMob)
    if not action or not actorMob or not Ashita.Mob.IsMe(actorMob.name) then
        return
    end

    local actionType = action.param

    if XP.IsBlocked and actionType == Ashita.ActionType.INTERRUPT then
        XP.IsBlocked = false
    end

    -- Block addition of XP from scroll. It messes up timing metrics.
    for _, target in pairs(action.targets) do
        for _, actionData in pairs(target.actions) do
            local itemId = actionData.param

            if Res.Items.XP_Scroll[itemId] then
                XP.IsBlocked = true
            end
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Parse the finish item use packet.
-- ------------------------------------------------------------------------------------------------------
---@param action   table action packet data.
---@param actorMob table
-- ------------------------------------------------------------------------------------------------------
H.Item.Finish = function(action, actorMob)
    if not action or not actorMob or not Ashita.Mob.IsMe(actorMob.name) then
        return
    end

    local itemId = action.param
    local dedicationItem = Res.Items.Dedication[itemId]

    -- Set dedication status (XP Boost) if a dedication item was used.
    if dedicationItem then
        XP.Dedication.Set(dedicationItem, true)
    end
end