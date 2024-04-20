_Debug.Unit.Tests.Spells = {}

------------------------------------------------------------------------------------------------------
-- Test: Spell Hit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Spells.Hit = function()
    local clicked = 0
    if UI.Button("Spell Hit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 145   -- Fire II
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage)
            H.Spell.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Magic Burst.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Spells.Burst = function()
    local clicked = 0
    if UI.Button("Magic Burst") then
        clicked = 1
        if clicked and 1 then
            local damage = 200
            local action_id = 145   -- Fire II
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, nil, A.Enum.Message.BURST)
            H.Spell.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Healing 100.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Spells.Cure_100 = function()
    local clicked = 0
    if UI.Button("Cure 100") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 3   -- Cure III
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage)
            H.Spell.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Healing 200.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Spells.Cure_200 = function()
    local clicked = 0
    if UI.Button("Cure 200") then
        clicked = 1
        if clicked and 1 then
            local damage = 200
            local action_id = 3   -- Cure III
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage)
            H.Spell.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Holy.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Spells.Holy = function()
    local clicked = 0
    if UI.Button("Holy") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 21 -- Holy
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage)
            H.Spell.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Damage over time. Zero damage.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Spells.DoT_0 = function()
    local clicked = 0
    if UI.Button("Bio 0") then
        clicked = 1
        if clicked and 1 then
            local damage = 0
            local action_id = 230 -- Bio
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage)
            H.Spell.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Damage over time. One damage.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Spells.DoT_1 = function()
    local clicked = 0
    if UI.Button("Bio 1") then
        clicked = 1
        if clicked and 1 then
            local damage = 1
            local action_id = 230 -- Bio
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage)
            H.Spell.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Aspir.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Spells.Aspir = function()
    local clicked = 0
    if UI.Button("Aspir") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 247 -- Aspir
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage)
            H.Spell.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Ga Spell.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Spells.Ga_Spell = function()
    local clicked = 0
    if UI.Button("Ga Spell") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local damage_two = 200
            local action_id = 174 -- Firaga
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, nil, nil, nil, nil, damage_two)
            H.Spell.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Curaga.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Spells.Curaga = function()
    local clicked = 0
    if UI.Button("Curaga") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local damage_two = 149
            local action_id = 7 -- Curaga
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, nil, nil, nil, nil, damage_two)
            H.Spell.Action(action, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end