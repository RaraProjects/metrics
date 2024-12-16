Column.Proc = {}

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
Column.Proc.Crit_Damage = function(player_name, damage_type, percent, justify)
    local crit_damage
    if damage_type == DB.Enum.COMBINED then
        local melee_crits  = DB.Data.Get(player_name, DB.Trackable.MELEE_OVERALL,  DB.Metric.CRITICAL_DAMAGE)
        local ranged_crits = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, DB.Metric.CRITICAL_DAMAGE)
        crit_damage = melee_crits + ranged_crits
    else
        crit_damage = DB.Data.Get(player_name, damage_type, DB.Metric.CRITICAL_DAMAGE)
    end
    local color = Column.String.Color_Zero(crit_damage)
    if percent then
        local total_damage = Column.Damage.Raw_Total_Player_Damage(player_name)
        return UI.TextColored(color, Column.String.Format_Percent(crit_damage, total_damage, justify))
    end
    return UI.TextColored(color, Column.String.Format_Number(crit_damage, justify))
end

------------------------------------------------------------------------------------------------------
-- Gets the average critical hit damage for a given damage type.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param damage_type string
---@param justify? boolean whether or not to right justify the text.
---@return string
------------------------------------------------------------------------------------------------------
Column.Proc.Crit_Average = function(player_name, damage_type, justify)
    local crit_damage = 0
    local crit_count = 0
    if damage_type == DB.Enum.COMBINED then
        local melee_crits       = DB.Data.Get(player_name, DB.Trackable.MELEE_OVERALL,  DB.Metric.CRITICAL_DAMAGE)
        local melee_crit_count  = DB.Data.Get(player_name, DB.Trackable.MELEE_OVERALL,  DB.Metric.CRITICAL_COUNT)
        local ranged_crits      = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, DB.Metric.CRITICAL_DAMAGE)
        local ranged_crit_count = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, DB.Metric.CRITICAL_COUNT)
        crit_damage = melee_crits + ranged_crits
        crit_count = melee_crit_count + ranged_crit_count
    else
        crit_damage = DB.Data.Get(player_name, damage_type, DB.Metric.CRITICAL_DAMAGE)
        crit_count = DB.Data.Get(player_name, damage_type, DB.Metric.CRITICAL_COUNT)
    end
    local color = Column.String.Color_Zero(crit_damage)
    return UI.TextColored(color, Column.String.Format_Percent(crit_damage, crit_count, justify, true))
end

------------------------------------------------------------------------------------------------------
-- Grabs how many times an entity has died.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param justify? boolean whether or not to right justify the text.
---@return string
------------------------------------------------------------------------------------------------------
Column.Proc.Deaths = function(player_name, justify)
    local death_count = DB.Data.Get(player_name, DB.Trackable.DEATH, DB.Metric.ATTEMPTS_ON_USE)
    local color = Column.String.Color_Zero(death_count)
    return UI.TextColored(color, Column.String.Format_Number(death_count, justify))
end

------------------------------------------------------------------------------------------------------
-- Gets the proc rate for ranged attack distance corrections (square hit or true strike).
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param correction_type string
---@param justify? boolean
---@return string
------------------------------------------------------------------------------------------------------
Column.Proc.Distance_Correction = function(player_name, correction_type, justify)
    local ranged_shots = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, DB.Metric.ATTEMPTS_ON_USE)
    local correction_hits = DB.Data.Get(player_name, correction_type, DB.Metric.HITS_ON_USE)
    local color = Column.String.Color_Zero(correction_hits)
    if ranged_shots == 0 or correction_hits == 0 then return UI.TextColored(color, Column.String.Format_Number(0, justify)) end
    return UI.TextColored(color, Column.String.Format_Percent(correction_hits, ranged_shots))
end