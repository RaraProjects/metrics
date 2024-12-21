DB.Pet_Data = {}

------------------------------------------------------------------------------------------------------
-- Initializes an [actor:target][pet_name] combination in the primary data node and catalog nodes.
-- Also initializes separate tracking globals for Running Accuracy.
-- If the "actor:target" combo has already been initialized then this will quit out early.
-- CALLED BY: Init.Data
------------------------------------------------------------------------------------------------------
---@param player_name string used for maintaining various player indexed tables. In the case of pets this will be the owner.
---@param pet_name string used for maintaining various pet indexed tables.
---@param target_name string
------------------------------------------------------------------------------------------------------
DB.Pet_Data.Initialize = function(player_name, pet_name, target_name)
	-- Early quit out to prevent crashing.
	local caller = "DB.Pet_Data.Initialize"
	if DB.Is_Value_Empty(caller, player_name, "Player") then return false end
	if DB.Is_Value_Empty(caller, target_name, "Target") then return false end
	if DB.Is_Value_Empty(caller, pet_name,    "Pet")    then return false end

	-- Don't want to overwrite data node if it already exists. This is for mob specfic data.
	local initialization_list = {}
	if not DB.Pet_Parse[player_name] then DB.Pet_Parse[player_name] = {} end
	if not DB.Pet_Parse[player_name][pet_name] then DB.Pet_Parse[player_name][pet_name] = {} end
	if not DB.Pet_Parse[player_name][pet_name][target_name] then
		DB.Pet_Parse[player_name][pet_name][target_name] = {}
		table.insert(initialization_list, target_name)
	end

	-- Don't want to overwrite data node if it already exists. This is for all mob data.
	local all_mobs = DB.Enum.ALL_MOBS
	if not DB.Pet_Parse[player_name][pet_name] then DB.Pet_Parse[player_name][pet_name] = {} end
	if not DB.Pet_Parse[player_name][pet_name][all_mobs] then
		DB.Pet_Parse[player_name][pet_name][all_mobs] = {}
		table.insert(initialization_list, all_mobs)
	end

	-- Initialize data nodes.
	-- Need to set minimum high manually to capture accurate minimums.
	if #initialization_list == 0 then return false end
	for _, initialization_target in ipairs(initialization_list) do
		for _, trackable in pairs(DB.Trackable) do

			DB.Pet_Parse[player_name][pet_name][initialization_target][trackable] = {}
			for _, metric in pairs(DB.Metric) do
				if DB.Metric_Needs_Max_Value(metric) then
					DB.Pet_Data.Set(DB.Enum.MAX_DAMAGE, player_name, pet_name, initialization_target, trackable, metric)
				else
					DB.Pet_Data.Set(0, player_name, pet_name, initialization_target, trackable, metric)
				end
			end
		end
	end

	-- Initialize pet tracking tables.
	if player_name and not DB.Tracking.Initialized_Pets[player_name] then DB.Tracking.Initialized_Pets[player_name] = {} end
	if player_name and not DB.Tracking.Initialized_Pets[player_name][pet_name] then DB.Tracking.Initialized_Pets[player_name][pet_name] = true end
end

------------------------------------------------------------------------------------------------------
-- Directly sets a pet's trackables metric to a specified value.
------------------------------------------------------------------------------------------------------
---@param value number the value to set the node to.
---@param player_name string
---@param pet_name string
---@param target_name string
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Pet_Data.Set = function(value, player_name, pet_name, target_name, trackable, metric)
	-- Early quit out to prevent crashing.
	-- Can't quit out early for blank metric nodes because this is used for initialization.
	local caller = "DB.Pet_Data.Set"
	if DB.Is_Value_Empty(caller, player_name, "Player")    then return false end
	if DB.Is_Value_Empty(caller, target_name, "Target")    then return false end
	if DB.Is_Value_Empty(caller, pet_name,    "Pet")       then return false end
	if DB.Is_Value_Empty(caller, trackable,   "Trackable") then return false end
	if DB.Is_Value_Empty(caller, metric,      "Metric")    then return false end
	if DB.Is_Value_Empty(caller, value,       "Value")     then return false end
	if not DB.Pet_Data.Is_Index_Node_Initialized(caller, true, player_name, pet_name, target_name) then return false end

	-- Don't set an unfiltered minimum if the mob specific minimum isn't less than the unfiltered one.
	if DB.Metric_Needs_Max_Value(metric) and target_name == DB.Enum.ALL_MOBS
	and DB.Pet_Parse[player_name][pet_name][target_name][trackable][metric]
	and value >= DB.Pet_Parse[player_name][pet_name][target_name][trackable][metric] then
		return false
	end

	-- Apply the change.
	DB.Pet_Parse[player_name][pet_name][target_name][trackable][metric] = value

	return true
end

------------------------------------------------------------------------------------------------------
-- Increments a pet's trackables metric by a specified amount.
------------------------------------------------------------------------------------------------------
---@param value number the value to increment the node by.
---@param player_name string
---@param pet_name string
---@param target_name string
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Pet_Data.Inc = function(value, player_name, pet_name, target_name, trackable, metric)
	-- Early quit out to prevent crashing.
	local caller = "DB.Pet_Data.Inc"
	if DB.Is_Value_Empty(caller, player_name, "Player")    then return false end
	if DB.Is_Value_Empty(caller, target_name, "Target")    then return false end
	if DB.Is_Value_Empty(caller, pet_name,    "Pet")       then return false end
	if DB.Is_Value_Empty(caller, trackable,   "Trackable") then return false end
	if DB.Is_Value_Empty(caller, metric,      "Metric")    then return false end
	if DB.Is_Value_Empty(caller, value,       "Value")     then return false end
	if not DB.Pet_Data.Is_Index_Node_Initialized(caller, true, player_name, pet_name, target_name) then return false end
	if not DB.Pet_Data.Is_Metric_Node_Initialized(caller, true, player_name, pet_name, target_name, trackable, metric) then return false end

	-- Apply the change.
	DB.Pet_Parse[player_name][pet_name][target_name][trackable][metric] = DB.Pet_Parse[player_name][pet_name][target_name][trackable][metric] + value

	return true
end

------------------------------------------------------------------------------------------------------
-- Gets data from a pet's trackable metric.
-- If the mob filter is set then only actions towards that mob are counted.
-- Consider that not every player:mob index will have a pet node.
------------------------------------------------------------------------------------------------------
---@param player_name string the player or entity name to search data for.
---@param pet_name string
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
---@param temporary_mob_focus? string used to force look for a specific mob (mainly for setting minimums for AOEs).
---@return number
------------------------------------------------------------------------------------------------------
DB.Pet_Data.Get = function(player_name, pet_name, trackable, metric, temporary_mob_focus)
	local caller = "DB.Pet_Data.Get"
	if DB.Is_Value_Empty(caller, player_name, "Player")    then return 0 end
	if DB.Is_Value_Empty(caller, pet_name,    "Pet")       then return 0 end
	if DB.Is_Value_Empty(caller, trackable,   "Trackable") then return 0 end
	if DB.Is_Value_Empty(caller, metric,      "Metric")    then return 0 end

	-- Dont get new data unless we are in a new throttle cycle or cached data doesn't exist.
	if (Throttle.Is_Enabled() and not Throttle.Allow_Calculation()) and not temporary_mob_focus then
		if DB.Pet_Cache[player_name] and DB.Pet_Cache[player_name][pet_name] and DB.Pet_Cache[player_name][pet_name][trackable]
		and DB.Pet_Cache[player_name][pet_name][trackable][metric] then
			return DB.Pet_Cache[player_name][pet_name][trackable][metric]
		end
	end

	-- The target index will just be the mob focus unless a temporary focus is passed in.
	-- The mob focus will handle the ALL_MOBS too.
	local value = 0
	if DB.Metric_Needs_Max_Value(metric) then value = DB.Enum.MAX_DAMAGE end
	local mob_focus = DB.Widgets.Util.Get_Mob_Focus()
	local target_index = mob_focus
	if temporary_mob_focus then target_index = temporary_mob_focus end

	-- Get the data.
	if DB.Pet_Data.Is_Index_Node_Initialized(caller, false, player_name, pet_name, target_index) then
		if DB.Pet_Data.Is_Metric_Node_Initialized(caller, false, player_name, pet_name, target_index, trackable, metric) then
			value = DB.Pet_Parse[player_name][pet_name][target_index][trackable][metric]
		end
	end

	-- Cache for performance.
	if not DB.Pet_Cache[player_name] then DB.Pet_Cache[player_name] = {} end
	if not DB.Pet_Cache[player_name][pet_name] then DB.Pet_Cache[player_name][pet_name] = {} end
	if not DB.Pet_Cache[player_name][pet_name][trackable] then DB.Pet_Cache[player_name][pet_name][trackable] = {} end
	DB.Pet_Cache[player_name][pet_name][trackable][metric] = value

	return value
end

------------------------------------------------------------------------------------------------------
-- Checks if the [player_name][target_name] nodes are initialized in the pet primary database.
------------------------------------------------------------------------------------------------------
---@param caller string
---@param write_error boolean
---@param player_name string
---@param pet_name string
---@param target_name string
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Pet_Data.Is_Index_Node_Initialized = function(caller, write_error, player_name, pet_name, target_name)
	if not DB.Pet_Parse or not DB.Pet_Parse[player_name] or not DB.Pet_Parse[player_name][pet_name] or not DB.Pet_Parse[player_name][pet_name][target_name] then
		if write_error then
			Debug.Error.Add(Debug.Error.ERROR, caller, "Not initialized in DB.Pet_Parse[" .. tostring(player_name) .. "]["
			.. tostring(pet_name) .. "][" .. tostring(target_name) .. "].")
		end
		return false
	end
	return true
end

------------------------------------------------------------------------------------------------------
-- Checks if the [player_name][target_name][trackable][metric] nodes are initialized in the pet primary database.
------------------------------------------------------------------------------------------------------
---@param caller string
---@param write_error boolean
---@param player_name string
---@param pet_name string
---@param target_name string
---@param trackable string
---@param metric string
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Pet_Data.Is_Metric_Node_Initialized = function(caller, write_error, player_name, pet_name, target_name, trackable, metric)
	if not DB.Pet_Parse or not DB.Pet_Parse[player_name] or not DB.Pet_Parse[player_name][pet_name] or not DB.Pet_Parse[player_name][pet_name][target_name]
	or not DB.Pet_Parse[player_name][pet_name][target_name][trackable] or not DB.Pet_Parse[player_name][pet_name][target_name][trackable][metric] then
		if write_error then
			Debug.Error.Add(Debug.Error.ERROR, caller, "Metric not initialized in DB.Pet_Parse[" .. tostring(player_name)
			.. "][" .. tostring(pet_name) .. "][" .. tostring(target_name) .. "][" .. tostring(trackable) .. "][" .. tostring(metric) .. "].")
		end
		return false
	end
	return true
end