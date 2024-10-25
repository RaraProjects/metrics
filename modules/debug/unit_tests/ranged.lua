Debug.Unit.Tests.Ranged = {}

------------------------------------------------------------------------------------------------------
-- Melee - Ranged > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Hit = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, nil, Ashita.Enum.Message.RANGEHIT)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_SQUARE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_TRUE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Ranged > Hit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Ranged > Square Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Square = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, nil, Ashita.Enum.Message.SQUARE)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_SQUARE][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_SQUARE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_SQUARE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_TRUE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Ranged > Square Hit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Ranged > Square Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Truestrike = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, nil, Ashita.Enum.Message.TRUE)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_SQUARE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_TRUE][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_TRUE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_TRUE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Ranged > Truestrike", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Ranged > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Miss = function()
    DB.Initialize(true)
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, 0, nil, Ashita.Enum.Message.RANGEMISS)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_SQUARE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_TRUE][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Ranged > Miss", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Ranged > Crit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Crit = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, nil, Ashita.Enum.Message.RANGECRIT)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.CRIT_DAMAGE] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.CRIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_SQUARE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_TRUE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Ranged > Crit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Ranged > Shadows
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Shadows = function()
    DB.Initialize(true)
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, 0, nil, Ashita.Enum.Message.SHADOWS)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.SHADOWS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_SQUARE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_TRUE][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Ranged > Shadows", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Ranged > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.PUP = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, nil, Ashita.Enum.Message.RANGEPUP)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_SQUARE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED_TRUE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Ranged > PUP", player_database)
end