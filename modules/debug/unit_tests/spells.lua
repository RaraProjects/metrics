Debug.Unit.Tests.Spells = {}

------------------------------------------------------------------------------------------------------
-- Spells > Nuke
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Nuke = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local message = Ashita.Enum.Message.SPELL_DAMAGE_HIT
    local action_id = 145
    local action_name = "Fire II"
    local mp_cost = 68

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, message))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost
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

    return Debug.Unit.Check_Result("Spells > Nuke", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells > Nuke (Burst)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Nuke_Burst = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 145
    local action_name = "Fire II"
    local mp_cost = 68

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, Ashita.Enum.Message.SPELL_MAGIC_BURST_PRIMARY))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.CRITICAL_MIN] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.CRITICAL_MAX] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.CRITICAL_DAMAGE] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.CRITICAL_COUNT] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_MIN] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_MAX] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_DAMAGE] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_COUNT] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_DAMAGE] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_COUNT] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = Blog.Enum.MAGIC_BURST,
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

    return Debug.Unit.Check_Result("Spells > Nuke Burst", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells > Nuke (Shadow)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Nuke_Shadow = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local message = Ashita.Enum.Message.SHADOW_ABSORPTION
    local action_id = 145
    local action_name = "Fire II"
    local mp_cost = 68

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, message))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost
    end

    local battle_log = {
        player = player_name,
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
        player_catalog = player_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Spells > Nuke (Shadow)", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells > Nuke AOE
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Nuke_AOE = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local target_name_two = Debug.Unit.Mob.ENEMY_TWO.name
    local all_mobs = DB.Enum.ALL_MOBS
    local damage = 100
    local damage_two = 200
    local message = Ashita.Enum.Message.SPELL_DAMAGE_HIT
    local action_id = 174
    local action_name = "Firaga"
    local mp_cost = 71

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, message))
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID_Two, damage_two, nil, nil, message))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}

    player[player_name] = {}
    player_catalog[player_name] = {}

    -- Damage done to target one. MP Spent and Hits on Target get attributed to the second mob.
    player[player_name][target_name] = {}
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL] = {}
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = damage
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.MIN] = damage
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.MAX] = damage
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_NUKING] = {}
    player[player_name][target_name][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage
    player[player_name][target_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = damage
    player[player_name][target_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = damage
    player[player_name][target_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.TOTAL_DAMAGE] = {}
    player[player_name][target_name][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[player_name][target_name][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
    player[player_name][target_name][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    player_catalog[player_name][target_name] = {}
    player_catalog[player_name][target_name][action_name] = {}
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_NUKING] = {}
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = damage
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = damage
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_TARGET] = 1
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 1

    -- Damage done to target two.
    player[player_name][target_name_two] = {}
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL] = {}
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = damage_two
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.MIN] = damage_two
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.MAX] = damage_two
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_NUKING] = {}
    player[player_name][target_name_two][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage_two
    player[player_name][target_name_two][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = damage_two
    player[player_name][target_name_two][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = damage_two
    player[player_name][target_name_two][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_USE] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost
    player[player_name][target_name_two][DB.Trackable.TOTAL_DAMAGE] = {}
    player[player_name][target_name_two][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage_two
    player[player_name][target_name_two][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
    player[player_name][target_name_two][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage_two

    player_catalog[player_name][target_name_two] = {}
    player_catalog[player_name][target_name_two][action_name] = {}
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_NUKING] = {}
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage_two
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = damage_two
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = damage_two
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_TARGET] = 1
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost

    -- Damage done to all mobs.
    player[player_name][all_mobs] = {}
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL] = {}
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = damage + damage_two
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.MIN] = damage
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.MAX] = damage_two
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING] = {}
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage + damage_two
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = damage
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = damage_two
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost
    player[player_name][all_mobs][DB.Trackable.TOTAL_DAMAGE] = {}
    player[player_name][all_mobs][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage + damage_two
    player[player_name][all_mobs][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
    player[player_name][all_mobs][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage + damage_two

    player_catalog[player_name][all_mobs] = {}
    player_catalog[player_name][all_mobs][action_name] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = damage + damage_two
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = damage_two
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_TARGET] = 2
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 2
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage + damage_two),
        action = action_name,
        note   = "TGTs: 2",
    }

    local misc = {}
    misc["Total Damage"] = damage + damage_two
    misc["Total Damage No Skillchain"] = damage + damage_two

    local test_package = {
        player = player,
        player_catalog = player_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Spells > Nuke AOE", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells > Nuke AOE with Burst
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Nuke_AOE_Burst = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local target_name_two = Debug.Unit.Mob.ENEMY_TWO.name
    local all_mobs = DB.Enum.ALL_MOBS
    local burst_damage = 1000
    local regular_damage = 100
    local message = Ashita.Enum.Message.SPELL_DAMAGE_HIT
    local action_id = 174
    local action_name = "Firaga"
    local mp_cost = 71

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, burst_damage, nil, nil, Ashita.Enum.Message.SPELL_MAGIC_BURST_PRIMARY))
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID_Two, regular_damage, nil, nil, message))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}

    player[player_name] = {}
    player_catalog[player_name] = {}

    -- Damage done to target one. MP Spent and Hits on Target get attributed to the second mob.
    player[player_name][target_name] = {}
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL] = {}
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = burst_damage
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.CRITICAL_MIN] = burst_damage
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.CRITICAL_MAX] = burst_damage
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.CRITICAL_DAMAGE] = burst_damage
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.CRITICAL_COUNT] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_NUKING] = {}
    player[player_name][target_name][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = burst_damage
    player[player_name][target_name][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_MIN] = burst_damage
    player[player_name][target_name][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_MAX] = burst_damage
    player[player_name][target_name][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_DAMAGE] = burst_damage
    player[player_name][target_name][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_COUNT] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.TOTAL_DAMAGE] = {}
    player[player_name][target_name][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = burst_damage
    player[player_name][target_name][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
    player[player_name][target_name][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = burst_damage

    player_catalog[player_name][target_name] = {}
    player_catalog[player_name][target_name][action_name] = {}
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_NUKING] = {}
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = burst_damage
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_MIN] = burst_damage
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_MAX] = burst_damage
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_DAMAGE] = burst_damage
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_COUNT] = 1
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_TARGET] = 1
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 1

    -- Damage done to target two.
    player[player_name][target_name_two] = {}
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL] = {}
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = regular_damage
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.MIN] = regular_damage
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.MAX] = regular_damage
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_NUKING] = {}
    player[player_name][target_name_two][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = regular_damage
    player[player_name][target_name_two][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = regular_damage
    player[player_name][target_name_two][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = regular_damage
    player[player_name][target_name_two][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_USE] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost
    player[player_name][target_name_two][DB.Trackable.TOTAL_DAMAGE] = {}
    player[player_name][target_name_two][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = regular_damage
    player[player_name][target_name_two][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
    player[player_name][target_name_two][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = regular_damage

    player_catalog[player_name][target_name_two] = {}
    player_catalog[player_name][target_name_two][action_name] = {}
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_NUKING] = {}
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = regular_damage
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = regular_damage
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = regular_damage
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_TARGET] = 1
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost

    -- Damage done to all mobs.
    player[player_name][all_mobs] = {}
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL] = {}
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = burst_damage + regular_damage
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.MIN] = regular_damage
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.MAX] = regular_damage
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.CRITICAL_MIN] = burst_damage
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.CRITICAL_MAX] = burst_damage
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.CRITICAL_DAMAGE] = burst_damage
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.CRITICAL_COUNT] =  1
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING] = {}
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = burst_damage + regular_damage
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = regular_damage
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = regular_damage
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_MIN] = burst_damage
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_MAX] = burst_damage
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_DAMAGE] = burst_damage
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_COUNT] =  1
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost
    player[player_name][all_mobs][DB.Trackable.TOTAL_DAMAGE] = {}
    player[player_name][all_mobs][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = burst_damage + regular_damage
    player[player_name][all_mobs][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
    player[player_name][all_mobs][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = burst_damage + regular_damage

    player_catalog[player_name][all_mobs] = {}
    player_catalog[player_name][all_mobs][action_name] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.TOTAL] = burst_damage + regular_damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MIN] = regular_damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MAX] = regular_damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_MIN] = burst_damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_MAX] = burst_damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_DAMAGE] = burst_damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.CRITICAL_COUNT] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.HITS_ON_TARGET] = 2
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 2
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_NUKING][DB.Metric.MP_SPENT] = mp_cost

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(burst_damage + regular_damage),
        action = action_name,
        note   = "BURST! TGTs: 2",
    }

    local misc = {}
    misc["Total Damage"] = burst_damage + regular_damage
    misc["Total Damage No Skillchain"] = burst_damage + regular_damage

    local test_package = {
        player = player,
        player_catalog = player_catalog,
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Spells > Nuke AOE (with Burst)", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells > Pet Nuke
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Pet_Nuke = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local message = Ashita.Enum.Message.SPELL_DAMAGE_HIT
    local action_id = 145
    local action_name = "Fire II"
    local mp_cost = 68

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, message))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

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
        player[player_name][target_index][DB.Trackable.PET_GENERAL_MAGIC] = {}
        player[player_name][target_index][DB.Trackable.PET_GENERAL_MAGIC][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.PET_NUKING] = {}
        player[player_name][target_index][DB.Trackable.PET_NUKING][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.PET_NUKING][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.PET_NUKING][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.PET_NUKING][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.PET_NUKING][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.PET_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_NUKING][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.PET_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_NUKING] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_NUKING][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_NUKING][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_NUKING][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_NUKING][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_NUKING][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_NUKING][DB.Metric.MP_SPENT] = mp_cost

        pet[player_name][pet_name][target_index] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_GENERAL_MAGIC] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_GENERAL_MAGIC][DB.Metric.MP_SPENT] = mp_cost
        pet[player_name][pet_name][target_index][DB.Trackable.PET_NUKING] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_NUKING][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_NUKING][DB.Metric.MIN] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_NUKING][DB.Metric.MAX] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_NUKING][DB.Metric.HITS_ON_USE] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_NUKING][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_NUKING][DB.Metric.MP_SPENT] = mp_cost
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_OVERALL] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.MIN] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.MAX] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        pet[player_name][pet_name][target_index][DB.Trackable.PET_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1

        pet_catalog[player_name][pet_name][target_index] = {}
        pet_catalog[player_name][pet_name][target_index][action_name] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_NUKING] = {}
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_NUKING][DB.Metric.TOTAL] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_NUKING][DB.Metric.MIN] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_NUKING][DB.Metric.MAX] = damage
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_NUKING][DB.Metric.HITS_ON_USE] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_NUKING][DB.Metric.HITS_ON_TARGET] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_NUKING][DB.Metric.ATTEMPTS_ON_USE] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_NUKING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_NUKING][DB.Metric.MP_SPENT] = mp_cost
    end

    local battle_log = {
        player = player_name,
        pet    = Debug.Unit.Mob.PET.name,
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

    return Debug.Unit.Check_Result("Spells > Pet Nuke", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells > Healing
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Healing = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.PLAYER_TWO.name
    local all_mobs = DB.Enum.ALL_MOBS
    local damage = 100
    local message = Ashita.Enum.Message.SPELL_HP_RECOVERY_PRIMARY
    local action_id = 3
    local action_name = "Cure III"
    local mp_cost = 46

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.PLAYER_TWO.id, damage, nil, nil, message))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}

    player[player_name] = {}
    player[target_name] = {}
    player_catalog[player_name] = {}
    player_catalog[target_name] = {}

    -- Healing GIVEN attributed to healer.
    player[player_name][target_name] = {}
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL] = {}
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[player_name][target_name][DB.Trackable.ALL_HEAL] = {}
    player[player_name][target_name][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
    player[player_name][target_name][DB.Trackable.ALL_HEAL][DB.Metric.MIN] = damage
    player[player_name][target_name][DB.Trackable.ALL_HEAL][DB.Metric.MAX] = damage
    player[player_name][target_name][DB.Trackable.ALL_HEAL][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.ALL_HEAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_HEALING] = {}
    player[player_name][target_name][DB.Trackable.SPELLS_HEALING][DB.Metric.TOTAL] = damage
    player[player_name][target_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MIN] = damage
    player[player_name][target_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MAX] = damage
    player[player_name][target_name][DB.Trackable.SPELLS_HEALING][DB.Metric.HITS_ON_USE] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_HEALING][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MP_SPENT] = mp_cost

    player_catalog[player_name][target_name] = {}
    player_catalog[player_name][target_name][action_name] = {}
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_HEALING] = {}
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.TOTAL] = damage
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MIN] = damage
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MAX] = damage
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.HITS_ON_TARGET] = 1
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MP_SPENT] = mp_cost

    -- Healing RECEIVED attributed to recipient.
    player[target_name][player_name] = {}
    player[target_name][player_name][DB.Trackable.DEF_HEALING_RECEIVED] = {}
    player[target_name][player_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.TOTAL] = damage
    player[target_name][player_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MIN] = damage
    player[target_name][player_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MAX] = damage
    player[target_name][player_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.HITS_ON_USE] = 1
    player[target_name][player_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.HITS_ON_TARGET] = 1
    player[target_name][player_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[target_name][player_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[target_name][player_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MP_SPENT] = mp_cost

    player_catalog[target_name][player_name] = {}
    player_catalog[target_name][player_name][action_name] = {}
    player_catalog[target_name][player_name][action_name][DB.Trackable.DEF_HEALING_RECEIVED] = {}
    player_catalog[target_name][player_name][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.TOTAL] = damage
    player_catalog[target_name][player_name][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MIN] = damage
    player_catalog[target_name][player_name][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MAX] = damage
    player_catalog[target_name][player_name][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.HITS_ON_USE] = 1
    player_catalog[target_name][player_name][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.HITS_ON_TARGET] = 1
    player_catalog[target_name][player_name][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[target_name][player_name][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player_catalog[target_name][player_name][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MP_SPENT] = mp_cost

    -- No filter healing from caster.
    player[player_name][all_mobs] = {}
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL] = {}
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[player_name][all_mobs][DB.Trackable.ALL_HEAL] = {}
    player[player_name][all_mobs][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
    player[player_name][all_mobs][DB.Trackable.ALL_HEAL][DB.Metric.MIN] = damage
    player[player_name][all_mobs][DB.Trackable.ALL_HEAL][DB.Metric.MAX] = damage
    player[player_name][all_mobs][DB.Trackable.ALL_HEAL][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][all_mobs][DB.Trackable.ALL_HEAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][all_mobs][DB.Trackable.SPELLS_HEALING] = {}
    player[player_name][all_mobs][DB.Trackable.SPELLS_HEALING][DB.Metric.TOTAL] = damage
    player[player_name][all_mobs][DB.Trackable.SPELLS_HEALING][DB.Metric.MIN] = damage
    player[player_name][all_mobs][DB.Trackable.SPELLS_HEALING][DB.Metric.MAX] = damage
    player[player_name][all_mobs][DB.Trackable.SPELLS_HEALING][DB.Metric.HITS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.SPELLS_HEALING][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][all_mobs][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][all_mobs][DB.Trackable.SPELLS_HEALING][DB.Metric.MP_SPENT] = mp_cost

    player_catalog[player_name][all_mobs] = {}
    player_catalog[player_name][all_mobs][action_name] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_HEALING] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.TOTAL] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MIN] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MAX] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.HITS_ON_TARGET] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MP_SPENT] = mp_cost

    -- No filter healing RECEIVED from recipient.
    player[target_name][all_mobs] = {}
    player[target_name][all_mobs][DB.Trackable.DEF_HEALING_RECEIVED] = {}
    player[target_name][all_mobs][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.TOTAL] = damage
    player[target_name][all_mobs][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MIN] = damage
    player[target_name][all_mobs][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MAX] = damage
    player[target_name][all_mobs][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.HITS_ON_USE] = 1
    player[target_name][all_mobs][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.HITS_ON_TARGET] = 1
    player[target_name][all_mobs][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[target_name][all_mobs][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[target_name][all_mobs][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MP_SPENT] = mp_cost

    player_catalog[target_name][all_mobs] = {}
    player_catalog[target_name][all_mobs][action_name] = {}
    player_catalog[target_name][all_mobs][action_name][DB.Trackable.DEF_HEALING_RECEIVED] = {}
    player_catalog[target_name][all_mobs][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.TOTAL] = damage
    player_catalog[target_name][all_mobs][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MIN] = damage
    player_catalog[target_name][all_mobs][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MAX] = damage
    player_catalog[target_name][all_mobs][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.HITS_ON_USE] = 1
    player_catalog[target_name][all_mobs][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.HITS_ON_TARGET] = 1
    player_catalog[target_name][all_mobs][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[target_name][all_mobs][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player_catalog[target_name][all_mobs][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MP_SPENT] = mp_cost

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

    return Debug.Unit.Check_Result("Spells > Healing", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells > Healing AOE
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Healing_AOE = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.PLAYER_TWO.name
    local all_mobs = DB.Enum.ALL_MOBS
    local damage = 100
    local damage_two = 200
    local message = Ashita.Enum.Message.SPELL_HP_RECOVERY_PRIMARY
    local message_two = Ashita.Enum.Message.SPELL_HP_RECOVERY_ADDITIONAL
    local action_id = 8
    local action_name = "Curaga II"
    local mp_cost = 120

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.PLAYER.id, damage, nil, nil, message))
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.PLAYER_TWO.id, damage_two, nil, nil, message_two))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}

    player[player_name] = {}
    player[target_name] = {}
    player_catalog[player_name] = {}
    player_catalog[target_name] = {}

    -- Healing from the caster to self.
    -- Attempt counts, hit counts, and MP Spent are applied to the target.
    player[player_name][player_name] = {}
    player[player_name][player_name][DB.Trackable.ALL_HEAL] = {}
    player[player_name][player_name][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
    player[player_name][player_name][DB.Trackable.ALL_HEAL][DB.Metric.MIN] = damage
    player[player_name][player_name][DB.Trackable.ALL_HEAL][DB.Metric.MAX] = damage
    player[player_name][player_name][DB.Trackable.ALL_HEAL][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][player_name][DB.Trackable.ALL_HEAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][player_name][DB.Trackable.SPELLS_HEALING] = {}
    player[player_name][player_name][DB.Trackable.SPELLS_HEALING][DB.Metric.TOTAL] = damage
    player[player_name][player_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MIN] = damage
    player[player_name][player_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MAX] = damage
    player[player_name][player_name][DB.Trackable.SPELLS_HEALING][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][player_name][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 1

    player_catalog[player_name][player_name] = {}
    player_catalog[player_name][player_name][action_name] = {}
    player_catalog[player_name][player_name][action_name][DB.Trackable.SPELLS_HEALING] = {}
    player_catalog[player_name][player_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.TOTAL] = damage
    player_catalog[player_name][player_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MIN] = damage
    player_catalog[player_name][player_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MAX] = damage
    player_catalog[player_name][player_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.HITS_ON_TARGET] = 1
    player_catalog[player_name][player_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 1

    -- Healing from the caster given to the target.
    player[player_name][target_name] = {}
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL] = {}
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[player_name][target_name][DB.Trackable.ALL_HEAL] = {}
    player[player_name][target_name][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage_two
    player[player_name][target_name][DB.Trackable.ALL_HEAL][DB.Metric.MIN] = damage_two
    player[player_name][target_name][DB.Trackable.ALL_HEAL][DB.Metric.MAX] = damage_two
    player[player_name][target_name][DB.Trackable.ALL_HEAL][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.ALL_HEAL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_HEALING] = {}
    player[player_name][target_name][DB.Trackable.SPELLS_HEALING][DB.Metric.TOTAL] = damage_two
    player[player_name][target_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MIN] = damage_two
    player[player_name][target_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MAX] = damage_two
    player[player_name][target_name][DB.Trackable.SPELLS_HEALING][DB.Metric.HITS_ON_USE] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_HEALING][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MP_SPENT] = mp_cost

    player_catalog[player_name][target_name] = {}
    player_catalog[player_name][target_name][action_name] = {}
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_HEALING] = {}
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.TOTAL] = damage_two
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MIN] = damage_two
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MAX] = damage_two
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.HITS_ON_TARGET] = 1
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MP_SPENT] = mp_cost

    -- Healing received by the target from the caster.
    player[target_name][player_name] = {}
    player[target_name][player_name][DB.Trackable.DEF_HEALING_RECEIVED] = {}
    player[target_name][player_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.TOTAL] = damage_two
    player[target_name][player_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MIN] = damage_two
    player[target_name][player_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MAX] = damage_two
    player[target_name][player_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.HITS_ON_USE] = 1
    player[target_name][player_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.HITS_ON_TARGET] = 1
    player[target_name][player_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[target_name][player_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[target_name][player_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MP_SPENT] = mp_cost / 2

    player_catalog[target_name][player_name] = {}
    player_catalog[target_name][player_name][action_name] = {}
    player_catalog[target_name][player_name][action_name][DB.Trackable.DEF_HEALING_RECEIVED] = {}
    player_catalog[target_name][player_name][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.TOTAL] = damage_two
    player_catalog[target_name][player_name][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MIN] = damage_two
    player_catalog[target_name][player_name][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MAX] = damage_two
    player_catalog[target_name][player_name][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.HITS_ON_USE] = 1
    player_catalog[target_name][player_name][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.HITS_ON_TARGET] = 1
    player_catalog[target_name][player_name][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[target_name][player_name][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player_catalog[target_name][player_name][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MP_SPENT] = mp_cost / 2

    -- No filter healing from the caster.
    player[player_name][all_mobs] = {}
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL] = {}
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[player_name][all_mobs][DB.Trackable.ALL_HEAL] = {}
    player[player_name][all_mobs][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage + damage_two
    player[player_name][all_mobs][DB.Trackable.ALL_HEAL][DB.Metric.MIN] = damage
    player[player_name][all_mobs][DB.Trackable.ALL_HEAL][DB.Metric.MAX] = damage_two
    player[player_name][all_mobs][DB.Trackable.ALL_HEAL][DB.Metric.HITS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.ALL_HEAL][DB.Metric.ATTEMPTS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.SPELLS_HEALING] = {}
    player[player_name][all_mobs][DB.Trackable.SPELLS_HEALING][DB.Metric.TOTAL] = damage + damage_two
    player[player_name][all_mobs][DB.Trackable.SPELLS_HEALING][DB.Metric.MIN] = damage
    player[player_name][all_mobs][DB.Trackable.SPELLS_HEALING][DB.Metric.MAX] = damage_two
    player[player_name][all_mobs][DB.Trackable.SPELLS_HEALING][DB.Metric.HITS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.SPELLS_HEALING][DB.Metric.HITS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.SPELLS_HEALING][DB.Metric.MP_SPENT] = mp_cost

    player_catalog[player_name][all_mobs] = {}
    player_catalog[player_name][all_mobs][action_name] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_HEALING] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.TOTAL] = damage + damage_two
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MIN] = damage
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MAX] = damage_two
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.HITS_ON_TARGET] = 2
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.ATTEMPTS_ON_TARGET] = 2
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_HEALING][DB.Metric.MP_SPENT] = mp_cost

    -- No filter healing received by the target.
    player[target_name][all_mobs] = {}
    player[target_name][all_mobs][DB.Trackable.DEF_HEALING_RECEIVED] = {}
    player[target_name][all_mobs][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.TOTAL] = damage_two
    player[target_name][all_mobs][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MIN] = damage_two
    player[target_name][all_mobs][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MAX] = damage_two
    player[target_name][all_mobs][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.HITS_ON_USE] = 1
    player[target_name][all_mobs][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.HITS_ON_TARGET] = 1
    player[target_name][all_mobs][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[target_name][all_mobs][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[target_name][all_mobs][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MP_SPENT] = mp_cost / 2

    player_catalog[target_name][all_mobs] = {}
    player_catalog[target_name][all_mobs][action_name] = {}
    player_catalog[target_name][all_mobs][action_name][DB.Trackable.DEF_HEALING_RECEIVED] = {}
    player_catalog[target_name][all_mobs][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.TOTAL] = damage_two
    player_catalog[target_name][all_mobs][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MIN] = damage_two
    player_catalog[target_name][all_mobs][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MAX] = damage_two
    player_catalog[target_name][all_mobs][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.HITS_ON_USE] = 1
    player_catalog[target_name][all_mobs][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.HITS_ON_TARGET] = 1
    player_catalog[target_name][all_mobs][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[target_name][all_mobs][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player_catalog[target_name][all_mobs][action_name][DB.Trackable.DEF_HEALING_RECEIVED][DB.Metric.MP_SPENT] = mp_cost / 2

    local battle_log = {
        player = player_name,
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

    return Debug.Unit.Check_Result("Spells > Healing AOE", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells > Pet Heal
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Pet_Heal = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local message = Ashita.Enum.Message.SPELL_HP_RECOVERY_PRIMARY
    local action_id = 3
    local action_name = "Cure III"
    local mp_cost = 46

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, message))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PET, Debug.Unit.Mob.PLAYER, true)

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
        player[player_name][target_index][DB.Trackable.PET_GENERAL_MAGIC] = {}
        player[player_name][target_index][DB.Trackable.PET_GENERAL_MAGIC][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.ALL_HEAL] = {}
        player[player_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.MAX] = damage
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
        player[player_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.MP_SPENT] = mp_cost

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
        player_catalog[player_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.MP_SPENT] = mp_cost

        pet[player_name][pet_name][target_index] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_GENERAL_MAGIC] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.PET_GENERAL_MAGIC][DB.Metric.MP_SPENT] = mp_cost
        pet[player_name][pet_name][target_index][DB.Trackable.ALL_HEAL] = {}
        pet[player_name][pet_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.MIN] = damage
        pet[player_name][pet_name][target_index][DB.Trackable.ALL_HEAL][DB.Metric.MAX] = damage
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
        pet[player_name][pet_name][target_index][DB.Trackable.PET_HEALING][DB.Metric.MP_SPENT] = mp_cost

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
        pet_catalog[player_name][pet_name][target_index][action_name][DB.Trackable.PET_HEALING][DB.Metric.MP_SPENT] = mp_cost
    end

    local battle_log = {
        player = player_name,
        pet    = Debug.Unit.Mob.PET.name,
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

    return Debug.Unit.Check_Result("Spells > Pet Heal", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells - DoT > No Damage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.DoT_No_Damage = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local action_id = 230
    local action_name = "Bio"
    local mp_cost = 15

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, Ashita.Enum.Message.SPELL_DAMAGE_HIT))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.SPELLS_DOT] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_DOT][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_DOT][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_DOT][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_DOT][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_DOT][DB.Metric.MP_SPENT] = mp_cost

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT][DB.Metric.MP_SPENT] = mp_cost
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

    return Debug.Unit.Check_Result("Spells - DoT > No Damage", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells - DoT > Damage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.DoT_Damage = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 1
    local action_id = 230
    local action_name = "Bio"
    local mp_cost = 15

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, Ashita.Enum.Message.SPELL_DAMAGE_HIT))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.SPELLS_DOT] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_DOT][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_DOT][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_DOT][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_DOT][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_DOT][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_DOT][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_DOT][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_DOT][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = {}
        player[player_name][target_index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT][DB.Metric.MP_SPENT] = mp_cost
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

    return Debug.Unit.Check_Result("Spells - DoT > Damage", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells - DoT > Poison
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Poison = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 3    -- Poison Debuff
    local action_id = 220
    local action_name = "Poison"
    local mp_cost = 5

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, Ashita.Enum.Message.SPELL_ENFEEBLE_LAND))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.SPELLS_DOT] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_DOT][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_DOT][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_DOT][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_DOT][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_DOT][DB.Metric.MP_SPENT] = mp_cost

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DOT][DB.Metric.MP_SPENT] = mp_cost
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

    return Debug.Unit.Check_Result("Spells - DoT > Poison", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells - Aspir
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Aspir = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local message = Ashita.Enum.Message.SPELL_MP_DRAIN
    local action_id = 247
    local action_name = "Aspir"
    local mp_cost = 10

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, message))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.MIN] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.MAX] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.MP_SPENT] = mp_cost

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.MP_SPENT] = mp_cost
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

    return Debug.Unit.Check_Result("Spells - Aspir", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells - Aspir (Burst)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Aspir_Burst = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 247
    local action_name = "Aspir"
    local mp_cost = 10

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, Ashita.Enum.Message.SPELL_MAGIC_BURST_MP_DRAIN))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.TOTAL] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.CRITICAL_MIN] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.CRITICAL_MAX] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.CRITICAL_DAMAGE] = damage
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.CRITICAL_COUNT] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.MP_SPENT] = mp_cost

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.TOTAL] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.CRITICAL_MIN] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.CRITICAL_MAX] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.CRITICAL_DAMAGE] = damage
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.CRITICAL_COUNT] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_MP_DRAIN][DB.Metric.MP_SPENT] = mp_cost
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = "BURST!",
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

    return Debug.Unit.Check_Result("Spells - Aspir (Burst)", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells - Enfeeble > Land
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Enfeeble_Land = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 252
    local action_name = "Stun"
    local mp_cost = 25

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, Ashita.Enum.Message.SPELL_ENFEEBLE_LAND))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost
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

    return Debug.Unit.Check_Result("Spells - Enfeeble > Land", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells - Enfeeble > Resist
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Enfeeble_Resist = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 252
    local action_name = "Stun"
    local mp_cost = 25

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, Ashita.Enum.Message.SPELL_RESIST))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = action_name,
        note   = Blog.Enum.RESIST,
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

    return Debug.Unit.Check_Result("Spells - Enfeeble > Resist", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells - Enfeeble > No Effect
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Enfeeble_No_Effect = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 252
    local action_name = "Stun"
    local mp_cost = 25

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, Ashita.Enum.Message.SPELL_NO_EFFECT))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = action_name,
        note   = Blog.Enum.NO_EFFECT,
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

    return Debug.Unit.Check_Result("Spells - Enfeeble > No Effect", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells - Enfeeble > Shadow
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Enfeeble_Shadow = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 252
    local action_name = "Stun"
    local mp_cost = 25

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, Ashita.Enum.Message.SHADOW_ABSORPTION))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost
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

    return Debug.Unit.Check_Result("Spells - Enfeeble > Shadow", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells - Enfeeble > AOE Land
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Enfeeble_AOE_Land = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local target_name_two = Debug.Unit.Mob.ENEMY_TWO.name
    local all_mobs = DB.Enum.ALL_MOBS
    local damage = 100
    local damage_two = 200
    local action_id = 274
    local action_name = "Sleepga II"
    local mp_cost = 58

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, Ashita.Enum.Message.SPELL_ENFEEBLE_LAND))
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID_Two, damage_two, nil, nil, Ashita.Enum.Message.SPELL_ENFEEBLE_LAND))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}

    player[player_name] = {}
    player_catalog[player_name] = {}

    -- Mob specific enfeebles from the player for mob one.
    player[player_name][target_name] = {}
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL] = {}
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_ENFEEBLING] = {}
    player[player_name][target_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 1

    player_catalog[player_name][target_name] = {}
    player_catalog[player_name][target_name][action_name] = {}
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_ENFEEBLING] = {}
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_TARGET] = 1
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 1

    -- Mob specific enfeebles from the player for mob two.
    player[player_name][target_name_two] = {}
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL] = {}
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[player_name][target_name_two][DB.Trackable.SPELLS_ENFEEBLING] = {}
    player[player_name][target_name_two][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_USE] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

    player_catalog[player_name][target_name_two] = {}
    player_catalog[player_name][target_name_two][action_name] = {}
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_ENFEEBLING] = {}
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_TARGET] = 1
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

    -- Unfiltered enfeebles from player on all mobs.
    player[player_name][all_mobs] = {}
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL] = {}
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[player_name][all_mobs][DB.Trackable.SPELLS_ENFEEBLING] = {}
    player[player_name][all_mobs][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

    player_catalog[player_name][all_mobs] = {}
    player_catalog[player_name][all_mobs][action_name] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_ENFEEBLING] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_TARGET] = 2
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 2
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

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

    return Debug.Unit.Check_Result("Spells - Enfeeble > AOE Land", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells - Enfeeble > AOE One Resist
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Enfeeble_AOE_One_Resist = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local target_name_two = Debug.Unit.Mob.ENEMY_TWO.name
    local all_mobs = DB.Enum.ALL_MOBS
    local damage = 100
    local damage_two = 200
    local action_id = 274
    local action_name = "Sleepga II"
    local mp_cost = 58

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, damage, nil, nil, Ashita.Enum.Message.SPELL_ENFEEBLE_LAND))
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID_Two, damage_two, nil, nil, Ashita.Enum.Message.SPELL_RESIST))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}

    player[player_name] = {}
    player_catalog[player_name] = {}

    -- Mob specific enfeebles from the player for mob one.
    player[player_name][target_name] = {}
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL] = {}
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_ENFEEBLING] = {}
    player[player_name][target_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][target_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 1

    player_catalog[player_name][target_name] = {}
    player_catalog[player_name][target_name][action_name] = {}
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_ENFEEBLING] = {}
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_TARGET] = 1
    player_catalog[player_name][target_name][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 1

    -- Mob specific enfeebles from the player for mob two.
    player[player_name][target_name_two] = {}
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL] = {}
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[player_name][target_name_two][DB.Trackable.SPELLS_ENFEEBLING] = {}
    player[player_name][target_name_two][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_USE] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player[player_name][target_name_two][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

    player_catalog[player_name][target_name_two] = {}
    player_catalog[player_name][target_name_two][action_name] = {}
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_ENFEEBLING] = {}
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
    player_catalog[player_name][target_name_two][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

    -- Unfiltered enfeebles from player on all mobs.
    player[player_name][all_mobs] = {}
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL] = {}
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
    player[player_name][all_mobs][DB.Trackable.SPELLS_ENFEEBLING] = {}
    player[player_name][all_mobs][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_TARGET] = 1
    player[player_name][all_mobs][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player[player_name][all_mobs][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 2
    player[player_name][all_mobs][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

    player_catalog[player_name][all_mobs] = {}
    player_catalog[player_name][all_mobs][action_name] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_ENFEEBLING] = {}
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_TARGET] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_USE] = 1
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 2
    player_catalog[player_name][all_mobs][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

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

    return Debug.Unit.Check_Result("Spells - Enfeeble > AOE One Resist", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells - Dispel
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Dispel = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.ENEMY.name
    local debuff_id = 93
    local debuff_name = "Defense Boost"
    local action_id = 260
    local action_name = "Dispel"
    local mp_cost = 25

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.Target_ID, debuff_id, nil, nil, Ashita.Enum.Message.SPELL_REMOVE_STATUS_EFFECT_PRIMARY))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.HITS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.ATTEMPTS_ON_TARGET] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_ENFEEBLING][DB.Metric.MP_SPENT] = mp_cost
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = action_name,
        note   = debuff_name,
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

    return Debug.Unit.Check_Result("Spells - Dispel", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells - Song
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Song = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.PLAYER.name
    local damage = 0
    local action_id = 398
    local action_name = "Valor Minuet V"

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.PLAYER.id_num, damage))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_BUFF_SONG] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_BUFF_SONG][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_BUFF_SONG][DB.Metric.ATTEMPTS_ON_USE] = 1

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_BUFF_SONG] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_BUFF_SONG][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_BUFF_SONG][DB.Metric.ATTEMPTS_ON_USE] = 1
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
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
        battle_log = battle_log,
        misc = misc,
    }

    return Debug.Unit.Check_Result("Spells - Song", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells - Status_Removal
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Status_Removal = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.PLAYER_TWO.name
    local damage = 128 -- Burn
    local debuff_name = "Burn"
    local action_id = 143
    local action_name = "Erase"
    local mp_cost = 18

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.PLAYER_TWO.id, damage))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.SPELLS_DEBUFF_REMOVAL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_DEBUFF_REMOVAL][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_DEBUFF_REMOVAL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_DEBUFF_REMOVAL][DB.Metric.MP_SPENT] = mp_cost

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DEBUFF_REMOVAL] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DEBUFF_REMOVAL][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DEBUFF_REMOVAL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_DEBUFF_REMOVAL][DB.Metric.MP_SPENT] = mp_cost
    end

    local battle_log = {
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = action_name,
        note   = debuff_name,
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

    return Debug.Unit.Check_Result("Spells - Status_Removal", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells - Buff
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Buff = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.PLAYER_TWO.name
    local damage = 40   -- Protect
    local message = Ashita.Enum.Message.SPELL_BUFF_PRIMARY
    local action_id = 43
    local action_name = "Protect"
    local mp_cost = 9

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.PLAYER_TWO.id, damage, nil, nil, message))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.SPELLS_BUFFS] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_BUFFS][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_BUFFS][DB.Metric.ATTEMPTS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_BUFFS][DB.Metric.MP_SPENT] = mp_cost

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_BUFFS] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_BUFFS][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_BUFFS][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_BUFFS][DB.Metric.MP_SPENT] = mp_cost
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

    return Debug.Unit.Check_Result("Spells - Buff", test_package)
end

------------------------------------------------------------------------------------------------------
-- Spells - Misc
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Spells.Misc = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local target_name = Debug.Unit.Mob.PLAYER_TWO.name
    local damage = 0
    local action_id = 261
    local action_name = "Warp"
    local mp_cost = 100

    local payload = {}
    table.insert(payload, Debug.Unit.Util.Build_Target_Packet(Debug.Unit.Mob.PLAYER_TWO.id, damage))
    local action = Debug.Unit.Util.Build_Action(payload, action_id)
    H.Spell.Action(action, Debug.Unit.Mob.PLAYER, nil, true)

    local player = {}
    local player_catalog = {}
    local target_lists = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

    player[player_name] = {}
    player_catalog[player_name] = {}

    for _, target_index in ipairs(target_lists) do
        player[player_name][target_index] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL] = {}
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_USE] = 1
        player[player_name][target_index][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_USE] = 1

        player_catalog[player_name][target_index] = {}
        player_catalog[player_name][target_index][action_name] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_OVERALL] = {}
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.HITS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.ATTEMPTS_ON_USE] = 1
        player_catalog[player_name][target_index][action_name][DB.Trackable.SPELLS_OVERALL][DB.Metric.MP_SPENT] = mp_cost
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

    return Debug.Unit.Check_Result("Spells - Misc", test_package)
end