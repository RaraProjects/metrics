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
-- Gets raw hit or proc count.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param damage_type string a trackable from the model.
------------------------------------------------------------------------------------------------------
Column.Defense.Proc_Count = function(player_name, damage_type)
    local proc_count = DB.Data.Get(player_name, damage_type, Column.Metric.HIT_COUNT)
    local color = Column.String.Color_Zero(proc_count)
    return UI.TextColored(color, Column.String.Format_Number(proc_count))
end

------------------------------------------------------------------------------------------------------
-- Gets raw count for a metric.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param damage_type string a trackable from the model.
------------------------------------------------------------------------------------------------------
Column.Defense.Total_Count = function(player_name, damage_type)
    local count = DB.Data.Get(player_name, damage_type, Column.Metric.COUNT)
    local color = Column.String.Color_Zero(count)
    return UI.TextColored(color, Column.String.Format_Number(count))
end