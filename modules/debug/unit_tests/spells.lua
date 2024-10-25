Debug.Unit.Tests.Spells = {}

------------------------------------------------------------------------------------------------------
-- Spells > Nuke
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Nuke = function()
    DB.Initialize(true)
    local damage = 100
    local action_id = 145   -- Fire II
    local mp_cost = 68
    local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Spells > Nuke", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells > Nuke AOE
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Nuke_AOE = function()
    DB.Initialize(true)
    local damage = 100
    local damage_two = 200
    local action_id = 174 -- Firaga
    local mp_cost = 71
    local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage, nil, nil, nil, nil, damage_two)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = damage + damage_two
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage + damage_two
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage_two
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Firaga"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.TOTAL] = damage + damage_two
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MAX] = damage_two
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage + damage_two
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage + damage_two

    return Debug.Unit.Check_Result("Spells > Nuke AOE", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells > Nuke (Burst)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Nuke_Burst = function()
    DB.Initialize(true)
    local damage = 100
    local action_id = 145   -- Fire II
    local mp_cost = 68
    local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage, nil, Ashita.Enum.Message.BURST)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.BURST_DAMAGE] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.BURST_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.BURST_DAMAGE] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.BURST_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.BURST_DAMAGE] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.BURST_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Spells > Nuke", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells > Pet Nuke
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Pet_Nuke = function()
    DB.Initialize(true)
    local damage = 100
    local action_id = 145   -- Fire II
    local mp_cost = 68
    local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MAGIC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.PET_NUKE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage

    local pet_database = T{}
    pet_database["Player:Debug"] = T{}
    pet_database["Player:Debug"]["Pet Name"] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_MAGIC] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_NUKE] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.TOTAL] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MIN] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MAX] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.COUNT] = 1
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.TOTAL] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MIN] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MAX] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.COUNT] = 1
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_NUKE][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MP_SPENT] = mp_cost
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.TOTAL] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Spells > Pet Nuke", player_database, pet_database)
end

------------------------------------------------------------------------------------------------------
-- Spells > Healing
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Healing = function()
    DB.Initialize(true)
    local damage = 100
    local action_id = 3   -- Cure III
    local mp_cost = 46
    local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.ALL_HEAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Cure III"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells > Healing", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells > Healing AOE
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Healing_AOE = function()
    DB.Initialize(true)
    local damage = 100
    local damage_two = 200
    local action_id = 8 -- Curaga II
    local mp_cost = 120
    local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage, nil, nil, nil, nil, damage_two)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.ALL_HEAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage + damage_two
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Metric.TOTAL] = damage + damage_two
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MAX] = damage_two
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Curaga II"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Curaga II"][DB.Enum.Metric.TOTAL] = damage + damage_two
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Curaga II"][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Curaga II"][DB.Enum.Metric.MAX] = damage_two
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Curaga II"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Curaga II"][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.HEALING][DB.Enum.Values.CATALOG]["Curaga II"][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells > Healing AOE", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells > Pet Heal
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Pet_Heal = function()
    DB.Initialize(true)
    local damage = 100
    local action_id = 3   -- Cure III
    local mp_cost = 46
    local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MAGIC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.ALL_HEAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_HEAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MP_SPENT] = mp_cost

    local pet_database = T{}
    pet_database["Player:Debug"] = T{}
    pet_database["Player:Debug"]["Pet Name"] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_MAGIC] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.ALL_HEAL] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.ALL_HEAL][DB.Enum.Metric.TOTAL] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_HEAL] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.TOTAL] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MIN] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MAX] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.COUNT] = 1
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Metric.MP_SPENT] = mp_cost
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.TOTAL] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MIN] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MAX] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.COUNT] = 1
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_HEAL][DB.Enum.Values.CATALOG]["Cure III"][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells > Pet Heal", player_database, pet_database)
end

------------------------------------------------------------------------------------------------------
-- Spells - DoT > No Damage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.DoT_No_Damage = function()
    DB.Initialize(true)
    local damage = 0
    local action_id = 230 -- Bio
    local mp_cost = 15
    local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells - DoT > No Damage", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells - DoT > Damage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.DoT_Damage = function()
    DB.Initialize(true)
    local damage = 1
    local action_id = 230 -- Bio
    local mp_cost = 15
    local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.NUKE][DB.Enum.Values.CATALOG]["Bio"][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Spells - DoT > Damage", player_database)
end

------------------------------------------------------------------------------------------------------
-- Spells - Aspir
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Aspir = function()
    DB.Initialize(true)
    local damage = 100
    local action_id = 247 -- Aspir
    local mp_cost = 10
    local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MAGIC][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.MP_SPENT] = mp_cost
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Aspir"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Aspir"][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Aspir"][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Aspir"][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Aspir"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Aspir"][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Aspir"][DB.Enum.Metric.MP_SPENT] = mp_cost

    return Debug.Unit.Check_Result("Spells - Aspir", player_database)
end