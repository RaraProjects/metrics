_Debug.Unit.Tests.Melee = {}

------------------------------------------------------------------------------------------------------
-- Test: Melee Main-hand Hit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Main_Hit = function()
    local clicked = 0
    if UI.Button("Melee Main Hit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_MAIN, Ashita.Enum.Message.HIT)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Off-hand Hit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Off_Hand_Hit = function()
    local clicked = 0
    if UI.Button("Melee Offhand Hit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_OFFHAND, Ashita.Enum.Message.HIT)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Main-hand Miss.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Main_Miss = function()
    local clicked = 0
    if UI.Button("Melee Main Miss") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_MAIN, Ashita.Enum.Message.MISS)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Off-hand Miss.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Off_Hand_Miss = function()
    local clicked = 0
    if UI.Button("Melee Offhand Miss") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_OFFHAND, Ashita.Enum.Message.MISS)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Crit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Crit = function()
    local clicked = 0
    if UI.Button("Melee Crit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_MAIN, Ashita.Enum.Message.CRIT)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Enspell.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Enspell = function()
    local clicked = 0
    if UI.Button("Melee Enspell") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_MAIN, Ashita.Enum.Message.HIT, 100)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Shadows.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Shadows = function()
    local clicked = 0
    if UI.Button("Melee Shadows") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_MAIN, Ashita.Enum.Message.SHADOWS)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Mob Heal.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Mob_Heal = function()
    local clicked = 0
    if UI.Button("Melee Mob Heal") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_MAIN, Ashita.Enum.Message.MOBHEAL373)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Pet Hit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Pet_Hit = function()
    local clicked = 0
    if UI.Button("Melee Pet Hit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_MAIN, Ashita.Enum.Message.HIT)
            H.Melee.Action(action, _Debug.Unit.Mob.PET, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Pet Crit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Pet_Crit = function()
    local clicked = 0
    if UI.Button("Melee Pet Crit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_MAIN, Ashita.Enum.Message.CRIT)
            H.Melee.Action(action, _Debug.Unit.Mob.PET, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Pet Miss.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Pet_Miss = function()
    local clicked = 0
    if UI.Button("Melee Pet Miss") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_MAIN, Ashita.Enum.Message.MISS)
            H.Melee.Action(action, _Debug.Unit.Mob.PET, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Pet Shadows.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Pet_Shadows = function()
    local clicked = 0
    if UI.Button("Melee Pet Shadows") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_MAIN, Ashita.Enum.Message.SHADOWS)
            H.Melee.Action(action, _Debug.Unit.Mob.PET, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Pet Mob Heal.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Pet_Mob_Heal = function()
    local clicked = 0
    if UI.Button("Melee Pet Mob Heal") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_MAIN, Ashita.Enum.Message.MOBHEAL373)
            H.Melee.Action(action, _Debug.Unit.Mob.PET, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Daken Hit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Daken_Hit = function()
    local clicked = 0
    if UI.Button("Melee Daken Hit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.DAKEN, Ashita.Enum.Message.RANGEHIT)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Daken Square Hit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Daken_Square = function()
    local clicked = 0
    if UI.Button("Melee Daken Square") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.DAKEN, Ashita.Enum.Message.SQUARE)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Daken Truestrike Hit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Daken_Truestrike = function()
    local clicked = 0
    if UI.Button("Melee Daken True") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.DAKEN, Ashita.Enum.Message.TRUE)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Daken Miss.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Daken_Miss = function()
    local clicked = 0
    if UI.Button("Melee Daken Miss") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.DAKEN, Ashita.Enum.Message.MISS)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Daken Crit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Daken_Crit = function()
    local clicked = 0
    if UI.Button("Melee Daken Crit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.DAKEN, Ashita.Enum.Message.RANGECRIT)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Kick Hit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Kick_Hit = function()
    local clicked = 0
    if UI.Button("Melee Kick Hit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_KICK, Ashita.Enum.Message.HIT)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Kick Miss.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Kick_Miss = function()
    local clicked = 0
    if UI.Button("Melee Kick Miss") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_KICK, Ashita.Enum.Message.MISS)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Kick Crit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Kick_Crit = function()
    local clicked = 0
    if UI.Button("Melee Kick Crit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, Ashita.Enum.Animation.MELEE_KICK, Ashita.Enum.Message.CRIT)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end