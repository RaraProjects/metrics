DB.Data = { }

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
	local caller = "DB.Data.Initialize"
	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, targetName, "Target") then
		return false
	end

	-- Don't want to overwrite data node if it already exists. This is for mob specfic data.
	local initializationList = { }
	if not DB.Parse[playerName] then DB.Parse[playerName] = { } end
	if not DB.Parse[playerName][targetName] then
		DB.Parse[playerName][targetName] = { }
		table.insert(initializationList, targetName)
	end

	-- Don't want to overwrite data node if it already exists. This is for all mob data.
	local allMobs = DB.Enum.ALL_MOBS
	if not DB.Parse[playerName][allMobs] then
		DB.Parse[playerName][allMobs] = {}
		table.insert(initializationList, allMobs)
	end

	-- Initialize data nodes.
	-- Need to set minimum high manually to capture accurate minimums.
	if #initializationList == 0 then
		return false
	end

	for _, initializationTarget in ipairs(initializationList) do
		for _, trackable in pairs(DB.Trackable) do
			DB.Parse[playerName][initializationTarget][trackable] = { }

			for _, metric in pairs(DB.Metric) do
				if DB.MetricNeedsMaxValue(metric) then
					DB.Data.Set(DB.Enum.MAX_DAMAGE, playerName, initializationTarget, trackable, metric)
				else
					DB.Data.Set(0, playerName, initializationTarget, trackable, metric)
				end
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
	if playerName and playerName ~= "" and not DB.Tracking.InitializedPlayers[playerName] then
		DB.Tracking.InitializedPlayers[playerName] = true
		DB.Lists.SortInitializedPlayers()
		DB.Tracking.RunningAccuracy[playerName]    = { }
		DB.Tracking.RunningDamage[playerName]      = 0
		DB.Tracking.RunningAttackSpeed[playerName] = { }
		DB.Tracking.MultiAttack[playerName]        = { }
	end
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
	local caller = "DB.Data.Update"

	if not audits then
		Debug.Error.Add(Debug.Error.ERROR, caller, "Nil audits passed in.")
		return nil
	end

	local playerName = audits.player_name
	local targetName = audits.target_name
	local petName    = audits.pet_name

	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, targetName, "Target") then
		return nil
	end

	DB.Data.Initialize(playerName, targetName)
	if petName then
		DB.PetData.Initialize(playerName, petName, targetName)
	end

	-- Set the data; loop once for mob-specific data and a second time for all mob data.
	local updateList = { targetName, DB.Enum.ALL_MOBS }

	for _, updateTarget in ipairs(updateList) do
		if mode == DB.UpdateMode.INC then
			DB.Data.Inc(value, playerName, updateTarget, trackable, metric)
			if petName then
				DB.PetData.Inc(value, playerName, petName, updateTarget, trackable, metric)
			end
		elseif mode == DB.UpdateMode.SET then
			DB.Data.Set(value, playerName, updateTarget, trackable, metric)
			if petName then
				DB.PetData.Set(value, playerName, petName, updateTarget, trackable, metric)
			end
		end
	end

	-- Increment the running damage count for DPS if this is a total damage increase.
	if mode == DB.UpdateMode.INC and
	   trackable == DB.Trackable.TOTAL_DAMAGE and
	   metric == DB.Metric.TOTAL then
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
	-- Increment grand totals if necessary. There is an all damage track and a no-skillchain track.
    if DB.IsTotalDamageTrackable(trackable) then
    	DB.Data.Update(DB.UpdateMode.INC, damage, audits, DB.Trackable.TOTAL_DAMAGE, DB.Metric.TOTAL)
		DB.TotalDamage = DB.TotalDamage + damage

		if trackable ~= DB.Trackable.SKILLCHAIN then
			DB.Data.Update(DB.UpdateMode.INC, damage, audits, DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN, DB.Metric.TOTAL)
			DB.TotalDamageNoSkillchain = DB.TotalDamageNoSkillchain + damage
		end
    end

	DB.Data.UpdateDamageBasic(audits, trackable, damage, isCriticalHit)
end

------------------------------------------------------------------------------------------------------
-- Sets the minimum and maximum values.
------------------------------------------------------------------------------------------------------
---@param audits         table
---@param trackable      DB.Trackable a tracked item from the trackable list.
---@param damage         number damage value to be logged.
---@param isCriticalHit? boolean
------------------------------------------------------------------------------------------------------
DB.Data.UpdateDamageBasic = function(audits, trackable, damage, isCriticalHit)
	-- Increment the trackable specific totals.
    DB.Data.Update(DB.UpdateMode.INC, damage, audits, trackable, DB.Metric.TOTAL)

	if isCriticalHit then
		DB.Data.Update(DB.UpdateMode.INC,      1, audits, trackable, DB.Metric.CRITICAL_COUNT)
    	DB.Data.Update(DB.UpdateMode.INC, damage, audits, trackable, DB.Metric.CRITICAL_DAMAGE)
	end

	-- Log an attempt on the target.
	DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS_ON_TARGET)

	-- Set trackable hits and minimums
	local minMetric = (isCriticalHit and DB.Metric.CRITICAL_MIN) or DB.Metric.MIN
	local maxMetric = (isCriticalHit and DB.Metric.CRITICAL_MAX) or DB.Metric.MAX

	-- We can't log a miss (0 damage) to MIN because then the miminum will always be zero.
	-- We log a hit on the target here too since we have a damage check.
	if damage > 0 then
		DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.HITS_ON_TARGET)

		if audits.pet_name then
			if damage < DB.PetData.Get(audits.player_name, audits.pet_name, trackable, minMetric, audits.target_name) then
				DB.Data.Update(DB.UpdateMode.SET, damage, audits, trackable, minMetric)
			end
		else
			if damage < DB.Data.Get(audits.player_name, trackable, minMetric, audits.target_name) then
				DB.Data.Update(DB.UpdateMode.SET, damage, audits, trackable, minMetric)
			end
		end
	end

	-- Set trackable maximums
	if damage > DB.Data.Get(audits.player_name, trackable, maxMetric, audits.target_name) then
		DB.Data.Update(DB.UpdateMode.SET, damage, audits, trackable, maxMetric)
	end
end

------------------------------------------------------------------------------------------------------
-- Directly sets a trackable's metric to a specified value.
-- This is primarily used for initialization and minimum/maximum metrics.
------------------------------------------------------------------------------------------------------
---@param value      number       the value to set the node to.
---@param playerName string
---@param targetName string
---@param trackable  DB.Trackable a tracked item from the trackable list.
---@param metric     DB.Metric    a trackable's metric from the metric
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Data.Set = function(value, playerName, targetName, trackable, metric)
	-- Early quit out to prevent crashing.
	-- Can't quit out early for blank metric nodes because this is used for initialization.
	local caller = "DB.Data.Set"
	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, targetName, "Target") or
	   DB.IsValueEmpty(caller, trackable,  "Trackable") or
	   DB.IsValueEmpty(caller, metric,     "Metric") or
	   DB.IsValueEmpty(caller, value,      "Value") or
	   not DB.Data.IsIndexNodeInitialized(caller, true, playerName, targetName) then
		return false
	end

	-- Don't set an unfiltered minimum if the mob specific minimum isn't less than the unfiltered one.
	if DB.MetricNeedsMaxValue(metric) and
	targetName == DB.Enum.ALL_MOBS and
	DB.Parse[playerName][targetName][trackable][metric] and
	value >= DB.Parse[playerName][targetName][trackable][metric] then
		return false
	end

	-- Apply the change.
	DB.Parse[playerName][targetName][trackable][metric] = value

	return true
end

------------------------------------------------------------------------------------------------------
-- Increments a trackable's metric by a specified amount.
------------------------------------------------------------------------------------------------------
---@param value      number       the value to increment the node by.
---@param playerName string
---@param targetName string
---@param trackable  DB.Trackable a tracked item from the trackable list.
---@param metric     DB.Metric    a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Data.Inc = function(value, playerName, targetName, trackable, metric)
	-- Early quit out to prevent crashing.
	local caller = "DB.Data.Inc"
	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, targetName, "Target") or
	   DB.IsValueEmpty(caller, trackable,  "Trackable") or
	   DB.IsValueEmpty(caller, metric,     "Metric") or
	   DB.IsValueEmpty(caller, value,      "Value") or
	   not DB.Data.IsIndexNodeInitialized(caller, true, playerName, targetName) or
	   not DB.Data.Is_Metric_Node_Initialized(caller, true, playerName, targetName, trackable, metric) then
		return false
	end

	-- Apply the change.
	DB.Parse[playerName][targetName][trackable][metric] = DB.Parse[playerName][targetName][trackable][metric] + value

	return true
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
	local caller = "DB.Data.Get"
	if DB.IsValueEmpty(caller, playerName, "Player") or
	   DB.IsValueEmpty(caller, trackable,  "Trackable") or
	   DB.IsValueEmpty(caller, metric,     "Metric") then
		return 0
	end

	-- Dont get new data unless we are in a new throttle cycle or cached data doesn't exist.
	if (Throttle.IsEnabled() and not Throttle.AllowCalculation()) and not tempMobFocus then
		if DB.Cache[playerName] and
		   DB.Cache[playerName][trackable] and
		   DB.Cache[playerName][trackable][metric] then
			return DB.Cache[playerName][trackable][metric]
		end
	end

	-- The target index will just be the mob focus unless a temporary focus is passed in.
	-- The mob focus will handle the ALL_MOBS too.
	local value       = DB.MetricNeedsMaxValue(metric) and DB.Enum.MAX_DAMAGE or 0
	local targetIndex = tempMobFocus or DB.Widgets.GetMobFocus()

	-- Get the data.
	if DB.Data.IsIndexNodeInitialized(caller, false, playerName, targetIndex) then
		if DB.Data.Is_Metric_Node_Initialized(caller, false, playerName, targetIndex, trackable, metric) then
			value = DB.Parse[playerName][targetIndex][trackable][metric]
		end
	end

	-- Cache for performance.
	if not DB.Cache[playerName] then DB.Cache[playerName] = { } end
	if not DB.Cache[playerName][trackable] then DB.Cache[playerName][trackable] = { } end
	DB.Cache[playerName][trackable][metric] = value

	return value
end

------------------------------------------------------------------------------------------------------
-- Checks if the [player_name][target_name] nodes are initialized in the primary database.
------------------------------------------------------------------------------------------------------
---@param caller     string
---@param writeError boolean
---@param playerName string
---@param targetName string
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Data.IsIndexNodeInitialized = function(caller, writeError, playerName, targetName)
	if not DB.Parse or
	   not DB.Parse[playerName] or
	   not DB.Parse[playerName][targetName] then
		if writeError then
			local errorMessage = string.format("Not initialized in DB.Parse[%s][%s].", tostring(playerName), tostring(targetName))
			Debug.Error.Add(Debug.Error.ERROR, caller, errorMessage)
		end

		return false
	end

	return true
end

------------------------------------------------------------------------------------------------------
-- Checks if the [player_name][target_name][trackable][metric] nodes are initialized in the primary database.
------------------------------------------------------------------------------------------------------
---@param caller     string
---@param writeError boolean
---@param playerName string
---@param targetName string
---@param trackable  DB.Trackable
---@param metric     DB.Metric
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Data.Is_Metric_Node_Initialized = function(caller, writeError, playerName, targetName, trackable, metric)
	if not DB.Parse or
	   not DB.Parse[playerName] or
	   not DB.Parse[playerName][targetName] then
		if writeError then
			local errorMessage = string.format("Metric not initialized in DB.Parse[%s][%s][%s][%s].",
			                     tostring(playerName), tostring(targetName), tostring(trackable), tostring(metric))
			Debug.Error.Add(Debug.Error.ERROR, caller, errorMessage)
		end

		return false
	end

	return true
end