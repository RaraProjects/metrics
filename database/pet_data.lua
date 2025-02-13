DB.PetData = { }

------------------------------------------------------------------------------------------------------
-- Initializes an [actor:target][pet_name] combination in the primary data node and catalog nodes.
-- Also initializes separate tracking globals for Running Accuracy.
-- If the "actor:target" combo has already been initialized then this will quit out early.
-- CALLED BY: Init.Data
------------------------------------------------------------------------------------------------------
---@param playerName string used for maintaining various player indexed tables. In the case of pets this will be the owner.
---@param petName    string used for maintaining various pet indexed tables.
---@param targetName string
------------------------------------------------------------------------------------------------------
DB.PetData.Initialize = function(playerName, petName, targetName)
	-- Early quit out to prevent crashing.
	local caller = "DB.PetData.Initialize"
	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, targetName, "Target") or
	   DB.IsValueEmpty(caller, petName,    "Pet") then
		return false
	end

	-- Don't want to overwrite data node if it already exists. This is for mob specfic data.
	local initializationList = { }
	if not DB.PetParse[playerName] then DB.PetParse[playerName] = { } end
	if not DB.PetParse[playerName][petName] then DB.PetParse[playerName][petName] = { } end
	if not DB.PetParse[playerName][petName][targetName] then
		DB.PetParse[playerName][petName][targetName] = { }
		table.insert(initializationList, targetName)
	end

	-- Don't want to overwrite data node if it already exists. This is for all mob data.
	local allMobs = DB.Enum.ALL_MOBS
	if not DB.PetParse[playerName][petName] then DB.PetParse[playerName][petName] = { } end
	if not DB.PetParse[playerName][petName][allMobs] then
		DB.PetParse[playerName][petName][allMobs] = { }
		table.insert(initializationList, allMobs)
	end

	-- Initialize data nodes.
	-- Need to set minimum high manually to capture accurate minimums.
	if #initializationList == 0 then
		return false
	end

	for _, initializationTarget in ipairs(initializationList) do
		for _, trackable in pairs(DB.Trackable) do
			DB.PetParse[playerName][petName][initializationTarget][trackable] = { }

			for _, metric in pairs(DB.Metric) do
				if DB.MetricNeedsMaxValue(metric) then
					DB.PetData.Set(DB.Enum.MAX_DAMAGE, playerName, petName, initializationTarget, trackable, metric)
				else
					DB.PetData.Set(0, playerName, petName, initializationTarget, trackable, metric)
				end
			end
		end
	end

	-- Initialize pet tracking tables.
	if playerName and not DB.Tracking.InitializedPets[playerName] then DB.Tracking.InitializedPets[playerName] = { } end
	if playerName and not DB.Tracking.InitializedPets[playerName][petName] then DB.Tracking.InitializedPets[playerName][petName] = true end
end

------------------------------------------------------------------------------------------------------
-- Directly sets a pet's trackables metric to a specified value.
------------------------------------------------------------------------------------------------------
---@param value      number       the value to set the node to.
---@param playerName string
---@param petName    string
---@param targetName string
---@param trackable  DB.Trackable a tracked item from the trackable list.
---@param metric     DB.Metric    a trackable's metric from the metric
---@return boolean
------------------------------------------------------------------------------------------------------
DB.PetData.Set = function(value, playerName, petName, targetName, trackable, metric)
	-- Early quit out to prevent crashing.
	-- Can't quit out early for blank metric nodes because this is used for initialization.
	local caller = "DB.PetData.Set"
	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, targetName, "Target") or
	   DB.IsValueEmpty(caller, petName,    "Pet") or
	   DB.IsValueEmpty(caller, trackable,  "Trackable") or
	   DB.IsValueEmpty(caller, metric,     "Metric") or
	   DB.IsValueEmpty(caller, value,      "Value") or
	   not DB.PetData.IsIndexNodeInitialized(caller, true, playerName, petName, targetName) then
		return false
	end

	-- Don't set an unfiltered minimum if the mob specific minimum isn't less than the unfiltered one.
	if DB.MetricNeedsMaxValue(metric) and
	   targetName == DB.Enum.ALL_MOBS and
	   DB.PetParse[playerName][petName][targetName][trackable][metric] and
	   value >= DB.PetParse[playerName][petName][targetName][trackable][metric] then
		return false
	end

	-- Apply the change.
	DB.PetParse[playerName][petName][targetName][trackable][metric] = value

	return true
end

------------------------------------------------------------------------------------------------------
-- Increments a pet's trackables metric by a specified amount.
------------------------------------------------------------------------------------------------------
---@param value      number       the value to increment the node by.
---@param playerName string
---@param petName    string
---@param targetName string
---@param trackable  DB.Trackable a tracked item from the trackable list.
---@param metric     DB.Metric    a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.PetData.Inc = function(value, playerName, petName, targetName, trackable, metric)
	-- Early quit out to prevent crashing.
	local caller = "DB.PetData.Inc"
	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, targetName, "Target") or
	   DB.IsValueEmpty(caller, petName,    "Pet") or
	   DB.IsValueEmpty(caller, trackable,  "Trackable") or
	   DB.IsValueEmpty(caller, metric,     "Metric") or
	   DB.IsValueEmpty(caller, value,      "Value") or
	   not DB.PetData.IsIndexNodeInitialized(caller, true, playerName, petName, targetName) or
	   not DB.PetData.IsMetricNodeInitialized(caller, true, playerName, petName, targetName, trackable, metric) then
		return false
	end

	-- Apply the change.
	DB.PetParse[playerName][petName][targetName][trackable][metric] = DB.PetParse[playerName][petName][targetName][trackable][metric] + value

	return true
end

------------------------------------------------------------------------------------------------------
-- Gets data from a pet's trackable metric.
-- If the mob filter is set then only actions towards that mob are counted.
-- Consider that not every player:mob index will have a pet node.
------------------------------------------------------------------------------------------------------
---@param playerName    string       the player or entity name to search data for.
---@param petName       string
---@param trackable     DB.Trackable a tracked item from the trackable list.
---@param metric        DB.Metric    a trackable's metric from the metric list.
---@param tempMobFocus? string       used to force look for a specific mob (mainly for setting minimums for AOEs).
---@return number
------------------------------------------------------------------------------------------------------
DB.PetData.Get = function(playerName, petName, trackable, metric, tempMobFocus)
	local caller = "DB.PetData.Get"
	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, petName,    "Pet") or
	   DB.IsValueEmpty(caller, trackable,  "Trackable") or
	   DB.IsValueEmpty(caller, metric,     "Metric") then
		return 0
	end

	-- Dont get new data unless we are in a new throttle cycle or cached data doesn't exist.
	if (Throttle.Is_Enabled() and not Throttle.Allow_Calculation()) and not tempMobFocus then
		if DB.PetCache[playerName] and
		   DB.PetCache[playerName][petName] and
		   DB.PetCache[playerName][petName][trackable] and
		   DB.PetCache[playerName][petName][trackable][metric] then
			return DB.PetCache[playerName][petName][trackable][metric]
		end
	end

	-- The target index will just be the mob focus unless a temporary focus is passed in.
	-- The mob focus will handle the ALL_MOBS too.
	local value       = DB.MetricNeedsMaxValue(metric) and DB.Enum.MAX_DAMAGE or 0
	local targetIndex = tempMobFocus or DB.Widgets.Util.Get_Mob_Focus()

	-- Get the data.
	if DB.PetData.IsIndexNodeInitialized(caller, false, playerName, petName, targetIndex) then
		if DB.PetData.IsMetricNodeInitialized(caller, false, playerName, petName, targetIndex, trackable, metric) then
			value = DB.PetParse[playerName][petName][targetIndex][trackable][metric]
		end
	end

	-- Cache for performance.
	if not DB.PetCache[playerName] then DB.PetCache[playerName] = { } end
	if not DB.PetCache[playerName][petName] then DB.PetCache[playerName][petName] = { } end
	if not DB.PetCache[playerName][petName][trackable] then DB.PetCache[playerName][petName][trackable] = { } end
	DB.PetCache[playerName][petName][trackable][metric] = value

	return value
end

------------------------------------------------------------------------------------------------------
-- Checks if the [player_name][target_name] nodes are initialized in the pet primary database.
------------------------------------------------------------------------------------------------------
---@param caller     string
---@param writeError boolean
---@param playerName string
---@param petName    string
---@param targetName string
---@return boolean
------------------------------------------------------------------------------------------------------
DB.PetData.IsIndexNodeInitialized = function(caller, writeError, playerName, petName, targetName)
	if not DB.PetParse or
	   not DB.PetParse[playerName] or
	   not DB.PetParse[playerName][petName] or
	   not DB.PetParse[playerName][petName][targetName] then
		if writeError then
			local errorMessage = string.format("Not initialized in DB.Pet_Parse[%s][%s][%s].", tostring(playerName), tostring(petName), tostring(targetName))
			Debug.Error.Add(Debug.Error.ERROR, caller, errorMessage)
		end

		return false
	end

	return true
end

------------------------------------------------------------------------------------------------------
-- Checks if the [player_name][target_name][trackable][metric] nodes are initialized in the pet primary database.
------------------------------------------------------------------------------------------------------
---@param caller     string
---@param writeError boolean
---@param playerName string
---@param petName    string
---@param targetName string
---@param trackable  DB.Trackable
---@param metric     DB.Metric
---@return boolean
------------------------------------------------------------------------------------------------------
DB.PetData.IsMetricNodeInitialized = function(caller, writeError, playerName, petName, targetName, trackable, metric)
	if not DB.PetParse or
	   not DB.PetParse[playerName] or
	   not DB.PetParse[playerName][petName] or
	   not DB.PetParse[playerName][petName][targetName] or
	   not DB.PetParse[playerName][petName][targetName][trackable] or
	   not DB.PetParse[playerName][petName][targetName][trackable][metric] then
		if writeError then
			local errorMessage = string.format("Metric not initialized in DB.Pet_Parse[%s][%s][%s][%s][%s].",
			                     tostring(playerName), tostring(petName), tostring(targetName), tostring(trackable), tostring(metric))
			Debug.Error.Add(Debug.Error.ERROR, caller, errorMessage)
		end

		return false
	end

	return true
end