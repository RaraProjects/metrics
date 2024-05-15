DB.Pet_Data = T{}

------------------------------------------------------------------------------------------------------
-- Initializes an [actor:target][pet_name] combination in the primary data node and catalog nodes.
-- Also initializes separate tracking globals for Running Accuracy.
-- If the "actor:target" combo has already been initialized then this will quit out early.
-- CALLED BY: Init.Data
------------------------------------------------------------------------------------------------------
---@param index string "actor_name:target_name"
---@param player_name? string used for maintaining various player indexed tables. In the case of pets this will be the owner.
---@param pet_name string used for maintaining various pet indexed tables.
------------------------------------------------------------------------------------------------------
DB.Pet_Data.Init = function(index, player_name, pet_name)
	if not index or not pet_name then
		_Debug.Error.Add("Pet_Data.Init: {" .. tostring(player_name) .. " {" .. tostring(pet_name) .. "} nil index passed in." )
		return false
	end

	if not DB.Pet_Parse[index] then DB.Pet_Parse[index] = {} end
	if DB.Pet_Parse[index][pet_name] then return false end

	DB.Pet_Parse[index][pet_name] = {}

	-- Initialize data nodes
	for _, trackable in pairs(DB.Enum.Trackable) do
		DB.Pet_Parse[index][pet_name][trackable] = {}
		DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG] = {}
		for _, metric in pairs(DB.Enum.Metric) do
			DB.Pet_Data.Set(0, index, pet_name, trackable, metric)
		end
	end

	-- Initialize pet tracking tables.
	if player_name and not DB.Tracking.Initialized_Pets[player_name] then
		DB.Tracking.Initialized_Pets[player_name] = {}
	end
	if player_name and not DB.Tracking.Initialized_Pets[player_name][pet_name] then
		DB.Tracking.Initialized_Pets[player_name][pet_name] = true
	end
end

------------------------------------------------------------------------------------------------------
-- Directly sets a pet's trackables metric to a specified value.
------------------------------------------------------------------------------------------------------
---@param value number the value to set the node to.
---@param index string "actor_name:target_name".
---@param pet_name string
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Pet_Data.Set = function(value, index, pet_name, trackable, metric)
	if not value or not index or not pet_name or not trackable or not metric then
		_Debug.Error.Add("Set.Pet_Data: {" .. tostring(index) .. "} {" .. tostring(trackable) .. "} nil required parameter passed in." )
		return false
	end
	DB.Pet_Parse[index][pet_name][trackable][metric] = value
	return true
end

------------------------------------------------------------------------------------------------------
-- Increments a pet's trackables metric by a specified amount.
------------------------------------------------------------------------------------------------------
---@param value number the value to increment the node by.
---@param index string "player_name:mob_name"
---@param pet_name string
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Pet_Data.Inc = function(value, index, pet_name, trackable, metric)
	if not value or not index or not pet_name or not trackable or not metric then
		_Debug.Error.Add("Inc.Pet_Data: {" .. tostring(index) .. "} {" .. tostring(pet_name) .. "} {" .. tostring(trackable) .. "} nil required parameter passed in." )
		return false
	end
	DB.Pet_Parse[index][pet_name][trackable][metric] = DB.Pet_Parse[index][pet_name][trackable][metric] + value
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
---@return number
------------------------------------------------------------------------------------------------------
DB.Pet_Data.Get = function(player_name, pet_name, trackable, metric)
	local total = 0
	local mob_focus = DB.Widgets.Util.Get_Mob_Focus()
	for index, _ in pairs(DB.Pet_Parse) do
		if mob_focus == DB.Widgets.Dropdown.Enum.NONE then
			if string.find(index, player_name .. ":") then
				if DB.Pet_Parse[index][pet_name] then
					total = total + DB.Pet_Parse[index][pet_name][trackable][metric]
				end
			end
		else
			if string.find(index, player_name .. ":" .. mob_focus) then
				if DB.Pet_Parse[index][pet_name] then
					total = total + DB.Pet_Parse[index][pet_name][trackable][metric]
				end
			end
		end
	end
	return total
end