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
    Blog.Add(actor_mob.name, nil, Blog.Action_Type.RANGED, DB.Trackable.RANGED_OVERALL, damage)
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
    local damage     = result.param
    local message_id = result.message
    local no_damage  = H.No_Damage_Messages(result)

    -- Need special handling for pets
    local player_name = actor_mob.name
    local ranged_type = DB.Trackable.RANGED_OVERALL
    local pet_name

    if owner_mob then
        ranged_type = DB.Trackable.PET_RANGED_OVERALL
        pet_name    = player_name
        player_name = owner_mob.name
    end

    local audits = {
        player_name = player_name,
        target_name = target_mob.name,
        pet_name    = pet_name,
    }

    local was_critical_hit = H.Ranged.Message(audits, damage, message_id, ranged_type, owner_mob)

    -- Avoid setting any damage data if the shot missed or healed a mob or something.
    if not no_damage then
        H.Offense.Grand_Totals(audits, damage, owner_mob)
        H.Offense.Min_Max(audits, ranged_type, damage, was_critical_hit)
    end

    -- This has its own damage separate from the intiial ranged shot.
    damage = damage + H.Ranged.Additional_Effect(audits, result)

    -- Shot Distance
    H.Ranged.Distance(audits, actor_mob, target_mob, ranged_type)

    -- Flag for the battle log.
    if no_damage then damage = -1 end

    return damage
end

------------------------------------------------------------------------------------------------------
-- Handle the various metrics based on message.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param message_id number numberic identifier for system chat messages.
---@param overall_ranged_type string player ranged or melee ranged.
---@param owner_mob? table
---@return boolean
------------------------------------------------------------------------------------------------------
H.Ranged.Message = function(audits, damage, message_id, overall_ranged_type, owner_mob)
    local was_critical_hit = false

    if message_id == Ashita.Enum.Message.RANGEHIT then
        H.Offense.Hit(audits, overall_ranged_type, damage)
        H.Offense.Miss(audits, DB.Trackable.RANGED_SQUARE_HIT)
        H.Offense.Miss(audits, DB.Trackable.RANGED_TRUE_STRIKE)
        H.Offense.Update_Recent_Accuracy(audits, true, owner_mob)

    elseif message_id == Ashita.Enum.Message.RANGEMISS then
        H.Offense.Miss(audits, overall_ranged_type)
        H.Offense.Miss(audits, DB.Trackable.RANGED_SQUARE_HIT)
        H.Offense.Miss(audits, DB.Trackable.RANGED_TRUE_STRIKE)
        H.Offense.Update_Recent_Accuracy(audits, false, owner_mob)

    elseif message_id == Ashita.Enum.Message.SQUARE then
        H.Offense.Hit(audits, overall_ranged_type, damage)
        H.Offense.Hit(audits, DB.Trackable.RANGED_SQUARE_HIT, damage)
        H.Offense.Miss(audits, DB.Trackable.RANGED_TRUE_STRIKE)
        H.Offense.Update_Recent_Accuracy(audits, true, owner_mob)

    elseif message_id == Ashita.Enum.Message.TRUE then
        H.Offense.Hit(audits, overall_ranged_type, damage)
        H.Offense.Hit(audits, DB.Trackable.RANGED_TRUE_STRIKE, damage)
        H.Offense.Miss(audits, DB.Trackable.RANGED_SQUARE_HIT)
        H.Offense.Update_Recent_Accuracy(audits, true, owner_mob)

    -- Critical hits will not negatively impact true strike or square hit rates.
    elseif message_id == Ashita.Enum.Message.RANGECRIT then
        was_critical_hit = true
        H.Offense.Hit(audits, overall_ranged_type, damage, true)
        H.Offense.Update_Recent_Accuracy(audits, true, owner_mob)

    -- Shadows have no impact on recent accuracy.
    elseif message_id == Ashita.Enum.Message.SHADOWS then
        H.Offense.No_Damage_Hit(audits, overall_ranged_type, DB.Metric.SHADOW_ABSORPTION)

    -- PUP ranged hits will not negatively impact true strike or square hit rates.
    elseif message_id == Ashita.Enum.Message.WEAPONSKILL_DAMAGE then
        H.Offense.Hit(audits, overall_ranged_type, damage)
        H.Offense.Update_Recent_Accuracy(audits, true, owner_mob)

    else
        Debug.Error.Add(Debug.Error.ERROR, "H.Ranged.Message", "Player {" .. tostring(audits.player_name) .. "} had unhandled ranged message: {"
        .. tostring(message_id) .. "}.")
    end

    return was_critical_hit
end

------------------------------------------------------------------------------------------------------
-- Catalog's ranged attack additional effects.
-- Additional elemental effects are treated as magic damage.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param result table
---@return integer
------------------------------------------------------------------------------------------------------
H.Ranged.Additional_Effect = function(audits, result)
    if not result then return 0 end
    local additional_damage = 0

    if result.has_add_effect then
        local message_id   = result.add_effect_message
        local animation_id = result.add_effect_animation
        local param        = result.add_effect_param   -- This is either damage or the type of debuff applied.

        -- Additional elemental damage from ammunition.
        if message_id == Ashita.Enum.Message.ENDAMAGE then
            if animation_id then
                local effect_name = Res.Game.Get_Additional_Effect_Animation(animation_id)
                additional_damage = param
                H.Offense.Hit(audits, DB.Trackable.SPELLS_OVERALL, additional_damage)
                H.Offense.Catalog_Hit(audits, DB.Trackable.RANGED_ENDAMAGE, additional_damage, effect_name)
            end

        -- Debuff effect from ammunition.
        elseif message_id == Ashita.Enum.Message.ENDEBUFF then
            local buff = Res.Buffs.Get_Buff(param)
            if buff then H.Offense.Catalog_No_Damage_Hit(audits, DB.Trackable.RANGED_ENDEBUFF, buff.en) end

        -- Additional damage from bloody bolts.
        elseif message_id == Ashita.Enum.Message.ENDRAIN then
            additional_damage = param
            H.Offense.Grand_Totals(audits, param)                       -- Bloody Bolt is net additional damage.
            H.Offense.Hit(audits, DB.Trackable.SPELLS_OVERALL, param)   -- Bloody Bolt is net additional damage.
            H.Offense.Hit(audits, DB.Trackable.RANGED_ENDRAIN, param)

        -- Not sure if aspir bolts exist, but have this just in case.
        elseif message_id == Ashita.Enum.Message.ENASPIR then
            H.Offense.Hit(audits, DB.Trackable.RANGED_ENASPIR, param)
        end

    end

    return additional_damage
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
    DB.Data.Update(DB.Update_Mode.INC, distance, audits, ranged_type, DB.Metric.SHOT_DISTANCE)
end