Debug.Unit.Tests.Melee = {}

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Main_Hit = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_MAIN, Ashita.Enum.Message.HIT)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Main-Hand > Hit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Main_Miss = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_MAIN, Ashita.Enum.Message.MISS)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Main-Hand > Miss", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Critical Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Crit = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_MAIN, Ashita.Enum.Message.CRIT)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CRIT_DAMAGE] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CRIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.CRIT_DAMAGE] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.CRIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Main-Hand > Crit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Enspell
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Enspell = function()
    DB.Initialize(true)
    local damage = 100
    local animation_id = Ashita.Enum.Animation.MELEE_MAIN
    local message_id = Ashita.Enum.Message.HIT
    local additional_effect_message = Ashita.Enum.Message.ENSPELL
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, animation_id, message_id, 100, additional_effect_message)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.ENSPELL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.ENSPELL][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Main-Hand > Enspell", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Shadows
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Shadows = function()
    DB.Initialize(true)
    local damage = 100
    local animation_id = Ashita.Enum.Animation.MELEE_MAIN
    local message_id = Ashita.Enum.Message.SHADOWS
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, animation_id, message_id)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.SHADOWS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.SHADOWS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Main-Hand > Shadows", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Mob Heal
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Mob_Heal = function()
    DB.Initialize(true)
    local damage = 100
    local animation_id = Ashita.Enum.Animation.MELEE_MAIN
    local message_id = Ashita.Enum.Message.MOBHEAL373
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, animation_id, message_id)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MOB_HEAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_MAIN][DB.Enum.Metric.MOB_HEAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Main-Hand > Mob Heal", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Off-Hand > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Off_Hand_Hit = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_OFFHAND, Ashita.Enum.Message.HIT)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_OFFHAND] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Off-Hand > Hit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Off-Hand > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Off_Hand_Miss = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_OFFHAND, Ashita.Enum.Message.MISS)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_OFFHAND] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_OFFHAND][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Off-Hand > Miss", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Pet > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Pet_Hit = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, 0, Ashita.Enum.Message.HIT)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Pet > Hit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Pet > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Pet_Miss = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, 0, Ashita.Enum.Message.MISS)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Pet > Miss", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Pet > Crit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Pet_Crit = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, 0, Ashita.Enum.Message.CRIT)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.CRIT_DAMAGE] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.CRIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.CRIT_DAMAGE] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.CRIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Pet > Crit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Pet > Shadows
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Pet_Shadows = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, 0, Ashita.Enum.Message.SHADOWS)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.SHADOWS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.SHADOWS] = 1

    return Debug.Unit.Check_Result("Melee - Pet > Shadows", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Pet > Mob Heal
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Pet_Mob_Heal = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, 0, Ashita.Enum.Message.MOBHEAL373)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE][DB.Enum.Metric.MOB_HEAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MELEE_DISCRETE][DB.Enum.Metric.MOB_HEAL] = damage

    return Debug.Unit.Check_Result("Melee - Pet > Mob Heal", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Daken > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Daken_Hit = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.DAKEN, Ashita.Enum.Message.RANGEHIT)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Daken > Hit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Daken > Square Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Daken_Square = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.DAKEN, Ashita.Enum.Message.SQUARE)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Daken > Square Hit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Daken > Truestrike
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Daken_Truestrike = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.DAKEN, Ashita.Enum.Message.TRUE)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Daken > Truestrike", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Daken > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Daken_Miss = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.DAKEN, Ashita.Enum.Message.MISS)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MULT_ATK_1] = 1

    return Debug.Unit.Check_Result("Melee - Daken > Miss", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Daken > Crit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Daken_Crit = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.DAKEN, Ashita.Enum.Message.RANGECRIT)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.CRIT_DAMAGE] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.RANGED][DB.Enum.Metric.CRIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.CRIT_DAMAGE] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.CRIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.THROWING][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Daken > Crit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Kick > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Kick_Hit = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_KICK, Ashita.Enum.Message.HIT)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Kick > Hit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Kick > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Kick_Miss = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_KICK, Ashita.Enum.Message.MISS)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Kick > Miss", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - Kick > Critical Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Kick_Crit = function()
    DB.Initialize(true)
    local damage = 100
    local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_KICK, Ashita.Enum.Message.CRIT)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CRIT_DAMAGE] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CRIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.CYCLE] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.CRIT_DAMAGE] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.CRIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.ROUNDS] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_KICK][DB.Enum.Metric.MULT_ATK_1] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MELEE_COUNTERED][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Kick > Crit", player_database)
end