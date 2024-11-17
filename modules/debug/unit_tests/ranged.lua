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

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.RANGED] = T{}
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player[index][DB.Enum.Trackable.RANGED_TRUE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.TOTAL] = T{}
    player[index][DB.Enum.Trackable.TOTAL][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Ranged > Hit", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.RANGED] = T{}
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player[index][DB.Enum.Trackable.RANGED_TRUE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.TOTAL] = T{}
    player[index][DB.Enum.Trackable.TOTAL][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Ranged > Square Hit", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.RANGED] = T{}
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player[index][DB.Enum.Trackable.RANGED_TRUE][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.RANGED_TRUE][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.RANGED_TRUE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.TOTAL] = T{}
    player[index][DB.Enum.Trackable.TOTAL][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Ranged > Truestrike", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.RANGED] = T{}
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player[index][DB.Enum.Trackable.RANGED_TRUE][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Ranged > Miss", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.RANGED] = T{}
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.CRITICAL_DAMAGE] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.CRITICAL_COUNT] = 1
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player[index][DB.Enum.Trackable.RANGED_TRUE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.TOTAL] = T{}
    player[index][DB.Enum.Trackable.TOTAL][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Ranged > Crit", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.RANGED] = T{}
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.SHADOW_ABSORPTION] = 1
    player[index][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player[index][DB.Enum.Trackable.RANGED_TRUE][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Ranged > Shadows", player)
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
    local add_effect_animation = 1
    local add_effect_name = "Fire"
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGEHIT}
    local add_effect = {param = additional_damage, animation = add_effect_animation, message = Ashita.Enum.Message.ENDAMAGE}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.RANGED] = T{}
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player[index][DB.Enum.Trackable.RANGED_TRUE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.MAGIC] = T{}
    player[index][DB.Enum.Trackable.MAGIC][DB.Metric.TOTAL] = additional_damage
    player[index][DB.Enum.Trackable.ENDAMAGE_R] = T{}
    player[index][DB.Enum.Trackable.ENDAMAGE_R][DB.Metric.TOTAL] = additional_damage
    player[index][DB.Enum.Trackable.ENDAMAGE_R][DB.Metric.MIN] = additional_damage
    player[index][DB.Enum.Trackable.ENDAMAGE_R][DB.Metric.MAX] = additional_damage
    player[index][DB.Enum.Trackable.ENDAMAGE_R][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.TOTAL] = T{}
    player[index][DB.Enum.Trackable.TOTAL][DB.Metric.TOTAL] = damage + additional_damage
    player[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Metric.TOTAL] = damage + additional_damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][add_effect_name] = T{}
    player_catalog[index][add_effect_name][DB.Enum.Trackable.ENDAMAGE_R] = T{}
    player_catalog[index][add_effect_name][DB.Enum.Trackable.ENDAMAGE_R][DB.Metric.TOTAL] = additional_damage
    player_catalog[index][add_effect_name][DB.Enum.Trackable.ENDAMAGE_R][DB.Metric.MIN] = additional_damage
    player_catalog[index][add_effect_name][DB.Enum.Trackable.ENDAMAGE_R][DB.Metric.MAX] = additional_damage
    player_catalog[index][add_effect_name][DB.Enum.Trackable.ENDAMAGE_R][DB.Metric.HIT_COUNT] = 1

    return Debug.Unit.Check_Result("Ranged > Endamage", player, player_catalog)
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
    local additional_damage = 5
    local add_effect_name = "Blind"
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGEHIT}
    local add_effect = {param = additional_damage, animation = nil, message = Ashita.Enum.Message.ENDEBUFF}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.RANGED] = T{}
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player[index][DB.Enum.Trackable.RANGED_TRUE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.ENDEBUFF_R] = T{}
    player[index][DB.Enum.Trackable.ENDEBUFF_R][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.TOTAL] = T{}
    player[index][DB.Enum.Trackable.TOTAL][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][add_effect_name] = T{}
    player_catalog[index][add_effect_name][DB.Enum.Trackable.ENDEBUFF_R] = T{}
    player_catalog[index][add_effect_name][DB.Enum.Trackable.ENDEBUFF_R][DB.Metric.HIT_COUNT] = 1

    return Debug.Unit.Check_Result("Ranged > Endebuff", player, player_catalog)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.RANGED] = T{}
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player[index][DB.Enum.Trackable.RANGED_TRUE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.MAGIC] = T{}
    player[index][DB.Enum.Trackable.MAGIC][DB.Metric.TOTAL] = additional_damage
    player[index][DB.Enum.Trackable.ENDRAIN_R] = T{}
    player[index][DB.Enum.Trackable.ENDRAIN_R][DB.Metric.TOTAL] = additional_damage
    player[index][DB.Enum.Trackable.ENDRAIN_R][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.TOTAL] = T{}
    player[index][DB.Enum.Trackable.TOTAL][DB.Metric.TOTAL] = damage + additional_damage
    player[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Metric.TOTAL] = damage + additional_damage

    return Debug.Unit.Check_Result("Ranged > Endrain", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.RANGED] = T{}
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.RANGED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_SQUARE] = T{}
    player[index][DB.Enum.Trackable.RANGED_SQUARE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.RANGED_TRUE] = T{}
    player[index][DB.Enum.Trackable.RANGED_TRUE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.TOTAL] = T{}
    player[index][DB.Enum.Trackable.TOTAL][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Ranged - PUP > Hit", player)
end