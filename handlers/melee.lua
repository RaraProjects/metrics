H.Melee = {}

-- ------------------------------------------------------------------------------------------------------
-- Parse the melee attack packet.
-- ------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param owner_mob table|nil (if pet) the mob data of the entity's owner.
---@param log_offense boolean if this action should actually be logged.
-- ------------------------------------------------------------------------------------------------------
H.Melee.Action = function(action, actor_mob, owner_mob, log_offense)
	if not log_offense then return nil end
	local result, target_mob
	local damage = 0
    local details = T{}
    local mult_attack = T{}

	for target_index, target_value in pairs(action.targets) do
		for action_index, _ in pairs(target_value.actions) do
			result = action.targets[target_index].actions[action_index]
			target_mob = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)
			if not target_mob then target_mob = {name = DB.Enum.DEBUG} end
            if target_mob then
                if Ashita.Mob.Is_Monster(target_mob) then DB.Lists.Check.Mob_Exists(target_mob.name) end
                details = H.Melee.Parse(result, actor_mob.name, target_mob.name, owner_mob)

                if details and details.damage then damage = damage + details.damage end
                if details and details.type then
                    if not mult_attack[details.type] then mult_attack[details.type] = 0 end
                    mult_attack[details.type] = mult_attack[details.type] + 1
                end
            end
		end
	end

    if details and details.audits and details.audits.player_name and not owner_mob then
        for type, number in pairs(mult_attack) do
            local metric = nil
            if number == 1 then metric = DB.Metric.MULTI_ATTACK_1 end
            if number == 2 then metric = DB.Metric.MULTI_ATTACK_2 end
            if number == 3 then metric = DB.Metric.MULTI_ATTACK_3 end
            if number == 4 then metric = DB.Metric.MULTI_ATTACK_4 end
            if number == 5 then metric = DB.Metric.MULTI_ATTACK_5 end
            if number == 6 then metric = DB.Metric.MULTI_ATTACK_6 end
            if number == 7 then metric = DB.Metric.MULTI_ATTACK_7 end
            if number == 8 then metric = DB.Metric.MULTI_ATTACK_8 end
            if metric then
                if not DB.Tracking.Multi_Attack[details.audits.player_name] then DB.Tracking.Multi_Attack[details.audits.player_name] = T{} end
                DB.Tracking.Multi_Attack[details.audits.player_name][metric] = true
                DB.Data.Update(DB.Update_Mode.INC, 1, details.audits, type, metric)
                DB.Data.Update(DB.Update_Mode.INC, 1, details.audits, type, DB.Metric.MELEE_STRIKES)
                DB.Data.Update(DB.Update_Mode.INC, 1, details.audits, DB.Trackable.MELEE_OVERALL, DB.Metric.MELEE_STRIKES)
                if number > 1 then DB.Data.Update(DB.Update_Mode.INC, 1, details.audits, DB.Trackable.MELEE_OVERALL, DB.Metric.MULTI_ATTACK_TOTAL) end
            end
        end
    end

    -- Don't calculate attack speed for pets.
    if not owner_mob then DB.Attack_Speed.Update(actor_mob.name) end

    -- Keeps track of how many melee cycles have occurred (1 per packet).
    if not owner_mob then DB.Data.Update(DB.Update_Mode.INC, 1, details.audits, DB.Trackable.MELEE_OVERALL, DB.Metric.MELEE_ROUNDS) end

    H.Melee.Blog(actor_mob, owner_mob, damage)
end

------------------------------------------------------------------------------------------------------
-- Set data for a melee action.
-- NOTES:
-- message 				https://github.com/Windower/Lua/wiki/Message-IDs
-- has_add_effect		boolean
-- add_effect_animation	https://github.com/Windower/Lua/wiki/Additional-Effect-IDs
-- Enspell element
-- add_effect_message	229: comes up with Ygnas bonus attack
-- add_effect_param		enspell damage
-- spike_effect_param	0: consistently on MNK vs Apex bats
-- spike_effect_effect
-- effect 				2: killing blow
-- 						4: counter? (probably not)
-- stagger 				animation the target does when being hit
-- reaction 			8: hit; consistently on MNK vs Apex bats
-- 						9: miss?; very rarely on MNK vs Apex bats
------------------------------------------------------------------------------------------------------
---@param result table contains all the information for the action.
---@param player_name string name of the player that did the action.
---@param target_name string name of the target that received the action.
---@param owner_mob? table if the action was from a pet then this will hold the owner's mob.
---@return table
------------------------------------------------------------------------------------------------------
H.Melee.Parse = function(result, player_name, target_name, owner_mob)
    Debug.Packet.Add_Action(player_name, target_name, "Melee", result)

    local animation_id = result.animation
    local damage       = result.param
    local message_id   = result.message
    local reaction_id  = result.reaction
    local throwing     = animation_id == Ashita.Enum.Animation.DAKEN
    local no_damage    = H.No_Damage_Messages(result)
    local melee_type_broad    = DB.Trackable.MELEE_OVERALL
    local melee_type_discrete = H.Melee.Melee_Type(animation_id)

    if throwing then
        melee_type_broad    = DB.Trackable.RANGED_OVERALL
        melee_type_discrete = DB.Trackable.RANGED_THROWING
    end

    -- Need special handling for pets
    local pet_name
    if owner_mob then
        melee_type_broad    = DB.Trackable.PET_MELEE_OVERALL
        melee_type_discrete = DB.Trackable.PET_MELEE_DISCRETE
        pet_name    = player_name
        player_name = owner_mob.name
    end

    local audits = {
        player_name = player_name,
        target_name = target_name,
        pet_name    = pet_name,
    }

    local was_critical_hit = H.Melee.Message(audits, damage, message_id, melee_type_broad, melee_type_discrete, owner_mob)

    -- Avoid setting any damage data if the strike missed or healed a mob or something.
    if not no_damage then
        H.Offense.Grand_Totals(audits, damage, owner_mob)
        H.Melee.Guarded(audits, melee_type_broad, reaction_id)
        H.Offense.Min_Max(audits, melee_type_broad, damage, was_critical_hit)
        H.Offense.Min_Max(audits, melee_type_discrete, damage, was_critical_hit)
    end

    -- These have their own damage separate from the intiial melee strike.
    H.Melee.Spikes(audits, result, owner_mob)
    damage = damage + H.Melee.Additional_Effect(audits, result, no_damage)

    -- Flag for the battle log.
    if no_damage then damage = -1 end

    return {damage = damage, type = melee_type_discrete, audits = audits}
end

-- ------------------------------------------------------------------------------------------------------
-- Adds melee damage to the battle log.
-- ------------------------------------------------------------------------------------------------------
---@param actor_mob table the mob data of the entity performing the action.
---@param owner_mob table|nil (if pet) the mob data of the entity's owner.
---@param damage number
-- ------------------------------------------------------------------------------------------------------
H.Melee.Blog = function(actor_mob, owner_mob, damage)
    if owner_mob then
        Blog.Add(owner_mob.name, actor_mob.name, Blog.Action_Type.PET_MELEE, DB.Trackable.PET_MELEE_OVERALL, damage)
    else
        Blog.Add(actor_mob.name, nil, Blog.Action_Type.MELEE, DB.Trackable.MELEE_OVERALL, damage)
    end
end

------------------------------------------------------------------------------------------------------
-- Map an animation to a discrete type of melee action.
------------------------------------------------------------------------------------------------------
---@param animation_id number represents, primary attack, offhand attack, kicking, etc.
---@return string
------------------------------------------------------------------------------------------------------
H.Melee.Melee_Type = function(animation_id)
    if animation_id == Ashita.Enum.Animation.MELEE_MAIN then
        return DB.Trackable.MELEE_MAIN_HAND
    elseif animation_id == Ashita.Enum.Animation.MELEE_OFFHAND then
        return DB.Trackable.MELEE_OFF_HAND
    elseif animation_id == Ashita.Enum.Animation.MELEE_KICK or animation_id == Ashita.Enum.Animation.MELEE_KICK2 then
        return DB.Trackable.MELEE_KICK_ATTACKS
    elseif animation_id == Ashita.Enum.Animation.DAKEN then
        return DB.Trackable.RANGED_THROWING
    else
        return DB.Trackable.DEFAULT
    end
end

------------------------------------------------------------------------------------------------------
-- The melee's reaction to determine whether the attack was guarded or not.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param melee_type_broad string
---@param reaction_id integer
------------------------------------------------------------------------------------------------------
H.Melee.Guarded = function(audits, melee_type_broad, reaction_id)
    if reaction_id == Ashita.Enum.Reaction.GUARD then
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, melee_type_broad, DB.Metric.GUARD)
    end
end

------------------------------------------------------------------------------------------------------
-- Handle the various metrics based on message.
-- The range attacks here are specifically the NIN auto throwing attacks while engaged.
-- https://github.com/Windower/Lua/wiki/Message-IDs
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param message_id number numberic identifier for system chat messages.
---@param melee_type_broad string player melee or pet melee.
---@param melee_type_discrete string main-hand, off-hand, etc.
---@param owner_mob? table
---@return boolean
------------------------------------------------------------------------------------------------------
H.Melee.Message = function(audits, damage, message_id, melee_type_broad, melee_type_discrete, owner_mob)
    local was_critical_hit = false

    if message_id == Ashita.Enum.Message.HIT then
        H.Offense.Hit(audits, melee_type_broad, damage)
        H.Offense.Hit(audits, melee_type_discrete, damage)
        H.Offense.Update_Recent_Accuracy(audits, true, owner_mob)

    elseif message_id == Ashita.Enum.Message.MISS then
        H.Offense.Miss(audits, melee_type_broad)
        H.Offense.Miss(audits, melee_type_discrete)
        H.Offense.Update_Recent_Accuracy(audits, false, owner_mob)

    elseif message_id == Ashita.Enum.Message.CRIT then
        H.Offense.Critical_Hit(audits, melee_type_broad, damage)
        H.Offense.Critical_Hit(audits, melee_type_discrete, damage)
        H.Offense.Update_Recent_Accuracy(audits, true, owner_mob)
        was_critical_hit = true

    -- Shadows have no impact on recent accuracy.
    elseif message_id == Ashita.Enum.Message.SHADOWS then
        H.Offense.Shadow_Absorption(audits, melee_type_broad)
        H.Offense.Shadow_Absorption(audits, melee_type_discrete)

    elseif message_id == Ashita.Enum.Message.DODGE then
        H.Melee.Dodge(audits, melee_type_broad, melee_type_discrete)

    elseif message_id == Ashita.Enum.Message.MOBHEAL3 or message_id == Ashita.Enum.Message.MOBHEAL373 then
        H.Offense.Mob_Heal(audits, melee_type_broad, damage)
        H.Offense.Mob_Heal(audits, melee_type_discrete, damage)
        H.Offense.Update_Recent_Accuracy(audits, true, owner_mob)

    elseif message_id == Ashita.Enum.Message.RANGEHIT then
        H.Offense.Hit(audits, melee_type_broad, damage)
        H.Offense.Hit(audits, melee_type_discrete, damage)
        H.Offense.Update_Recent_Accuracy(audits, true)

    elseif message_id == Ashita.Enum.Message.RANGEMISS then
        H.Offense.Miss(audits, melee_type_broad)
        H.Offense.Miss(audits, melee_type_discrete)
        H.Offense.Update_Recent_Accuracy(audits, false, owner_mob)

    elseif message_id == Ashita.Enum.Message.SQUARE then
        H.Offense.Hit(audits, melee_type_broad, damage)
        H.Offense.Hit(audits, melee_type_discrete, damage)
        H.Offense.Update_Recent_Accuracy(audits, true)

    elseif message_id == Ashita.Enum.Message.TRUE then
        H.Offense.Hit(audits, melee_type_broad, damage)
        H.Offense.Hit(audits, melee_type_discrete, damage)
        H.Offense.Update_Recent_Accuracy(audits, true)

    elseif message_id == Ashita.Enum.Message.RANGECRIT then
        H.Offense.Critical_Hit(audits, melee_type_broad, damage)
        H.Offense.Critical_Hit(audits, melee_type_discrete, damage)
        H.Offense.Update_Recent_Accuracy(audits, true, owner_mob)
        was_critical_hit = true

    else
        Debug.Error.Add(Debug.Error.WARNING, "H.Melee.Message", "Player {" .. tostring(audits.player_name) .. "} had unhandled melee message {"
        .. tostring(message_id) .. "}.")
    end

    return was_critical_hit
end

------------------------------------------------------------------------------------------------------
-- Regular melee evaded by Pefect Dodge.
-- Remove the count so perfect dodge isn't penalized.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param melee_type_broad string player melee or pet melee.
---@param melee_type_discrete string main-hand, off-hand, etc.
------------------------------------------------------------------------------------------------------
H.Melee.Dodge = function(audits, melee_type_broad, melee_type_discrete)
    DB.Data.Update(DB.Update_Mode.INC, -1, audits, melee_type_broad,    DB.Metric.ATTEMPTS_ON_TARGET)
    DB.Data.Update(DB.Update_Mode.INC, -1, audits, melee_type_discrete, DB.Metric.ATTEMPTS_ON_TARGET)
end

------------------------------------------------------------------------------------------------------
-- Captures additional effects from melee.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param result table
---@param no_damage? boolean whether or not the damage from this should be treated as actual damage or not.
---@return integer
------------------------------------------------------------------------------------------------------
H.Melee.Additional_Effect = function(audits, result, no_damage)
    if not result then return 0 end
    local additional_damage = 0

    if result.has_add_effect then
        local message_id   = result.add_effect_message
        local animation_id = result.add_effect_animation
        local param        = result.add_effect_param   -- This is either damage or the type of debuff applied.

        if message_id == Ashita.Enum.Message.ENSPELL then
            if no_damage then param = 0 end
            if animation_id and Res.Spells.Get_Enspell_Type(animation_id) then
                local enspell_name = Res.Spells.Get_Enspell_Type(animation_id)
                additional_damage = param
                H.Offense.Hit(audits, DB.Trackable.SPELLS_OVERALL, additional_damage)
                H.Offense.Catalog_Hit(audits, DB.Trackable.MELEE_ENSPELL, additional_damage, enspell_name)
            end

        elseif message_id == Ashita.Enum.Message.ENDAMAGE then
            if animation_id then
                local effect_name = Res.Game.Get_Additional_Effect_Animation(animation_id)
                additional_damage = param
                H.Offense.Hit(audits, DB.Trackable.SPELLS_OVERALL, additional_damage)
                H.Offense.Catalog_Hit(audits, DB.Trackable.MELEE_ENDAMAGE, additional_damage, effect_name)
            end

        elseif message_id == Ashita.Enum.Message.ENDEBUFF then
            local buff = Res.Buffs.Get_Buff(param)
            if buff then H.Offense.Catalog_No_Damage_Hit(audits, DB.Trackable.MELEE_ENDEBUFF, buff.en) end

        -- Drain Samba and Blood Weapon do not contribute to net new damage.
        elseif message_id == Ashita.Enum.Message.ENDRAIN then
            H.Offense.Hit(audits, DB.Trackable.MELEE_ENDRAIN, param)

        elseif message_id == Ashita.Enum.Message.ENASPIR then
            H.Offense.Hit(audits, DB.Trackable.MELEE_ENASPIR, param)
        end
    end

    return additional_damage
end

------------------------------------------------------------------------------------------------------
-- Detects how much damage the player took from the spike damage.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param result table action data
---@param owner_mob? table
------------------------------------------------------------------------------------------------------
H.Melee.Spikes = function(audits, result, owner_mob)
    if owner_mob or result.animation == Ashita.Enum.Animation.DAKEN then return nil end
    local was_countered = false

    local spike_effect = result.has_spike_effect
    if spike_effect and not audits.pet_name then
        local damage        = result.spike_effect_param
        local spike_message = result.spike_effect_message
        H.Defense.Grand_Totals(audits, damage)

        if spike_message == Ashita.Enum.Message.SPIKE_DMG then
            H.Offense.Hit(audits, DB.Trackable.DEF_NUKING, damage)
            H.Offense.Hit(audits, DB.Trackable.DEF_SPIKES, damage)

        elseif spike_message == Ashita.Enum.Message.COUNTER then
            was_countered = true
            H.Offense.Hit(audits, DB.Trackable.DEF_MELEE, damage)
            H.Offense.Hit(audits, DB.Trackable.DEF_COUNTERED, damage)
        end

    end
    if not was_countered then H.Offense.Miss(audits, DB.Trackable.DEF_COUNTERED) end
end