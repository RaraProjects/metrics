Debug.Unit.Tests.TP_Action = {}

------------------------------------------------------------------------------------------------------
-- TP > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Hit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 156 -- Tachi: Fudo
    local tp = Ashita.Party.Refresh(player_name, Ashita.Enum.Player_Attributes.TP)
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.WS] = T{}
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Metric.TP_SPENT] = tp
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"] = T{}
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.TP_SPENT] = tp
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("TP - Weaponskill > Hit", player_database)
end

------------------------------------------------------------------------------------------------------
-- TP > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Miss = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local action_id = 156 -- Tachi: Fudo
    local tp = Ashita.Party.Refresh(player_name, Ashita.Enum.Player_Attributes.TP)
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.WS] = T{}
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Metric.TP_SPENT] = tp
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"] = T{}
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.TP_SPENT] = tp

    return Debug.Unit.Check_Result("TP - Weaponskill > Miss", player_database)
end

------------------------------------------------------------------------------------------------------
-- Melee - TP > Energy Steal
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Energy_Steal = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 21   -- Energy Steal
    local tp = Ashita.Party.Refresh(player_name, Ashita.Enum.Player_Attributes.TP)
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.WS] = T{}
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Metric.TP_SPENT] = tp
    player_database[index][DB.Enum.Trackable.MP_DRAIN] = T{}
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Energy Steal"] = T{}
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Energy Steal"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Energy Steal"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Energy Steal"][DB.Enum.Metric.TP_SPENT] = tp
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Energy Steal"] = T{}
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Energy Steal"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Energy Steal"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.MP_DRAIN][DB.Enum.Values.CATALOG]["Energy Steal"][DB.Enum.Metric.MAX] = damage

    return Debug.Unit.Check_Result("TP - Weaponskill > Energy Steal", player_database)
end

------------------------------------------------------------------------------------------------------
-- TP > Skillchain
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Skillchain = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 156   -- Tachi: Fudo
    local tp = Ashita.Party.Refresh(player_name, Ashita.Enum.Player_Attributes.TP)
    local sc_id = 288       -- Light
    local sc_damage = 200
    local add_effect = {param = sc_damage, animation = nil, message = sc_id}
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage, nil, add_effect)
    H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.WS] = T{}
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Metric.TP_SPENT] = tp
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"] = T{}
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.WS][DB.Enum.Values.CATALOG]["Tachi: Fudo"][DB.Enum.Metric.TP_SPENT] = tp

    player_database[index][DB.Enum.Trackable.SC] = T{}
    player_database[index][DB.Enum.Trackable.SC][DB.Enum.Metric.TOTAL] = sc_damage
    player_database[index][DB.Enum.Trackable.SC][DB.Enum.Metric.MIN] = sc_damage
    player_database[index][DB.Enum.Trackable.SC][DB.Enum.Metric.MAX] = sc_damage
    player_database[index][DB.Enum.Trackable.SC][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.SC][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.SC][DB.Enum.Metric.SC_OPENED] = 1
    player_database[index][DB.Enum.Trackable.SC][DB.Enum.Metric.SC_CLOSED] = 1
    player_database[index][DB.Enum.Trackable.SC][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.SC][DB.Enum.Values.CATALOG]["Light"] = T{}
    player_database[index][DB.Enum.Trackable.SC][DB.Enum.Values.CATALOG]["Light"][DB.Enum.Metric.TOTAL] = sc_damage
    player_database[index][DB.Enum.Trackable.SC][DB.Enum.Values.CATALOG]["Light"][DB.Enum.Metric.MIN] = sc_damage
    player_database[index][DB.Enum.Trackable.SC][DB.Enum.Values.CATALOG]["Light"][DB.Enum.Metric.MAX] = sc_damage
    player_database[index][DB.Enum.Trackable.SC][DB.Enum.Values.CATALOG]["Light"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.SC][DB.Enum.Values.CATALOG]["Light"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.SC][DB.Enum.Values.CATALOG]["Light"][DB.Enum.Metric.SC_OPENED] = 1
    player_database[index][DB.Enum.Trackable.SC][DB.Enum.Values.CATALOG]["Light"][DB.Enum.Metric.SC_CLOSED] = 1

    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage + sc_damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("TP - Weaponskill > Skillchain", player_database)
end

------------------------------------------------------------------------------------------------------
-- Pet TP > Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Pet_Hit = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local pet = Debug.Unit.Mob.PET.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 100
    local action_id = 262   -- Sheep Charge
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.TP.Monster_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.PET_WS] = T{}
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"] = T{}
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET] = T{}
    player_database[index][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_WS] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.TOTAL] = T{}
    pet_database[index][pet][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    pet_database[index][pet][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage

    return Debug.Unit.Check_Result("TP - Pet > Hit", player_database, pet_database)
end

------------------------------------------------------------------------------------------------------
-- Pet TP > Miss
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Pet_Miss = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local pet = Debug.Unit.Mob.PET.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local action_id = 262   -- Sheep Charge
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.TP.Monster_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.PET_WS] = T{}
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"] = T{}
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.COUNT] = 1

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_WS] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Charge"][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("TP - Pet > Miss", player_database, pet_database)
end

------------------------------------------------------------------------------------------------------
-- Pet TP > AOE Hit
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Pet_Hit_AOE = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local pet = Debug.Unit.Mob.PET.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local index_two = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY_TWO.name
    local damage = 100
    local damage_two = 200
    local action_id = 273   -- Claw Cyclone
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage, nil, nil, nil, Debug.Unit.Mob.Target_ID_Two, damage_two)
    Debug.Unit.Has_Pet = true
    H.TP.Monster_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    -- AOE counts are calculated outside of the target loop so only the second target has them documented.
    -- This could be a problem only if the second mob has a different name and a mob filter is used.
    -- But if I counted it for the first mob too then damage could be double counted when there is no mob filter used and the mobs have different names.
    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.PET_WS] = T{}
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"] = T{}
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MIN] = damage
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MAX] = damage
    player_database[index][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage
    player_database[index][DB.Enum.Trackable.PET] = T{}
    player_database[index][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage

    player_database[index_two] = T{}
    player_database[index_two][DB.Enum.Trackable.PET_WS] = T{}
    player_database[index_two][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index_two][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MIN] = damage_two
    player_database[index_two][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MAX] = damage_two
    player_database[index_two][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG] = T{}
    player_database[index_two][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"] = T{}
    player_database[index_two][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index_two][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MIN] = damage_two
    player_database[index_two][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MAX] = damage_two
    player_database[index_two][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.HIT_COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.COUNT] = 1
    player_database[index_two][DB.Enum.Trackable.TOTAL] = T{}
    player_database[index_two][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index_two][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    player_database[index_two][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage_two
    player_database[index_two][DB.Enum.Trackable.PET] = T{}
    player_database[index_two][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage_two

    -- AOE counts are calculated outside of the target loop so only the second target has them documented.
    -- This could be a problem only if the second mob has a different name and a mob filter is used.
    -- But if I counted it for the first mob too then damage could be double counted when there is no mob filter used and the mobs have different names.
    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_WS] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MIN] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MAX] = damage
    pet_database[index][pet][DB.Enum.Trackable.TOTAL] = T{}
    pet_database[index][pet][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    pet_database[index][pet][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage
    pet_database[index][pet][DB.Enum.Trackable.PET] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage

    -- In this case, a catalog minimum for Claw Cyclone isn't set because the first mob already set the minimum to 100. Retrieving catalog minimums searches
    -- everything. This could be a problem if the mob filter is used on the second mob because it's minimum hasn't been set yet.
    pet_database[index_two] = T{}
    pet_database[index_two][pet] = T{}
    pet_database[index_two][pet][DB.Enum.Trackable.PET_WS] = T{}
    pet_database[index_two][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.TOTAL] = damage_two
    pet_database[index_two][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MIN] = damage_two
    pet_database[index_two][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.MAX] = damage_two
    pet_database[index_two][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index_two][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.COUNT] = 1
    pet_database[index_two][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG] = T{}
    pet_database[index_two][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"] = T{}
    pet_database[index_two][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.TOTAL] = damage_two
    pet_database[index_two][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MIN] = damage_two
    pet_database[index_two][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.MAX] = damage_two
    pet_database[index_two][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.HIT_COUNT] = 1
    pet_database[index_two][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Claw Cyclone"][DB.Enum.Metric.COUNT] = 1
    pet_database[index_two][pet][DB.Enum.Trackable.TOTAL] = T{}
    pet_database[index_two][pet][DB.Enum.Trackable.TOTAL][DB.Enum.Metric.TOTAL] = damage_two
    pet_database[index_two][pet][DB.Enum.Trackable.TOTAL_NO_SC] = T{}
    pet_database[index_two][pet][DB.Enum.Trackable.TOTAL_NO_SC][DB.Enum.Metric.TOTAL] = damage_two
    pet_database[index_two][pet][DB.Enum.Trackable.PET] = T{}
    pet_database[index_two][pet][DB.Enum.Trackable.PET][DB.Enum.Metric.TOTAL] = damage_two

    return Debug.Unit.Check_Result("TP - Pet > AOE Hit", player_database, pet_database)
end

------------------------------------------------------------------------------------------------------
-- Pet TP > No Damage
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.TP_Action.Pet_No_Damage = function()
    DB.Initialize(true)
    local player_name = Debug.Unit.Mob.PLAYER.name
    local pet = Debug.Unit.Mob.PET.name
    local index = tostring(player_name) .. ":" .. Debug.Unit.Mob.ENEMY.name
    local damage = 0
    local action_id = 264   -- Sheep Song
    local action = Debug.Unit.Util.Build_Action(Debug.Unit.Mob.Target_ID, action_id, damage)
    Debug.Unit.Has_Pet = true
    H.TP.Monster_Action(action, Debug.Unit.Mob.PET, true)
    Debug.Unit.Has_Pet = false

    local player_database = T{}
    player_database[index] = T{}
    player_database[index][DB.Enum.Trackable.PET_WS] = T{}
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.COUNT] = 1
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG] = T{}
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Song"] = T{}
    player_database[index][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Song"][DB.Enum.Metric.COUNT] = 1

    local pet_database = T{}
    pet_database[index] = T{}
    pet_database[index][pet] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_WS] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Metric.COUNT] = 1
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Song"] = T{}
    pet_database[index][pet][DB.Enum.Trackable.PET_WS][DB.Enum.Values.CATALOG]["Sheep Song"][DB.Enum.Metric.COUNT] = 1

    return Debug.Unit.Check_Result("TP - Pet > No Damage", player_database, pet_database)
end