Debug.Unit.Tests.Ability = {}

------------------------------------------------------------------------------------------------------
-- Ability - Damaging > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Damaging_Hit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 46
    local action_name = "Shield Bash"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.ABILITY] = T{}
    player[index][DB.Enum.Trackable.ABILITY][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.ABILITY_DAMAGING] = T{}
    player[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.TOTAL] = T{}
    player[index][DB.Enum.Trackable.TOTAL][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_DAMAGING] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Ability - Damaging > Hit", player, player_catalog)
end

------------------------------------------------------------------------------------------------------
-- Ability - Damaging > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Damaging_Miss = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local action_id = 46
    local action_name = "Shield Bash"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.ABILITY] = T{}
    player[index][DB.Enum.Trackable.ABILITY][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.ABILITY_DAMAGING] = T{}
    player[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_DAMAGING] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Ability - Damaging > Miss", player, player_catalog)
end

------------------------------------------------------------------------------------------------------
-- Ability - Damaging > Hit (TP)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Damaging_Hit_TP = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 66
    local action_name = "Jump"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.ABILITY] = T{}
    player[index][DB.Enum.Trackable.ABILITY][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.ABILITY_DAMAGING] = T{}
    player[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.TOTAL] = T{}
    player[index][DB.Enum.Trackable.TOTAL][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_DAMAGING] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Ability - Damaging > Hit (TP)", player, player_catalog)
end

------------------------------------------------------------------------------------------------------
-- Ability - Damaging > Miss (TP)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Damaging_Miss_TP = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local action_id = 66
    local action_name = "Jump"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.ABILITY] = T{}
    player[index][DB.Enum.Trackable.ABILITY][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.ABILITY_DAMAGING] = T{}
    player[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_DAMAGING] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Ability - Damaging > Miss (TP)", player, player_catalog)
end

------------------------------------------------------------------------------------------------------
-- Ability - Healing
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Healing = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 38
    local action_name = "Chakra"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.ALL_HEAL] = T{}
    player[index][DB.Enum.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.ABILITY] = T{}
    player[index][DB.Enum.Trackable.ABILITY][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.ABILITY_HEALING] = T{}
    player[index][DB.Enum.Trackable.ABILITY_HEALING][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.ABILITY_HEALING][DB.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.ABILITY_HEALING][DB.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.ABILITY_HEALING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.ABILITY_HEALING][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_HEALING] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_HEALING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_HEALING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_HEALING][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_HEALING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_HEALING][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Ability - Healing", player, player_catalog)
end

------------------------------------------------------------------------------------------------------
-- Ability - MP
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.MP = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 154
    local action_name = "Devotion"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.ABILITY] = T{}
    player[index][DB.Enum.Trackable.ABILITY][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY] = T{}
    player[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_MP_RECOVERY] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Ability - MP", player, player_catalog)
end

------------------------------------------------------------------------------------------------------
-- Ability > No Damage Buff
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.No_Damage = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 47
    local action_name = "Holy Circle"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.ABILITY] = T{}
    player[index][DB.Enum.Trackable.ABILITY][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.ABILITY_GENERAL] = T{}
    player[index][DB.Enum.Trackable.ABILITY_GENERAL][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_GENERAL] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ABILITY_GENERAL][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Ability > No Damage Buff", player, player_catalog)
end

------------------------------------------------------------------------------------------------------
-- Ability - Avatar > Rage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Avatar_Rage = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 846
    local action_name = "Flaming Crush"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.PET_ABILITY] = T{}
    player[index][DB.Enum.Trackable.PET_ABILITY][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.PET_ABILITY][DB.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.PET_ABILITY][DB.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.PET_ABILITY][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.PET_ABILITY][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.TOTAL] = T{}
    player[index][DB.Enum.Trackable.TOTAL][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.PET] = T{}
    player[index][DB.Enum.Trackable.PET][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.PET_ABILITY] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.ATTEMPTS] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_ABILITY] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Enum.Trackable.TOTAL] = T{}
    pet[index][pet_name][DB.Enum.Trackable.TOTAL][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    pet[index][pet_name][DB.Enum.Trackable.TOTAL_NO_SC][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET][DB.Metric.TOTAL] = damage

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_ABILITY] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.TOTAL] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.MIN] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.MAX] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Ability - Avatar > Rage", player, player_catalog, pet, pet_catalog)
end

------------------------------------------------------------------------------------------------------
-- Ability - Avatar > Ward
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Avatar_Ward = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 853
    local action_name = "Earthen Ward"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.PET_ABILITY] = T{}
    player[index][DB.Enum.Trackable.PET_ABILITY][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.PET_ABILITY][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.PET_ABILITY] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.ATTEMPTS] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_ABILITY] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.ATTEMPTS] = 1

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_ABILITY] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Ability - Avatar > Ward", player, player_catalog, pet, pet_catalog)
end

------------------------------------------------------------------------------------------------------
-- Ability - Avatar > Healing
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Avatar_Healing = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 906
    local action_name = "Healing Ruby"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.ALL_HEAL] = T{}
    player[index][DB.Enum.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.PET_HEAL] = T{}
    player[index][DB.Enum.Trackable.PET_HEAL][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.PET_HEAL][DB.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.PET_HEAL][DB.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.PET_HEAL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.PET_HEAL][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.ATTEMPTS] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Enum.Trackable.ALL_HEAL] = T{}
    pet[index][pet_name][DB.Enum.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.ATTEMPTS] = 1

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.TOTAL] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.MIN] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.MAX] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Ability - Avatar > Healing", player, player_catalog, pet, pet_catalog)
end

------------------------------------------------------------------------------------------------------
-- Ability - Wyvern > Breath Damage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Wyvern_Breath_Damage = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 646
    local action_name = "Flame Breath"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = true

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.PET_ABILITY] = T{}
    player[index][DB.Enum.Trackable.PET_ABILITY][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.PET_ABILITY][DB.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.PET_ABILITY][DB.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.PET_ABILITY][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.PET_ABILITY][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Enum.Trackable.TOTAL] = T{}
    player[index][DB.Enum.Trackable.TOTAL][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.PET] = T{}
    player[index][DB.Enum.Trackable.PET][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.PET_ABILITY] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.ATTEMPTS] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_ABILITY] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Enum.Trackable.TOTAL] = T{}
    pet[index][pet_name][DB.Enum.Trackable.TOTAL][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    pet[index][pet_name][DB.Enum.Trackable.TOTAL_NO_SC][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET][DB.Metric.TOTAL] = damage

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_ABILITY] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.TOTAL] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.MIN] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.MAX] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_ABILITY][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Ability - Wyvern > Breath Damage", player, player_catalog, pet, pet_catalog)
end

------------------------------------------------------------------------------------------------------
-- Ability - Wyvern > Breath Healing
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Wyvern_Breath_Healing = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 640
    local action_name = "Healing Breath"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.ALL_HEAL] = T{}
    player[index][DB.Enum.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.PET_HEAL] = T{}
    player[index][DB.Enum.Trackable.PET_HEAL][DB.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.PET_HEAL][DB.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.PET_HEAL][DB.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.PET_HEAL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.PET_HEAL][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.ATTEMPTS] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Enum.Trackable.ALL_HEAL] = T{}
    pet[index][pet_name][DB.Enum.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.ATTEMPTS] = 1

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.TOTAL] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.MIN] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.MAX] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL][DB.Metric.ATTEMPTS] = 1

    return Debug.Unit.Check_Result("Ability - Wyvern > Breath Healing", player, player_catalog, pet, pet_catalog)
end