Column.Defense = T{}

------------------------------------------------------------------------------------------------------
-- Grabs the damage of a certain trackable that the entity has taken.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param damage_type string a trackable from the model.
---@param percent? boolean whether or not the damage should be raw or percent.
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Defense.Damage_Taken_By_Type = function(player_name, damage_type, percent, justify, raw)
    local total = DB.Data.Get(player_name, damage_type, Column.Metric.TOTAL)
    local color = Column.String.Color_Zero(total)
    if percent then
        local total_damage = DB.Data.Get(player_name, Column.Trackable.DAMAGE_TAKEN_TOTAL, Column.Metric.TOTAL)
        if raw then return Column.String.Format_Percent(total, total_damage) end
        return UI.TextColored(color, Column.String.Format_Percent(total, total_damage, justify))
    end
    if raw then return Column.String.Format_Number(total) end
    return UI.TextColored(color, Column.String.Format_Number(total, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the proc rate of certain defensive actions.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param damage_type string a trackable from the model.
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Defense.Proc_Rate_By_Type = function(player_name, damage_type, justify, raw)
    local proc_count = DB.Data.Get(player_name, damage_type, Column.Metric.HIT_COUNT)
    local color = Column.String.Color_Zero(proc_count)
    local attack_count = DB.Data.Get(player_name, damage_type, Column.Metric.COUNT)
    if raw then return Column.String.Format_Percent(proc_count, attack_count) end
    return UI.TextColored(color, Column.String.Format_Percent(proc_count, attack_count, justify))
end

------------------------------------------------------------------------------------------------------
-- Approximates how much damage has been potentially mitigated by the given mitigation type.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param mitigation_type string a trackable from the model.
---@param justify? boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.Defense.Damage_Mitigation = function(player_name, mitigation_type, justify)
    local mitigation_proc = DB.Data.Get(player_name, mitigation_type, Column.Metric.HIT_COUNT)
    local color = Column.String.Color_Zero(mitigation_proc)
    if mitigation_proc == 0 then return UI.TextColored(color, Column.String.Format_Number(mitigation_proc)) end

    local average_melee = Column.Defense.Average_Damage_By_Type(player_name, Column.Trackable.DEF_UNMITIGATED, false, true)
    color = Column.String.Color_Zero(average_melee)
    if average_melee == 0 then return UI.TextColored(color, "...") end

    local average_reduced_damage = Column.Defense.Average_Damage_By_Type(player_name, mitigation_type, false, true)
    if mitigation_type == DB.Enum.Trackable.DEF_COUNTER then average_reduced_damage = 0 end -- Counter reduces damage 100%, but stores counter damage done.
    local damage_mitigated = mitigation_proc * (average_melee - average_reduced_damage)
    if damage_mitigated < 0 then damage_mitigated = 0 end
    color = Column.String.Color_Zero(damage_mitigated)
    return UI.TextColored(color, Column.String.Format_Number(damage_mitigated, justify))
end

------------------------------------------------------------------------------------------------------
-- Gets the average amount of damage taken per damage type.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param damage_type string a trackable from the model.
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return integer
------------------------------------------------------------------------------------------------------
Column.Defense.Average_Damage_By_Type = function(player_name, damage_type, justify, raw)
    local count = DB.Data.Get(player_name, damage_type, Column.Metric.HIT_COUNT)
    local color = Column.String.Color_Zero(count)
    if count == 0 then
        if raw then return 0 end
        return UI.TextColored(color, "...", justify)
    end

    local damage = DB.Data.Get(player_name, damage_type, Column.Metric.TOTAL)
    color = Column.String.Color_Zero(damage)
    local average_damage = math.floor(damage / count)
    if raw then return average_damage end
    return UI.TextColored(color, Column.String.Format_Percent(damage, count, justify, true))
end

------------------------------------------------------------------------------------------------------
-- Calculates how what the DT% is for a given mitigation type.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param mitigation_type string a trackable from the model.
---@param justify? boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.Defense.Damage_Reduction = function(player_name, mitigation_type, justify)
    local average_melee = Column.Defense.Average_Damage_By_Type(player_name, Column.Trackable.DEF_UNMITIGATED, false, true)
    local color = Column.String.Color_Zero(average_melee)
    if average_melee == 0 then return UI.TextColored(color, "...") end

    local average_reduced_damage = Column.Defense.Average_Damage_By_Type(player_name, mitigation_type, false, true)
    color = Column.String.Color_Zero(average_reduced_damage)

    return UI.TextColored(color, Column.String.Format_Percent(average_melee - average_reduced_damage, average_melee, justify))
end