-- Performance review: 01/16/26

DB.Data = { }

-- Local holders for common global tables--performance+.
---@type table
local dbParse       = nil
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
local petData       = nil

------------------------------------------------------------------------------------------------------
-- Directly sets a trackable's metric to a specified value.
-- This is primarily used for initialization and minimum/maximum metrics.
-- CALLER SHOULD ENSURE ARGUMENTS EXIST!!!
------------------------------------------------------------------------------------------------------
---@param newValue   number       the value to set the node to.
---@param playerName string
---@param targetName string
---@param trackable  DB.Trackable a tracked item from the trackable list.
---@param metric     DB.Metric    a trackable's metric from the metric
---@return boolean
------------------------------------------------------------------------------------------------------
local set = function(newValue, playerName, targetName, trackable, metric)
    local playerData    = dbParse[playerName]
    local targetData    = playerData and playerData[targetName]
    local trackableData = targetData and targetData[trackable]

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

	trackableData[metric] = newValue

	return true
end

------------------------------------------------------------------------------------------------------
-- Increments a trackable's metric by a specified amount.
-- CALLER SHOULD ENSURE ARGUMENTS EXIST!!!
------------------------------------------------------------------------------------------------------
---@param value      number       the value to increment the node by.
---@param playerName string
---@param targetName string
---@param trackable  DB.Trackable a tracked item from the trackable list.
---@param metric     DB.Metric    a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
local inc = function(value, playerName, targetName, trackable, metric)
    local playerData    = dbParse[playerName]
    local targetData    = playerData and playerData[targetName]
    local trackableData = targetData and targetData[trackable]

    if not trackableData then
        return false
    end

	trackableData[metric] = trackableData[metric] + value

	return true
end

------------------------------------------------------------------------------------------------------
-- Helper function for binding globals to locals to increase performance.
------------------------------------------------------------------------------------------------------
DB.Data.BindGlobals = function()
    dbParse       = dbParse or DB.Parse
    trackables    = trackables or DB.Trackable
    metrics       = metrics or DB.Metric
    trackingLists = trackingLists or DB.Tracking
    updateMode    = updateMode or DB.UpdateMode
    lists         = lists or DB.Lists
    cache         = cache or DB.Cache
    petData       = petData or DB.PetData
end

------------------------------------------------------------------------------------------------------
-- Initializes the primary player data nodes and other tracking globals.
-- The core nodes for initialization are [player_name][target_name].
------------------------------------------------------------------------------------------------------
---@param playerName string In the case of pets this will be the owner. This will never be a mob name.
---@param targetName string The entity receiving the action of the player.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Data.Initialize = function(playerName, targetName)
    -- Early quit out to prevent crashing.
	local caller = 'DB.Data.Initialize'

	if DB.IsValueEmpty(caller, playerName, 'Player') or
	   DB.IsValueEmpty(caller, targetName, 'Target')
	then
		return false
	end

	-- Don't want to overwrite data node if it already exists. This is for mob specfic data.
	local allMobs            = DB.Enum.ALL_MOBS
    local initializationList = { }
    local playerData         = dbParse[playerName] or { }

    dbParse[playerName] = playerData

    -- Target Specific
    if not playerData[targetName] then
        playerData[targetName] = { }
        initializationList[#initializationList + 1] = targetName
    end

    -- All Mobs
	if not playerData[allMobs] then
		playerData[allMobs] = { }
        initializationList[#initializationList + 1] = allMobs
	end

	if #initializationList == 0 then
		return false
	end

    -- Initialize data nodes.
	-- Need to set minimum high manually to capture accurate minimums.
	for _, initializationTarget in ipairs(initializationList) do
        local targetData = playerData[initializationTarget]

		for _, trackable in pairs(trackables) do
			targetData[trackable] = { }

			for _, metric in pairs(metrics) do
				local value = DB.MetricNeedsMaxValue(metric) and DB.Enum.MAX_DAMAGE or 0

				set(value, playerName, initializationTarget, trackable, metric)
			end
		end
	end

	DB.Data.InitializePlayerTrackingTables(playerName)

	return true
end

------------------------------------------------------------------------------------------------------
-- Initializes various parallel tracking globals based on the player.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
DB.Data.InitializePlayerTrackingTables = function(playerName)
	if not playerName or playerName == '' or playerName == DB.Enum.DEBUG then
        return nil
    end

    local initialized = trackingLists.InitializedPlayers

    if initialized[playerName] then
        return nil
    end

    initialized[playerName] = true
    lists.SortInitializedPlayers()

    trackingLists.RunningAccuracy[playerName]    = { }
    trackingLists.RunningDamage[playerName]      = 0
    trackingLists.RunningAttackSpeed[playerName] = { }
    trackingLists.MultiAttack[playerName]        = { }
end

------------------------------------------------------------------------------------------------------
-- A handler function that makes sure the data is set appropriately.
-- This does not set data directly. Rather, it calls the Set~ or Inc~ functions.
------------------------------------------------------------------------------------------------------
---@param mode      string       flag calling out whether the data should be set or incremented.
---@param value     number       the value to set or increment the node to/by.
---@param audits    table        Contains necessary data; helps save on parameter slots.
---@param trackable DB.Trackable a tracked item from the trackable list.
---@param metric    DB.Metric    a trackable's metric from the metric list.
------------------------------------------------------------------------------------------------------
DB.Data.Update = function(mode, value, audits, trackable, metric)
	local caller = 'DB.Data.Update'

	if not audits then
		Debug.Error.Add(Debug.Error.ERROR, caller, 'Nil audits passed in.')
		return nil
	end

	local playerName = audits.player_name
	local targetName = audits.target_name
	local petName    = audits.pet_name

	if DB.IsValueEmpty(caller, playerName, 'Player') or
	   DB.IsValueEmpty(caller, targetName, 'Target')
	then
		return nil
	end

	DB.Data.Initialize(playerName, targetName)

	if petName then
		petData.Initialize(playerName, petName, targetName)
	end

    local isInc = mode == updateMode.INC
    local isSet = mode == updateMode.SET

	-- Set the data; loop once for mob-specific data and a second time for all mob data.
	local updateList = { targetName, DB.Enum.ALL_MOBS }

	for _, updateTarget in ipairs(updateList) do
		if isInc then
			inc(value, playerName, updateTarget, trackable, metric)

			if petName then
				petData.Inc(value, playerName, petName, updateTarget, trackable, metric)
			end

		elseif isSet then
			set(value, playerName, updateTarget, trackable, metric)

			if petName then
				petData.Set(value, playerName, petName, updateTarget, trackable, metric)
			end
		end
	end

	-- Increment the running damage count for DPS if this is a total damage increase.
	if isInc and
	   trackable == trackables.TOTAL_DAMAGE and
	   metric == metrics.TOTAL
	then
		DB.DPS.IncBuffer(playerName, value)
	end
end

------------------------------------------------------------------------------------------------------
-- Handles the primary database portion of damage updates.
------------------------------------------------------------------------------------------------------
---@param audits         table
---@param trackable      DB.Trackable a tracked item from the trackable list.
---@param damage         number       damage value to be logged.
---@param isCriticalHit? boolean      whether or not a critical hit or magic burst took place.
------------------------------------------------------------------------------------------------------
DB.Data.UpdateDamage = function(audits, trackable, damage, isCriticalHit)
    local update = DB.Data.Update

    -- Increment grand totals if necessary. There is an all damage track and a no-skillchain track.
    if DB.IsTotalDamageTrackable(trackable) then
        update(updateMode.INC, damage, audits, trackables.TOTAL_DAMAGE, metrics.TOTAL)
		DB.TotalDamage = DB.TotalDamage + damage
        lists.ResortDataDamage(trackables.TOTAL_DAMAGE)

		if trackable ~= trackables.SKILLCHAIN then
			update(updateMode.INC, damage, audits, trackables.TOTAL_DAMAGE_NO_SKILLCHAIN, metrics.TOTAL)
			DB.TotalDamageNoSkillchain = DB.TotalDamageNoSkillchain + damage
            lists.ResortDataDamage(trackables.TOTAL_DAMAGE_NO_SKILLCHAIN)
		end
    end

	DB.Data.UpdateDamageBasic(audits, trackable, damage, isCriticalHit)
end

------------------------------------------------------------------------------------------------------
-- Sets the minimum and maximum values. Assumes zero damage can be a hit.
------------------------------------------------------------------------------------------------------
---@param audits         table
---@param trackable      DB.Trackable a tracked item from the trackable list.
---@param damage         number       damage value to be logged.
---@param isCriticalHit? boolean
------------------------------------------------------------------------------------------------------
DB.Data.UpdateDamageBasic = function(audits, trackable, damage, isCriticalHit)
    local update = DB.Data.Update
    local get    = DB.Data.Get

    local playerName = audits.player_name
    local targetName = audits.target_name
    local petName    = audits.pet_name

	local minMetric = (isCriticalHit and metrics.CRITICAL_MIN) or metrics.MIN
	local maxMetric = (isCriticalHit and metrics.CRITICAL_MAX) or metrics.MAX

    update(updateMode.INC, damage, audits, trackable, metrics.TOTAL)

	if isCriticalHit then
		update(updateMode.INC,      1, audits, trackable, metrics.CRITICAL_COUNT)
    	update(updateMode.INC, damage, audits, trackable, metrics.CRITICAL_DAMAGE)
	end

	-- We can't log a miss (0 damage) to MIN because then the miminum will always be zero.
	if damage > 0 then
		if petName then
			if damage < petData.Get(playerName, petName, trackable, minMetric, targetName) then
				update(updateMode.SET, damage, audits, trackable, minMetric)
			end
		else
			if damage < get(playerName, trackable, minMetric, targetName) then
				update(updateMode.SET, damage, audits, trackable, minMetric)
			end
		end
	end

	-- Set trackable maximums
	if damage > get(playerName, trackable, maxMetric, targetName) then
		update(updateMode.SET, damage, audits, trackable, maxMetric)
	end

    -- Resort damage lists.
    lists.ResortDataDamage(trackable)

    if petName then
        lists.ResortPetDamage(playerName)
    end
end

------------------------------------------------------------------------------------------------------
-- Updates accuracy.
------------------------------------------------------------------------------------------------------
---@param audits    table
---@param trackable DB.Trackable a tracked item from the trackable list.
---@param isHit     boolean
------------------------------------------------------------------------------------------------------
DB.Data.UpdateAccuracy = function(audits, trackable, isHit)
    local update = DB.Data.Update

    update(updateMode.INC, 1, audits, trackable, metrics.ATTEMPTS_ON_TARGET)

    if isHit then
        update(updateMode.INC, 1, audits, trackable, metrics.HITS_ON_TARGET)
    end
end

------------------------------------------------------------------------------------------------------
-- Gets data from a trackable metric.
-- If the mob filter is set then only actions towards that mob are counted.
------------------------------------------------------------------------------------------------------
---@param playerName    string       the player or entity name to search data for.
---@param trackable     DB.Trackable a tracked item from the trackable list.
---@param metric        DB.Metric    a trackable's metric from the metric list.
---@param tempMobFocus? string       used to force look for a specific mob (mainly for setting minimums for AOEs).
---@return number
------------------------------------------------------------------------------------------------------
DB.Data.Get = function(playerName, trackable, metric, tempMobFocus)
    -- Check if we can used cached data first.
	if (Throttle.IsEnabled() and not Throttle.AllowCalculation()) and not tempMobFocus then
		local playerCache = cache[playerName]

        if playerCache then
            local trackableCache = playerCache[trackable]

            if trackableCache then
                local cacheValue = trackableCache[metric]

                if cacheValue ~= nil then
                    return cacheValue
                end
            end
        end
    end

    -- Cache doesn't exist or needs refreshed. Validate for database hit.
    local caller = 'DB.Data.Get'

	if DB.IsValueEmpty(caller, playerName, 'Player') or
	   DB.IsValueEmpty(caller, trackable,  'Trackable') or
	   DB.IsValueEmpty(caller, metric,     'Metric')
	then
		return 0
	end

	-- The target index will just be the mob focus unless a temporary focus is passed in.
	-- The mob focus will handle the ALL_MOBS too.
	local value       = DB.MetricNeedsMaxValue(metric) and DB.Enum.MAX_DAMAGE or 0
	local targetIndex = tempMobFocus or DB.Widgets.GetMobFocus()

	-- Get the data.
    local dbPlayer = dbParse[playerName]

    if dbPlayer then
        local dbTarget = dbPlayer[targetIndex]

        if dbTarget then
            local dbTrackable = dbTarget[trackable]

            if dbTrackable then
                local dbData = dbTrackable[metric]

                if dbData ~= nil then
                    value = dbData
                end
            end
        end
    end

	-- Update the cache.
    local playerCache = cache[playerName]

    if not playerCache then
        playerCache = { }
        cache[playerName] = playerCache
    end

    local trackableCache = playerCache[trackable]

    if not trackableCache then
        trackableCache = { }
        playerCache[trackable] = trackableCache
    end

    trackableCache[metric] = value

	return value
end
