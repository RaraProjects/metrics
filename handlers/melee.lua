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
    local add_damage = 0
    local overall_hit = false
    local details = {}
    local mult_attack = {}

	for target_index, target_value in pairs(action.targets) do
		for action_index, _ in pairs(target_value.actions) do
			result = action.targets[target_index].actions[action_index]
			target_mob = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)
			if not target_mob then target_mob = {name = DB.Enum.DEBUG} end
            if target_mob then
                if Ashita.Mob.Is_Monster(target_mob) then DB.Lists.Check.Mob_Exists(target_mob.name) end
                details = H.Melee.Parse(result, actor_mob.name, target_mob.name, owner_mob)

                -- Special handling for tracking multi-attacks.
                if details then
                    if details.damage then damage = damage + details.damage end
                    if details.add_damage then add_damage = add_damage + details.add_damage end     -- Additional effect kept seperate from multi-attack damage.
                end

                -- Multi-attack handling by type.
                if details and details.type then
                    -- First hit for a melee type should be initialization.
                    if not mult_attack[details.type] then
                        mult_attack[details.type] = {}
                        mult_attack[details.type].swings = 0
                        mult_attack[details.type].multi_damage = 0
                        mult_attack[details.type].has_hit = false

                    -- If already initialized then this should not be the first hit i.e. a multi-attack has occurred.
                    -- Start logging multi-attack damage in this case.
                    else
                        mult_attack[details.type].multi_damage = mult_attack[details.type].multi_damage + details.damage
                    end

                    -- Always increment the multi-attack swing counter and total damage
                    if details.has_hit then
                        mult_attack[details.type].has_hit = true
                        overall_hit = true
                    end
                    mult_attack[details.type].swings = mult_attack[details.type].swings + 1
                end
            end
		end
	end

    if details and details.audits and details.audits.player_name and not owner_mob then

        local multi_swings = 0
        local multi_damage = 0
        local has_hit = false
        local has_multi = false

        for type, data in pairs(mult_attack) do
            multi_swings = data.swings
            multi_damage = data.multi_damage
            has_hit      = data.has_hit

            -- Find the correct multi-attack metric based on the number attacks for the melee type.
            local multi_count_metric = nil
            local multi_damage_metric = nil
            if     multi_swings == 1 then multi_count_metric = DB.Metric.MULTI_ATTACK_1 multi_damage_metric = DB.Metric.MULTI_ATTACK_1_DAMAGE
            elseif multi_swings == 2 then multi_count_metric = DB.Metric.MULTI_ATTACK_2 multi_damage_metric = DB.Metric.MULTI_ATTACK_2_DAMAGE
            elseif multi_swings == 3 then multi_count_metric = DB.Metric.MULTI_ATTACK_3 multi_damage_metric = DB.Metric.MULTI_ATTACK_3_DAMAGE
            elseif multi_swings == 4 then multi_count_metric = DB.Metric.MULTI_ATTACK_4 multi_damage_metric = DB.Metric.MULTI_ATTACK_4_DAMAGE
            elseif multi_swings == 5 then multi_count_metric = DB.Metric.MULTI_ATTACK_5 multi_damage_metric = DB.Metric.MULTI_ATTACK_5_DAMAGE
            elseif multi_swings == 6 then multi_count_metric = DB.Metric.MULTI_ATTACK_6 multi_damage_metric = DB.Metric.MULTI_ATTACK_6_DAMAGE
            elseif multi_swings == 7 then multi_count_metric = DB.Metric.MULTI_ATTACK_7 multi_damage_metric = DB.Metric.MULTI_ATTACK_7_DAMAGE
            elseif multi_swings == 8 then multi_count_metric = DB.Metric.MULTI_ATTACK_8 multi_damage_metric = DB.Metric.MULTI_ATTACK_8_DAMAGE
            end

            if multi_count_metric and multi_damage_metric then
                -- Multi-attack specific rate.
                if not DB.Tracking.Multi_Attack[details.audits.player_name] then DB.Tracking.Multi_Attack[details.audits.player_name] = {} end
                DB.Tracking.Multi_Attack[details.audits.player_name][multi_count_metric] = true
                DB.Data.Update(DB.Update_Mode.INC, 1, details.audits, type, multi_count_metric)                        -- Specific multi-attack count (even if it's one).
                DB.Data.Update(DB.Update_Mode.INC, multi_damage, details.audits, type, multi_damage_metric)            -- Specific multi-attack damage.
                if has_hit then DB.Data.Update(DB.Update_Mode.INC, 1, details.audits, type, DB.Metric.HITS_ON_USE) end -- How many times an attack round contained a specific melee type.
                DB.Data.Update(DB.Update_Mode.INC, 1, details.audits, type, DB.Metric.ATTEMPTS_ON_USE)                 -- Kind of benign. All hits should have an attempt associated though.

                -- Total multi-attack rate.
                if multi_swings > 1 then
                    has_multi = true
                    DB.Data.Update(DB.Update_Mode.INC, 1,            details.audits, type, DB.Metric.MULTI_ATTACK_HIT_ON_USE)
                    DB.Data.Update(DB.Update_Mode.INC, multi_damage, details.audits, type, DB.Metric.MULTI_ATTACK_TOTAL)
                    DB.Data.Update(DB.Update_Mode.INC, multi_damage, details.audits, DB.Trackable.MELEE_OVERALL, DB.Metric.MULTI_ATTACK_TOTAL)
                end
            end
        end

        -- Only count one multi attack per attack round for the overall metric. Otherwise there is >100% for overall multi rate.
        if has_multi then DB.Data.Update(DB.Update_Mode.INC, 1, details.audits, DB.Trackable.MELEE_OVERALL, DB.Metric.MULTI_ATTACK_HIT_ON_USE) end
    end

    -- Don't calculatefor pets.
    -- Keep track of how many melee cycles have occurred (1 per packet).
    if not owner_mob then
        DB.Attack_Speed.Update(actor_mob.name)
        if overall_hit then DB.Data.Update(DB.Update_Mode.INC, 1, details.audits, DB.Trackable.MELEE_OVERALL, DB.Metric.HITS_ON_USE) end
        DB.Data.Update(DB.Update_Mode.INC, 1, details.audits, DB.Trackable.MELEE_OVERALL, DB.Metric.ATTEMPTS_ON_USE)
    end

    H.Melee.Blog(actor_mob, owner_mob, damage + add_damage)
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

    local was_critical_hit, has_hit = H.Melee.Message(audits, damage, message_id, melee_type_broad, melee_type_discrete, owner_mob)

    -- Avoid setting any damage data if the strike missed or healed a mob or something.
    if not no_damage then
        H.Offense.Grand_Totals(audits, damage, owner_mob)
        H.Melee.Guarded(audits, melee_type_broad, reaction_id)
        H.Offense.Min_Max(audits, melee_type_broad, damage, was_critical_hit)
        H.Offense.Min_Max(audits, melee_type_discrete, damage, was_critical_hit)
    end

    if no_damage then damage = 0 end

    -- These have their own damage separate from the intiial melee strike.
    H.Melee.Spikes(audits, result, owner_mob)
    local add_damage = H.Melee.Additional_Effect(audits, result)

    return {damage = damage, add_damage = add_damage, has_hit = has_hit, type = melee_type_discrete, audits = audits}
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
---@return boolean, boolean
------------------------------------------------------------------------------------------------------
H.Melee.Message = function(audits, damage, message_id, melee_type_broad, melee_type_discrete, owner_mob)
    local was_critical_hit = false
    local has_hit = true

    if message_id == Ashita.Enum.Message.HIT then
        H.Offense.Hit(audits, melee_type_broad, damage)
        H.Offense.Hit(audits, melee_type_discrete, damage)
        H.Offense.Update_Recent_Accuracy(audits, true, owner_mob)

    elseif message_id == Ashita.Enum.Message.MISS then
        H.Offense.Miss(audits, melee_type_broad)
        H.Offense.Miss(audits, melee_type_discrete)
        H.Offense.Update_Recent_Accuracy(audits, false, owner_mob)
        has_hit = false

    elseif message_id == Ashita.Enum.Message.CRIT then
        H.Offense.Hit(audits, melee_type_broad, damage, true)
        H.Offense.Hit(audits, melee_type_discrete, damage, true)
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
        has_hit = false

    elseif message_id == Ashita.Enum.Message.SQUARE then
        H.Offense.Hit(audits, melee_type_broad, damage)
        H.Offense.Hit(audits, melee_type_discrete, damage)
        H.Offense.Update_Recent_Accuracy(audits, true)

    elseif message_id == Ashita.Enum.Message.TRUE then
        H.Offense.Hit(audits, melee_type_broad, damage)
        H.Offense.Hit(audits, melee_type_discrete, damage)
        H.Offense.Update_Recent_Accuracy(audits, true)

    elseif message_id == Ashita.Enum.Message.RANGECRIT then
        H.Offense.Hit(audits, melee_type_broad, damage, true)
        H.Offense.Hit(audits, melee_type_discrete, damage, true)
        H.Offense.Update_Recent_Accuracy(audits, true, owner_mob)
        was_critical_hit = true

    else
        Debug.Error.Add(Debug.Error.WARNING, "H.Melee.Message", "Player {" .. tostring(audits.player_name) .. "} had unhandled melee message {"
        .. tostring(message_id) .. "}.")
        has_hit = false
    end

    return was_critical_hit, has_hit
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
---@return integer
------------------------------------------------------------------------------------------------------
H.Melee.Additional_Effect = function(audits, result)
    if not result then return 0 end
    local additional_damage = 0

    if result.has_add_effect then
        local message_id   = result.add_effect_message
        local animation_id = result.add_effect_animation
        local param        = result.add_effect_param   -- This is either damage or the type of debuff applied.

        if message_id == Ashita.Enum.Message.ENSPELL then
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
        local damage          = result.spike_effect_param
        local spike_animation = result.spike_effect_animation
        local spike_message   = result.spike_effect_message
        local spike_trackable = DB.Trackable.DEF_SPIKES
        H.Defense.Grand_Totals(audits, damage)

        if spike_message == Ashita.Enum.Message.SPIKE_DMG then
            H.Offense.Hit(audits, DB.Trackable.DEF_NUKING, damage)

            if spike_animation == Ashita.Enum.Effect_Animation.FIRE then
                H.Offense.Catalog_Hit(audits, spike_trackable, damage, "Blaze Spikes")

            elseif spike_animation == Ashita.Enum.Effect_Animation.ICE then
                H.Offense.Catalog_Hit(audits, spike_trackable, damage, "Ice Spikes")

            elseif spike_animation == Ashita.Enum.Effect_Animation.THUNDER then
                H.Offense.Catalog_Hit(audits, spike_trackable, damage, "Shock Spikes")
            end

        elseif spike_message == Ashita.Enum.Message.COUNTER then
            was_countered = true
            H.Offense.Hit(audits, DB.Trackable.DEF_MELEE, damage)
            H.Offense.Hit(audits, DB.Trackable.DEF_COUNTERED, damage)
        end

    end
    if not was_countered then H.Offense.Miss(audits, DB.Trackable.DEF_COUNTERED) end
end