Column.Defense = {}

------------------------------------------------------------------------------------------------------
-- Grabs the damage of a certain trackable that the entity has taken.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the model.
---@param percent? boolean whether or not the damage should be raw or percent.
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Defense.DamageTakenByType = function(player_name, trackable, percent, justify, raw)
    local total = DB.Data.Get(player_name, trackable, DB.Metric.TOTAL)

    local color = Column.String.Color_Zero(total)

    if percent then
        local total_damage = DB.Data.Get(player_name, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, DB.Metric.TOTAL)
        if raw then return Column.String.FormatPercent(total, total_damage) end
        return UI.TextColored(color, Column.String.FormatPercent(total, total_damage, justify))
    end

    if raw then return Column.String.FormatNumber(total) end
    return UI.TextColored(color, Column.String.FormatNumber(total, justify))
end

------------------------------------------------------------------------------------------------------
-- Approximates how much damage has been potentially mitigated by the given mitigation type.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the model.
---@param ranged? boolean
---@param justify? boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.Defense.Damage_Mitigation = function(player_name, trackable, ranged, justify)
    -- How many times the damage mitigation has proc'd.
    local procs = DB.Data.Get(player_name, trackable, DB.Metric.HITS_ON_TARGET)
    local color = Column.String.Color_Zero(procs)
    if procs == 0 then return UI.TextColored(color, Column.String.FormatNumber(procs)) end

    -- What is the average unmitigated melee damage? (We ignore ranged evasions here)
    local unmitigated_trackable = DB.Trackable.DEF_UNMITIGATED_MELEE
    if trackable == DB.Trackable.DEF_EVASION_RANGED or trackable == DB.Trackable.DEF_SHADOWS_RANGED then
        unmitigated_trackable = DB.Trackable.DEF_UNMITIGATED_RANGED
    elseif trackable == DB.Trackable.DEF_SHADOWS_MAGIC then
        unmitigated_trackable = DB.Trackable.DEF_UNMITIGATED_MAGIC
    end
    local average_melee = Column.Defense.Average_Damage_By_Type(player_name, unmitigated_trackable, false, true)
    color = Column.String.Color_Zero(average_melee)
    if average_melee == 0 then return UI.TextColored(color, "...") end

    -- What is the average damage for the trackable?
    local average_trackable = Column.Defense.Average_Damage_By_Type(player_name, trackable, false, true)
    if trackable == DB.Trackable.MELEE_COUNTER then average_trackable = 0 end -- Counter reduces damage 100%, but stores counter damage done.

    local damage_mitigated = procs * (average_melee - average_trackable)
    if damage_mitigated < 0 then damage_mitigated = 0 end

    color = Column.String.Color_Zero(damage_mitigated)
    return UI.TextColored(color, Column.String.FormatNumber(damage_mitigated, justify))
end

------------------------------------------------------------------------------------------------------
-- Gets the average amount of damage taken per damage type.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the model.
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return integer
------------------------------------------------------------------------------------------------------
Column.Defense.Average_Damage_By_Type = function(player_name, trackable, justify, raw)
    local count = DB.Data.Get(player_name, trackable, DB.Metric.HITS_ON_TARGET)
    local color = Column.String.Color_Zero(count)

    if count == 0 then
        if raw then return 0 end
        return UI.TextColored(color, "...", justify)
    end

    local damage = DB.Data.Get(player_name, trackable, DB.Metric.TOTAL)
    local average_damage = math.floor(damage / count)

    color = Column.String.Color_Zero(damage)

    if raw then return average_damage end
    return UI.TextColored(color, Column.String.FormatPercent(damage, count, justify, true))
end

------------------------------------------------------------------------------------------------------
-- Calculates how what the DT% is for a given mitigation type.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the model.
---@param justify? boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.Defense.Damage_Reduction = function(player_name, trackable, justify)
    local average_melee = Column.Defense.Average_Damage_By_Type(player_name, DB.Trackable.DEF_UNMITIGATED_MELEE, false, true)
    local color = Column.String.Color_Zero(average_melee)
    if average_melee == 0 then return UI.TextColored(color, "...") end

    local average_reduced_damage = Column.Defense.Average_Damage_By_Type(player_name, trackable, false, true)

    color = Column.String.Color_Zero(average_reduced_damage)

    return UI.TextColored(color, Column.String.FormatPercent(average_melee - average_reduced_damage, average_melee, justify))
end