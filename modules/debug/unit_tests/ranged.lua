Debug.Unit.Tests.Ranged = {}

------------------------------------------------------------------------------------------------------
-- Ranged > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Hit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGEHIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.RANGED_OVERALL] = T{}
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_SQUARE_HIT] = T{}
    player[index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_TRUE_STRIKE] = T{}
    player[index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    local battle_log = T{
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Ranged",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    return Debug.Unit.Check_Result("Ranged > Hit", player, nil, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Square Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Square = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.SQUARE}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.RANGED_OVERALL] = T{}
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_SQUARE_HIT] = T{}
    player[index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_TRUE_STRIKE] = T{}
    player[index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    local battle_log = T{
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Ranged",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    return Debug.Unit.Check_Result("Ranged > Square Hit", player, nil, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Square Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Truestrike = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.TRUE}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.RANGED_OVERALL] = T{}
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_SQUARE_HIT] = T{}
    player[index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_TRUE_STRIKE] = T{}
    player[index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    local battle_log = T{
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Ranged",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    return Debug.Unit.Check_Result("Ranged > Truestrike", player, nil, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Miss = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGEMISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.RANGED_OVERALL] = T{}
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_SQUARE_HIT] = T{}
    player[index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_TRUE_STRIKE] = T{}
    player[index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = "Ranged",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Ranged > Miss", player, nil, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Crit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Crit = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGECRIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.RANGED_OVERALL] = T{}
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.CRITICAL_DAMAGE] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.CRITICAL_COUNT] = 1
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.CRITICAL_MIN] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.CRITICAL_MAX] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_SQUARE_HIT] = T{}
    player[index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_TRUE_STRIKE] = T{}
    player[index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    local battle_log = T{
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Ranged",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    return Debug.Unit.Check_Result("Ranged > Crit", player, nil, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Shadows
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Shadows = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.SHADOWS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.RANGED_OVERALL] = T{}
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.SHADOW_ABSORPTION] = 1
    player[index][DB.Trackable.RANGED_SQUARE_HIT] = T{}
    player[index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_TRUE_STRIKE] = T{}
    player[index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = "---",
        action = "Ranged",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Ranged > Shadows", player, nil, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Endamage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Endamage = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 200
    local add_effect_animation = 1
    local add_effect_name = "Fire"
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGEHIT}
    local add_effect = {param = additional_damage, animation = add_effect_animation, message = Ashita.Enum.Message.ENDAMAGE}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.RANGED_OVERALL] = T{}
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_SQUARE_HIT] = T{}
    player[index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_TRUE_STRIKE] = T{}
    player[index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = additional_damage
    player[index][DB.Trackable.RANGED_ENDAMAGE] = T{}
    player[index][DB.Trackable.RANGED_ENDAMAGE][DB.Metric.TOTAL] = additional_damage
    player[index][DB.Trackable.RANGED_ENDAMAGE][DB.Metric.MIN] = additional_damage
    player[index][DB.Trackable.RANGED_ENDAMAGE][DB.Metric.MAX] = additional_damage
    player[index][DB.Trackable.RANGED_ENDAMAGE][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage + additional_damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage + additional_damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][add_effect_name] = T{}
    player_catalog[index][add_effect_name][DB.Trackable.RANGED_ENDAMAGE] = T{}
    player_catalog[index][add_effect_name][DB.Trackable.RANGED_ENDAMAGE][DB.Metric.TOTAL] = additional_damage
    player_catalog[index][add_effect_name][DB.Trackable.RANGED_ENDAMAGE][DB.Metric.MIN] = additional_damage
    player_catalog[index][add_effect_name][DB.Trackable.RANGED_ENDAMAGE][DB.Metric.MAX] = additional_damage
    player_catalog[index][add_effect_name][DB.Trackable.RANGED_ENDAMAGE][DB.Metric.HIT_COUNT] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage + additional_damage),
        action = "Ranged",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = damage + additional_damage
    misc["Total Damage No Skillchain"] = damage + additional_damage

    return Debug.Unit.Check_Result("Ranged > Endamage", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Endebuff
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Endebuff = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 5
    local add_effect_name = "Blind"
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGEHIT}
    local add_effect = {param = additional_damage, animation = nil, message = Ashita.Enum.Message.ENDEBUFF}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.RANGED_OVERALL] = T{}
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_SQUARE_HIT] = T{}
    player[index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_TRUE_STRIKE] = T{}
    player[index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_ENDEBUFF] = T{}
    player[index][DB.Trackable.RANGED_ENDEBUFF][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][add_effect_name] = T{}
    player_catalog[index][add_effect_name][DB.Trackable.RANGED_ENDEBUFF] = T{}
    player_catalog[index][add_effect_name][DB.Trackable.RANGED_ENDEBUFF][DB.Metric.HIT_COUNT] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Ranged",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    return Debug.Unit.Check_Result("Ranged > Endebuff", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ranged > Endrain
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Endrain = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local additional_damage = 200
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGEHIT}
    local add_effect = {param = additional_damage, animation = nil, message = Ashita.Enum.Message.ENDRAIN}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary, add_effect)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.RANGED_OVERALL] = T{}
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_SQUARE_HIT] = T{}
    player[index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_TRUE_STRIKE] = T{}
    player[index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.SPELLS_OVERALL] = T{}
    player[index][DB.Trackable.SPELLS_OVERALL][DB.Metric.TOTAL] = additional_damage
    player[index][DB.Trackable.RANGED_ENDRAIN] = T{}
    player[index][DB.Trackable.RANGED_ENDRAIN][DB.Metric.TOTAL] = additional_damage
    player[index][DB.Trackable.RANGED_ENDRAIN][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage + additional_damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage + additional_damage

    local battle_log = T{
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage + additional_damage),
        action = "Ranged",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = damage + additional_damage
    misc["Total Damage No Skillchain"] = damage + additional_damage

    return Debug.Unit.Check_Result("Ranged > Endrain", player, nil, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Ranged - PUP > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.PUP = function()
    Debug.Unit.Reset()
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGEPUP}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, nil, damage, primary)
    H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.RANGED_OVERALL] = T{}
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MIN] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.MAX] = damage
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.RANGED_OVERALL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_SQUARE_HIT] = T{}
    player[index][DB.Trackable.RANGED_SQUARE_HIT][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.RANGED_TRUE_STRIKE] = T{}
    player[index][DB.Trackable.RANGED_TRUE_STRIKE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    local battle_log = T{
        player = Debug.Unit.Mob.PLAYER.name,
        pet    = Blog.Enum.NO_PET,
        damage = tostring(damage),
        action = "Ranged",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = damage
    misc["Total Damage No Skillchain"] = damage

    return Debug.Unit.Check_Result("Ranged - PUP > Hit", player, nil, nil, nil, battle_log, misc)
end