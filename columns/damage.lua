Column.Damage = {}

------------------------------------------------------------------------------------------------------
-- Grabs the damage of a certain trackable that the entity has done.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the model.
---@param metric? string
---@param percent_player? boolean whether or not the damage should be raw or percent.
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.By_Type = function(player_name, trackable, metric, action_name, percent_player, justify, raw)
    if not metric then metric = DB.Metric.TOTAL end
    local trackable_damage = 0

    if action_name then
        trackable_damage = DB.Catalog.Get(player_name, trackable, action_name, metric)
    else
        trackable_damage = DB.Data.Get(player_name, trackable, metric)
    end
    if DB.MetricNeedsMaxValue(metric) and trackable_damage >= DB.Enum.MAX_DAMAGE then trackable_damage = 0 end

    local color = Column.String.Color_Zero(trackable_damage)

    if percent_player then
        local total_damage = Column.Damage.RawTotalPlayerDamage(player_name)
        if trackable == DB.Trackable.SPELLS_HEALING or trackable == DB.Trackable.ABILITY_HEALING or
           trackable == DB.Trackable.PET_HEALING or trackable == DB.Trackable.ALL_HEAL then
            total_damage = DB.Data.Get(player_name, DB.Trackable.ALL_HEAL, DB.Metric.TOTAL)
        end
        return Column.Output.Percent(trackable_damage, total_damage, color, false, justify, raw)
    end

    return Column.Output.Number(trackable_damage, color, justify, raw)
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- This is for pet actions.
-- Grabs the total amount of damage a cataloged action has done for a given trackable and metric.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param pet_name string
---@param trackable string a trackable from the model.
---@param metric? string a metric from the model.
---@param action_name? string
---@param percent_pet? boolean whether or not the damage should be raw or percent.
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.By_Type_Pet = function(player_name, pet_name, trackable, metric, action_name, percent_pet)
    if not metric then metric = DB.Metric.TOTAL end
    local trackable_damage = 0

    if action_name then
        trackable_damage = DB.Pet_Catalog.Get(player_name, pet_name, trackable, action_name, metric)
    else
        trackable_damage = DB.Pet_Data.Get(player_name, pet_name, trackable, metric)
    end
    if DB.MetricNeedsMaxValue(metric) and trackable_damage >= DB.Enum.MAX_DAMAGE then trackable_damage = 0 end

    local color = Column.String.Color_Zero(trackable_damage)

    if percent_pet then
        local total_damage = DB.Pet_Data.Get(player_name, pet_name, DB.Trackable.TOTAL_DAMAGE, DB.Metric.TOTAL)
        return UI.TextColored(color, Column.String.Format_Percent(trackable_damage, total_damage))
    end

    return UI.TextColored(color, Column.String.Format_Number(trackable_damage))
end

------------------------------------------------------------------------------------------------------
-- Grabs an entity's critical hit damage for a given trackable.
-- Can also give combine melee/ranged crit damage.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param damage_type string
---@param percent? boolean whether or not the damage should be raw or percent.
---@param justify? boolean whether or not to right justify the text.
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.By_Type_Crit = function(player_name, damage_type, percent, justify)
    local crit_damage

    -- Get data
    if damage_type == DB.Enum.COMBINED then
        local melee_crits  = DB.Data.Get(player_name, DB.Trackable.MELEE_OVERALL,  DB.Metric.CRITICAL_DAMAGE)
        local ranged_crits = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, DB.Metric.CRITICAL_DAMAGE)
        crit_damage = melee_crits + ranged_crits
    else
        crit_damage = DB.Data.Get(player_name, damage_type, DB.Metric.CRITICAL_DAMAGE)
    end

    -- Colors
    local color = Column.String.Color_Zero(crit_damage)

    if percent then
        local total_damage = Column.Damage.RawTotalPlayerDamage(player_name)
        return Column.Output.Percent(crit_damage, total_damage, color, false, justify)
    end

    return Column.Output.Number(crit_damage, color, true, justify)
end

------------------------------------------------------------------------------------------------------
-- Shows the average damage for a trackable (like weaponskills).
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the model.
---@param damage_metric? string
---@param action_name? string
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.By_Type_Average = function(player_name, trackable, damage_metric, action_name, justify, raw)
    local damage = 0
    local hits   = 0
    if not damage_metric then damage_metric = DB.Metric.TOTAL end

    local count_metric = DB.Metric.HITS_ON_TARGET
    if damage_metric == DB.Metric.CRITICAL_DAMAGE then count_metric = DB.Metric.CRITICAL_COUNT end

    if action_name then
        damage = DB.Catalog.Get(player_name, trackable, action_name, damage_metric)
        hits   = DB.Catalog.Get(player_name, trackable, action_name, count_metric)
    else
        damage = DB.Data.Get(player_name, trackable, damage_metric)
        hits   = DB.Data.Get(player_name, trackable, count_metric)
    end

    local color  = Column.String.Color_Zero(damage)

    if damage == 0 or hits == 0 then return Column.Output.Number(0, color, justify, raw) end
    return Column.Output.Percent(damage, hits, color, true, justify, raw)
end

------------------------------------------------------------------------------------------------------
-- Shows the average non-critical damage for a given damage type.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the model.
---@param justify? boolean whether or not to right justify the text
---@return number
------------------------------------------------------------------------------------------------------
Column.Damage.Average_By_Type_Exclude_Critical = function(player_name, trackable, justify)
    -- Get the data.
    local damage      = DB.Data.Get(player_name, trackable, DB.Metric.TOTAL)
    local crit_damage = DB.Data.Get(player_name, trackable, DB.Metric.CRITICAL_DAMAGE)
    local hit_count   = DB.Data.Get(player_name, trackable, DB.Metric.HITS_ON_TARGET)
    local crit_count  = DB.Data.Get(player_name, trackable, DB.Metric.CRITICAL_COUNT)

    -- Seperate the critical and non-critical hit damage.
    local non_crit_damage = damage - crit_damage
    local non_crit_count  = hit_count - crit_count

    -- Colors
    local color = Column.String.Color_Zero(non_crit_damage)

    if non_crit_damage == 0 or non_crit_count == 0 then return UI.TextColored(color, Column.String.Format_Percent(0, 0, justify)) end
    return UI.TextColored(color, Column.String.Format_Percent(non_crit_damage, non_crit_count, justify, true))
end

------------------------------------------------------------------------------------------------------
-- Gets the average critical hit damage for a given damage type.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string
---@param justify? boolean whether or not to right justify the text.
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.Average_By_Type_Critical_Only = function(player_name, trackable, justify)
    local crit_damage = 0
    local crit_count  = 0

    -- Get data
    if trackable == DB.Enum.COMBINED then
        local melee_crits       = DB.Data.Get(player_name, DB.Trackable.MELEE_OVERALL,  DB.Metric.CRITICAL_DAMAGE)
        local melee_crit_count  = DB.Data.Get(player_name, DB.Trackable.MELEE_OVERALL,  DB.Metric.CRITICAL_COUNT)
        local ranged_crits      = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, DB.Metric.CRITICAL_DAMAGE)
        local ranged_crit_count = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, DB.Metric.CRITICAL_COUNT)
        crit_damage = melee_crits + ranged_crits
        crit_count  = melee_crit_count + ranged_crit_count
    else
        crit_damage = DB.Data.Get(player_name, trackable, DB.Metric.CRITICAL_DAMAGE)
        crit_count  = DB.Data.Get(player_name, trackable, DB.Metric.CRITICAL_COUNT)
    end

    -- Colors
    local color = Column.String.Color_Zero(crit_damage)

    return UI.TextColored(color, Column.String.Format_Percent(crit_damage, crit_count, justify, true))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- This is for pet actions.
-- Grabs the average damage for a given cataloged action and trackable.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param pet_name string
---@param trackable string a trackable from the model.
---@param action_name? string
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.Pet_Average = function(player_name, pet_name, trackable, action_name)
    local hits   = 0
    local damage = 0

    if action_name then
        hits   = DB.Pet_Catalog.Get(player_name, pet_name, trackable, action_name, DB.Metric.HITS_ON_TARGET)
        damage = DB.Pet_Catalog.Get(player_name, pet_name, trackable, action_name, DB.Metric.TOTAL)
    else
        hits   = DB.Pet_Data.Get(player_name, pet_name, trackable, DB.Metric.HITS_ON_TARGET)
        damage = DB.Pet_Data.Get(player_name, pet_name, trackable, DB.Metric.TOTAL)
    end

    local color = Column.String.Color_Zero(hits)

    if hits == 0 or damage == 0 then return UI.TextColored(color, Column.String.Format_Number(0)) end
    return UI.TextColored(color, Column.String.Format_Percent(damage, hits, false, true))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs the usage rate of specfic enspells.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the model.
---@param action_name? string
---@param on_target? boolean
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.Hits = function(player_name, trackable, action_name, on_target)
    local hits = 0

    local hit_metric = DB.Metric.HITS_ON_USE
    if on_target then hit_metric = DB.Metric.HITS_ON_TARGET end

    if action_name then
        hits = DB.Catalog.Get(player_name, trackable, action_name, hit_metric)
    else
        hits = DB.Data.Get(player_name, trackable, hit_metric)
    end

    local color = Column.String.Color_Zero(hits)

    return UI.TextColored(color, Column.String.Format_Number(hits))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs how many times a cataloged action was attempted for a given trackable.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the model.
---@param attempt_metric? string
---@param action_name? string
---@param on_target? boolean
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.Attempts = function(player_name, trackable, attempt_metric, action_name, on_target, raw)
    if not attempt_metric then attempt_metric = DB.Metric.ATTEMPTS_ON_USE end
    if on_target then attempt_metric = DB.Metric.ATTEMPTS_ON_TARGET end

    local attempts = 0
    if action_name then
        attempts = DB.Catalog.Get(player_name, trackable, action_name, attempt_metric)
    else
        attempts = DB.Data.Get(player_name, trackable, attempt_metric)
    end

    local color = Column.String.Color_Zero(attempts)

    if raw then return Column.String.Format_Number(attempts) end
    return UI.TextColored(color, Column.String.Format_Number(attempts))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- This is for pet actions.
-- Grabs how many times a cataloged action was attempted for a given trackable.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param pet_name string
---@param trackable string a trackable from the model.
---@param action_name? string
---@param on_target? boolean
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.Pet_Attempts = function(player_name, pet_name, trackable, action_name, on_target)
    local attempt_metric = DB.Metric.ATTEMPTS_ON_USE
    if on_target then attempt_metric = DB.Metric.ATTEMPTS_ON_TARGET end

    local attempts = 0
    if action_name then
        attempts = DB.Pet_Catalog.Get(player_name, pet_name, trackable, action_name, attempt_metric)
    else
        attempts = DB.Pet_Data.Get(player_name, pet_name, trackable, attempt_metric)
    end

    local color = Column.String.Color_Zero(attempts)

    return UI.TextColored(color, Column.String.Format_Number(attempts))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs the total amount of damage a cataloged action has done for a given trackable and metric.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the model.
---@param unit_metric string
---@param action_name? string
---@param burst? boolean
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.Per_Unit = function(player_name, trackable, unit_metric, action_name, burst)
    local damage = 0
    local unit   = 0

    local metric_total = DB.Metric.TOTAL
    if burst then metric_total = DB.Metric.CRITICAL_DAMAGE end

    if action_name then
        damage = DB.Catalog.Get(player_name, trackable, action_name, metric_total)
        unit   = DB.Catalog.Get(player_name, trackable, action_name, unit_metric)
    else
        damage = DB.Data.Get(player_name, trackable, metric_total)
        unit   = DB.Data.Get(player_name, trackable, unit_metric)
    end

    local final_unit = unit

    -- Convert MP to Burst MP if needed.
    if burst then
        local target_count    = DB.Data.Get(player_name, trackable, DB.Metric.ATTEMPTS_ON_TARGET)
        local burst_attempts  = DB.Data.Get(player_name, trackable, DB.Metric.CRITICAL_COUNT)
        local unit_per_target = unit / target_count
        local burst_mp        = unit_per_target * burst_attempts
        final_unit            = burst_mp
    end

    -- Colors
    local color = Column.String.Color_Zero(final_unit)

    if damage == 0 or unit == 0 then color = Res.Colors.Basic.DIM end
    return UI.TextColored(color, Column.String.Format_Percent(damage, final_unit, false, true))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs the average tp used for a weaponskill.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string
---@param unit_metric string
---@param action_name? string
---@param justify? boolean
------------------------------------------------------------------------------------------------------
Column.Damage.Per_Unit_Average = function(player_name, trackable, unit_metric, action_name, justify)
    local tp        = 0
    local attempts  = 0

    -- If an action name isn't provided then get the overall weaponskill TP.
    if action_name then
        tp       = DB.Catalog.Get(player_name, trackable, action_name, unit_metric)
        attempts = DB.Catalog.Get(player_name, trackable, action_name, DB.Metric.ATTEMPTS_ON_USE)
    else
        tp       = DB.Data.Get(player_name, trackable, unit_metric)
        attempts = DB.Data.Get(player_name, trackable, DB.Metric.ATTEMPTS_ON_USE)
    end

    -- Colors
    local color = Column.String.Color_Zero(tp)

    if tp == 0 or attempts == 0 then color = Res.Colors.Basic.DIM end
    return UI.TextColored(color, Column.String.Format_Percent(tp, attempts, justify, true))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs the average tp used for a pet weaponskill.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param pet_name string
---@param trackable string
---@param action_name? string
------------------------------------------------------------------------------------------------------
Column.Damage.Average_Pet_TP = function(player_name, pet_name, trackable, action_name)
    local tp = 0
    local attempts = 0

    if action_name then
        tp       = DB.Pet_Catalog.Get(player_name, pet_name, trackable, action_name, DB.Metric.TP_SPENT)
        attempts = DB.Pet_Catalog.Get(player_name, pet_name, trackable, action_name, DB.Metric.ATTEMPTS_ON_USE)
    else
        tp       = DB.Data.Get(player_name, trackable, DB.Metric.TP_SPENT)
        attempts = DB.Data.Get(player_name, trackable, DB.Metric.ATTEMPTS_ON_USE)
    end

    local color = Column.String.Color_Zero(tp)
    if tp == 0 or attempts == 0 then color = Res.Colors.Basic.DIM end

    return UI.TextColored(color, Column.String.Format_Percent(tp, attempts, false, true))
end

------------------------------------------------------------------------------------------------------
-- Grabs the damage of a certain trackable that the entity's pet has done.
------------------------------------------------------------------------------------------------------
---@param player_name string the entity that owns the pet.
---@param pet_name string the pet that we want the damage for.
---@param damage_type string a trackable from the model.
---@param percent? boolean whether or not the damage should be raw or percent.
---@param justify? boolean whether or not to right justify the text
---@param all_total? boolean controls denominator for %; true = pet total; false = all total
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.Pet_By_Type = function(player_name, pet_name, damage_type, percent, justify, all_total)
    local focused_damage = DB.Pet_Data.Get(player_name, pet_name, damage_type, DB.Metric.TOTAL)
    local color = Column.String.Color_Zero(focused_damage)
    if percent then
        local total_damage = DB.Data.Get(player_name, DB.Trackable.PET_OVERALL, DB.Metric.TOTAL)
        if all_total then total_damage = DB.Data.Get(player_name, DB.Trackable.TOTAL_DAMAGE, DB.Metric.TOTAL) end
        return UI.TextColored(color, Column.String.Format_Percent(focused_damage, total_damage, justify))
    end
    return UI.TextColored(color, Column.String.Format_Number(focused_damage, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the damage of a certain trackable that the entity's pet has done.
------------------------------------------------------------------------------------------------------
---@param player_name string the entity that owns the pet.
---@param pet_name? string the pet that we want the damage for.
---@param damage_type string a trackable from the model.
---@param justify? boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.Healing_Player = function(player_name, pet_name, damage_type, justify)
    local healing = DB.Data.Get(player_name, damage_type, DB.Metric.TOTAL)
    if pet_name then healing = DB.Pet_Data.Get(player_name, pet_name, damage_type, DB.Metric.TOTAL) end
    local color = Column.String.Color_Zero(healing)
    local player_healing = DB.Data.Get(player_name, DB.Trackable.ALL_HEAL, DB.Metric.TOTAL)
    return UI.TextColored(color, Column.String.Format_Percent(healing, player_healing, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the magic burst damage for the player.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param percent? boolean whether or not the damage should be raw or percent.
---@param magic_only? boolean whether or not the denominator for percent should be total damage or just magic damage.
---@param justify? boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.Burst = function(player_name, percent, magic_only, justify)
    local focused_damage = DB.Data.Get(player_name, DB.Trackable.SPELLS_OVERALL, DB.Metric.MAGIC_BURST_DAMAGE)
    local color = Column.String.Color_Zero(focused_damage)
    if percent then
        local total_damage = Column.Damage.RawTotalPlayerDamage(player_name)
        if magic_only then
            total_damage = DB.Data.Get(player_name, DB.Trackable.SPELLS_OVERALL, DB.Metric.TOTAL)
        end
        return UI.TextColored(color, Column.String.Format_Percent(focused_damage, total_damage, justify))
    end
    return UI.TextColored(color, Column.String.Format_Number(focused_damage, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the total damage that the entity has done.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param percent? boolean whether or not the damage should be raw or percent.
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.Total = function(player_name, percent, justify, raw)
    local grand_total = Column.Damage.RawTotalPlayerDamage(player_name)
    local color = Column.String.Color_Zero(grand_total)

    if percent then
        local party_damage = DB.GetTeamDamage()
        if raw then return Column.String.Format_Percent(grand_total, party_damage) end
        return UI.TextColored(color, Column.String.Format_Percent(grand_total, party_damage, justify))
    end

    if raw then return Column.String.Format_Number(grand_total) end
    return UI.TextColored(color, Column.String.Format_Number(grand_total, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the total damage percentage that the entity has done.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param damage_type string a trackable from the model.
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.Percent_Total_By_Type = function(player_name, damage_type, justify, raw)
    local total = DB.Data.Get(player_name, damage_type, DB.Metric.TOTAL)
    local color = Column.String.Color_Zero(total)
    local team_damage = DB.GetTeamDamageByType(damage_type)
    if raw then return Column.String.Format_Percent(total, team_damage) end
    return UI.TextColored(color, Column.String.Format_Percent(total, team_damage, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the total running damage for the player.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param justify? boolean whether or not to right justify the text
------------------------------------------------------------------------------------------------------
Column.Damage.DPS = function(player_name, justify)
    local dps = DB.DPS.GetDPS(player_name)
    local color = Column.String.Color_Zero(dps)
    return UI.TextColored(color, Column.String.Format_Number(dps, justify))
end

------------------------------------------------------------------------------------------------------
-- Displays the maximum local DPS for a player.
------------------------------------------------------------------------------------------------------
---@param justify? boolean whether or not to right justify the text
------------------------------------------------------------------------------------------------------
Column.Damage.Max_DPS = function(player_name, justify)
    local max_dps = DB.DPS.GetMaxDPS(player_name)
    local color = Column.String.Color_Zero(max_dps)
    return UI.TextColored(color, Column.String.Format_Number(max_dps, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the total damage that the entity has done.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@return number
------------------------------------------------------------------------------------------------------
Column.Damage.RawTotalPlayerDamage = function(player_name)
    if player_name then
        if Parse.Config.IncludeSkillchainDamage() then
            return DB.Data.Get(player_name, DB.Trackable.TOTAL_DAMAGE, DB.Metric.TOTAL)
        else
            return DB.Data.Get(player_name, DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN, DB.Metric.TOTAL)
        end
    end
    return 0
end

------------------------------------------------------------------------------------------------------
-- Calculates total for a trackable across all members of the database.
------------------------------------------------------------------------------------------------------
---@param trackable string
---@param justify? boolean whether or not to right justify the text
------------------------------------------------------------------------------------------------------
Column.Damage.Trackable_Total = function(trackable, justify)
    local damage = 0
    for player_name, _ in pairs(DB.Tracking.InitializedPlayers) do
        damage = damage + DB.Data.Get(player_name, trackable, DB.Metric.TOTAL)
    end
    local color = Column.String.Color_Zero(damage)
    return UI.TextColored(color, Column.String.Format_Number(damage, justify))
end

------------------------------------------------------------------------------------------------------
-- Displays the sum total damage of all members of the database.
------------------------------------------------------------------------------------------------------
---@param justify? boolean whether or not to right justify the text
------------------------------------------------------------------------------------------------------
Column.Damage.Parse_Total = function(justify)
    local damage = DB.GetTeamDamage()
    local color = Column.String.Color_Zero(damage)
    return UI.TextColored(color, Column.String.Format_Number(damage, justify))
end

------------------------------------------------------------------------------------------------------
-- Displays the sum dps of all members of the database.
------------------------------------------------------------------------------------------------------
---@param justify? boolean whether or not to right justify the text
------------------------------------------------------------------------------------------------------
Column.Damage.Parse_DPS = function(justify)
    local dps = 0
    for player_name, _ in pairs(DB.Tracking.InitializedPlayers) do
        dps = dps + DB.DPS.GetDPS(player_name)
    end
    local color = Column.String.Color_Zero(dps)
    return UI.TextColored(color, Column.String.Format_Number(dps, justify))
end

------------------------------------------------------------------------------------------------------
-- Displays the sum dps of all members of the database.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param justify? boolean whether or not to right justify the text
------------------------------------------------------------------------------------------------------
Column.Damage.Shot_Distance = function(player_name, justify)
    local shot_distance = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, DB.Metric.SHOT_DISTANCE)
    if shot_distance then shot_distance = shot_distance / 100 end
    local count = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, DB.Metric.ATTEMPTS_ON_TARGET)
    local color = Column.String.Color_Zero(shot_distance)
    return UI.TextColored(color, Column.String.Format_Percent(shot_distance, count, justify))
end