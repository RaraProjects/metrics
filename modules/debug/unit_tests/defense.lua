Debug.Unit.Tests.Defense = {}

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Hit = function()
    DB.Initialize(true)
    local damage = 100
    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    local action = Debug.Unit.Util.Build_Action(nil, player.id_num, damage, nil, Ashita.Enum.Message.HIT)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player_name = player.name
    local player_database = T{}
    player_database[tostring(player_name) .. ":Enemy"] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_EVASION] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_PARRY] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_COUNTER] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_GUARD] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_GUARD][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_BLOCK] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_BLOCK][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_CRIT] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_UNMITIGATED] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_UNMITIGATED][DB.Enum.Metric.TOTAL] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_UNMITIGATED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Melee > Hit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Miss = function()
    DB.Initialize(true)
    local damage = 0
    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    local action = Debug.Unit.Util.Build_Action(nil, player.id_num, damage, nil, Ashita.Enum.Message.MISS)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player_name = player.name
    local player_database = T{}
    player_database[tostring(player_name) .. ":Enemy"] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_EVASION] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_CRIT] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - Melee > Miss", player_database)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Parry
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Parry = function()
    DB.Initialize(true)
    local damage = 0
    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    local action = Debug.Unit.Util.Build_Action(nil, player.id_num, damage, nil, Ashita.Enum.Message.PARRY)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player_name = player.name
    local player_database = T{}
    player_database[tostring(player_name) .. ":Enemy"] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_EVASION] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_PARRY] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_CRIT] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - Melee > Parry", player_database)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Shadows
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Shadows = function()
    DB.Initialize(true)
    local damage = 0
    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    local action = Debug.Unit.Util.Build_Action(nil, player.id_num, damage, nil, Ashita.Enum.Message.SHADOWS)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player_name = player.name
    local player_database = T{}
    player_database[tostring(player_name) .. ":Enemy"] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_EVASION] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_PARRY] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_CRIT] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("Defense - Melee > Shadows", player_database)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Counter (Player countering the mob)
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Counter = function()
    DB.Initialize(true)
    local damage = 100
    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    local action = Debug.Unit.Util.Build_Action(nil, player.id_num, 0, nil, nil, nil, nil, nil, damage, Ashita.Enum.Message.COUNTER)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player_name = player.name
    local player_database = T{}
    player_database[tostring(player_name) .. ":Enemy"] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE][DB.Enum.Metric.TOTAL] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_EVASION] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_PARRY] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_COUNTER] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.TOTAL] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_CRIT] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TOTAL] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Melee > Counter", player_database)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Guard
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Guard = function()
    DB.Initialize(true)
    local damage = 100
    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    local action = Debug.Unit.Util.Build_Action(nil, player.id_num, damage, nil, Ashita.Enum.Message.HIT, nil, nil, nil, nil, nil, Ashita.Enum.Reaction.GUARD)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player_name = player.name
    local player_database = T{}
    player_database[tostring(player_name) .. ":Enemy"] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_EVASION] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_PARRY] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_COUNTER] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_GUARD] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_GUARD][DB.Enum.Metric.TOTAL] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_GUARD][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_GUARD][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_CRIT] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Melee > Guard", player_database)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Shield Block
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Shield = function()
    DB.Initialize(true)
    local damage = 100
    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    local action = Debug.Unit.Util.Build_Action(nil, player.id_num, damage, nil, Ashita.Enum.Message.HIT, nil, nil, nil, nil, nil, Ashita.Enum.Reaction.SHIELD_BLOCK)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player_name = player.name
    local player_database = T{}
    player_database[tostring(player_name) .. ":Enemy"] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_EVASION] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_PARRY] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_COUNTER] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_GUARD] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_GUARD][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_BLOCK] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_BLOCK][DB.Enum.Metric.TOTAL] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_BLOCK][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_BLOCK][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_CRIT] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Melee > Shield Block", player_database)
end

------------------------------------------------------------------------------------------------------
-- Defense - Melee > Crit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Melee_Crit = function()
    DB.Initialize(true)
    local damage = 100
    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    local action = Debug.Unit.Util.Build_Action(nil, player.id_num, damage, nil, Ashita.Enum.Message.CRIT)
    H.Melee_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player_name = player.name
    local player_database = T{}
    player_database[tostring(player_name) .. ":Enemy"] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.MELEE_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_EVASION] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_EVASION][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_PARRY] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_PARRY][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_SHADOWS] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_SHADOWS][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_COUNTER] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_COUNTER][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_GUARD] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_GUARD][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_BLOCK] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_BLOCK][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_CRIT] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.TOTAL] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_CRIT][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_UNMITIGATED] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_UNMITIGATED][DB.Enum.Metric.TOTAL] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DEF_UNMITIGATED][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Melee > Crit", player_database)
end

------------------------------------------------------------------------------------------------------
-- Defense - Spell
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Spell = function()
    DB.Initialize(true)
    local damage = 100
    local action_id = 145   -- Fire II
    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    local action = Debug.Unit.Util.Build_Action(action_id, player.id_num, damage)
    H.Spell_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player_name = player.name
    local player_database = T{}
    player_database[tostring(player_name) .. ":Enemy"] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.TOTAL] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MIN] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.MAX] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Fire II"][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Defense - Spell", player_database)
end

------------------------------------------------------------------------------------------------------
-- Defense - Nuke AOE
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.Nuke_AOE = function()
    DB.Initialize(true)
    local damage = 100
    local damage_two = 200
    local action_id = 174 -- Firaga
    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    local action = Debug.Unit.Util.Build_Action(action_id, player.id_num, damage, nil, nil, nil, nil, damage_two)
    H.Spell_Def.Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player_name = player.name
    local player_database = T{}
    player_database[tostring(player_name) .. ":Enemy"] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage + damage_two
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.TOTAL] = damage + damage_two
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MIN] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.MAX] = damage_two
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.SPELL_DMG_TAKEN][DB.Enum.Values.CATALOG]["Firaga"][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage + damage_two

    return Debug.Unit.Check_Result("Defense - Defense - Nuke AOE", player_database)
end

------------------------------------------------------------------------------------------------------
-- Defense - TP
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.TP = function()
    DB.Initialize(true)
    local damage = 100
    local action_id = 262   -- Sheep Charge
    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    local action = Debug.Unit.Util.Build_Action(action_id, player.id_num, damage)
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    local player_name = player.name
    local player_database = T{}
    player_database[tostring(player_name) .. ":Enemy"] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.TOTAL] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MIN] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MAX] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.COUNT] = 1
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("Defense - Defense - TP", player_database)
end

------------------------------------------------------------------------------------------------------
-- Defense - TP AOE
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Defense.TP_AOE = function()
    DB.Initialize(true)
    local damage = 100
    local damage_two = 200
    local action_id = 273   -- Claw Cyclone
    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    local action = Debug.Unit.Util.Build_Action(action_id, player.id_num, damage, nil, nil, nil, nil, damage_two)
    H.TP_Def.Monster_Action(action, Debug.Unit.Mob.ENEMY, nil, true)

    -- Hit counts and attempts are two because the same player is being hit twice.
    local player_name = player.name
    local player_database = T{}
    player_database[tostring(player_name) .. ":Enemy"] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.TOTAL] = damage + damage_two
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MIN] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.MAX] = damage_two
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.HIT_COUNT] = 2
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Metric.COUNT] = 2
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.TOTAL] = damage + damage_two
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MIN] = damage
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MAX] = damage_two
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.HIT_COUNT] = 2
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.TP_DMG_TAKEN][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.COUNT] = 2
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL] = T{}
    player_database[tostring(player_name) .. ":Enemy"][DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL][DB.Enum.Metric.TOTAL] = damage + damage_two

    return Debug.Unit.Check_Result("Defense - Defense - TP AOE", player_database)
end