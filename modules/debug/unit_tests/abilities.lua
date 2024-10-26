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
    local action_id = 46 -- Shield Bash
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG]["Shield Bash"] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG]["Shield Bash"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG]["Shield Bash"] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG]["Shield Bash"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG]["Shield Bash"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG]["Shield Bash"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG]["Shield Bash"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG]["Shield Bash"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Ability - Damaging > Hit", player_database)
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
    local action_id = 46 -- Shield Bash
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG]["Shield Bash"] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG]["Shield Bash"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG]["Shield Bash"] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG]["Shield Bash"][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Ability - Damaging > Miss", player_database)
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
    local action_id = 66 -- Jump
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG]["Jump"] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG]["Jump"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG]["Jump"] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG]["Jump"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG]["Jump"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG]["Jump"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG]["Jump"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG]["Jump"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Ability - Damaging > Hit (TP)", player_database)
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
    local action_id = 66 -- Jump
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG]["Jump"] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG]["Jump"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG]["Jump"] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_DAMAGING][DB.Enum.Values.CATALOG]["Jump"][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Ability - Damaging > Miss (TP)", player_database)
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
    local action_id = 38 -- Chakra
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.ALL_HEAL] = T{}
    player_database[index][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.ABILITY] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG]["Chakra"] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG]["Chakra"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_HEALING] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_HEALING][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_HEALING][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_HEALING][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_HEALING][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_HEALING][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_HEALING][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_HEALING][DB.Enum.Values.CATALOG]["Chakra"] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_HEALING][DB.Enum.Values.CATALOG]["Chakra"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_HEALING][DB.Enum.Values.CATALOG]["Chakra"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_HEALING][DB.Enum.Values.CATALOG]["Chakra"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_HEALING][DB.Enum.Values.CATALOG]["Chakra"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_HEALING][DB.Enum.Values.CATALOG]["Chakra"][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Ability - Healing", player_database)
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
    local action_id = 154 -- Devotion
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG]["Devotion"] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG]["Devotion"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Enum.Values.CATALOG]["Devotion"] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Enum.Values.CATALOG]["Devotion"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Enum.Values.CATALOG]["Devotion"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Enum.Values.CATALOG]["Devotion"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Enum.Values.CATALOG]["Devotion"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_MP_RECOVERY][DB.Enum.Values.CATALOG]["Devotion"][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Ability - MP", player_database)
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
    local action_id = 47 -- Holy Circle
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG]["Holy Circle"] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY][DB.Enum.Values.CATALOG]["Holy Circle"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_GENERAL] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_GENERAL][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ABILITY_GENERAL][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_GENERAL][DB.Enum.Values.CATALOG]["Holy Circle"] = T{}
    player_database[index][DB.Enum.Trackable.ABILITY_GENERAL][DB.Enum.Values.CATALOG]["Holy Circle"][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Ability > No Damage Buff", player_database)
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
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 846 -- Flaming Crush
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.PET_ABILITY] = T{}
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flaming Crush"] = T{}
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flaming Crush"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flaming Crush"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flaming Crush"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flaming Crush"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flaming Crush"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET] = T{}
    player_database[index][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flaming Crush"] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flaming Crush"][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flaming Crush"][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flaming Crush"][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flaming Crush"][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flaming Crush"][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.TOTAL] = T{}
    pet_database[index][pet][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    pet_database[index][pet][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Ability - Avatar > Rage", player_database, pet_database)
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
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 853 -- Earthen Ward
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.PET_ABILITY] = T{}
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Earthen Ward"] = T{}
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Earthen Ward"][DB.Enum.Metric.COUNT] = 1

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Earthen Ward"] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Earthen Ward"][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Ability - Avatar > Ward", player_database, pet_database)
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
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 906 -- Healing Ruby
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.ALL_HEAL] = T{}
    player_database[index][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL] = T{}
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Ruby"] = T{}
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Ruby"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Ruby"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Ruby"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Ruby"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Ruby"][DB.Enum.Metric.COUNT] = 1

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.ALL_HEAL] = T{}
    pet_database[index][pet][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Ruby"] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Ruby"][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Ruby"][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Ruby"][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Ruby"][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Ruby"][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Ability - Avatar > Healing", player_database, pet_database)
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
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 646 -- Flame Breath
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = true

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.PET_ABILITY] = T{}
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flame Breath"] = T{}
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flame Breath"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flame Breath"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flame Breath"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flame Breath"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flame Breath"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET] = T{}
    player_database[index][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flame Breath"] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flame Breath"][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flame Breath"][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flame Breath"][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flame Breath"][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_ABILITY][DB.Enum.Values.CATALOG]["Flame Breath"][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.TOTAL] = T{}
    pet_database[index][pet][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    pet_database[index][pet][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Ability - Wyvern > Breath Damage", player_database, pet_database)
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
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 640 -- Healing Breath
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.ALL_HEAL] = T{}
    player_database[index][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL] = T{}
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Breath"] = T{}
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Breath"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Breath"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Breath"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Breath"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Breath"][DB.Enum.Metric.COUNT] = 1

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.ALL_HEAL] = T{}
    pet_database[index][pet][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Breath"] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Breath"][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Breath"][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Breath"][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Breath"][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Healing Breath"][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Ability - Wyvern > Breath Healing", player_database, pet_database)
end