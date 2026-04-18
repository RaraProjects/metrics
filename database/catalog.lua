-- Performance review: 01/16/26

DB.Catalog = { }

-- Local holders for common global tables--performance+.
---@type table
local catalogParse  = nil
---@type table
local trackables    = nil
---@type table
local metrics       = nil
---@type table
local trackingLists = nil
---@type table
local updateMode    = nil
---@type table
local lists         = nil
---@type table
local cache         = nil
---@type table
local dbData        = nil

------------------------------------------------------------------------------------------------------
-- Directly sets a trackable's cataloged action metric to a specified value.
-- Some trackables need to be cataloged discretely in addition to holistically.
-- For example, metrics for weapons skill damage and metrics for each individual weapon skill.
-- CALLER SHOULD ENSURE ARGUMENTS EXIST!!!
------------------------------------------------------------------------------------------------------
---@param newValue   number       the value to set the node to
---@param playerName string
---@param targetName string
---@param actionName string       the name of the action to be cataloged.
---@param trackable  DB.Trackable a tracked item from the trackable list.
---@param metric     DB.Metric    a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
local set = function(newValue, playerName, targetName, actionName, trackable, metric)
    local playerData    = catalogParse[playerName]
    local targetData    = playerData and playerData[targetName]
    local actionData    = targetData and targetData[actionName]
    local trackableData = actionData and actionData[trackable]

    if not trackableData then
        return false
    end

    local currentValue = trackableData[metric]

	-- Don't set an unfiltered minimum if the mob specific minimum isn't less than the unfiltered one.
    if DB.MetricNeedsMaxValue(metric) and
       targetName == DB.Enum.ALL_MOBS and
       currentValue and
       newValue >= currentValue
    then
        return false
    end

	-- Apply the change.
	trackableData[metric] = newValue

	return true
end

------------------------------------------------------------------------------------------------------
-- Increments a trackable's metric by a specified amount.
-- Some trackables need to be cataloged discretely in addition to holistically.
-- For example, metrics for weapons skill damage and metrics for each individual weapon skill.
-- CALLER SHOULD ENSURE ARGUMENTS EXIST!!!
------------------------------------------------------------------------------------------------------
---@param newValue   number       the value to increment the node by.
---@param playerName string
---@param targetName string
---@param actionName string       the name of the action to be cataloged.
---@param trackable  DB.Trackable a tracked item from the trackable list.
---@param metric     DB.Metric    a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
local inc = function(newValue, playerName, targetName, actionName, trackable, metric)
    local playerData    = catalogParse[playerName]
    local targetData    = playerData and playerData[targetName]
    local actionData    = targetData and targetData[actionName]
    local trackableData = actionData and actionData[trackable]

    if not trackableData then
        return false
    end

    trackableData[metric] = trackableData[metric] + newValue

	return true
end

------------------------------------------------------------------------------------------------------
-- Helper for checking maximums.
------------------------------------------------------------------------------------------------------
---@param damage     integer
---@param audits     table
---@param playerName string
---@param targetName string
---@param actionName string
---@param trackable  DB.Trackable
---@param maxMetric  DB.Metric
------------------------------------------------------------------------------------------------------
local checkMax = function(damage, audits, playerName, targetName, actionName, trackable, maxMetric)
    local maxHealing   = DB.HealingMax

    -- Mob specific maximum.
    if damage > DB.Catalog.Get(playerName, trackable, actionName, maxMetric, targetName) then
        -- Add a check for abnormally high healing magic to prevent Divine Seal from messing up overcure.
        if trackable == trackables.SPELLS_HEALING and maxHealing[actionName] then
            if damage > maxHealing[actionName] then
                damage = maxHealing[actionName]
            end
        end

        -- Maximum damage.
        DB.Catalog.UpdateMetric(updateMode.SET, damage, audits, trackable, actionName, maxMetric)
    end
end

------------------------------------------------------------------------------------------------------
-- Helper function for binding globals to locals to increase performance.
------------------------------------------------------------------------------------------------------
DB.Catalog.BindGlobals = function()
    catalogParse  = catalogParse or DB.ParseCatalog
    trackables    = trackables or DB.Trackable
    metrics       = metrics or DB.Metric
    trackingLists = trackingLists or DB.Tracking
    updateMode    = updateMode or DB.UpdateMode
    lists         = lists or DB.Lists
    cache         = cache or DB.CatalogCache
    dbData        = dbData or DB.Data
end

------------------------------------------------------------------------------------------------------
-- Initializes a cataloged action.
-- The base tables are initialized in the Init.Data and Init.Pet_Data functions.
-- If the action has already been initialized then this will quit out early.
-- Also initializes Trackable_Data which is used in the Focus Window.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param targetName string
---@param actionName string              the name of the action to be cataloged.
---@param trackable  DB.Trackable|string a tracked item from the trackable list.
---@param petName?   string
------------------------------------------------------------------------------------------------------
DB.Catalog.Initialize = function(playerName, targetName, actionName, trackable, petName)
	local caller = 'DB.Catalog.Initialize'

	if DB.IsValueEmpty(caller, playerName, 'Player') or
	   DB.IsValueEmpty(caller, targetName, 'Target') or
	   DB.IsValueEmpty(caller, actionName, 'Action') or
	   DB.IsValueEmpty(caller, trackable,  'Trackable')
    then
		return false
	end

	-- Initializations
	dbData.Initialize(playerName, targetName)

	if petName then
		DB.PetData.Initialize(playerName, petName, targetName)
	end

    local allMobs            = DB.Enum.ALL_MOBS
    local initializationList = { }
    local playerData         = catalogParse[playerName] or { }

    catalogParse[playerName] = playerData

    -- Helper for traversing the table.
    local function initTable(target)
        local targetData = playerData[target] or { }

        playerData[target] = targetData

        local actionData = targetData[actionName] or { }

        targetData[actionName] = actionData

        if not actionData[trackable] then
            actionData[trackable] = { }
            initializationList[#initializationList + 1] = target
        end
    end

    initTable(targetName)
    initTable(allMobs)

	-- Make sure the pet catalog is also initialized if necessary.
	if petName then
		DB.PetCatalog.Initialize(playerName, petName, targetName, actionName, trackable)
	end

	-- Initialize data nodes.
	-- Need to set minimum high manually to capture accurate minimums.
	if #initializationList == 0 then
		return false
	end

    for _, initializationTarget in ipairs(initializationList) do
        for _, metric in pairs(metrics) do
            local value = DB.MetricNeedsMaxValue(metric) and DB.Enum.MAX_DAMAGE or 0

            set(value, playerName, initializationTarget, actionName, trackable, metric)
        end
    end

	-- Initialize tracking tables.
    trackingLists.Trackables[trackable] = trackingLists.Trackables[trackable] or { }
    trackingLists.Trackables[trackable][playerName] = trackingLists.Trackables[trackable][playerName] or { }

    return true
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
	local caller = 'DB.Catalog.UpdateDamage'

	if DB.IsValueEmpty(caller, playerName, 'Player') or
	   DB.IsValueEmpty(caller, targetName, 'Target')
    then
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

    local updateMetric = DB.Catalog.UpdateMetric
    local get          = DB.Catalog.Get

	-- Update the non-catalog database with the damage
	dbData.UpdateDamage(audits, trackable, damage, isCriticalHit)
	-- Everything after this is for the catalog.

	-- Total Damage
    updateMetric(updateMode.INC, damage, audits, trackable, actionName, metrics.TOTAL)

	if isCriticalHit then
		updateMetric(updateMode.INC, damage, audits, trackable, actionName, metrics.CRITICAL_DAMAGE)
	end

	-- Attempts on the target.
	if isCriticalHit then
		updateMetric(updateMode.INC, 1, audits, trackable, actionName, metrics.CRITICAL_COUNT)
	end

	-- Set trackable hits and minimums
	local minMetric = (isCriticalHit and metrics.CRITICAL_MIN) or metrics.MIN
	local maxMetric = (isCriticalHit and metrics.CRITICAL_MAX) or metrics.MAX

    if damage > 0 then
		-- Minimum damage.
		if damage < get(playerName, trackable, actionName, minMetric, audits.target_name) then
			updateMetric(updateMode.SET, damage, audits, trackable, actionName, minMetric)
		end
    end

    -- Need to check for per-mob maximum and global all mobs maximum.
    checkMax(damage, audits, playerName, targetName, actionName, trackable, maxMetric)
    checkMax(damage, audits, playerName, DB.Enum.ALL_MOBS, actionName, trackable, maxMetric)

    lists.ResortPlayerCatalogDamage(playerName, trackable)

    if petName then
        lists.ResortPetCatalogDamage(playerName, petName)
    end

    return true
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
	local caller     = 'DB.Catalog.UpdateMetric'

	if DB.IsValueEmpty(caller, playerName, 'Player') or
	   DB.IsValueEmpty(caller, targetName, 'Target') or
	   DB.IsValueEmpty(caller, actionName, 'Action') or
	   DB.IsValueEmpty(caller, trackable,  'Trackable') or
	   DB.IsValueEmpty(caller, metric,     'Metric') or
	   playerName == DB.Enum.DEBUG
    then
		return false
	end

	-- Initialization
	DB.Catalog.Initialize(playerName, targetName, actionName, trackable, petName)

	-- Set the data; loop once for mob-specific data and a second time for all mob data.
	local updateList = { targetName, DB.Enum.ALL_MOBS }

	for _, updateTarget in ipairs(updateList) do
		if mode == updateMode.INC then
			inc(value, playerName, updateTarget, actionName, trackable, metric)

			if petName then
				DB.PetCatalog.Inc(value, playerName, petName, updateTarget, actionName, trackable, metric)
			end

		elseif mode == updateMode.SET then
			set(value, playerName, updateTarget, actionName, trackable, metric)

			if petName then
				DB.PetCatalog.Set(value, playerName, petName, updateTarget, actionName, trackable, metric)
			end
		end
	end

	-- This is used for the focus window
	trackingLists.Trackables[trackable][playerName][actionName] = true

	if petName then
		if not DB.PetCatalog.InitializeTracking(trackable, playerName, petName) then
			return false
		end

		trackingLists.PetTrackables[trackable][playerName][petName][actionName] = true
	end

	return true
end

------------------------------------------------------------------------------------------------------
-- Updates cataloged accuracy.
------------------------------------------------------------------------------------------------------
---@param audits     table
---@param trackable  DB.Trackable a tracked item from the trackable list.
---@param actionName string
---@param isHit      boolean
------------------------------------------------------------------------------------------------------
DB.Catalog.UpdateAccuracy = function(audits, trackable, actionName, isHit)
    local updateMetric = DB.Catalog.UpdateMetric

    updateMetric(updateMode.INC, 1, audits, trackable, actionName, metrics.ATTEMPTS_ON_TARGET)

    if isHit then
        updateMetric(updateMode.INC, 1, audits, trackable, actionName, metrics.HITS_ON_TARGET)
    end

    -- Update non-cataloged accuracy.
    dbData.UpdateAccuracy(audits, trackable, isHit)
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
    if Throttle.IsEnabled() and not Throttle.AllowCalculation() and not tempMobFocus then
        local playerCache = cache[playerName]

        if playerCache then
            local actionCache = playerCache[actionName]

            if actionCache then
                local trackableCache = actionCache[trackable]

                if trackableCache then
                    local cacheValue = trackableCache[metric]

                    if cacheValue ~= nil then
                        return cacheValue
                    end
                end
            end
        end
    end

    local caller = 'DB.Catalog.Get'

	if DB.IsValueEmpty(caller, playerName, 'Player') or
	   DB.IsValueEmpty(caller, actionName, 'Action') or
	   DB.IsValueEmpty(caller, trackable,  'Trackable') or
	   DB.IsValueEmpty(caller, metric,     'Metric') then
		return 0
	end

	local value       = DB.MetricNeedsMaxValue(metric) and DB.Enum.MAX_DAMAGE or 0
	local targetIndex = tempMobFocus or DB.Widgets.GetMobFocus()

	-- Get the data.
    local catalogPlayer = catalogParse[playerName]

    if catalogPlayer then
        local catalogTarget = catalogPlayer[targetIndex]

        if catalogTarget then
            local catalogAction = catalogTarget[actionName]

            if catalogAction then
                local catalogTrackable = catalogAction[trackable]

                if catalogTrackable then
                    local catalogData = catalogTrackable[metric]

                    if catalogData ~= nil then
                        value = catalogData
                    end
                end
            end
        end
    end

	-- Cache for performance.
    local playerCache = cache[playerName]

    if not playerCache then
        playerCache = { }
        cache[playerName] = playerCache
    end

    local actionCache = playerCache[actionName]

    if not actionCache then
        actionCache = { }
        playerCache[actionName] = actionCache
    end

    local trackableCache = actionCache[trackable]

    if not trackableCache then
        trackableCache = { }
        actionCache[trackable] = trackableCache
    end

    trackableCache[metric] = value

	return value
end
