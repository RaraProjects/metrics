local c = {}

c.Damage = {}
c.Acc = {}
c.Crit = {}
c.Single = {}

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
c.Damage.By_Type = function(player_name, damage_type, percent)
    local focused_damage = Model.Get.Data(player_name, damage_type, 'total')
    if percent then
        local total_damage = Model.Get.Data(player_name, 'total', 'total')
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
        grand_total = Model.Get.Data(player_name, 'total', 'total')
    else
        grand_total = Model.Get.Data(player_name, 'total_no_sc', 'total')
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
        local melee_hits = Model.Get.Data(player_name, 'melee', 'hits')
        local melee_attempts = Model.Get.Data(player_name, 'melee', 'count')
        local ranged_hits = Model.Get.Data(player_name, 'ranged', 'hits')
        local ranged_attempts = Model.Get.Data(player_name, 'ranged', 'count')
        hits = melee_hits + ranged_hits
        attempts = melee_attempts + ranged_attempts
    else
        hits = Model.Get.Data(player_name, acc_type, 'hits')
        attempts = Model.Get.Data(player_name, acc_type, 'count')
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
        local melee_crits  = Model.Get.Data(player_name, 'melee', 'crits')
        local ranged_crits = Model.Get.Data(player_name, 'ranged', 'crits')

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
        local melee_crits     = Model.Get.Data(player_name, 'melee', 'crits')
        local melee_attempts  = Model.Get.Data(player_name, 'melee', 'count')
        local ranged_crits    = Model.Get.Data(player_name, 'ranged', 'crits')
        local ranged_attempts = Model.Get.Data(player_name, 'ranged', 'count')
        crits = melee_crits + ranged_crits
        attempts = melee_attempts + ranged_attempts
    else
        crits = Model.Get.Data(player_name, damage_type, 'crits')
        attempts = Model.Get.Data(player_name, damage_type, 'count')
    end
    return Format_Percent(crits, attempts)
end

------------------------------------------------------------------------------------------------------
-- damage_type = melee, ranged, throwing
------------------------------------------------------------------------------------------------------
c.Crit.Damage = function(player_name, damage_type, percent)
    local crit_damage
    if damage_type == 'combined' then
        local melee_crits  = Model.Get.Data(player_name, 'melee',  'crit damage')
        local ranged_crits = Model.Get.Data(player_name, 'ranged', 'crit damage')
        crit_damage = melee_crits + ranged_crits
    else
        crit_damage = Model.Get.Data(player_name, damage_type, 'crit damage')
    end

    if percent then
        local total_damage = Model.Get.Data(player_name, 'total', 'total')
        return Format_Percent(crit_damage, total_damage)
    end

    return Format_Number(crit_damage)
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
c.Deaths = function(player_name)
    local death_count = Model.Get.Data(player_name, 'death', 'count')
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
        local total_damage = Model.Get.Data(player_name, 'total', 'total')
        return Format_Percent(single_damage, total_damage)
    end

    return Format_Number(single_damage)
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
c.Single.Attempts = function(player_name, action_name)
    local single_attempts = Model.Get.Catalog(player_name, Focus.Settings.Trackable, action_name, 'count')
    return Format_Number(single_attempts)
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
c.Single.Acc = function(player_name, action_name)
    local single_hits = Model.Get.Catalog(player_name, Focus.Settings.Trackable, action_name, 'hits')
    local single_attempts = Model.Get.Catalog(player_name, Focus.Settings.Trackable, action_name, 'count')
    return Format_Percent(single_hits, single_attempts)
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
c.Single.Average = function(player_name, action_name)
    local single_attempts = Model.Get.Catalog(player_name, Focus.Settings.Trackable, action_name, 'count')
    if single_attempts == 0 then
        return Format_Number(0)
    end

    local single_damage  = Model.Get.Catalog(player_name, Focus.Settings.Trackable, action_name, 'total')
    local single_average = tonumber(string.format("%d", single_damage / single_attempts))
    return Format_Number(single_average)
end


-- ******************************************************************************************************
-- *
-- *                                                 Data
-- *
-- ******************************************************************************************************

--[[
    DESCRIPTION:
    PARAMETERS :
]]
function Col_Rank(rank, player_name, column_width)
    local color = Col_Color(Is_Me(player_name), C_Bright_Green, C_White)
    return color..' '..rank..'.  '..String_Length(player_name, column_width)
end

--[[
    DESCRIPTION:
    PARAMETERS :
]]
function Col_Color(condition, true_color, false_color)

    if (condition) then
        return true_color
    else
        return false_color
    end

end

--[[
    DESCRIPTION:
    PARAMETERS :
]]
function Col_Debug(debug_type)

    local party = windower.ffxi.get_party()
    if (not party) then return 'ERROR' end
    return Format_Number(Total_Party_Damage(party), Column_Widths['dmg'])

end

return c