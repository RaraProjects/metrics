local c = {}

c.Damage = {}
c.Healing = {}
c.Acc = {}
c.Crit = {}
c.Single = {}
c.String = {}
c.Util = {}

-- Easier reference for Model's ENUMs.
c.Mode = Model.Enum.Mode
c.Trackable = Model.Enum.Trackable
c.Metric = Model.Enum.Metric

------------------------------------------------------------------------------------------------------
-- Grabs the damage of a certain trackable that the entity has done.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param damage_type string a trackable from the model.
---@param percent? boolean whether or not the damage should be raw or percent.
---@return string a
------------------------------------------------------------------------------------------------------
c.Damage.By_Type = function(player_name, damage_type, percent)
    local focused_damage = Model.Get.Data(player_name, damage_type, c.Metric.TOTAL)
    if percent then
        local total_damage = c.Util.Total_Damage(player_name)
        return c.String.Format_Percent(focused_damage, total_damage)
    end
    return c.String.Format_Number(focused_damage)
end

------------------------------------------------------------------------------------------------------
-- Grabs the damage of a certain trackable that the entity's pet has done.
------------------------------------------------------------------------------------------------------
---@param player_name string the entity that owns the pet.
---@param pet_name string the pet that we want the damage for.
---@param damage_type string a trackable from the model.
---@param percent? boolean whether or not the damage should be raw or percent.
---@return string
------------------------------------------------------------------------------------------------------
c.Damage.Pet_By_Type = function(player_name, pet_name, damage_type, percent)
    local focused_damage = Model.Get.Pet_Data(player_name, pet_name, damage_type, c.Metric.TOTAL)
    if percent then
        local total_damage = Model.Get.Pet_Data(player_name, pet_name, c.Trackable.TOTAL, c.Metric.TOTAL)
        return c.String.Format_Percent(focused_damage, total_damage)
    end
    return c.String.Format_Number(focused_damage)
end

------------------------------------------------------------------------------------------------------
-- Grabs the magic burst damage for the player.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param percent? boolean whether or not the damage should be raw or percent.
---@param magic_only? boolean whether or not the denominator for percent should be total damage or just magic damage.
---@return string
------------------------------------------------------------------------------------------------------
c.Damage.Burst = function(player_name, percent, magic_only)
    local focused_damage = Model.Get.Data(player_name, Model.Enum.Trackable.MAGIC, c.Metric.BURST_DAMAGE)
    if percent then
        local total_damage = c.Util.Total_Damage(player_name)
        if magic_only then
            total_damage = Model.Get.Data(player_name, c.Trackable.MAGIC, c.Metric.TOTAL)
        end
        return c.String.Format_Percent(focused_damage, total_damage)
    end
    return c.String.Format_Number(focused_damage)
end

------------------------------------------------------------------------------------------------------
-- Grabs the overcure amount for the player.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@return string
------------------------------------------------------------------------------------------------------
c.Healing.Overcure = function(player_name)
    return c.String.Format_Number(Model.Get.Data(player_name, Model.Enum.Trackable.HEALING, c.Metric.OVERCURE))
end

------------------------------------------------------------------------------------------------------
-- Grabs the total damage that the entity has done.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param percent? boolean whether or not the damage should be raw or percent.
---@return string
------------------------------------------------------------------------------------------------------
c.Damage.Total = function(player_name, percent)
    local grand_total = c.Util.Total_Damage(player_name)
    if percent then
        local party_damage = Model.Get.Total_Party_Damage()
        return c.String.Format_Percent(grand_total, party_damage)
    end
    return c.String.Format_Number(grand_total)
end

------------------------------------------------------------------------------------------------------
-- Grabs the total damage that the entity has done.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@return number
------------------------------------------------------------------------------------------------------
c.Util.Total_Damage = function(player_name)
    if player_name then
        if Team.Settings.Include_SC_Damage then
            return Model.Get.Data(player_name, c.Trackable.TOTAL, c.Metric.TOTAL)
        else
            return Model.Get.Data(player_name, c.Trackable.TOTAL_NO_SC, c.Metric.TOTAL)
        end
    end
    return 0
end

------------------------------------------------------------------------------------------------------
-- Grabs an entities accuracy for a specific trackable.
-- Accuracy can be broken up into type--like melee and ranged--or melee and ranged combined.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param acc_type string a trackable from the model.
---@return string
------------------------------------------------------------------------------------------------------
c.Acc.By_Type = function(player_name, acc_type)
    local hits, attempts
    if acc_type == Model.Enum.Misc.COMBINED then
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

    if Team.Settings.Accuracy_Show_Attempts then
        return c.String.Format_Number(attempts)
    end

    return c.String.Format_Percent(hits, attempts)
end

------------------------------------------------------------------------------------------------------
-- Grabs an entity's accuracy for last {X} amount of attempts. Includes melee and ranged combined.
-- {X} is defined in the model's settings.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@return string
------------------------------------------------------------------------------------------------------
c.Acc.Running = function(player_name)
    local accuracy = Model.Get.Running_Accuracy(player_name)
    return c.String.Format_Percent(accuracy[1], accuracy[2])
end

------------------------------------------------------------------------------------------------------
-- Grabs an entity's critical hit rate for a given trackable.
-- Can also give combine melee/ranged crit rate.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param damage_type string a trackable from the model.
---@return string
------------------------------------------------------------------------------------------------------
c.Crit.Rate = function(player_name, damage_type)
    local crits, attempts
    if damage_type == Model.Enum.Misc.COMBINED then
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
    return c.String.Format_Percent(crits, attempts)
end

------------------------------------------------------------------------------------------------------
-- Grabs an entity's critical hit damage for a given trackable.
-- Can also give combine melee/ranged crit damage.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param damage_type string
---@param percent? boolean whether or not the damage should be raw or percent.
---@return string
------------------------------------------------------------------------------------------------------
c.Crit.Damage = function(player_name, damage_type, percent)
    local crit_damage
    if damage_type == Model.Enum.Misc.COMBINED then
        local melee_crits  = Model.Get.Data(player_name, c.Trackable.MELEE,  c.Metric.CRIT_DAMAGE)
        local ranged_crits = Model.Get.Data(player_name, c.Trackable.RANGED, c.Metric.CRIT_DAMAGE)
        crit_damage = melee_crits + ranged_crits
    else
        crit_damage = Model.Get.Data(player_name, damage_type, c.Metric.CRIT_DAMAGE)
    end

    if percent then
        local total_damage = c.Util.Total_Damage(player_name)
        return c.String.Format_Percent(crit_damage, total_damage)
    end

    return c.String.Format_Number(crit_damage)
end

------------------------------------------------------------------------------------------------------
-- Grabs how many times an entity has died.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@return string
------------------------------------------------------------------------------------------------------
c.Deaths = function(player_name)
    local death_count = Model.Get.Data(player_name, c.Trackable.DEATH, c.Metric.COUNT)
    return c.String.Format_Number(death_count)
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs the total amount of damage a cataloged action has done for a given trackable and metric.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param focus_type string a trackable from the model.
---@param metric string a metric from the model.
---@param percent? boolean whether or not the damage should be raw or percent.
---@return string
------------------------------------------------------------------------------------------------------
c.Single.Damage = function(player_name, action_name, focus_type, metric, percent)
    local single_damage
    if metric == Model.Enum.Misc.IGNORE then
        single_damage = 0
    else
        single_damage = Model.Get.Catalog(player_name, focus_type, action_name, metric)
    end

    if percent then
        local total_damage = c.Util.Total_Damage(player_name)
        return c.String.Format_Percent(single_damage, total_damage)
    end

    return c.String.Format_Number(single_damage)
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
c.Single.Pet_Damage = function(player_name, pet_name, action_name, trackable, metric, percent)
    local single_damage
    if metric == Model.Enum.Misc.IGNORE then
        single_damage = 0
    else
        single_damage = Model.Get.Pet_Catalog(player_name, pet_name, trackable, action_name, metric)
    end

    if percent then
        local total_damage = Model.Get.Pet_Data(player_name, pet_name, c.Trackable.TOTAL, c.Metric.TOTAL)
        return c.String.Format_Percent(single_damage, total_damage)
    end

    return c.String.Format_Number(single_damage)
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs how many times a cataloged action was attempted for a given trackable.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param focus_type string a trackable from the model.
---@return string
------------------------------------------------------------------------------------------------------
c.Single.Attempts = function(player_name, action_name, focus_type)
    local single_attempts = Model.Get.Catalog(player_name, focus_type, action_name, c.Metric.COUNT)
    return c.String.Format_Number(single_attempts)
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
c.Single.Pet_Attempts = function(player_name, pet_name, action_name, trackable)
    local single_attempts = Model.Get.Pet_Catalog(player_name, pet_name, trackable, action_name, c.Metric.COUNT)
    return c.String.Format_Number(single_attempts)
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs how many times a cataloged action was magic burst.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@return string
------------------------------------------------------------------------------------------------------
c.Single.Bursts = function(player_name, action_name)
    local burst_count = Model.Get.Catalog(player_name, Model.Enum.Trackable.MAGIC, action_name, c.Metric.BURST_COUNT)
    return c.String.Format_Number(burst_count)
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs how overcure was done with a certain spell.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@return string
------------------------------------------------------------------------------------------------------
c.Single.Overcure = function(player_name, action_name)
    local overcure = Model.Get.Catalog(player_name, Model.Enum.Trackable.HEALING, action_name, c.Metric.OVERCURE)
    return c.String.Format_Number(overcure)
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
c.Single.Acc = function(player_name, action_name, focus_type)
    local single_hits = Model.Get.Catalog(player_name, focus_type, action_name, c.Metric.HIT_COUNT)
    local single_attempts = Model.Get.Catalog(player_name, focus_type, action_name, c.Metric.COUNT)
    return c.String.Format_Percent(single_hits, single_attempts)
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
c.Single.Pet_Acc = function(player_name, pet_name, action_name, trackable)
    local single_hits = Model.Get.Pet_Catalog(player_name, pet_name, trackable, action_name, c.Metric.HIT_COUNT)
    local single_attempts = Model.Get.Pet_Catalog(player_name, pet_name, trackable, action_name, c.Metric.COUNT)
    return c.String.Format_Percent(single_hits, single_attempts)
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Grabs the average damage for a given cataloged action and trackable.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param focus_type string a trackable from the model.
---@return string
------------------------------------------------------------------------------------------------------
c.Single.Average = function(player_name, action_name, focus_type)
    local single_attempts = Model.Get.Catalog(player_name, focus_type, action_name, c.Metric.COUNT)
    if single_attempts == 0 then
        return c.String.Format_Number(0)
    end

    local single_damage  = Model.Get.Catalog(player_name, focus_type, action_name, c.Metric.TOTAL)
    local single_average = single_damage / single_attempts
    return c.String.Format_Number(single_average)
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
c.Single.Pet_Average = function(player_name, pet_name, action_name, trackable)
    local single_attempts = Model.Get.Pet_Catalog(player_name, pet_name, trackable, action_name, c.Metric.COUNT)
    if single_attempts == 0 then
        return c.String.Format_Number(0)
    end

    local single_damage  = Model.Get.Pet_Catalog(player_name, pet_name, trackable, action_name, c.Metric.TOTAL)
    local single_average = single_damage / single_attempts
    return c.String.Format_Number(single_average)
end

------------------------------------------------------------------------------------------------------
-- Create a nicely formatted number string.
-- I floor the number to get rid of any decimals. Decimals were a problem with the average column.
------------------------------------------------------------------------------------------------------
---@param number number this should be an actual number and not a string.
---@return string
------------------------------------------------------------------------------------------------------
c.String.Format_Number = function(number)
    if Team.Settings.Condensed_Numbers then return c.String.Compact_Number(number) end
    number = math.floor(number)
    return c.String.Add_Comma(number)
end

------------------------------------------------------------------------------------------------------
-- Calculates and formats a percent.
------------------------------------------------------------------------------------------------------
---@param numerator number The numerator for the percent.
---@param denominator number The denominator for the percent.
------------------------------------------------------------------------------------------------------
c.String.Format_Percent = function(numerator, denominator)
    if not denominator or denominator == 0 then return "0" end
    local percent = (numerator / denominator) * 100
    if percent == 0 then return "0" end
    local percent_string = string.format("%.1f", percent)
    return tostring(percent_string)
end

------------------------------------------------------------------------------------------------------
-- Handles formatting numbers into a more compact easier to read mode (with rounding).
-- Mode examples: Compact = 2.5M; Regular = 2,500,000
------------------------------------------------------------------------------------------------------
---@param number number this should be an actual number and not a string.
---@return string
------------------------------------------------------------------------------------------------------
c.String.Compact_Number = function(number)
    number = number or 0

    local display_number, suffix
    local format = true

    -- Millions
    if number >= 1000000 then
        display_number = (number / 1000000)
        suffix = " M"

    -- Thousands
    elseif number >= 1000 then
        display_number = (number / 1000)
        suffix = " K"

    -- No adjustments necessary
    else
        display_number = number
        suffix = ""
        format = false
    end

    if number == 0 then return tostring(number) end

    if format then display_number = string.format("%.1f", display_number) end
    display_number = display_number..suffix

    return tostring(display_number)
end



------------------------------------------------------------------------------------------------------
-- Adds commas to large numbers for easier readability.
------------------------------------------------------------------------------------------------------
---@param number number the number to be formatted with commas.
---@return string
------------------------------------------------------------------------------------------------------
c.String.Add_Comma = function(number)
    -- Take the string apart
    local str = tostring(number)
    local length = string.len(str)
    local numbers = {}
    for i = 1, length, 1 do numbers[i] = string.byte(str, i) end

    -- Rebuild adding a comma after every third number
    local new_str = ""
    local count = 0
    for i = length, 1, -1 do
        if count > 0 and (count % 3) == 0 then new_str = ","  ..  new_str end
        new_str = string.char(numbers[i]) .. new_str
        count = count + 1
    end

    return new_str
end

return c