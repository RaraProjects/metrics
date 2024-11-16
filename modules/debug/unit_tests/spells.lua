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
    local action_id = 145
    local action_name = "Fire II"
    local mp_cost = 68
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.MAGIC] = T{}
    player[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index][DB.Enum.Trackable.NUKE] = T{}
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index][DB.Enum.Trackable.TOTAL] = T{}
    player[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells > Nuke", player, player_catalog)
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
    local action_id = 174
    local action_name = "Firaga"
    local mp_cost = 71
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage, nil, nil, nil, Debug.Unit.Mob.Target_ID_Two, damage_two)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    -- Ga-spell metrics are calculated outside of the target loop so only the second target has them documented.
    -- This could be a problem only if the second mob has a different name and a mob filter is used.
    -- But if I counted it for the first mob too then damage could be double counted when there is no mob filter used and the mobs have different names.
    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.MAGIC] = T{}
    player[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.NUKE] = T{}
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.TOTAL] = T{}
    player[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage
    -- In this case, a catalog minimum for Firaga isn't set because the first mob already set the minimum to 100. Retrieving catalog minimums searches
    -- everything. This could be a problem if the mob filter is used on the second mob because it's minimum hasn't been set yet.
    player[index_two] = T{}
    player[index_two][DB.Enum.Trackable.MAGIC] = T{}
    player[index_two][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = damage_two
    player[index_two][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index_two][DB.Enum.Trackable.NUKE] = T{}
    player[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage_two
    player[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage_two
    player[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage_two
    player[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player[index_two][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index_two][DB.Enum.Trackable.TOTAL] = T{}
    player[index_two][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage_two
    player[index_two][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index_two][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage_two

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage
    player_catalog[index_two] = T{}
    player_catalog[index_two][action_name] = T{}
    player_catalog[index_two][action_name][DB.Enum.Trackable.NUKE] = T{}
    player_catalog[index_two][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage_two
    player_catalog[index_two][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage_two
    player_catalog[index_two][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage_two
    player_catalog[index_two][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index_two][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player_catalog[index_two][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells > Nuke AOE", player, player_catalog)
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
    local action_id = 145
    local action_name = "Fire II"
    local mp_cost = 68
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.BURST}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage, primary)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.MAGIC] = T{}
    player[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.BURST_DAMAGE] = damage
    player[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.BURST_COUNT] = 1
    player[index][DB.Enum.Trackable.NUKE] = T{}
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.BURST_DAMAGE] = damage
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.BURST_COUNT] = 1
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index][DB.Enum.Trackable.TOTAL] = T{}
    player[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.BURST_DAMAGE] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.BURST_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells > Nuke Burst", player, player_catalog)
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
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 145
    local action_name = "Fire II"
    local mp_cost = 68
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.PET_MAGIC] = T{}
    player[index][DB.Enum.Trackable.PET_MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index][DB.Enum.Trackable.PET_NUKE] = T{}
    player[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index][DB.Enum.Trackable.TOTAL] = T{}
    player[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.PET] = T{}
    player[index][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.PET_NUKE] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_MAGIC] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    pet[index][pet_name][DB.Enum.Trackable.PET_NUKE] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MIN] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MAX] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    pet[index][pet_name][DB.Enum.Trackable.TOTAL] = T{}
    pet[index][pet_name][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    pet[index][pet_name][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_NUKE] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.TOTAL] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MIN] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MAX] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells > Pet Nuke", player, player_catalog, pet, pet_catalog)
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
    local action_id = 3
    local action_name = "Cure III"
    local mp_cost = 46
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER_TWO.id, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.MAGIC] = T{}
    player[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index][DB.Enum.Trackable.ALL_HEAL] = T{}
    player[index][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.HEALING] = T{}
    player[index][DB.Enum.Trackable.HEALING][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.HEALING][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.HEALING][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index_two] = T{}
    player[index_two][DB.Enum.Trackable.HEALING_RECEIVED] = T{}
    player[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Metric.TOTAL] = damage
    player[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Metric.MIN] = damage
    player[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Metric.MAX] = damage
    player[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Metric.HIT_COUNT] = 1
    player[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Metric.COUNT] = 1
    player[index_two][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Metric.MP_SPENT] = mp_cost

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.HEALING] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.HEALING][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.HEALING][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.HEALING][DB.Enum.Metric.COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_catalog[index_two] = T{}
    player_catalog[index_two][action_name] = T{}
    player_catalog[index_two][action_name][DB.Enum.Trackable.HEALING_RECEIVED] = T{}
    player_catalog[index_two][action_name][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index_two][action_name][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Metric.MIN] = damage
    player_catalog[index_two][action_name][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Metric.MAX] = damage
    player_catalog[index_two][action_name][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index_two][action_name][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Metric.COUNT] = 1
    player_catalog[index_two][action_name][DB.Enum.Trackable.HEALING_RECEIVED][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells > Healing", player, player_catalog)
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
    local action_id = 8
    local action_name = "Curaga II"
    local mp_cost = 120
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage, nil, nil, nil, Debug.Unit.Mob.Target_ID_Two, damage_two)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    -- Ga-spell metrics are calculated outside of the target loop so only the second target has them documented.
    -- This could be a problem only if the second mob has a different name and a mob filter is used.
    -- But if I counted it for the first mob too then damage could be double counted when there is no mob filter used and the mobs have different names.
    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.MAGIC] = T{}
    player[index][DB.Enum.Trackable.ALL_HEAL] = T{}
    player[index][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.HEALING] = T{}
    player[index][DB.Enum.Trackable.HEALING][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MAX] = damage
    -- In this case, a catalog minimum for Curaga II isn't set because the first mob already set the minimum to 100. Retrieving catalog minimums searches
    -- everything. This could be a problem if the mob filter is used on the second mob because it's minimum hasn't been set yet.
    player[index_two] = T{}
    player[index_two][DB.Enum.Trackable.MAGIC] = T{}
    player[index_two][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index_two][DB.Enum.Trackable.ALL_HEAL] = T{}
    player[index_two][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage_two
    player[index_two][DB.Enum.Trackable.HEALING] = T{}
    player[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Metric.TOTAL] = damage_two
    player[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MIN] = damage_two
    player[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MAX] = damage_two
    player[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Metric.HIT_COUNT] = 1
    player[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Metric.COUNT] = 1
    player[index_two][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MP_SPENT] = mp_cost

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.HEALING] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.HEALING][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MAX] = damage
    player_catalog[index_two] = T{}
    player_catalog[index_two][action_name] = T{}
    player_catalog[index_two][action_name][DB.Enum.Trackable.HEALING] = T{}
    player_catalog[index_two][action_name][DB.Enum.Trackable.HEALING][DB.Enum.Metric.TOTAL] = damage_two
    player_catalog[index_two][action_name][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MIN] = damage_two
    player_catalog[index_two][action_name][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MAX] = damage_two
    player_catalog[index_two][action_name][DB.Enum.Trackable.HEALING][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index_two][action_name][DB.Enum.Trackable.HEALING][DB.Enum.Metric.COUNT] = 1
    player_catalog[index_two][action_name][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells > Healing AOE", player, player_catalog)
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
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 3
    local action_name = "Cure III"
    local mp_cost = 46
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.PET_MAGIC] = T{}
    player[index][DB.Enum.Trackable.PET_MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index][DB.Enum.Trackable.ALL_HEAL] = T{}
    player[index][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.PET_HEAL] = T{}
    player[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MP_SPENT] = mp_cost

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MP_SPENT] = mp_cost

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_MAGIC] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    pet[index][pet_name][DB.Enum.Trackable.ALL_HEAL] = T{}
    pet[index][pet_name][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MIN] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MAX] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MP_SPENT] = mp_cost

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.TOTAL] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MIN] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MAX] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells > Pet Heal", player, player_catalog, pet, pet_catalog)
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
    local action_id = 230
    local action_name = "Bio"
    local mp_cost = 15
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.MAGIC] = T{}
    player[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index][DB.Enum.Trackable.NUKE] = T{}
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells - DoT > No Damage", player, player_catalog)
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
    local action_id = 230
    local action_name = "Bio"
    local mp_cost = 15
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.MAGIC] = T{}
    player[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index][DB.Enum.Trackable.NUKE] = T{}
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index][DB.Enum.Trackable.TOTAL] = T{}
    player[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells - DoT > Damage", player, player_catalog)
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
    local action_id = 247
    local action_name = "Aspir"
    local mp_cost = 10
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.MAGIC] = T{}
    player[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index][DB.Enum.Trackable.MP_DRAIN] = T{}
    player[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.MP_SPENT] = mp_cost

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.MP_DRAIN] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells - Aspir", player, player_catalog)
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
    local action_id = 252
    local action_name = "Stun"
    local mp_cost = 25
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.ENF_LAND}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage, primary)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.MAGIC] = T{}
    player[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index][DB.Enum.Trackable.ENFEEBLE] = T{}
    player[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.AOE_COUNT] = 1
    player[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.MP_SPENT] = mp_cost

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ENFEEBLE] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.AOE_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells - Enfeeble > Land", player, player_catalog)
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
    local action_id = 252
    local action_name = "Stun"
    local mp_cost = 25
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RESIST}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage, primary)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.MAGIC] = T{}
    player[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index][DB.Enum.Trackable.ENFEEBLE] = T{}
    player[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.AOE_COUNT] = 1
    player[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.MP_SPENT] = mp_cost

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ENFEEBLE] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.AOE_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells - Enfeeble > Resist", player, player_catalog)
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
    local action_id = 252
    local action_name = "Stun"
    local mp_cost = 25
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.NO_EFFECT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage, primary)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.MAGIC] = T{}
    player[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index][DB.Enum.Trackable.ENFEEBLE] = T{}
    player[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.AOE_COUNT] = 1
    player[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.MP_SPENT] = mp_cost

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ENFEEBLE] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.AOE_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells - Enfeeble > No Effect", player, player_catalog)
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
    local action_id = 274
    local action_name = "Sleepga II"
    local mp_cost = 58
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.ENF_LAND}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage, primary, nil, nil, Debug.Unit.Mob.Target_ID_Two, damage_two)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    -- Ga-spell metrics are calculated outside of the target loop so only the second target has them documented.
    -- This could be a problem only if the second mob has a different name and a mob filter is used.
    -- But if I counted it for the first mob too then damage could be double counted when there is no mob filter used and the mobs have different names.
    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.MAGIC] = T{}
    player[index][DB.Enum.Trackable.ENFEEBLE] = T{}
    player[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.AOE_COUNT] = 1
    player[index_two] = T{}
    player[index_two][DB.Enum.Trackable.MAGIC] = T{}
    player[index_two][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index_two][DB.Enum.Trackable.ENFEEBLE] = T{}
    player[index_two][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.HIT_COUNT] = 1
    player[index_two][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.COUNT] = 1
    player[index_two][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.AOE_COUNT] = 1
    player[index_two][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.MP_SPENT] = mp_cost

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ENFEEBLE] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.AOE_COUNT] = 1
    player_catalog[index_two] = T{}
    player_catalog[index_two][action_name] = T{}
    player_catalog[index_two][action_name][DB.Enum.Trackable.ENFEEBLE] = T{}
    player_catalog[index_two][action_name][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index_two][action_name][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.COUNT] = 1
    player_catalog[index_two][action_name][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.AOE_COUNT] = 1
    player_catalog[index_two][action_name][DB.Enum.Trackable.ENFEEBLE][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells - Enfeeble > AOE Land", player, player_catalog)
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
    local action_id = 398
    local action_name = "Valor Minuet V"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.BUFF_SONG] = T{}
    player[index][DB.Enum.Trackable.BUFF_SONG][DB.Enum.Metric.COUNT] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.BUFF_SONG] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.BUFF_SONG][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Spells - Song", player, player_catalog)
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
    local action_id = 143
    local action_name = "Erase"
    local mp_cost = 18
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER_TWO.id, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.MAGIC] = T{}
    player[index][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player[index][DB.Enum.Trackable.DEBUFF_REMOVAL] = T{}
    player[index][DB.Enum.Trackable.DEBUFF_REMOVAL][DB.Enum.Metric.COUNT] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.DEBUFF_REMOVAL] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.DEBUFF_REMOVAL][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.DEBUFF_REMOVAL][DB.Enum.Metric.COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.DEBUFF_REMOVAL][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells - Status_Removal", player, player_catalog)
end