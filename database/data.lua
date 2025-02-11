DB.Data = {}

------------------------------------------------------------------------------------------------------
-- Initializes the primary player data nodes and other tracking globals.
-- The core nodes for initialization are [player_name][target_name].
------------------------------------------------------------------------------------------------------
---@param player_name string In the case of pets this will be the owner. This will never be a mob name.
---@param target_name string The entity receiving the action of the player.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Data.Initialize = function(player_name, target_name)
	-- Early quit out to prevent crashing.
	local caller = "DB.Data.Initialize"
	if DB.IsValueEmpty(caller, player_name, "Player") then return false end
	if DB.IsValueEmpty(caller, target_name, "Target") then return false end

	-- Don't want to overwrite data node if it already exists. This is for mob specfic data.
	local initialization_list = {}
	if not DB.Parse[player_name] then DB.Parse[player_name] = {} end
	if not DB.Parse[player_name][target_name] then
		DB.Parse[player_name][target_name] = {}
		table.insert(initialization_list, target_name)
	end

	-- Don't want to overwrite data node if it already exists. This is for all mob data.
	local all_mobs = DB.Enum.ALL_MOBS
	if not DB.Parse[player_name][all_mobs] then
		DB.Parse[player_name][all_mobs] = {}
		table.insert(initialization_list, all_mobs)
	end

	-- Initialize data nodes.
	-- Need to set minimum high manually to capture accurate minimums.
	if #initialization_list == 0 then return false end
	for _, initialization_target in ipairs(initialization_list) do
		for _, trackable in pairs(DB.Trackable) do

			DB.Parse[player_name][initialization_target][trackable] = {}
			for _, metric in pairs(DB.Metric) do
				if DB.MetricNeedsMaxValue(metric) then
					DB.Data.Set(DB.Enum.MAX_DAMAGE, player_name, initialization_target, trackable, metric)
				else
					DB.Data.Set(0, player_name, initialization_target, trackable, metric)
				end
			end

		end
	end

	DB.Data.Initialize_Player_Tracking_Tables(player_name)

	return true
end

------------------------------------------------------------------------------------------------------
-- Initializes various parallel tracking globals based on the player.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
DB.Data.Initialize_Player_Tracking_Tables = function(player_name)
	if player_name and player_name ~= "" and not DB.Tracking.InitializedPlayers[player_name] then
		DB.Tracking.InitializedPlayers[player_name] = true
		DB.Lists.Sort.Players()
		DB.Tracking.RunningAccuracy[player_name] = {}
		DB.Tracking.RunningDamage[player_name] = 0
		DB.Tracking.RunningAttackSpeed[player_name] = {}
		DB.Tracking.MultiAttack[player_name] = {}
	end
end

------------------------------------------------------------------------------------------------------
-- A handler function that makes sure the data is set appropriately.
-- This does not set data directly. Rather, it calls the Set~ or Inc~ functions.
------------------------------------------------------------------------------------------------------
---@param mode string flag calling out whether the data should be set or incremented.
---@param value number the value to set or increment the node to/by.
---@param audits table Contains necessary data; helps save on parameter slots.
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
------------------------------------------------------------------------------------------------------
DB.Data.Update = function(mode, value, audits, trackable, metric)
	local caller = "DB.Data.Update"

	if not audits then
		Debug.Error.Add(Debug.Error.ERROR, caller, "Nil audits passed in.")
		return nil
	end

	local player_name = audits.player_name
	local target_name = audits.target_name
	local pet_name    = audits.pet_name

	if DB.IsValueEmpty(caller, player_name, "Player") then return nil end
	if DB.IsValueEmpty(caller, target_name, "Target") then return nil end

	DB.Data.Initialize(player_name, target_name)
	if pet_name then DB.Pet_Data.Initialize(player_name, pet_name, target_name) end

	-- Set the data; loop once for mob-specific data and a second time for all mob data.
	local update_list = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

	for _, update_target in ipairs(update_list) do
		if mode == DB.UpdateMode.INC then
			DB.Data.Inc(value, player_name, update_target, trackable, metric)
			if pet_name then
				DB.Pet_Data.Inc(value, player_name, pet_name, update_target, trackable, metric)
			end
		elseif mode == DB.UpdateMode.SET then
			DB.Data.Set(value, player_name, update_target, trackable, metric)
			if pet_name then
				DB.Pet_Data.Set(value, player_name, pet_name, update_target, trackable, metric)
			end
		end
	end

	-- Increment the running damage count for DPS if this is a total damage increase.
	if mode == DB.UpdateMode.INC and trackable == DB.Trackable.TOTAL_DAMAGE and metric == DB.Metric.TOTAL then DB.DPS.Inc_Buffer(player_name, value) end
end

------------------------------------------------------------------------------------------------------
-- Handles the primary database portion of damage updates.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param trackable string a tracked item from the trackable list.
---@param damage number damage value to be logged.
---@param critical_hit? boolean whether or not a critical hit or magic burst took place.
------------------------------------------------------------------------------------------------------
DB.Data.UpdateDamage = function(audits, trackable, damage, critical_hit)
	-- Increment grand totals if necessary. There is an all damage track and a no-skillchain track.
    if DB.IsTotalDamageTrackable(trackable) then
    	DB.Data.Update(DB.UpdateMode.INC, damage, audits, DB.Trackable.TOTAL_DAMAGE, DB.Metric.TOTAL)
		DB.TotalDamage = DB.TotalDamage + damage
		if trackable ~= DB.Trackable.SKILLCHAIN then
			DB.Data.Update(DB.UpdateMode.INC, damage, audits, DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN, DB.Metric.TOTAL)
			DB.TotalDamageNoSkillchain = DB.TotalDamageNoSkillchain + damage
		end
    end

	DB.Data.Update_Damage_Basic(audits, trackable, damage, critical_hit)
end

------------------------------------------------------------------------------------------------------
-- Sets the minimum and maximum values.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param trackable string a tracked item from the trackable list.
---@param damage number damage value to be logged.
---@param critical_hit? boolean
------------------------------------------------------------------------------------------------------
DB.Data.Update_Damage_Basic = function(audits, trackable, damage, critical_hit)
	-- Increment the trackable specific totals.
    DB.Data.Update(DB.UpdateMode.INC, damage, audits, trackable, DB.Metric.TOTAL)

	if critical_hit then
		DB.Data.Update(DB.UpdateMode.INC,      1, audits, trackable, DB.Metric.CRITICAL_COUNT)
    	DB.Data.Update(DB.UpdateMode.INC, damage, audits, trackable, DB.Metric.CRITICAL_DAMAGE)
	end

	-- Log an attempt on the target.
	DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS_ON_TARGET)

	-- Set trackable hits and minimums
	local min_metric = (critical_hit and DB.Metric.CRITICAL_MIN) or DB.Metric.MIN
	local max_metric = (critical_hit and DB.Metric.CRITICAL_MAX) or DB.Metric.MAX

	-- We can't log a miss (0 damage) to MIN because then the miminum will always be zero.
	-- We log a hit on the target here too since we have a damage check.
	if damage > 0 then
		DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.HITS_ON_TARGET)
		if audits.pet_name then
			if damage < DB.Pet_Data.Get(audits.player_name, audits.pet_name, trackable, min_metric, audits.target_name) then
				DB.Data.Update(DB.UpdateMode.SET, damage, audits, trackable, min_metric)
			end
		else
			if damage < DB.Data.Get(audits.player_name, trackable, min_metric, audits.target_name) then
				DB.Data.Update(DB.UpdateMode.SET, damage, audits, trackable, min_metric)
			end
		end
	end

	-- Set trackable maximums
	if damage > DB.Data.Get(audits.player_name, trackable, max_metric, audits.target_name) then
		DB.Data.Update(DB.UpdateMode.SET, damage, audits, trackable, max_metric)
	end
end

------------------------------------------------------------------------------------------------------
-- Directly sets a trackable's metric to a specified value.
-- This is primarily used for initialization and minimum/maximum metrics.
------------------------------------------------------------------------------------------------------
---@param value number the value to set the node to.
---@param player_name string
---@param target_name string
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Data.Set = function(value, player_name, target_name, trackable, metric)
	-- Early quit out to prevent crashing.
	-- Can't quit out early for blank metric nodes because this is used for initialization.
	local caller = "DB.Data.Set"
	if DB.IsValueEmpty(caller, player_name, "Player")    then return false end
	if DB.IsValueEmpty(caller, target_name, "Target")    then return false end
	if DB.IsValueEmpty(caller, trackable,   "Trackable") then return false end
	if DB.IsValueEmpty(caller, metric,      "Metric")    then return false end
	if DB.IsValueEmpty(caller, value,       "Value")     then return false end
	if not DB.Data.Is_Index_Node_Initialized(caller, true, player_name, target_name) then return false end

	-- Don't set an unfiltered minimum if the mob specific minimum isn't less than the unfiltered one.
	if DB.MetricNeedsMaxValue(metric) and target_name == DB.Enum.ALL_MOBS
	and DB.Parse[player_name][target_name][trackable][metric]
	and value >= DB.Parse[player_name][target_name][trackable][metric] then
		return false
	end

	-- Apply the change.
	DB.Parse[player_name][target_name][trackable][metric] = value

	return true
end

------------------------------------------------------------------------------------------------------
-- Increments a trackable's metric by a specified amount.
------------------------------------------------------------------------------------------------------
---@param value number the value to increment the node by.
---@param player_name string
---@param target_name string
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Data.Inc = function(value, player_name, target_name, trackable, metric)
	-- Early quit out to prevent crashing.
	local caller = "DB.Data.Inc"
	if DB.IsValueEmpty(caller, player_name, "Player")    then return false end
	if DB.IsValueEmpty(caller, target_name, "Target")    then return false end
	if DB.IsValueEmpty(caller, trackable,   "Trackable") then return false end
	if DB.IsValueEmpty(caller, metric,      "Metric")    then return false end
	if DB.IsValueEmpty(caller, value,       "Value")     then return false end
	if not DB.Data.Is_Index_Node_Initialized(caller, true, player_name, target_name) then return false end
	if not DB.Data.Is_Metric_Node_Initialized(caller, true, player_name, target_name, trackable, metric) then return false end

	-- Apply the change.
	DB.Parse[player_name][target_name][trackable][metric] = DB.Parse[player_name][target_name][trackable][metric] + value

	return true
end

------------------------------------------------------------------------------------------------------
-- Gets data from a trackable metric.
-- If the mob filter is set then only actions towards that mob are counted.
------------------------------------------------------------------------------------------------------
---@param player_name string the player or entity name to search data for.
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
---@param temporary_mob_focus? string used to force look for a specific mob (mainly for setting minimums for AOEs).
---@return number
------------------------------------------------------------------------------------------------------
DB.Data.Get = function(player_name, trackable, metric, temporary_mob_focus)
	local caller = "DB.Data.Get"
	if DB.IsValueEmpty(caller, player_name, "Player")    then return 0 end
	if DB.IsValueEmpty(caller, trackable,   "Trackable") then return 0 end
	if DB.IsValueEmpty(caller, metric,      "Metric")    then return 0 end

	-- Dont get new data unless we are in a new throttle cycle or cached data doesn't exist.
	if (Throttle.Is_Enabled() and not Throttle.Allow_Calculation()) and not temporary_mob_focus then
		if DB.Cache[player_name] and DB.Cache[player_name][trackable] and DB.Cache[player_name][trackable][metric] then
			return DB.Cache[player_name][trackable][metric]
		end
	end

	-- The target index will just be the mob focus unless a temporary focus is passed in.
	-- The mob focus will handle the ALL_MOBS too.
	local value = 0
	if DB.MetricNeedsMaxValue(metric) then value = DB.Enum.MAX_DAMAGE end
	local mob_focus = DB.Widgets.Util.Get_Mob_Focus()
	local target_index = mob_focus
	if temporary_mob_focus then target_index = temporary_mob_focus end

	-- Get the data.
	if DB.Data.Is_Index_Node_Initialized(caller, false, player_name, target_index) then
		if DB.Data.Is_Metric_Node_Initialized(caller, false, player_name, target_index, trackable, metric) then
			value = DB.Parse[player_name][target_index][trackable][metric]
		end
	end

	-- Cache for performance.
	if not DB.Cache[player_name] then DB.Cache[player_name] = {} end
	if not DB.Cache[player_name][trackable] then DB.Cache[player_name][trackable] = {} end
	DB.Cache[player_name][trackable][metric] = value

	return value
end

------------------------------------------------------------------------------------------------------
-- Checks if the [player_name][target_name] nodes are initialized in the primary database.
------------------------------------------------------------------------------------------------------
---@param caller string
---@param write_error boolean
---@param player_name string
---@param target_name string
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Data.Is_Index_Node_Initialized = function(caller, write_error, player_name, target_name)
	if not DB.Parse or not DB.Parse[player_name] or not DB.Parse[player_name][target_name] then
		if write_error then
			Debug.Error.Add(Debug.Error.ERROR, caller, "Not initialized in DB.Parse[" .. tostring(player_name) .. "][" .. tostring(target_name) .. "].")
		end
		return false
	end
	return true
end

------------------------------------------------------------------------------------------------------
-- Checks if the [player_name][target_name][trackable][metric] nodes are initialized in the primary database.
------------------------------------------------------------------------------------------------------
---@param caller string
---@param write_error boolean
---@param player_name string
---@param target_name string
---@param trackable string
---@param metric string
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Data.Is_Metric_Node_Initialized = function(caller, write_error, player_name, target_name, trackable, metric)
	if not DB.Parse or not DB.Parse[player_name] or not DB.Parse[player_name][target_name] then
		if write_error then
			Debug.Error.Add(Debug.Error.ERROR, caller, "Metric not initialized in DB.Parse[" .. tostring(player_name)
			.. "][" .. tostring(target_name) .. "][" .. tostring(trackable) .. "][" .. tostring(metric) .. "].")
		end
		return false
	end
	return true
end