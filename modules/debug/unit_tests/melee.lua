Debug.Unit.Tests.Melee = {}

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Main_Hit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.HIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND] = {}
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED] = {}
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Main-Hand > Hit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Main_Miss = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.MISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND] = {}
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED] = {}
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Main-Hand > Miss", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Critical Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Crit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.CRIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.CRITICAL_DAMAGE] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.CRITICAL_COUNT] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.CRITICAL_MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.CRITICAL_MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND] = {}
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.CRITICAL_DAMAGE] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.CRITICAL_COUNT] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.CRITICAL_MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.CRITICAL_MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED] = {}
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Main-Hand > Crit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Enspell
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Enspell = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 200
    local add_effect_animation = 1
    local add_effect_name = "Enfire"
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.HIT}
    local add_effect = {param = additional_damage, animation = add_effect_animation, message = Ashita.Enum.Message.ENSPELL}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND] = {}
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED] = {}
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = additional_damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_ENSPELL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_ENSPELL][DB.Metric.TOTAL] = additional_damage
        player[player_name][target_index][DB.Trackable.MELEE_ENSPELL][DB.Metric.MIN] = additional_damage
        player[player_name][target_index][DB.Trackable.MELEE_ENSPELL][DB.Metric.MAX] = additional_damage
        player[player_name][target_index][DB.Trackable.MELEE_ENSPELL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_ENSPELL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage + additional_damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage + additional_damage

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][add_effect_name] = {}
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.MELEE_ENSPELL] = {}
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.MELEE_ENSPELL][DB.Metric.TOTAL] = additional_damage
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.MELEE_ENSPELL][DB.Metric.MIN] = additional_damage
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.MELEE_ENSPELL][DB.Metric.MAX] = additional_damage
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.MELEE_ENSPELL][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.MELEE_ENSPELL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage + additional_damage),
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Main-Hand > Enspell", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Shadows
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Shadows = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.SHADOWS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.SHADOW_ABSORPTION] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND] = {}
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.SHADOW_ABSORPTION] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED] = {}
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Main-Hand > Shadows", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Mob Heal
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Mob_Heal = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.MOBHEAL373}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MOB_HEALING] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND] = {}
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MOB_HEALING] = damage
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED] = {}
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Main-Hand > Mob Heal", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Off-Hand > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Off_Hand_Hit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.MELEE_OFFHAND, reaction = nil, message = Ashita.Enum.Message.HIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OFF_HAND] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED] = {}
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Off-Hand > Hit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Off-Hand > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Off_Hand_Miss = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.MELEE_OFFHAND, reaction = nil, message = Ashita.Enum.Message.MISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OFF_HAND] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OFF_HAND][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED] = {}
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Off-Hand > Miss", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Pet > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Pet_Hit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.HIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local pet = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    pet[player_name] = {}
    pet[player_name][pet_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.PET_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE] = {}
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

        pet[player_name][pet_name][target_index] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_OVERALL] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.MIN] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.MAX] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.MIN] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.MAX] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Debug.Unit.Mob.PET.name,
        damage = tostring(damage),
        action = "Pet Melee",
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    local test_package = {
        player = player,
        pet = pet,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Melee - Pet > Hit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Pet > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Pet_Miss = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.MISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local pet = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    pet[player_name] = {}
    pet[player_name][pet_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE] = {}
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        pet[player_name][pet_name][target_index] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Debug.Unit.Mob.PET.name,
        damage = "---",
        action = "Pet Melee",
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    local test_package = {
        player = player,
        pet = pet,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Melee - Pet > Miss", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Pet > Crit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Pet_Crit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.CRIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local pet = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    pet[player_name] = {}
    pet[player_name][pet_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.PET_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.CRITICAL_DAMAGE] = damage
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.CRITICAL_COUNT] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.CRITICAL_MIN] = damage
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.CRITICAL_MAX] = damage
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE] = {}
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.CRITICAL_DAMAGE] = damage
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.CRITICAL_COUNT] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.CRITICAL_MIN] = damage
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.CRITICAL_MAX] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

        pet[player_name][pet_name][target_index] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_OVERALL] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.CRITICAL_DAMAGE] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.CRITICAL_COUNT] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.CRITICAL_MIN] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.CRITICAL_MAX] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.CRITICAL_DAMAGE] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.CRITICAL_COUNT] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.CRITICAL_MIN] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.CRITICAL_MAX] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Debug.Unit.Mob.PET.name,
        damage = tostring(damage),
        action = "Pet Melee",
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    local test_package = {
        player = player,
        pet = pet,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Melee - Pet > Crit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Pet > Shadows
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Pet_Shadows = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.SHADOWS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local pet = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    pet[player_name] = {}
    pet[player_name][pet_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.SHADOW_ABSORPTION] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE] = {}
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.SHADOW_ABSORPTION] = 1

        pet[player_name][pet_name][target_index] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.SHADOW_ABSORPTION] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.SHADOW_ABSORPTION] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Debug.Unit.Mob.PET.name,
        damage = "---",
        action = "Pet Melee",
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    local test_package = {
        player = player,
        pet = pet,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Melee - Pet > Shadows", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Pet > Mob Heal
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Pet_Mob_Heal = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.MOBHEAL373}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local pet = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    pet[player_name] = {}
    pet[player_name][pet_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.MOB_HEALING] = damage
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE] = {}
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.MOB_HEALING] = damage

        pet[player_name][pet_name][target_index] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_OVERALL][DB.Metric.MOB_HEALING] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_MELEE_DISCRETE][DB.Metric.MOB_HEALING] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Debug.Unit.Mob.PET.name,
        damage = "---",
        action = "Pet Melee",
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    local test_package = {
        player = player,
        pet = pet,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Melee - Pet > Mob Heal", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Daken > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Daken_Hit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.DAKEN, reaction = nil, message = Ashita.Enum.Message.RANGEHIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING] = {}
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Daken > Hit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Daken > Square Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Daken_Square = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.DAKEN, reaction = nil, message = Ashita.Enum.Message.SQUARE}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING] = {}
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Daken > Square Hit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Daken > Truestrike
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Daken_Truestrike = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.DAKEN, reaction = nil, message = Ashita.Enum.Message.TRUE}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING] = {}
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Daken > Truestrike", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Daken > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Daken_Miss = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local primary = {animation = Ashita.Enum.Animation.DAKEN, reaction = nil, message = Ashita.Enum.Message.RANGEMISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING] = {}
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.MULTI_ATTACK_1] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Daken > Miss", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Daken > Crit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Daken_Crit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.DAKEN, reaction = nil, message = Ashita.Enum.Message.RANGECRIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.CRITICAL_MIN] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.CRITICAL_MAX] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.CRITICAL_DAMAGE] = damage
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.CRITICAL_COUNT] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING] = {}
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.CRITICAL_MIN] = damage
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.CRITICAL_MAX] = damage
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.CRITICAL_DAMAGE] = damage
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.CRITICAL_COUNT] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.RANGED_THROWING][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Daken > Crit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Kick > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Kick_Hit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.MELEE_KICK, reaction = nil, message = Ashita.Enum.Message.HIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS] = {}
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED] = {}
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Kick > Hit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Kick > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Kick_Miss = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local primary = {animation = Ashita.Enum.Animation.MELEE_KICK, reaction = nil, message = Ashita.Enum.Message.MISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS] = {}
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED] = {}
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Kick > Miss", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Kick > Critical Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Kick_Crit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = Ashita.Enum.Animation.MELEE_KICK, reaction = nil, message = Ashita.Enum.Message.CRIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.CRITICAL_DAMAGE] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.CRITICAL_COUNT] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.CRITICAL_MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.CRITICAL_MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS] = {}
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.CRITICAL_DAMAGE] = damage
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.CRITICAL_COUNT] = 1
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.CRITICAL_MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.CRITICAL_MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_KICK_ATTACKS][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED] = {}
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Kick > Crit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Endamage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Endamage = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 200
    local add_effect_animation = 1
    local add_effect_name = "Fire"
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.HIT}
    local add_effect = {param = additional_damage, animation = add_effect_animation, message = Ashita.Enum.Message.ENDAMAGE}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND] = {}
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED] = {}
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = additional_damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_ENDAMAGE] = {}
        player[player_name][target_index][DB.Trackable.MELEE_ENDAMAGE][DB.Metric.TOTAL] = additional_damage
        player[player_name][target_index][DB.Trackable.MELEE_ENDAMAGE][DB.Metric.MIN] = additional_damage
        player[player_name][target_index][DB.Trackable.MELEE_ENDAMAGE][DB.Metric.MAX] = additional_damage
        player[player_name][target_index][DB.Trackable.MELEE_ENDAMAGE][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_ENDAMAGE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage + additional_damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage + additional_damage

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][add_effect_name] = {}
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.MELEE_ENDAMAGE] = {}
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.MELEE_ENDAMAGE][DB.Metric.TOTAL] = additional_damage
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.MELEE_ENDAMAGE][DB.Metric.MIN] = additional_damage
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.MELEE_ENDAMAGE][DB.Metric.MAX] = additional_damage
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.MELEE_ENDAMAGE][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.MELEE_ENDAMAGE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage + additional_damage),
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Main-Hand > Endamage", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Endebuff
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Endebuff = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 5
    local add_effect_name = "Blind"
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.HIT}
    local add_effect = {param = additional_damage, animation = nil, message = Ashita.Enum.Message.ENDEBUFF}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND] = {}
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED] = {}
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_ENDEBUFF] = {}
        player[player_name][target_index][DB.Trackable.MELEE_ENDEBUFF][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_ENDEBUFF][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][add_effect_name] = {}
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.MELEE_ENDEBUFF] = {}
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.MELEE_ENDEBUFF][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][add_effect_name][DB.Trackable.MELEE_ENDEBUFF][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Main-Hand > Endebuff", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Endrain
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Endrain = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 200
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.HIT}
    local add_effect = {param = additional_damage, animation = nil, message = Ashita.Enum.Message.ENDRAIN}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND] = {}
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED] = {}
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_ENDRAIN] = {}
        player[player_name][target_index][DB.Trackable.MELEE_ENDRAIN][DB.Metric.TOTAL] = additional_damage
        player[player_name][target_index][DB.Trackable.MELEE_ENDRAIN][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_ENDRAIN][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Melee",
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

    return Debug.Unit.Check_Result("Melee - Main-Hand > Endrain", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - Main-Hand > Enaspir
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Melee.Enaspir = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 200
    local primary = {animation = Ashita.Enum.Animation.MELEE_MAIN, reaction = nil, message = Ashita.Enum.Message.HIT}
    local add_effect = {param = additional_damage, animation = nil, message = Ashita.Enum.Message.ENASPIR}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
    H.Melee.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_ROUNDS] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND] = {}
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MELEE_STRIKES] = 1
        player[player_name][target_index][DB.Trackable.MELEE_MAIN_HAND][DB.Metric.MULTI_ATTACK_1] = 1
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED] = {}
        player[player_name][target_index][DB.Trackable.DEF_COUNTERED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_ENASPIR] = {}
        player[player_name][target_index][DB.Trackable.MELEE_ENASPIR][DB.Metric.TOTAL] = additional_damage
        player[player_name][target_index][DB.Trackable.MELEE_ENASPIR][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_ENASPIR][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = "100",
        action = "Melee",
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = 100
    misc["Total Damage No Skillchain"] = 100

    local test_package = {
        player = player,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Melee - Main-Hand > Enaspir", test_package)
end