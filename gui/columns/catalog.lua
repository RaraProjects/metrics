Column.Single = T{}

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs the total amount of damage a cataloged action has done for a given trackable and metric.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param focus_type string a trackable from the model.
---@param metric string a metric from the model.
---@param percent? boolean whether or not the damage should be raw or percent.
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Single.Damage = function(player_name, action_name, focus_type, metric, percent, raw)
    local single_damage
    if metric == DB.Enum.Values.IGNORE then
        single_damage = 0
    else
        single_damage = DB.Catalog.Get(player_name, focus_type, action_name, metric)
    end

    local color = Column.String.Color_Zero(single_damage)
    if percent then
        local total_damage = Column.Damage.Raw_Total_Player_Damage(player_name)
        if raw then return Column.String.Format_Percent(single_damage, total_damage) end
        return UI.TextColored(color, Column.String.Format_Percent(single_damage, total_damage))
    end
    if raw then return Column.String.Format_Number(single_damage) end
    return UI.TextColored(color, Column.String.Format_Number(single_damage))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs the total amount of damage a cataloged action has done for a given trackable and metric.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param focus_type string a trackable from the model.
---@return string
------------------------------------------------------------------------------------------------------
Column.Single.Damage_Per_MP = function(player_name, action_name, focus_type)
    local single_damage = DB.Catalog.Get(player_name, focus_type, action_name, Column.Metric.TOTAL)
    local mp = DB.Catalog.Get(player_name, focus_type, action_name, Column.Metric.MP_SPENT)
    local color = Column.String.Color_Zero(mp)
    if single_damage == 0 or mp == 0 then color = Res.Colors.Basic.DIM end
    return UI.TextColored(color, string.format("%.1f", Column.String.Raw_Percent(single_damage, mp)))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- This is for pet actions.
-- Grabs the total amount of damage a cataloged action has done for a given trackable and metric.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param pet_name string
---@param action_name string
---@param trackable string a trackable from the model.
---@param metric string a metric from the model.
---@param percent? boolean whether or not the damage should be raw or percent.
---@return string
------------------------------------------------------------------------------------------------------
Column.Single.Pet_Damage = function(player_name, pet_name, action_name, trackable, metric, percent)
    local single_damage
    if metric == DB.Enum.Values.IGNORE then
        single_damage = 0
    else
        single_damage = DB.Pet_Catalog.Get(player_name, pet_name, trackable, action_name, metric)
    end
    local color = Column.String.Color_Zero(single_damage)
    if percent then
        local total_damage = DB.Pet_Data.Get(player_name, pet_name, Column.Trackable.TOTAL, Column.Metric.TOTAL)
        return UI.TextColored(color, Column.String.Format_Percent(single_damage, total_damage))
    end
    return UI.TextColored(color, Column.String.Format_Number(single_damage))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs how many times a cataloged action was attempted for a given trackable.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param focus_type string a trackable from the model.
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Single.Attempts = function(player_name, action_name, focus_type, raw)
    local single_attempts = DB.Catalog.Get(player_name, focus_type, action_name, Column.Metric.COUNT)
    local color = Column.String.Color_Zero(single_attempts)
    if raw then return Column.String.Format_Number(single_attempts) end
    return UI.TextColored(color, Column.String.Format_Number(single_attempts))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Returns how much total MP was used for a specific spell.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param focus_type string a trackable from the model.
---@return string
------------------------------------------------------------------------------------------------------
Column.Single.MP_Used = function(player_name, action_name, focus_type)
    local mp = DB.Catalog.Get(player_name, focus_type, action_name, Column.Metric.MP_SPENT)
    local color = Column.String.Color_Zero(mp)
    return UI.TextColored(color, Column.String.Format_Number(mp))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- This is for pet actions.
-- Grabs how many times a cataloged action was attempted for a given trackable.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param pet_name string
---@param action_name string
---@param trackable string a trackable from the model.
---@return string
------------------------------------------------------------------------------------------------------
Column.Single.Pet_Attempts = function(player_name, pet_name, action_name, trackable)
    local single_attempts = DB.Pet_Catalog.Get(player_name, pet_name, trackable, action_name, Column.Metric.COUNT)
    local color = Column.String.Color_Zero(single_attempts)
    return UI.TextColored(color, Column.String.Format_Number(single_attempts))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs how many times a cataloged action was magic burst.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@return string
------------------------------------------------------------------------------------------------------
Column.Single.Bursts = function(player_name, action_name)
    local burst_count = DB.Catalog.Get(player_name, Column.Trackable.NUKE, action_name, Column.Metric.BURST_COUNT)
    local color = Column.String.Color_Zero(burst_count)
    return UI.TextColored(color, Column.String.Format_Number(burst_count))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs how overcure was done with a certain spell.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@return string
------------------------------------------------------------------------------------------------------
Column.Single.Overcure = function(player_name, action_name)
    local overcure = DB.Catalog.Get(player_name, Column.Trackable.HEALING, action_name, Column.Metric.OVERCURE)
    local color = Column.String.Color_Zero(overcure)
    return UI.TextColored(color, Column.String.Format_Number(overcure))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs the accuracy for a given cataloged action and trackable.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param focus_type string a trackable from the model.
---@return string
------------------------------------------------------------------------------------------------------
Column.Single.Acc = function(player_name, action_name, focus_type)
    local single_hits = DB.Catalog.Get(player_name, focus_type, action_name, Column.Metric.HIT_COUNT)
    local single_attempts = DB.Catalog.Get(player_name, focus_type, action_name, Column.Metric.COUNT)
    local color = Column.String.Color_Zero(single_hits)
    return UI.TextColored(color, Column.String.Format_Percent(single_hits, single_attempts))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- This is for pet actions.
-- Grabs the accuracy for a given cataloged action and trackable.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param pet_name string
---@param action_name string
---@param trackable string a trackable from the model.
---@return string
------------------------------------------------------------------------------------------------------
Column.Single.Pet_Acc = function(player_name, pet_name, action_name, trackable)
    local single_hits = DB.Pet_Catalog.Get(player_name, pet_name, trackable, action_name, Column.Metric.HIT_COUNT)
    local single_attempts = DB.Pet_Catalog.Get(player_name, pet_name, trackable, action_name, Column.Metric.COUNT)
    local color = Column.String.Color_Zero(single_hits)
    return UI.TextColored(color, Column.String.Format_Percent(single_hits, single_attempts))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs the usage rate of specfic enspells.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param focus_type string a trackable from the model.
---@param action_name string
---@return string
------------------------------------------------------------------------------------------------------
Column.Single.Hit_Count = function(player_name, focus_type, action_name)
    local procs = DB.Catalog.Get(player_name, focus_type, action_name, Column.Metric.HIT_COUNT)
    local color = Column.String.Color_Zero(procs)
    return UI.TextColored(color, Column.String.Format_Number(procs))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs the average damage for a given cataloged action and trackable.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param focus_type string a trackable from the model.
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Single.Average = function(player_name, action_name, focus_type, raw)
    local single_hits = DB.Catalog.Get(player_name, focus_type, action_name, Column.Metric.HIT_COUNT)
    local color = Column.String.Color_Zero(single_hits)
    if single_hits == 0 then
        if raw then return Column.String.Format_Number(0) end
        return UI.TextColored(color, Column.String.Format_Number(0))
    end
    local single_damage  = DB.Catalog.Get(player_name, focus_type, action_name, Column.Metric.TOTAL)
    local single_average = single_damage / single_hits
    color = Column.String.Color_Zero(single_damage)
    if raw then return Column.String.Format_Number(single_average) end
    return UI.TextColored(color, Column.String.Format_Number(single_average))
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- This is for pet actions.
-- Grabs the average damage for a given cataloged action and trackable.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param pet_name string
---@param action_name string
---@param trackable string a trackable from the model.
---@return string
------------------------------------------------------------------------------------------------------
Column.Single.Pet_Average = function(player_name, pet_name, action_name, trackable)
    local single_hits = DB.Pet_Catalog.Get(player_name, pet_name, trackable, action_name, Column.Metric.HIT_COUNT)
    local single_damage  = DB.Pet_Catalog.Get(player_name, pet_name, trackable, action_name, Column.Metric.TOTAL)
    local color = Column.String.Color_Zero(single_hits)
    if single_hits == 0 or single_damage == 0 then
        color = Res.Colors.Basic.DIM
        return UI.TextColored(color, Column.String.Format_Number(0))
    end
    local single_average = single_damage / single_hits
    return UI.TextColored(color, Column.String.Format_Number(single_average))
end