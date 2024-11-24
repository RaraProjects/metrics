DB.Catalog = T{}

------------------------------------------------------------------------------------------------------
-- Initializes a cataloged action.
-- The base tables are initialized in the Init.Data and Init.Pet_Data functions.
-- If the action has already been initialized then this will quit out early.
-- Also initializes Trackable_Data which is used in the Focus Window.
-- CALLED BY: Update.Catalog_Damage and Update.Catalog Metric
------------------------------------------------------------------------------------------------------
---@param index string "actor_name:target_name"
---@param player_name string
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param pet_name? string
---@return boolean an initialization was performed.
------------------------------------------------------------------------------------------------------
DB.Catalog.Initialize = function(index, player_name, trackable, action_name, pet_name)
	if not index or not player_name or not trackable or not action_name then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Catalog.Initialize", "Player {" .. tostring(player_name) .. "} Pet {" .. tostring(pet_name) .. "}: Nil required parameter passed in." )
		return false
	end

	DB.Data.Initialize(index, player_name)
	if pet_name then DB.Pet_Data.Initialize(index, player_name, pet_name) end

	-- Don't want to overwrite data node if it already exists
	if not DB.Parse_Catalog[index] then DB.Parse_Catalog[index] = T{} end
	if not DB.Parse_Catalog[index][action_name] then DB.Parse_Catalog[index][action_name] = T{} end
	if DB.Parse_Catalog[index][action_name][trackable] then
		if pet_name then
			DB.Pet_Catalog.Initialize(index, player_name, trackable, action_name, pet_name)
			return true
		end
		return false
	end

	DB.Parse_Catalog[index][action_name][trackable] = T{}
	if pet_name then DB.Pet_Catalog.Initialize(index, player_name, trackable, action_name, pet_name) end

	-- Populate metric nodes
	-- Need to set minimum high manually to capture accurate minimums
	for _, metric in pairs(DB.Metric) do
		DB.Catalog.Set(0, index, trackable, action_name, metric)
	end
	DB.Catalog.Set(DB.Enum.MAX_DAMAGE, index, trackable, action_name, DB.Metric.MIN)
	DB.Catalog.Set(DB.Enum.MAX_DAMAGE, index, trackable, action_name, DB.Metric.CRITICAL_MIN)

	-- Initialize tracking tables
	if not DB.Tracking.Trackable[trackable] then DB.Tracking.Trackable[trackable] = T{} end
	if not DB.Tracking.Trackable[trackable][player_name] then DB.Tracking.Trackable[trackable][player_name] = T{} end

	return true
end

------------------------------------------------------------------------------------------------------
-- Directs the setting of cataloged data.
-- Called by the action handling functions.
------------------------------------------------------------------------------------------------------
---@param player_name string name of the player or entity performing the action.
---@param mob_name string name of the mob or entity receiving the action.
---@param trackable string a tracked item from the trackable list.
---@param damage number damage value to be logged.
---@param action_name string the name of the action to be cataloged.
---@param pet_name? string
---@param burst? boolean whether or not a magic burst took place.
------------------------------------------------------------------------------------------------------
DB.Catalog.Update_Damage = function(player_name, mob_name, trackable, damage, action_name, pet_name, burst)
    if player_name == "" or mob_name == "" or pet_name == "" then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Catalog.Update_Damage", "Blank Entity: Player {" .. tostring(player_name) .. "} Mob {" .. tostring(mob_name)
		.. "} Pet {" .. tostring(pet_name) .. "} Trackable {" .. tostring(trackable) .. "} Action {" .. tostring(action_name) .. "} Damage {" .. tostring(damage) .. "}")
		return nil
	end

	-- Double check initializations
	local index = DB.Data.Build_Index(player_name, mob_name)
    DB.Catalog.Initialize(index, player_name, trackable, action_name, pet_name)

	local audits = {
		player_name = player_name,
		target_name = mob_name,
		pet_name = pet_name,
	}

	-- Update the non-catalog database with the damage
	DB.Data.Update_Damage(audits, trackable, damage, burst)

	-- Magic Bursts
	if trackable == DB.Trackable.SPELLS_NUKING and burst then
		DB.Catalog.Update_Metric(DB.Update_Mode.INC, damage, audits, trackable, action_name, DB.Metric.MAGIC_BURST_DAMAGE)
	end
	-- COUNT gets incremented in the packet handler.

	-- Total Damage
    DB.Catalog.Update_Metric(DB.Update_Mode.INC, damage, audits, trackable, action_name, DB.Metric.TOTAL)

	-- Minimum Damage
    if damage > 0 and damage < DB.Catalog.Get(player_name, trackable, action_name, DB.Metric.MIN, audits.target_name) then
		DB.Catalog.Update_Metric(DB.Update_Mode.SET, damage, audits, trackable, action_name, DB.Metric.MIN)
    end

	-- Maximum Damage
    if damage > DB.Catalog.Get(player_name, trackable, action_name, DB.Metric.MAX) then
    	-- Add a check for abnormally high healing magic to prevent Divine Seal from messing up overcure.
		if trackable == DB.Trackable.SPELLS_HEALING and DB.Healing_Max[action_name] then
			if damage > DB.Healing_Max[action_name] then damage = DB.Healing_Max[action_name] end
		end
		DB.Catalog.Update_Metric(DB.Update_Mode.SET, damage, audits, trackable, action_name, DB.Metric.MAX)
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
	local pet_name = audits.pet_name

	-- Input checking
	if not trackable or not action_name or not player_name or not target_name or player_name == "" or target_name == "" then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Catalog.Update_Metric", "Nil/Blank required parameter: Player {" .. tostring(player_name) .. "} Pet {"
		.. tostring(pet_name) .. "} Action {" .. tostring(action_name) .. "} Target {" .. tostring(audits.target_name) .. "} Trackable {"
		.. tostring(trackable) .. "} Metric {" .. tostring(metric) .. "}.")
		return false
	end

	-- Initialization
	local index = DB.Data.Build_Index(player_name, target_name)
	DB.Catalog.Initialize(index, player_name, trackable, action_name, pet_name)
	if not DB.Tracking.Initialized_Players[player_name] then DB.Tracking.Initialized_Players[player_name] = true end

	-- Set the data
	if mode == DB.Update_Mode.INC then
		DB.Catalog.Inc(value, index, trackable, action_name, metric)
		if pet_name then
			DB.Pet_Catalog.Inc(value, index, pet_name, trackable, action_name, metric)
		end
	elseif mode == DB.Update_Mode.SET then
		DB.Catalog.Set(value, index, trackable, action_name, metric)
		if pet_name then
			DB.Pet_Catalog.Set(value, index, pet_name, trackable, action_name, metric)
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
---@param index string "player_name:mob_name"
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Catalog.Set = function(value, index, trackable, action_name, metric)
	if not value or not index or not trackable or not action_name or not metric then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Catalog.Set", "Index {" .. tostring(index) .. "} Trackable {" .. tostring(trackable) .. "} Action {"
		.. tostring(action_name) .. "} Metric {" .. tostring(metric) .. "} nil required parameter passed in.")
		return false
	end
	if not DB.Parse_Catalog[index] or not DB.Parse_Catalog[index][action_name] then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Catalog.Set", "Index {" .. tostring(index) .. "} Trackable {" .. tostring(trackable) .. "} Action {"
		.. tostring(action_name) .. "} Metric {" .. tostring(metric) .. "} is not initialized.")
		return false
	end

	DB.Parse_Catalog[index][action_name][trackable][metric] = value	-- Assumes this node exists.

	return true
end

------------------------------------------------------------------------------------------------------
-- Increments a trackable's metric by a specified amount.
-- Some trackables need to be cataloged discretely in addition to holistically.
-- For example, metrics for weapons skill damage and metrics for each individual weapon skill.
-- The discrete tracking happens in the "catalog" node under each trackable.
------------------------------------------------------------------------------------------------------
---@param value number the value to increment the node by.
---@param index string "player_name:mob_name"
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Catalog.Inc = function(value, index, trackable, action_name, metric)
	if not value or not index or not trackable or not action_name or not metric then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Catalog.Inc", "Index {" .. tostring(index) .. "} Trackable {" .. tostring(trackable) .. "} Action {"
		.. tostring(action_name) .. "} Metric {" .. tostring(metric) .. "} nil required parameter passed in.")
		return false
	end
	if not DB.Parse_Catalog[index] or not DB.Parse_Catalog[index][action_name] then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Catalog.Set", "Index {" .. tostring(index) .. "} Trackable {" .. tostring(trackable) .. "} Action {"
		.. tostring(action_name) .. "} Metric {" .. tostring(metric) .. "} is not initialized.")
		return false
	end

	DB.Parse_Catalog[index][action_name][trackable][metric]				-- Assumes this node exists.
	= DB.Parse_Catalog[index][action_name][trackable][metric] + value

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
	if not player_name or not trackable or not action_name or not metric then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Catalog.Get", "Player {" .. tostring(player_name) .. "} Trackable {" .. tostring(trackable) .. "} Action {"
		.. tostring(action_name) .. "} Metric {" .. tostring(metric) .. "} nil required parameter passed in.")
		return 0
	end

	-- Dont get new data unless we are in a new throttle cycle or cached data doesn't exist.
	if Throttle.Is_Enabled() and not Throttle.Allow_Calculation() then
		if DB.Catalog_Cache[player_name] and DB.Catalog_Cache[player_name][action_name] and DB.Catalog_Cache[player_name][action_name][trackable]
		and DB.Catalog_Cache[player_name][action_name][trackable][metric] then
			return DB.Catalog_Cache[player_name][action_name][trackable][metric]
		end
	end

	local total = 0
	if metric == DB.Metric.MIN then total = DB.Enum.MAX_DAMAGE end
	local mob_focus = DB.Widgets.Util.Get_Mob_Focus()
	local search_string = player_name .. ":" .. mob_focus
	if mob_focus == DB.Widgets.Dropdown.Enum.NONE or trackable == DB.Trackable.DEF_HEALING_RECEIVED then search_string = player_name .. ":" end
	if temporary_mob_focus then search_string = player_name .. ":" .. temporary_mob_focus end

	for index, _ in pairs(DB.Parse_Catalog) do
		if string.find(index, search_string) then
			total = DB.Catalog.Calculate(total, index, trackable, action_name, metric)
		end
	end

	-- Cache for performance.
	if not DB.Catalog_Cache[player_name] then DB.Catalog_Cache[player_name] = {} end
	if not DB.Catalog_Cache[player_name][action_name] then DB.Catalog_Cache[player_name][action_name] = {} end
	if not DB.Catalog_Cache[player_name][action_name][trackable] then DB.Catalog_Cache[player_name][action_name][trackable] = {} end
	DB.Catalog_Cache[player_name][action_name][trackable][metric] = total

	return total
end

------------------------------------------------------------------------------------------------------
-- Helper function for getting cataloged data.
------------------------------------------------------------------------------------------------------
---@param value number the value to increment the node by.
---@param index string "player_name:mob_name"
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return number
------------------------------------------------------------------------------------------------------
DB.Catalog.Calculate = function(value, index, trackable, action_name, metric)
	if DB.Parse_Catalog[index] and DB.Parse_Catalog[index][action_name] and DB.Parse_Catalog[index][action_name][trackable] then
		if     metric == DB.Metric.MIN then value = DB.Catalog.Minimum(value, index, trackable, action_name, metric)
		elseif metric == DB.Metric.MAX then value = DB.Catalog.Maximum(value, index, trackable, action_name, metric)
		else   value = value + DB.Parse_Catalog[index][action_name][trackable][metric] end
	end
	return value
end

------------------------------------------------------------------------------------------------------
-- Helper function for getting cataloged data for minimum metric.
------------------------------------------------------------------------------------------------------
---@param min number current observed minimum value.
---@param index string "player_name:mob_name"
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return number
------------------------------------------------------------------------------------------------------
DB.Catalog.Minimum = function(min, index, trackable, action_name, metric)
	if min > DB.Parse_Catalog[index][action_name][trackable][metric] then
		min =  DB.Parse_Catalog[index][action_name][trackable][metric]
	end
	return min
end

------------------------------------------------------------------------------------------------------
-- Helper function for getting cataloged data for maximum metric.
------------------------------------------------------------------------------------------------------
---@param max number current observed maximum value.
---@param index string "player_name:mob_name"
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return number
------------------------------------------------------------------------------------------------------
DB.Catalog.Maximum = function(max, index, trackable, action_name, metric)
	if DB.Parse_Catalog[index][action_name][trackable][metric] > max then
		max = DB.Parse_Catalog[index][action_name][trackable][metric]
	end
	return max
end

------------------------------------------------------------------------------------------------------
-- Helper function for getting cataloged data for maximum metric.
------------------------------------------------------------------------------------------------------
---@param trackable string a tracked item from the trackable list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Catalog.Include_Total_Damage = function(trackable)
	if trackable == DB.Trackable.SPELLS_HEALING or
	   trackable == DB.Trackable.DEF_HEALING_RECEIVED or
	   trackable == DB.Trackable.ABILITY_HEALING or
	   trackable == DB.Trackable.ABILITY_MP_RECOVERY or
	   trackable == DB.Trackable.PET_HEALING or
	   trackable == DB.Trackable.SPELLS_MP_DRAIN or
	   trackable == DB.Trackable.DEF_NUKING or
	   trackable == DB.Trackable.DEF_NUKING_PET or
	   trackable == DB.Trackable.DEF_SPIKES or
	   trackable == DB.Trackable.DEF_TP_MOVE or
	   trackable == DB.Trackable.DEF_TP_MOVE_PET or
	   trackable == DB.Trackable.DEF_MELEE or
	   trackable == DB.Trackable.DEF_MELEE_PET then
		return false
	end
	return true
end