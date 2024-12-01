Debug.Unit.Tests.Ability = {}

------------------------------------------------------------------------------------------------------
-- Ability - Damaging > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Damaging_Hit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 46
    local action_name = "Shield Bash"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.ABILITY_OVERALL] = T{}
    player[index][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.ABILITY_DAMAGING] = T{}
    player[index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_OVERALL] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.ABILITY_DAMAGING] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS] = 1

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

    return Debug.Unit.Check_Result("Ability - Damaging > Hit", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ability - Damaging > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Damaging_Miss = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local action_id = 46
    local action_name = "Shield Bash"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.ABILITY_OVERALL] = T{}
    player[index][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.ABILITY_DAMAGING] = T{}
    player[index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_OVERALL] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.ABILITY_DAMAGING] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = "0",
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Ability - Damaging > Miss", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ability - Damaging > Hit (TP Packet)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Damaging_Hit_TP = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 66
    local action_name = "Jump"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.ABILITY_OVERALL] = T{}
    player[index][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.ABILITY_DAMAGING] = T{}
    player[index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_OVERALL] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.ABILITY_DAMAGING] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS] = 1

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

    return Debug.Unit.Check_Result("Ability - Damaging > Hit (TP Packet)", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ability - Damaging > Miss (TP Packet)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Damaging_Miss_TP = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local action_id = 66
    local action_name = "Jump"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.ABILITY_OVERALL] = T{}
    player[index][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.ABILITY_DAMAGING] = T{}
    player[index][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_OVERALL] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.ABILITY_DAMAGING] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_DAMAGING][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = player_name,
        pet    = Blog.Enum.NO_PET,
        damage = "0",
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Ability - Damaging > Miss (TP Packet)", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ability - Healing
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Healing = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 38
    local action_name = "Chakra"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.ALL_HEAL] = T{}
    player[index][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.ABILITY_OVERALL] = T{}
    player[index][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.ABILITY_HEALING] = T{}
    player[index][DB.Trackable.ABILITY_HEALING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.ABILITY_HEALING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.ABILITY_HEALING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.ABILITY_HEALING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.ABILITY_HEALING][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_OVERALL] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.ABILITY_HEALING] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_HEALING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.ABILITY_HEALING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.ABILITY_HEALING][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.ABILITY_HEALING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.ABILITY_HEALING][DB.Metric.ATTEMPTS] = 1

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

    return Debug.Unit.Check_Result("Ability - Healing", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ability - MP
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.MP = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 154
    local action_name = "Devotion"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.ABILITY_OVERALL] = T{}
    player[index][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.ABILITY_MP_RECOVERY] = T{}
    player[index][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.MIN] = damage
    player[index][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.MAX] = damage
    player[index][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_OVERALL] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.ABILITY_MP_RECOVERY] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.ABILITY_MP_RECOVERY][DB.Metric.ATTEMPTS] = 1

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

    return Debug.Unit.Check_Result("Ability - MP", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ability > No Damage Buff
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.No_Damage = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 47
    local action_name = "Holy Circle"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.ABILITY_OVERALL] = T{}
    player[index][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.ABILITY_GENERAL] = T{}
    player[index][DB.Trackable.ABILITY_GENERAL][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_OVERALL] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_OVERALL][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.ABILITY_GENERAL] = T{}
    player_catalog[index][action_name][DB.Trackable.ABILITY_GENERAL][DB.Metric.ATTEMPTS] = 1

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

    return Debug.Unit.Check_Result("Ability > No Damage Buff", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ability - Avatar > Rage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Avatar_Rage = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 846
    local action_name = "Flaming Crush"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
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

    return Debug.Unit.Check_Result("Ability - Avatar > Rage", player, player_catalog, pet, pet_catalog, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ability - Avatar > Ward
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Avatar_Ward = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 853
    local action_name = "Earthen Ward"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.PET_TP] = T{}
    player[index][DB.Trackable.PET_TP][DB.Metric.HIT_COUNT] = 1
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
    pet[index][pet_name][DB.Trackable.PET_TP][DB.Metric.HIT_COUNT] = 1
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
        note   = "TGTs: 1",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Ability - Avatar > Ward", player, player_catalog, pet, pet_catalog, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ability - Avatar > Healing
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Avatar_Healing = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 906
    local action_name = "Healing Ruby"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.ALL_HEAL] = T{}
    player[index][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.PET_HEALING] = T{}
    player[index][DB.Trackable.PET_HEALING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.PET_HEALING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.PET_HEALING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.PET_HEALING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.PET_HEALING] = T{}
    player_catalog[index][action_name][DB.Trackable.PET_HEALING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.PET_HEALING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.PET_HEALING][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.PET_HEALING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.ALL_HEAL] = T{}
    pet[index][pet_name][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.PET_HEALING] = T{}
    pet[index][pet_name][DB.Trackable.PET_HEALING][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.PET_HEALING][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Trackable.PET_HEALING][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Trackable.PET_HEALING][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS] = 1

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

    return Debug.Unit.Check_Result("Ability - Avatar > Healing", player, player_catalog, pet, pet_catalog, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ability - Wyvern > Breath Damage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Wyvern_Breath_Damage = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 646
    local action_name = "Flame Breath"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = true

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

    return Debug.Unit.Check_Result("Ability - Wyvern > Breath Damage", player, player_catalog, pet, pet_catalog, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ability - Wyvern > Breath Healing
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Wyvern_Breath_Healing = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 640
    local action_name = "Healing Breath"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.ALL_HEAL] = T{}
    player[index][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.PET_HEALING] = T{}
    player[index][DB.Trackable.PET_HEALING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.PET_HEALING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.PET_HEALING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.PET_HEALING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS] = 1

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.PET_HEALING] = T{}
    player_catalog[index][action_name][DB.Trackable.PET_HEALING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.PET_HEALING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.PET_HEALING][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.PET_HEALING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.ALL_HEAL] = T{}
    pet[index][pet_name][DB.Trackable.ALL_HEAL][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.PET_HEALING] = T{}
    pet[index][pet_name][DB.Trackable.PET_HEALING][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.PET_HEALING][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Trackable.PET_HEALING][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Trackable.PET_HEALING][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.PET_HEALING][DB.Metric.ATTEMPTS] = 1

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

    return Debug.Unit.Check_Result("Ability - Wyvern > Breath Healing", player, player_catalog, pet, pet_catalog, battle_log, misc)
end