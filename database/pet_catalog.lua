DB.Pet_Catalog = T{}

------------------------------------------------------------------------------------------------------
-- Initializes a pet cataloged action.
-- If the action has already been initialized then this will quit out early.
-- Also initializes Trackable_Data which is used in the Focus Window.
------------------------------------------------------------------------------------------------------
---@param index string "actor_name:target_name"
---@param player_name string
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param pet_name string
------------------------------------------------------------------------------------------------------
DB.Pet_Catalog.Init = function(index, player_name, trackable, action_name, pet_name)
	if DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name] then return false end
	DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name] = {}

	-- Initialize catalog data nodes
	for _, metric in pairs(DB.Enum.Metric) do
		DB.Pet_Catalog.Set(0, index, pet_name, trackable, action_name, metric)
	end

	DB.Pet_Catalog.Set(DB.Enum.Values.MAX_DAMAGE, index, pet_name, trackable, action_name, DB.Enum.Metric.MIN)

	-- Initialize tracking tables
	DB.Pet_Catalog.Init_Tracking(trackable, player_name, pet_name)
end

------------------------------------------------------------------------------------------------------
-- Initializes a pet trackable.
------------------------------------------------------------------------------------------------------
---@param trackable string a tracked item from the trackable list.
---@param player_name string
---@param pet_name string
---@return boolean true: successful initialization; false: error
------------------------------------------------------------------------------------------------------
DB.Pet_Catalog.Init_Tracking = function(trackable, player_name, pet_name)
	if not trackable or not player_name or not pet_name then
		_Debug.Error.Add("Pet_Catalog.Init_Tracking:  Passed nil Trackable " .. tostring(trackable) .. " Player Name " .. tostring(player_name) .. " " .. tostring(pet_name))
		return false
	end
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
---@param index string "player_name:mob_name"
---@param pet_name string
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Pet_Catalog.Set = function(value, index, pet_name, trackable, action_name, metric)
	if not value or not index or not pet_name or not trackable or not action_name or not metric then
		_Debug.Error.Add("Set.Pet_Catalog: {" .. tostring(index) .. "} {" .. tostring(pet_name) .. "} {".. tostring(trackable) .. "} nil required parameter passed in." )
		return false
	end
	DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name][metric] = value
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
---@param pet_name string
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Pet_Catalog.Inc = function(value, index, pet_name, trackable, action_name, metric)
	if not value or not index or not pet_name or not trackable or not action_name or not metric then
		_Debug.Error.Add("Inc.Pet_Catalog: {" .. tostring(index) .. "} {" .. tostring(pet_name) .. "} {" .. tostring(trackable) .. "} nil required parameter passed in." )
		return false
	end
	DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name][metric]
	= DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name][metric] + value
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
---@return number
------------------------------------------------------------------------------------------------------
DB.Pet_Catalog.Get = function(player_name, pet_name, trackable, action_name, metric)
	if not player_name or not pet_name or not trackable or not action_name or not metric then
		_Debug.Error.Add("Get.Pet_Catalog: player_name {" .. tostring(player_name) .. "} pet_name {" .. tostring(pet_name) .. "} trackable {" .. tostring(trackable) .. "} action_name {" .. tostring(action_name) .. "} metric {" .. tostring(metric))
		return 0
	end
	local total = 0
	if metric == DB.Enum.Metric.MIN then total = DB.Enum.Values.MAX_DAMAGE end
	local mob_focus = DB.Widgets.Util.Get_Mob_Focus()
	for index, _ in pairs(DB.Pet_Parse) do
		if mob_focus == DB.Widgets.Dropdown.Enum.NONE then
			if string.find(index, player_name .. ":") then
				total = DB.Pet_Catalog.Calculate(total, index, pet_name, trackable, action_name, metric)
			end
		else
			if string.find(index, player_name .. ":" .. mob_focus) then
				total = DB.Pet_Catalog.Calculate(total, index, pet_name, trackable, action_name, metric)
			end
		end
	end
	return total
end

------------------------------------------------------------------------------------------------------
-- Helper function for getting pet cataloged data.
-- Using an BST pet job ability like Razor Fang will create and index of player:pet with a nil pet node.
-- The actual damage will come later in the monster TP packet.
-- Data.Parse[index][pet_name] gets initialized in m.Init.Pet_Data.
------------------------------------------------------------------------------------------------------
---@param value number the value to increment the node by.
---@param index string "player_name:mob_name"
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return number
------------------------------------------------------------------------------------------------------
DB.Pet_Catalog.Calculate = function(value, index, pet_name, trackable, action_name, metric)
	if not DB.Pet_Parse[index][pet_name] then
		_Debug.Error.Add("Util.Pet_Catalog_Calc: Tried referencing uninitialized node. " .. tostring(index) .. " " .. tostring(pet_name) .. " " .. tostring(action_name))
		return value
	end

	if DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name] then
		if     metric == DB.Enum.Metric.MIN then value = DB.Pet_Catalog.Minimum(value, index, pet_name, trackable, action_name, metric)
		elseif metric == DB.Enum.Metric.MAX then value = DB.Pet_Catalog.Maximum(value, index, pet_name, trackable, action_name, metric)
		else   value = value + DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name][metric] end
	end

	return value
end

------------------------------------------------------------------------------------------------------
-- Helper function for getting pet cataloged data for minimum metric.
------------------------------------------------------------------------------------------------------
---@param min number current observed minimum value.
---@param index string "player_name:mob_name"
---@param pet_name string
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return number
------------------------------------------------------------------------------------------------------
DB.Pet_Catalog.Minimum = function(min, index, pet_name, trackable, action_name, metric)
	if min > DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name][metric] then
		min =  DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name][metric]
	end
	return min
end

------------------------------------------------------------------------------------------------------
-- Helper function for getting pet cataloged data for maximum metric.
------------------------------------------------------------------------------------------------------
---@param max number current observed maximum value.
---@param index string "player_name:mob_name"
---@param pet_name string
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return number
------------------------------------------------------------------------------------------------------
DB.Pet_Catalog.Maximum = function(max, index, pet_name, trackable, action_name, metric)
	if DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name][metric] > max then
		max = DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name][metric]
	end
	return max
end