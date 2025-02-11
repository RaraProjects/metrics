DB.Lists = {}

-- Sorted Lists
DB.Sorted = {}
DB.Sorted.Players = {}
DB.Sorted.Mobs = {}
DB.Sorted.Pet_Damage = {}
DB.Sorted.Pet_Catalog_Damage = {}

-- Function Containers
DB.Lists.Get = {}
DB.Lists.Sort = {}
DB.Lists.Populate = {}
DB.Lists.Check = {}

------------------------------------------------------------------------------------------------------
-- Retrieval function to get the list of mobs that have been acted upon.
------------------------------------------------------------------------------------------------------
DB.Lists.Get.Mob = function()
	return DB.Sorted.Mobs
end

------------------------------------------------------------------------------------------------------
-- Retrieval function to get the list of players that have data.
------------------------------------------------------------------------------------------------------
DB.Lists.Get.Players = function()
	return DB.Sorted.Players
end

------------------------------------------------------------------------------------------------------
-- Sorts intiialized players so they show up in a reasonable order in the player selection drop down.
------------------------------------------------------------------------------------------------------
DB.Lists.Sort.Players = function()
	local name_sort = {}
	table.insert(name_sort, DB.Widgets.Dropdown.Enum.NONE)
	for player_name, _ in pairs(DB.Tracking.InitializedPlayers) do
		table.insert(name_sort, player_name)
	end
	table.sort(name_sort)
	DB.Sorted.Players = name_sort
end

------------------------------------------------------------------------------------------------------
-- Sorting function for the sorting the total damage table.
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
DB.Lists.Sort.TotalDamage = function()
	local sorted_damage = {}
	local damage = nil

	-- Loop through players to get their total damage.
	for player_name, _ in pairs(DB.Tracking.InitializedPlayers) do
		if Parse.Config.IncludeSkillchainDamage() then
			damage = DB.Data.Get(player_name, DB.Trackable.TOTAL_DAMAGE, DB.Metric.TOTAL)
		else
			damage = DB.Data.Get(player_name, DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN, DB.Metric.TOTAL)
		end
		table.insert(sorted_damage, {player_name, damage})
	end

	-- Sort the total damage.
	table.sort(sorted_damage, function (a, b)
		local a_damage = a[2]
		local b_damage = b[2]
		return (a_damage > b_damage)
	end)

	return sorted_damage
end

------------------------------------------------------------------------------------------------------
-- Sorts damage by a specific type of damage.
------------------------------------------------------------------------------------------------------
---@param trackable string
---@return table
------------------------------------------------------------------------------------------------------
DB.Lists.Sort.Damage_By_Type = function(trackable)
	if not trackable then return {} end

	local sorted_damage = {}
	local damage = nil

	-- Loop through players to get their total trackable damage.
	for player_name, _ in pairs(DB.Tracking.InitializedPlayers) do
		damage = DB.Data.Get(player_name, trackable, DB.Metric.TOTAL)
		table.insert(sorted_damage, {player_name, damage})
	end

	-- Sort the total trackable damage.
	table.sort(sorted_damage, function (a, b)
		local a_damage = a[2]
		local b_damage = b[2]
		return (a_damage > b_damage)
	end)

	return sorted_damage
end

------------------------------------------------------------------------------------------------------
-- Sorting function for the sorted cataloged damage table.
------------------------------------------------------------------------------------------------------
---@param player_name string name of the player that did the cataloged action
---@param focus_type string the trackable that is of interest.
---@return table
------------------------------------------------------------------------------------------------------
DB.Lists.Sort.Catalog_Damage = function(player_name, focus_type)
	if not player_name or not focus_type then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Lists.Sort.Catalog_Damage", "Nil required parameter: Player {" .. tostring(player_name)
		.. "} Focus Type {" .. tostring(focus_type) .. "}.")
		return {}
	end
	if not DB.Tracking.Trackables[focus_type] or not DB.Tracking.Trackables[focus_type][player_name] then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Lists.Sort.Catalog_Damage", "Tracking uninitialized: Player {" .. tostring(player_name)
		.. "} does not have data for focus type {" .. tostring(focus_type) .. "}.")
		return {}
	end

	local sorted_damage = {}
	for action_name, _ in pairs(DB.Tracking.Trackables[focus_type][player_name]) do
		table.insert(sorted_damage, {action_name, DB.Catalog.Get(player_name, focus_type, action_name, DB.Metric.TOTAL)})
	end

	table.sort(sorted_damage, function (a, b)
		local a_damage = a[2]
		local b_damage = b[2]
		return (a_damage > b_damage)
	end)

	return sorted_damage
end

------------------------------------------------------------------------------------------------------
-- Sorting function for the sorted cataloged damage table.
------------------------------------------------------------------------------------------------------
---@param player_name string name of the player that did the cataloged action
---@param pet_name string
------------------------------------------------------------------------------------------------------
DB.Lists.Sort.Pet_Catalog_Damage = function(player_name, pet_name)
	DB.Lists.Populate.Pet_Catalog_Damage(player_name, pet_name)
	table.sort(DB.Sorted.Pet_Catalog_Damage, function (a, b)
		local a_damage = a[2]
		local b_damage = b[2]
		return (a_damage > b_damage)
	end)
end

------------------------------------------------------------------------------------------------------
-- Builds the sorted pet total damage table.
-- This table contains the total amount of damage that each recognized player's pet has done.
-- Capable of filtering out skillchain damage.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
DB.Lists.Populate.Pet_Damage = function(player_name)
	if not player_name then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Lists.Populate.Pet_Damage", "player_name is nil.")
		return nil
	end
	if not DB or not DB.Tracking or not DB.Tracking.InitializedPets or not DB.Tracking.InitializedPets[player_name] then
		Debug.Error.Add(Debug.Error.ERROR, "DB.Lists.Populate.Pet_Damage", "Initialized pets is nil for player {" .. tostring(player_name) .. "}.")
		return nil
	end

	DB.Sorted.Pet_Damage = {}
	local damage = 0
	for pet_name, _ in pairs(DB.Tracking.InitializedPets[player_name]) do
		if Parse.Config.IncludeSkillchainDamage() then
			damage = DB.Pet_Data.Get(player_name, pet_name, DB.Trackable.TOTAL_DAMAGE, DB.Metric.TOTAL)
		else
			damage = DB.Pet_Data.Get(player_name, pet_name, DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN, DB.Metric.TOTAL)
		end
		table.insert(DB.Sorted.Pet_Damage, {pet_name, damage})
	end
end

------------------------------------------------------------------------------------------------------
-- Builds the sorted cataloged damage table.
-- This table contains the total amount of damage that each recognized player has done for a cataloged action.
------------------------------------------------------------------------------------------------------
---@param player_name string name of the player that did the cataloged action
---@param pet_name string
------------------------------------------------------------------------------------------------------
DB.Lists.Populate.Pet_Catalog_Damage = function(player_name, pet_name)
	DB.Sorted.Pet_Catalog_Damage = {}
	for _, trackable in pairs(DB.PetSingleTrackables) do
		if DB.Lists.Check.Pet_Catalog_Exists(trackable, player_name, pet_name) then
			for action_name, _ in pairs(DB.Tracking.PetTrackables[trackable][player_name][pet_name]) do
				table.insert(DB.Sorted.Pet_Catalog_Damage, {action_name, 999, trackable})
			end
		end
	end
end

------------------------------------------------------------------------------------------------------
-- Checks to see if a mob has been initialized for the Mob Filter list.
------------------------------------------------------------------------------------------------------
---@param target_name string
------------------------------------------------------------------------------------------------------
DB.Lists.Check.MobExists = function(target_name)
	if target_name ~= DB.Enum.DEBUG and not DB.Tracking.InitializedMobs[target_name] then
		DB.Tracking.InitializedMobs[target_name] = true
		table.insert(DB.Sorted.Mobs, target_name)
		table.sort(DB.Sorted.Mobs)
	end
end

------------------------------------------------------------------------------------------------------
-- Checks if the player has any cataloged data for the specified focus type.
-- Can use this to check if there is anything to publish via report before attempting to do so.
------------------------------------------------------------------------------------------------------
---@param player_name string name of the player that did the cataloged action
---@param focus_type string the trackable that is of interest.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Lists.Check.Catalog_Exists = function(player_name, focus_type)
	if not DB.Tracking.Trackables[focus_type] or not DB.Tracking.Trackables[focus_type][player_name] then return false end
	return true
end

------------------------------------------------------------------------------------------------------
-- Checks if there is any pet cataloged data for a certain player/pet.
-- I made this to get check if the pet catalog header should show in the focus window.
------------------------------------------------------------------------------------------------------
---@param trackable string a tracked item from the trackable list.
---@param player_name string
---@param pet_name string
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Lists.Check.Pet_Catalog_Exists = function(trackable, player_name, pet_name)
	if not DB.Tracking.PetTrackables[trackable] then return false end
	if not DB.Tracking.PetTrackables[trackable][player_name] then return false end
	if not DB.Tracking.PetTrackables[trackable][player_name][pet_name] then return false end
	return true
end