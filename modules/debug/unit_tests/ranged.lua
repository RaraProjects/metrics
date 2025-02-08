Debug.Unit.Tests.Ranged = {}

------------------------------------------------------------------------------------------------------
-- Ranged > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Hit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, Ashita.Message.RANGE_HIT))
    local action = Debug.Unit.Util.Build_Action(payload)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_SQUARE_HIT] = {}
        player[player_name][target_index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_TRUE_STRIKE] = {}
        player[player_name][target_index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Ranged",
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    local test_package = {
        player = player,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ranged > Hit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Square Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Square = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, Ashita.Message.RANGE_SQUARE_HIT))
    local action = Debug.Unit.Util.Build_Action(payload)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_SQUARE_HIT] = {}
        player[player_name][target_index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_TRUE_STRIKE] = {}
        player[player_name][target_index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Ranged",
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    local test_package = {
        player = player,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ranged > Square Hit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Square Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Truestrike = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, Ashita.Message.RANGE_TRUESTRIKE))
    local action = Debug.Unit.Util.Build_Action(payload)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_SQUARE_HIT] = {}
        player[player_name][target_index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_TRUE_STRIKE] = {}
        player[player_name][target_index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Ranged",
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    local test_package = {
        player = player,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ranged > Truestrike", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Miss = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 0

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, Ashita.Message.RANGE_MISS))
    local action = Debug.Unit.Util.Build_Action(payload)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_SQUARE_HIT] = {}
        player[player_name][target_index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_TRUE_STRIKE] = {}
        player[player_name][target_index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(0),
        action = "Ranged",
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    local test_package = {
        player = player,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ranged > Miss", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Crit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Crit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, Ashita.Message.RANGE_CRITICAL_HIT))
    local action = Debug.Unit.Util.Build_Action(payload)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.CRITICAL_DAMAGE] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.CRITICAL_COUNT] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.CRITICAL_MIN] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.CRITICAL_MAX] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Ranged",
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    local test_package = {
        player = player,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ranged > Crit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Shadows
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Shadows = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 0

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, Ashita.Message.SHADOW_ABSORPTION))
    local action = Debug.Unit.Util.Build_Action(payload)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.SHADOW_ABSORPTION] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(0),
        action = "Ranged",
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    local test_package = {
        player = player,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ranged > Shadows", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ranged - Mob Heal
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Mob_Heal = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, Ashita.Message.MOB_HEAL_MELEE))
    local action = Debug.Unit.Util.Build_Action(payload)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MOB_HEALING] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(0),
        action = "Ranged",
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    local test_package = {
        player = player,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ranged - Mob Heal", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Endamage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Endamage = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 200
    local add_effect_animation = 1
    local add_effect_name = "Fire"

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage,  nil, nil, Ashita.Message.RANGE_HIT, true, additional_damage, add_effect_animation, Ashita.Message.ENDAMAGE))
    local action = Debug.Unit.Util.Build_Action(payload)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_SQUARE_HIT] = {}
        player[player_name][target_index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_TRUE_STRIKE] = {}
        player[player_name][target_index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = additional_damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MIN] = additional_damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MAX] = additional_damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_ENDAMAGE] = {}
        player[player_name][target_index][DB.Trackable.RANGED_ENDAMAGE][DB.Metric.TOTAL] = additional_damage
        player[player_name][target_index][DB.Trackable.RANGED_ENDAMAGE][DB.Metric.MIN] = additional_damage
        player[player_name][target_index][DB.Trackable.RANGED_ENDAMAGE][DB.Metric.MAX] = additional_damage
        player[player_name][target_index][DB.Trackable.RANGED_ENDAMAGE][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_ENDAMAGE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage + additional_damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage + additional_damage

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][add_effect_name] = {}
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.RANGED_ENDAMAGE] = {}
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.RANGED_ENDAMAGE][DB.Metric.TOTAL] = additional_damage
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.RANGED_ENDAMAGE][DB.Metric.MIN] = additional_damage
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.RANGED_ENDAMAGE][DB.Metric.MAX] = additional_damage
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.RANGED_ENDAMAGE][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.RANGED_ENDAMAGE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage + additional_damage),
        action = "Ranged",
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = damage + additional_damage
    misc["Total Damage No Skillchain"] = damage + additional_damage

    local test_package = {
        player = player,
        player_catalog = player_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ranged > Endamage", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Endebuff
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Endebuff = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 5
    local add_effect_name = "Blind"

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage,  nil, nil, Ashita.Message.RANGE_HIT, true, additional_damage, nil, Ashita.Message.ENDEBUFF))
    local action = Debug.Unit.Util.Build_Action(payload)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_SQUARE_HIT] = {}
        player[player_name][target_index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_TRUE_STRIKE] = {}
        player[player_name][target_index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_ENDEBUFF] = {}
        player[player_name][target_index][DB.Trackable.RANGED_ENDEBUFF][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_ENDEBUFF][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][add_effect_name] = {}
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.RANGED_ENDEBUFF] = {}
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.RANGED_ENDEBUFF][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.RANGED_ENDEBUFF][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Ranged",
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    local test_package = {
        player = player,
        player_catalog = player_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ranged > Endebuff", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Endrain
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Endrain = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 200

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage,  nil, nil, Ashita.Message.RANGE_HIT, true, additional_damage, nil, Ashita.Message.ENDRAIN))
    local action = Debug.Unit.Util.Build_Action(payload)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_SQUARE_HIT] = {}
        player[player_name][target_index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_TRUE_STRIKE] = {}
        player[player_name][target_index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = additional_damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MIN] = additional_damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MAX] = additional_damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_ENDRAIN] = {}
        player[player_name][target_index][DB.Trackable.RANGED_ENDRAIN][DB.Metric.TOTAL] = additional_damage
        player[player_name][target_index][DB.Trackable.RANGED_ENDRAIN][DB.Metric.MIN] = additional_damage
        player[player_name][target_index][DB.Trackable.RANGED_ENDRAIN][DB.Metric.MAX] = additional_damage
        player[player_name][target_index][DB.Trackable.RANGED_ENDRAIN][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_ENDRAIN][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage + additional_damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage + additional_damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage + additional_damage),
        action = "Ranged",
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = damage + additional_damage
    misc["Total Damage No Skillchain"] = damage + additional_damage

    local test_package = {
        player = player,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ranged > Endrain", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ranged - PUP > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.PUP = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, Ashita.AttackAnimation.MELEE_MAIN, nil, Ashita.Message.WEAPONSKILL_DAMAGE))
    local action = Debug.Unit.Util.Build_Action(payload)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Ranged",
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    local test_package = {
        player = player,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ranged - PUP > Hit", test_package)
end