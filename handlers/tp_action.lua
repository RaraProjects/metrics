H.TP = {}

H.TP.SC_Opener = nil
H.TP.SC_Opening_WS = nil
H.TP.SC_Step   = 0

------------------------------------------------------------------------------------------------------
-- Parse the weaponskill packet.
-- Surprises:
-- 1. Some abilities--like DRG Jumps--oddly show up in this packet.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param log_offense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.TP.Action = function(action, actor_mob, log_offense)
    if not log_offense then return nil end

	local ws_data = H.TP.WS_Data(action, actor_mob)
    if not ws_data then return nil end
    local ws_name = ws_data.en
    local ws_id   = ws_data.id

    local result, target_mob, sc_name
    local total_damage = 0
    local ws_damage    = 0
    local sc_damage    = 0
    local was_no_damage_hit = false

    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do

            result = action.targets[target_index].actions[action_index]

            -- Abilities marked as weaponskills
            if H.TP.WS_Ability(result, ws_id, action, actor_mob) then return nil end
            target_mob = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)

            if target_mob then
                if Ashita.Mob.Is_Monster(target_mob) then DB.Lists.Check.Mob_Exists(target_mob.name) end

                -- Check for skillchains
                sc_damage, sc_name = H.TP.Skillchain_Parse(result, actor_mob, target_mob, ws_name)

                -- Need to calculate WS damage here to account for AOE weaponskills
                ws_damage, was_no_damage_hit = H.TP.Weaponskill_Parse(result, actor_mob, target_mob, ws_name, ws_id)
                total_damage = total_damage + ws_damage
            end
        end
    end

    -- Finalize weaponskill and skillchain data.
    -- Have to do it outside of the loop to avoid counting attempts and hits multiple times.
    local tp = H.TP.Weaponskill_Wrap_Up(actor_mob, target_mob, total_damage, ws_name, sc_name, was_no_damage_hit)

    -- Update the battle log.
    if was_no_damage_hit then total_damage = 0 end
    Blog.Add(actor_mob.name, nil, Blog.Action_Type.WEAPONSKILL, ws_name, total_damage, tp, ws_data)
    if sc_damage > 0 then Blog.Add(actor_mob.name, nil, Blog.Action_Type.SKILLCHAIN, sc_name, sc_damage) end
end

------------------------------------------------------------------------------------------------------
-- Parse the begin monster TP move packet. This is primarily used to capture pet TP when using abilities.
-- BST Pet and Puppet ranged attacks fall into this category.
-- Trust abilities can show up here too. They don't have an owner.
-- As DRG, using Smiting Breath and Restoring Breath also come through here (as abilities).
-- Using the avatar ability as SMN also goes through here.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param log_offense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.TP.Begin_Monster_Action = function(action, actor_mob, log_offense)
    if not log_offense or Ashita.Mob.Is_Player(actor_mob) then return false end
    local owner_mob = Ashita.Mob.Pet_Owner(actor_mob)    -- Check to see if the pet belongs to anyone in the party.

    local target_mob, result, action_id, skill_data, skill_name
    local trackable = DB.Trackable.PET_TP
    for target_index, target_value in pairs(action.targets) do
        target_mob = Ashita.Mob.Get_Mob_By_ID(target_value.id)
        if not target_mob then target_mob = {name = DB.Enum.DEBUG} end
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            action_id = result.param
            skill_data = H.TP.Pet_Skill_Data(action_id, actor_mob)
            if not skill_data then return nil end
            skill_name = skill_data.en

            -- Avatar and wyvern abilities go through here too.
            if Res.Avatar.Get_Healing(action_id) then
                trackable = DB.Trackable.PET_HEALING
            elseif Res.Avatar.Get_Rage(action_id) or Res.Avatar.Get_Ward(action_id) then
                trackable = DB.Trackable.PET_TP
            elseif Res.Pets.Get_Damaging_Wyvern_Breath(action_id) then
                trackable = DB.Trackable.PET_TP
                skill_name = Res.Pets.Get_Damaging_Wyvern_Breath(action_id).en
            elseif Res.Pets.Get_Healing_Wyvern_Breath(action_id) then
                trackable = DB.Trackable.PET_HEALING
                skill_name = Res.Pets.Get_Healing_Wyvern_Breath(action_id).en
            elseif not Res.Monster.Get_Damaging_Ability(action_id) then
                return nil
            end
        end
    end

    local pet_tp = Ashita.Player.Get(Ashita.Enum.Player_Attributes.PET_TP) or 0
    local audits = H.TP.Audits(actor_mob, owner_mob, target_mob)
    H.Offense.Weaponskill_TP(audits, pet_tp, skill_name, trackable)
end

------------------------------------------------------------------------------------------------------
-- Parse the finish monster TP move packet.
-- BST Pet and Puppet ranged attacks fall into this category.
-- Trust abilities can show up here too. They don't have an owner.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param log_offense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.TP.Monster_Action = function(action, actor_mob, log_offense)
    if not log_offense then return false end
    local owner_mob = Ashita.Mob.Pet_Owner(actor_mob)    -- Check to see if the pet belongs to anyone in the party.

    local skill_data = H.TP.Pet_Skill_Data(action.param, actor_mob)
    if not skill_data then return nil end
    local skill_name = skill_data.en
    local action_id = skill_data.id

    local result, target_mob
    local damage = 0

    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target_mob = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if not target_mob then target_mob = {name = DB.Enum.DEBUG} end

            -- Puppet ranged attack
            -- This needs to be inside the result loop in order to send the data to the ranged handler.
            if action_id == 1949 then
                H.Ranged.Parse(result, actor_mob, target_mob, owner_mob)
                skill_name = "Pet Ranged"
                damage = result.param

            -- BST pet abilities can't skillchain in HorizonXI.
            -- Need to calculate WS damage here to account for AOE weaponskills.
            else
                damage = damage + H.TP.Weaponskill_Parse(result, actor_mob, target_mob, skill_name, action_id, owner_mob)
            end
        end
    end

    local audits = H.TP.Audits(actor_mob, owner_mob, target_mob)
    H.TP.Pet_Skill_Attempts(audits, audits.trackable, skill_name)
    if damage > 0 then H.TP.Pet_Skill_Hit(audits, audits.trackable, skill_name) end

    -- Update the battle log.
    if owner_mob then
        if not Res.Monster.Get_Damaging_Ability(action_id) then damage = -1 end
        Blog.Add(owner_mob.name, actor_mob.name, Blog.Action_Type.PET_TP, skill_name, damage)
    end

    return true
end

------------------------------------------------------------------------------------------------------
-- Set data for a weaponskill action.
-- AOE weaponskills will go through this one time for each mob hit.
------------------------------------------------------------------------------------------------------
---@param result table contains all the information for the action.
---@param actor_mob table name of the player that did the action.
---@param target_mob table name of the target that received the action.
---@param ws_name string name of the weaponskill that was used.
---@param ws_id integer ID of the ability that was used. Right now this is used to check monster abilities.
---@param owner_mob? table if the action was from a pet then this will hold the owner's mob.
---@return integer, boolean
------------------------------------------------------------------------------------------------------
H.TP.Weaponskill_Parse = function(result, actor_mob, target_mob, ws_name, ws_id, owner_mob)
    Debug.Packet.Add_Action(actor_mob.name, target_mob.name, "Weaponskill", result)
    local damage     = result.param
    local message_id = result.message
    local audits = H.TP.Audits(actor_mob, owner_mob, target_mob)

    -- Some weaponskills drain MP instead of doing damage.
    -- There is special handling within DB code to prevent total damage increment on this trackable.
    local was_no_damage_hit = false
    if Res.WS.Get_MP_Drain(ws_id) then
        was_no_damage_hit = true
        H.Offense.Catalog_Hit(audits, DB.Trackable.WEAPONSKILL_MP_DRAIN, damage, ws_name)
        damage = 0
    end

    -- A lot of pet abilities just land a status effect and it carries in a value as if it were damage.
    -- Setting PET_OVERALL total damage directly because I don't know if this is a hit or miss.
    if owner_mob then
        if not Res.Monster.Get_Damaging_Ability(ws_id) then damage = 0 end
        DB.Data.Update(DB.Update_Mode.INC, damage, audits, DB.Trackable.PET_OVERALL, DB.Metric.TOTAL)
    end

    if message_id == Ashita.Enum.Message.SHADOWS then
        H.Offense.Catalog_No_Damage_Hit(audits, audits.trackable, ws_name)
        was_no_damage_hit = true
    else
        H.Offense.Catalog_Hit(audits, audits.trackable, damage, ws_name)
    end

    return damage, was_no_damage_hit
end

-- ------------------------------------------------------------------------------------------------------
-- Check for skillchains.
-- ------------------------------------------------------------------------------------------------------
---@param result table
---@param actor_mob table
---@param target_mob table
---@param ws_name string
---@return number, string
-- ------------------------------------------------------------------------------------------------------
H.TP.Skillchain_Parse = function(result, actor_mob, target_mob, ws_name)
    local sc_id = result.add_effect_message
    local sc_damage = 0
    local sc_name = DB.Enum.DEBUG
    if sc_id > 0 then
        sc_name   = Res.WS.Get_Skillchain(sc_id)
        sc_damage = result.add_effect_param
        local audits = {player_name = actor_mob.name, target_name = target_mob.name}
        H.Offense.Catalog_Hit(audits, DB.Trackable.SKILLCHAIN, sc_damage, sc_name)
        H.TP.SC_Step = H.TP.SC_Step + 1
    else
        H.TP.SC_Opener = actor_mob.name
        H.TP.SC_Opening_WS = ws_name
        H.TP.SC_Step   = 1
    end
    return sc_damage, sc_name
end

-- ------------------------------------------------------------------------------------------------------
-- Wraps up weaponskill and skillchain tallys outside of the target loop.
-- ------------------------------------------------------------------------------------------------------
---@param actor_mob table
---@param target_mob table
---@param damage integer
---@param ws_name string
---@return integer
-- ------------------------------------------------------------------------------------------------------
H.TP.Weaponskill_Wrap_Up = function(actor_mob, target_mob, damage, ws_name, sc_name, was_no_damage_hit)
    local audits = {
        player_name = actor_mob.name,
        target_name = target_mob.name,
    }

    -- Update TP usage.
    local tp = Ashita.Party.Refresh(audits.player_name, Ashita.Enum.Player_Attributes.TP)
    tp = H.Offense.Weaponskill_TP(audits, tp, ws_name, DB.Trackable.WEAPONSKILL)

    -- Update non-target loop hits and attempts.
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.WEAPONSKILL, DB.Metric.ATTEMPTS_ON_USE)
    DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, DB.Trackable.WEAPONSKILL, ws_name, DB.Metric.ATTEMPTS_ON_USE)

    if damage > 0 or was_no_damage_hit then
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.WEAPONSKILL, DB.Metric.HITS_ON_USE)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, DB.Trackable.WEAPONSKILL, ws_name, DB.Metric.HITS_ON_USE)
    end

    if sc_name ~= DB.Enum.DEBUG then H.TP.Skillchain_Hit(audits, sc_name) end

    return tp
end

-- ------------------------------------------------------------------------------------------------------
-- Increments skillchain counts.
-- ------------------------------------------------------------------------------------------------------
---@param audits table
---@param sc_name string
-- ------------------------------------------------------------------------------------------------------
H.TP.Skillchain_Hit = function(audits, sc_name)
    -- Total Attempts
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.SKILLCHAIN, DB.Metric.ATTEMPTS_ON_USE)
    DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, DB.Trackable.SKILLCHAIN, sc_name, DB.Metric.ATTEMPTS_ON_USE)

    -- Successfull SC Count
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.SKILLCHAIN, DB.Metric.HITS_ON_USE)
    DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, DB.Trackable.SKILLCHAIN, sc_name, DB.Metric.HITS_ON_USE)

    -- Credit to skillchain closer.
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.SKILLCHAIN, DB.Metric.SKILLCHAIN_CLOSED)
    DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, DB.Trackable.SKILLCHAIN, sc_name, DB.Metric.SKILLCHAIN_CLOSED)

    -- Credit to skillchain opener (except for multistep skillchains).
    if H.TP.SC_Step <= 2 then
        local sc_audits = T{
            player_name = H.TP.SC_Opener,
            target_name = audits.target_name,
        }
        DB.Data.Update(DB.Update_Mode.INC, 1, sc_audits, DB.Trackable.SKILLCHAIN, DB.Metric.SKILLCHAIN_OPENED)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, sc_audits, DB.Trackable.SKILLCHAIN, sc_name, DB.Metric.SKILLCHAIN_OPENED)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Increments pet skill attempts.
-- ------------------------------------------------------------------------------------------------------
---@param audits table
---@param trackable string
---@param skill_name string
-- ------------------------------------------------------------------------------------------------------
H.TP.Pet_Skill_Attempts = function(audits, trackable, skill_name)
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS_ON_USE)
    DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, skill_name, DB.Metric.ATTEMPTS_ON_USE)
end

-- ------------------------------------------------------------------------------------------------------
-- Increments pet skill hits.
-- ------------------------------------------------------------------------------------------------------
---@param audits table
---@param trackable string
---@param skill_name string
-- ------------------------------------------------------------------------------------------------------
H.TP.Pet_Skill_Hit = function(audits, trackable, skill_name)
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.HITS_ON_USE)
    DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, skill_name, DB.Metric.HITS_ON_USE)
end

-- ------------------------------------------------------------------------------------------------------
-- Set audit information for pet skills.
-- ------------------------------------------------------------------------------------------------------
---@param actor_mob table
---@param owner_mob table|nil
---@param target_mob table
---@return table
-- ------------------------------------------------------------------------------------------------------
H.TP.Audits = function(actor_mob, owner_mob, target_mob)
    -- Initialize on case where this is a trust or regular monster.
    local player_name = actor_mob.name
    local pet_name = nil
    local trackable = DB.Trackable.WEAPONSKILL
    -- Case where this is a player's pet using an ability.
    if owner_mob then
        player_name = owner_mob.name
        pet_name = actor_mob.name
        trackable = DB.Trackable.PET_TP
    end
    local audits = {
        player_name = player_name,
        target_name = target_mob.name,
        pet_name = pet_name,
        trackable = trackable
    }
    return audits
end

-- ------------------------------------------------------------------------------------------------------
-- Get weaponskill data.
-- ------------------------------------------------------------------------------------------------------
---@param action table
---@param actor_mob table
---@return table|nil
-- ------------------------------------------------------------------------------------------------------
H.TP.WS_Data = function(action, actor_mob)
    local ws_data = Ashita.WS.Get_By_ID(action.param)
	if not ws_data then
        Debug.Error.Add(Debug.Error.ERROR, "H.TP.WS_Data", "Actor {" .. tostring(actor_mob.name) .. "} used WS ID {" .. tostring(action.param)
        .. "} and it wasn't found.")
        return nil
    end
    return ws_data
end

-- ------------------------------------------------------------------------------------------------------
-- Get pet skill data.
-- ------------------------------------------------------------------------------------------------------
---@param action_id number
---@param actor_mob table
---@return table
-- ------------------------------------------------------------------------------------------------------
H.TP.Pet_Skill_Data = function(action_id, actor_mob)
    local skill_data = Res.Monster.Get_Full_List(action_id)
    if not skill_data then
        Debug.Error.Add(Debug.Error.ERROR, "H.TP.Pet_Skill_Data", "Actor {" .. tostring(actor_mob.name) .. "} used TP move {" .. tostring(action_id)
        .. "} and it was unmapped.")
        skill_data = {id = action_id, en = "UNK Mon. Ability (" .. action_id .. ")"}
    end
    return skill_data
end

-- ------------------------------------------------------------------------------------------------------
-- Checks for abilities that come through on the WS packet.
-- I'm differentiating them based on chat message, so this needs to be called in the result loop and not before.
-- Specific case: Steal/Swift Blade, Atonement/Mug, Gale Axe/Jump, Spinning Axe/Super Jump
-- ------------------------------------------------------------------------------------------------------
---@param result table
---@param ws_id number
---@param action table
---@param actor_mob table
---@return boolean true: weaponskill was actually an ability
-- ------------------------------------------------------------------------------------------------------
H.TP.WS_Ability = function(result, ws_id, action, actor_mob)
    if Res.WS.Get_Ability(ws_id) then
        if result.message ~= 185 and result.message ~= 188 then
            H.Ability.Action(action, actor_mob, true)
            return true
        end
    end
    return false
end