Debug.Unit.Tests.Ability = {}

------------------------------------------------------------------------------------------------------
-- Ability - Damaging > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Damaging_Hit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 46
    local action_name = "Shield Bash"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_OVERALL] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = action_name,
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

    return Debug.Unit.Check_Result("Ability - Damaging > Hit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ability - Damaging > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Damaging_Miss = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local action_id = 46
    local action_name = "Shield Bash"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_OVERALL] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = "0",
        action = action_name,
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    local test_package = {
        player = player,
        player_catalog = player_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ability - Damaging > Miss", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ability - Damaging > Hit (TP Packet)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Damaging_Hit_TP = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 66
    local action_name = "Jump"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_OVERALL] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = action_name,
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

    return Debug.Unit.Check_Result("Ability - Damaging > Hit (TP Packet)", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ability - Damaging > Miss (TP Packet)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Damaging_Miss_TP = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local action_id = 66
    local action_name = "Jump"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_OVERALL] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = "0",
        action = action_name,
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    local test_package = {
        player = player,
        player_catalog = player_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ability - Damaging > Miss (TP Packet)", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ability - Healing
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Healing = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 38
    local action_name = "Chakra"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.ALL_HEAL] = {}
        player[player_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_HEALING] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_HEALING][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.ABILITY_HEALING][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.ABILITY_HEALING][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.ABILITY_HEALING][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_HEALING][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_HEALING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_OVERALL] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_HEALING] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_HEALING][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_HEALING][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_HEALING][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_HEALING][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_HEALING][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_HEALING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    local test_package = {
        player = player,
        player_catalog = player_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ability - Healing", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ability - MP
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.MP = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 154
    local action_name = "Devotion"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_MP_RECOVERY] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_OVERALL] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_MP_RECOVERY] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    local test_package = {
        player = player,
        player_catalog = player_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ability - MP", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ability > No Damage Buff
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.No_Damage = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 47
    local action_name = "Holy Circle"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.ABILITY_GENERAL] = {}
        player[player_name][target_index][DB.Trackable.ABILITY_GENERAL][DB.Metric.ATTEMPTS_ON_USE] = 1

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_OVERALL] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_GENERAL] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.ABILITY_GENERAL][DB.Metric.ATTEMPTS_ON_USE] = 1
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = action_name,
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    local test_package = {
        player = player,
        player_catalog = player_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ability > No Damage Buff", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ability - Avatar > Rage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Avatar_Rage = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 846
    local action_name = "Flaming Crush"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player = {}
    local player_catalog = {}
    local pet = {}
    local pet_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}
    pet[player_name] = {}
    pet[player_name][pet_name] = {}
    pet_catalog[player_name] = {}
    pet_catalog[player_name][pet_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.PET_TP] = {}
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.PET_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1


        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        pet[player_name][pet_name][target_index] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.MAX] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_OVERALL] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        pet_catalog[player_name][pet_name][target_index] = {}
        pet_catalog[player_name][pet_name][target_index][action_name] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = player_name,
        pet    = pet_name,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    local test_package = {
        player = player,
        player_catalog = player_catalog,
        pet = pet,
        pet_catalog = pet_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ability - Avatar > Rage", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ability - Avatar > Ward
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Avatar_Ward = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 853
    local action_name = "Earthen Ward"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player = {}
    local player_catalog = {}
    local pet = {}
    local pet_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}
    pet[player_name] = {}
    pet[player_name][pet_name] = {}
    pet_catalog[player_name] = {}
    pet_catalog[player_name][pet_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.PET_TP] = {}
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1

        pet[player_name][pet_name][target_index] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1

        pet_catalog[player_name][pet_name][target_index] = {}
        pet_catalog[player_name][pet_name][target_index][action_name] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
    end

    local battle_log = {
        player = player_name,
        pet    = pet_name,
        damage = "---",
        action = action_name,
        note   = "TGTs: 1",
    }

    local misc = {}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    local test_package = {
        player = player,
        player_catalog = player_catalog,
        pet = pet,
        pet_catalog = pet_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ability - Avatar > Ward", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ability - Avatar > Healing
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Avatar_Healing = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 906
    local action_name = "Healing Ruby"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player = {}
    local player_catalog = {}
    local pet = {}
    local pet_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}
    pet[player_name] = {}
    pet[player_name][pet_name] = {}
    pet_catalog[player_name] = {}
    pet_catalog[player_name][pet_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.ALL_HEAL] = {}
        player[player_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_HEALING] = {}
        player[player_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_HEALING] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        pet[player_name][pet_name][target_index] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.ALL_HEAL] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_HEALING] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.MIN] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.MAX] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.HITS_ON_USE] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS_ON_USE] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        pet_catalog[player_name][pet_name][target_index] = {}
        pet_catalog[player_name][pet_name][target_index][action_name] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_HEALING] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.TOTAL] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.MIN] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.MAX] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.HITS_ON_USE] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.HITS_ON_TARGET] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS_ON_USE] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = player_name,
        pet    = pet_name,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    local test_package = {
        player = player,
        player_catalog = player_catalog,
        pet = pet,
        pet_catalog = pet_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ability - Avatar > Healing", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ability - Wyvern > Breath Damage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Wyvern_Breath_Damage = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 646
    local action_name = "Flame Breath"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = true

    local player = {}
    local player_catalog = {}
    local pet = {}
    local pet_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}
    pet[player_name] = {}
    pet[player_name][pet_name] = {}
    pet_catalog[player_name] = {}
    pet_catalog[player_name][pet_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.PET_TP] = {}
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.PET_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        pet[player_name][pet_name][target_index] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.MAX] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_OVERALL] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        pet_catalog[player_name][pet_name][target_index] = {}
        pet_catalog[player_name][pet_name][target_index][action_name] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = player_name,
        pet    = pet_name,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    local test_package = {
        player = player,
        player_catalog = player_catalog,
        pet = pet,
        pet_catalog = pet_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ability - Wyvern > Breath Damage", test_package)
end

------------------------------------------------------------------------------------------------------
-- Ability - Wyvern > Breath Healing
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Wyvern_Breath_Healing = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 640
    local action_name = "Healing Breath"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player = {}
    local player_catalog = {}
    local pet = {}
    local pet_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}
    pet[player_name] = {}
    pet[player_name][pet_name] = {}
    pet_catalog[player_name] = {}
    pet_catalog[player_name][pet_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.ALL_HEAL] = {}
        player[player_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_HEALING] = {}
        player[player_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_HEALING] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        pet[player_name][pet_name][target_index] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.ALL_HEAL] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_HEALING] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.MIN] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.MAX] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.HITS_ON_USE] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS_ON_USE] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        pet_catalog[player_name][pet_name][target_index] = {}
        pet_catalog[player_name][pet_name][target_index][action_name] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_HEALING] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.TOTAL] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.MIN] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.MAX] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.HITS_ON_USE] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.HITS_ON_TARGET] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS_ON_USE] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = player_name,
        pet    = pet_name,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    local test_package = {
        player = player,
        player_catalog = player_catalog,
        pet = pet,
        pet_catalog = pet_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Ability - Wyvern > Breath Healing", test_package)
end