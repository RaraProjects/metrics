DB.Lists = T{}

-- Sorted Lists
DB.Sorted = T{}
DB.Sorted.Players = T{}
DB.Sorted.Mobs = T{}
DB.Sorted.Total_Damage = T{}
DB.Sorted.Catalog_Damage = T{}
DB.Sorted.Pet_Catalog_Damage = T{}

-- Function Containers
DB.Lists.Get = T{}
DB.Lists.Sort = T{}
DB.Lists.Populate = T{}
DB.Lists.Check = T{}

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
	table.insert(name_sort, Window.Dropdown.Enum.NONE)
	for player_name, _ in pairs(DB.Tracking.Initialized_Players) do
		table.insert(name_sort, player_name)
	end
	table.sort(name_sort)
	DB.Sorted.Players = name_sort
end

------------------------------------------------------------------------------------------------------
-- Sorting function for the sorting the total damage table.
------------------------------------------------------------------------------------------------------
DB.Lists.Sort.Total_Damage = function()
	DB.Lists.Populate.Total_Damage()
	table.sort(DB.Sorted.Total_Damage, function (a, b)
		local a_damage = a[2]
		local b_damage = b[2]
		return (a_damage > b_damage)
	end)
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
	local damage
	for player_name, _ in pairs(DB.Tracking.Initialized_Players) do
		damage = DB.Data.Get(player_name, trackable, DB.Enum.Metric.TOTAL)
		table.insert(sorted_damage, {player_name, damage})
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
---@param focus_type string the trackable that is of interest.
------------------------------------------------------------------------------------------------------
DB.Lists.Sort.Catalog_Damage = function(player_name, focus_type)
	if not focus_type then
		_Debug.Error.Add("Sort.Catalog_Damage: {" .. tostring(player_name) .. "} focus_type wasn't provided.")
		return nil
	end
	DB.Lists.Populate.Catalog_Damage(player_name, focus_type)
	table.sort(DB.Sorted.Catalog_Damage, function (a, b)
		local a_damage = a[2]
		local b_damage = b[2]
		return (a_damage > b_damage)
	end)
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
-- Builds the sorted total damage table.
-- This table contains the total amount of damage that each recognized player has done.
-- Capable of filtering out skillchain damage.
------------------------------------------------------------------------------------------------------
DB.Lists.Populate.Total_Damage = function()
	DB.Sorted.Total_Damage = {}
	local damage
	for index, _ in pairs(DB.Tracking.Initialized_Players) do
		if Metrics.Team.Settings.Include_SC_Damage then
			damage = DB.Data.Get(index, DB.Enum.Trackable.TOTAL, DB.Enum.Metric.TOTAL)
		else
			damage = DB.Data.Get(index, DB.Enum.Trackable.TOTAL_NO_SC, DB.Enum.Metric.TOTAL)
		end
		table.insert(DB.Sorted.Total_Damage, {index, damage})
	end
end

------------------------------------------------------------------------------------------------------
-- Builds the sorted cataloged damage table.
-- This table contains the total amount of damage that each recognized player has done for a cataloged action.
------------------------------------------------------------------------------------------------------
---@param player_name string name of the player that did the cataloged action
---@param focus_type string the trackable that is of interest.
------------------------------------------------------------------------------------------------------
DB.Lists.Populate.Catalog_Damage = function(player_name, focus_type)
	if not focus_type then
		_Debug.Error.Add("Util.Populate_Total_Damage_Table: {" .. tostring(player_name) .. "} focus_type wasn't provided.")
		return nil
	elseif not DB.Tracking.Trackable[focus_type] or not DB.Tracking.Trackable[focus_type][player_name] then
		_Debug.Error.Add("Util.Populate_Total_Damage_Table: {" .. tostring(player_name) .. "} does have data for focus type {" .. tostring(focus_type) .. "}")
		return nil
	end
	DB.Sorted.Catalog_Damage = {}
	for action_name, _ in pairs(DB.Tracking.Trackable[focus_type][player_name]) do
		table.insert(DB.Sorted.Catalog_Damage, {action_name, DB.Catalog.Get(player_name, focus_type, action_name, DB.Enum.Metric.TOTAL)})
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
	for _, trackable in pairs(DB.Enum.Pet_Single_Trackable) do
		if DB.Lists.Check.Pet_Catalog_Exists(trackable, player_name, pet_name) then
			for action_name, _ in pairs(DB.Tracking.Pet_Trackable[trackable][player_name][pet_name]) do
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
DB.Lists.Check.Mob_Exists = function(target_name)
	if target_name ~= DB.Enum.Values.DEBUG and not DB.Tracking.Initialized_Mobs[target_name] then
		DB.Tracking.Initialized_Mobs[target_name] = true
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
	if not DB.Tracking.Trackable[focus_type] or not DB.Tracking.Trackable[focus_type][player_name] then return false end
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
	if not DB.Tracking.Pet_Trackable[trackable] then return false end
	if not DB.Tracking.Pet_Trackable[trackable][player_name] then return false end
	if not DB.Tracking.Pet_Trackable[trackable][player_name][pet_name] then return false end
	return true
end