Column.Acc = {}

------------------------------------------------------------------------------------------------------
-- Calculates text colors.
------------------------------------------------------------------------------------------------------
---@param numerator integer
---@param denominator integer a trackable from the model.
---@param threshold? number whether or not to right justify the text
---@return table
------------------------------------------------------------------------------------------------------
Column.Acc.Color_Selection = function(numerator, denominator, threshold)
    if not threshold then threshold = DB.Settings.Accuracy_Warning end
    local color = Res.Colors.Basic.WHITE
    local percent = Column.String.Raw_Percent(numerator, denominator)
    if percent == 0 then
        color = Res.Colors.Basic.DIM
    elseif percent <= threshold then
        color = Res.Colors.Basic.RED
    end
    return color
end

------------------------------------------------------------------------------------------------------
-- Grabs an entities accuracy for a specific trackable.
-- Accuracy can be broken up into type--like melee and ranged--or melee and ranged combined.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Acc.By_Type = function(player_name, trackable, justify, raw)
    local hit_metric     = DB.Metric.HITS_ON_TARGET
    local attempt_metric = DB.Metric.ATTEMPTS_ON_TARGET
    local hits, attempts

    if trackable == DB.Enum.COMBINED then
        local melee_hits      = DB.Data.Get(player_name, DB.Trackable.MELEE_OVERALL,  hit_metric)
        local melee_attempts  = DB.Data.Get(player_name, DB.Trackable.MELEE_OVERALL,  attempt_metric)
        local ranged_hits     = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, hit_metric)
        local ranged_attempts = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, attempt_metric)
        hits = melee_hits + ranged_hits
        attempts = melee_attempts + ranged_attempts
    else
        hits     = DB.Data.Get(player_name, trackable, hit_metric)
        attempts = DB.Data.Get(player_name, trackable, attempt_metric)
    end
    local color = Column.Acc.Color_Selection(hits, attempts)

    return Column.Output.Percent(hits, attempts, color, justify, raw)
end

------------------------------------------------------------------------------------------------------
-- Grabs the accuracy of a certain trackable that the entity's pet has done.
------------------------------------------------------------------------------------------------------
---@param player_name string the entity that owns the pet.
---@param pet_name string the pet that we want the damage for.
---@param acc_type string a trackable from the model.
---@param justify? boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.Acc.By_Type_Pet = function(player_name, pet_name, acc_type, justify)
    local hit_metric     = DB.Metric.HITS_ON_TARGET
    local attempt_metric = DB.Metric.ATTEMPTS_ON_TARGET

    local hits     = DB.Pet_Data.Get(player_name, pet_name, acc_type, hit_metric)
    local attempts = DB.Pet_Data.Get(player_name, pet_name, acc_type, attempt_metric)
    local color    = Column.Acc.Color_Selection(hits, attempts)

    return Column.Output.Percent(hits, attempts, color, justify)
end


------------------------------------------------------------------------------------------------------
-- Grabs an entity's accuracy for last {X} amount of attempts. Includes melee and ranged combined.
-- {X} is defined in the model's settings.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param justify? boolean
---@return string
------------------------------------------------------------------------------------------------------
Column.Acc.Recent = function(player_name, justify)
    local accuracy = DB.Accuracy.Get(player_name)
    local color    = Column.Acc.Color_Selection(accuracy[1], accuracy[2])
    return Column.Output.Percent(accuracy[1], accuracy[2], color, justify)
end