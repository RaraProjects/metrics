H.Unblinkable = { }

------------------------------------------------------------------------------------------------------
-- Parse the weaponskill packet.
-- Surprises:
-- 1. Some abilities--like DRG Jumps--oddly show up in this packet.
------------------------------------------------------------------------------------------------------
---@param action     table action packet data.
---@param actorMob   table the mob data of the entity performing the action.
---@param logOffense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.Unblinkable.Action = function(action, actorMob, logOffense)
    if not logOffense then
        return nil
    end

    H.Ability.Action(action, actorMob, logOffense)
end