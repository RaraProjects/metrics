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
    local color = Res.Colors.Basic.WHITE
    local percent = Column.String.Raw_Percent(numerator, denominator)
    if percent == 0 then
        color = Res.Colors.Basic.DIM
    elseif threshold and percent <= threshold then
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
---@param threshold? integer
---@param critical_hit? boolean
---@param action_name? string
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Acc.By_Type = function(player_name, trackable, threshold, critical_hit, action_name, justify, raw)
    local hit_metric     = DB.Metric.HITS_ON_TARGET
    local attempt_metric = DB.Metric.ATTEMPTS_ON_TARGET
    local hits, attempts

    -- Misses don't affect critical hit rates.
    if critical_hit then
        hit_metric     = DB.Metric.CRITICAL_COUNT
        attempt_metric = DB.Metric.HITS_ON_TARGET
        threshold      = 0
    end

    -- Getting melee and ranged combine accuracy.
    if trackable == DB.Enum.COMBINED then
        local melee_hits      = DB.Data.Get(player_name, DB.Trackable.MELEE_OVERALL,  hit_metric)
        local melee_attempts  = DB.Data.Get(player_name, DB.Trackable.MELEE_OVERALL,  attempt_metric)
        local ranged_hits     = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, hit_metric)
        local ranged_attempts = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, attempt_metric)
        hits = melee_hits + ranged_hits
        attempts = melee_attempts + ranged_attempts

    -- Getting the accuracy of an action like a weaponskill.
    elseif action_name then
        hits     = DB.Catalog.Get(player_name, trackable, action_name, hit_metric)
        attempts = DB.Catalog.Get(player_name, trackable, action_name, attempt_metric)

    -- General accuracy of melee or ranged attaack.
    else
        hits     = DB.Data.Get(player_name, trackable, hit_metric)
        attempts = DB.Data.Get(player_name, trackable, attempt_metric)
    end

    -- Colors.
    if not threshold then threshold = DB.Settings.Accuracy_Warning end
    local color = Column.Acc.Color_Selection(hits, attempts, threshold)

    return Column.Output.Percent(hits, attempts, color, false, justify, raw)
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
    local color    = Column.Acc.Color_Selection(hits, attempts, DB.Settings.Accuracy_Warning)

    return Column.Output.Percent(hits, attempts, color, false, justify)
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
---@param on_use? boolean
---@return string
------------------------------------------------------------------------------------------------------
Column.Acc.By_Type_Pet_Catalog = function(player_name, pet_name, action_name, trackable, on_use)
    local hit_metric     = DB.Metric.HITS_ON_TARGET
    local attempt_metric = DB.Metric.ATTEMPTS_ON_TARGET
    if on_use then
        hit_metric     = DB.Metric.HITS_ON_USE
        attempt_metric = DB.Metric.ATTEMPTS_ON_USE
    end

    local hits     = DB.Pet_Catalog.Get(player_name, pet_name, trackable, action_name, hit_metric)
    local attempts = DB.Pet_Catalog.Get(player_name, pet_name, trackable, action_name, attempt_metric)
    local color    = Column.Acc.Color_Selection(hits, attempts, DB.Settings.Accuracy_Warning)

    return Column.Output.Percent(hits, attempts, color)
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
    local color    = Column.Acc.Color_Selection(accuracy[1], accuracy[2], DB.Settings.Accuracy_Warning)
    return Column.Output.Percent(accuracy[1], accuracy[2], color, false, justify)
end

------------------------------------------------------------------------------------------------------
-- Shows how many times an event contained a certain proc'able thing.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param proc_trackable string
---@param event_trackable string
---@return string
------------------------------------------------------------------------------------------------------
Column.Acc.Proc_Per_Use = function(player_name, proc_trackable, event_trackable)
    local proc_use  = DB.Data.Get(player_name, proc_trackable, DB.Metric.HITS_ON_USE)
    local event_use = DB.Data.Get(player_name, event_trackable, DB.Metric.ATTEMPTS_ON_USE)
    local color     = Column.Acc.Color_Selection(proc_use, event_use, 0)
    return Column.Output.Percent(proc_use, event_use, color)
end

------------------------------------------------------------------------------------------------------
-- Grabs the multi attack rate for a specific melee type.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param melee_type string
---@param multi_attack_metric string
---@return string
------------------------------------------------------------------------------------------------------
Column.Acc.Multi_Attack = function(player_name, melee_type, multi_attack_metric)
    local multi_attack  = DB.Data.Get(player_name, melee_type, multi_attack_metric)
    local attack_rounds = DB.Data.Get(player_name, melee_type, DB.Metric.ATTEMPTS_ON_USE)
    local color         = Column.Acc.Color_Selection(multi_attack, attack_rounds, 0)
    return Column.Output.Percent(multi_attack, attack_rounds, color)
end

------------------------------------------------------------------------------------------------------
-- Displays Phantom Roll rates.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param roll_metric string
---@param action_name? string
---@return string
------------------------------------------------------------------------------------------------------
Column.Acc.Phantom_Roll = function(player_name, roll_metric, action_name)
    local trackable = DB.Trackable.PHANTOM_ROLL

    local roll_hits = DB.Data.Get(player_name, trackable, roll_metric)
    if action_name then roll_hits = DB.Catalog.Get(player_name, trackable, action_name, roll_metric) end
    local roll_attempts = DB.Data.Get(player_name, trackable, DB.Metric.ATTEMPTS_ON_TARGET)

    local color = Column.Acc.Color_Selection(roll_hits, roll_attempts, 0)

    return Column.Output.Percent(roll_hits, roll_attempts, color)
end