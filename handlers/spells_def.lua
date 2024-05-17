H.Spell_Def = T{}

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

    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target_mob = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if not target_mob then target_mob = {name = DB.Enum.Values.DEBUG} end
            if target_mob.spawn_flags == Ashita.Enum.Spawn_Flags.MOB then DB.Lists.Check.Mob_Exists(actor_mob.name) end

            new_damage = H.Spell_Def.Parse(spell_data, result, actor_mob, target_mob, owner_mob)
            if not new_damage then new_damage = 0 end

            target_count = target_count + 1
            damage = damage + new_damage
        end
    end

    local audits = H.Spell_Def.Audits(actor_mob, target_mob, owner_mob)
    if Res.Spells.Get_Damaging(spell_id) then
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, H.Trackable.SPELL_DMG_TAKEN, spell_name, H.Metric.COUNT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, H.Trackable.SPELL_DMG_TAKEN, spell_name, H.Metric.HIT_COUNT)
    else
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, H.Trackable.DEF_NO_DMG_SPELLS, spell_name, H.Metric.COUNT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, H.Trackable.DEF_NO_DMG_SPELLS, spell_name, H.Metric.HIT_COUNT)
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
    _Debug.Packet.Add_Action(actor_mob.name, target_mob.name, "Spell Def", result)
    if not spell_data then return 0 end

    local spell_id = spell_data.Index
    local spell_name = Ashita.Spell.Name(spell_id, spell_data)
    local is_mapped = false
    local damage = result.param or 0
    local audits = H.Spell_Def.Audits(actor_mob, target_mob, owner_mob)

    if Res.Spells.Get_Damaging(spell_id) then
        H.Spell_Def.Nuke(audits, damage, spell_name)
        is_mapped = true
    end

    if Res.Spells.Get_MP_Drain(spell_id) then
        H.Spell_Def.MP_Drain(audits, damage)
        is_mapped = true
    end

    if Res.Spells.Get_Enfeeble(spell_id) then
        H.Spell_Def.Enfeebling(audits)
        is_mapped = true
    end

    if not is_mapped then
        _Debug.Error.Add("Spell_Def.Parse: {" .. tostring(actor_mob.name) .. "} spell " .. tostring(spell_id) .. " named " .. tostring(spell_name) .. " is unhandled.")
    end

    return damage
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

------------------------------------------------------------------------------------------------------
-- Handles spells that damage enemies.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param damage number
---@param spell_name string
------------------------------------------------------------------------------------------------------
H.Spell_Def.Nuke = function(audits, damage, spell_name)
    if audits.pet_name then
        DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.SPELL_PET_DMG_TAKEN, H.Metric.TOTAL)
    else
        DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.DAMAGE_TAKEN_TOTAL, H.Metric.TOTAL)
        DB.Catalog.Update_Damage(audits.player_name, audits.target_name, H.Trackable.SPELL_DMG_TAKEN, damage, spell_name, audits.pet_name)
    end
end

------------------------------------------------------------------------------------------------------
-- Handles spells that drain MP. The drain doesn't get used towards the damage total.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param damage number
------------------------------------------------------------------------------------------------------
H.Spell_Def.MP_Drain = function(audits, damage)
    if not audits.pet_name then
        DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.DEF_MP_DRAIN, H.Metric.TOTAL)
    end
end

------------------------------------------------------------------------------------------------------
-- Handles resist rates of enfeebling spells.
------------------------------------------------------------------------------------------------------
---@param audits table
------------------------------------------------------------------------------------------------------
H.Spell_Def.Enfeebling = function(audits)
    if not audits.pet_name then
        DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.DEF_ENFEEBLE, H.Metric.COUNT) -- Used to flag that data is availabel for show in Focus.
    end
end