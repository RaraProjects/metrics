Debug.Unit.Tests.Defense = {}

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Hit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.HIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_EVASION] = {}
        player[player_name][target_index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_PARRY] = {}
        player[player_name][target_index][DB.Trackable.DEF_PARRY][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS] = {}
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION] = {}
        player[player_name][target_index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_COUNTER] = {}
        player[player_name][target_index][DB.Trackable.MELEE_COUNTER][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_GUARD] = {}
        player[player_name][target_index][DB.Trackable.DEF_GUARD][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_SHIELD_BLOCK] = {}
        player[player_name][target_index][DB.Trackable.DEF_SHIELD_BLOCK][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE] = {}
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
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

    return Debug.Unit.Check_Result("Defense - Melee > Hit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Miss = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.MISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_EVASION] = {}
        player[player_name][target_index][DB.Trackable.DEF_EVASION][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
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

    return Debug.Unit.Check_Result("Defense - Melee > Miss", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Parry
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Parry = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.PARRY}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_EVASION] = {}
        player[player_name][target_index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_PARRY] = {}
        player[player_name][target_index][DB.Trackable.DEF_PARRY][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_PARRY][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
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

    return Debug.Unit.Check_Result("Defense - Melee > Parry", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Shadows
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Shadows = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 200
    local primary = {animation = nil, reaction = 1, message = Ashita.Enum.Message.SHADOWS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_EVASION] = {}
        player[player_name][target_index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_PARRY] = {}
        player[player_name][target_index][DB.Trackable.DEF_PARRY][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS] = {}
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
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

    return Debug.Unit.Check_Result("Defense - Melee > Shadows", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Third Eye
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Third_Eye = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.THIRD_EYE_ANTICIPATION}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_EVASION] = {}
        player[player_name][target_index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_PARRY] = {}
        player[player_name][target_index][DB.Trackable.DEF_PARRY][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS] = {}
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION] = {}
        player[player_name][target_index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
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

    return Debug.Unit.Check_Result("Defense - Melee > Third Eye", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Counter (Player countering the mob)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Counter = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local spike = {param = damage, message = Ashita.Enum.Message.COUNTER}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, 0, nil, nil, spike)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_MELEE] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_EVASION] = {}
        player[player_name][target_index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_PARRY] = {}
        player[player_name][target_index][DB.Trackable.DEF_PARRY][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS] = {}
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION] = {}
        player[player_name][target_index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_COUNTER] = {}
        player[player_name][target_index][DB.Trackable.MELEE_COUNTER][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.MELEE_COUNTER][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_COUNTER][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = "Melee",
        note   = "Counter: " .. tostring(damage),
    }

    local misc = {}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    local test_package = {
        player = player,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Defense - Melee > Counter", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Guard
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Guard = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = Ashita.Enum.Reaction.GUARD, message = Ashita.Enum.Message.HIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE_PARTIAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE_PARTIAL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE_PARTIAL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE_PARTIAL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE_PARTIAL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE_PARTIAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_EVASION] = {}
        player[player_name][target_index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_PARRY] = {}
        player[player_name][target_index][DB.Trackable.DEF_PARRY][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS] = {}
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION] = {}
        player[player_name][target_index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_COUNTER] = {}
        player[player_name][target_index][DB.Trackable.MELEE_COUNTER][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_GUARD] = {}
        player[player_name][target_index][DB.Trackable.DEF_GUARD][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_GUARD][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_GUARD][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
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

    return Debug.Unit.Check_Result("Defense - Melee > Guard", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Shield Block
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Shield = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = Ashita.Enum.Reaction.SHIELD_BLOCK, message = Ashita.Enum.Message.HIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE_PARTIAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE_PARTIAL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE_PARTIAL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE_PARTIAL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE_PARTIAL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE_PARTIAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_EVASION] = {}
        player[player_name][target_index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_PARRY] = {}
        player[player_name][target_index][DB.Trackable.DEF_PARRY][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS] = {}
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION] = {}
        player[player_name][target_index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_COUNTER] = {}
        player[player_name][target_index][DB.Trackable.MELEE_COUNTER][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_GUARD] = {}
        player[player_name][target_index][DB.Trackable.DEF_GUARD][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_SHIELD_BLOCK] = {}
        player[player_name][target_index][DB.Trackable.DEF_SHIELD_BLOCK][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_SHIELD_BLOCK][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_SHIELD_BLOCK][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
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

    return Debug.Unit.Check_Result("Defense - Melee > Shield Block", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Crit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Crit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.CRIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_EVASION] = {}
        player[player_name][target_index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_PARRY] = {}
        player[player_name][target_index][DB.Trackable.DEF_PARRY][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS] = {}
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION] = {}
        player[player_name][target_index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_COUNTER] = {}
        player[player_name][target_index][DB.Trackable.MELEE_COUNTER][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_GUARD] = {}
        player[player_name][target_index][DB.Trackable.DEF_GUARD][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_SHIELD_BLOCK] = {}
        player[player_name][target_index][DB.Trackable.DEF_SHIELD_BLOCK][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL][DB.Metric.CRITICAL_DAMAGE] = damage
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL][DB.Metric.CRITICAL_COUNT] = 1
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE] = {}
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
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

    return Debug.Unit.Check_Result("Defense - Melee > Crit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Spikes
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Spikes = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local animation = Ashita.Enum.Effect_Animation.FIRE -- Blaze Spikes
    local action_name = "Blaze Spikes"
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.HIT}
    local spike = {param = damage, animation = animation, message = Ashita.Enum.Message.SPIKE_DMG}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary, nil, spike)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_SPIKE_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_SPIKE_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_SPIKE_DAMAGE][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_SPIKE_DAMAGE][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_SPIKE_DAMAGE][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_SPIKE_DAMAGE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_MELEE] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_EVASION] = {}
        player[player_name][target_index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_PARRY] = {}
        player[player_name][target_index][DB.Trackable.DEF_PARRY][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS] = {}
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION] = {}
        player[player_name][target_index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_COUNTER] = {}
        player[player_name][target_index][DB.Trackable.MELEE_COUNTER][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_GUARD] = {}
        player[player_name][target_index][DB.Trackable.DEF_GUARD][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_SHIELD_BLOCK] = {}
        player[player_name][target_index][DB.Trackable.DEF_SHIELD_BLOCK][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE] = {}
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_SPIKE_DAMAGE] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_SPIKE_DAMAGE][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_SPIKE_DAMAGE][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_SPIKE_DAMAGE][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_SPIKE_DAMAGE][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_SPIKE_DAMAGE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
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

    return Debug.Unit.Check_Result("Defense - Melee > Spikes", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Enspell
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Enspell = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 200
    local animation = 1
    local action_name = "Enfire"
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.HIT}
    local add_effect = {param = additional_damage, animation = animation, message = Ashita.Enum.Message.ENSPELL}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary, add_effect)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}
    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_NUKING] = {}
        player[player_name][target_index][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = additional_damage
        player[player_name][target_index][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = additional_damage
        player[player_name][target_index][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = additional_damage
        player[player_name][target_index][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_EVASION] = {}
        player[player_name][target_index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_PARRY] = {}
        player[player_name][target_index][DB.Trackable.DEF_PARRY][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS] = {}
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION] = {}
        player[player_name][target_index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.MELEE_COUNTER] = {}
        player[player_name][target_index][DB.Trackable.MELEE_COUNTER][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_GUARD] = {}
        player[player_name][target_index][DB.Trackable.DEF_GUARD][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_SHIELD_BLOCK] = {}
        player[player_name][target_index][DB.Trackable.DEF_SHIELD_BLOCK][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE] = {}
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_MELEE][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage + additional_damage

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_NUKING] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = additional_damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = additional_damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = additional_damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage + additional_damage),
        action = "Melee",
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

    return Debug.Unit.Check_Result("Defense - Melee > Enspell", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Pet Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Pet_Hit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.HIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PET.id, nil, damage, primary)
    Debug.Unit.Has_Pet = true
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, Debug.Unit.Mob.PLAYER, true)
    Debug.Unit.Has_Pet = false

    local player = {}
    local pet = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    pet[player_name] = {}
    pet[player_name][pet_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE_PET] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE_PET][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_MELEE_PET][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.DEF_MELEE_PET][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.DEF_MELEE_PET][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_MELEE_PET][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

        pet[player_name][pet_name][target_index] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_MELEE_PET] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_MELEE_PET][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_MELEE_PET][DB.Metric.MIN] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_MELEE_PET][DB.Metric.MAX] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_MELEE_PET][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_MELEE_PET][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Melee",
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

    return Debug.Unit.Check_Result("Defense - Melee > Pet Hit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Pet Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Pet_Miss = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 0
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.MISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PET.id, nil, damage, primary)
    Debug.Unit.Has_Pet = true
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, Debug.Unit.Mob.PLAYER, true)
    Debug.Unit.Has_Pet = false

    local player = {}
    local pet = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    pet[player_name] = {}
    pet[player_name][pet_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE_PET] = {}
        player[player_name][target_index][DB.Trackable.DEF_MELEE_PET][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        pet[player_name][pet_name][target_index] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_MELEE_PET] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_MELEE_PET][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
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
        pet = pet,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Defense - Melee > Pet Miss", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Ranged > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Ranged_Hit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 272
    local action_name = "Ranged"
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGEHIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage, primary)
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.DEF_RANGED] = {}
        player[player_name][target_index][DB.Trackable.DEF_RANGED][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_RANGED][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.DEF_RANGED][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.DEF_RANGED][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_RANGED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_EVASION] = {}
        player[player_name][target_index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS] = {}
        player[player_name][target_index][DB.Trackable.DEF_SHADOWS][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_RANGED] = {}
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_RANGED][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_RANGED][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_UNMITIGATED_RANGED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
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
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Defense - Ranged > Hit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Ranged > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Ranged_Miss = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 272
    local action_name = "Ranged"
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGEMISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage, primary)
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.DEF_RANGED] = {}
        player[player_name][target_index][DB.Trackable.DEF_RANGED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_EVASION] = {}
        player[player_name][target_index][DB.Trackable.DEF_EVASION][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(0),
        action = action_name,
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

    return Debug.Unit.Check_Result("Defense - Ranged > Miss", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Nuke
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Nuke = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 145
    local action_name = "Fire II"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage)
    H.Spell_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.DEF_NUKING] = {}
        player[player_name][target_index][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_NUKING] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
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

    return Debug.Unit.Check_Result("Defense - Nuke", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Nuke AOE
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Nuke_AOE = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local player_name_two = Debug.Unit.Mob.PLAYER_TWO.name
    local mob_name = Debug.Unit.Mob.ENEMY.name
    local all_mobs = DB.Enum.ALL_MOBS
    local damage = 100
    local damage_two = 200
    local action_id = 174
    local action_name = "Firaga"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage, nil, nil, nil, Debug.Unit.Mob.PLAYER_TWO.id, damage_two)
    H.Spell_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = {}
    local player_catalog = {}

    player[player_name] = {}
    player[player_name_two] = {}
    player_catalog[player_name] = {}
    player_catalog[player_name_two] = {}

    -- Mob specific damage taken by player one.
    player[player_name][mob_name] = {}
    player[player_name][mob_name][DB.Trackable.DEF_NUKING] = {}
    player[player_name][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage
    player[player_name][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage
    player[player_name][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage
    player[player_name][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage

    player_catalog[player_name][mob_name] = {}
    player_catalog[player_name][mob_name][action_name] = {}
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING] = {}
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1

    -- Mob specific damage taken by player two.
    player[player_name_two][mob_name] = {}
    player[player_name_two][mob_name][DB.Trackable.DEF_NUKING] = {}
    player[player_name_two][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage_two
    player[player_name_two][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage_two
    player[player_name_two][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage_two
    player[player_name_two][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_USE] = 1
    player[player_name_two][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name_two][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
    player[player_name_two][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage_two

    player_catalog[player_name_two][mob_name] = {}
    player_catalog[player_name_two][mob_name][action_name] = {}
    player_catalog[player_name_two][mob_name][action_name][DB.Trackable.DEF_NUKING] = {}
    player_catalog[player_name_two][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage_two
    player_catalog[player_name_two][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage_two
    player_catalog[player_name_two][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage_two
    player_catalog[player_name_two][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name_two][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1

    -- Unfiltered damage taken by player one.
    player[player_name][all_mobs] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage

    player_catalog[player_name][all_mobs] = {}
    player_catalog[player_name][all_mobs][action_name] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1

    -- Unfiltered damage taken by player two.
    player[player_name_two][all_mobs] = {}
    player[player_name_two][all_mobs][DB.Trackable.DEF_NUKING] = {}
    player[player_name_two][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage_two
    player[player_name_two][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage_two
    player[player_name_two][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage_two
    player[player_name_two][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_USE] = 1
    player[player_name_two][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name_two][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
    player[player_name_two][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage_two

    player_catalog[player_name_two][all_mobs] = {}
    player_catalog[player_name_two][all_mobs][action_name] = {}
    player_catalog[player_name_two][all_mobs][action_name][DB.Trackable.DEF_NUKING] = {}
    player_catalog[player_name_two][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage_two
    player_catalog[player_name_two][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage_two
    player_catalog[player_name_two][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage_two
    player_catalog[player_name_two][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name_two][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage + damage_two),
        action = action_name,
        note   = "TGTs: 2",
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

    return Debug.Unit.Check_Result("Defense - Nuke AOE", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Nuke Pet
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Nuke_Pet = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 145
    local action_name = "Fire II"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PET.id, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Spell_Def.Action(action, Debug.Unit.Mob.ENEMY, Debug.Unit.Mob.PLAYER, true)
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
        player[player_name][target_index][DB.Trackable.DEF_NUKING_PET] = {}
        player[player_name][target_index][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_NUKING_PET] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1

        pet[player_name][pet_name][target_index] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_NUKING_PET] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

        pet_catalog[player_name][pet_name][target_index] = {}
        pet_catalog[player_name][pet_name][target_index][action_name] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.DEF_NUKING_PET] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
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
        pet = pet,
        pet_catalog = pet_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Defense - Nuke Pet", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Nuke Pet AOE (Primary)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Nuke_Pet_AOE_Primary = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local mob_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local all_mobs = DB.Enum.ALL_MOBS
    local damage = 100
    local damage_two = 200
    local action_id = 174
    local action_name = "Firaga"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PET.id, action_id, damage, nil, nil, nil, Debug.Unit.Mob.PLAYER.id, damage_two)
    Debug.Unit.Has_Pet = true
    H.Spell_Def.Action(action, Debug.Unit.Mob.ENEMY, Debug.Unit.Mob.PLAYER, true)
    Debug.Unit.Has_Pet = false

    local player = {}
    local player_catalog = {}
    local pet = {}
    local pet_catalog = {}

    player[player_name] = {}
    player_catalog[player_name] = {}
    pet[player_name] = {}
    pet[player_name][pet_name] = {}
    pet_catalog[player_name] = {}
    pet_catalog[player_name][pet_name] = {}

    -- Damage done to the player.
    player[player_name][mob_name] = {}
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage_two
    player[player_name][mob_name][DB.Trackable.DEF_NUKING] = {}
    player[player_name][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage_two
    player[player_name][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage_two
    player[player_name][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage_two
    player[player_name][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_NUKING_PET] = {}
    player[player_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
    player[player_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
    player[player_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
    player[player_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

    player_catalog[player_name][mob_name] = {}
    player_catalog[player_name][mob_name][action_name] = {}
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING] = {}
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage_two
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage_two
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage_two
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET] = {}
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1

    player[player_name][all_mobs] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage_two
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage_two
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage_two
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage_two
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING_PET] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

    player_catalog[player_name][all_mobs] = {}
    player_catalog[player_name][all_mobs][action_name] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage_two
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage_two
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage_two
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1

    -- Damage done to the pet.
    pet[player_name][pet_name][mob_name] = {}
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_NUKING_PET] = {}
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

    pet_catalog[player_name][pet_name][mob_name] = {}
    pet_catalog[player_name][pet_name][mob_name][action_name] = {}
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET] = {}
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1

    pet[player_name][pet_name][all_mobs] = {}
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_NUKING_PET] = {}
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

    pet_catalog[player_name][pet_name][all_mobs] = {}
    pet_catalog[player_name][pet_name][all_mobs][action_name] = {}
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET] = {}
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage + damage_two),
        action = action_name,
        note   = "TGTs: 2",
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

    return Debug.Unit.Check_Result("Defense - Nuke Pet AOE Primary", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - Nuke Pet AOE (Secondary)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Nuke_Pet_AOE_Secondary = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local mob_name =  Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local all_mobs = DB.Enum.ALL_MOBS
    local damage = 100
    local damage_two = 200
    local action_id = 174
    local action_name = "Firaga"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id, action_id, damage, nil, nil, nil, Debug.Unit.Mob.PET.id, damage_two)
    Debug.Unit.Has_Pet = true
    H.Spell_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)
    Debug.Unit.Has_Pet = false

    local player = {}
    local player_catalog = {}
    local pet = {}
    local pet_catalog = {}

    player[player_name] = {}
    player_catalog[player_name] = {}
    pet[player_name] = {}
    pet[player_name][pet_name] = {}
    pet_catalog[player_name] = {}
    pet_catalog[player_name][pet_name] = {}

    -- Damage done to the player.
    player[player_name][mob_name] = {}
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage
    player[player_name][mob_name][DB.Trackable.DEF_NUKING] = {}
    player[player_name][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage
    player[player_name][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage
    player[player_name][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage
    player[player_name][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_NUKING_PET] = {}
    player[player_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage_two
    player[player_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage_two
    player[player_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage_two
    player[player_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage_two

    player_catalog[player_name][mob_name] = {}
    player_catalog[player_name][mob_name][action_name] = {}
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING] = {}
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET] = {}
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage_two
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage_two
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage_two
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1

    player[player_name][all_mobs] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING_PET] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage_two
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage_two
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage_two
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage_two

    player_catalog[player_name][all_mobs] = {}
    player_catalog[player_name][all_mobs][action_name] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage_two
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage_two
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage_two
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1

    -- Damage done to the pet.
    pet[player_name][pet_name][mob_name] = {}
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_NUKING_PET] = {}
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage_two
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage_two
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage_two
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage_two

    pet_catalog[player_name][pet_name][mob_name] = {}
    pet_catalog[player_name][pet_name][mob_name][action_name] = {}
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET] = {}
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage_two
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage_two
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage_two
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1

    pet[player_name][pet_name][all_mobs] = {}
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_NUKING_PET] = {}
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage_two
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage_two
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage_two
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage_two

    pet_catalog[player_name][pet_name][all_mobs] = {}
    pet_catalog[player_name][pet_name][all_mobs][action_name] = {}
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET] = {}
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage_two
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage_two
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage_two
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HITS_ON_USE] = 1
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS_ON_USE] = 1

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage + damage_two),
        action = action_name,
        note   = "TGTs: 2",
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

    return Debug.Unit.Check_Result("Defense - Nuke Pet AOE Secondary", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - TP
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.TP = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 262
    local action_name = "Sheep Charge"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage)
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.DEF_TP_MOVE] = {}
        player[player_name][target_index][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.DEF_TP_MOVE][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_TP_MOVE] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS_ON_USE] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
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

    return Debug.Unit.Check_Result("Defense - TP", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - TP AOE
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.TP_AOE = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local player_name_two = Debug.Unit.Mob.PLAYER_TWO.name
    local mob_name = Debug.Unit.Mob.ENEMY.name
    local all_mobs = DB.Enum.ALL_MOBS
    local damage = 100
    local damage_two = 200
    local action_id = 273
    local action_name = "Claw Cyclone"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage, nil, nil, nil, Debug.Unit.Mob.PLAYER_TWO.id, damage_two)
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = {}
    local player_catalog = {}

    player[player_name] = {}
    player[player_name_two] = {}
    player_catalog[player_name] = {}
    player_catalog[player_name_two] = {}

    -- Damage taken by player one.
    player[player_name][mob_name] = {}
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE] = {}
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HITS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage

    player_catalog[player_name][mob_name] = {}
    player_catalog[player_name][mob_name][action_name] = {}
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE] = {}
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS_ON_USE] = 1

    player[player_name][all_mobs] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.HITS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage

    player_catalog[player_name][all_mobs] = {}
    player_catalog[player_name][all_mobs][action_name] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS_ON_USE] = 1

    -- Damage taken by player two.
    player[player_name_two][mob_name] = {}
    player[player_name_two][mob_name][DB.Trackable.DEF_TP_MOVE] = {}
    player[player_name_two][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage_two
    player[player_name_two][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage_two
    player[player_name_two][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage_two
    player[player_name_two][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HITS_ON_USE] = 1
    player[player_name_two][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name_two][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
    player[player_name_two][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage_two

    player_catalog[player_name_two][mob_name] = {}
    player_catalog[player_name_two][mob_name][action_name] = {}
    player_catalog[player_name_two][mob_name][action_name][DB.Trackable.DEF_TP_MOVE] = {}
    player_catalog[player_name_two][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage_two
    player_catalog[player_name_two][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage_two
    player_catalog[player_name_two][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage_two
    player_catalog[player_name_two][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name_two][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS_ON_USE] = 1

    player[player_name_two][all_mobs] = {}
    player[player_name_two][all_mobs][DB.Trackable.DEF_TP_MOVE] = {}
    player[player_name_two][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage_two
    player[player_name_two][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage_two
    player[player_name_two][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage_two
    player[player_name_two][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.HITS_ON_USE] = 1
    player[player_name_two][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name_two][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
    player[player_name_two][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage_two

    player_catalog[player_name_two][all_mobs] = {}
    player_catalog[player_name_two][all_mobs][action_name] = {}
    player_catalog[player_name_two][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE] = {}
    player_catalog[player_name_two][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage_two
    player_catalog[player_name_two][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage_two
    player_catalog[player_name_two][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage_two
    player_catalog[player_name_two][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name_two][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS_ON_USE] = 1

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage + damage_two),
        action = action_name,
        note   = "TGTs: 2",
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

    return Debug.Unit.Check_Result("Defense - TP AOE", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - TP Pet
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.TP_Pet = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 262
    local action_name = "Sheep Charge"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PET.id, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, Debug.Unit.Mob.PLAYER, true)
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
        player[player_name][target_index][DB.Trackable.DEF_TP_MOVE_PET] = {}
        player[player_name][target_index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
        player[player_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_TP_MOVE_PET] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1

        pet[player_name][pet_name][target_index] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_TP_MOVE_PET] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

        pet_catalog[player_name][pet_name][target_index] = {}
        pet_catalog[player_name][pet_name][target_index][action_name] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.DEF_TP_MOVE_PET] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
    end

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
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
        pet = pet,
        pet_catalog = pet_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Defense - TP Pet", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - TP Pet AOE Primary
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.TP_Pet_AOE_Primary = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local mob_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local all_mobs = DB.Enum.ALL_MOBS
    local damage = 100
    local damage_two = 200
    local action_id = 273
    local action_name = "Claw Cyclone"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PET.id, action_id, damage, nil, nil, nil, Debug.Unit.Mob.PLAYER.id_num, damage_two)
    Debug.Unit.Has_Pet = true
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, Debug.Unit.Mob.PLAYER, true)
    Debug.Unit.Has_Pet = false

    local player = {}
    local player_catalog = {}
    local pet = {}
    local pet_catalog = {}

    player[player_name] = {}
    player_catalog[player_name] = {}
    pet[player_name] = {}
    pet[player_name][pet_name] = {}
    pet_catalog[player_name] = {}
    pet_catalog[player_name][pet_name] = {}

    -- Damage taken by the player.
    player[player_name][mob_name] = {}
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE] = {}
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage_two
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage_two
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage_two
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HITS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET] = {}
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage_two
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

    player_catalog[player_name][mob_name] = {}
    player_catalog[player_name][mob_name][action_name] = {}
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE] = {}
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage_two
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage_two
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage_two
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET] = {}
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1

    player[player_name][all_mobs] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage_two
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage_two
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage_two
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.HITS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage_two
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

    player_catalog[player_name][all_mobs] = {}
    player_catalog[player_name][all_mobs][action_name] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage_two
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage_two
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage_two
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1

    -- Damage taken by the pet.
    pet[player_name][pet_name][mob_name] = {}
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET] = {}
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

    pet_catalog[player_name][pet_name][mob_name] = {}
    pet_catalog[player_name][pet_name][mob_name][action_name] = {}
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET] = {}
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1

    pet[player_name][pet_name][all_mobs] = {}
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET] = {}
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

    pet_catalog[player_name][pet_name][all_mobs] = {}
    pet_catalog[player_name][pet_name][all_mobs][action_name] = {}
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET] = {}
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage + damage_two),
        action = action_name,
        note   = "TGTs: 2",
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

    return Debug.Unit.Check_Result("Defense - TP Pet AOE Primary", test_package)
end

------------------------------------------------------------------------------------------------------
-- Defense - TP Pet AOE Secondary
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.TP_Pet_AOE_Secondary = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local mob_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local all_mobs = DB.Enum.ALL_MOBS
    local damage = 100
    local damage_two = 200
    local action_id = 273
    local action_name = "Claw Cyclone"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage, nil, nil, nil, Debug.Unit.Mob.PET.id, damage_two)
    Debug.Unit.Has_Pet = true
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, nil, true)
    Debug.Unit.Has_Pet = false

    local player = {}
    local player_catalog = {}
    local pet = {}
    local pet_catalog = {}

    player[player_name] = {}
    player_catalog[player_name] = {}
    pet[player_name] = {}
    pet[player_name][pet_name] = {}
    pet_catalog[player_name] = {}
    pet_catalog[player_name][pet_name] = {}

    -- Damage done to the player.
    player[player_name][mob_name] = {}
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE] = {}
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HITS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET] = {}
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage_two
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage_two
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage_two
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
    player[player_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage_two

    player_catalog[player_name][mob_name] = {}
    player_catalog[player_name][mob_name][action_name] = {}
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE] = {}
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET] = {}
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage_two
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage_two
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage_two
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1

    player[player_name][all_mobs] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.HITS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage_two
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage_two
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage_two
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
    player[player_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage_two

    player_catalog[player_name][all_mobs] = {}
    player_catalog[player_name][all_mobs][action_name] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage_two
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage_two
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage_two
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1

    -- Damage done to the pet.
    pet[player_name][pet_name][mob_name] = {}
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET] = {}
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage_two
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage_two
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage_two
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
    pet[player_name][pet_name][mob_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage_two

    pet_catalog[player_name][pet_name][mob_name] = {}
    pet_catalog[player_name][pet_name][mob_name][action_name] = {}
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET] = {}
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage_two
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage_two
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage_two
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
    pet_catalog[player_name][pet_name][mob_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1

    pet[player_name][pet_name][all_mobs] = {}
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET] = {}
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage_two
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage_two
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage_two
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = {}
    pet[player_name][pet_name][all_mobs][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage_two

    pet_catalog[player_name][pet_name][all_mobs] = {}
    pet_catalog[player_name][pet_name][all_mobs][action_name] = {}
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET] = {}
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage_two
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage_two
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage_two
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HITS_ON_USE] = 1
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS_ON_USE] = 1

    local battle_log = {
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage + damage_two),
        action = action_name,
        note   = "TGTs: 2",
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

    return Debug.Unit.Check_Result("Defense - TP Pet AOE Secondary", test_package)
end