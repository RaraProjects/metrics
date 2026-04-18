DB.PetCatalog = { }

------------------------------------------------------------------------------------------------------
-- Initializes a pet cataloged action.
-- If the action has already been initialized then this will quit out early.
-- Also initializes Trackable_Data which is used in the Focus Window.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param petName    string
---@param targetName string
---@param actionName string              the name of the action to be cataloged.
---@param trackable  DB.Trackable|string a tracked item from the trackable list.
------------------------------------------------------------------------------------------------------
DB.PetCatalog.Initialize = function(playerName, petName, targetName, actionName, trackable)
	-- Early quit out to prevent crashing.
	local caller = "DB.PetCatalog.Initialize"
	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, targetName, "Target") or
	   DB.IsValueEmpty(caller, petName,    "Pet") then
		return false
	end

	-- Don't want to overwrite data node if it already exists. This is for mob specfic data.
	local initializationList = { }
	if not DB.PetParseCatalog[playerName] then DB.PetParseCatalog[playerName] = { } end
	if not DB.PetParseCatalog[playerName][petName] then DB.PetParseCatalog[playerName][petName] = { } end
	if not DB.PetParseCatalog[playerName][petName][targetName] then DB.PetParseCatalog[playerName][petName][targetName] = { } end
	if not DB.PetParseCatalog[playerName][petName][targetName][actionName] then DB.PetParseCatalog[playerName][petName][targetName][actionName] = { } end
	if not DB.PetParseCatalog[playerName][petName][targetName][actionName][trackable] then
		DB.PetParseCatalog[playerName][petName][targetName][actionName][trackable] = { }
		table.insert(initializationList, targetName)
	end

	-- Don't want to overwrite data node if it already exists. This is for all mob data.
	local allMobs = DB.Enum.ALL_MOBS
	if not DB.PetParseCatalog[playerName] then DB.PetParseCatalog[playerName] = { } end
	if not DB.PetParseCatalog[playerName][petName] then DB.PetParseCatalog[playerName][petName] = { } end
	if not DB.PetParseCatalog[playerName][petName][allMobs] then DB.PetParseCatalog[playerName][petName][allMobs] = { } end
	if not DB.PetParseCatalog[playerName][petName][allMobs][actionName] then DB.PetParseCatalog[playerName][petName][allMobs][actionName] = { } end
	if not DB.PetParseCatalog[playerName][petName][allMobs][actionName][trackable] then
		DB.PetParseCatalog[playerName][petName][allMobs][actionName][trackable] = { }
		table.insert(initializationList, allMobs)
	end

	-- Initialize data nodes.
	-- Need to set minimum high manually to capture accurate minimums.
	if #initializationList == 0 then
		return nil
	end

	for _, initializationTarget in ipairs(initializationList) do
		for _, metric in pairs(DB.Metric) do
			if DB.MetricNeedsMaxValue(metric) then
				DB.PetCatalog.Set(DB.Enum.MAX_DAMAGE, playerName, petName, initializationTarget, actionName, trackable, metric)
			else
				DB.PetCatalog.Set(0, playerName, petName, initializationTarget, actionName, trackable, metric)
			end
		end
	end

	-- Initialize tracking tables.
	DB.PetCatalog.InitializeTracking(trackable, playerName, petName)
end

------------------------------------------------------------------------------------------------------
-- Initializes a pet trackable.
------------------------------------------------------------------------------------------------------
---@param trackable  DB.Trackable a tracked item from the trackable list.
---@param playerName string
---@param petName    string
---@return boolean true: successful initialization; false: error
------------------------------------------------------------------------------------------------------
DB.PetCatalog.InitializeTracking = function(trackable, playerName, petName)
	-- Early quit out to prevent crashing.
	local caller = "DB.PetCatalog.Initialize_Tracking"
	if DB.IsValueEmpty(caller, trackable,  "Trackable") or
	   DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, petName,    "Pet") then
		return false
	end

	if not DB.Tracking.PetTrackables[trackable] then DB.Tracking.PetTrackables[trackable] = { } end
	if not DB.Tracking.PetTrackables[trackable][playerName] then DB.Tracking.PetTrackables[trackable][playerName] = { } end
	if not DB.Tracking.PetTrackables[trackable][playerName][petName] then DB.Tracking.PetTrackables[trackable][playerName][petName] = { } end

	return true
end

------------------------------------------------------------------------------------------------------
-- Directly sets a pet's trackables cataloged action metric to a specified value.
-- Some trackables need to be cataloged discretely in addition to holistically.
-- For example, metrics for weapons skill damage and metrics for each individual weapon skill.
-- The discrete tracking happens in the "catalog" node under each trackable.
------------------------------------------------------------------------------------------------------
---@param value      number       the value to set the node to
---@param playerName string
---@param petName    string
---@param targetName string
---@param actionName string       the name of the action to be cataloged.
---@param trackable  DB.Trackable a tracked item from the trackable list.
---@param metric     DB.Metric    a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.PetCatalog.Set = function(value, playerName, petName, targetName, actionName, trackable, metric)
	-- Early quit out to prevent crashing.
	-- Can't quit out early for blank metric nodes because this is used for initialization.
	local caller = "DB.PetCatalog.Set"
	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, targetName, "Target") or
	   DB.IsValueEmpty(caller, petName,    "Pet") or
	   DB.IsValueEmpty(caller, actionName, "Action") or
	   DB.IsValueEmpty(caller, trackable,  "Trackable") or
	   DB.IsValueEmpty(caller, metric,     "Metric") or
	   DB.IsValueEmpty(caller, value,      "Value") or
	   not DB.PetCatalog.IsIndexNodeInitialized(caller, true, playerName, petName, targetName, actionName) then
		return false
	end

	-- Don't set an unfiltered minimum if the mob specific minimum isn't less than the unfiltered one.
	if DB.MetricNeedsMaxValue(metric) and
	   targetName == DB.Enum.ALL_MOBS and
	   DB.PetParseCatalog[playerName][petName][targetName][actionName][trackable] and
	   DB.PetParseCatalog[playerName][petName][targetName][actionName][trackable][metric] and
	   value >= DB.PetParseCatalog[playerName][petName][targetName][actionName][trackable][metric] then
		return false
	end

	-- Apply the change.
	DB.PetParseCatalog[playerName][petName][targetName][actionName][trackable][metric] = value

	return true
end

------------------------------------------------------------------------------------------------------
-- Increments a trackable's metric by a specified amount.
-- Some trackables need to be cataloged discretely in addition to holistically.
-- For example, metrics for weapons skill damage and metrics for each individual weapon skill.
-- The discrete tracking happens in the "catalog" node under each trackable.
------------------------------------------------------------------------------------------------------
---@param value      number       the value to increment the node by.
---@param playerName string
---@param petName    string
---@param targetName string
---@param actionName string       the name of the action to be cataloged.
---@param trackable  DB.Trackable a tracked item from the trackable list.
---@param metric     DB.Metric    a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.PetCatalog.Inc = function(value, playerName, petName, targetName, actionName, trackable, metric)
	-- Early quit out to prevent crashing.
	-- Can't quit out early for blank metric nodes because this is used for initialization.
	local caller = "DB.PetCatalog.Inc"
	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, targetName, "Target") or
	   DB.IsValueEmpty(caller, petName,    "Pet") or
	   DB.IsValueEmpty(caller, actionName, "Action") or
	   DB.IsValueEmpty(caller, trackable,  "Trackable") or
	   DB.IsValueEmpty(caller, metric,     "Metric") or
	   DB.IsValueEmpty(caller, value,      "Value") or
	   not DB.PetCatalog.IsIndexNodeInitialized(caller, true, playerName, petName, targetName, actionName) or
	   not DB.PetCatalog.IsMetricNodeInitialized(caller, true, playerName, petName, targetName, actionName, trackable, metric) then
		return false
	end

	DB.PetParseCatalog[playerName][petName][targetName][actionName][trackable][metric]
	= DB.PetParseCatalog[playerName][petName][targetName][actionName][trackable][metric] + value

	return true
end

------------------------------------------------------------------------------------------------------
-- Gets data from a pet's trackables cataloged metric.
-- If the mob filter is set then only actions towards that mob are counted.
------------------------------------------------------------------------------------------------------
---@param playerName    string       the player or entity name to search data for.
---@param petName       string
---@param trackable     DB.Trackable a tracked item from the trackable list.
---@param actionName    string       the name of the action to be cataloged.
---@param metric        DB.Metric    a trackable's metric from the metric list.
---@param tempMobFocus? string       used to force look for a specific mob (mainly for setting minimums for AOEs).
---@return number
------------------------------------------------------------------------------------------------------
DB.PetCatalog.Get = function(playerName, petName, trackable, actionName, metric, tempMobFocus)
	local caller = "DB.PetCatalog.Get"
	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, petName,    "Pet") or
	   DB.IsValueEmpty(caller, actionName, "Action") or
	   DB.IsValueEmpty(caller, trackable,  "Trackable") or
	   DB.IsValueEmpty(caller, metric,     "Metric") then
		return 0
	end

	-- Dont get new data unless we are in a new throttle cycle or cached data doesn't exist.
	if (Throttle.IsEnabled() and not Throttle.AllowCalculation()) and not tempMobFocus then
		if DB.PetCatalogCache[playerName] and
		   DB.PetCatalogCache[playerName][petName] and
		   DB.PetCatalogCache[playerName][petName][actionName] and
		   DB.PetCatalogCache[playerName][petName][actionName][trackable] and
		   DB.PetCatalogCache[playerName][petName][actionName][trackable][metric] then
			return DB.PetCatalogCache[playerName][petName][actionName][trackable][metric]
		end
	end

	local value       = DB.MetricNeedsMaxValue(metric) and DB.Enum.MAX_DAMAGE or 0
	local targetIndex = tempMobFocus or DB.Widgets.GetMobFocus()

	-- Get the data.
	if DB.PetCatalog.IsIndexNodeInitialized(caller, false, playerName, petName, targetIndex, actionName) then
		if DB.PetCatalog.IsMetricNodeInitialized(caller, false, playerName, petName, targetIndex, actionName, trackable, metric) then
			value = DB.PetParseCatalog[playerName][petName][targetIndex][actionName][trackable][metric]
		end
	end

	-- Cache for performance.
	if not DB.PetCatalogCache[playerName] then DB.PetCatalogCache[playerName] = { } end
	if not DB.PetCatalogCache[playerName][petName] then DB.PetCatalogCache[playerName][petName] = { } end
	if not DB.PetCatalogCache[playerName][petName][actionName] then DB.PetCatalogCache[playerName][petName][actionName] = { } end
	if not DB.PetCatalogCache[playerName][petName][actionName][trackable] then DB.PetCatalogCache[playerName][petName][actionName][trackable] = { } end
	DB.PetCatalogCache[playerName][petName][actionName][trackable][metric] = value

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
---@param actionName string
---@return boolean
------------------------------------------------------------------------------------------------------
DB.PetCatalog.IsIndexNodeInitialized = function(caller, writeError, playerName, petName, targetName, actionName)
	if not DB.PetParseCatalog or
	   not DB.PetParseCatalog[playerName] or
	   not DB.PetParseCatalog[playerName][petName] or
	   not DB.PetParseCatalog[playerName][petName][targetName] then
		if writeError then
			local errorMessage = string.format("Not initialized in DB.PetParseCatalog[%s][%s][%s][%s].",
			                     tostring(playerName), tostring(petName), tostring(targetName), tostring(actionName))
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
---@param actionName string
---@param trackable  DB.Trackable
---@param metric     DB.Metric
---@return boolean
------------------------------------------------------------------------------------------------------
DB.PetCatalog.IsMetricNodeInitialized = function(caller, writeError, playerName, petName, targetName, actionName, trackable, metric)
	if not DB.PetParseCatalog or
	   not DB.PetParseCatalog[playerName] or
	   not DB.PetParseCatalog[playerName][petName] or
	   not DB.PetParseCatalog[playerName][petName][targetName] or
	   not DB.PetParseCatalog[playerName][petName][targetName][actionName] or
	   not DB.PetParseCatalog[playerName][petName][targetName][actionName][trackable] or
	   not DB.PetParseCatalog[playerName][petName][targetName][actionName][trackable][metric] then
		if writeError then
			local errorMessage = string.format("Metric not initialized in DB.PetParseCatalog[%s][%s][%s][%s][%s][%s].",
			                     tostring(playerName), tostring(petName), tostring(targetName), tostring(actionName), tostring(trackable), tostring(metric))
			Debug.Error.Add(Debug.Error.ERROR, caller, errorMessage)
		end

		return false
	end

	return true
end