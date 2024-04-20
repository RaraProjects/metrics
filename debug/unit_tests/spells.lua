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

-- Magic Burst