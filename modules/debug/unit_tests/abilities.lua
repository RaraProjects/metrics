Debug.Unit.Tests.Ability = {}

------------------------------------------------------------------------------------------------------
-- Test: Shield Bash.
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Shield_Bash = function()
    local clicked = 0
    if UI.Button("Shield Bash") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 46 -- Shield Bash
            local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage)
            H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Jump. Damage 100.
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Jump_100 = function()
    local clicked = 0
    if UI.Button("Jump 100") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 66 -- Jump
            local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage)
            H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Jump. Damage 200.
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Jump_200 = function()
    local clicked = 0
    if UI.Button("Jump 200") then
        clicked = 1
        if clicked and 1 then
            local damage = 200
            local action_id = 66 -- Jump
            local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage)
            H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Jump Miss.
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Jump_Miss = function()
    local clicked = 0
    if UI.Button("Jump Miss") then
        clicked = 1
        if clicked and 1 then
            local damage = 0
            local action_id = 66 -- Jump
            local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage)
            H.TP.Action(action, Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Holy Circle.
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Holy_Circle = function()
    local clicked = 0
    if UI.Button("Holy Circle") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 47 -- Holy Circle
            local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage)
            H.Ability.Action(action, Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Avatar Rage.
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Avatar_Rage = function()
    local clicked = 0
    if UI.Button("Flaming Crush") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 846 -- Flaming Crush
            local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage)
            H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Avatar Ward.
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Avatar_Ward = function()
    local clicked = 0
    if UI.Button("Earthen Ward") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 853 -- Earthen Ward
            local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage)
            H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Avatar Healing Ward.
------------------------------------------------------------------------------------------------------
Debug.Unit.Tests.Ability.Avatar_Healing_Ward = function()
    local clicked = 0
    if UI.Button("Healing Ruby") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 906 -- Healing Ruby
            local action = Debug.Unit.Util.Build_Action(action_id, Debug.Unit.Mob.Target_ID, damage)
            H.Ability.Pet_Action(action, Debug.Unit.Mob.PET, true)
        end
    end
end