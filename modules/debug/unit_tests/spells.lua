Debug.Unit.Tests.Spells = {}

------------------------------------------------------------------------------------------------------
-- Spells > Nuke
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Nuke = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 145   -- Fire II
    local mp_cost = 68
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.NUKE] = T{}
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"] = T{}
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Spells > Nuke", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells > Nuke AOE
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Nuke_AOE = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local index_two = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY_TWO.name
    local damage = 100
    local damage_two = 200
    local action_id = 174 -- Firaga
    local mp_cost = 71
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage, nil, nil, nil, Debug.Unit.Mob.Target_ID_Two, damage_two)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    -- Ga-spell metrics are calculated outside of the target loop so only the second target has them documented.
    -- This could be a problem only if the second mob has a different name and a mob filter is used.
    -- But if I counted it for the first mob too then damage could be double counted when there is no mob filter used and the mobs have different names.
    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.NUKE] = T{}
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Firaga"] = T{}
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    -- In this case, a catalog minimum for Firaga isn't set because the first mob already set the minimum to 100. Retrieving catalog minimums searches
    -- everything. This could be a problem if the mob filter is used on the second mob because it's minimum hasn't been set yet.
    player_database[index_two] = T{}
    player_database[index_two][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index_two][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index_two][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index_two][DB.Enum.Trackable.NUKE] = T{}
    player_database[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage_two
    player_database[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage_two
    player_database[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG] = T{}
    player_database[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Firaga"] = T{}
    player_database[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MIN] = damage_two
    player_database[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MAX] = damage_two
    player_database[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index_two][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index_two][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index_two][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index_two][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage_two

    return Debug.Unit.Check_Result("Spells > Nuke AOE", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells > Nuke (Burst)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Nuke_Burst = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 145   -- Fire II
    local mp_cost = 68
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.BURST}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage, primary)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.BURST_DAMAGE] = damage
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.BURST_COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE] = T{}
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.BURST_DAMAGE] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.BURST_COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"] = T{}
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.BURST_DAMAGE] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.BURST_COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Spells > Nuke Burst", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells > Pet Nuke
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Pet_Nuke = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 145   -- Fire II
    local mp_cost = 68
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.PET_MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.PET_MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.PET_NUKE] = T{}
    player_database[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"] = T{}
    player_database[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET] = T{}
    player_database[index][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_MAGIC] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    pet_database[index][pet][DB.Enum.Trackable.PET_NUKE] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    pet_database[index][pet][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MP_SPENT] = mp_cost
    pet_database[index][pet][DB.Enum.Trackable.TOTAL] = T{}
    pet_database[index][pet][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    pet_database[index][pet][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Spells > Pet Nuke", player_database, pet_database)
end

------------------------------------------------------------------------------------------------------
-- Spells > Healing
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Healing = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.PLAYER_TWO.name
    local index_two = Debug.Unit.Mob.PLAYER_TWO.name .. ":" .. tostring(player_name)
    local damage = 100
    local action_id = 3   -- Cure III
    local mp_cost = 46
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER_TWO.id, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.ALL_HEAL] = T{}
    player_database[index][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.HEALING] = T{}
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Cure III"] = T{}
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MP_SPENT] = mp_cost

    player_database[index_two] = T{}
    player_database[index_two][DB.Enum.Trackable.HEALING_RECEIVED] = T{}
    player_database[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Metric.TOTAL] = damage
    player_database[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Metric.MIN] = damage
    player_database[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Metric.MAX] = damage
    player_database[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Metric.COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Values.CATALOG] = T{}
    player_database[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Values.CATALOG]["Cure III"] = T{}
    player_database[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.TOTAL] = damage
    player_database[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MIN] = damage
    player_database[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MAX] = damage
    player_database[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells > Healing", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells > Healing AOE
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Healing_AOE = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local index_two = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY_TWO.name
    local damage = 100
    local damage_two = 200
    local action_id = 8 -- Curaga II
    local mp_cost = 120
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage, nil, nil, nil, Debug.Unit.Mob.Target_ID_Two, damage_two)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    -- Ga-spell metrics are calculated outside of the target loop so only the second target has them documented.
    -- This could be a problem only if the second mob has a different name and a mob filter is used.
    -- But if I counted it for the first mob too then damage could be double counted when there is no mob filter used and the mobs have different names.
    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.ALL_HEAL] = T{}
    player_database[index][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.HEALING] = T{}
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Curaga II"] = T{}
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Curaga II"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Curaga II"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Curaga II"][DB.Enum.Metric.MAX] = damage

    -- In this case, a catalog minimum for Curaga II isn't set because the first mob already set the minimum to 100. Retrieving catalog minimums searches
    -- everything. This could be a problem if the mob filter is used on the second mob because it's minimum hasn't been set yet.
    player_database[index_two] = T{}
    player_database[index_two][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index_two][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index_two][DB.Enum.Trackable.ALL_HEAL] = T{}
    player_database[index_two][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index_two][DB.Enum.Trackable.HEALING] = T{}
    player_database[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MIN] = damage_two
    player_database[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MAX] = damage_two
    player_database[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Metric.COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG] = T{}
    player_database[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Curaga II"] = T{}
    player_database[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Curaga II"][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Curaga II"][DB.Enum.Metric.MIN] = damage_two
    player_database[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Curaga II"][DB.Enum.Metric.MAX] = damage_two
    player_database[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Curaga II"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Curaga II"][DB.Enum.Metric.COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Curaga II"][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells > Healing AOE", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells > Pet Heal
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Pet_Heal = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 3   -- Cure III
    local mp_cost = 46
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.PET_MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.PET_MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.ALL_HEAL] = T{}
    player_database[index][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL] = T{}
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"] = T{}
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MP_SPENT] = mp_cost

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_MAGIC] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    pet_database[index][pet][DB.Enum.Trackable.ALL_HEAL] = T{}
    pet_database[index][pet][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MP_SPENT] = mp_cost
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells > Pet Heal", player_database, pet_database)
end

------------------------------------------------------------------------------------------------------
-- Spells - DoT > No Damage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.DoT_No_Damage = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local action_id = 230 -- Bio
    local mp_cost = 15
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.NUKE] = T{}
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"] = T{}
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells - DoT > No Damage", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells - DoT > Damage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.DoT_Damage = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 1
    local action_id = 230 -- Bio
    local mp_cost = 15
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.NUKE] = T{}
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"] = T{}
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Spells - DoT > Damage", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells - Aspir
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Aspir = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 247 -- Aspir
    local mp_cost = 10
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.MP_DRAIN] = T{}
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Aspir"] = T{}
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Aspir"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Aspir"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Aspir"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Aspir"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Aspir"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Aspir"][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells - Aspir", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells - Enfeeble > Land
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Enfeeble_Land = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 252 -- Stun
    local mp_cost = 25
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.ENF_LAND}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage, primary)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.ENFEEBLE] = T{}
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.AOE_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Stun"] = T{}
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Stun"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Stun"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Stun"][DB.Enum.Metric.AOE_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Stun"][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells - Enfeeble > Land", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells - Enfeeble > Resist
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Enfeeble_Resist = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 252 -- Stun
    local mp_cost = 25
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RESIST}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage, primary)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.ENFEEBLE] = T{}
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.AOE_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Stun"] = T{}
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Stun"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Stun"][DB.Enum.Metric.AOE_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Stun"][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells - Enfeeble > Resist", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells - Enfeeble > No Effect
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Enfeeble_No_Effect = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 252 -- Stun
    local mp_cost = 25
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.NO_EFFECT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage, primary)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.ENFEEBLE] = T{}
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.AOE_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Stun"] = T{}
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Stun"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Stun"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Stun"][DB.Enum.Metric.AOE_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Stun"][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells - Enfeeble > No Effect", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells - Enfeeble > AOE Land
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Enfeeble_AOE_Land = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local index_two = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY_TWO.name
    local damage = 100
    local damage_two = 200
    local action_id = 274 -- Sleepga II
    local mp_cost = 58
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.ENF_LAND}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage, primary, nil, nil, Debug.Unit.Mob.Target_ID_Two, damage_two)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    -- Ga-spell metrics are calculated outside of the target loop so only the second target has them documented.
    -- This could be a problem only if the second mob has a different name and a mob filter is used.
    -- But if I counted it for the first mob too then damage could be double counted when there is no mob filter used and the mobs have different names.
    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.ENFEEBLE] = T{}
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.AOE_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Sleepga II"] = T{}
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Sleepga II"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Sleepga II"][DB.Enum.Metric.AOE_COUNT] = 1

    player_database[index_two] = T{}
    player_database[index_two][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index_two][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index_two][DB.Enum.Trackable.ENFEEBLE] = T{}
    player_database[index_two][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.AOE_COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index_two][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG] = T{}
    player_database[index_two][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Sleepga II"] = T{}
    player_database[index_two][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Sleepga II"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Sleepga II"][DB.Enum.Metric.COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Sleepga II"][DB.Enum.Metric.AOE_COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Values.CATALOG]["Sleepga II"][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells - Enfeeble > AOE Land", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells - Song
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Song = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. tostring(player_name)
    local damage = 0
    local action_id = 398 -- Valor Minuet V
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.BUFF_SONG] = T{}
    player_database[index][DB.Enum.Trackable.BUFF_SONG][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.BUFF_SONG][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.BUFF_SONG][DB.Enum.Values.CATALOG]["Valor Minuet V"] = T{}
    player_database[index][DB.Enum.Trackable.BUFF_SONG][DB.Enum.Values.CATALOG]["Valor Minuet V"][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Spells - Song", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells - Status_Removal
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Status_Removal = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.PLAYER_TWO.name
    local damage = 128      -- Burn
    local action_id = 143   -- Erase
    local mp_cost = 18
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER_TWO.id, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC] = T{}
    player_database[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database[index][DB.Enum.Trackable.DEBUFF_REMOVAL] = T{}
    player_database[index][DB.Enum.Trackable.DEBUFF_REMOVAL][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEBUFF_REMOVAL][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.DEBUFF_REMOVAL][DB.Enum.Values.CATALOG]["Erase"] = T{}
    player_database[index][DB.Enum.Trackable.DEBUFF_REMOVAL][DB.Enum.Values.CATALOG]["Erase"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEBUFF_REMOVAL][DB.Enum.Values.CATALOG]["Erase"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEBUFF_REMOVAL][DB.Enum.Values.CATALOG]["Erase"][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells - Status_Removal", player_database)
end