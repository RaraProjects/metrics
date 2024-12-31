Debug.Unit.Tests.TP_Action = {}

------------------------------------------------------------------------------------------------------
-- TP > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Hit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local message = Ashita.Enum.Message.WEAPONSKILL_DAMAGE
    local action_id = 156
    local action_name = "Tachi: Fudo"
    local tp = Ashita.Party.Refresh(player_name, Ashita.Enum.Player_Attributes.TP)

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, message))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.WEAPONSKILL] = {}
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.TP_SPENT] = tp
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.TP_SPENT] = tp
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = "TP: 0 ",
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

    return Debug.Unit.Check_Result("TP - Weaponskill > Hit", test_package)
end

------------------------------------------------------------------------------------------------------
-- TP > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Miss = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local message = Ashita.Enum.Message.WEAPONSKILL_MISS
    local action_id = 156
    local action_name = "Tachi: Fudo"
    local tp = Ashita.Party.Refresh(player_name, Ashita.Enum.Player_Attributes.TP)

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, message))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.WEAPONSKILL] = {}
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.TP_SPENT] = tp

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.TP_SPENT] = tp
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = "TP: 0 ",
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

    return Debug.Unit.Check_Result("TP - Weaponskill > Miss", test_package)
end

------------------------------------------------------------------------------------------------------
-- TP > Shadow
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Shadow = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local message = Ashita.Enum.Message.SHADOWS
    local action_id = 156
    local action_name = "Tachi: Fudo"
    local tp = Ashita.Party.Refresh(player_name, Ashita.Enum.Player_Attributes.TP)

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, message))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.WEAPONSKILL] = {}
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.TP_SPENT] = tp

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.TP_SPENT] = tp
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(0),
        action = action_name,
        note   = "TP: 0 ",
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

    return Debug.Unit.Check_Result("TP - Weaponskill > Shadow", test_package)
end

------------------------------------------------------------------------------------------------------
-- Melee - TP > Energy Steal
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Energy_Steal = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local message = Ashita.Enum.Message.WEAPONSKILL_MP_DRAIN
    local action_id = 21
    local action_name = "Energy Steal"
    local tp = Ashita.Party.Refresh(player_name, Ashita.Enum.Player_Attributes.TP)

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, message))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.WEAPONSKILL_MP_DRAIN] = {}
        player[player_name][target_index][DB.Trackable.WEAPONSKILL_MP_DRAIN][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.WEAPONSKILL_MP_DRAIN][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.WEAPONSKILL_MP_DRAIN][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.WEAPONSKILL_MP_DRAIN][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.WEAPONSKILL_MP_DRAIN][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.WEAPONSKILL_MP_DRAIN][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.WEAPONSKILL_MP_DRAIN][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.WEAPONSKILL_MP_DRAIN][DB.Metric.TP_SPENT] = tp

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL_MP_DRAIN] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL_MP_DRAIN][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL_MP_DRAIN][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL_MP_DRAIN][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL_MP_DRAIN][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL_MP_DRAIN][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL_MP_DRAIN][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL_MP_DRAIN][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL_MP_DRAIN][DB.Metric.TP_SPENT] = tp
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = "TP: 0 ",
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

    return Debug.Unit.Check_Result("TP - Weaponskill > Energy Steal", test_package)
end

------------------------------------------------------------------------------------------------------
-- TP > Skillchain
-- Difficult to check for skillchain opener due to that being handled during run time.
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Skillchain = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local message = Ashita.Enum.Message.WEAPONSKILL_DAMAGE
    local action_id = 156
    local action_name = "Tachi: Fudo"
    local tp = Ashita.Party.Refresh(player_name, Ashita.Enum.Player_Attributes.TP)
    local sc_id = 288
    local sc_name = "Light"
    local sc_damage = 200

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, message, true, sc_damage, nil, sc_id))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.WEAPONSKILL] = {}
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.WEAPONSKILL][DB.Metric.TP_SPENT] = tp
        player[player_name][target_index][DB.Trackable.SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.SKILLCHAIN][DB.Metric.TOTAL] = sc_damage
        player[player_name][target_index][DB.Trackable.SKILLCHAIN][DB.Metric.MIN] = sc_damage
        player[player_name][target_index][DB.Trackable.SKILLCHAIN][DB.Metric.MAX] = sc_damage
        player[player_name][target_index][DB.Trackable.SKILLCHAIN][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SKILLCHAIN][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SKILLCHAIN][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SKILLCHAIN][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SKILLCHAIN][DB.Metric.SKILLCHAIN_OPENED] = 1   -- Gets set due to run-time nuance.
        player[player_name][target_index][DB.Trackable.SKILLCHAIN][DB.Metric.SKILLCHAIN_CLOSED] = 1
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage + sc_damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.WEAPONSKILL][DB.Metric.TP_SPENT] = tp
        player_catalog[player_name][target_index][sc_name] = {}
        player_catalog[player_name][target_index][sc_name][DB.Trackable.SKILLCHAIN] = {}
        player_catalog[player_name][target_index][sc_name][DB.Trackable.SKILLCHAIN][DB.Metric.TOTAL] = sc_damage
        player_catalog[player_name][target_index][sc_name][DB.Trackable.SKILLCHAIN][DB.Metric.MIN] = sc_damage
        player_catalog[player_name][target_index][sc_name][DB.Trackable.SKILLCHAIN][DB.Metric.MAX] = sc_damage
        player_catalog[player_name][target_index][sc_name][DB.Trackable.SKILLCHAIN][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][sc_name][DB.Trackable.SKILLCHAIN][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][sc_name][DB.Trackable.SKILLCHAIN][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][sc_name][DB.Trackable.SKILLCHAIN][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player_catalog[player_name][target_index][sc_name][DB.Trackable.SKILLCHAIN][DB.Metric.SKILLCHAIN_OPENED] = 1  -- Gets set due to run-time nuance.
        player_catalog[player_name][target_index][sc_name][DB.Trackable.SKILLCHAIN][DB.Metric.SKILLCHAIN_CLOSED] = 1
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(sc_damage),
        action = sc_name,
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = damage + sc_damage
    misc["Total Damage No Skillchain"] = damage

    local test_package = {
        player = player,
        player_catalog = player_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("TP - Weaponskill > Skillchain", test_package)
end

------------------------------------------------------------------------------------------------------
-- Pet TP > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Pet_Hit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local pet_name = Debug.Unit.Mob.PET.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local message = Ashita.Enum.Message.WEAPONSKILL_DAMAGE
    local action_id = 262
    local action_name = "Sheep Charge"

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, message))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    Debug.Unit.Has_Pet = true
    H.TP.Monster_Action(action, Debug.Unit.Mob.PET, true)
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

    return Debug.Unit.Check_Result("TP - Pet > Hit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Pet TP > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Pet_Miss = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local pet_name = Debug.Unit.Mob.PET.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local message = Ashita.Enum.Message.WEAPONSKILL_MISS
    local action_id = 262
    local action_name = "Sheep Charge"

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, message))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    Debug.Unit.Has_Pet = true
    H.TP.Monster_Action(action, Debug.Unit.Mob.PET, true)
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
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        pet[player_name][pet_name][target_index] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        pet_catalog[player_name][pet_name][target_index] = {}
        pet_catalog[player_name][pet_name][target_index][action_name] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    end

    local battle_log = {
        player = player_name,
        pet    = pet_name,
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
        pet = pet,
        pet_catalog = pet_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("TP - Pet > Miss", test_package)
end

------------------------------------------------------------------------------------------------------
-- Pet TP > AOE Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Pet_Hit_AOE = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local pet_name = Debug.Unit.Mob.PET.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local target_name_two = Debug.Unit.Mob.ENEMY_TWO.name
    local all_mobs = DB.Enum.ALL_MOBS
    local damage = 100
    local damage_two = 200
    local message = Ashita.Enum.Message.WEAPONSKILL_DAMAGE
    local action_id = 273
    local action_name = "Claw Cyclone"

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, message))
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID_Two, damage_two, nil, nil, message))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    Debug.Unit.Has_Pet = true
    H.TP.Monster_Action(action, Debug.Unit.Mob.PET, true)
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

    -- Damage to target one.
    player[player_name][target_name] = {}
    player[player_name][target_name][DB.Trackable.PET_TP] = {}
    player[player_name][target_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
    player[player_name][target_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
    player[player_name][target_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage
    player[player_name][target_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.TOTAL_DAMAGE] = {}
    player[player_name][target_name][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[player_name][target_name][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
    player[player_name][target_name][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    player[player_name][target_name][DB.Trackable.PET_OVERALL] = {}
    player[player_name][target_name][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage

    player_catalog[player_name][target_name] = {}
    player_catalog[player_name][target_name][action_name] = {}
    player_catalog[player_name][target_name][action_name][DB.Trackable.PET_TP] = {}
    player_catalog[player_name][target_name][action_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
    player_catalog[player_name][target_name][action_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
    player_catalog[player_name][target_name][action_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage
    player_catalog[player_name][target_name][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 1
    player_catalog[player_name][target_name][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1

    pet[player_name][pet_name][target_name] = {}
    pet[player_name][pet_name][target_name][DB.Trackable.PET_TP] = {}
    pet[player_name][pet_name][target_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
    pet[player_name][pet_name][target_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
    pet[player_name][pet_name][target_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage
    pet[player_name][pet_name][target_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 1
    pet[player_name][pet_name][target_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    pet[player_name][pet_name][target_name][DB.Trackable.TOTAL_DAMAGE] = {}
    pet[player_name][pet_name][target_name][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    pet[player_name][pet_name][target_name][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
    pet[player_name][pet_name][target_name][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
    pet[player_name][pet_name][target_name][DB.Trackable.PET_OVERALL] = {}
    pet[player_name][pet_name][target_name][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage

    pet_catalog[player_name][pet_name][target_name] = {}
    pet_catalog[player_name][pet_name][target_name][action_name] = {}
    pet_catalog[player_name][pet_name][target_name][action_name][DB.Trackable.PET_TP] = {}
    pet_catalog[player_name][pet_name][target_name][action_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage
    pet_catalog[player_name][pet_name][target_name][action_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
    pet_catalog[player_name][pet_name][target_name][action_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage
    pet_catalog[player_name][pet_name][target_name][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 1
    pet_catalog[player_name][pet_name][target_name][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1

    -- Damage to target two.
    player[player_name][target_name_two] = {}
    player[player_name][target_name_two][DB.Trackable.PET_TP] = {}
    player[player_name][target_name_two][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage_two
    player[player_name][target_name_two][DB.Trackable.PET_TP][DB.Metric.MIN] = damage_two
    player[player_name][target_name_two][DB.Trackable.PET_TP][DB.Metric.MAX] = damage_two
    player[player_name][target_name_two][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
    player[player_name][target_name_two][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name_two][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][target_name_two][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name_two][DB.Trackable.TOTAL_DAMAGE] = {}
    player[player_name][target_name_two][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage_two
    player[player_name][target_name_two][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
    player[player_name][target_name_two][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage_two
    player[player_name][target_name_two][DB.Trackable.PET_OVERALL] = {}
    player[player_name][target_name_two][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage_two

    player_catalog[player_name][target_name_two] = {}
    player_catalog[player_name][target_name_two][action_name] = {}
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.PET_TP] = {}
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage_two
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage_two
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage_two
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 1
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1

    pet[player_name][pet_name][target_name_two] = {}
    pet[player_name][pet_name][target_name_two][DB.Trackable.PET_TP] = {}
    pet[player_name][pet_name][target_name_two][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage_two
    pet[player_name][pet_name][target_name_two][DB.Trackable.PET_TP][DB.Metric.MIN] = damage_two
    pet[player_name][pet_name][target_name_two][DB.Trackable.PET_TP][DB.Metric.MAX] = damage_two
    pet[player_name][pet_name][target_name_two][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
    pet[player_name][pet_name][target_name_two][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 1
    pet[player_name][pet_name][target_name_two][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
    pet[player_name][pet_name][target_name_two][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    pet[player_name][pet_name][target_name_two][DB.Trackable.TOTAL_DAMAGE] = {}
    pet[player_name][pet_name][target_name_two][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage_two
    pet[player_name][pet_name][target_name_two][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
    pet[player_name][pet_name][target_name_two][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage_two
    pet[player_name][pet_name][target_name_two][DB.Trackable.PET_OVERALL] = {}
    pet[player_name][pet_name][target_name_two][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage_two

    pet_catalog[player_name][pet_name][target_name_two] = {}
    pet_catalog[player_name][pet_name][target_name_two][action_name] = {}
    pet_catalog[player_name][pet_name][target_name_two][action_name][DB.Trackable.PET_TP] = {}
    pet_catalog[player_name][pet_name][target_name_two][action_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage_two
    pet_catalog[player_name][pet_name][target_name_two][action_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage_two
    pet_catalog[player_name][pet_name][target_name_two][action_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage_two
    pet_catalog[player_name][pet_name][target_name_two][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
    pet_catalog[player_name][pet_name][target_name_two][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 1
    pet_catalog[player_name][pet_name][target_name_two][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
    pet_catalog[player_name][pet_name][target_name_two][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1

    -- Damage to all mobs.
    player[player_name][all_mobs] = {}
    player[player_name][all_mobs][DB.Trackable.PET_TP] = {}
    player[player_name][all_mobs][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage + damage_two
    player[player_name][all_mobs][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
    player[player_name][all_mobs][DB.Trackable.PET_TP][DB.Metric.MAX] = damage_two
    player[player_name][all_mobs][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.TOTAL_DAMAGE] = {}
    player[player_name][all_mobs][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage + damage_two
    player[player_name][all_mobs][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
    player[player_name][all_mobs][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage + damage_two
    player[player_name][all_mobs][DB.Trackable.PET_OVERALL] = {}
    player[player_name][all_mobs][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage + damage_two

    player_catalog[player_name][all_mobs] = {}
    player_catalog[player_name][all_mobs][action_name] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.PET_TP] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage + damage_two
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage_two
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 2
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 2

    pet[player_name][pet_name][all_mobs] = {}
    pet[player_name][pet_name][all_mobs][DB.Trackable.PET_TP] = {}
    pet[player_name][pet_name][all_mobs][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage + damage_two
    pet[player_name][pet_name][all_mobs][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
    pet[player_name][pet_name][all_mobs][DB.Trackable.PET_TP][DB.Metric.MAX] = damage_two
    pet[player_name][pet_name][all_mobs][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
    pet[player_name][pet_name][all_mobs][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 2
    pet[player_name][pet_name][all_mobs][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
    pet[player_name][pet_name][all_mobs][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 2
    pet[player_name][pet_name][all_mobs][DB.Trackable.TOTAL_DAMAGE] = {}
    pet[player_name][pet_name][all_mobs][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage + damage_two
    pet[player_name][pet_name][all_mobs][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
    pet[player_name][pet_name][all_mobs][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage + damage_two
    pet[player_name][pet_name][all_mobs][DB.Trackable.PET_OVERALL] = {}
    pet[player_name][pet_name][all_mobs][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage + damage_two

    pet_catalog[player_name][pet_name][all_mobs] = {}
    pet_catalog[player_name][pet_name][all_mobs][action_name] = {}
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.PET_TP] = {}
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.PET_TP][DB.Metric.TOTAL] = damage + damage_two
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.PET_TP][DB.Metric.MIN] = damage
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.PET_TP][DB.Metric.MAX] = damage_two
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_USE] = 1
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.PET_TP][DB.Metric.HITS_ON_TARGET] = 2
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
    pet_catalog[player_name][pet_name][all_mobs][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 2

    local battle_log = {
        player = player_name,
        pet    = pet_name,
        damage = tostring(damage + damage_two),
        action = action_name,
        note   = " ",
    }

    local misc = {}
    misc["Total Damage"] = damage + damage_two
    misc["Total Damage No Skillchain"] = damage + damage_two

    local test_package = {
        player = player,
        player_catalog = player_catalog,
        pet = pet,
        pet_catalog = pet_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("TP - Pet > AOE Hit", test_package)
end

------------------------------------------------------------------------------------------------------
-- Pet TP > No Damage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Pet_No_Damage = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local pet_name = Debug.Unit.Mob.PET.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local message = Ashita.Enum.Message.WEAPONSKILL_DAMAGE
    local action_id = 264
    local action_name = "Sheep Song"

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, message))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    Debug.Unit.Has_Pet = true
    H.TP.Monster_Action(action, Debug.Unit.Mob.PET, true)
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
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        pet[player_name][pet_name][target_index] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_USE] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_TP][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        pet_catalog[player_name][pet_name][target_index] = {}
        pet_catalog[player_name][pet_name][target_index][action_name] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_TP] = {}
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

    return Debug.Unit.Check_Result("TP - Pet > No Damage", test_package)
end