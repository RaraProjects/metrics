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

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND] = T{}
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MIN] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MAX] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.DEF_COUNTERED] = T{}
    player[index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Main-Hand > Hit", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND] = T{}
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.DEF_COUNTERED] = T{}
    player[index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Melee - Main-Hand > Miss", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.CRITICAL_DAMAGE] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.CRITICAL_COUNT] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND] = T{}
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MIN] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MAX] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.CRITICAL_DAMAGE] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.CRITICAL_COUNT] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.DEF_COUNTERED] = T{}
    player[index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Main-Hand > Crit", player)
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
    local add_effect_animation = 1
    local add_effect_name = "Enfire"
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.HIT}
    local add_effect = {param = additional_damage, animation = add_effect_animation, message = Ashita.Enum.Message.ENSPELL}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND] = T{}
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MIN] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MAX] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.DEF_COUNTERED] = T{}
    player[index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = additional_damage
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_ENSPELL] = T{}
    player[index][DB.Trackable.MELEE_ENSPELL][DB.Metric.TOTAL] = additional_damage
    player[index][DB.Trackable.MELEE_ENSPELL][DB.Metric.MIN] = additional_damage
    player[index][DB.Trackable.MELEE_ENSPELL][DB.Metric.MAX] = additional_damage
    player[index][DB.Trackable.MELEE_ENSPELL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage + additional_damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage + additional_damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][add_effect_name] = T{}
    player_catalog[index][add_effect_name][DB.Trackable.MELEE_ENSPELL] = T{}
    player_catalog[index][add_effect_name][DB.Trackable.MELEE_ENSPELL][DB.Metric.TOTAL] = additional_damage
    player_catalog[index][add_effect_name][DB.Trackable.MELEE_ENSPELL][DB.Metric.MIN] = additional_damage
    player_catalog[index][add_effect_name][DB.Trackable.MELEE_ENSPELL][DB.Metric.MAX] = additional_damage
    player_catalog[index][add_effect_name][DB.Trackable.MELEE_ENSPELL][DB.Metric.HIT_COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Main-Hand > Enspell", player, player_catalog)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.SHADOW_ABSORPTION] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND] = T{}
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.SHADOW_ABSORPTION] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.DEF_COUNTERED] = T{}
    player[index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Melee - Main-Hand > Shadows", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MOB_HEALING] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND] = T{}
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MOB_HEALING] = damage
    player[index][DB.Trackable.DEF_COUNTERED] = T{}
    player[index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Melee - Main-Hand > Mob Heal", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_OFF_HAND] = T{}
    player[index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.MIN] = damage
    player[index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.MAX] = damage
    player[index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.DEF_COUNTERED] = T{}
    player[index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Off-Hand > Hit", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_OFF_HAND] = T{}
    player[index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.DEF_COUNTERED] = T{}
    player[index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Melee - Off-Hand > Miss", player)
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
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.HIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.PET_OVERALL] = T{}
    player[index][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.PET_MELEE_OVERALL] = T{}
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.PET_MELEE_DISCRETE] = T{}
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.MIN] = damage
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.MAX] = damage
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.PET_OVERALL] = T{}
    pet[index][pet_name][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL] = T{}
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE] = T{}
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Trackable.TOTAL_DAMAGE] = T{}
    pet[index][pet_name][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    pet[index][pet_name][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Pet > Hit", player, nil, pet)
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
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.MISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.PET_MELEE_OVERALL] = T{}
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.PET_MELEE_DISCRETE] = T{}
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL] = T{}
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE] = T{}
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Melee - Pet > Miss", player, nil, pet)
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
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.CRIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.PET_OVERALL] = T{}
    player[index][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.PET_MELEE_OVERALL] = T{}
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.CRITICAL_DAMAGE] = damage
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.CRITICAL_COUNT] = 1
    player[index][DB.Trackable.PET_MELEE_DISCRETE] = T{}
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.MIN] = damage
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.MAX] = damage
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.CRITICAL_DAMAGE] = damage
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.CRITICAL_COUNT] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.PET_OVERALL] = T{}
    pet[index][pet_name][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL] = T{}
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.CRITICAL_DAMAGE] = damage
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.CRITICAL_COUNT] = 1
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE] = T{}
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.CRITICAL_DAMAGE] = damage
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.CRITICAL_COUNT] = 1
    pet[index][pet_name][DB.Trackable.TOTAL_DAMAGE] = T{}
    pet[index][pet_name][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    pet[index][pet_name][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Pet > Crit", player, nil, pet)
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
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.SHADOWS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.PET_MELEE_OVERALL] = T{}
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.SHADOW_ABSORPTION] = 1
    player[index][DB.Trackable.PET_MELEE_DISCRETE] = T{}
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.SHADOW_ABSORPTION] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL] = T{}
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.SHADOW_ABSORPTION] = 1
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE] = T{}
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.SHADOW_ABSORPTION] = 1

    return Debug.Unit.Check_Result("Melee - Pet > Shadows", player, nil, pet)
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
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.MOBHEAL373}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.PET_MELEE_OVERALL] = T{}
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.MOB_HEALING] = damage
    player[index][DB.Trackable.PET_MELEE_DISCRETE] = T{}
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.MOB_HEALING] = damage

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL] = T{}
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.MOB_HEALING] = damage
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE] = T{}
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.MOB_HEALING] = damage

    return Debug.Unit.Check_Result("Melee - Pet > Mob Heal", player, nil, pet)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.RANGED_OVERALL] = T{}
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_THROWING] = T{}
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Daken > Hit", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.RANGED_OVERALL] = T{}
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_THROWING] = T{}
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Daken > Square Hit", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.RANGED_OVERALL] = T{}
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_THROWING] = T{}
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Daken > Truestrike", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.RANGED_OVERALL] = T{}
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_THROWING] = T{}
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.MULTI_ATTACK_1] = 1

    return Debug.Unit.Check_Result("Melee - Daken > Miss", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.RANGED_OVERALL] = T{}
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.CRITICAL_DAMAGE] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.CRITICAL_COUNT] = 1
    player[index][DB.Trackable.RANGED_THROWING] = T{}
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.CRITICAL_DAMAGE] = damage
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.CRITICAL_COUNT] = 1
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.RANGED_THROWING][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Daken > Crit", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_KICK_ATTACKS] = T{}
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.MIN] = damage
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.MAX] = damage
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.DEF_COUNTERED] = T{}
    player[index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Kick > Hit", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_KICK_ATTACKS] = T{}
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.DEF_COUNTERED] = T{}
    player[index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Melee - Kick > Miss", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.CRITICAL_DAMAGE] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.CRITICAL_COUNT] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_KICK_ATTACKS] = T{}
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.MIN] = damage
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.MAX] = damage
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.CRITICAL_DAMAGE] = damage
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.CRITICAL_COUNT] = 1
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.DEF_COUNTERED] = T{}
    player[index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Kick > Crit", player)
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
    local add_effect_animation = 1
    local add_effect_name = "Fire"
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.HIT}
    local add_effect = {param = additional_damage, animation = add_effect_animation, message = Ashita.Enum.Message.ENDAMAGE}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND] = T{}
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MIN] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MAX] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.DEF_COUNTERED] = T{}
    player[index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = additional_damage
    player[index][DB.Trackable.MELEE_ENDAMAGE] = T{}
    player[index][DB.Trackable.MELEE_ENDAMAGE][DB.Metric.TOTAL] = additional_damage
    player[index][DB.Trackable.MELEE_ENDAMAGE][DB.Metric.MIN] = additional_damage
    player[index][DB.Trackable.MELEE_ENDAMAGE][DB.Metric.MAX] = additional_damage
    player[index][DB.Trackable.MELEE_ENDAMAGE][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage + additional_damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage + additional_damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][add_effect_name] = T{}
    player_catalog[index][add_effect_name][DB.Trackable.MELEE_ENDAMAGE] = T{}
    player_catalog[index][add_effect_name][DB.Trackable.MELEE_ENDAMAGE][DB.Metric.TOTAL] = additional_damage
    player_catalog[index][add_effect_name][DB.Trackable.MELEE_ENDAMAGE][DB.Metric.MIN] = additional_damage
    player_catalog[index][add_effect_name][DB.Trackable.MELEE_ENDAMAGE][DB.Metric.MAX] = additional_damage
    player_catalog[index][add_effect_name][DB.Trackable.MELEE_ENDAMAGE][DB.Metric.HIT_COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Main-Hand > Endamage", player, player_catalog)
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
    local additional_damage = 5
    local add_effect_name = "Blind"
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.HIT}
    local add_effect = {param = additional_damage, animation = nil, message = Ashita.Enum.Message.ENDEBUFF}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND] = T{}
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MIN] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MAX] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.DEF_COUNTERED] = T{}
    player[index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_ENDEBUFF] = T{}
    player[index][DB.Trackable.MELEE_ENDEBUFF][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][add_effect_name] = T{}
    player_catalog[index][add_effect_name][DB.Trackable.MELEE_ENDEBUFF] = T{}
    player_catalog[index][add_effect_name][DB.Trackable.MELEE_ENDEBUFF][DB.Metric.HIT_COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Main-Hand > Endebuff", player, player_catalog)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND] = T{}
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MIN] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MAX] = damage
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.DEF_COUNTERED] = T{}
    player[index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_ENDRAIN] = T{}
    player[index][DB.Trackable.MELEE_ENDRAIN][DB.Metric.TOTAL] = additional_damage
    player[index][DB.Trackable.MELEE_ENDRAIN][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Melee - Main-Hand > Endrain", player)
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

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND] = T{}
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
    player[index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
    player[index][DB.Trackable.DEF_COUNTERED] = T{}
    player[index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_ENASPIR] = T{}
    player[index][DB.Trackable.MELEE_ENASPIR][DB.Metric.TOTAL] = additional_damage
    player[index][DB.Trackable.MELEE_ENASPIR][DB.Metric.HIT_COUNT] = 1

    return Debug.Unit.Check_Result("Melee - Main-Hand > Enaspir", player)
end