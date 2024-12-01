Debug.Unit.Tests.Spells = {}

------------------------------------------------------------------------------------------------------
-- Spells > Nuke
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Nuke = function()
    Debug.Unit.Reset()
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
    player[index][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[index][DB.Trackable.SPELLS_NUKING] = T{}
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    return Debug.Unit.Check_Result("Spells > Nuke", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Spells > Nuke AOE
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Nuke_AOE = function()
    Debug.Unit.Reset()
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
    player[index][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.SPELLS_NUKING] = T{}
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    -- In this case, a catalog minimum for Firaga isn't set because the first mob already set the minimum to 100. Retrieving catalog minimums searches
    -- everything. This could be a problem if the mob filter is used on the second mob because it's minimum hasn't been set yet.
    player[index_two] = T{}
    player[index_two][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = damage_two
    player[index_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[index_two][DB.Trackable.SPELLS_NUKING] = T{}
    player[index_two][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage_two
    player[index_two][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = damage_two
    player[index_two][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = damage_two
    player[index_two][DB.Trackable.SPELLS_NUKING][DB.Metric.HIT_COUNT] = 1
    player[index_two][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS] = 1
    player[index_two][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost
    player[index_two][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index_two][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage_two
    player[index_two][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index_two][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage_two

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = damage
    player_catalog[index_two] = T{}
    player_catalog[index_two][action_name] = T{}
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_NUKING] = T{}
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage_two
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = damage_two
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = damage_two
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS] = 1
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage + damage_two),
        action = action_name,
        note   = "TGTs: 2",
    }

    local misc = T{}
    misc["Total Damage"] = damage + damage_two
    misc["Total Damage No Skillchain"] = damage + damage_two

    return Debug.Unit.Check_Result("Spells > Nuke AOE", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Spells > Nuke (Burst)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Nuke_Burst = function()
    Debug.Unit.Reset()
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
    player[index][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MAGIC_BURST_DAMAGE] = damage
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MAGIC_BURST_COUNT] = 1
    player[index][DB.Trackable.SPELLS_NUKING] = T{}
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.MAGIC_BURST_DAMAGE] = damage
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.MAGIC_BURST_COUNT] = 1
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MAGIC_BURST_DAMAGE] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MAGIC_BURST_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = Blog.Enum.MAGIC_BURST,
    }

    local misc = T{}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    return Debug.Unit.Check_Result("Spells > Nuke Burst", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Spells > Pet Nuke
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Pet_Nuke = function()
    Debug.Unit.Reset()
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
    player[index][DB.Trackable.PET_GENERAL_MAGIC] = T{}
    player[index][DB.Trackable.PET_GENERAL_MAGIC][DB.Metric.MP_SPENT] = mp_cost
    player[index][DB.Trackable.PET_NUKING] = T{}
    player[index][DB.Trackable.PET_NUKING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.PET_NUKING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.PET_NUKING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.PET_NUKING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.PET_NUKING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.PET_NUKING][DB.Metric.MP_SPENT] = mp_cost
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.PET_OVERALL] = T{}
    player[index][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.PET_NUKING] = T{}
    player_catalog[index][action_name][DB.Trackable.PET_NUKING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.PET_NUKING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.PET_NUKING][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.PET_NUKING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.PET_NUKING][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.PET_NUKING][DB.Metric.MP_SPENT] = mp_cost

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.PET_GENERAL_MAGIC] = T{}
    pet[index][pet_name][DB.Trackable.PET_GENERAL_MAGIC][DB.Metric.MP_SPENT] = mp_cost
    pet[index][pet_name][DB.Trackable.PET_NUKING] = T{}
    pet[index][pet_name][DB.Trackable.PET_NUKING][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.PET_NUKING][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Trackable.PET_NUKING][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Trackable.PET_NUKING][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.PET_NUKING][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Trackable.PET_NUKING][DB.Metric.MP_SPENT] = mp_cost
    pet[index][pet_name][DB.Trackable.TOTAL_DAMAGE] = T{}
    pet[index][pet_name][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    pet[index][pet_name][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.PET_OVERALL] = T{}
    pet[index][pet_name][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_NUKING] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_NUKING][DB.Metric.TOTAL] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_NUKING][DB.Metric.MIN] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_NUKING][DB.Metric.MAX] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_NUKING][DB.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_NUKING][DB.Metric.ATTEMPTS] = 1
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_NUKING][DB.Metric.MP_SPENT] = mp_cost

    local battle_log = T{
        player = player_name,
        pet    = Debug.Unit.Mob.PET.name,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    return Debug.Unit.Check_Result("Spells > Pet Nuke", player, player_catalog, pet, pet_catalog, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Spells > Healing
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Healing = function()
    Debug.Unit.Reset()
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
    player[index][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[index][DB.Trackable.ALL_HEAL] = T{}
    player[index][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.SPELLS_HEALING] = T{}
    player[index][DB.Trackable.SPELLS_HEALING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.SPELLS_HEALING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.SPELLS_HEALING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.SPELLS_HEALING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.SPELLS_HEALING][DB.Metric.MP_SPENT] = mp_cost
    player[index_two] = T{}
    player[index_two][DB.Trackable.DEF_HEALING_RECEIVED] = T{}
    player[index_two][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.TOTAL] = damage
    player[index_two][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MIN] = damage
    player[index_two][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MAX] = damage
    player[index_two][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.HIT_COUNT] = 1
    player[index_two][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.ATTEMPTS] = 1
    player[index_two][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MP_SPENT] = mp_cost

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_HEALING] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MP_SPENT] = mp_cost
    player_catalog[index_two] = T{}
    player_catalog[index_two][action_name] = T{}
    player_catalog[index_two][action_name][DB.Trackable.DEF_HEALING_RECEIVED] = T{}
    player_catalog[index_two][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.TOTAL] = damage
    player_catalog[index_two][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MIN] = damage
    player_catalog[index_two][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MAX] = damage
    player_catalog[index_two][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.HIT_COUNT] = 1
    player_catalog[index_two][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.ATTEMPTS] = 1
    player_catalog[index_two][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MP_SPENT] = mp_cost

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Spells > Healing", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Spells > Healing AOE
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Healing_AOE = function()
    Debug.Unit.Reset()
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
    player[index][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index][DB.Trackable.ALL_HEAL] = T{}
    player[index][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.SPELLS_HEALING] = T{}
    player[index][DB.Trackable.SPELLS_HEALING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.SPELLS_HEALING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.SPELLS_HEALING][DB.Metric.MAX] = damage
    -- In this case, a catalog minimum for Curaga II isn't set because the first mob already set the minimum to 100. Retrieving catalog minimums searches
    -- everything. This could be a problem if the mob filter is used on the second mob because it's minimum hasn't been set yet.
    player[index_two] = T{}
    player[index_two][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[index_two][DB.Trackable.ALL_HEAL] = T{}
    player[index_two][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage_two
    player[index_two][DB.Trackable.SPELLS_HEALING] = T{}
    player[index_two][DB.Trackable.SPELLS_HEALING][DB.Metric.TOTAL] = damage_two
    player[index_two][DB.Trackable.SPELLS_HEALING][DB.Metric.MIN] = damage_two
    player[index_two][DB.Trackable.SPELLS_HEALING][DB.Metric.MAX] = damage_two
    player[index_two][DB.Trackable.SPELLS_HEALING][DB.Metric.HIT_COUNT] = 1
    player[index_two][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS] = 1
    player[index_two][DB.Trackable.SPELLS_HEALING][DB.Metric.MP_SPENT] = mp_cost

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_HEALING] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MAX] = damage
    player_catalog[index_two] = T{}
    player_catalog[index_two][action_name] = T{}
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_HEALING] = T{}
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.TOTAL] = damage_two
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MIN] = damage_two
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MAX] = damage_two
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS] = 1
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MP_SPENT] = mp_cost

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage + damage_two),
        action = action_name,
        note   = "TGTs: 2",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Spells > Healing AOE", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Spells > Pet Heal
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Pet_Heal = function()
    Debug.Unit.Reset()
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
    player[index][DB.Trackable.PET_GENERAL_MAGIC] = T{}
    player[index][DB.Trackable.PET_GENERAL_MAGIC][DB.Metric.MP_SPENT] = mp_cost
    player[index][DB.Trackable.ALL_HEAL] = T{}
    player[index][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.PET_HEALING] = T{}
    player[index][DB.Trackable.PET_HEALING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.PET_HEALING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.PET_HEALING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.PET_HEALING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.PET_HEALING][DB.Metric.MP_SPENT] = mp_cost

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.PET_HEALING] = T{}
    player_catalog[index][action_name][DB.Trackable.PET_HEALING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.PET_HEALING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.PET_HEALING][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.PET_HEALING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.PET_HEALING][DB.Metric.MP_SPENT] = mp_cost

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.PET_GENERAL_MAGIC] = T{}
    pet[index][pet_name][DB.Trackable.PET_GENERAL_MAGIC][DB.Metric.MP_SPENT] = mp_cost
    pet[index][pet_name][DB.Trackable.ALL_HEAL] = T{}
    pet[index][pet_name][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.PET_HEALING] = T{}
    pet[index][pet_name][DB.Trackable.PET_HEALING][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.PET_HEALING][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Trackable.PET_HEALING][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Trackable.PET_HEALING][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Trackable.PET_HEALING][DB.Metric.MP_SPENT] = mp_cost

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_HEALING] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_HEALING][DB.Metric.TOTAL] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_HEALING][DB.Metric.MIN] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_HEALING][DB.Metric.MAX] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_HEALING][DB.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS] = 1
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_HEALING][DB.Metric.MP_SPENT] = mp_cost

    local battle_log = T{
        player = player_name,
        pet    = Debug.Unit.Mob.PET.name,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Spells > Pet Heal", player, player_catalog, pet, pet_catalog, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Spells - DoT > No Damage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.DoT_No_Damage = function()
    Debug.Unit.Reset()
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
    player[index][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[index][DB.Trackable.SPELLS_NUKING] = T{}
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Spells - DoT > No Damage", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Spells - DoT > Damage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.DoT_Damage = function()
    Debug.Unit.Reset()
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
    player[index][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[index][DB.Trackable.SPELLS_NUKING] = T{}
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    return Debug.Unit.Check_Result("Spells - DoT > Damage", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Spells - Aspir
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Aspir = function()
    Debug.Unit.Reset()
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
    player[index][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[index][DB.Trackable.SPELLS_MP_DRAIN] = T{}
    player[index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.MIN] = damage
    player[index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.MAX] = damage
    player[index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.MP_SPENT] = mp_cost

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_MP_DRAIN] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.MP_SPENT] = mp_cost

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Spells - Aspir", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Spells - Enfeeble > Land
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Enfeeble_Land = function()
    Debug.Unit.Reset()
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
    player[index][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[index][DB.Trackable.SPELLS_ENFEEBLING] = T{}
    player[index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.AOE_ATTEMPTS] = 1
    player[index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_ENFEEBLING] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.AOE_ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Spells - Enfeeble > Land", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Spells - Enfeeble > Resist
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Enfeeble_Resist = function()
    Debug.Unit.Reset()
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
    player[index][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[index][DB.Trackable.SPELLS_ENFEEBLING] = T{}
    player[index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.AOE_ATTEMPTS] = 1
    player[index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_ENFEEBLING] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.AOE_ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = action_name,
        note   = Blog.Enum.RESIST,
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Spells - Enfeeble > Resist", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Spells - Enfeeble > No Effect
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Enfeeble_No_Effect = function()
    Debug.Unit.Reset()
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
    player[index][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[index][DB.Trackable.SPELLS_ENFEEBLING] = T{}
    player[index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.AOE_ATTEMPTS] = 1
    player[index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_ENFEEBLING] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.AOE_ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = action_name,
        note   = Blog.Enum.NO_EFFECT,
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Spells - Enfeeble > No Effect", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Spells - Enfeeble > AOE Land
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Enfeeble_AOE_Land = function()
    Debug.Unit.Reset()
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
    player[index][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index][DB.Trackable.SPELLS_ENFEEBLING] = T{}
    player[index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.AOE_ATTEMPTS] = 1
    player[index_two] = T{}
    player[index_two][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[index_two][DB.Trackable.SPELLS_ENFEEBLING] = T{}
    player[index_two][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HIT_COUNT] = 1
    player[index_two][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS] = 1
    player[index_two][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.AOE_ATTEMPTS] = 1
    player[index_two][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_ENFEEBLING] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.AOE_ATTEMPTS] = 1
    player_catalog[index_two] = T{}
    player_catalog[index_two][action_name] = T{}
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_ENFEEBLING] = T{}
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS] = 1
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.AOE_ATTEMPTS] = 1
    player_catalog[index_two][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Spells - Enfeeble > AOE Land", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Spells - Song
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Song = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. tostring(player_name)
    local damage = 0
    local action_id = 398
    local action_name = "Valor Minuet V"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.SPELLS_BUFF_SONG] = T{}
    player[index][DB.Trackable.SPELLS_BUFF_SONG][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_BUFF_SONG] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_BUFF_SONG][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = action_name,
        note   = "TGTs: 1",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Spells - Song", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Spells - Status_Removal
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Status_Removal = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.PLAYER_TWO.name
    local damage = 128      -- Burn
    local debuff_name = "Burn"
    local action_id = 143
    local action_name = "Erase"
    local mp_cost = 18
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER_TWO.id, action_id, damage)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[index][DB.Trackable.SPELLS_DEBUFF_REMOVAL] = T{}
    player[index][DB.Trackable.SPELLS_DEBUFF_REMOVAL][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_DEBUFF_REMOVAL] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_DEBUFF_REMOVAL][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_DEBUFF_REMOVAL][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.SPELLS_DEBUFF_REMOVAL][DB.Metric.MP_SPENT] = mp_cost

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = action_name,
        note   = debuff_name,
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Spells - Status_Removal", player, player_catalog, nil, nil, battle_log, misc)
end