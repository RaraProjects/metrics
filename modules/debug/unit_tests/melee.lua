Debug.Unit.Tests.Melee = {}

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Main_Hit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.HIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Main-Hand > Hit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Main_Miss = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.MISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Main-Hand > Miss", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Critical Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Crit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.CRIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CRIT_DAMAGE] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CRIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.CRIT_DAMAGE] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.CRIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Main-Hand > Crit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Enspell
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Enspell = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 200
    local add_effect_animation = 1  -- Enfire
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.HIT}
    local add_effect = {param = additional_damage, animation = add_effect_animation, message = Ashita.Enum.Message.ENSPELL}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = additional_damage
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENSPELL] = T{}
    player_database[index][DB.Enum.Trackable.ENSPELL][DB.Enum.Metric.TOTAL] = additional_damage
    player_database[index][DB.Enum.Trackable.ENSPELL][DB.Enum.Metric.MIN] = additional_damage
    player_database[index][DB.Enum.Trackable.ENSPELL][DB.Enum.Metric.MAX] = additional_damage
    player_database[index][DB.Enum.Trackable.ENSPELL][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENSPELL][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ENSPELL][DB.Enum.Values.CATALOG]["Enfire"] = T{}
    player_database[index][DB.Enum.Trackable.ENSPELL][DB.Enum.Values.CATALOG]["Enfire"][DB.Enum.Metric.TOTAL] = additional_damage
    player_database[index][DB.Enum.Trackable.ENSPELL][DB.Enum.Values.CATALOG]["Enfire"][DB.Enum.Metric.MIN] = additional_damage
    player_database[index][DB.Enum.Trackable.ENSPELL][DB.Enum.Values.CATALOG]["Enfire"][DB.Enum.Metric.MAX] = additional_damage
    player_database[index][DB.Enum.Trackable.ENSPELL][DB.Enum.Values.CATALOG]["Enfire"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage + additional_damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage + additional_damage

    return Debug.Unit.Check_Result("Melee - Main-Hand > Enspell", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Shadows
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Shadows = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.SHADOWS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.SHADOWS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.SHADOWS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Main-Hand > Shadows", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Mob Heal
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Mob_Heal = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.MOBHEAL373}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MOB_HEAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MOB_HEAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Main-Hand > Mob Heal", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Off-Hand > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Off_Hand_Hit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.MELEE_OFFHAND, reaction = nil, message = Ashita.Enum.Message.HIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_OFFHAND] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Off-Hand > Hit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Off-Hand > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Off_Hand_Miss = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.MELEE_OFFHAND, reaction = nil, message = Ashita.Enum.Message.MISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_OFFHAND] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Off-Hand > Miss", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Pet > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Pet_Hit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.HIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.PET] = T{}
    player_database[index][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_MELEE] = T{}
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE] = T{}
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.TOTAL] = T{}
    pet_database[index][pet][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    pet_database[index][pet][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Pet > Hit", player_database, pet_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Pet > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Pet_Miss = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.MISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.PET_MELEE] = T{}
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE] = T{}
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.COUNT] = 1

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Pet > Miss", player_database, pet_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Pet > Crit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Pet_Crit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.CRIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.PET] = T{}
    player_database[index][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_MELEE] = T{}
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.CRIT_DAMAGE] = damage
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.CRIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE] = T{}
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.CRIT_DAMAGE] = damage
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.CRIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.CRIT_DAMAGE] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.CRIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.CRIT_DAMAGE] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.CRIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.TOTAL] = T{}
    pet_database[index][pet][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    pet_database[index][pet][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Pet > Crit", player_database, pet_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Pet > Shadows
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Pet_Shadows = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.SHADOWS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.PET_MELEE] = T{}
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.SHADOWS] = 1
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE] = T{}
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.SHADOWS] = 1

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.SHADOWS] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.SHADOWS] = 1

    return Debug.Unit.Check_Result("Melee - Pet > Shadows", player_database, pet_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Pet > Mob Heal
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Pet_Mob_Heal = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.MOBHEAL373}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.PET_MELEE] = T{}
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.MOB_HEAL] = damage
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE] = T{}
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.MOB_HEAL] = damage

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.MOB_HEAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.MOB_HEAL] = damage

    return Debug.Unit.Check_Result("Melee - Pet > Mob Heal", player_database, pet_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Daken > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Daken_Hit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.DAKEN, reaction = nil, message = Ashita.Enum.Message.RANGEHIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.RANGED] = T{}
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.THROWING] = T{}
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Daken > Hit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Daken > Square Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Daken_Square = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.DAKEN, reaction = nil, message = Ashita.Enum.Message.SQUARE}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.RANGED] = T{}
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.THROWING] = T{}
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Daken > Square Hit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Daken > Truestrike
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Daken_Truestrike = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.DAKEN, reaction = nil, message = Ashita.Enum.Message.TRUE}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.RANGED] = T{}
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.THROWING] = T{}
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Daken > Truestrike", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Daken > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Daken_Miss = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local primary = {animation = Ashita.Enum.Animation.DAKEN, reaction = nil, message = Ashita.Enum.Message.MISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.RANGED] = T{}
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.THROWING] = T{}
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MULT_ATK_1] = 1

    return Debug.Unit.Check_Result("Melee - Daken > Miss", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Daken > Crit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Daken_Crit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.DAKEN, reaction = nil, message = Ashita.Enum.Message.RANGECRIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.RANGED] = T{}
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.CRIT_DAMAGE] = damage
    player_database[index][DB.Enum.Trackable.RANGED][DB.Enum.Metric.CRIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.THROWING] = T{}
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.CRIT_DAMAGE] = damage
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.CRIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Daken > Crit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Kick > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Kick_Hit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.MELEE_KICK, reaction = nil, message = Ashita.Enum.Message.HIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_KICK] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Kick > Hit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Kick > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Kick_Miss = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local primary = {animation = Ashita.Enum.Animation.MELEE_KICK, reaction = nil, message = Ashita.Enum.Message.MISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_KICK] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Kick > Miss", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Kick > Critical Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Kick_Crit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.MELEE_KICK, reaction = nil, message = Ashita.Enum.Message.CRIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CRIT_DAMAGE] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CRIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_KICK] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.CRIT_DAMAGE] = damage
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.CRIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Kick > Crit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Endamage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Endamage = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 200
    local add_effect_animation = 1  -- Fire
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.HIT}
    local add_effect = {param = additional_damage, animation = add_effect_animation, message = Ashita.Enum.Message.ENDAMAGE}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = additional_damage
    player_database[index][DB.Enum.Trackable.ENDAMAGE] = T{}
    player_database[index][DB.Enum.Trackable.ENDAMAGE][DB.Enum.Metric.TOTAL] = additional_damage
    player_database[index][DB.Enum.Trackable.ENDAMAGE][DB.Enum.Metric.MIN] = additional_damage
    player_database[index][DB.Enum.Trackable.ENDAMAGE][DB.Enum.Metric.MAX] = additional_damage
    player_database[index][DB.Enum.Trackable.ENDAMAGE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENDAMAGE][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ENDAMAGE][DB.Enum.Values.CATALOG]["Fire"] = T{}
    player_database[index][DB.Enum.Trackable.ENDAMAGE][DB.Enum.Values.CATALOG]["Fire"][DB.Enum.Metric.TOTAL] = additional_damage
    player_database[index][DB.Enum.Trackable.ENDAMAGE][DB.Enum.Values.CATALOG]["Fire"][DB.Enum.Metric.MIN] = additional_damage
    player_database[index][DB.Enum.Trackable.ENDAMAGE][DB.Enum.Values.CATALOG]["Fire"][DB.Enum.Metric.MAX] = additional_damage
    player_database[index][DB.Enum.Trackable.ENDAMAGE][DB.Enum.Values.CATALOG]["Fire"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage + additional_damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage + additional_damage

    return Debug.Unit.Check_Result("Melee - Main-Hand > Endamage", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Endebuff
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Endebuff = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 5  -- Blind
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.HIT}
    local add_effect = {param = additional_damage, animation = nil, message = Ashita.Enum.Message.ENDEBUFF}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENDEBUFF] = T{}
    player_database[index][DB.Enum.Trackable.ENDEBUFF][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENDEBUFF][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ENDEBUFF][DB.Enum.Values.CATALOG]["Blind"] = T{}
    player_database[index][DB.Enum.Trackable.ENDEBUFF][DB.Enum.Values.CATALOG]["Blind"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Main-Hand > Endebuff", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Endrain
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Endrain = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 200
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.HIT}
    local add_effect = {param = additional_damage, animation = nil, message = Ashita.Enum.Message.ENDRAIN}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENDRAIN] = T{}
    player_database[index][DB.Enum.Trackable.ENDRAIN][DB.Enum.Metric.TOTAL] = additional_damage
    player_database[index][DB.Enum.Trackable.ENDRAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Main-Hand > Endrain", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Enaspir
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Enaspir = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 200
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.HIT}
    local add_effect = {param = additional_damage, animation = nil, message = Ashita.Enum.Message.ENASPIR}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.ROUNDS] = 1
    player_database[index][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENASPIR] = T{}
    player_database[index][DB.Enum.Trackable.ENASPIR][DB.Enum.Metric.TOTAL] = additional_damage
    player_database[index][DB.Enum.Trackable.ENASPIR][DB.Enum.Metric.HIT_COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Main-Hand > Enaspir", player_database)
end