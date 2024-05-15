Column.Acc = T{}

------------------------------------------------------------------------------------------------------
-- Grabs an entities accuracy for a specific trackable.
-- Accuracy can be broken up into type--like melee and ranged--or melee and ranged combined.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param acc_type string a trackable from the model.
---@param justify? boolean whether or not to right justify the text
---@param count_type? string used for getting ranged square and truestrike rates.
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Acc.By_Type = function(player_name, acc_type, justify, count_type, raw)
    local hits, attempts
    if not count_type then count_type = Column.Metric.HIT_COUNT end
    if acc_type == DB.Enum.Values.COMBINED then
        local melee_hits = DB.Data.Get(player_name, Column.Trackable.MELEE, Column.Metric.HIT_COUNT)
        local melee_attempts = DB.Data.Get(player_name, Column.Trackable.MELEE, Column.Metric.COUNT)
        local ranged_hits = DB.Data.Get(player_name, Column.Trackable.RANGED, Column.Metric.HIT_COUNT)
        local ranged_attempts = DB.Data.Get(player_name, Column.Trackable.RANGED, Column.Metric.COUNT)
        hits = melee_hits + ranged_hits
        attempts = melee_attempts + ranged_attempts
    else
        hits = DB.Data.Get(player_name, acc_type, count_type)
        attempts = DB.Data.Get(player_name, acc_type, Column.Metric.COUNT)
    end

    local color = Res.Colors.Basic.WHITE
    local percent = Column.String.Raw_Percent(hits, attempts)
    if percent == 0 then
        color = Res.Colors.Basic.DIM
    elseif percent <= DB.Settings.Accuracy_Warning then
        color = Res.Colors.Basic.RED
    end

    if raw then return Column.String.Format_Percent(hits, attempts) end
    return UI.TextColored(color, Column.String.Format_Percent(hits, attempts, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the accuracy of a certain trackable that the entity's pet has done.
------------------------------------------------------------------------------------------------------
---@param player_name string the entity that owns the pet.
---@param pet_name string the pet that we want the damage for.
---@param acc_type string a trackable from the model.
---@param justify? boolean whether or not to right justify the text
---@param count_type? string used for getting ranged square and truestrike rates.
---@return string
------------------------------------------------------------------------------------------------------
Column.Acc.Pet_By_Type = function(player_name, pet_name, acc_type, justify, count_type)
    if not count_type then count_type = Column.Metric.HIT_COUNT end
    local hits = DB.Pet_Data.Get(player_name, pet_name, acc_type, count_type)
    local attempts = DB.Pet_Data.Get(player_name, pet_name, acc_type, Column.Metric.COUNT)

    local color = Res.Colors.Basic.WHITE
    local percent = Column.String.Raw_Percent(hits, attempts)
    if percent == 0 then
        color = Res.Colors.Basic.DIM
    elseif percent <= DB.Settings.Accuracy_Warning then
        color = Res.Colors.Basic.RED
    end

    return UI.TextColored(color, Column.String.Format_Percent(hits, attempts, justify))
end


------------------------------------------------------------------------------------------------------
-- Grabs an entity's accuracy for last {X} amount of attempts. Includes melee and ranged combined.
-- {X} is defined in the model's settings.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@return string
------------------------------------------------------------------------------------------------------
Column.Acc.Running = function(player_name)
    local accuracy = DB.Accuracy.Get(player_name)
    local color = Res.Colors.Basic.WHITE
    local percent = Column.String.Raw_Percent(accuracy[1], accuracy[2])

    if percent == 0 then
        color = Res.Colors.Basic.DIM
    elseif percent <= DB.Settings.Accuracy_Warning then
        color = Res.Colors.Basic.RED
    end

    return UI.TextColored(color, Column.String.Format_Percent(accuracy[1], accuracy[2], true))
end