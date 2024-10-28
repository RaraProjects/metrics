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
-- Ranged > Endamage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Endamage = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 200
    local add_effect_animation = 1  -- Fire
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGEHIT}
    local add_effect = {param = additional_damage, animation = add_effect_animation, message = Ashita.Enum.Message.ENDAMAGE}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
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
    player_database[index][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = additional_damage
    player_database[index][DB.Enum.Trackable.ENDAMAGE_R] = T{}
    player_database[index][DB.Enum.Trackable.ENDAMAGE_R][DB.Enum.Metric.TOTAL] = additional_damage
    player_database[index][DB.Enum.Trackable.ENDAMAGE_R][DB.Enum.Metric.MIN] = additional_damage
    player_database[index][DB.Enum.Trackable.ENDAMAGE_R][DB.Enum.Metric.MAX] = additional_damage
    player_database[index][DB.Enum.Trackable.ENDAMAGE_R][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENDAMAGE_R][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ENDAMAGE_R][DB.Enum.Values.CATALOG]["Fire"] = T{}
    player_database[index][DB.Enum.Trackable.ENDAMAGE_R][DB.Enum.Values.CATALOG]["Fire"][DB.Enum.Metric.TOTAL] = additional_damage
    player_database[index][DB.Enum.Trackable.ENDAMAGE_R][DB.Enum.Values.CATALOG]["Fire"][DB.Enum.Metric.MIN] = additional_damage
    player_database[index][DB.Enum.Trackable.ENDAMAGE_R][DB.Enum.Values.CATALOG]["Fire"][DB.Enum.Metric.MAX] = additional_damage
    player_database[index][DB.Enum.Trackable.ENDAMAGE_R][DB.Enum.Values.CATALOG]["Fire"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage + additional_damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage + additional_damage

    return Debug.Unit.Check_Result("Ranged > Endamage", player_database)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Endebuff
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Endebuff = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 5  -- Blind
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGEHIT}
    local add_effect = {param = additional_damage, animation = nil, message = Ashita.Enum.Message.ENDEBUFF}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
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
    player_database[index][DB.Enum.Trackable.ENDEBUFF_R] = T{}
    player_database[index][DB.Enum.Trackable.ENDEBUFF_R][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENDEBUFF_R][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ENDEBUFF_R][DB.Enum.Values.CATALOG]["Blind"] = T{}
    player_database[index][DB.Enum.Trackable.ENDEBUFF_R][DB.Enum.Values.CATALOG]["Blind"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Ranged > Endebuff", player_database)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Endrain
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Endrain = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 200
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGEHIT}
    local add_effect = {param = additional_damage, animation = nil, message = Ashita.Enum.Message.ENDRAIN}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
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
    player_database[index][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = additional_damage
    player_database[index][DB.Enum.Trackable.ENDRAIN_R] = T{}
    player_database[index][DB.Enum.Trackable.ENDRAIN_R][DB.Enum.Metric.TOTAL] = additional_damage
    player_database[index][DB.Enum.Trackable.ENDRAIN_R][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage + additional_damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage + additional_damage

    return Debug.Unit.Check_Result("Ranged > Endrain", player_database)
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