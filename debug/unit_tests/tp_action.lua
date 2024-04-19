_Debug.Unit.Tests.TP_Action = {}

------------------------------------------------------------------------------------------------------
-- Test: Weaponskill Hit. 1000 damage.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.TP_Action.WS_Hit_1000 = function()
    local clicked = 0
    if UI.Button("WS Hit 1K") then
        clicked = 1
        if clicked and 1 then
            local damage = 1000
            local action_id = 156 -- Tachi: Fudo
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, nil, nil, nil, 0)
            H.TP.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Weaponskill Hit. 2000 damage.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.TP_Action.WS_Hit_2000 = function()
    local clicked = 0
    if UI.Button("WS Hit 2K") then
        clicked = 1
        if clicked and 1 then
            local damage = 2000
            local action_id = 156 -- Tachi: Fudo
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, nil, nil, nil, 0)
            H.TP.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Weaponskill Miss.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.TP_Action.WS_Miss = function()
    local clicked = 0
    if UI.Button("WS Miss") then
        clicked = 1
        if clicked and 1 then
            local damage = 0
            local action_id = 156 -- Tachi: Fudo
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, nil, nil, nil, 0)
            H.TP.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Skillchain. 1000 damage.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.TP_Action.SC_1000 = function()
    local clicked = 0
    if UI.Button("Skillchain 1K") then
        clicked = 1
        if clicked and 1 then
            local damage = 1000
            local action_id = 156   -- Tachi: Fudo
            local sc_id = 288       -- Light
            local sc_damage = 1000
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, nil, nil, sc_damage, sc_id)
            H.TP.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Skillchain. 1000 damage.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.TP_Action.SC_2000 = function()
    local clicked = 0
    if UI.Button("Skillchain 2K") then
        clicked = 1
        if clicked and 1 then
            local damage = 1000
            local action_id = 156   -- Tachi: Fudo
            local sc_id = 288       -- Light
            local sc_damage = 2000
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, nil, nil, sc_damage, sc_id)
            H.TP.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Pet TP Move Hit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.TP_Action.Pet_Hit = function()
    local clicked = 0
    if UI.Button("Pet Hit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 262   -- Sheep Charge
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage)
            H.TP.Monster_Action(action, _Debug.Unit.Mob.PET, true)
        end
    end
end