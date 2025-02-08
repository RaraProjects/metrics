H.Spell_Def = {}

------------------------------------------------------------------------------------------------------
-- Parse the finish spell casting packet.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param owner_mob table|nil (if pet) the mob data of the entity's owner.
---@param log_defense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.Spell_Def.Action = function(action, actor_mob, owner_mob, log_defense)
    if not log_defense then return nil end

    local result, target_mob, new_damage
    local damage = 0
    local target_count = 0
    local spell_id = action.param
    local spell_data = Ashita.Spell.Get_By_ID(spell_id)
    if not spell_data then return nil end
    local spell_name = Ashita.Spell.Name(spell_id, spell_data)

    -- Loop through target actions.
    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target_mob = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if target_mob and (Ashita.Party.Is_Affiliate(target_mob.name) or Ashita.Mob.Pet_Owner(target_mob) or Parse.Config.Is_Lurking()) then
                if Ashita.Mob.Is_Monster(actor_mob) then DB.Lists.Check.Mob_Exists(actor_mob.name) end
                owner_mob = Ashita.Mob.Pet_Owner(target_mob)    -- Need to recheck for AOEs.
                new_damage = H.Spell_Def.Parse(spell_data, result, actor_mob, target_mob, owner_mob)
                if not new_damage then new_damage = 0 end
                target_count = target_count + 1
                damage = damage + new_damage
            end
        end
    end

    -- Update the Battle Log.
    if Res.Spells.Get_Damaging(spell_id) then
        H.Spell_Def.Blog(actor_mob, spell_id, spell_data, spell_name, damage, target_count)
    end
end

------------------------------------------------------------------------------------------------------
-- Set data for a spell action (including healing).
-- Not all spells do damage and not all spells heal this will sort those out.
------------------------------------------------------------------------------------------------------
---@param spell_data table the main packet; need it to get spell ID
---@param result table contains all the information for the action
---@param actor_mob table
---@param target_mob table
---@param owner_mob? table
---@return number
------------------------------------------------------------------------------------------------------
H.Spell_Def.Parse = function(spell_data, result, actor_mob, target_mob, owner_mob)
    Debug.Packet.Add_Action(actor_mob.name, target_mob.name, "Spell Def", result)
    if not spell_data then return 0 end

    -- Need to double check each target in case a pet gets hit by AOE and wasn't the primary target.
    if not owner_mob then owner_mob = Ashita.Mob.Pet_Owner(target_mob) end

    local spell_id   = spell_data.Index
    local spell_name = Ashita.Spell.Name(spell_id, spell_data)
    local damage     = result.param or 0
    local no_damage  = H.No_Damage_Messages(result)
    local message_id = result.message
    local audits = H.Spell_Def.Audits(actor_mob, target_mob, owner_mob)

    local tag = "H.Spell_Def.Parse"
    Debug.Error.Add(Debug.Error.WARNING, tag,
    "BENIGN: Spell {" .. tostring(spell_name) .. "} (" .. tostring(spell_id) .. ") has message {" .. tostring(message_id) .. "}.")

    if no_damage then damage = 0 end

    if Res.Spells.Get_Damaging(spell_id) then
        H.Spell_Def.Nuke(audits, damage, spell_name, owner_mob)
    else
        H.Offense.Catalog_No_Damage_Hit(audits, DB.Trackable.DEF_NO_DAMAGE_SPELLS, spell_name)
    end

    -- Not tracking these for pets right now.
    if not owner_mob then
        -- Full Mitigation; track unmitigated damage if it isn't absorbed by a shadow.
        local full = false
        if not full then full = H.Defense.Mitigation(audits, DB.Trackable.DEF_SHADOWS_MAGIC, damage, message_id, Ashita.Message.SHADOW_ABSORPTION, true) end
        if not full then H.Offense.Hit(audits, DB.Trackable.DEF_UNMITIGATED_MAGIC, damage) end

        if Res.Spells.Get_MP_Drain(spell_id) then H.Offense.Hit(audits, DB.Trackable.DEF_MP_DRAIN, damage) end
        if Res.Spells.Get_Enfeeble(spell_id) then H.Offense.Hit(audits, DB.Trackable.DEF_ENFEEBLING, damage) end
    end

    if no_damage then damage = -1 end

    return damage
end

------------------------------------------------------------------------------------------------------
-- Handles spells that damage enemies.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param damage number
---@param spell_name string
---@param owner_mob? table
------------------------------------------------------------------------------------------------------
H.Spell_Def.Nuke = function(audits, damage, spell_name, owner_mob)
    local trackable = DB.Trackable.DEF_NUKING
    if owner_mob then trackable = DB.Trackable.DEF_NUKING_PET end
    H.Defense.Grand_Totals(audits, damage, owner_mob)
    H.Offense.Catalog_Hit(audits, trackable, damage, spell_name)
end

-- ------------------------------------------------------------------------------------------------------
-- Adds spell damage taken to the battle log.
-- ------------------------------------------------------------------------------------------------------
---@param actor_mob table the mob data of the entity receiving the action.
---@param spell_id integer
---@param spell_data table
---@param spell_name string
---@param damage number
---@param target_count integer
-- ------------------------------------------------------------------------------------------------------
H.Spell_Def.Blog = function(actor_mob, spell_id, spell_data, spell_name, damage, target_count)
    local blog_note = ""
    if target_count > 1 then blog_note = "TGTs: " .. tostring(target_count) end
    Blog.Add(actor_mob.name, nil, Blog.Action_Type.MOB_SPELL, spell_name, damage, blog_note, spell_data)
end

------------------------------------------------------------------------------------------------------
-- Convenient function to build the audit table.
------------------------------------------------------------------------------------------------------
---@param actor_mob table
---@param target_mob table
---@param owner_mob? table this will not be nil if the actor is a pet.
---@return table
------------------------------------------------------------------------------------------------------
H.Spell_Def.Audits = function(actor_mob, target_mob, owner_mob)
    local player_name = actor_mob.name
    local target_name = target_mob.name
    local pet_name = nil

    if owner_mob then
        pet_name = target_mob.name
        target_name = owner_mob.name
    end

    -- These are switched compared to offense.
    local audits = {
        player_name = target_name,
        target_name = player_name,
        pet_name = pet_name,
    }

    return audits
end