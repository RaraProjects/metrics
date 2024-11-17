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
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_EVASION] = T{}
    player[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_PARRY] = T{}
    player[index][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player[index][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_THIRD_EYE_ANTICIPATION] = T{}
    player[index][DB.Enum.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_COUNTER] = T{}
    player[index][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_GUARD] = T{}
    player[index][DB.Enum.Trackable.DEF_GUARD][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_BLOCK] = T{}
    player[index][DB.Enum.Trackable.DEF_BLOCK][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_CRIT] = T{}
    player[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_UNMITIGATED] = T{}
    player[index][DB.Enum.Trackable.DEF_UNMITIGATED][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.DEF_UNMITIGATED][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Melee > Hit", player)
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
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_EVASION] = T{}
    player[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_CRIT] = T{}
    player[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - Melee > Miss", player)
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
    local damage = 0
    local primary = {animation = nil, reaction = nil, message = Ashita.Enum.Message.PARRY}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, nil, damage, primary)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player = T{}
    player[index] = T{}
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_EVASION] = T{}
    player[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_PARRY] = T{}
    player[index][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_CRIT] = T{}
    player[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - Melee > Parry", player)
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
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_EVASION] = T{}
    player[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_PARRY] = T{}
    player[index][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player[index][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_CRIT] = T{}
    player[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1

    local battle_log_data = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = "0",
        action = "Melee",
        note   = " ",
    }

    return Debug.Unit.Check_Result("Defense - Melee > Shadows", player, nil, nil, nil, battle_log_data)
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
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_EVASION] = T{}
    player[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_PARRY] = T{}
    player[index][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player[index][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_THIRD_EYE_ANTICIPATION] = T{}
    player[index][DB.Enum.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_CRIT] = T{}
    player[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - Melee > Third Eye", player)
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
    player[index][DB.Enum.Trackable.MELEE] = T{}
    player[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_EVASION] = T{}
    player[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_PARRY] = T{}
    player[index][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player[index][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_THIRD_EYE_ANTICIPATION] = T{}
    player[index][DB.Enum.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_COUNTER] = T{}
    player[index][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_CRIT] = T{}
    player[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.TOTAL] = T{}
    player[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Melee > Counter", player)
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
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_EVASION] = T{}
    player[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_PARRY] = T{}
    player[index][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player[index][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_THIRD_EYE_ANTICIPATION] = T{}
    player[index][DB.Enum.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_COUNTER] = T{}
    player[index][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_GUARD] = T{}
    player[index][DB.Enum.Trackable.DEF_GUARD][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.DEF_GUARD][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_GUARD][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_CRIT] = T{}
    player[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Melee > Guard", player)
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
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_EVASION] = T{}
    player[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_PARRY] = T{}
    player[index][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player[index][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_THIRD_EYE_ANTICIPATION] = T{}
    player[index][DB.Enum.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_COUNTER] = T{}
    player[index][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_GUARD] = T{}
    player[index][DB.Enum.Trackable.DEF_GUARD][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_BLOCK] = T{}
    player[index][DB.Enum.Trackable.DEF_BLOCK][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.DEF_BLOCK][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_BLOCK][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_CRIT] = T{}
    player[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Melee > Shield Block", player)
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
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_EVASION] = T{}
    player[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_PARRY] = T{}
    player[index][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player[index][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_THIRD_EYE_ANTICIPATION] = T{}
    player[index][DB.Enum.Trackable.DEF_THIRD_EYE_ANTICIPATION][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_COUNTER] = T{}
    player[index][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_GUARD] = T{}
    player[index][DB.Enum.Trackable.DEF_GUARD][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_BLOCK] = T{}
    player[index][DB.Enum.Trackable.DEF_BLOCK][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_CRIT] = T{}
    player[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DEF_UNMITIGATED] = T{}
    player[index][DB.Enum.Trackable.DEF_UNMITIGATED][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.DEF_UNMITIGATED][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Melee > Crit", player)
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
    player[index][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    player[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN] = T{}
    pet[index][pet_name][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    pet[index][pet_name][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    pet[index][pet_name][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    pet[index][pet_name][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Melee > Pet Hit", player, nil, pet)
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
    player[index][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN] = T{}
    pet[index][pet_name][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - Melee > Pet Miss", player, nil, pet)
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
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - Nuke", player, player_catalog)
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
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage
    player[index_two] = T{}
    player[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN] = T{}
    player[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    player[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    player[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index_two][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player[index_two][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage_two

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_catalog[index_two] = T{}
    player_catalog[index_two][action_name] = T{}
    player_catalog[index_two][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN] = T{}
    player_catalog[index_two][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    player_catalog[index_two][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    player_catalog[index_two][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player_catalog[index_two][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index_two][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - Nuke AOE", player, player_catalog)
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
    player[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    player[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN] = T{}
    pet[index][pet_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    pet[index][pet_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    pet[index][pet_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    pet[index][pet_name][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - Nuke Pet", player, player_catalog, pet, pet_catalog)
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
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage_two
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    player[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN] = T{}
    pet[index][pet_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    pet[index][pet_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    pet[index][pet_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    pet[index][pet_name][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - Nuke Pet AOE Primary", player, player_catalog, pet, pet_catalog)
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
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    player[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    player[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    player[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage_two

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN] = T{}
    pet[index][pet_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    pet[index][pet_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    pet[index][pet_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    pet[index][pet_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    pet[index][pet_name][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage_two

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - Nuke Pet AOE Secondary", player, player_catalog, pet, pet_catalog)
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
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - TP", player, player_catalog)
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
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage
    player[index_two] = T{}
    player[index_two][DB.Enum.Trackable.TP_DMG_TAKEN] = T{}
    player[index_two][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    player[index_two][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    player[index_two][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player[index_two][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index_two][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index_two][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player[index_two][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage_two

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_catalog[index_two] = T{}
    player_catalog[index_two][action_name] = T{}
    player_catalog[index_two][action_name][DB.Enum.Trackable.TP_DMG_TAKEN] = T{}
    player_catalog[index_two][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    player_catalog[index_two][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    player_catalog[index_two][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player_catalog[index_two][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index_two][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - TP AOE", player, player_catalog)
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
    player[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    player[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    pet[index][pet_name][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - TP Pet", player, player_catalog, pet, pet_catalog)
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
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage_two
    player[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    player[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    pet[index][pet_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    pet[index][pet_name][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - TP Pet AOE Primary", player, player_catalog, pet, pet_catalog)
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
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN] = T{}
    player[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    player[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    player[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage
    player[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    player[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage_two

    local player_catalog = T{}
    player_catalog[index] = T{}
    player_catalog[index][action_name] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN] = T{}
    player_catalog[index][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    player_catalog[index][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    player_catalog[index][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player_catalog[index][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_catalog[index][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    local pet = T{}
    pet[index] = T{}
    pet[index][pet_name] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN] = T{}
    pet[index][pet_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    pet[index][pet_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    pet[index][pet_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    pet[index][pet_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    pet[index][pet_name][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    pet[index][pet_name][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage_two

    local pet_catalog = T{}
    pet_catalog[index] = T{}
    pet_catalog[index][pet_name] = T{}
    pet_catalog[index][pet_name][action_name] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN] = T{}
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet_catalog[index][pet_name][action_name][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - TP Pet AOE Secondary", player, player_catalog, pet, pet_catalog)
end