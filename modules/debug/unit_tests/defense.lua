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

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_EVASION] = T{}
    player_database[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_PARRY] = T{}
    player_database[index][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player_database[index][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_COUNTER] = T{}
    player_database[index][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_GUARD] = T{}
    player_database[index][DB.Enum.Trackable.DEF_GUARD][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_BLOCK] = T{}
    player_database[index][DB.Enum.Trackable.DEF_BLOCK][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_CRIT] = T{}
    player_database[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_UNMITIGATED] = T{}
    player_database[index][DB.Enum.Trackable.DEF_UNMITIGATED][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.DEF_UNMITIGATED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Melee > Hit", player_database)
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

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_EVASION] = T{}
    player_database[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_CRIT] = T{}
    player_database[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - Melee > Miss", player_database)
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

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_EVASION] = T{}
    player_database[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_PARRY] = T{}
    player_database[index][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_CRIT] = T{}
    player_database[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - Melee > Parry", player_database)
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

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_EVASION] = T{}
    player_database[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_PARRY] = T{}
    player_database[index][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player_database[index][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_CRIT] = T{}
    player_database[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1

    local battle_log_data = T{
        player = Debug.Unit.Mob.ENEMY.name,
        pet    = Blog.Enum.Text.NO_PET,
        damage = "0",
        action = "Melee",
        note   = " ",
    }

    return Debug.Unit.Check_Result("Defense - Melee > Shadows", player_database, nil, battle_log_data)
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

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE] = T{}
    player_database[index][DB.Enum.Trackable.MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_EVASION] = T{}
    player_database[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_PARRY] = T{}
    player_database[index][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player_database[index][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_COUNTER] = T{}
    player_database[index][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_CRIT] = T{}
    player_database[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Melee > Counter", player_database)
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

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_EVASION] = T{}
    player_database[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_PARRY] = T{}
    player_database[index][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player_database[index][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_COUNTER] = T{}
    player_database[index][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_GUARD] = T{}
    player_database[index][DB.Enum.Trackable.DEF_GUARD][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.DEF_GUARD][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_GUARD][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_CRIT] = T{}
    player_database[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Melee > Guard", player_database)
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

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_EVASION] = T{}
    player_database[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_PARRY] = T{}
    player_database[index][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player_database[index][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_COUNTER] = T{}
    player_database[index][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_GUARD] = T{}
    player_database[index][DB.Enum.Trackable.DEF_GUARD][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_BLOCK] = T{}
    player_database[index][DB.Enum.Trackable.DEF_BLOCK][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.DEF_BLOCK][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_BLOCK][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_CRIT] = T{}
    player_database[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Melee > Shield Block", player_database)
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

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_EVASION] = T{}
    player_database[index][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_PARRY] = T{}
    player_database[index][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player_database[index][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_COUNTER] = T{}
    player_database[index][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_GUARD] = T{}
    player_database[index][DB.Enum.Trackable.DEF_GUARD][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_BLOCK] = T{}
    player_database[index][DB.Enum.Trackable.DEF_BLOCK][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_CRIT] = T{}
    player_database[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DEF_UNMITIGATED] = T{}
    player_database[index][DB.Enum.Trackable.DEF_UNMITIGATED][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.DEF_UNMITIGATED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Melee > Crit", player_database)
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
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.HIT}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PET.id, nil, damage, primary)
    Debug.Unit.Has_Pet = true
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, Debug.Unit.Mob.PLAYER, true)
    Debug.Unit.Has_Pet = false

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    player_database[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN] = T{}
    pet_database[index][pet][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    pet_database[index][pet][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Melee > Pet Hit", player_database, pet_database)
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
    local pet = Debug.Unit.Mob.PET.name
    local damage = 0
    local primary = {animation = 0, reaction = nil, message = Ashita.Enum.Message.MISS}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PET.id, nil, damage, primary)
    Debug.Unit.Has_Pet = true
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, Debug.Unit.Mob.PLAYER, true)
    Debug.Unit.Has_Pet = false

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN] = T{}
    pet_database[index][pet][DB.Enum.Trackable.MELEE_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - Melee > Pet Miss", player_database, pet_database)
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
    local action_id = 145   -- Fire II
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage)
    H.Spell_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Nuke", player_database)
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
    local action_id = 174 -- Firaga
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage, nil, nil, nil, Debug.Unit.Mob.PLAYER_TWO.id, damage_two)
    H.Spell_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    player_database[index_two] = T{}
    player_database[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN] = T{}
    player_database[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    player_database[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player_database[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"] = T{}
    player_database[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MIN] = damage_two
    player_database[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MAX] = damage_two
    player_database[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[index_two][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage_two

    return Debug.Unit.Check_Result("Defense - Nuke AOE", player_database)
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
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 145   -- Fire II
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PET.id, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.Spell_Def.Action(action, Debug.Unit.Mob.ENEMY, Debug.Unit.Mob.PLAYER, true)
    Debug.Unit.Has_Pet = false

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    player_database[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN] = T{}
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"] = T{}
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    pet_database[index][pet][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Nuke Pet", player_database, pet_database)
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
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local damage_two = 200
    local action_id = 174 -- Firaga
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PET.id, action_id, damage, nil, nil, nil, Debug.Unit.Mob.PLAYER.id, damage_two)
    Debug.Unit.Has_Pet = true
    H.Spell_Def.Action(action, Debug.Unit.Mob.ENEMY, Debug.Unit.Mob.PLAYER, true)
    Debug.Unit.Has_Pet = false

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MIN] = damage_two
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MAX] = damage_two
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    player_database[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN] = T{}
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"] = T{}
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    pet_database[index][pet][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Nuke Pet AOE Primary", player_database, pet_database)
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
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local damage_two = 200
    local action_id = 174 -- Firaga
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id, action_id, damage, nil, nil, nil, Debug.Unit.Mob.PET.id, damage_two)
    Debug.Unit.Has_Pet = true
    H.Spell_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)
    Debug.Unit.Has_Pet = false

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"] = T{}
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MIN] = damage_two
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MAX] = damage_two
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    player_database[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage_two

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN] = T{}
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"] = T{}
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.TOTAL] = damage_two
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MIN] = damage_two
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MAX] = damage_two
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.SPELL_PET_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    pet_database[index][pet][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage_two

    return Debug.Unit.Check_Result("Defense - Nuke Pet AOE Secondary", player_database, pet_database)
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
    local action_id = 262   -- Sheep Charge
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage)
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"] = T{}
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - TP", player_database)
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
    local action_id = 273   -- Claw Cyclone
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage, nil, nil, nil, Debug.Unit.Mob.PLAYER_TWO.id, damage_two)
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"] = T{}
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    player_database[index_two] = T{}
    player_database[index_two][DB.Enum.Trackable.TP_DMG_TAKEN] = T{}
    player_database[index_two][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index_two][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    player_database[index_two][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player_database[index_two][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[index_two][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"] = T{}
    player_database[index_two][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index_two][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MIN] = damage_two
    player_database[index_two][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MAX] = damage_two
    player_database[index_two][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[index_two][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage_two

    return Debug.Unit.Check_Result("Defense - TP AOE", player_database)
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
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local action_id = 262   -- Sheep Charge
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PET.id, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, Debug.Unit.Mob.PLAYER, true)
    Debug.Unit.Has_Pet = false

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"] = T{}
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    player_database[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    pet_database[index][pet][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - TP Pet", player_database, pet_database)
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
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local damage_two = 200
    local action_id = 273   -- Claw Cyclone
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PET.id, action_id, damage, nil, nil, nil, Debug.Unit.Mob.PLAYER.id_num, damage_two)
    Debug.Unit.Has_Pet = true
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, Debug.Unit.Mob.PLAYER, true)
    Debug.Unit.Has_Pet = false

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"] = T{}
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MIN] = damage_two
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MAX] = damage_two
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"] = T{}
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    player_database[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    pet_database[index][pet][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - TP Pet AOE Primary", player_database, pet_database)
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
    local pet = Debug.Unit.Mob.PET.name
    local damage = 100
    local damage_two = 200
    local action_id = 273   -- Claw Cyclone
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.PLAYER.id_num, action_id, damage, nil, nil, nil, Debug.Unit.Mob.PET.id, damage_two)
    Debug.Unit.Has_Pet = true
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, nil, true)
    Debug.Unit.Has_Pet = false

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"] = T{}
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN] = T{}
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"] = T{}
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MIN] = damage_two
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MAX] = damage_two
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    player_database[index][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage_two

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage_two
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage_two
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.TOTAL] = damage_two
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MIN] = damage_two
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MAX] = damage_two
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET] = T{}
    pet_database[index][pet][DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET][DB.Enum.Metric.TOTAL] = damage_two

    return Debug.Unit.Check_Result("Defense - TP Pet AOE Secondary", player_database, pet_database)
end