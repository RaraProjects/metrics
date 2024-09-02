Debug.Unit.Tests.Ranged = {}

------------------------------------------------------------------------------------------------------
-- Test: Ranged Hit.
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Hit = function()
    local clicked = 0
    if UI.Button("Ranged Hit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, nil, Ashita.Enum.Message.RANGEHIT)
            H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Ranged Square Hit.
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Square = function()
    local clicked = 0
    if UI.Button("Ranged Square Hit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, nil, Ashita.Enum.Message.SQUARE)
            H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Ranged Truestrike Hit.
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Truestrike = function()
    local clicked = 0
    if UI.Button("Ranged Truestrike Hit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, nil, Ashita.Enum.Message.TRUE)
            H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Ranged Miss.
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Miss = function()
    local clicked = 0
    if UI.Button("Ranged Miss") then
        clicked = 1
        if clicked and 1 then
            local damage = 0
            local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, nil, Ashita.Enum.Message.RANGEMISS)
            H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Ranged Crit.
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Crit = function()
    local clicked = 0
    if UI.Button("Ranged Crit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, nil, Ashita.Enum.Message.RANGECRIT)
            H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Ranged PUP.
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.PUP = function()
    local clicked = 0
    if UI.Button("Ranged PUP") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, nil, Ashita.Enum.Message.RANGEPUP)
            H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Ranged Shadows.
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ranged.Shadows = function()
    local clicked = 0
    if UI.Button("Ranged Shadows") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action = Debug.Unit.Util.Build_Action(nil, Debug.Unit.Mob.Target_ID, damage, nil, Ashita.Enum.Message.SHADOWS)
            H.Ranged.Action(action, Debug.Unit.Mob.PLAYER, true)
        end
    end
end