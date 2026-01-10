DB.Lists = { }

DB.Lists.Players   = { }
DB.Lists.PetDamage = { }
DB.Lists.Mobs      = { }

DB.Lists.SortedDataDamageCache       = { }
DB.Lists.SortedCatalogDamageCache    = { }
DB.Lists.SortedPetDamageCache        = { }
DB.Lists.SortedPetCatalogDamageCache = { }

------------------------------------------------------------------------------------------------------
-- Sorts intiialized players so they show up in a reasonable order in the player selection drop down.
------------------------------------------------------------------------------------------------------
DB.Lists.SortInitializedPlayers = function()
	DB.Lists.Players = { DB.Enum.NONE }

	for playerName, _ in pairs(DB.Tracking.InitializedPlayers) do
		table.insert(DB.Lists.Players, playerName)
	end

	table.sort(DB.Lists.Players)
end

------------------------------------------------------------------------------------------------------
-- Checks to see if a mob has been initialized for the Mob Filter list.
------------------------------------------------------------------------------------------------------
---@param mobName string
------------------------------------------------------------------------------------------------------
DB.Lists.AddToInitializedMobs = function(mobName)
	if not mobName or mobName == DB.Enum.DEBUG or DB.Tracking.InitializedMobs[mobName] then
		return nil
	end

	DB.Tracking.InitializedMobs[mobName] = true

	table.insert(DB.Lists.Mobs, mobName)
	table.sort(DB.Lists.Mobs)
end

------------------------------------------------------------------------------------------------------
-- Recalculate player damage sorting for the trackable.
------------------------------------------------------------------------------------------------------
---@param trackable? DB.Trackable
---@return table
------------------------------------------------------------------------------------------------------
DB.Lists.ResortDataDamage = function(trackable)
    trackable = trackable or (Parse.Config.IncludeSkillchainDamage() and DB.Trackable.TOTAL_DAMAGE or DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN)

    local sortedDamage = { }

	-- Loop through players to get their total damage. Force through the cache by using a mob focus.
	for playerName, _ in pairs(DB.Tracking.InitializedPlayers) do
		local damage = DB.Data.Get(playerName, trackable, DB.Metric.TOTAL, DB.Widgets.GetMobFocus()) or 0
		sortedDamage[#sortedDamage + 1] = { playerName, damage }
	end

	-- Sort the total damage.
	table.sort(sortedDamage, function (a, b)
		return a[2] > b[2]
	end)

    -- Cache the sorted damage.
    DB.Lists.SortedDataDamageCache[trackable] = sortedDamage

    return DB.Lists.SortedDataDamageCache[trackable]
end

------------------------------------------------------------------------------------------------------
-- Get the sorted list of players for the trackable.
------------------------------------------------------------------------------------------------------
---@param trackable? DB.Trackable
---@return table
------------------------------------------------------------------------------------------------------
DB.Lists.GetSortedDataDamage = function(trackable)
	trackable = trackable or (Parse.Config.IncludeSkillchainDamage() and DB.Trackable.TOTAL_DAMAGE or DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN)

    return DB.Lists.SortedDataDamageCache[trackable] or DB.Lists.ResortDataDamage(trackable)
end

------------------------------------------------------------------------------------------------------
-- Recalculate player catalog damage sorting for the trackable.
------------------------------------------------------------------------------------------------------
---@param playerName string       name of the player that did the cataloged action
---@param trackable? DB.Trackable
---@return table
------------------------------------------------------------------------------------------------------
DB.Lists.ResortPlayerCatalogDamage = function(playerName, trackable)
	if not playerName or not trackable then
		local errorMessage = string.format("Nil required parameter: Player {%s} Trackable {%s}.", tostring(playerName), tostring(trackable))
		Debug.Error.Add(Debug.Error.ERROR, "DB.Lists.ResortPlayerCatalogDamage", errorMessage)
		return { }
	end

	if not DB.Tracking.Trackables[trackable] or not DB.Tracking.Trackables[trackable][playerName] then
		local errorMessage = string.format("Tracking uninitialized: Player {%s} does not have data for trackable {%s}.", tostring(playerName), tostring(trackable))
		Debug.Error.Add(Debug.Error.ERROR, "DB.Lists.ResortPlayerCatalogDamage", errorMessage)
		return { }
	end

	local sortedDamage = { }

	for actionName, _ in pairs(DB.Tracking.Trackables[trackable][playerName]) do
		sortedDamage[#sortedDamage + 1] = { actionName, DB.Catalog.Get(playerName, trackable, actionName, DB.Metric.TOTAL, DB.Widgets.GetMobFocus()) or 0 }
	end

	table.sort(sortedDamage, function (a, b)
		return (a[2] > b[2])
	end)

    -- Cache the sorted damage.
    DB.Lists.SortedCatalogDamageCache[trackable] = DB.Lists.SortedCatalogDamageCache[trackable] or { }
    DB.Lists.SortedCatalogDamageCache[trackable][playerName] = sortedDamage

	return DB.Lists.SortedCatalogDamageCache[trackable][playerName]
end

------------------------------------------------------------------------------------------------------
-- Sorting function for the sorted cataloged damage table.
------------------------------------------------------------------------------------------------------
---@param playerName string       name of the player that did the cataloged action
---@param trackable  DB.Trackable the trackable that is of interest.
---@return table
------------------------------------------------------------------------------------------------------
DB.Lists.GetSortedPlayerCatalogDamage = function(playerName, trackable)
	if not playerName or not trackable then
		local errorMessage = string.format("Nil required parameter: Player {%s} Trackable {%s}.", tostring(playerName), tostring(trackable))
		Debug.Error.Add(Debug.Error.ERROR, "DB.Lists.GetSortedPlayerCatalogDamage", errorMessage)
		return { }
	end

	if not DB.Tracking.Trackables[trackable] or not DB.Tracking.Trackables[trackable][playerName] then
		local errorMessage = string.format("Tracking uninitialized: Player {%s} does not have data for trackable {%s}.", tostring(playerName), tostring(trackable))
		Debug.Error.Add(Debug.Error.ERROR, "DB.Lists.GetSortedPlayerCatalogDamage", errorMessage)
		return { }
	end

    DB.Lists.SortedCatalogDamageCache[trackable] = DB.Lists.SortedCatalogDamageCache[trackable] or { }

    return DB.Lists.SortedCatalogDamageCache[trackable][playerName] or DB.Lists.ResortPlayerCatalogDamage(playerName, trackable)
end

------------------------------------------------------------------------------------------------------
-- Recalculate player pet damage sorting for the trackable.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@return table
------------------------------------------------------------------------------------------------------
DB.Lists.ResortPetDamage = function(playerName)
	if not playerName then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Lists.ResortPetDamage", "playerName is nil.")
		return { }
	end

	if not DB or not DB.Tracking or not DB.Tracking.InitializedPets or not DB.Tracking.InitializedPets[playerName] then
		local errorMessage = string.format("Initialized pets is nil for player {%s}.", tostring(playerName))
		Debug.Error.Add(Debug.Error.ERROR, "DB.Lists.ResortPetDamage", errorMessage)
		return { }
	end

	local sortedDamage = { }

	for petName, _ in pairs(DB.Tracking.InitializedPets[playerName]) do
		local trackable = Parse.Config.IncludeSkillchainDamage() and DB.Trackable.TOTAL_DAMAGE or DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN
		sortedDamage[#sortedDamage + 1] = { petName, DB.PetData.Get(playerName, petName, trackable, DB.Metric.TOTAL, DB.Widgets.GetMobFocus()) or 0 }
	end

	table.sort(sortedDamage, function (a, b)
		return (a[2] > b[2])
	end)

    -- Cache the sorted damage.
    DB.Lists.SortedPetDamageCache[playerName] = sortedDamage

	return DB.Lists.SortedPetDamageCache[playerName]
end

------------------------------------------------------------------------------------------------------
-- Builds the sorted pet total damage table.
-- This table contains the total amount of damage that each recognized player's pet has done.
-- Capable of filtering out skillchain damage.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@return table
------------------------------------------------------------------------------------------------------
DB.Lists.GetSortedPetDamage = function(playerName)
	if not playerName then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Lists.GetSortedPetDamage", "playerName is nil.")
		return { }
	end

	if not DB or not DB.Tracking or not DB.Tracking.InitializedPets or not DB.Tracking.InitializedPets[playerName] then
		local errorMessage = string.format("Initialized pets is nil for player {%s}.", tostring(playerName))
		Debug.Error.Add(Debug.Error.ERROR, "DB.Lists.GetSortedPetDamage", errorMessage)
		return { }
	end

	return DB.Lists.SortedPetDamageCache[playerName] or DB.Lists.ResortPetDamage(playerName)
end

------------------------------------------------------------------------------------------------------
-- Resort pet catalog damage.
------------------------------------------------------------------------------------------------------
---@param playerName string name of the player that did the cataloged action
---@param petName    string
---@return table
------------------------------------------------------------------------------------------------------
DB.Lists.ResortPetCatalogDamage = function(playerName, petName)
	if not playerName or not petName then
        return { }
    end

    local sortedDamage = { }

	for _, trackable in pairs(DB.PetSingleTrackables) do
		if DB.Tracking.PetTrackables[trackable] and
		   DB.Tracking.PetTrackables[trackable][playerName] and
		   DB.Tracking.PetTrackables[trackable][playerName][petName]
        then
			for actionName, _ in pairs(DB.Tracking.PetTrackables[trackable][playerName][petName]) do
                local damage = DB.PetCatalog.Get(playerName, petName, trackable, actionName, DB.Metric.TOTAL, DB.Widgets.GetMobFocus()) or 0
				sortedDamage[#sortedDamage + 1] = { actionName, damage, trackable }
			end
		end
	end

	table.sort(sortedDamage, function (a, b)
		return (a[2] > b[2])
	end)

    -- Cache the sorted damage.
    DB.Lists.SortedPetCatalogDamageCache[playerName] = DB.Lists.SortedPetCatalogDamageCache[playerName] or { }
    DB.Lists.SortedPetCatalogDamageCache[playerName][petName] = sortedDamage

	return DB.Lists.SortedPetCatalogDamageCache[playerName][petName]
end

------------------------------------------------------------------------------------------------------
-- Sorting function for the sorted cataloged damage table.
------------------------------------------------------------------------------------------------------
---@param playerName string name of the player that did the cataloged action
---@param petName    string
---@return table
------------------------------------------------------------------------------------------------------
DB.Lists.GetSortedPetCatalogDamage = function(playerName, petName)
	if not playerName or not petName then
        return { }
    end

    DB.Lists.SortedPetCatalogDamageCache[playerName] = DB.Lists.SortedPetCatalogDamageCache[playerName] or { }

    return DB.Lists.SortedPetCatalogDamageCache[playerName][petName] or DB.Lists.ResortPetCatalogDamage(playerName, petName)
end

------------------------------------------------------------------------------------------------------
-- Checks if the player has any cataloged data for the specified focus type.
-- Can use this to check if there is anything to publish via report before attempting to do so.
------------------------------------------------------------------------------------------------------
---@param playerName string       name of the player that did the cataloged action
---@param trackable  DB.Trackable the trackable that is of interest.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Lists.CatalogExists = function(playerName, trackable)
	return DB.Tracking.Trackables[trackable] and DB.Tracking.Trackables[trackable][playerName] or false
end