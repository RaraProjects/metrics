H.Ranged = {}

------------------------------------------------------------------------------------------------------
-- Parse the ranged attack packet.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param log_offense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.Ranged.Action = function(action, actor_mob, log_offense)
    if not log_offense then return nil end
    local result, target_mob
    local damage = 0

    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target_mob = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if target_mob then
                if Ashita.Mob.Is_Monster(target_mob) then DB.Lists.Check.Mob_Exists(target_mob.name) end
                damage = damage + H.Ranged.Parse(result, actor_mob, target_mob)
            end
        end
    end

    H.Ranged.Blog(actor_mob, damage)
end

-- ------------------------------------------------------------------------------------------------------
-- Adds ranged damage to the battle log.
-- ------------------------------------------------------------------------------------------------------
---@param actor_mob table the mob data of the entity performing the action.
---@param damage number
-- ------------------------------------------------------------------------------------------------------
H.Ranged.Blog = function(actor_mob, damage)
    Blog.Add(actor_mob.name, nil, Blog.Enum.Types.RANGED, H.Trackable.RANGED, damage)
end

------------------------------------------------------------------------------------------------------
-- Set data for a ranged attack action.
------------------------------------------------------------------------------------------------------
---@param result table contains all the information for the action.
---@param actor_mob table name of the player that did the action.
---@param target_mob table name of the target that received the action.
---@param owner_mob? table if the action was from a pet then this will hold the owner's mob.
---@return number
------------------------------------------------------------------------------------------------------
H.Ranged.Parse = function(result, actor_mob, target_mob, owner_mob)
    if not actor_mob or not target_mob then return 0 end

    Debug.Packet.Add_Action(actor_mob.name, target_mob.name, "Ranged", result)
    local damage = result.param
    local message_id = result.message

    -- Need special handling for pets
    local player_name = actor_mob.name
    local ranged_type = H.Trackable.RANGED
    if owner_mob then
        ranged_type = H.Trackable.PET_RANGED
        player_name = owner_mob.name
    end

    local audits = {
        player_name = player_name,
        target_name = target_mob.name,
    }

    H.Ranged.Totals(audits, damage, ranged_type)                    -- Totals
    H.Ranged.Pet_Total(owner_mob, audits, damage)                   -- Pet Totals
    H.Ranged.Message(message_id, audits, damage, ranged_type)       -- Accuracy and misc. traits.
    H.Ranged.Additional_Effect(audits, result)                      -- Additional Effects
    H.Ranged.Min_Max(damage, audits, ranged_type)                   -- Min/Max
    H.Ranged.Distance(audits, actor_mob, target_mob, ranged_type)   -- Shot Distance

    return damage
end

------------------------------------------------------------------------------------------------------
-- Increment Grand Totals.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param ranged_type string player ranged or melee ranged.
------------------------------------------------------------------------------------------------------
H.Ranged.Totals = function(audits, damage, ranged_type)
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.TOTAL,  H.Metric.TOTAL)
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.TOTAL_NO_SC, H.Metric.TOTAL)
    DB.Data.Update(H.Mode.INC,      1, audits, ranged_type, H.Metric.COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, H.Trackable.RANGED_SQUARE, H.Metric.COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, H.Trackable.RANGED_TRUE, H.Metric.COUNT)
end

------------------------------------------------------------------------------------------------------
-- Increment total pet damage.
------------------------------------------------------------------------------------------------------
---@param owner_mob table|nil if the action was from a pet then this will hold the owner's mob.
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
------------------------------------------------------------------------------------------------------
H.Ranged.Pet_Total = function(owner_mob, audits, damage)
    if owner_mob then
        DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.PET, H.Metric.TOTAL)
    end
end

------------------------------------------------------------------------------------------------------
-- Handle the various metrics based on message.
------------------------------------------------------------------------------------------------------
---@param message_id number numberic identifier for system chat messages.
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param ranged_type string player ranged or melee ranged.
------------------------------------------------------------------------------------------------------
H.Ranged.Message = function(message_id, audits, damage, ranged_type)
    if message_id == Ashita.Enum.Message.RANGEHIT then
        H.Ranged.Hit(audits, damage, ranged_type)
    elseif message_id == Ashita.Enum.Message.SQUARE then
        H.Ranged.Square(audits, damage, ranged_type)
    elseif message_id == Ashita.Enum.Message.TRUE then
        H.Ranged.Truestrike(audits, damage, ranged_type)
    elseif message_id == Ashita.Enum.Message.RANGECRIT then
        H.Ranged.Crit(audits, damage, ranged_type)
    elseif message_id == Ashita.Enum.Message.RANGEPUP then
        H.Ranged.PUP_Hit(audits, damage, ranged_type)
    elseif message_id == Ashita.Enum.Message.RANGEMISS then
        H.Ranged.Miss(audits, damage, ranged_type)
    elseif message_id == Ashita.Enum.Message.SHADOWS then
        H.Ranged.Shadows(audits, damage, ranged_type)
    else
        Debug.Error.Add("Ranged.Message: {" .. tostring(audits.player_name) .. "} Unhandled Ranged Message: " .. tostring(message_id))
    end
end

------------------------------------------------------------------------------------------------------
-- Regular ranged hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param ranged_type string player ranged or melee ranged.
------------------------------------------------------------------------------------------------------
H.Ranged.Hit = function(audits, damage, ranged_type)
    DB.Data.Update(H.Mode.INC,      1, audits, ranged_type, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC, damage, audits, ranged_type, H.Metric.TOTAL)
    DB.Accuracy.Update(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Regular ranged square hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param ranged_type string player ranged or melee ranged.
------------------------------------------------------------------------------------------------------
H.Ranged.Square = function(audits, damage, ranged_type)
    DB.Data.Update(H.Mode.INC,      1, audits, ranged_type, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC, damage, audits, ranged_type, H.Metric.TOTAL)
    DB.Data.Update(H.Mode.INC,      1, audits, H.Trackable.RANGED_SQUARE, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.RANGED_SQUARE, H.Metric.TOTAL)
    DB.Accuracy.Update(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Regular ranged truestrike hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param ranged_type string player ranged or melee ranged.
------------------------------------------------------------------------------------------------------
H.Ranged.Truestrike = function(audits, damage, ranged_type)
    DB.Data.Update(H.Mode.INC,      1, audits, ranged_type, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC, damage, audits, ranged_type, H.Metric.TOTAL)
    DB.Data.Update(H.Mode.INC,      1, audits, H.Trackable.RANGED_TRUE, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.RANGED_TRUE, H.Metric.TOTAL)
    DB.Accuracy.Update(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Regular ranged critical hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param ranged_type string player ranged or melee ranged.
------------------------------------------------------------------------------------------------------
H.Ranged.Crit = function(audits, damage, ranged_type)
    DB.Data.Update(H.Mode.INC,      1, audits, ranged_type, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, ranged_type, H.Metric.CRIT_COUNT)
    DB.Data.Update(H.Mode.INC, damage, audits, ranged_type, H.Metric.CRIT_DAMAGE)
    DB.Data.Update(H.Mode.INC, damage, audits, ranged_type, H.Metric.TOTAL)
    DB.Accuracy.Update(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Catalog's ranged attack additional effects.
-- Additional elemental effects are treated as magic damage.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param result table
------------------------------------------------------------------------------------------------------
H.Ranged.Additional_Effect = function(audits, result)
    if not result then return nil end
    if result.has_add_effect then
        local message_id = result.add_effect_message
        local animation_id = result.add_effect_animation
        local param = result.add_effect_param   -- This is either damage or the type of debuff applied.

        if message_id == Ashita.Enum.Message.ENDAMAGE then
            local effect_name = Res.Game.Get_Additional_Effect_Animation(animation_id)
            if animation_id then
                DB.Data.Update(H.Mode.INC, param, audits, H.Trackable.MAGIC,    H.Metric.TOTAL)
                DB.Data.Update(H.Mode.INC,     1, audits, H.Trackable.ENDAMAGE_R, H.Metric.HIT_COUNT)
                DB.Catalog.Update_Damage(audits.player_name, audits.target_name, H.Trackable.ENDAMAGE_R, param, effect_name)
                DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, H.Trackable.ENDAMAGE_R, effect_name, H.Metric.HIT_COUNT)
            end
        elseif message_id == Ashita.Enum.Message.ENDEBUFF then
            local buff = Res.Buffs.Get_Buff(param)
            if buff then
                DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.ENDEBUFF_R, H.Metric.HIT_COUNT)
                DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, H.Trackable.ENDEBUFF_R, buff.en, H.Metric.HIT_COUNT)
            end
        elseif message_id == Ashita.Enum.Message.ENDRAIN then
            DB.Data.Update(H.Mode.INC, param, audits, H.Trackable.MAGIC,       H.Metric.TOTAL)    -- Bloody Bolt is net additional damage.
            DB.Data.Update(H.Mode.INC, param, audits, H.Trackable.TOTAL,       H.Metric.TOTAL)    -- Bloody Bolt is net additional damage.
            DB.Data.Update(H.Mode.INC, param, audits, H.Trackable.TOTAL_NO_SC, H.Metric.TOTAL)    -- Bloody Bolt is net additional damage.
            DB.Data.Update(H.Mode.INC, param, audits, H.Trackable.ENDRAIN_R,   H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC, 1,     audits, H.Trackable.ENDRAIN_R,   H.Metric.HIT_COUNT)
        elseif message_id == Ashita.Enum.Message.ENASPIR then
            DB.Data.Update(H.Mode.INC, param, audits, H.Trackable.ENASPIR_R, H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC, 1,     audits, H.Trackable.ENASPIR_R, H.Metric.HIT_COUNT)
        end

    end
end

------------------------------------------------------------------------------------------------------
-- Puppet ranged hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param ranged_type string player ranged or melee ranged.
------------------------------------------------------------------------------------------------------
H.Ranged.PUP_Hit = function(audits, damage, ranged_type)
    DB.Data.Update(H.Mode.INC,      1, audits, ranged_type, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC, damage, audits, ranged_type, H.Metric.TOTAL)
    DB.Accuracy.Update(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Regular ranged miss.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param ranged_type string player ranged or melee ranged.
------------------------------------------------------------------------------------------------------
H.Ranged.Miss = function(audits, damage, ranged_type)
    DB.Accuracy.Update(audits.player_name, false)
    return damage
end

------------------------------------------------------------------------------------------------------
-- Regular ranged absorbed by shadows.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param ranged_type string player ranged or melee ranged.
------------------------------------------------------------------------------------------------------
H.Ranged.Shadows = function(audits, damage, ranged_type)
    DB.Data.Update(H.Mode.INC,      1, audits, ranged_type, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, ranged_type, H.Metric.SHADOWS)
    return damage
end

------------------------------------------------------------------------------------------------------
-- Minimum and maximum ranged values.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param ranged_type string player ranged or melee ranged.
------------------------------------------------------------------------------------------------------
H.Ranged.Min_Max = function(damage, audits, ranged_type)
    if damage > 0 and (damage < DB.Data.Get(audits.player_name, ranged_type, H.Metric.MIN)) then DB.Data.Update(H.Mode.SET, damage, audits, ranged_type, H.Metric.MIN) end
    if damage > DB.Data.Get(audits.player_name, ranged_type, H.Metric.MAX) then DB.Data.Update(H.Mode.SET, damage, audits, ranged_type, H.Metric.MAX) end
end

------------------------------------------------------------------------------------------------------
-- Gets the distance between the actor and target.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param actor_mob table
---@param target_mob table
---@param ranged_type string player ranged or melee ranged.
------------------------------------------------------------------------------------------------------
H.Ranged.Distance = function(audits, actor_mob, target_mob, ranged_type)
    if not actor_mob or not target_mob then return nil end
    local distance = Ashita.Mob.Distance(actor_mob, target_mob)
    if distance < 0 then return nil end
    if distance > 30 then distance = 30 end
    DB.Data.Update(H.Mode.INC, distance, audits, ranged_type, H.Metric.SHOT_DISTANCE)
end