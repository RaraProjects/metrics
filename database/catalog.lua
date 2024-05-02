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
DB.Catalog.Init = function(index, player_name, trackable, action_name, pet_name)
	if not index or not player_name or not trackable or not action_name then
		_Debug.Error.Add("Init.Catalog_Action: {" .. tostring(player_name) .. "} {" .. tostring(pet_name) .. "} nil required parameter passed in." )
		return false
	end

	DB.Data.Init(index, player_name, pet_name)

	-- Don't want to overwrite action_name node if it is already built out
	if DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name] then
		if pet_name then
			if DB.Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name] then return false end
			DB.Pet_Catalog.Init(index, player_name, trackable, action_name, pet_name)
			return true
		end
		return false
	end

	DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name] = {}
	if pet_name then DB.Pet_Catalog.Init(index, player_name, trackable, action_name, pet_name) end

	-- Initialize catalog data nodes
	for _, metric in pairs(DB.Enum.Metric) do
		DB.Catalog.Set(0, index, trackable, action_name, metric)
	end

	-- Need to set minimum high manually to capture accurate minimums
	DB.Catalog.Set(DB.Enum.Values.MAX_DAMAGE, index, trackable, action_name, DB.Enum.Metric.MIN)

	-- Initialize tracking tables
	if not DB.Tracking.Trackable[trackable] then DB.Tracking.Trackable[trackable] = {} end
	if not DB.Tracking.Trackable[trackable][player_name] then DB.Tracking.Trackable[trackable][player_name] = {} end

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
    local index = DB.Data.Build_Index(player_name, mob_name)
    DB.Catalog.Init(index, player_name, trackable, action_name, pet_name)

	local audits = {
		player_name = player_name,
		target_name = mob_name,
		pet_name = pet_name,
	}

	-- GRAND TOTAL ////////////////////////////////////////////////////////////////////////////////
	-- There is a regular track and a "no skillchains" track.
    if trackable ~= DB.Enum.Trackable.HEALING and trackable ~= DB.Enum.Trackable.PET_HEAL and trackable ~= DB.Enum.Trackable.MP_DRAIN then
    	DB.Data.Update(DB.Enum.Mode.INC, damage, audits, DB.Enum.Trackable.TOTAL, DB.Enum.Metric.TOTAL)
		if trackable ~= DB.Enum.Trackable.SC then
			DB.Data.Update(DB.Enum.Mode.INC, damage, audits, DB.Enum.Trackable.TOTAL_NO_SC, DB.Enum.Metric.TOTAL)
		end
    end

    -- TRACKABLE TOTAL, MIN, and MAX //////////////////////////////////////////////////////////////
    DB.Data.Update(DB.Enum.Mode.INC, damage, audits, trackable, DB.Enum.Metric.TOTAL)
	if burst then
		DB.Data.Update(DB.Enum.Mode.INC, damage, audits, DB.Enum.Trackable.MAGIC, DB.Enum.Metric.BURST_DAMAGE)
	end

	-- We can't log a miss (0 damage) to MIN because then the miminum will always be zero.
    if damage > 0 and damage < DB.Data.Get(player_name, trackable, DB.Enum.Metric.MIN) then
		DB.Data.Update(DB.Enum.Mode.SET, damage, audits, trackable, DB.Enum.Metric.MIN)
	end

    if damage > DB.Data.Get(player_name, trackable, DB.Enum.Metric.MAX) then
		DB.Data.Update(DB.Enum.Mode.SET, damage, audits, trackable, DB.Enum.Metric.MAX)
	end

    -- CATALOG TOTAL, MIN, and MAX ////////////////////////////////////////////////////////////////
	-- COUNT gets incremented in the packet handler.
    DB.Catalog.Update_Metric(DB.Enum.Mode.INC, damage, audits, trackable, action_name, DB.Enum.Metric.TOTAL)
	if trackable == DB.Enum.Trackable.MAGIC and burst then
		DB.Catalog.Update_Metric(DB.Enum.Mode.INC, damage, audits, trackable, action_name, DB.Enum.Metric.BURST_DAMAGE)
	end

    if damage > 0 and damage < DB.Catalog.Get(player_name, trackable, action_name, DB.Enum.Metric.MIN) then
		DB.Catalog.Update_Metric(DB.Enum.Mode.SET, damage, audits, trackable, action_name, DB.Enum.Metric.MIN)
    end

    if damage > DB.Catalog.Get(player_name, trackable, action_name, DB.Enum.Metric.MAX) then
    	-- Add a check for abnormally high healing magic to prevent Divine Seal from messing up overcure.
		if trackable == DB.Enum.Trackable.HEALING then
			if damage > DB.Healing_Max[action_name] then damage = DB.Healing_Max[action_name] end
		end
		DB.Catalog.Update_Metric(DB.Enum.Mode.SET, damage, audits, trackable, action_name, DB.Enum.Metric.MAX)
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
	local index = DB.Data.Build_Index(player_name, target_name)

	if not trackable or not player_name or not action_name then
		_Debug.Error.Add("Update.Catalog_Metric: {" .. tostring(player_name) .. "} {" .. tostring(pet_name) .. "} nil required parameter passed in." )
		return false
	end
	DB.Catalog.Init(index, player_name, trackable, action_name, pet_name)
	if not DB.Tracking.Initialized_Players[player_name] then DB.Tracking.Initialized_Players[player_name] = true end

	-- Set the data.
	if mode == DB.Enum.Mode.INC then
		DB.Catalog.Inc(value, index, trackable, action_name, metric)
		if pet_name then
			DB.Pet_Catalog.Inc(value, index, pet_name, trackable, action_name, metric)
		end
	elseif mode == DB.Enum.Mode.SET then
		DB.Catalog.Set(value, index, trackable, action_name, metric)
		if pet_name then
			DB.Pet_Catalog.Set(value, index, pet_name, trackable, action_name, metric)
		end
	end

	-- This is used for the focus window
	DB.Tracking.Trackable[trackable][player_name][action_name] = true
	if pet_name then
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
		_Debug.Error.Add("Set.Catalog: {" .. tostring(index) .. "} {" .. tostring(trackable) .. "} nil required parameter passed in." )
		return false
	end
	DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name][metric] = value
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
		_Debug.Error.Add("Inc.Catalog: {" .. tostring(index) .. "} {" .. tostring(trackable) .. "} nil required parameter passed in." )
		return false
	end
	DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name][metric]
	= DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name][metric] + value
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
---@return number
------------------------------------------------------------------------------------------------------
DB.Catalog.Get = function(player_name, trackable, action_name, metric)
	if not player_name or not trackable or not action_name or not metric then
		_Debug.Error.Add("Get.Catalog: player_name {" .. tostring(player_name) .. "} trackable {" .. tostring(trackable) .. "} action_name {" .. tostring(action_name) .. "} metric {" .. tostring(metric))
		return 0
	end
	local total = 0
	if metric == DB.Enum.Metric.MIN then total = DB.Enum.Values.MAX_DAMAGE end
	local mob_focus = Window.Util.Get_Mob_Focus()
	for index, _ in pairs(DB.Parse) do
		if mob_focus == Window.Dropdown.Enum.NONE then
			if string.find(index, player_name) then
				total = DB.Catalog.Calculate(total, index, trackable, action_name, metric)
			end
		else
			if string.find(index, player_name .. ":" .. mob_focus) then
				total = DB.Catalog.Calculate(total, index, trackable, action_name, metric)
			end
		end
	end
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
	if DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name] then
		if     metric == DB.Enum.Metric.MIN then value = DB.Catalog.Minimum(value, index, trackable, action_name, metric)
		elseif metric == DB.Enum.Metric.MAX then value = DB.Catalog.Maximum(value, index, trackable, action_name, metric)
		else   value = value + DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name][metric] end
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
	if min > DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name][metric] then
		min =  DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name][metric]
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
	if DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name][metric] > max then
		max = DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name][metric]
	end
	return max
end