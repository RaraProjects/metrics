H.TP_Def = {}

------------------------------------------------------------------------------------------------------
-- Parse the finish monster TP move packet.
-- BST Pet and Puppet ranged attacks fall into this category.
-- Trust abilities can show up here too. They don't have an owner.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param owner_mob? table (if pet) the mob data of the entity's owner.
---@param log_defense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.TP_Def.Monster_Action = function(action, actor_mob, owner_mob, log_defense)
    if not log_defense then return false end

    local skill_data = H.TP.Pet_Skill_Data(action.param, actor_mob)
    if not skill_data then return nil end
    local skill_name = skill_data.en
    local action_id  = skill_data.id

    -- Mob ranged attacks come in as TP moves. Jump to Ranged Defense if that happens.
    if skill_name and skill_name == "Ranged Attack" then
        H.Ranged_Def.Action(action, actor_mob, owner_mob, log_defense)
        return nil
    end

    local result, target_mob
    local damage = 0
    local target_damage = 0
    local count  = 0
    local is_target_hit = false
    local is_target_no_damage = false
    local is_use_no_damage = true
    local is_use_hit = false
    local trackable = DB.Trackable.DEF_TP_MOVE_PET

    -- Mob AOEs can hit pets. Need to check for all the target owner mobs because they may not be the original target.
    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target_mob = Ashita.Mob.GetMobByID(action.targets[target_index].id)
            if target_mob and (Ashita.Party.IsAffiliate(target_mob.name) or Ashita.Mob.PetOwner(target_mob) or Parse.Config.Is_Lurking()) then
                if Ashita.Mob.IsMonster(actor_mob) then DB.Lists.Check.Mob_Exists(actor_mob.name) end

                -- Need to recheck for AOEs.
                owner_mob = Ashita.Mob.PetOwner(target_mob)
                if not owner_mob then trackable = DB.Trackable.DEF_TP_MOVE end

                -- Target Counts
                count = count + 1

                -- Parse the target.
                target_damage, is_target_hit, is_target_no_damage = H.TP_Def.Weaponskill_Parse(result, actor_mob, target_mob, skill_name, action_id, owner_mob)
                damage = damage + target_damage

                -- If the ability is an AOE, if any of the hits are not "no damage" (like a miss) then the use level becomes a hit.
                if not is_target_no_damage then is_use_no_damage = false end
                if is_target_hit then is_use_hit = true end
            end
        end
    end

    -- Counts
    local audits = H.TP_Def.Audits(actor_mob, owner_mob, target_mob)
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS_ON_USE)
    DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, skill_name, DB.Metric.ATTEMPTS_ON_USE)

    if is_use_hit then
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.HITS_ON_USE)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, skill_name, DB.Metric.HITS_ON_USE)
    end

    -- Battle Log
    H.TP_Def.Blog(actor_mob, damage, skill_name, count, is_use_no_damage)

    return true
end

------------------------------------------------------------------------------------------------------
-- Parse the packet where a mob buffs themselves with a self-targeting buff.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
------------------------------------------------------------------------------------------------------
H.TP_Def.Mob_Self_Target = function(action, actor_mob)
    local skill_data = H.TP.Pet_Skill_Data(action.param, actor_mob)
    if not skill_data then return nil end
    H.TP_Def.Blog(actor_mob, 0, skill_data.en, 1, true)
end

------------------------------------------------------------------------------------------------------
-- Set data for a weaponskill action.
-- AOE weaponskills will go through this one time for each mob hit.
------------------------------------------------------------------------------------------------------
---@param result table contains all the information for the action.
---@param actor_mob table name of the player that did the action.
---@param target_mob table name of the target that received the action.
---@param ws_name string name of the weaponskill that was used.
---@param ws_id number ID of the ability that was used. Right now this is used to check monster abilities.
---@param owner_mob? table if the action was from a pet then this will hold the owner's mob.
---@return number
---@return boolean
---@return boolean
------------------------------------------------------------------------------------------------------
H.TP_Def.Weaponskill_Parse = function(result, actor_mob, target_mob, ws_name, ws_id, owner_mob)
    Debug.Packet.Add_Action(actor_mob.name, target_mob.name, "TP Def", result)
    local damage     = result.param
    local message_id = result.message
    local audits = H.TP_Def.Audits(actor_mob, owner_mob, target_mob)
    local hit = false
    local is_no_damage = false

    -- Check damage mitigation first. If mitigated, the damage is set to zero for the counts, blog, etc.
    damage, hit, is_no_damage = H.TP_Def.Damage_Mitigation(audits, damage, message_id, ws_name, owner_mob)

    -- The mob drains the player's MP.
    if H.Message_MP_Drain(message_id) then
        H.Offense.Catalog_No_Damage_Hit(audits, audits.trackable, ws_name)
        H.Offense.Catalog_Hit(audits, DB.Trackable.DEF_MP_DRAIN, damage, ws_name)

    -- The mob drains the player's TP.
    elseif H.Message_TP_Drain(message_id) then

    -- The mob dispels the player.
    elseif H.Message_Dispel(message_id) then
        is_no_damage = true

    -- The mob debuffs the player.
    elseif H.Message_Debuff(message_id) then
        H.Offense.Catalog_No_Damage_Hit(audits, audits.trackable, ws_name)
        is_no_damage = true

    -- The mob's attack deals damage. This also includes HP drained from the player.
    elseif H.Message_Damaging(message_id) or H.Message_HP_Drain(message_id) then
        H.Defense.Grand_Totals(audits, damage, owner_mob)
        H.Offense.Catalog_Hit(audits, audits.trackable, damage, ws_name)
        if not owner_mob then H.Offense.Hit(audits, DB.Trackable.DEF_UNMITIGATED_TP_ACTION, damage) end
        if H.Message_HP_Drain(message_id) then H.Offense.Catalog_Hit(audits, DB.Trackable.DEF_MP_DRAIN, damage, ws_name) end

    -- Just for information gathering purposes.
    else
        Debug.Error.Add(Debug.Error.WARNING, "H.TP_Def.Weaponskill_Parse",
        "BENIGN: Ability {" .. tostring(ws_name) .. "} (" .. tostring(ws_id) .. ") has message {" .. tostring(message_id) .. "}.")
    end

    return damage, hit, is_no_damage
end

------------------------------------------------------------------------------------------------------
-- Checks for damage mitigation like evasion or shadows.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param damage integer
---@param message_id integer
---@param ws_name string
---@param owner_mob? table
---@return integer
---@return boolean
---@return boolean
------------------------------------------------------------------------------------------------------
H.TP_Def.Damage_Mitigation = function(audits, damage, message_id, ws_name, owner_mob)
    local miss   = false
    local shadow = false

    -- Mob misses the player.
    if H.Message_No_Damage_Miss(message_id) then
        H.Defense.Grand_Totals(audits, 0, owner_mob)
        H.Offense.Catalog_Hit(audits, audits.trackable, 0, ws_name)
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.DEF_EVASION_TP_ACTION, DB.Metric.HITS_ON_TARGET)
        damage = 0
        miss   = true

    -- Player's shadow absorbs the ability.
    elseif H.Message_No_Damage_Hit(message_id) then
        H.Defense.Grand_Totals(audits, 0, owner_mob)
        H.Offense.Catalog_No_Damage_Hit(audits, audits.trackable, ws_name)
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.DEF_SHADOWS_TP_ACTION, DB.Metric.HITS_ON_TARGET)
        damage = 0
        shadow = true
    end

    -- Set attempts. Not tracking mitigation for pets.
    if not owner_mob then
        if miss then
            DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.DEF_EVASION_TP_ACTION, DB.Metric.ATTEMPTS_ON_TARGET)
        else
            DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.DEF_EVASION_TP_ACTION, DB.Metric.ATTEMPTS_ON_TARGET)
            DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.DEF_SHADOWS_TP_ACTION, DB.Metric.ATTEMPTS_ON_TARGET)
        end
    end

    return damage, not miss, miss or shadow
end

-- ------------------------------------------------------------------------------------------------------
-- Adds mob TP damage to the battle log.
-- ------------------------------------------------------------------------------------------------------
---@param actor_mob table
---@param damage integer
---@param skill_name string
---@param target_count integer
---@param is_no_damage boolean
-- ------------------------------------------------------------------------------------------------------
H.TP_Def.Blog = function(actor_mob, damage, skill_name, target_count, is_no_damage)
    local note = nil
    if target_count > 1 then note = "TGTs: " .. tostring(target_count) end

    -- Flag non damaging abilities to have "---" for damage.
    if is_no_damage then damage = -1 end

    Blog.Add(actor_mob.name, nil, Blog.Action_Type.MOB_TP, skill_name, damage, note)
end

-- ------------------------------------------------------------------------------------------------------
-- Set audit information for pet skills.
-- ------------------------------------------------------------------------------------------------------
---@param actor_mob table
---@param owner_mob table|nil
---@param target_mob table
---@return table
-- ------------------------------------------------------------------------------------------------------
H.TP_Def.Audits = function(actor_mob, owner_mob, target_mob)
    local player_name = actor_mob.name
    local target_name = target_mob.name
    local pet_name = nil
    local trackable = DB.Trackable.DEF_TP_MOVE

    if owner_mob then
        pet_name = target_mob.name
        target_name = owner_mob.name
        trackable = DB.Trackable.DEF_TP_MOVE_PET
    end

    -- These are switched compared to offense.
    local audits = {
        player_name = target_name,
        target_name = player_name,
        pet_name = pet_name,
        trackable = trackable
    }

    return audits
end
