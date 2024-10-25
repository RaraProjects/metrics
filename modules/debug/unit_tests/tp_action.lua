Debug.Unit.Tests.TP_Action = {}

------------------------------------------------------------------------------------------------------
-- TP > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Hit = function()
    DB.Initialize(true)
    local damage = 100
    local action_id = 156 -- Tachi: Fudo
    local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage, nil, nil, nil, 0)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.WS] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("TP - Weaponskill > Hit", player_database)
end

------------------------------------------------------------------------------------------------------
-- TP > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Miss = function()
    DB.Initialize(true)
    local damage = 0
    local action_id = 156 -- Tachi: Fudo
    local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage, nil, nil, nil, 0)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.WS] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("TP - Weaponskill > Miss", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - TP > Energy Steal
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Energy_Steal = function()
    DB.Initialize(true)
    local damage = 100
    local action_id = 21   -- Energy Steal
    local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage, nil, nil, nil, 0)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.WS] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Energy Steal"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Energy Steal"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Energy Steal"][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Energy Steal"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Energy Steal"][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Energy Steal"][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Energy Steal"][DB.Enum.Metric.MAX] = damage

    return Debug.Unit.Check_Result("TP - Weaponskill > Energy Steal", player_database)
end

------------------------------------------------------------------------------------------------------
-- TP > Skillchain
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Skillchain = function()
    DB.Initialize(true)
    local damage = 100
    local action_id = 156   -- Tachi: Fudo
    local sc_id = 288       -- Light
    local sc_damage = 200
    local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage, nil, nil, sc_damage, sc_id)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.WS] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.COUNT] = 1

    player_database["Player:Debug"][DB.Enum.Trackable.SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.SC][DB.Enum.Metric.TOTAL] = sc_damage
    player_database["Player:Debug"][DB.Enum.Trackable.SC][DB.Enum.Metric.MIN] = sc_damage
    player_database["Player:Debug"][DB.Enum.Trackable.SC][DB.Enum.Metric.MAX] = sc_damage
    player_database["Player:Debug"][DB.Enum.Trackable.SC][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.SC][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.SC][DB.Enum.Metric.SC_OPENED] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.SC][DB.Enum.Metric.SC_CLOSED] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.SC][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.SC][DB.Enum.Values.CATALOG]["Light"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.SC][DB.Enum.Values.CATALOG]["Light"][DB.Enum.Metric.TOTAL] = sc_damage
    player_database["Player:Debug"][DB.Enum.Trackable.SC][DB.Enum.Values.CATALOG]["Light"][DB.Enum.Metric.MIN] = sc_damage
    player_database["Player:Debug"][DB.Enum.Trackable.SC][DB.Enum.Values.CATALOG]["Light"][DB.Enum.Metric.MAX] = sc_damage
    player_database["Player:Debug"][DB.Enum.Trackable.SC][DB.Enum.Values.CATALOG]["Light"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.SC][DB.Enum.Values.CATALOG]["Light"][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.SC][DB.Enum.Values.CATALOG]["Light"][DB.Enum.Metric.SC_OPENED] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.SC][DB.Enum.Values.CATALOG]["Light"][DB.Enum.Metric.SC_CLOSED] = 1

    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage + sc_damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("TP - Weaponskill > Skillchain", player_database)
end

------------------------------------------------------------------------------------------------------
-- Pet TP > Single Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Pet_Hit_Single = function()
    DB.Initialize(true)
    local damage = 100
    local action_id = 262   -- Sheep Charge
    local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage)
    H.TP.Monster_Action(action, Debug.Unit.Mob.PET, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MAX] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage

    local pet_database = T{}
    pet_database["Player:Debug"] = T{}
    pet_database["Player:Debug"]["Pet Name"] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.TOTAL] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MIN] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MAX] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.COUNT] = 1
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.TOTAL] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MIN] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MAX] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.COUNT] = 1
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.TOTAL] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("TP - Pet > Single Hit", player_database, pet_database)
end

------------------------------------------------------------------------------------------------------
-- Pet TP > AOE Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Pet_Hit_AOE = function()
    DB.Initialize(true)
    local damage = 100
    local damage_two = 200
    local action_id = 262   -- Sheep Charge
    local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage, nil, nil, nil, nil, damage_two)
    H.TP.Monster_Action(action, Debug.Unit.Mob.PET, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.TOTAL] = damage + damage_two
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MAX] = damage_two
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.TOTAL] = damage + damage_two
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MIN] = damage
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MAX] = damage_two
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage + damage_two
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage + damage_two
    player_database["Player:Debug"][DB.Enum.Trackable.PET] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage + damage_two

    local pet_database = T{}
    pet_database["Player:Debug"] = T{}
    pet_database["Player:Debug"]["Pet Name"] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.TOTAL] = damage + damage_two
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MIN] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MAX] = damage_two
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.COUNT] = 1
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.TOTAL] = damage + damage_two
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MIN] = damage
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MAX] = damage_two
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.COUNT] = 1
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.TOTAL] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage + damage_two
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage + damage_two
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage + damage_two

    return Debug.Unit.Check_Result("TP - Pet > AOE Hit", player_database, pet_database)
end

------------------------------------------------------------------------------------------------------
-- Pet TP > Single Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Pet_Miss_Single = function()
    DB.Initialize(true)
    local damage = 0
    local action_id = 262   -- Sheep Charge
    local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage)
    H.TP.Monster_Action(action, Debug.Unit.Mob.PET, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.COUNT] = 1

    local pet_database = T{}
    pet_database["Player:Debug"] = T{}
    pet_database["Player:Debug"]["Pet Name"] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.COUNT] = 1
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("TP - Pet > Single Miss", player_database, pet_database)
end

------------------------------------------------------------------------------------------------------
-- Pet TP > Single Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Pet_No_Damage_Debuff = function()
    DB.Initialize(true)
    local damage = 0
    local action_id = 264   -- Sheep Song
    local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage)
    H.TP.Monster_Action(action, Debug.Unit.Mob.PET, true)

    local player_database = T{}
    player_database["Player:Debug"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.COUNT] = 1
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Song"] = T{}
    player_database["Player:Debug"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Song"][DB.Enum.Metric.COUNT] = 1

    local pet_database = T{}
    pet_database["Player:Debug"] = T{}
    pet_database["Player:Debug"]["Pet Name"] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.COUNT] = 1
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Song"] = T{}
    pet_database["Player:Debug"]["Pet Name"][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Song"][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("TP - Pet > No Damage Debuff", player_database, pet_database)
end