Debug.Unit.Tests.TP_Action = {}

------------------------------------------------------------------------------------------------------
-- TP > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Hit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 156
    local action_name = "Tachi: Fudo"
    local tp = Ashita.Party.Refresh(player_name, Ashita.Enum.Player_Attributes.TP)
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.WEAPONSKILL] = T{}
    player[index][DB.Trackable.WEAPONSKILL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.WEAPONSKILL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.WEAPONSKILL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.WEAPONSKILL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.WEAPONSKILL][DB.Metric.TP_SPENT] = tp
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL] = T{}
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.TP_SPENT] = tp

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = "TP: 0 ",
    }

    local misc = T{}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    return Debug.Unit.Check_Result("TP - Weaponskill > Hit", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- TP > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Miss = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local action_id = 156
    local action_name = "Tachi: Fudo"
    local tp = Ashita.Party.Refresh(player_name, Ashita.Enum.Player_Attributes.TP)
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.WEAPONSKILL] = T{}
    player[index][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.WEAPONSKILL][DB.Metric.TP_SPENT] = tp

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL] = T{}
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.TP_SPENT] = tp

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = "TP: 0 ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("TP - Weaponskill > Miss", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Melee - TP > Energy Steal
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Energy_Steal = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 21
    local action_name = "Energy Steal"
    local tp = Ashita.Party.Refresh(player_name, Ashita.Enum.Player_Attributes.TP)
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.WEAPONSKILL] = T{}
    player[index][DB.Trackable.WEAPONSKILL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.WEAPONSKILL][DB.Metric.TP_SPENT] = tp
    player[index][DB.Trackable.SPELLS_MP_DRAIN] = T{}
    player[index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.MIN] = damage
    player[index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.MAX] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL] = T{}
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.TP_SPENT] = tp
    player_catalog[index][action_name][DB.Trackable.SPELLS_MP_DRAIN] = T{}
    player_catalog[index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.MAX] = damage

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = "TP: 0 ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("TP - Weaponskill > Energy Steal", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- TP > Skillchain
-- Difficult to check for skillchain opener due to that being handled during run time.
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Skillchain = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 156
    local action_name = "Tachi: Fudo"
    local tp = Ashita.Party.Refresh(player_name, Ashita.Enum.Player_Attributes.TP)
    local sc_id = 288
    local sc_name = "Light"
    local sc_damage = 200
    local add_effect = {param = sc_damage, animation = nil, message = sc_id}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage, nil, add_effect)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.WEAPONSKILL] = T{}
    player[index][DB.Trackable.WEAPONSKILL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.WEAPONSKILL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.WEAPONSKILL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.WEAPONSKILL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.WEAPONSKILL][DB.Metric.TP_SPENT] = tp
    player[index][DB.Trackable.SKILLCHAIN] = T{}
    player[index][DB.Trackable.SKILLCHAIN][DB.Metric.TOTAL] = sc_damage
    player[index][DB.Trackable.SKILLCHAIN][DB.Metric.MIN] = sc_damage
    player[index][DB.Trackable.SKILLCHAIN][DB.Metric.MAX] = sc_damage
    player[index][DB.Trackable.SKILLCHAIN][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.SKILLCHAIN][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.SKILLCHAIN][DB.Metric.SKILLCHAIN_OPENED] = 1   -- Gets set due to run-time nuance.
    player[index][DB.Trackable.SKILLCHAIN][DB.Metric.SKILLCHAIN_CLOSED] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage + sc_damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL] = T{}
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.TP_SPENT] = tp
    player_catalog[index][sc_name] = T{}
    player_catalog[index][sc_name][DB.Trackable.SKILLCHAIN] = T{}
    player_catalog[index][sc_name][DB.Trackable.SKILLCHAIN][DB.Metric.TOTAL] = sc_damage
    player_catalog[index][sc_name][DB.Trackable.SKILLCHAIN][DB.Metric.MIN] = sc_damage
    player_catalog[index][sc_name][DB.Trackable.SKILLCHAIN][DB.Metric.MAX] = sc_damage
    player_catalog[index][sc_name][DB.Trackable.SKILLCHAIN][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][sc_name][DB.Trackable.SKILLCHAIN][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][sc_name][DB.Trackable.SKILLCHAIN][DB.Metric.SKILLCHAIN_OPENED] = 1  -- Gets set due to run-time nuance.
    player_catalog[index][sc_name][DB.Trackable.SKILLCHAIN][DB.Metric.SKILLCHAIN_CLOSED] = 1

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(sc_damage),
        action = sc_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = damage + sc_damage
    misc["Total Damage No Skillchain"] = damage

    return Debug.Unit.Check_Result("TP - Weaponskill > Skillchain", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Pet TP > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Pet_Hit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local pet_name = Debug.Unit.Mob.PET.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 262
    local action_name = "Sheep Charge"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.TP.Monster_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.PET_TP] = T{}
    player[index][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
    player[index][DB.Trackable.PET_TP][DB.Metric.MAX] = damage
    player[index][DB.Trackable.PET_TP][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.PET_OVERALL] = T{}
    player[index][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.PET_TP] = T{}
    player_catalog[index][action_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.PET_TP][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.PET_TP] = T{}
    pet[index][pet_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Trackable.PET_TP][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS] = 1
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
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_TP] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_TP][DB.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = player_name,
        pet    = pet_name,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    return Debug.Unit.Check_Result("TP - Pet > Hit", player, player_catalog, pet, pet_catalog, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Pet TP > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Pet_Miss = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local pet_name = Debug.Unit.Mob.PET.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local action_id = 262
    local action_name = "Sheep Charge"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.TP.Monster_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.PET_TP] = T{}
    player[index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.PET_TP] = T{}
    player_catalog[index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.PET_TP] = T{}
    pet[index][pet_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS] = 1

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_TP] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = player_name,
        pet    = pet_name,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("TP - Pet > Miss", player, player_catalog, pet, pet_catalog, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Pet TP > AOE Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Pet_Hit_AOE = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local pet_name = Debug.Unit.Mob.PET.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local index_two = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY_TWO.name
    local damage = 100
    local damage_two = 200
    local action_id = 273
    local action_name = "Claw Cyclone"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage, nil, nil, nil, Debug.Unit.Mob.Target_ID_Two, damage_two)
    Debug.Unit.Has_Pet = true
    H.TP.Monster_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    -- AOE counts are calculated outside of the target loop so only the second target has them documented.
    -- This could be a problem only if the second mob has a different name and a mob filter is used.
    -- But if I counted it for the first mob too then damage could be double counted when there is no mob filter used and the mobs have different names.
    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.PET_TP] = T{}
    player[index][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
    player[index][DB.Trackable.PET_TP][DB.Metric.MAX] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.PET_OVERALL] = T{}
    player[index][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage
    player[index_two] = T{}
    player[index_two][DB.Trackable.PET_TP] = T{}
    player[index_two][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage_two
    player[index_two][DB.Trackable.PET_TP][DB.Metric.MIN] = damage_two
    player[index_two][DB.Trackable.PET_TP][DB.Metric.MAX] = damage_two
    player[index_two][DB.Trackable.PET_TP][DB.Metric.HIT_COUNT] = 1
    player[index_two][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS] = 1
    player[index_two][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index_two][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage_two
    player[index_two][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index_two][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage_two
    player[index_two][DB.Trackable.PET_OVERALL] = T{}
    player[index_two][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage_two

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.PET_TP] = T{}
    player_catalog[index][action_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage

    -- In this case, a catalog minimum for Claw Cyclone isn't set because the first mob already set the minimum to 100. Retrieving catalog minimums searches
    -- everything withouth a mob focus. This could be a problem if the mob filter is used on the second mob because it's minimum hasn't been set yet.
    player_catalog[index_two] = T{}
    player_catalog[index_two][action_name] = T{}
    player_catalog[index_two][action_name][DB.Trackable.PET_TP] = T{}
    player_catalog[index_two][action_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage_two
    player_catalog[index_two][action_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage_two
    player_catalog[index_two][action_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage_two
    player_catalog[index_two][action_name][DB.Trackable.PET_TP][DB.Metric.HIT_COUNT] = 1
    player_catalog[index_two][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS] = 1

    -- AOE counts are calculated outside of the target loop so only the second target has them documented.
    -- This could be a problem only if the second mob has a different name and a mob filter is used.
    -- But if I counted it for the first mob too then damage could be double counted when there is no mob filter used and the mobs have different names.
    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.PET_TP] = T{}
    pet[index][pet_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Trackable.TOTAL_DAMAGE] = T{}
    pet[index][pet_name][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    pet[index][pet_name][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.PET_OVERALL] = T{}
    pet[index][pet_name][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage
    pet[index_two] = T{}
    pet[index_two][pet_name] = T{}
    pet[index_two][pet_name][DB.Trackable.PET_TP] = T{}
    pet[index_two][pet_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage_two
    pet[index_two][pet_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage_two
    pet[index_two][pet_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage_two
    pet[index_two][pet_name][DB.Trackable.PET_TP][DB.Metric.HIT_COUNT] = 1
    pet[index_two][pet_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS] = 1
    pet[index_two][pet_name][DB.Trackable.TOTAL_DAMAGE] = T{}
    pet[index_two][pet_name][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage_two
    pet[index_two][pet_name][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    pet[index_two][pet_name][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage_two
    pet[index_two][pet_name][DB.Trackable.PET_OVERALL] = T{}
    pet[index_two][pet_name][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage_two

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_TP] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage

    -- In this case, a catalog minimum for Claw Cyclone isn't set because the first mob already set the minimum to 100. Retrieving catalog minimums searches
    -- everything. This could be a problem if the mob filter is used on the second mob because it's minimum hasn't been set yet.
    pet_catalog[index_two] = T{}
    pet_catalog[index_two][pet_name] = T{}
    pet_catalog[index_two][pet_name][action_name] = T{}
    pet_catalog[index_two][pet_name][action_name][DB.Trackable.PET_TP] = T{}
    pet_catalog[index_two][pet_name][action_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage_two
    pet_catalog[index_two][pet_name][action_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage_two
    pet_catalog[index_two][pet_name][action_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage_two
    pet_catalog[index_two][pet_name][action_name][DB.Trackable.PET_TP][DB.Metric.HIT_COUNT] = 1
    pet_catalog[index_two][pet_name][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = player_name,
        pet    = pet_name,
        damage = tostring(damage + damage_two),
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = damage + damage_two
    misc["Total Damage No Skillchain"] = damage + damage_two

    return Debug.Unit.Check_Result("TP - Pet > AOE Hit", player, player_catalog, pet, pet_catalog, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Pet TP > No Damage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Pet_No_Damage = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local pet_name = Debug.Unit.Mob.PET.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local action_id = 264
    local action_name = "Sheep Song"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.TP.Monster_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.PET_TP] = T{}
    player[index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.PET_TP] = T{}
    player_catalog[index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.PET_TP] = T{}
    pet[index][pet_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS] = 1

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_TP] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = player_name,
        pet    = pet_name,
        damage = "---",
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("TP - Pet > No Damage", player, player_catalog, pet, pet_catalog, battle_log, misc)
end