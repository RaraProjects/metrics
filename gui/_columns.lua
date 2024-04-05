local c = {}

c.Damage = {}
c.Acc = {}
c.Crit = {}
c.Single = {}

c.Mode = Model.Enum.Mode
c.Trackable = Model.Enum.Trackable
c.Metric = Model.Enum.Metric

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
c.Damage.By_Type = function(player_name, damage_type, percent)
    local focused_damage = Model.Get.Data(player_name, damage_type, c.Metric.TOTAL)
    if percent then
        local total_damage = Model.Get.Data(player_name, c.Trackable.TOTAL, c.Metric.TOTAL)
        return Format_Percent(focused_damage, total_damage)
    end
    return Format_Number(focused_damage)
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
c.Damage.Pet_By_Type = function(player_name, pet_name, damage_type, percent)
    local focused_damage = Model.Get.Pet_Data(player_name, pet_name, damage_type, c.Metric.TOTAL)
    if percent then
        local total_damage = Model.Get.Pet_Data(player_name, pet_name, c.Trackable.TOTAL, c.Metric.TOTAL)
        return Format_Percent(focused_damage, total_damage)
    end
    return Format_Number(focused_damage)
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
c.Damage.Total = function(player_name, percent)
    local grand_total = 0
    if Monitor.Settings.Include_SC_Damage then
        grand_total = Model.Get.Data(player_name, c.Trackable.TOTAL, c.Metric.TOTAL)
    else
        grand_total = Model.Get.Data(player_name, c.Trackable.TOTAL_NO_SC, c.Metric.TOTAL)
    end

    if percent then
        local party_damage = Model.Get.Total_Party_Damage()
        return Format_Percent(grand_total, party_damage)
    end

    return Format_Number(grand_total)
end

------------------------------------------------------------------------------------------------------
-- acc_type = melee, ranged, throwing, ws, sc
------------------------------------------------------------------------------------------------------
c.Acc.By_Type = function(player_name, acc_type)
    local hits, attempts
    if acc_type == 'combined' then
        local melee_hits = Model.Get.Data(player_name, c.Trackable.MELEE, c.Metric.HIT_COUNT)
        local melee_attempts = Model.Get.Data(player_name, c.Trackable.MELEE, c.Metric.COUNT)
        local ranged_hits = Model.Get.Data(player_name, c.Trackable.RANGED, c.Metric.HIT_COUNT)
        local ranged_attempts = Model.Get.Data(player_name, c.Trackable.RANGED, c.Metric.COUNT)
        hits = melee_hits + ranged_hits
        attempts = melee_attempts + ranged_attempts
    else
        hits = Model.Get.Data(player_name, acc_type, c.Metric.HIT_COUNT)
        attempts = Model.Get.Data(player_name, acc_type, c.Metric.COUNT)
    end

    if Monitor.Settings.Accuracy_Show_Attempts then
        return Format_Number(attempts)
    end

    return Format_Percent(hits, attempts)
end

------------------------------------------------------------------------------------------------------
-- Accuracy for last X amount of attempts. Includes melee and ranged combined.
------------------------------------------------------------------------------------------------------
c.Acc.Running = function(player_name)
    return Model.Get.Running_Accuracy(player_name)
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
c.Crit.Rate = function(player_name, count)
    local critical_rate = ""
    if Monitor.Display.Flags.Crit then
        local melee_crits  = Model.Get.Data(player_name, c.Trackable.MELEE, c.Metric.CRIT_COUNT)
        local ranged_crits = Model.Get.Data(player_name, c.Trackable.RANGED, c.Metric.CRIT_COUNT)

        if Monitor.Settings.Combine_Crit then
            local final_crits = melee_crits + ranged_crits
            critical_rate = Format_Percent(final_crits, count)
        else
            critical_rate = Format_Percent(melee_crits,  count)
            critical_rate = Format_Percent(ranged_crits, count)
        end
    end
    return critical_rate
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
c.Crit.Focus_Rate = function(player_name, damage_type)
    local crits, attempts
    if damage_type == 'combined' then
        local melee_crits     = Model.Get.Data(player_name, c.Trackable.MELEE, c.Metric.CRIT_COUNT)
        local melee_attempts  = Model.Get.Data(player_name, c.Trackable.MELEE, c.Metric.COUNT)
        local ranged_crits    = Model.Get.Data(player_name, c.Trackable.RANGED, c.Metric.CRIT_COUNT)
        local ranged_attempts = Model.Get.Data(player_name, c.Trackable.RANGED, c.Metric.COUNT)
        crits = melee_crits + ranged_crits
        attempts = melee_attempts + ranged_attempts
    else
        crits = Model.Get.Data(player_name, damage_type, c.Metric.CRIT_COUNT)
        attempts = Model.Get.Data(player_name, damage_type, c.Metric.COUNT)
    end
    return Format_Percent(crits, attempts)
end

------------------------------------------------------------------------------------------------------
-- damage_type = melee, ranged, throwing
------------------------------------------------------------------------------------------------------
c.Crit.Damage = function(player_name, damage_type, percent)
    local crit_damage
    if damage_type == 'combined' then
        local melee_crits  = Model.Get.Data(player_name, c.Trackable.MELEE,  c.Metric.CRIT_DAMAGE)
        local ranged_crits = Model.Get.Data(player_name, c.Trackable.RANGED, c.Metric.CRIT_DAMAGE)
        crit_damage = melee_crits + ranged_crits
    else
        crit_damage = Model.Get.Data(player_name, damage_type, c.Metric.CRIT_DAMAGE)
    end

    if percent then
        local total_damage = Model.Get.Data(player_name, c.Trackable.TOTAL, c.Metric.TOTAL)
        return Format_Percent(crit_damage, total_damage)
    end

    return Format_Number(crit_damage)
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
c.Deaths = function(player_name)
    local death_count = Model.Get.Data(player_name, c.Trackable.DEATH, c.Metric.COUNT)
    return Format_Number(death_count)
end

------------------------------------------------------------------------------------------------------
-- metric = total, min, max
------------------------------------------------------------------------------------------------------
c.Single.Damage = function(player_name, action_name, metric, percent)
    local single_damage
    if metric == 'ignore' then
        single_damage = 0
    else
        single_damage = Model.Get.Catalog(player_name, Focus.Settings.Trackable, action_name, metric)
    end

    if percent then
        local total_damage = Model.Get.Data(player_name, c.Trackable.TOTAL, c.Metric.TOTAL)
        return Format_Percent(single_damage, total_damage)
    end

    return Format_Number(single_damage)
end

------------------------------------------------------------------------------------------------------
-- metric = total, min, max
------------------------------------------------------------------------------------------------------
c.Single.Pet_Damage = function(player_name, pet_name, action_name, trackable, metric, percent)
    local single_damage
    if metric == 'ignore' then
        single_damage = 0
    else
        single_damage = Model.Get.Pet_Catalog(player_name, pet_name, trackable, action_name, metric)
    end

    if percent then
        local total_damage = Model.Get.Pet_Data(player_name, pet_name, c.Trackable.TOTAL, c.Metric.TOTAL)
        return Format_Percent(single_damage, total_damage)
    end

    return Format_Number(single_damage)
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
c.Single.Attempts = function(player_name, action_name)
    local single_attempts = Model.Get.Catalog(player_name, Focus.Settings.Trackable, action_name, c.Metric.COUNT)
    return Format_Number(single_attempts)
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
c.Single.Pet_Attempts = function(player_name, pet_name, action_name, trackable)
    local single_attempts = Model.Get.Pet_Catalog(player_name, pet_name, trackable, action_name, c.Metric.COUNT)
    return Format_Number(single_attempts)
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
c.Single.Acc = function(player_name, action_name)
    local single_hits = Model.Get.Catalog(player_name, Focus.Settings.Trackable, action_name, c.Metric.HIT_COUNT)
    local single_attempts = Model.Get.Catalog(player_name, Focus.Settings.Trackable, action_name, c.Metric.COUNT)
    return Format_Percent(single_hits, single_attempts)
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
c.Single.Pet_Acc = function(player_name, pet_name, action_name, trackable)
    local single_hits = Model.Get.Pet_Catalog(player_name, pet_name, trackable, action_name, c.Metric.HIT_COUNT)
    local single_attempts = Model.Get.Pet_Catalog(player_name, pet_name, trackable, action_name, c.Metric.COUNT)
    return Format_Percent(single_hits, single_attempts)
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
c.Single.Average = function(player_name, action_name)
    local single_attempts = Model.Get.Catalog(player_name, Focus.Settings.Trackable, action_name, c.Metric.COUNT)
    if single_attempts == 0 then
        return Format_Number(0)
    end

    local single_damage  = Model.Get.Catalog(player_name, Focus.Settings.Trackable, action_name, c.Metric.TOTAL)
    local single_average = tonumber(string.format("%d", single_damage / single_attempts))
    return Format_Number(single_average)
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
c.Single.Pet_Average = function(player_name, pet_name, action_name, trackable)
    local single_attempts = Model.Get.Pet_Catalog(player_name, pet_name, trackable, action_name, c.Metric.COUNT)
    if single_attempts == 0 then
        return Format_Number(0)
    end

    local single_damage  = Model.Get.Pet_Catalog(player_name, pet_name, trackable, action_name, c.Metric.TOTAL)
    local single_average = tonumber(string.format("%d", single_damage / single_attempts))
    return Format_Number(single_average)
end

return c