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
DB.Data.Initialize = function(index, player_name)
	if not index then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Data.Initialize", "Nil index {" .. tostring(index) .. "} passed in.")
		return false
	end
	if not player_name or player_name == "" then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Data.Initialize", "Nil or blank player name: {" .. tostring(index) .. "}." )
		return false
	end

	-- Primary player data node initialization.
	if DB.Parse[index] then return false end
	DB.Parse[index] = T{}

	-- Initialize data nodes.
	for _, trackable in pairs(DB.Enum.Trackable) do
		DB.Parse[index][trackable] = T{}
		for _, metric in pairs(DB.Metric) do

			-- Need to set minimum high manually to capture accurate minimums.
			if metric == DB.Metric.MIN then
				DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, trackable, metric)
			else
				DB.Data.Set(0, index, trackable, metric)
			end

		end
	end

	DB.Data.Initialize_Player_Tracking_Tables(player_name)

	return true
end

------------------------------------------------------------------------------------------------------
-- Initializes a player in the player list.
------------------------------------------------------------------------------------------------------
---@param player_name? string
------------------------------------------------------------------------------------------------------
DB.Data.Initialize_Player_Tracking_Tables = function(player_name)
	if player_name and player_name ~= "" and not DB.Tracking.Initialized_Players[player_name] then
		DB.Tracking.Initialized_Players[player_name] = true
		DB.Lists.Sort.Players()
		DB.Tracking.Running_Accuracy[player_name] = T{}
		DB.Tracking.Running_Damage[player_name] = 0
		DB.Tracking.Running_Attack_Speed[player_name] = T{}
		DB.Tracking.Multi_Attack[player_name] = T{}
	end
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
	if audits.player_name == "" or audits.target_name == "" then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Data.Update", "Empty name: Player {" .. tostring(audits.player_name) .. "} Target {"
		.. tostring(audits.target_name) .. "} Trackable {" .. tostring(trackable) .. "} Metric {" .. tostring(metric) .. "}.")
		return nil
	end

	local player_name = audits.player_name
	local target_name = audits.target_name
	local pet_name = audits.pet_name
	local index = DB.Data.Build_Index(player_name, target_name)
	DB.Data.Initialize(index, player_name)
	if pet_name then DB.Pet_Data.Initialize(index, player_name, pet_name) end

	-- Peform the operation.
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

	-- Increment the running damage count for DPS if this is a total damage increase.
	if mode == DB.Enum.Mode.INC and trackable == DB.Enum.Trackable.TOTAL and metric == DB.Metric.TOTAL then
		DB.DPS.Inc_Buffer(player_name, value)
	end
end

------------------------------------------------------------------------------------------------------
-- Called by the catalog update damage function.
-- Handles the regular database portion of damage updates.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param trackable string a tracked item from the trackable list.
---@param damage number damage value to be logged.
---@param burst? boolean whether or not a magic burst took place.
------------------------------------------------------------------------------------------------------
DB.Data.Update_Damage = function(audits, trackable, damage, burst)
	-- Grand Totals; There is a regular track and a "no skillchains" track.
    if DB.Catalog.Include_Total_Damage(trackable) then
    	DB.Data.Update(DB.Enum.Mode.INC, damage, audits, DB.Enum.Trackable.TOTAL, DB.Metric.TOTAL)
		if trackable ~= DB.Enum.Trackable.SC then
			DB.Data.Update(DB.Enum.Mode.INC, damage, audits, DB.Enum.Trackable.TOTAL_NO_SC, DB.Metric.TOTAL)
		end
    end

    -- Trackable Total
    DB.Data.Update(DB.Enum.Mode.INC, damage, audits, trackable, DB.Metric.TOTAL)
	if burst then
		DB.Data.Update(DB.Enum.Mode.INC, damage, audits, DB.Enum.Trackable.MAGIC, DB.Metric.MAGIC_BURST_DAMAGE)
		DB.Data.Update(DB.Enum.Mode.INC, damage, audits, trackable, DB.Metric.MAGIC_BURST_DAMAGE)
	end

	-- Trackable Minimum
	-- We can't log a miss (0 damage) to MIN because then the miminum will always be zero.
	if audits.pet_name then
		if damage > 0 and damage < DB.Pet_Data.Get(audits.player_name, audits.pet_name, trackable, DB.Metric.MIN) then
			DB.Data.Update(DB.Enum.Mode.SET, damage, audits, trackable, DB.Metric.MIN)
		end
	else
		if damage > 0 and damage < DB.Data.Get(audits.player_name, trackable, DB.Metric.MIN, audits.target_name) then
			DB.Data.Update(DB.Enum.Mode.SET, damage, audits, trackable, DB.Metric.MIN)
		end
	end

	-- Trackable Maximum
    if damage > DB.Data.Get(audits.player_name, trackable, DB.Metric.MAX) then
		DB.Data.Update(DB.Enum.Mode.SET, damage, audits, trackable, DB.Metric.MAX)
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
		Debug.Error.Add(Debug.Error.ERROR, "DB.Data.Set", "Index {" .. tostring(index) .. "} Trackable {" .. tostring(trackable) .. "} Metric {"
		.. tostring(metric) .. "} nil required parameter passed in.")
		return false
	end
	if not DB.Parse or not DB.Parse[index] then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Data.Set", "Index {" .. tostring(index) .. "} is not initialized.")
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
		Debug.Error.Add(Debug.Error.ERROR, "DB.Data.Inc", "Index {" .. tostring(index) .. "} Trackable {" .. tostring(trackable) .. "} Metric {"
		.. tostring(metric) .. "} nil required parameter passed in.")
		return false
	end
	if not DB.Parse or not DB.Parse[index] or not DB.Parse[index][trackable] or not DB.Parse[index][trackable][metric] then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Data.Inc", "DB.Parse uninitialized: Index {" .. tostring(index) .. "} Trackable {" .. tostring(trackable)
		.. "} Metric {" .. tostring(metric) .. "}." )
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
---@param temporary_mob_focus? string used to force look for a specific mob (mainly for setting minimums for AOEs).
---@return number
------------------------------------------------------------------------------------------------------
DB.Data.Get = function(player_name, trackable, metric, temporary_mob_focus)
	if not player_name or not trackable or not metric then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Data.Get", "Nil required parameter: Player {" .. tostring(player_name) .. "} Trackable {"
		.. tostring(trackable) .. "} Metric {" .. tostring(metric) .. "}.")
		return 0
	end

	-- Dont get new data unless we are in a new throttle cycle or cached data doesn't exist.
	if Throttle.Is_Enabled() and not Throttle.Allow_Calculation() then
		if DB.Cache[player_name] and DB.Cache[player_name][trackable] and DB.Cache[player_name][trackable][metric] then
			return DB.Cache[player_name][trackable][metric]
		end
	end

	local total = 0
	if metric == DB.Metric.MIN then total = DB.Enum.Values.MAX_DAMAGE end
	local mob_focus = DB.Widgets.Util.Get_Mob_Focus()
	local search_string = player_name .. ":" .. mob_focus
	if mob_focus == DB.Widgets.Dropdown.Enum.NONE then search_string = player_name .. ":" end
	if temporary_mob_focus then search_string = player_name .. ":" .. temporary_mob_focus end

	for index, _ in pairs(DB.Parse) do
		if string.find(index, search_string) then
			local value = DB.Parse[index][trackable][metric]
			if metric == DB.Metric.MIN then
				if value < total then total = value end
			elseif metric == DB.Metric.MAX then
				if value > total then total = value end
			else
				total = total + value
			end
		end
	end

	-- Cache for performance.
	if not DB.Cache[player_name] then DB.Cache[player_name] = T{} end
	if not DB.Cache[player_name][trackable] then DB.Cache[player_name][trackable] = T{} end
	DB.Cache[player_name][trackable][metric] = total

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
		Debug.Error.Add(Debug.Error.ERROR, "DB.Data.Build_Index", "Nil target name: Actor {" .. tostring(actor_name) .. "} Target {"
		.. tostring(target_name) .. "}.")
		target_name = DB.Enum.Values.DEBUG
	end
	if not actor_name then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Data.Build_Index", "Nil actor name: Actor {" .. tostring(actor_name) .. "} Target {"
		.. tostring(target_name) .. "}.")
		actor_name = DB.Enum.Values.DEBUG
	end

	return actor_name .. ":" .. target_name
end