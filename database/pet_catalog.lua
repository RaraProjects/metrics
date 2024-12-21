DB.Pet_Catalog = {}

------------------------------------------------------------------------------------------------------
-- Initializes a pet cataloged action.
-- If the action has already been initialized then this will quit out early.
-- Also initializes Trackable_Data which is used in the Focus Window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param pet_name string
---@param target_name string
---@param action_name string the name of the action to be cataloged.
---@param trackable string a tracked item from the trackable list.
------------------------------------------------------------------------------------------------------
DB.Pet_Catalog.Initialize = function(player_name, pet_name, target_name, action_name, trackable)
	-- Early quit out to prevent crashing.
	local caller = "DB.Pet_Catalog.Initialize"
	if DB.Is_Value_Empty(caller, player_name, "Player") then return false end
	if DB.Is_Value_Empty(caller, target_name, "Target") then return false end
	if DB.Is_Value_Empty(caller, pet_name,    "Pet")    then return false end

	-- Don't want to overwrite data node if it already exists. This is for mob specfic data.
	local initialization_list = {}
	if not DB.Pet_Parse_Catalog[player_name] then DB.Pet_Parse_Catalog[player_name] = {} end
	if not DB.Pet_Parse_Catalog[player_name][pet_name] then DB.Pet_Parse_Catalog[player_name][pet_name] = {} end
	if not DB.Pet_Parse_Catalog[player_name][pet_name][target_name] then DB.Pet_Parse_Catalog[player_name][pet_name][target_name] = {} end
	if not DB.Pet_Parse_Catalog[player_name][pet_name][target_name][action_name] then DB.Pet_Parse_Catalog[player_name][pet_name][target_name][action_name] = {} end
	if not DB.Pet_Parse_Catalog[player_name][pet_name][target_name][action_name][trackable] then
		DB.Pet_Parse_Catalog[player_name][pet_name][target_name][action_name][trackable] = {}
		table.insert(initialization_list, target_name)
	end

	-- Don't want to overwrite data node if it already exists. This is for all mob data.
	local all_mobs = DB.Enum.ALL_MOBS
	if not DB.Pet_Parse_Catalog[player_name] then DB.Pet_Parse_Catalog[player_name] = {} end
	if not DB.Pet_Parse_Catalog[player_name][pet_name] then DB.Pet_Parse_Catalog[player_name][pet_name] = {} end
	if not DB.Pet_Parse_Catalog[player_name][pet_name][all_mobs] then DB.Pet_Parse_Catalog[player_name][pet_name][all_mobs] = {} end
	if not DB.Pet_Parse_Catalog[player_name][pet_name][all_mobs][action_name] then DB.Pet_Parse_Catalog[player_name][pet_name][all_mobs][action_name] = {} end
	if not DB.Pet_Parse_Catalog[player_name][pet_name][all_mobs][action_name][trackable] then
		DB.Pet_Parse_Catalog[player_name][pet_name][all_mobs][action_name][trackable] = {}
		table.insert(initialization_list, all_mobs)
	end

	-- Initialize data nodes.
	-- Need to set minimum high manually to capture accurate minimums.
	if #initialization_list == 0 then return nil end
	for _, initialization_target in ipairs(initialization_list) do
		for _, metric in pairs(DB.Metric) do
			if DB.Metric_Needs_Max_Value(metric) then
				DB.Pet_Catalog.Set(DB.Enum.MAX_DAMAGE, player_name, pet_name, initialization_target, action_name, trackable, metric)
			else
				DB.Pet_Catalog.Set(0, player_name, pet_name, initialization_target, action_name, trackable, metric)
			end
		end
	end

	-- Initialize tracking tables.
	DB.Pet_Catalog.Initialize_Tracking(trackable, player_name, pet_name)
end

------------------------------------------------------------------------------------------------------
-- Initializes a pet trackable.
------------------------------------------------------------------------------------------------------
---@param trackable string a tracked item from the trackable list.
---@param player_name string
---@param pet_name string
---@return boolean true: successful initialization; false: error
------------------------------------------------------------------------------------------------------
DB.Pet_Catalog.Initialize_Tracking = function(trackable, player_name, pet_name)
	-- Early quit out to prevent crashing.
	local caller = "DB.Pet_Catalog.Initialize_Tracking"
	if DB.Is_Value_Empty(caller, trackable,   "Trackable") then return false end
	if DB.Is_Value_Empty(caller, player_name, "Player")    then return false end
	if DB.Is_Value_Empty(caller, pet_name,    "Pet")       then return false end

	if not DB.Tracking.Pet_Trackable[trackable] then DB.Tracking.Pet_Trackable[trackable] = {} end
	if not DB.Tracking.Pet_Trackable[trackable][player_name] then DB.Tracking.Pet_Trackable[trackable][player_name] = {} end
	if not DB.Tracking.Pet_Trackable[trackable][player_name][pet_name] then DB.Tracking.Pet_Trackable[trackable][player_name][pet_name] = {} end
	return true
end

------------------------------------------------------------------------------------------------------
-- Directly sets a pet's trackables cataloged action metric to a specified value.
-- Some trackables need to be cataloged discretely in addition to holistically.
-- For example, metrics for weapons skill damage and metrics for each individual weapon skill.
-- The discrete tracking happens in the "catalog" node under each trackable.
------------------------------------------------------------------------------------------------------
---@param value number the value to set the node to
---@param player_name string
---@param pet_name string
---@param target_name string
---@param action_name string the name of the action to be cataloged.
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Pet_Catalog.Set = function(value, player_name, pet_name, target_name, action_name, trackable, metric)
	-- Early quit out to prevent crashing.
	-- Can't quit out early for blank metric nodes because this is used for initialization.
	local caller = "DB.Pet_Catalog.Set"
	if DB.Is_Value_Empty(caller, player_name, "Player")    then return false end
	if DB.Is_Value_Empty(caller, target_name, "Target")    then return false end
	if DB.Is_Value_Empty(caller, pet_name,    "Pet")       then return false end
	if DB.Is_Value_Empty(caller, action_name, "Action")    then return false end
	if DB.Is_Value_Empty(caller, trackable,   "Trackable") then return false end
	if DB.Is_Value_Empty(caller, metric,      "Metric")    then return false end
	if DB.Is_Value_Empty(caller, value,       "Value")     then return false end
	if not DB.Pet_Catalog.Is_Index_Node_Initialized(caller, true, player_name, pet_name, target_name, action_name) then return false end

	-- Don't set an unfiltered minimum if the mob specific minimum isn't less than the unfiltered one.
	if DB.Metric_Needs_Max_Value(metric) and target_name == DB.Enum.ALL_MOBS
	and DB.Pet_Parse_Catalog[player_name][pet_name][target_name][action_name][trackable]
	and DB.Pet_Parse_Catalog[player_name][pet_name][target_name][action_name][trackable][metric]
	and value >= DB.Pet_Parse_Catalog[player_name][pet_name][target_name][action_name][trackable][metric] then
		return false
	end

	-- Apply the change.
	DB.Pet_Parse_Catalog[player_name][pet_name][target_name][action_name][trackable][metric] = value

	return true
end

------------------------------------------------------------------------------------------------------
-- Increments a trackable's metric by a specified amount.
-- Some trackables need to be cataloged discretely in addition to holistically.
-- For example, metrics for weapons skill damage and metrics for each individual weapon skill.
-- The discrete tracking happens in the "catalog" node under each trackable.
------------------------------------------------------------------------------------------------------
---@param value number the value to increment the node by.
---@param player_name string
---@param pet_name string
---@param target_name string
---@param action_name string the name of the action to be cataloged.
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Pet_Catalog.Inc = function(value, player_name, pet_name, target_name, action_name, trackable, metric)
	-- Early quit out to prevent crashing.
	-- Can't quit out early for blank metric nodes because this is used for initialization.
	local caller = "DB.Pet_Catalog.Inc"
	if DB.Is_Value_Empty(caller, player_name, "Player")    then return false end
	if DB.Is_Value_Empty(caller, target_name, "Target")    then return false end
	if DB.Is_Value_Empty(caller, pet_name,    "Pet")       then return false end
	if DB.Is_Value_Empty(caller, action_name, "Action")    then return false end
	if DB.Is_Value_Empty(caller, trackable,   "Trackable") then return false end
	if DB.Is_Value_Empty(caller, metric,      "Metric")    then return false end
	if DB.Is_Value_Empty(caller, value,       "Value")     then return false end
	if not DB.Pet_Catalog.Is_Index_Node_Initialized(caller, true, player_name, pet_name, target_name, action_name) then return false end
	if not DB.Pet_Catalog.Is_Metric_Node_Initialized(caller, true, player_name, pet_name, target_name, action_name, trackable, metric) then return false end

	DB.Pet_Parse_Catalog[player_name][pet_name][target_name][action_name][trackable][metric]
	= DB.Pet_Parse_Catalog[player_name][pet_name][target_name][action_name][trackable][metric] + value

	return true
end

------------------------------------------------------------------------------------------------------
-- Gets data from a pet's trackables cataloged metric.
-- If the mob filter is set then only actions towards that mob are counted.
------------------------------------------------------------------------------------------------------
---@param player_name string the player or entity name to search data for.
---@param pet_name string
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@param temporary_mob_focus? string used to force look for a specific mob (mainly for setting minimums for AOEs).
---@return number
------------------------------------------------------------------------------------------------------
DB.Pet_Catalog.Get = function(player_name, pet_name, trackable, action_name, metric, temporary_mob_focus)
	local caller = "DB.Pet_Catalog.Inc"
	if DB.Is_Value_Empty(caller, player_name, "Player")    then return 0 end
	if DB.Is_Value_Empty(caller, pet_name,    "Pet")       then return 0 end
	if DB.Is_Value_Empty(caller, action_name, "Action")    then return 0 end
	if DB.Is_Value_Empty(caller, trackable,   "Trackable") then return 0 end
	if DB.Is_Value_Empty(caller, metric,      "Metric")    then return 0 end

	-- Dont get new data unless we are in a new throttle cycle or cached data doesn't exist.
	if (Throttle.Is_Enabled() and not Throttle.Allow_Calculation()) and not temporary_mob_focus then
		if DB.Pet_Catalog_Cache[player_name] and DB.Pet_Catalog_Cache[player_name][pet_name] and DB.Pet_Catalog_Cache[player_name][pet_name][action_name]
		and DB.Pet_Catalog_Cache[player_name][pet_name][action_name][trackable] and DB.Pet_Catalog_Cache[player_name][pet_name][action_name][trackable][metric] then
			return DB.Pet_Catalog_Cache[player_name][pet_name][action_name][trackable][metric]
		end
	end

	local value = 0
	if DB.Metric_Needs_Max_Value(metric) then value = DB.Enum.MAX_DAMAGE end
	local mob_focus = DB.Widgets.Util.Get_Mob_Focus()
	local target_index = mob_focus
	if temporary_mob_focus then target_index = temporary_mob_focus end

	-- Get the data.
	if DB.Pet_Catalog.Is_Index_Node_Initialized(caller, false, player_name, pet_name, target_index, action_name) then
		if DB.Pet_Catalog.Is_Metric_Node_Initialized(caller, false, player_name, pet_name, target_index, action_name, trackable, metric) then
			value = DB.Pet_Parse_Catalog[player_name][pet_name][target_index][action_name][trackable][metric]
		end
	end

	-- Cache for performance.
	if not DB.Pet_Catalog_Cache[player_name] then DB.Pet_Catalog_Cache[player_name] = {} end
	if not DB.Pet_Catalog_Cache[player_name][pet_name] then DB.Pet_Catalog_Cache[player_name][pet_name] = {} end
	if not DB.Pet_Catalog_Cache[player_name][pet_name][action_name] then DB.Pet_Catalog_Cache[player_name][pet_name][action_name] = {} end
	if not DB.Pet_Catalog_Cache[player_name][pet_name][action_name][trackable] then DB.Pet_Catalog_Cache[player_name][pet_name][action_name][trackable] = {} end
	DB.Pet_Catalog_Cache[player_name][pet_name][action_name][trackable][metric] = value

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
---@param action_name string
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Pet_Catalog.Is_Index_Node_Initialized = function(caller, write_error, player_name, pet_name, target_name, action_name)
	if not DB.Pet_Parse_Catalog or not DB.Pet_Parse_Catalog[player_name] or not DB.Pet_Parse_Catalog[player_name][pet_name]
	or not DB.Pet_Parse_Catalog[player_name][pet_name][target_name] then
		if write_error then
			Debug.Error.Add(Debug.Error.ERROR, caller, "Not initialized in DB.Pet_Parse_Catalog[" .. tostring(player_name) .. "]["
			.. tostring(pet_name) .. "][" .. tostring(target_name) .. "][" .. tostring(action_name) .. "].")
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
---@param action_name string
---@param trackable string
---@param metric string
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Pet_Catalog.Is_Metric_Node_Initialized = function(caller, write_error, player_name, pet_name, target_name, action_name, trackable, metric)
	if not DB.Pet_Parse_Catalog or not DB.Pet_Parse_Catalog[player_name] or not DB.Pet_Parse_Catalog[player_name][pet_name] or not DB.Pet_Parse_Catalog[player_name][pet_name][target_name]
	or not DB.Pet_Parse_Catalog[player_name][pet_name][target_name][action_name] or not DB.Pet_Parse_Catalog[player_name][pet_name][target_name][action_name][trackable]
	or not DB.Pet_Parse_Catalog[player_name][pet_name][target_name][action_name][trackable][metric] then
		if write_error then
			Debug.Error.Add(Debug.Error.ERROR, caller, "Metric not initialized in DB.Pet_Parse_Catalog[" .. tostring(player_name)
			.. "][" .. tostring(pet_name) .. "][" .. tostring(target_name) .. "][" .. tostring(action_name) .. "][" .. tostring(trackable)
			.. "][" .. tostring(metric) .. "].")
		end
		return false
	end
	return true
end