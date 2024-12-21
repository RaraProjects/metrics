DB.Catalog = {}

------------------------------------------------------------------------------------------------------
-- Initializes a cataloged action.
-- The base tables are initialized in the Init.Data and Init.Pet_Data functions.
-- If the action has already been initialized then this will quit out early.
-- Also initializes Trackable_Data which is used in the Focus Window.
-- CALLED BY: Update.Catalog_Damage and Update.Catalog Metric
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param target_name string
---@param action_name string the name of the action to be cataloged.
---@param trackable string a tracked item from the trackable list.
---@param pet_name? string
------------------------------------------------------------------------------------------------------
DB.Catalog.Initialize = function(player_name, target_name, action_name, trackable, pet_name)
	-- Early quit out to prevent crashing.
	local caller = "DB.Catalog.Initialize"
	if DB.Is_Value_Empty(caller, player_name, "Player")  then return false end
	if DB.Is_Value_Empty(caller, target_name, "Target")  then return false end
	if DB.Is_Value_Empty(caller, action_name, "Action")  then return false end
	if DB.Is_Value_Empty(caller, trackable, "Trackable") then return false end

	DB.Data.Initialize(player_name, target_name)
	if pet_name then DB.Pet_Data.Initialize(player_name, pet_name, target_name) end

	-- Don't want to overwrite data node if it already exists. This is for mob specfic data.
	local initialization_list = {}
	if not DB.Parse_Catalog[player_name] then DB.Parse_Catalog[player_name] = {} end
	if not DB.Parse_Catalog[player_name][target_name] then DB.Parse_Catalog[player_name][target_name] = {} end
	if not DB.Parse_Catalog[player_name][target_name][action_name] then DB.Parse_Catalog[player_name][target_name][action_name] = {} end
	if not DB.Parse_Catalog[player_name][target_name][action_name][trackable] then
		DB.Parse_Catalog[player_name][target_name][action_name][trackable] = {}
		table.insert(initialization_list, target_name)
	end

	-- Don't want to overwrite data node if it already exists. This is for all mob data.
	local all_mobs = DB.Enum.ALL_MOBS
	if not DB.Parse_Catalog[player_name][all_mobs] then  DB.Parse_Catalog[player_name][all_mobs] = {} end
	if not DB.Parse_Catalog[player_name][all_mobs][action_name] then DB.Parse_Catalog[player_name][all_mobs][action_name] = {} end
	if not DB.Parse_Catalog[player_name][all_mobs][action_name][trackable] then
		DB.Parse_Catalog[player_name][all_mobs][action_name][trackable] = {}
		table.insert(initialization_list, all_mobs)
	end

	-- Make sure the pet catalog is also initialized if necessary.
	if pet_name then DB.Pet_Catalog.Initialize(player_name, pet_name, target_name, action_name, trackable) end

	-- Initialize data nodes.
	-- Need to set minimum high manually to capture accurate minimums.
	if #initialization_list == 0 then return nil end
	for _, initialization_target in ipairs(initialization_list) do
		for _, metric in pairs(DB.Metric) do
			if DB.Metric_Needs_Max_Value(metric) then
				DB.Catalog.Set(DB.Enum.MAX_DAMAGE, player_name, initialization_target, action_name, trackable, metric)
			else
				DB.Catalog.Set(0, player_name, initialization_target, action_name, trackable, metric)
			end
		end
	end

	-- Initialize tracking tables.
	if not DB.Tracking.Trackable[trackable] then DB.Tracking.Trackable[trackable] = {} end
	if not DB.Tracking.Trackable[trackable][player_name] then DB.Tracking.Trackable[trackable][player_name] = {} end
end

------------------------------------------------------------------------------------------------------
-- Directs the setting of cataloged data.
-- Called by the action handling functions.
------------------------------------------------------------------------------------------------------
---@param player_name string name of the player or entity performing the action.
---@param target_name string name of the mob or entity receiving the action.
---@param trackable string a tracked item from the trackable list.
---@param damage number damage value to be logged.
---@param action_name string the name of the action to be cataloged.
---@param pet_name? string
---@param critical_hit? boolean whether or not a critical hit or magic burst took place.
------------------------------------------------------------------------------------------------------
DB.Catalog.Update_Damage = function(player_name, target_name, trackable, damage, action_name, pet_name, critical_hit)
	-- Early quit out to prevent crashing.
	local caller = "DB.Catalog.Update_Damage"
	if DB.Is_Value_Empty(caller, player_name, "Player") then return false end
	if DB.Is_Value_Empty(caller, target_name, "Target") then return false end

	-- Double check initializations
    DB.Catalog.Initialize(player_name, target_name, action_name, trackable, pet_name)

	local audits = {
		player_name = player_name,
		target_name = target_name,
		pet_name    = pet_name,
	}

	-- Update the non-catalog database with the damage
	DB.Data.Update_Damage(audits, trackable, damage, critical_hit)
	-- Everything after this is for the catalog.

	-- Total Damage
    DB.Catalog.Update_Metric(DB.Update_Mode.INC, damage, audits, trackable, action_name, DB.Metric.TOTAL)

	-- Attempts on the target.
	DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, action_name, DB.Metric.ATTEMPTS_ON_TARGET)

	-- Set trackable hits and minimums
	local min_metric = (critical_hit and DB.Metric.CRITICAL_MIN) or DB.Metric.MIN
	local max_metric = (critical_hit and DB.Metric.CRITICAL_MAX) or DB.Metric.MAX

    if damage > 0 then
		-- Log hits here since we have a damage check.
		DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, action_name, DB.Metric.HITS_ON_TARGET)

		-- Minimum damage.
		if damage < DB.Catalog.Get(player_name, trackable, action_name, min_metric, audits.target_name) then
			DB.Catalog.Update_Metric(DB.Update_Mode.SET, damage, audits, trackable, action_name, min_metric)
		end
    end

    if damage > DB.Catalog.Get(player_name, trackable, action_name, max_metric) then
    	-- Add a check for abnormally high healing magic to prevent Divine Seal from messing up overcure.
		if trackable == DB.Trackable.SPELLS_HEALING and DB.Healing_Max[action_name] then
			if damage > DB.Healing_Max[action_name] then damage = DB.Healing_Max[action_name] end
		end

		-- Maximum damage.
		DB.Catalog.Update_Metric(DB.Update_Mode.SET, damage, audits, trackable, action_name, max_metric)
    end
end

------------------------------------------------------------------------------------------------------
-- A handler function that makes sure the data is set appropriately (for cataloged actions)
-- This does not set data directly. Rather, it calls the Set~ or Inc~ functions.
-- This is called by the functions that perform the action handling.
------------------------------------------------------------------------------------------------------
---@param mode string flag calling out whether the data should be set or incremented.
---@param value number the value to set or increment the node to/by.
---@param audits table a table containing necessary data; helps save on parameter slots.
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Catalog.Update_Metric = function(mode, value, audits, trackable, action_name, metric)
	local player_name = audits.player_name
	local target_name = audits.target_name
	local pet_name    = audits.pet_name

	-- Early quit out to prevent crashing.
	local caller = "DB.Catalog.Update_Metric"
	if DB.Is_Value_Empty(caller, player_name, "Player")    then return false end
	if DB.Is_Value_Empty(caller, target_name, "Target")    then return false end
	if DB.Is_Value_Empty(caller, action_name, "Action")    then return false end
	if DB.Is_Value_Empty(caller, trackable,   "Trackable") then return false end
	if DB.Is_Value_Empty(caller, metric,      "Metric")    then return false end

	-- Initialization
	DB.Catalog.Initialize(player_name, target_name, action_name, trackable, pet_name)
	if not DB.Tracking.Initialized_Players[player_name] then DB.Tracking.Initialized_Players[player_name] = true end

	-- Set the data; loop once for mob-specific data and a second time for all mob data.
	local update_list = {[1] = target_name, [2] = DB.Enum.ALL_MOBS}

	for _, update_target in ipairs(update_list) do
		if mode == DB.Update_Mode.INC then
			DB.Catalog.Inc(value, player_name, update_target, action_name, trackable, metric)
			if pet_name then
				DB.Pet_Catalog.Inc(value, player_name, pet_name, update_target, action_name, trackable, metric)
			end
		elseif mode == DB.Update_Mode.SET then
			DB.Catalog.Set(value, player_name, update_target, action_name, trackable, metric)
			if pet_name then
				DB.Pet_Catalog.Set(value, player_name, pet_name, update_target, action_name, trackable, metric)
			end
		end
	end

	-- This is used for the focus window
	DB.Tracking.Trackable[trackable][player_name][action_name] = true
	if pet_name then
		local initialized = DB.Pet_Catalog.Initialize_Tracking(trackable, player_name, pet_name)
		if not initialized then return false end
		DB.Tracking.Pet_Trackable[trackable][player_name][pet_name][action_name] = true
	end

	return true
end

------------------------------------------------------------------------------------------------------
-- Directly sets a trackable's cataloged action metric to a specified value.
-- Some trackables need to be cataloged discretely in addition to holistically.
-- For example, metrics for weapons skill damage and metrics for each individual weapon skill.
-- The discrete tracking happens in the "catalog" node under each trackable.
------------------------------------------------------------------------------------------------------
---@param value number the value to set the node to
---@param player_name string
---@param target_name string
---@param action_name string the name of the action to be cataloged.
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Catalog.Set = function(value, player_name, target_name, action_name, trackable, metric)
	-- Early quit out to prevent crashing.
	-- Can't quit out early for blank metric nodes because this is used for initialization.
	local caller = "DB.Catalog.Set"
	if DB.Is_Value_Empty(caller, player_name, "Player")    then return false end
	if DB.Is_Value_Empty(caller, target_name, "Target")    then return false end
	if DB.Is_Value_Empty(caller, action_name, "Action")    then return false end
	if DB.Is_Value_Empty(caller, trackable,   "Trackable") then return false end
	if DB.Is_Value_Empty(caller, metric,      "Metric")    then return false end
	if DB.Is_Value_Empty(caller, value,       "Value")     then return false end
	if not DB.Catalog.Is_Index_Node_Initialized(caller, true, player_name, target_name, action_name) then return false end

	-- Don't set an unfiltered minimum if the mob specific minimum isn't less than the unfiltered one.
	if DB.Metric_Needs_Max_Value(metric) and target_name == DB.Enum.ALL_MOBS
	and DB.Parse_Catalog[player_name][target_name][action_name][trackable] and DB.Parse_Catalog[player_name][target_name][action_name][trackable][metric]
	and value >= DB.Parse_Catalog[player_name][target_name][action_name][trackable][metric] then
		return false
	end

	-- Apply the change.
	DB.Parse_Catalog[player_name][target_name][action_name][trackable][metric] = value

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
---@param target_name string
---@param action_name string the name of the action to be cataloged.
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Catalog.Inc = function(value, player_name, target_name, action_name, trackable, metric)
	-- Early quit out to prevent crashing.
	local caller = "DB.Catalog.Inc"
	if DB.Is_Value_Empty(caller, player_name, "Player")    then return false end
	if DB.Is_Value_Empty(caller, target_name, "Target")    then return false end
	if DB.Is_Value_Empty(caller, action_name, "Action")    then return false end
	if DB.Is_Value_Empty(caller, trackable,   "Trackable") then return false end
	if DB.Is_Value_Empty(caller, metric,      "Metric")    then return false end
	if DB.Is_Value_Empty(caller, value,       "Value")     then return false end
	if not DB.Catalog.Is_Index_Node_Initialized(caller, true, player_name, target_name, action_name) then return false end
	if not DB.Catalog.Is_Metric_Node_Initialized(caller, true, player_name, target_name, action_name, trackable, metric) then return false end

	-- Apply the change.
	DB.Parse_Catalog[player_name][target_name][action_name][trackable][metric] = DB.Parse_Catalog[player_name][target_name][action_name][trackable][metric] + value

	return true
end

------------------------------------------------------------------------------------------------------
-- Gets data from a trackable's cataloged metric.
-- If the mob filter is set then only actions towards that mob are counted.
------------------------------------------------------------------------------------------------------
---@param player_name string the player or entity name to search data for.
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@param temporary_mob_focus? string used to force look for a specific mob (mainly for setting minimums for AOEs).
---@return number
------------------------------------------------------------------------------------------------------
DB.Catalog.Get = function(player_name, trackable, action_name, metric, temporary_mob_focus)
	local caller = "DB.Catalog.Get"
	if DB.Is_Value_Empty(caller, player_name, "Player")    then return 0 end
	if DB.Is_Value_Empty(caller, action_name, "Action")    then return 0 end
	if DB.Is_Value_Empty(caller, trackable,   "Trackable") then return 0 end
	if DB.Is_Value_Empty(caller, metric,      "Metric")    then return 0 end

	-- Dont get new data unless we are in a new throttle cycle or cached data doesn't exist.
	if (Throttle.Is_Enabled() and not Throttle.Allow_Calculation()) and not temporary_mob_focus then
		if DB.Catalog_Cache[player_name] and DB.Catalog_Cache[player_name][action_name] and DB.Catalog_Cache[player_name][action_name][trackable]
		and DB.Catalog_Cache[player_name][action_name][trackable][metric] then
			return DB.Catalog_Cache[player_name][action_name][trackable][metric]
		end
	end

	local value = 0
	if DB.Metric_Needs_Max_Value(metric) then value = DB.Enum.MAX_DAMAGE end
	local mob_focus = DB.Widgets.Util.Get_Mob_Focus()
	local target_index = mob_focus
	if temporary_mob_focus then target_index = temporary_mob_focus end

	-- Get the data.
	if DB.Catalog.Is_Index_Node_Initialized(caller, false, player_name, target_index, action_name) then
		if DB.Catalog.Is_Metric_Node_Initialized(caller, false, player_name, target_index, action_name, trackable, metric) then
			value = DB.Parse_Catalog[player_name][target_index][action_name][trackable][metric]
		end
	end

	-- Cache for performance.
	if not DB.Catalog_Cache[player_name] then DB.Catalog_Cache[player_name] = {} end
	if not DB.Catalog_Cache[player_name][action_name] then DB.Catalog_Cache[player_name][action_name] = {} end
	if not DB.Catalog_Cache[player_name][action_name][trackable] then DB.Catalog_Cache[player_name][action_name][trackable] = {} end
	DB.Catalog_Cache[player_name][action_name][trackable][metric] = value

	return value
end

------------------------------------------------------------------------------------------------------
-- Checks if the [player_name][target_name] nodes are initialized in the catalog database.
------------------------------------------------------------------------------------------------------
---@param caller string
---@param write_error boolean
---@param player_name string
---@param target_name string
---@param action_name string
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Catalog.Is_Index_Node_Initialized = function(caller, write_error, player_name, target_name, action_name)
	if not DB.Parse_Catalog or not DB.Parse_Catalog[player_name] or not DB.Parse_Catalog[player_name][target_name]
	or not DB.Parse_Catalog[player_name][target_name][action_name] then
		if write_error then
			local error = "Not initialized in DB.Parse_Catalog[" .. tostring(player_name) .. "][" .. tostring(target_name) .. "][" .. tostring(action_name) .. "]."
			Debug.Error.Add(Debug.Error.ERROR, caller, error)
		end
		return false
	end
	return true
end

------------------------------------------------------------------------------------------------------
-- Checks if the [player_name][target_name][trackable][metric] nodes are initialized in the catalog database.
------------------------------------------------------------------------------------------------------
---@param caller string
---@param write_error boolean
---@param player_name string
---@param target_name string
---@param action_name string
---@param trackable string
---@param metric string
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Catalog.Is_Metric_Node_Initialized = function(caller, write_error, player_name, target_name, action_name, trackable, metric)
	if not DB.Parse_Catalog or not DB.Parse_Catalog[player_name] or not DB.Parse_Catalog[player_name][target_name]
	or not DB.Parse_Catalog[player_name][target_name][action_name] or not DB.Parse_Catalog[player_name][target_name][action_name][trackable]
	or not DB.Parse_Catalog[player_name][target_name][action_name][trackable][metric] then
		if write_error then
			local error = "Metric not initialized in DB.Parse_Catalog[" .. tostring(player_name) .. "][" .. tostring(target_name) .. "][" .. tostring(action_name)
			.. "][" .. tostring(trackable) .. "][" .. tostring(metric) .. "]."
			Debug.Error.Add(Debug.Error.ERROR, caller, error)
		end
		return false
	end
	return true
end