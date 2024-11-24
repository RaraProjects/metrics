Debug.Unit.Tests.Defense = {}

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Hit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.HIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_MELEE] = T{}
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.MIN] = damage
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.MAX] = damage
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_EVASION] = T{}
    player[index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_PARRY] = T{}
    player[index][DB.Trackable.DEF_PARRY][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_SHADOWS] = T{}
    player[index][DB.Trackable.DEF_SHADOWS][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION] = T{}
    player[index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_COUNTER] = T{}
    player[index][DB.Trackable.MELEE_COUNTER][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_GUARD] = T{}
    player[index][DB.Trackable.DEF_GUARD][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_SHIELD_BLOCK] = T{}
    player[index][DB.Trackable.DEF_SHIELD_BLOCK][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_CRITICAL] = T{}
    player[index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_UNMITIGATED] = T{}
    player[index][DB.Trackable.DEF_UNMITIGATED][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_UNMITIGATED][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = tostring(damage),
        action = "Melee",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - Melee > Hit", player, nil, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Miss = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.MISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_MELEE] = T{}
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_EVASION] = T{}
    player[index][DB.Trackable.DEF_EVASION][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_CRITICAL] = T{}
    player[index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = "---",
        action = "Melee",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - Melee > Miss", player, nil, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Parry
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Parry = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.PARRY}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_MELEE] = T{}
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_EVASION] = T{}
    player[index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_PARRY] = T{}
    player[index][DB.Trackable.DEF_PARRY][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_PARRY][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_CRITICAL] = T{}
    player[index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = "---",
        action = "Melee",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - Melee > Parry", player, nil, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Shadows
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Shadows = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 200
    local primary = {animation = nil, reaction = 1, message = Ashita.Enum.Message.SHADOWS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_MELEE] = T{}
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_EVASION] = T{}
    player[index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_PARRY] = T{}
    player[index][DB.Trackable.DEF_PARRY][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_SHADOWS] = T{}
    player[index][DB.Trackable.DEF_SHADOWS][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_SHADOWS][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_CRITICAL] = T{}
    player[index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = "---",
        action = "Melee",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - Melee > Shadows", player, nil, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Third Eye
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Third_Eye = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.THIRD_EYE_ANTICIPATION}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_MELEE] = T{}
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_EVASION] = T{}
    player[index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_PARRY] = T{}
    player[index][DB.Trackable.DEF_PARRY][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_SHADOWS] = T{}
    player[index][DB.Trackable.DEF_SHADOWS][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION] = T{}
    player[index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_CRITICAL] = T{}
    player[index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = "---",
        action = "Melee",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - Melee > Third Eye", player, nil, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Counter (Player countering the mob)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Counter = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local spike = {param = damage, message = Ashita.Enum.Message.COUNTER}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, 0, nil, nil, spike)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.MELEE_OVERALL] = T{}
    player[index][DB.Trackable.MELEE_OVERALL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_MELEE] = T{}
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_EVASION] = T{}
    player[index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_PARRY] = T{}
    player[index][DB.Trackable.DEF_PARRY][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_SHADOWS] = T{}
    player[index][DB.Trackable.DEF_SHADOWS][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION] = T{}
    player[index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_COUNTER] = T{}
    player[index][DB.Trackable.MELEE_COUNTER][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.MELEE_COUNTER][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.MELEE_COUNTER][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_CRITICAL] = T{}
    player[index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.TOTAL_DAMAGE] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN] = T{}
    player[index][DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN][DB.Metric.TOTAL] = damage

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = "---",
        action = "Melee",
        note   = "Counter: " .. tostring(damage),
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - Melee > Counter", player, nil, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Guard
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Guard = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = Ashita.Enum.Reaction.GUARD, message = Ashita.Enum.Message.HIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_MELEE] = T{}
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.MIN] = damage
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.MAX] = damage
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_EVASION] = T{}
    player[index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_PARRY] = T{}
    player[index][DB.Trackable.DEF_PARRY][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_SHADOWS] = T{}
    player[index][DB.Trackable.DEF_SHADOWS][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION] = T{}
    player[index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_COUNTER] = T{}
    player[index][DB.Trackable.MELEE_COUNTER][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_GUARD] = T{}
    player[index][DB.Trackable.DEF_GUARD][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_GUARD][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_GUARD][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_CRITICAL] = T{}
    player[index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = tostring(damage),
        action = "Melee",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - Melee > Guard", player, nil, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Shield Block
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Shield = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = Ashita.Enum.Reaction.SHIELD_BLOCK, message = Ashita.Enum.Message.HIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_MELEE] = T{}
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.MIN] = damage
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.MAX] = damage
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_EVASION] = T{}
    player[index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_PARRY] = T{}
    player[index][DB.Trackable.DEF_PARRY][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_SHADOWS] = T{}
    player[index][DB.Trackable.DEF_SHADOWS][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION] = T{}
    player[index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_COUNTER] = T{}
    player[index][DB.Trackable.MELEE_COUNTER][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_GUARD] = T{}
    player[index][DB.Trackable.DEF_GUARD][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_SHIELD_BLOCK] = T{}
    player[index][DB.Trackable.DEF_SHIELD_BLOCK][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_SHIELD_BLOCK][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_SHIELD_BLOCK][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_CRITICAL] = T{}
    player[index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = tostring(damage),
        action = "Melee",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - Melee > Shield Block", player, nil, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Crit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Crit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.CRIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_MELEE] = T{}
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.MIN] = damage
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.MAX] = damage
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_MELEE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_EVASION] = T{}
    player[index][DB.Trackable.DEF_EVASION][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_PARRY] = T{}
    player[index][DB.Trackable.DEF_PARRY][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_SHADOWS] = T{}
    player[index][DB.Trackable.DEF_SHADOWS][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION] = T{}
    player[index][DB.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.MELEE_COUNTER] = T{}
    player[index][DB.Trackable.MELEE_COUNTER][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_GUARD] = T{}
    player[index][DB.Trackable.DEF_GUARD][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_SHIELD_BLOCK] = T{}
    player[index][DB.Trackable.DEF_SHIELD_BLOCK][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_CRITICAL] = T{}
    player[index][DB.Trackable.DEF_CRITICAL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_CRITICAL][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_CRITICAL][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_UNMITIGATED] = T{}
    player[index][DB.Trackable.DEF_UNMITIGATED][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_UNMITIGATED][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = tostring(damage),
        action = "Melee",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - Melee > Crit", player, nil, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Pet Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Pet_Hit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.HIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PET.id, nil, damage, primary)
    Debug.Unit.Has_Pet = true
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, Debug.Unit.Mob.PLAYER, true)
    Debug.Unit.Has_Pet = false

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_MELEE_PET] = T{}
    player[index][DB.Trackable.DEF_MELEE_PET][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_MELEE_PET][DB.Metric.MIN] = damage
    player[index][DB.Trackable.DEF_MELEE_PET][DB.Metric.MAX] = damage
    player[index][DB.Trackable.DEF_MELEE_PET][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_MELEE_PET][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.DEF_MELEE_PET] = T{}
    pet[index][pet_name][DB.Trackable.DEF_MELEE_PET][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.DEF_MELEE_PET][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Trackable.DEF_MELEE_PET][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Trackable.DEF_MELEE_PET][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.DEF_MELEE_PET][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = T{}
    pet[index][pet_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = tostring(damage),
        action = "Melee",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - Melee > Pet Hit", player, nil, pet, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Pet Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Pet_Miss = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 0
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.MISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PET.id, nil, damage, primary)
    Debug.Unit.Has_Pet = true
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, Debug.Unit.Mob.PLAYER, true)
    Debug.Unit.Has_Pet = false

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_MELEE_PET] = T{}
    player[index][DB.Trackable.DEF_MELEE_PET][DB.Metric.ATTEMPTS] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.DEF_MELEE_PET] = T{}
    pet[index][pet_name][DB.Trackable.DEF_MELEE_PET][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = "---",
        action = "Melee",
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - Melee > Pet Miss", player, nil, pet, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - Ranged > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Ranged_Hit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 272
    local action_name = "Ranged Attack"
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.RANGEHIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage, primary)
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_TP_MOVE] = T{}
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - Ranged > Hit", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - Nuke
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Nuke = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 145
    local action_name = "Fire II"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage)
    H.Spell_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_NUKING] = T{}
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - Nuke", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - Nuke AOE
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Nuke_AOE = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local index_two = tostring(Debug.Unit.Mob.PLAYER_TWO.name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local damage_two = 200
    local action_id = 174
    local action_name = "Firaga"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage, nil, nil, nil, Debug.Unit.Mob.PLAYER_TWO.id, damage_two)
    H.Spell_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_NUKING] = T{}
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage
    player[index_two] = T{}
    player[index_two][DB.Trackable.DEF_NUKING] = T{}
    player[index_two][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage_two
    player[index_two][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage_two
    player[index_two][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage_two
    player[index_two][DB.Trackable.DEF_NUKING][DB.Metric.HIT_COUNT] = 1
    player[index_two][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS] = 1
    player[index_two][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = T{}
    player[index_two][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage_two

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS] = 1
    player_catalog[index_two] = T{}
    player_catalog[index_two][action_name] = T{}
    player_catalog[index_two][action_name][DB.Trackable.DEF_NUKING] = T{}
    player_catalog[index_two][action_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage_two
    player_catalog[index_two][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage_two
    player_catalog[index_two][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage_two
    player_catalog[index_two][action_name][DB.Trackable.DEF_NUKING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index_two][action_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = tostring(damage + damage_two),
        action = action_name,
        note   = "TGTs: 2",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - Nuke AOE", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - Nuke Pet
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Nuke_Pet = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 145
    local action_name = "Fire II"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PET.id, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Spell_Def.Action(action, Debug.Unit.Mob.ENEMY, Debug.Unit.Mob.PLAYER, true)
    Debug.Unit.Has_Pet = false

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_NUKING_PET] = T{}
    player[index][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
    player[index][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
    player[index][DB.Trackable.DEF_NUKING_PET][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING_PET] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.DEF_NUKING_PET] = T{}
    pet[index][pet_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = T{}
    pet[index][pet_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_NUKING_PET] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - Nuke Pet", player, player_catalog, pet, pet_catalog, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - Nuke Pet AOE (Primary)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Nuke_Pet_AOE_Primary = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local damage_two = 200
    local action_id = 174
    local action_name = "Firaga"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PET.id, action_id, damage, nil, nil, nil, Debug.Unit.Mob.PLAYER.id, damage_two)
    Debug.Unit.Has_Pet = true
    H.Spell_Def.Action(action, Debug.Unit.Mob.ENEMY, Debug.Unit.Mob.PLAYER, true)
    Debug.Unit.Has_Pet = false

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage_two
    player[index][DB.Trackable.DEF_NUKING] = T{}
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage_two
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage_two
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage_two
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_NUKING_PET] = T{}
    player[index][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
    player[index][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
    player[index][DB.Trackable.DEF_NUKING_PET][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage_two
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage_two
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage_two
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING_PET] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.DEF_NUKING_PET] = T{}
    pet[index][pet_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = T{}
    pet[index][pet_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_NUKING_PET] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = tostring(damage + damage_two),
        action = action_name,
        note   = "TGTs: 2",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - Nuke Pet AOE Primary", player, player_catalog, pet, pet_catalog, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - Nuke Pet AOE (Secondary)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Nuke_Pet_AOE_Secondary = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local damage_two = 200
    local action_id = 174
    local action_name = "Firaga"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id, action_id, damage, nil, nil, nil, Debug.Unit.Mob.PET.id, damage_two)
    Debug.Unit.Has_Pet = true
    H.Spell_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)
    Debug.Unit.Has_Pet = false

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_NUKING] = T{}
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_NUKING_PET] = T{}
    player[index][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage_two
    player[index][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage_two
    player[index][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage_two
    player[index][DB.Trackable.DEF_NUKING_PET][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage_two

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING_PET] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage_two
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage_two
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage_two
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.DEF_NUKING_PET] = T{}
    pet[index][pet_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage_two
    pet[index][pet_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage_two
    pet[index][pet_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage_two
    pet[index][pet_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = T{}
    pet[index][pet_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage_two

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_NUKING_PET] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.TOTAL] = damage_two
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MIN] = damage_two
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.MAX] = damage_two
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_NUKING_PET][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = tostring(damage + damage_two),
        action = action_name,
        note   = "TGTs: 2",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - Nuke Pet AOE Secondary", player, player_catalog, pet, pet_catalog, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - TP
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.TP = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 262
    local action_name = "Sheep Charge"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage)
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_TP_MOVE] = T{}
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - TP", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - TP AOE
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.TP_AOE = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local index_two = tostring(Debug.Unit.Mob.PLAYER_TWO.name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local damage_two = 200
    local action_id = 273
    local action_name = "Claw Cyclone"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage, nil, nil, nil, Debug.Unit.Mob.PLAYER_TWO.id, damage_two)
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_TP_MOVE] = T{}
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage
    player[index_two] = T{}
    player[index_two][DB.Trackable.DEF_TP_MOVE] = T{}
    player[index_two][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage_two
    player[index_two][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage_two
    player[index_two][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage_two
    player[index_two][DB.Trackable.DEF_TP_MOVE][DB.Metric.HIT_COUNT] = 1
    player[index_two][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS] = 1
    player[index_two][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = T{}
    player[index_two][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage_two

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS] = 1
    player_catalog[index_two] = T{}
    player_catalog[index_two][action_name] = T{}
    player_catalog[index_two][action_name][DB.Trackable.DEF_TP_MOVE] = T{}
    player_catalog[index_two][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage_two
    player_catalog[index_two][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage_two
    player_catalog[index_two][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage_two
    player_catalog[index_two][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HIT_COUNT] = 1
    player_catalog[index_two][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = tostring(damage + damage_two),
        action = action_name,
        note   = "TGTs: 2",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - TP AOE", player, player_catalog, nil, nil, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - TP Pet
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.TP_Pet = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 262
    local action_name = "Sheep Charge"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PET.id, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, Debug.Unit.Mob.PLAYER, true)
    Debug.Unit.Has_Pet = false

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_TP_MOVE_PET] = T{}
    player[index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
    player[index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
    player[index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE_PET] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.DEF_TP_MOVE_PET] = T{}
    pet[index][pet_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = T{}
    pet[index][pet_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_TP_MOVE_PET] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = tostring(damage),
        action = action_name,
        note   = " ",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - TP Pet", player, player_catalog, pet, pet_catalog, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - TP Pet AOE Primary
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.TP_Pet_AOE_Primary = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local damage_two = 200
    local action_id = 273
    local action_name = "Claw Cyclone"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PET.id, action_id, damage, nil, nil, nil, Debug.Unit.Mob.PLAYER.id_num, damage_two)
    Debug.Unit.Has_Pet = true
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, Debug.Unit.Mob.PLAYER, true)
    Debug.Unit.Has_Pet = false

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_TP_MOVE] = T{}
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage_two
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage_two
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage_two
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_TP_MOVE_PET] = T{}
    player[index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
    player[index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
    player[index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage_two
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage_two
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage_two
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage_two
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE_PET] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.DEF_TP_MOVE_PET] = T{}
    pet[index][pet_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
    pet[index][pet_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
    pet[index][pet_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = T{}
    pet[index][pet_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_TP_MOVE_PET] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = tostring(damage + damage_two),
        action = action_name,
        note   = "TGTs: 2",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - TP Pet AOE Primary", player, player_catalog, pet, pet_catalog, battle_log, misc)
end

------------------------------------------------------------------------------------------------------
-- Defense - TP Pet AOE Secondary
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.TP_Pet_AOE_Secondary = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local pet_name = Debug.Unit.Mob.PET.name
    local damage = 100
    local damage_two = 200
    local action_id = 273
    local action_name = "Claw Cyclone"
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage, nil, nil, nil, Debug.Unit.Mob.PET.id, damage_two)
    Debug.Unit.Has_Pet = true
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, nil, true)
    Debug.Unit.Has_Pet = false

    local player = T{}
    player[index] = T{}
    player[index][DB.Trackable.DEF_TP_MOVE] = T{}
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_TP_MOVE_PET] = T{}
    player[index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage_two
    player[index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage_two
    player[index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage_two
    player[index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HIT_COUNT] = 1
    player[index][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS] = 1
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL][DB.Metric.TOTAL] = damage
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = T{}
    player[index][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage_two

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE][DB.Metric.ATTEMPTS] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE_PET] = T{}
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage_two
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage_two
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage_two
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Trackable.DEF_TP_MOVE_PET] = T{}
    pet[index][pet_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage_two
    pet[index][pet_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage_two
    pet[index][pet_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage_two
    pet[index][pet_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS] = 1
    pet[index][pet_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET] = T{}
    pet[index][pet_name][DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET][DB.Metric.TOTAL] = damage_two

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_TP_MOVE_PET] = T{}
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.TOTAL] = damage_two
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MIN] = damage_two
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.MAX] = damage_two
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Trackable.DEF_TP_MOVE_PET][DB.Metric.ATTEMPTS] = 1

    local battle_log = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = tostring(damage + damage_two),
        action = action_name,
        note   = "TGTs: 2",
    }

    local misc = T{}
    misc["Total Damage"] = 0
    misc["Total Damage No Skillchain"] = 0

    return Debug.Unit.Check_Result("Defense - TP Pet AOE Secondary", player, player_catalog, pet, pet_catalog, battle_log, misc)
end