DB.Catalog = { }

------------------------------------------------------------------------------------------------------
-- Initializes a cataloged action.
-- The base tables are initialized in the Init.Data and Init.Pet_Data functions.
-- If the action has already been initialized then this will quit out early.
-- Also initializes Trackable_Data which is used in the Focus Window.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param targetName string
---@param actionName string       the name of the action to be cataloged.
---@param trackable  DB.Trackable a tracked item from the trackable list.
---@param petName?   string
------------------------------------------------------------------------------------------------------
DB.Catalog.Initialize = function(playerName, targetName, actionName, trackable, petName)
	-- Early quit out to prevent crashing.
	local caller = "DB.Catalog.Initialize"
	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, targetName, "Target") or
	   DB.IsValueEmpty(caller, actionName, "Action") or
	   DB.IsValueEmpty(caller, trackable, "Trackable") then
		return false
	end

	-- Initializations
	DB.Data.Initialize(playerName, targetName)
	if petName then
		DB.PetData.Initialize(playerName, petName, targetName)
	end

	-- Don't want to overwrite data node if it already exists. This is for mob specfic data.
	local initializationList = { }
	if not DB.ParseCatalog[playerName] then DB.ParseCatalog[playerName] = { } end
	if not DB.ParseCatalog[playerName][targetName] then DB.ParseCatalog[playerName][targetName] = { } end
	if not DB.ParseCatalog[playerName][targetName][actionName] then DB.ParseCatalog[playerName][targetName][actionName] = { } end
	if not DB.ParseCatalog[playerName][targetName][actionName][trackable] then
		DB.ParseCatalog[playerName][targetName][actionName][trackable] = { }
		table.insert(initializationList, targetName)
	end

	-- Don't want to overwrite data node if it already exists. This is for all mob data.
	local allMobs = DB.Enum.ALL_MOBS
	if not DB.ParseCatalog[playerName][allMobs] then  DB.ParseCatalog[playerName][allMobs] = { } end
	if not DB.ParseCatalog[playerName][allMobs][actionName] then DB.ParseCatalog[playerName][allMobs][actionName] = { } end
	if not DB.ParseCatalog[playerName][allMobs][actionName][trackable] then
		DB.ParseCatalog[playerName][allMobs][actionName][trackable] = { }
		table.insert(initializationList, allMobs)
	end

	-- Make sure the pet catalog is also initialized if necessary.
	if petName then
		DB.PetCatalog.Initialize(playerName, petName, targetName, actionName, trackable)
	end

	-- Initialize data nodes.
	-- Need to set minimum high manually to capture accurate minimums.
	if #initializationList == 0 then
		return nil
	end

	for _, initializationTarget in ipairs(initializationList) do
		for _, metric in pairs(DB.Metric) do
			if DB.MetricNeedsMaxValue(metric) then
				DB.Catalog.Set(DB.Enum.MAX_DAMAGE, playerName, initializationTarget, actionName, trackable, metric)
			else
				DB.Catalog.Set(0, playerName, initializationTarget, actionName, trackable, metric)
			end
		end
	end

	-- Initialize tracking tables.
	if not DB.Tracking.Trackables[trackable] then DB.Tracking.Trackables[trackable] = { } end
	if not DB.Tracking.Trackables[trackable][playerName] then DB.Tracking.Trackables[trackable][playerName] = { } end
end

------------------------------------------------------------------------------------------------------
-- Directs the setting of cataloged data.
-- Called by the action handling functions.
------------------------------------------------------------------------------------------------------
---@param playerName     string       name of the player or entity performing the action.
---@param targetName     string       name of the mob or entity receiving the action.
---@param trackable      DB.Trackable a tracked item from the trackable list.
---@param damage         integer      damage value to be logged.
---@param actionName     string       the name of the action to be cataloged.
---@param petName?       string
---@param isCriticalHit? boolean      whether or not a critical hit or magic burst took place.
------------------------------------------------------------------------------------------------------
DB.Catalog.UpdateDamage = function(playerName, targetName, trackable, damage, actionName, petName, isCriticalHit)
	-- Early quit out to prevent crashing.
	local caller = "DB.Catalog.UpdateDamage"
	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, targetName, "Target") then
		return false
	end

	damage = damage or 0

	-- Double check initializations
    DB.Catalog.Initialize(playerName, targetName, actionName, trackable, petName)

	local audits =
	{
		player_name = playerName,
		target_name = targetName,
		pet_name    = petName,
	}

	-- Update the non-catalog database with the damage
	DB.Data.UpdateDamage(audits, trackable, damage, isCriticalHit)
	-- Everything after this is for the catalog.

	-- Total Damage
    DB.Catalog.UpdateMetric(DB.UpdateMode.INC, damage, audits, trackable, actionName, DB.Metric.TOTAL)
	if isCriticalHit then
		DB.Catalog.UpdateMetric(DB.UpdateMode.INC, damage, audits, trackable, actionName, DB.Metric.CRITICAL_DAMAGE)
	end

	-- Attempts on the target.
	DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, trackable, actionName, DB.Metric.ATTEMPTS_ON_TARGET)
	if isCriticalHit then
		DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, trackable, actionName, DB.Metric.CRITICAL_COUNT)
	end

	-- Set trackable hits and minimums
	local minMetric = (isCriticalHit and DB.Metric.CRITICAL_MIN) or DB.Metric.MIN
	local maxMetric = (isCriticalHit and DB.Metric.CRITICAL_MAX) or DB.Metric.MAX

    if damage > 0 then
		-- Log hits here since we have a damage check.
		DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, trackable, actionName, DB.Metric.HITS_ON_TARGET)

		-- Minimum damage.
		if damage < DB.Catalog.Get(playerName, trackable, actionName, minMetric, audits.target_name) then
			DB.Catalog.UpdateMetric(DB.UpdateMode.SET, damage, audits, trackable, actionName, minMetric)
		end
    end

    if damage > DB.Catalog.Get(playerName, trackable, actionName, maxMetric) then
    	-- Add a check for abnormally high healing magic to prevent Divine Seal from messing up overcure.
		if trackable == DB.Trackable.SPELLS_HEALING and DB.HealingMax[actionName] then
			if damage > DB.HealingMax[actionName] then
				damage = DB.HealingMax[actionName]
			end
		end

		-- Maximum damage.
		DB.Catalog.UpdateMetric(DB.UpdateMode.SET, damage, audits, trackable, actionName, maxMetric)
    end
end

------------------------------------------------------------------------------------------------------
-- A handler function that makes sure the data is set appropriately (for cataloged actions)
-- This does not set data directly. Rather, it calls the Set~ or Inc~ functions.
-- This is called by the functions that perform the action handling.
------------------------------------------------------------------------------------------------------
---@param mode       DB.UpdateMode flag calling out whether the data should be set or incremented.
---@param value      number        the value to set or increment the node to/by.
---@param audits     table         a table containing necessary data; helps save on parameter slots.
---@param trackable  DB.Trackable  a tracked item from the trackable list.
---@param actionName string        the name of the action to be cataloged.
---@param metric     DB.Metric     a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Catalog.UpdateMetric = function(mode, value, audits, trackable, actionName, metric)
	local playerName = audits.player_name
	local targetName = audits.target_name
	local petName    = audits.pet_name

	-- Early quit out to prevent crashing.
	local caller = "DB.Catalog.UpdateMetric"
	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, targetName, "Target") or
	   DB.IsValueEmpty(caller, actionName, "Action") or
	   DB.IsValueEmpty(caller, trackable,  "Trackable") or
	   DB.IsValueEmpty(caller, metric,     "Metric") then
		return false
	end

	-- Initialization
	DB.Catalog.Initialize(playerName, targetName, actionName, trackable, petName)
	DB.Tracking.InitializedPlayers[playerName] = DB.Tracking.InitializedPlayers[playerName] or true

	-- Set the data; loop once for mob-specific data and a second time for all mob data.
	local updateList = { targetName, DB.Enum.ALL_MOBS }

	for _, updateTarget in ipairs(updateList) do
		if mode == DB.UpdateMode.INC then
			DB.Catalog.Inc(value, playerName, updateTarget, actionName, trackable, metric)
			if petName then
				DB.PetCatalog.Inc(value, playerName, petName, updateTarget, actionName, trackable, metric)
			end

		elseif mode == DB.UpdateMode.SET then
			DB.Catalog.Set(value, playerName, updateTarget, actionName, trackable, metric)
			if petName then
				DB.PetCatalog.Set(value, playerName, petName, updateTarget, actionName, trackable, metric)
			end
		end
	end

	-- This is used for the focus window
	DB.Tracking.Trackables[trackable][playerName][actionName] = true

	if petName then
		if not DB.PetCatalog.InitializeTracking(trackable, playerName, petName) then
			return false
		end

		DB.Tracking.PetTrackables[trackable][playerName][petName][actionName] = true
	end

	return true
end

------------------------------------------------------------------------------------------------------
-- Directly sets a trackable's cataloged action metric to a specified value.
-- Some trackables need to be cataloged discretely in addition to holistically.
-- For example, metrics for weapons skill damage and metrics for each individual weapon skill.
-- The discrete tracking happens in the "catalog" node under each trackable.
------------------------------------------------------------------------------------------------------
---@param value      number       the value to set the node to
---@param playerName string
---@param targetName string
---@param actionName string       the name of the action to be cataloged.
---@param trackable  DB.Trackable a tracked item from the trackable list.
---@param metric     DB.Metric    a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Catalog.Set = function(value, playerName, targetName, actionName, trackable, metric)
	-- Early quit out to prevent crashing.
	-- Can't quit out early for blank metric nodes because this is used for initialization.
	local caller = "DB.Catalog.Set"
	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, targetName, "Target") or
	   DB.IsValueEmpty(caller, actionName, "Action") or
	   DB.IsValueEmpty(caller, trackable,  "Trackable") or
	   DB.IsValueEmpty(caller, metric,     "Metric") or
	   DB.IsValueEmpty(caller, value,      "Value") or
	   not DB.Catalog.IsIndexNodeInitialized(caller, true, playerName, targetName, actionName) then
		return false
	end

	-- Don't set an unfiltered minimum if the mob specific minimum isn't less than the unfiltered one.
	if DB.MetricNeedsMaxValue(metric) and targetName == DB.Enum.ALL_MOBS and
	   DB.ParseCatalog[playerName][targetName][actionName][trackable] and
	   DB.ParseCatalog[playerName][targetName][actionName][trackable][metric] and
	   value >= DB.ParseCatalog[playerName][targetName][actionName][trackable][metric] then
		return false
	end

	-- Apply the change.
	DB.ParseCatalog[playerName][targetName][actionName][trackable][metric] = value

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
---@param targetName string
---@param actionName string       the name of the action to be cataloged.
---@param trackable  DB.Trackable a tracked item from the trackable list.
---@param metric     DB.Metric    a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Catalog.Inc = function(value, playerName, targetName, actionName, trackable, metric)
	-- Early quit out to prevent crashing.
	local caller = "DB.Catalog.Inc"
	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, targetName, "Target") or
	   DB.IsValueEmpty(caller, actionName, "Action") or
	   DB.IsValueEmpty(caller, trackable,  "Trackable") or
	   DB.IsValueEmpty(caller, metric,     "Metric") or
	   DB.IsValueEmpty(caller, value,      "Value") or
	   not DB.Catalog.IsIndexNodeInitialized(caller, true, playerName, targetName, actionName) or
	   not DB.Catalog.IsMetricNodeInitialized(caller, true, playerName, targetName, actionName, trackable, metric) then
		return false
	end

	-- Apply the change.
	DB.ParseCatalog[playerName][targetName][actionName][trackable][metric] = DB.ParseCatalog[playerName][targetName][actionName][trackable][metric] + value

	return true
end

------------------------------------------------------------------------------------------------------
-- Gets data from a trackable's cataloged metric.
-- If the mob filter is set then only actions towards that mob are counted.
------------------------------------------------------------------------------------------------------
---@param playerName    string       the player or entity name to search data for.
---@param trackable     DB.Trackable a tracked item from the trackable list.
---@param actionName    string       the name of the action to be cataloged.
---@param metric        DB.Metric    a trackable's metric from the metric list.
---@param tempMobFocus? string       used to force look for a specific mob (mainly for setting minimums for AOEs).
---@return number
------------------------------------------------------------------------------------------------------
DB.Catalog.Get = function(playerName, trackable, actionName, metric, tempMobFocus)
	local caller = "DB.Catalog.Get"
	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, actionName, "Action") or
	   DB.IsValueEmpty(caller, trackable,  "Trackable") or
	   DB.IsValueEmpty(caller, metric,     "Metric") then
		return 0
	end

	-- Dont get new data unless we are in a new throttle cycle or cached data doesn't exist.
	if (Throttle.IsEnabled() and not Throttle.AllowCalculation()) and not tempMobFocus then
		if DB.CatalogCache[playerName] and
		   DB.CatalogCache[playerName][actionName] and
		   DB.CatalogCache[playerName][actionName][trackable] and
		   DB.CatalogCache[playerName][actionName][trackable][metric] then
			return DB.CatalogCache[playerName][actionName][trackable][metric]
		end
	end

	local value       = DB.MetricNeedsMaxValue(metric) and DB.Enum.MAX_DAMAGE or 0
	local targetIndex = tempMobFocus or DB.Widgets.GetMobFocus()

	-- Get the data.
	if DB.Catalog.IsIndexNodeInitialized(caller, false, playerName, targetIndex, actionName) then
		if DB.Catalog.IsMetricNodeInitialized(caller, false, playerName, targetIndex, actionName, trackable, metric) then
			value = DB.ParseCatalog[playerName][targetIndex][actionName][trackable][metric]
		end
	end

	-- Cache for performance.
	if not DB.CatalogCache[playerName] then DB.CatalogCache[playerName] = { } end
	if not DB.CatalogCache[playerName][actionName] then DB.CatalogCache[playerName][actionName] = { } end
	if not DB.CatalogCache[playerName][actionName][trackable] then DB.CatalogCache[playerName][actionName][trackable] = { } end
	DB.CatalogCache[playerName][actionName][trackable][metric] = value

	return value
end

------------------------------------------------------------------------------------------------------
-- Checks if the [player_name][target_name] nodes are initialized in the catalog database.
------------------------------------------------------------------------------------------------------
---@param caller     string
---@param writeError boolean
---@param playerName string
---@param targetName string
---@param actionName string
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Catalog.IsIndexNodeInitialized = function(caller, writeError, playerName, targetName, actionName)
	if not DB.ParseCatalog or
	   not DB.ParseCatalog[playerName] or
	   not DB.ParseCatalog[playerName][targetName] or
	   not DB.ParseCatalog[playerName][targetName][actionName] then
		if writeError then
			local errorMessage = string.format("Not initialized in DB.ParseCatalog[%s][%s][%s].", tostring(playerName), tostring(targetName), tostring(actionName))
			Debug.Error.Add(Debug.Error.ERROR, caller, errorMessage)
		end

		return false
	end

	return true
end

------------------------------------------------------------------------------------------------------
-- Checks if the [player_name][target_name][trackable][metric] nodes are initialized in the catalog database.
------------------------------------------------------------------------------------------------------
---@param caller     string
---@param writeError boolean
---@param playerName string
---@param targetName string
---@param actionName string
---@param trackable  DB.Trackable
---@param metric     DB.Metric
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Catalog.IsMetricNodeInitialized = function(caller, writeError, playerName, targetName, actionName, trackable, metric)
	if not DB.ParseCatalog or
	   not DB.ParseCatalog[playerName] or not DB.ParseCatalog[playerName][targetName] or
	   not DB.ParseCatalog[playerName][targetName][actionName] or not DB.ParseCatalog[playerName][targetName][actionName][trackable] or
	   not DB.ParseCatalog[playerName][targetName][actionName][trackable][metric] then
		if writeError then
			local errorMessage = string.format("Metric not initialized in DB.Parse_Catalog[%s][%s][%s][%s][%s].",
			                     tostring(playerName), tostring(targetName), tostring(actionName), tostring(trackable), tostring(metric))
			Debug.Error.Add(Debug.Error.ERROR, caller, errorMessage)
		end

		return false
	end

	return true
end