DB.Data = T{}

------------------------------------------------------------------------------------------------------
-- Initializes an "actor:target" combination in the primary data and catalog data nodes.
-- Also initializes separate tracking globals for Running Accuracy.
-- If the "actor:target" combo has already been initialized then this will quit out early.
-- CALLED BY: Init.Catalog, Update.Data, and Get.Total_Party_Damage
------------------------------------------------------------------------------------------------------
---@param index string "actor_name:target_name"
---@param player_name? string used for maintaining various player indexed tables. In the case of pets this will be the owner.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Data.Init = function(index, player_name)
	if not index then
		_Debug.Error.Add("Data.Init: {" .. tostring(player_name) .. "} nil index passed in." )
		return false
	end

	-- Check to see if the nodes have already been initialized for the player and the pet.
	if DB.Parse[index] then return false end

	-- Initialize primary node.
	DB.Parse[index] = {}

	-- Initialize data nodes
	for _, trackable in pairs(DB.Enum.Trackable) do
		DB.Parse[index][trackable] = {}
		DB.Parse[index][trackable][DB.Enum.Values.CATALOG] = {}
		for _, metric in pairs(DB.Enum.Metric) do
			DB.Data.Set(0, index, trackable, metric)
		end
	end

	-- Initialize tracking tables
	if player_name and not DB.Tracking.Initialized_Players[player_name] then
		DB.Tracking.Initialized_Players[player_name] = true
		DB.Lists.Sort.Players()
		DB.Tracking.Running_Accuracy[player_name] = T{}
	end

	return true
end

------------------------------------------------------------------------------------------------------
-- A handler function that makes sure the data is set appropriately.
-- This does not set data directly. Rather, it calls the Set~ or Inc~ functions.
-- This is called by the functions that perform the action handling.
------------------------------------------------------------------------------------------------------
---@param mode string flag calling out whether the data should be set or incremented.
---@param value number the value to set or increment the node to/by.
---@param audits table Contains necessary data; helps save on parameter slots.
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
------------------------------------------------------------------------------------------------------
DB.Data.Update = function(mode, value, audits, trackable, metric)
	local player_name = audits.player_name
	local target_name = audits.target_name
	local pet_name = audits.pet_name
	local index = DB.Data.Build_Index(player_name, target_name)
	DB.Data.Init(index, player_name)
	if pet_name then DB.Pet_Data.Init(index, player_name, pet_name) end

	if mode == DB.Enum.Mode.INC then
		DB.Data.Inc(value, index, trackable, metric)
		if pet_name then
			DB.Pet_Data.Inc(value, index, pet_name, trackable, metric)
		end
	elseif mode == DB.Enum.Mode.SET then
		DB.Data.Set(value, index, trackable, metric)
		if pet_name then
			DB.Pet_Data.Set(value, index, pet_name, trackable, metric)
		end
	end
end

------------------------------------------------------------------------------------------------------
-- Directly sets a trackable's metric to a specified value.
------------------------------------------------------------------------------------------------------
---@param value number the value to set the node to.
---@param index string "actor_name:target_name".
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Data.Set = function(value, index, trackable, metric)
	if not value or not index or not trackable or not metric then
		_Debug.Error.Add("Set.Data: {" .. tostring(index) .. "} {" .. tostring(trackable) .. "} nil required parameter passed in." )
		return false
	end
	DB.Parse[index][trackable][metric] = value
	return true
end

------------------------------------------------------------------------------------------------------
-- Increments a trackable's metric by a specified amount.
------------------------------------------------------------------------------------------------------
---@param value number the value to increment the node by.
---@param index string "player_name:mob_name"
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Data.Inc = function(value, index, trackable, metric)
	if not value or not index or not trackable or not metric then
		_Debug.Error.Add("Inc.Data: {" .. tostring(index) .. "} {" .. tostring(trackable) .. "} nil required parameter passed in." )
		return false
	end
	DB.Parse[index][trackable][metric] = DB.Parse[index][trackable][metric] + value
	return true
end

------------------------------------------------------------------------------------------------------
-- Gets data from a trackable metric.
-- If the mob filter is set then only actions towards that mob are counted.
------------------------------------------------------------------------------------------------------
---@param player_name string the player or entity name to search data for.
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
---@return number
------------------------------------------------------------------------------------------------------
DB.Data.Get = function(player_name, trackable, metric)
	if not player_name or not trackable or not metric then
		_Debug.Error.Add("Get.Data: Nil player name. " .. tostring(trackable) .. " " .. tostring(metric))
		return 0
	end

	local total = 0
	local mob_focus = Window.Util.Get_Mob_Focus()
	for index, _ in pairs(DB.Parse) do
		if mob_focus == Window.Dropdown.Enum.NONE then
			if string.find(index, player_name .. ":") then
				total = total + DB.Parse[index][trackable][metric]
			end
		else
			if string.find(index, player_name .. ":" .. mob_focus) then
				total = total + DB.Parse[index][trackable][metric]
			end
		end
	end
	return total
end

------------------------------------------------------------------------------------------------------
-- Builds the primary index in the form player_name:mob_name
------------------------------------------------------------------------------------------------------
---@param actor_name string name of the player or entity performing the action
---@param target_name? string name of the mob or entity receiving the action
---@return string [actor_name:target_name]
------------------------------------------------------------------------------------------------------
DB.Data.Build_Index = function(actor_name, target_name)
	if not target_name then
		_Debug.Error.Add("Util.Build_Index: {" .. tostring(actor_name) .. "} {" .. tostring(target_name) .. "} nil target name passed in.")
		target_name = DB.Enum.Values.DEBUG
	end
	if not actor_name then
		_Debug.Error.Add("Util.Build_Index: {" .. tostring(actor_name) .. "} {" .. tostring(target_name) .. "} nil actor name passed in.")
		return DB.Enum.Values.DEBUG
	end
	return actor_name..":"..target_name
end