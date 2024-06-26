H.Ability = {}

------------------------------------------------------------------------------------------------------
-- Parse the job ability casting packet.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param log_offense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.Ability.Action = function(action, actor_mob, log_offense)
    if not log_offense then return nil end

	-- Need to provide an offset to get to the abilities. Otherwise I get WS information.
	local ability_id = action.param + H.Enum.Offsets.ABILITY
    local ability_data = Ashita.Ability.Get_By_ID(ability_id)
    ability_data = H.Ability.Player_Missing_Ability_Check(ability_data, ability_id, actor_mob)

    local result, target_mob
    local damage = 0
    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target_mob = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if not target_mob then target_mob = {name = DB.Enum.Values.DEBUG} end
            if target_mob.spawn_flags == Ashita.Enum.Spawn_Flags.MOB then DB.Lists.Check.Mob_Exists(target_mob.name) end
            damage = damage + H.Ability.Parse(ability_data, result, actor_mob, target_mob.name)
        end
    end

    -- Log remaining action data.
    H.Ability.Player_Catalog_Count(actor_mob, target_mob, ability_data)
    H.Ability.Blog(actor_mob, ability_data, ability_id, damage)
end

------------------------------------------------------------------------------------------------------
-- Parse the pet ability packet.
-- SMN bloodpacts; DRG wyvern breaths
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param log_offense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.Ability.Pet_Action = function(action, actor_mob, log_offense)
    if not log_offense then return nil end

    -- Check to see if the pet belongs to anyone in the party.
    local owner_mob = Ashita.Mob.Pet_Owner(actor_mob)
    if not owner_mob then return nil end

    local ability_id = action.param
    local ability_data
    local avatar = false
    local trackable = H.Trackable.PET_ABILITY

    -- Handle offset for Blood Pacts. I don't know why they are all out of order.
    ability_data, avatar, trackable = H.Ability.Pet_Ability_Mapping(ability_id, trackable)

    -- Need special data handling since pulling from multiple sources.
    ability_data = H.Ability.Pet_Ability_Rectify(ability_data, ability_id, avatar, actor_mob)

    local result, target
    local damage = 0
    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if not target then target = {name = 'test'} end
            if target.spawn_flags == Ashita.Enum.Spawn_Flags.MOB then DB.Lists.Check.Mob_Exists(target.name) end
            damage = damage + H.Ability.Parse(ability_data, result, owner_mob, target.name, actor_mob)
        end
    end

    H.Ability.Pet_Count(actor_mob, owner_mob, target, ability_data, trackable, damage)
    H.Ability.Pet_Blog(actor_mob, owner_mob, ability_data, ability_id, damage)
end

------------------------------------------------------------------------------------------------------
-- Set data for an ability action.
-- This includes pet damage (since they are ability based).
-- Using an ability to cause a pet to attack gets captured here, but the actual data for the damage
-- done comes in a different packet. SMN comes in Pet_Ability and then routes back to here.
------------------------------------------------------------------------------------------------------
---@param ability_data table the main packet; need it to get ability ID
---@param result table contains all the information for the action.
---@param actor_mob table name of the player that did the action.
---@param target_name string name of the target that received the action.
---@param owner_mob? table if the action was from a pet then this will hold the owner's mob.
---@return number
------------------------------------------------------------------------------------------------------
H.Ability.Parse = function(ability_data, result, actor_mob, target_name, owner_mob)
    _Debug.Packet.Add_Action(actor_mob.name, target_name, "Ability", result)
    local player_name = actor_mob.name
    local ability_id = ability_data.Id
    local ability_name = ability_data.Name
    local damage = result.param
    local ability_type = H.Trackable.ABILITY

    local pet_name = nil
    if owner_mob then
        ability_type = H.Trackable.PET_ABILITY
        pet_name = owner_mob.name
    end

    local audits = H.Ability.Audits(player_name, target_name, pet_name)

    -- Specifics
    if owner_mob then
        if Res.Avatar.Get_Rage(ability_id) then
            H.Ability.Pet_Rage(audits, owner_mob, damage, ability_type, ability_name)
        elseif Res.Avatar.Get_Healing(ability_id) or Res.Pets.Get_Healing_Wyvern_Breath(ability_id) then
            ability_type = H.Ability.Pet_Healing(audits, owner_mob, damage, ability_name)
        elseif Res.Pets.Get_Damaging_Wyvern_Breath(ability_id) then
            H.Ability.Pet_Breath(audits, owner_mob, damage, ability_type, ability_name)
        end
    else
        if Res.Abilities.Get_Damaging(ability_id) then
            ability_type = H.Trackable.ABILITY_DAMAGING
            H.Ability.Catalog(audits, damage, ability_type, ability_name)
        elseif Res.Abilities.Get_Player_Healing(ability_id) or Res.Abilities.Get_Pet_Healing(ability_id) then
            ability_type = H.Trackable.ABILITY_HEALING
            H.Ability.Catalog(audits, damage, ability_type, ability_name)
            DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.ALL_HEAL, H.Metric.TOTAL)
        elseif Res.Abilities.Get_MP_Recovery(ability_id) then
            ability_type = H.Trackable.ABILITY_MP_RECOVERY
            H.Ability.Catalog(audits, damage, ability_type, ability_name)
        end
    end

    -- Set a flag to make this section show up in the Focus menu.
    DB.Data.Update(H.Mode.INC, 1, audits, ability_type, H.Metric.COUNT)

    return damage
end

------------------------------------------------------------------------------------------------------
-- Creates an audit table.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param target_name string
---@param pet_name? string
---@return table
------------------------------------------------------------------------------------------------------
H.Ability.Audits = function(player_name, target_name, pet_name)
    return {player_name = player_name, target_name = target_name, pet_name = pet_name}
end

------------------------------------------------------------------------------------------------------
-- Adds ability damage to the battle log.
------------------------------------------------------------------------------------------------------
---@param actor_mob table
---@param ability_data table
---@param ability_id number
---@param damage number
------------------------------------------------------------------------------------------------------
H.Ability.Blog = function(actor_mob, ability_data, ability_id, damage)
    if Res.Abilities.Get_Damaging(ability_id) or Res.Abilities.Get_MP_Recovery(ability_id) then
        local note = nil
        if ability_id == Res.Abilities.CHIVALRY then note = Ashita.Party.Refresh(actor_mob.name, Ashita.Enum.Player_Attributes.TP) end
        Blog.Add(actor_mob.name, Blog.Enum.Types.ABILITY, ability_data.Name, damage, note)
    end

    if Res.Abilities.Get_Player_Healing(ability_id) or Res.Abilities.Get_Pet_Healing(ability_id) then
        Blog.Add(actor_mob.name, Blog.Enum.Types.HEALING, ability_data.Name, damage)
    end
end

------------------------------------------------------------------------------------------------------
-- Adds pet ability damage to the battle log.
------------------------------------------------------------------------------------------------------
---@param actor_mob table
---@param owner_mob table
---@param ability_data table
---@param ability_id number
---@param damage number
------------------------------------------------------------------------------------------------------
H.Ability.Pet_Blog = function(actor_mob, owner_mob, ability_data, ability_id, damage)
    if damage > 0 then
        if Res.Avatar.Get_Rage(ability_id) or Res.Pets.Get_Damaging_Wyvern_Breath(ability_id) then
            Blog.Add(owner_mob.name .. " (" .. Column.String.Truncate(actor_mob.name, Blog.Settings.Truncate_Length) .. ")", Blog.Enum.Types.PET, ability_data.Name, damage)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Check for unaccounted for abilities.
------------------------------------------------------------------------------------------------------
---@param ability_data table
---@param ability_id number
---@param actor_mob table
---@return table
------------------------------------------------------------------------------------------------------
H.Ability.Player_Missing_Ability_Check = function(ability_data, ability_id, actor_mob)
    if not ability_data then
        _Debug.Error.Add("Ability.Player_Missing_Ability_Check: {" .. tostring(actor_mob.name) .. "} Data on ability ID " .. tostring(ability_id) .. " is unavailable.")
        ability_data = {Id = ability_id, Name = "UNK Ability (" .. ability_id .. ")"}
    else
        ability_data = {Id = ability_id, Name = Ashita.Ability.Name(ability_id, ability_data)}
    end
    return ability_data
end

------------------------------------------------------------------------------------------------------
-- Increment the use counter of the ability.
------------------------------------------------------------------------------------------------------
---@param actor_mob table
---@param target_mob table
---@param ability_data table
------------------------------------------------------------------------------------------------------
H.Ability.Player_Catalog_Count = function(actor_mob, target_mob, ability_data)
    local audits = H.Ability.Audits(actor_mob.name, target_mob.name)
    local trackable = H.Trackable.ABILITY

    if Res.Abilities.Get_Damaging(ability_data.Id) then
        trackable = H.Trackable.ABILITY_DAMAGING
    elseif Res.Abilities.Get_Player_Healing(ability_data.Id) or Res.Abilities.Get_Pet_Healing(ability_data.Id) then
        trackable = H.Trackable.ABILITY_HEALING
    elseif Res.Abilities.Get_MP_Recovery(ability_data.Id) then
        trackable = H.Trackable.ABILITY_MP_RECOVERY
    end

    DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, ability_data.Name, H.Metric.COUNT)
end

------------------------------------------------------------------------------------------------------
-- The ability IDs for avatars are a bit scrambled compared to Windower.
-- Also need to flag certain pet abilities as healing abilities or not.
------------------------------------------------------------------------------------------------------
---@param ability_id number
---@param trackable string
---@return table ability_data
---@return boolean avatar
---@return string trackable
------------------------------------------------------------------------------------------------------
H.Ability.Pet_Ability_Mapping = function(ability_id, trackable)
    local ability_data = {}
    local avatar = false
    if Res.Avatar.Get_Rage(ability_id) then
        ability_data = Res.Avatar.Get_Rage(ability_id)
        avatar = true
    elseif Res.Avatar.Get_Ward(ability_id) then
        ability_data = Res.Avatar.Get_Ward(ability_id)
        if Res.Avatar.Get_Healing(ability_id) then trackable = H.Trackable.PET_HEAL end
        avatar = true
    else
        ability_data = Ashita.Ability.Get_By_ID(ability_id + H.Enum.Offsets.PET)
        if Res.Pets.Get_Healing_Wyvern_Breath(ability_id) then trackable = H.Trackable.PET_HEAL end
    end
    return ability_data, avatar, trackable
end

------------------------------------------------------------------------------------------------------
-- Since I'm pulling from different sources for ability information (Windower resource luas and Ashita),
-- I need rectify those sources into one standard.
------------------------------------------------------------------------------------------------------
---@param ability_data table
---@param ability_id number
---@param avatar boolean whether or not the ability was an avatar bloodpact.
---@param actor_mob table
---@return table ability_data
------------------------------------------------------------------------------------------------------
H.Ability.Pet_Ability_Rectify = function(ability_data, ability_id, avatar, actor_mob)
    if not ability_data then
        _Debug.Error.Add("Ability.Pet_Ability_Rectify: {" .. tostring(actor_mob.name) .. "} Data on ability ID " .. tostring(ability_id) .. " is unavailable.")
        ability_data = {Id = ability_id, Name = "UNK Ability (" .. ability_id .. ")"}
    else
        if avatar then
            ability_data = {Id = ability_id, Name = ability_data.en}
        else
            ability_data = {Id = ability_id, Name = Ashita.Ability.Name(ability_id, ability_data)}
        end
    end
    return ability_data
end

------------------------------------------------------------------------------------------------------
-- Increment the use count of a pet ability.
------------------------------------------------------------------------------------------------------
---@param actor_mob table
---@param owner_mob table
---@param target_mob table
---@param ability_data table
---@param trackable string
---@param damage number
------------------------------------------------------------------------------------------------------
H.Ability.Pet_Count = function(actor_mob, owner_mob, target_mob, ability_data, trackable, damage)
    local audits = H.Ability.Audits(owner_mob.name, target_mob.name, actor_mob.name)
    DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, ability_data.Name, H.Metric.COUNT)
    if damage > 0 then
        DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.HIT_COUNT)
    end
end

------------------------------------------------------------------------------------------------------
-- Handle avatar's rage bloodpact.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param owner_mob table
---@param damage number
---@param ability_type string
---@param ability_name string
------------------------------------------------------------------------------------------------------
H.Ability.Pet_Rage = function(audits, owner_mob, damage, ability_type, ability_name)
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.PET, H.Metric.TOTAL)
    DB.Catalog.Update_Damage(audits.player_name, audits.target_name, ability_type, damage, ability_name, owner_mob.name)
    if damage > 0 then
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, ability_type, ability_name, H.Metric.HIT_COUNT)
    end
end

------------------------------------------------------------------------------------------------------
-- Handle avatar and wyvern healing.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param owner_mob table
---@param damage number
---@param ability_name string
---@return string
------------------------------------------------------------------------------------------------------
H.Ability.Pet_Healing = function(audits, owner_mob, damage, ability_name)
    local ability_type = H.Trackable.PET_HEAL
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.HEALING, H.Metric.TOTAL)
    DB.Catalog.Update_Damage(audits.player_name, audits.target_name, ability_type, damage, ability_name, owner_mob.name)
    if damage > 0 then
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, ability_type, ability_name, H.Metric.HIT_COUNT)
    end
    return ability_type
end

------------------------------------------------------------------------------------------------------
-- Handle wyvern breath abilities.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param owner_mob table
---@param damage number
---@param ability_type string
---@param ability_name string
------------------------------------------------------------------------------------------------------
H.Ability.Pet_Breath = function(audits, owner_mob, damage, ability_type, ability_name)
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.PET, H.Metric.TOTAL)
    DB.Catalog.Update_Damage(audits.player_name, audits.target_name, ability_type, damage, ability_name, owner_mob.name)
    if damage > 0 then
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, ability_type, ability_name, H.Metric.HIT_COUNT)
    end
end

------------------------------------------------------------------------------------------------------
-- Handle player abilities that do damage.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param damage number
---@param ability_type string
---@param ability_name string
------------------------------------------------------------------------------------------------------
H.Ability.Catalog = function(audits, damage, ability_type, ability_name)
    if damage > 0 then
        DB.Catalog.Update_Damage(audits.player_name, audits.target_name, ability_type, damage, ability_name)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, ability_type, ability_name, H.Metric.HIT_COUNT)
    end
end