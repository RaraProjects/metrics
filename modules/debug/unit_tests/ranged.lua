Debug.Unit.Tests.Ranged = {}

------------------------------------------------------------------------------------------------------
-- Ranged > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Hit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGEHIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.RANGED] = T{}
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player_database[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player_database[index][DB.Enum.Trackable.RANGED_TRUE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Ranged > Hit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Square Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Square = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.SQUARE}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.RANGED] = T{}
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player_database[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player_database[index][DB.Enum.Trackable.RANGED_TRUE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Ranged > Square Hit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Square Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Truestrike = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.TRUE}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.RANGED] = T{}
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player_database[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player_database[index][DB.Enum.Trackable.RANGED_TRUE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.RANGED_TRUE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED_TRUE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Ranged > Truestrike", player_database)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Miss = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGEMISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.RANGED] = T{}
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player_database[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player_database[index][DB.Enum.Trackable.RANGED_TRUE][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Ranged > Miss", player_database)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Crit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Crit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGECRIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.RANGED] = T{}
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.CRIT_DAMAGE] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.CRIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player_database[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player_database[index][DB.Enum.Trackable.RANGED_TRUE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Ranged > Crit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Shadows
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Shadows = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.SHADOWS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.RANGED] = T{}
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.SHADOWS] = 1
    player_database[index][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player_database[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player_database[index][DB.Enum.Trackable.RANGED_TRUE][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Ranged > Shadows", player_database)
end

------------------------------------------------------------------------------------------------------
-- Ranged - PUP > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.PUP = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGEPUP}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.RANGED] = T{}
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player_database[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player_database[index][DB.Enum.Trackable.RANGED_TRUE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Ranged - PUP > Hit", player_database)
end