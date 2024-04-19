_Debug.Unit.Tests.Ranged = {}

------------------------------------------------------------------------------------------------------
-- Test: Ranged Hit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Ranged.Hit = function()
    local clicked = 0
    if UI.Button("Ranged Hit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action = _Debug.Unit.Util.Build_Action(nil, _Debug.Unit.Mob.Target_ID, damage, nil, A.Enum.Message.RANGEHIT)
            H.Ranged.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Ranged Square Hit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Ranged.Square = function()
    local clicked = 0
    if UI.Button("Ranged Square Hit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action = _Debug.Unit.Util.Build_Action(nil, _Debug.Unit.Mob.Target_ID, damage, nil, A.Enum.Message.SQUARE)
            H.Ranged.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Ranged Truestrike Hit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Ranged.Truestrike = function()
    local clicked = 0
    if UI.Button("Ranged Truestrike Hit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action = _Debug.Unit.Util.Build_Action(nil, _Debug.Unit.Mob.Target_ID, damage, nil, A.Enum.Message.TRUE)
            H.Ranged.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Ranged Miss.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Ranged.Miss = function()
    local clicked = 0
    if UI.Button("Ranged Miss") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action = _Debug.Unit.Util.Build_Action(nil, _Debug.Unit.Mob.Target_ID, damage, nil, A.Enum.Message.RANGEMISS)
            H.Ranged.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Ranged Crit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Ranged.Crit = function()
    local clicked = 0
    if UI.Button("Ranged Crit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action = _Debug.Unit.Util.Build_Action(nil, _Debug.Unit.Mob.Target_ID, damage, nil, A.Enum.Message.RANGECRIT)
            H.Ranged.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Ranged PUP.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Ranged.PUP = function()
    local clicked = 0
    if UI.Button("Ranged PUP") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action = _Debug.Unit.Util.Build_Action(nil, _Debug.Unit.Mob.Target_ID, damage, nil, A.Enum.Message.RANGEPUP)
            H.Ranged.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Ranged Shadows.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Ranged.Shadows = function()
    local clicked = 0
    if UI.Button("Ranged Shadows") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action = _Debug.Unit.Util.Build_Action(nil, _Debug.Unit.Mob.Target_ID, damage, nil, A.Enum.Message.SHADOWS)
            H.Ranged.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end