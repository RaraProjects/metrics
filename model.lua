local m = {}

m.Enum = {
	Misc = {
		IGNORE   = 'ignore',
		COMBINED = 'combined',
		MAX_DAMAGE = 100000,
	},
	Node   = {
		CATALOG     = "catalog",
		PET_CATALOG = "pet_catalog"
	},
	Index  = {
		DEBUG = "Debug"
	},
	Trackable = {
		TOTAL       = "Total",
		TOTAL_NO_SC = 'No SC Total',
		MELEE       = 'Melee',
		MELEE_MAIN  = 'Melee Mainhand',
		MELEE_OFFH  = 'Melee Offhand',
		MELEE_KICK  = 'Melee Kicks',
		PET_MELEE   = 'Pet Melee',
		PET_MELEE_DISCRETE = 'pet_melee_discrete',
		RANGED      = 'Ranged',
		PET_RANGED  = 'Pet Ranged',
		THROWING    = 'Throwing',
		WS          = 'Weaponskills',
		PET_WS      = 'Pet Weaponskill',
		SC          = 'Skillchains',
		ABILITY     = 'Abilities',
		PET_ABILITY = 'Pet Ability',
		PET_HEAL    = 'Pet Healing',
		MAGIC       = 'Spells',
		ENSPELL     = 'Enspell',
		NUKE        = 'Nuke',
		HEALING     = "Healing",
		MP_DRAIN    = "MP Drain",
		PET         = 'Pet',
		DEATH       = 'Death',
		DEFAULT     = 'Default',
	},
	Metric = {
		TOTAL        = 'Total',
		COUNT        = 'count',
		HIT_COUNT    = 'hits',
		CRIT_COUNT   = 'crits',
		CRIT_DAMAGE  = 'crit damage',
		MISS_COUNT   = 'misses',
		SHADOWS      = 'shadows',
		MOB_HEAL     = 'mob heal',
		MIN          = 'min',
		MAX          = 'max',
		BURST_COUNT  = 'burst count',
		BURST_DAMAGE = 'burst damage',
		OVERCURE     = 'overcure'
	},
	Mode = {
		INC = "inc",
		SET = "set",
	},
	HEALING = {
		["Cure"]       = 50,	-- 35
		["Cure II"]    = 150, 	-- 102
		["Cure III"]   = 250, 	-- 212
		["Cure IV"]    = 500,	-- 430
		["Cure V"]     = 1300,
		["Cure VI"]    = 1500,
		["Curaga"]     = 150,	-- 102
		["Curaga II"]  = 400,	-- 213
		["Curaga III"] = 800,
		["Curaga IV"]  = 1000,
		["Curaga V"]   = 1300,
	},
}
m.Enum.Pet_Single_Trackable = {
	PET_WS      = m.Enum.Trackable.PET_WS,
	PET_ABILITY = m.Enum.Trackable.PET_ABILITY,
	PET_HEAL    = m.Enum.Trackable.PET_HEAL,
}

-- Needed to prevent Divine Seal from messing up overcure.
m.Healing_Max = {
    ["Cure"]       = 50,
    ["Cure II"]    = 150,
    ["Cure III"]   = 250,
    ["Cure IV"]    = 500,
    ["Cure V"]     = 1300,
    ["Cure VI"]    = 1500,
    ["Curaga"]     = 150,
    ["Curaga II"]  = 400,
    ["Curaga III"] = 800,
    ["Curaga IV"]  = 1000,
    ["Curaga V"]   = 1300,
}

m.Settings = {
	Running_Accuracy_Limit = 25,
	Accuracy_Warning = 0.80
}
m.Settings.Default = {
	Running_Accuracy_Limit = 25
}

m.Data = {
	Parse = {},	-- Holds all of the damage data that the parser uses index is.
				-- [player:mob][trackable][metric]
				-- [player:mob][trackable][catalog_type][action_name][metric]
				-- [player:mob][pet_name][trackable][metric]
				-- [player:mob][pet_name][trackable][metric][catalog_type][action_name][metric]

	Trackable = {},		-- [trackable][player_name] Keeps track of which skills have been initialized
	Pet_Trackable = {},	-- [trackable][player_name][pet_name]
	Initialized_Pets = {},
	Running_Accuracy = {},		-- Keeps track of the running accuracy data
	Total_Damage_Sorted  = {},	-- Ranks players based on relative total damage done
	Catalog_Damage_Race = {},	-- Ranks weaponskills, skillchains, abilities, etc.
	Pet_Catalog_Damage_Race = {},
}

-- Initialize for mob selection drop down.
m.Data.Initialized_Players = {}	-- Keeps track of which entities have been initialized
m.Data.Player_List_Sorted = {}
m.Data.Initialized_Mobs = {}
m.Data.Mob_List_Sorted = {}

m.Init = {}
m.Sort = {}
m.Update = {}
m.Get = {}
m.Set = {}
m.Inc = {}
m.Util = {}

------------------------------------------------------------------------------------------------------
-- Resets the parsing data and clears the battle log.
------------------------------------------------------------------------------------------------------
m.Initialize = function()
	m.Data.Parse = {}
	m.Data.Trackable = {}
	m.Data.Pet_Trackable = {}
	m.Data.Initialized_Players = {}
	m.Data.Player_List_Sorted = {[1] = Window.Dropdown.Enum.NONE}
	m.Data.Initialized_Mobs = {[Window.Dropdown.Enum.NONE] = true}
	m.Data.Initialized_Pets = {}
	m.Data.Mob_List_Sorted = {[1] = Window.Dropdown.Enum.NONE}
	m.Data.Running_Accuracy = {}
	m.Data.Total_Damage_Sorted  = {}
	m.Data.Catalog_Damage_Race = {}
	Pet_Catalog_Damage_Race = {}
	m.Enum.Misc.NONE = Window.Dropdown.Enum.NONE
	m.Healing_Max = {}
	Window.Dropdown.Player.Index = 1
	Window.Dropdown.Mob.Index = 1
	for spell, threshold in pairs(m.Enum.HEALING) do
		m.Healing_Max[spell] = threshold
	end
	Blog.Reset_Log()
end

------------------------------------------------------------------------------------------------------
-- Initializes an "actor:target" combination in the primary data and catalog data nodes.
-- Also initializes separate tracking globals for Running Accuracy.
-- If the "actor:target" combo has already been initialized then this will quit out early.
-- CALLED BY: Init.Catalog, Update.Data, and Get.Total_Party_Damage
------------------------------------------------------------------------------------------------------
---@param index string "actor_name:target_name"
---@param player_name? string used for maintaining various player indexed tables. In the case of pets this will be the owner.
---@param pet_name? string used for maintaining various pet indexed tables.
---@return boolean
------------------------------------------------------------------------------------------------------
m.Init.Data = function(index, player_name, pet_name)
	if not index then
		_Debug.Error.Add("Init.Data: {" .. tostring(player_name) .. "} {" .. tostring(pet_name) .. "} nil index passed in." )
		return false
	end

	-- Check to see if the nodes have already been initialized for the player and the pet.
	if m.Data.Parse[index] then
		if pet_name then
			if m.Data.Parse[index][pet_name] then return false end
			m.Init.Pet_Data(index, player_name, pet_name)
			return true
		end
		return false
	end

	-- Initialize primary node.
	if not m.Data.Parse[index] then m.Data.Parse[index] = {} end

	-- If the player has a pet then intialize those nodes as well.
	if pet_name then m.Init.Pet_Data(index, player_name, pet_name) end

	-- Initialize data nodes
	for _, trackable in pairs(m.Enum.Trackable) do
		m.Data.Parse[index][trackable] = {}
		m.Data.Parse[index][trackable][m.Enum.Node.CATALOG] = {}
		for _, metric in pairs(m.Enum.Metric) do
			m.Set.Data(0, index, trackable, metric)
		end
	end

	-- Initialize tracking tables
	if player_name and not m.Data.Initialized_Players[player_name] then
		m.Data.Initialized_Players[player_name] = true
		m.Init.Sort_Players()
		m.Data.Running_Accuracy[player_name] = {}
	end

	return true
end

------------------------------------------------------------------------------------------------------
-- Initializes an [actor:target][pet_name] combination in the primary data node and catalog nodes.
-- Also initializes separate tracking globals for Running Accuracy.
-- If the "actor:target" combo has already been initialized then this will quit out early.
-- CALLED BY: Init.Data
------------------------------------------------------------------------------------------------------
---@param index string "actor_name:target_name"
---@param player_name? string used for maintaining various player indexed tables. In the case of pets this will be the owner.
---@param pet_name string used for maintaining various pet indexed tables.
------------------------------------------------------------------------------------------------------
m.Init.Pet_Data = function(index, player_name, pet_name)
	if m.Data.Parse[index][pet_name] then return nil end
	m.Data.Parse[index][pet_name] = {}

	-- Initialize data nodes
	for _, trackable in pairs(m.Enum.Trackable) do
		m.Data.Parse[index][pet_name][trackable] = {}
		m.Data.Parse[index][pet_name][trackable][m.Enum.Node.CATALOG] = {}
		for _, metric in pairs(m.Enum.Metric) do
			m.Set.Pet_Data(0, index, pet_name, trackable, metric)
		end
	end

	-- Initialize pet tracking tables.
	if player_name and not m.Data.Initialized_Pets[player_name] then
		m.Data.Initialized_Pets[player_name] = {}
	end
	if player_name and not m.Data.Initialized_Pets[player_name][pet_name] then
		m.Data.Initialized_Pets[player_name][pet_name] = true
	end

end

------------------------------------------------------------------------------------------------------
-- Initializes a cataloged action.
-- The base tables are initialized in the Init.Data and Init.Pet_Data functions.
-- If the action has already been initialized then this will quit out early.
-- Also initializes Trackable_Data which is used in the Focus Window.
-- CALLED BY: Update.Catalog_Damage and Update.Catalog Metric
------------------------------------------------------------------------------------------------------
---@param index string "actor_name:target_name"
---@param player_name string
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param pet_name? string
---@return boolean an initialization was performed.
------------------------------------------------------------------------------------------------------
m.Init.Catalog_Action = function(index, player_name, trackable, action_name, pet_name)
	if not index or not player_name or not trackable or not action_name then
		_Debug.Error.Add("Init.Catalog_Action: {" .. tostring(player_name) .. "} {" .. tostring(pet_name) .. "} nil required parameter passed in." )
		return false
	end

	m.Init.Data(index, player_name, pet_name)

	-- Don't want to overwrite action_name node if it is already built out
	if m.Data.Parse[index][trackable][m.Enum.Node.CATALOG][action_name] then
		if pet_name then
			if m.Data.Parse[index][pet_name][trackable][m.Enum.Node.CATALOG][action_name] then return false end
			m.Init.Pet_Catalog(index, player_name, trackable, action_name, pet_name)
			return true
		end
		return false
	end

	m.Data.Parse[index][trackable][m.Enum.Node.CATALOG][action_name] = {}
	if pet_name then m.Init.Pet_Catalog(index, player_name, trackable, action_name, pet_name) end

	-- Initialize catalog data nodes
	for _, metric in pairs(m.Enum.Metric) do
		m.Set.Catalog(0, index, trackable, action_name, metric)
	end

	-- Need to set minimum high manually to capture accurate minimums
	m.Set.Catalog(m.Enum.Misc.MAX_DAMAGE, index, trackable, action_name, m.Enum.Metric.MIN)

	-- Initialize tracking tables
	if not m.Data.Trackable[trackable] then m.Data.Trackable[trackable] = {} end
	if not m.Data.Trackable[trackable][player_name] then m.Data.Trackable[trackable][player_name] = {} end

	return true
end

------------------------------------------------------------------------------------------------------
-- Initializes a pet cataloged action.
-- If the action has already been initialized then this will quit out early.
-- Also initializes Trackable_Data which is used in the Focus Window.
------------------------------------------------------------------------------------------------------
---@param index string "actor_name:target_name"
---@param player_name string
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param pet_name string
------------------------------------------------------------------------------------------------------
m.Init.Pet_Catalog = function(index, player_name, trackable, action_name, pet_name)
	if m.Data.Parse[index][pet_name][trackable][m.Enum.Node.CATALOG][action_name] then return false end
	m.Data.Parse[index][pet_name][trackable][m.Enum.Node.CATALOG][action_name] = {}

	-- Initialize catalog data nodes
	for _, metric in pairs(m.Enum.Metric) do
		m.Set.Pet_Catalog(0, index, pet_name, trackable, action_name, metric)
	end

	m.Set.Pet_Catalog(m.Enum.Misc.MAX_DAMAGE, index, pet_name, trackable, action_name, m.Enum.Metric.MIN)

	-- Initialize tracking tables
	if not m.Data.Pet_Trackable[trackable] then m.Data.Pet_Trackable[trackable] = {} end
	if not m.Data.Pet_Trackable[trackable][player_name] then m.Data.Pet_Trackable[trackable][player_name] = {} end
	if not m.Data.Pet_Trackable[trackable][player_name][pet_name] then m.Data.Pet_Trackable[trackable][player_name][pet_name] = {} end
end

------------------------------------------------------------------------------------------------------
-- Sorts intiialized players so they show up in a reasonable order in the player selection drop down.
------------------------------------------------------------------------------------------------------
m.Init.Sort_Players = function()
	local name_sort = {}
	table.insert(name_sort, Window.Dropdown.Enum.NONE)
	for player_name, _ in pairs(m.Data.Initialized_Players) do
		table.insert(name_sort, player_name)
	end
	table.sort(name_sort)
	m.Data.Player_List_Sorted = name_sort
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
m.Update.Data = function(mode, value, audits, trackable, metric)
	local player_name = audits.player_name
	local target_name = audits.target_name
	local pet_name = audits.pet_name
	local index = m.Util.Build_Index(player_name, target_name)
	m.Init.Data(index, player_name, pet_name)

	if mode == m.Enum.Mode.INC then
		m.Inc.Data(value, index, trackable, metric)
		if pet_name then
			m.Inc.Pet_Data(value, index, pet_name, trackable, metric)
		end
	elseif mode == m.Enum.Mode.SET then
		m.Set.Data(value, index, trackable, metric)
		if pet_name then
			m.Set.Pet_Data(value, index, pet_name, trackable, metric)
		end
	end
end

------------------------------------------------------------------------------------------------------
-- Directs the setting of cataloged data.
-- Called by the action handling functions.
------------------------------------------------------------------------------------------------------
---@param player_name string name of the player or entity performing the action.
---@param mob_name string name of the mob or entity receiving the action.
---@param trackable string a tracked item from the trackable list.
---@param damage number damage value to be logged.
---@param action_name string the name of the action to be cataloged.
---@param pet_name? string
---@param burst? boolean whether or not a magic burst took place.
------------------------------------------------------------------------------------------------------
m.Update.Catalog_Damage = function(player_name, mob_name, trackable, damage, action_name, pet_name, burst)
    local index = m.Util.Build_Index(player_name, mob_name)
    m.Init.Catalog_Action(index, player_name, trackable, action_name, pet_name)

	local audits = {
		player_name = player_name,
		target_name = mob_name,
		pet_name = pet_name,
	}

	-- GRAND TOTAL ////////////////////////////////////////////////////////////////////////////////
	-- There is a regular track and a "no skillchains" track.
    if trackable ~= m.Enum.Trackable.HEALING and trackable ~= m.Enum.Trackable.PET_HEAL and trackable ~= m.Enum.Trackable.MP_DRAIN then
    	m.Update.Data(m.Enum.Mode.INC, damage, audits, m.Enum.Trackable.TOTAL, m.Enum.Metric.TOTAL)
		if trackable ~= m.Enum.Trackable.SC then
			m.Update.Data(m.Enum.Mode.INC, damage, audits, m.Enum.Trackable.TOTAL_NO_SC, m.Enum.Metric.TOTAL)
		end
    end

    -- TRACKABLE TOTAL, MIN, and MAX //////////////////////////////////////////////////////////////
    m.Update.Data(m.Enum.Mode.INC, damage, audits, trackable, m.Enum.Metric.TOTAL)
	if trackable == m.Enum.Trackable.MAGIC and burst then
		m.Update.Data(m.Enum.Mode.INC, damage, audits, trackable, m.Enum.Metric.BURST_DAMAGE)
	end

	-- We can't log a miss (0 damage) to MIN because then the miminum will always be zero.
    if damage > 0 and damage < m.Get.Data(player_name, trackable, m.Enum.Metric.MIN) then
		m.Update.Data(m.Enum.Mode.SET, damage, audits, trackable, m.Enum.Metric.MIN)
	end

    if damage > m.Get.Data(player_name, trackable, m.Enum.Metric.MAX) then
		m.Update.Data(m.Enum.Mode.SET, damage, audits, trackable, m.Enum.Metric.MAX)
	end

    -- CATALOG TOTAL, MIN, and MAX ////////////////////////////////////////////////////////////////
	-- COUNT gets incremented in the packet handler.
    m.Update.Catalog_Metric(m.Enum.Mode.INC, damage, audits, trackable, action_name, m.Enum.Metric.TOTAL)
	if trackable == m.Enum.Trackable.MAGIC and burst then
		m.Update.Catalog_Metric(m.Enum.Mode.INC, damage, audits, trackable, action_name, m.Enum.Metric.BURST_DAMAGE)
	end

    if damage > 0 and damage < m.Get.Catalog(player_name, trackable, action_name, m.Enum.Metric.MIN) then
		m.Update.Catalog_Metric(m.Enum.Mode.SET, damage, audits, trackable, action_name, m.Enum.Metric.MIN)
    end

    if damage > m.Get.Catalog(player_name, trackable, action_name, m.Enum.Metric.MAX) then
    	-- Add a check for abnormally high healing magic to prevent Divine Seal from messing up overcure.
		if trackable == m.Enum.Trackable.HEALING and damage <= Model.Healing_Max[action_name] then
			m.Update.Catalog_Metric(m.Enum.Mode.SET, damage, audits, trackable, action_name, m.Enum.Metric.MAX)
		elseif trackable ~= m.Enum.Trackable.HEALING then
			m.Update.Catalog_Metric(m.Enum.Mode.SET, damage, audits, trackable, action_name, m.Enum.Metric.MAX)
		end
    end
end

------------------------------------------------------------------------------------------------------
-- A handler function that makes sure the data is set appropriately (for cataloged actions)
-- This does not set data directly. Rather, it calls the Set~ or Inc~ functions.
-- This is called by the functions that perform the action handling.
------------------------------------------------------------------------------------------------------
---@param mode string flag calling out whether the data should be set or incremented.
---@param value number the value to set or increment the node to/by.
---@param audits table a table containing necessary data; helps save on parameter slots.
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
m.Update.Catalog_Metric = function(mode, value, audits, trackable, action_name, metric)
	local player_name = audits.player_name
	local target_name = audits.target_name
	local pet_name = audits.pet_name
	local index = m.Util.Build_Index(player_name, target_name)

	if not trackable or not player_name or not action_name then
		_Debug.Error.Add("Update.Catalog_Metric: {" .. tostring(player_name) .. "} {" .. tostring(pet_name) .. "} nil required parameter passed in." )
		return false
	end
	m.Init.Catalog_Action(index, player_name, trackable, action_name, pet_name)
	if not m.Data.Initialized_Players[player_name] then m.Data.Initialized_Players[player_name] = true end

	-- Set the data.
	if mode == m.Enum.Mode.INC then
		m.Inc.Catalog(value, index, trackable, action_name, metric)
		if pet_name then
			m.Inc.Pet_Catalog(value, index, pet_name, trackable, action_name, metric)
		end
	elseif mode == m.Enum.Mode.SET then
		m.Set.Catalog(value, index, trackable, action_name, metric)
		if pet_name then
			m.Set.Pet_Catalog(value, index, pet_name, trackable, action_name, metric)
		end
	end

	-- This is used for the focus window
	m.Data.Trackable[trackable][player_name][action_name] = true
	if pet_name then
		m.Data.Pet_Trackable[trackable][player_name][pet_name][action_name] = true
	end

	return true
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
m.Set.Data = function(value, index, trackable, metric)
	if not value or not index or not trackable or not metric then
		_Debug.Error.Add("Set.Data: {" .. tostring(index) .. "} {" .. tostring(trackable) .. "} nil required parameter passed in." )
		return false
	end
	m.Data.Parse[index][trackable][metric] = value
	return true
end

------------------------------------------------------------------------------------------------------
-- Directly sets a pet's trackables metric to a specified value.
------------------------------------------------------------------------------------------------------
---@param value number the value to set the node to.
---@param index string "actor_name:target_name".
---@param pet_name string
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric
---@return boolean
------------------------------------------------------------------------------------------------------
m.Set.Pet_Data = function(value, index, pet_name, trackable, metric)
	if not value or not index or not pet_name or not trackable or not metric then
		_Debug.Error.Add("Set.Pet_Data: {" .. tostring(index) .. "} {" .. tostring(trackable) .. "} nil required parameter passed in." )
		return false
	end
	m.Data.Parse[index][pet_name][trackable][metric] = value
	return true
end

------------------------------------------------------------------------------------------------------
-- Directly sets a trackable's cataloged action metric to a specified value.
-- Some trackables need to be cataloged discretely in addition to holistically.
-- For example, metrics for weapons skill damage and metrics for each individual weapon skill.
-- The discrete tracking happens in the "catalog" node under each trackable.
------------------------------------------------------------------------------------------------------
---@param value number the value to set the node to
---@param index string "player_name:mob_name"
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
m.Set.Catalog = function(value, index, trackable, action_name, metric)
	if not value or not index or not trackable or not action_name or not metric then
		_Debug.Error.Add("Set.Catalog: {" .. tostring(index) .. "} {" .. tostring(trackable) .. "} nil required parameter passed in." )
		return false
	end
	m.Data.Parse[index][trackable][m.Enum.Node.CATALOG][action_name][metric] = value
	return true
end

------------------------------------------------------------------------------------------------------
-- Directly sets a pet's trackables cataloged action metric to a specified value.
-- Some trackables need to be cataloged discretely in addition to holistically.
-- For example, metrics for weapons skill damage and metrics for each individual weapon skill.
-- The discrete tracking happens in the "catalog" node under each trackable.
------------------------------------------------------------------------------------------------------
---@param value number the value to set the node to
---@param index string "player_name:mob_name"
---@param pet_name string
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
m.Set.Pet_Catalog = function(value, index, pet_name, trackable, action_name, metric)
	if not value or not index or not pet_name or not trackable or not action_name or not metric then
		_Debug.Error.Add("Set.Pet_Catalog: {" .. tostring(index) .. "} {" .. tostring(pet_name) .. "} {".. tostring(trackable) .. "} nil required parameter passed in." )
		return false
	end
	m.Data.Parse[index][pet_name][trackable][m.Enum.Node.CATALOG][action_name][metric] = value
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
m.Inc.Data = function(value, index, trackable, metric)
	if not value or not index or not trackable or not metric then
		_Debug.Error.Add("Inc.Data: {" .. tostring(index) .. "} {" .. tostring(trackable) .. "} nil required parameter passed in." )
		return false
	end
	m.Data.Parse[index][trackable][metric] = m.Data.Parse[index][trackable][metric] + value
	return true
end

------------------------------------------------------------------------------------------------------
-- Increments a pet's trackables metric by a specified amount.
------------------------------------------------------------------------------------------------------
---@param value number the value to increment the node by.
---@param index string "player_name:mob_name"
---@param pet_name string
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
m.Inc.Pet_Data = function(value, index, pet_name, trackable, metric)
	if not value or not index or not pet_name or not trackable or not metric then
		_Debug.Error.Add("Inc.Pet_Data: {" .. tostring(index) .. "} {" .. tostring(pet_name) .. "} {" .. tostring(trackable) .. "} nil required parameter passed in." )
		return false
	end
	m.Data.Parse[index][pet_name][trackable][metric] = m.Data.Parse[index][pet_name][trackable][metric] + value
	return true
end

------------------------------------------------------------------------------------------------------
-- Increments a trackable's metric by a specified amount.
-- Some trackables need to be cataloged discretely in addition to holistically.
-- For example, metrics for weapons skill damage and metrics for each individual weapon skill.
-- The discrete tracking happens in the "catalog" node under each trackable.
------------------------------------------------------------------------------------------------------
---@param value number the value to increment the node by.
---@param index string "player_name:mob_name"
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
m.Inc.Catalog = function(value, index, trackable, action_name, metric)
	if not value or not index or not trackable or not action_name or not metric then
		_Debug.Error.Add("Inc.Catalog: {" .. tostring(index) .. "} {" .. tostring(trackable) .. "} nil required parameter passed in." )
		return false
	end
	m.Data.Parse[index][trackable][m.Enum.Node.CATALOG][action_name][metric]
	= m.Data.Parse[index][trackable][m.Enum.Node.CATALOG][action_name][metric] + value
	return true
end

------------------------------------------------------------------------------------------------------
-- Increments a trackable's metric by a specified amount.
-- Some trackables need to be cataloged discretely in addition to holistically.
-- For example, metrics for weapons skill damage and metrics for each individual weapon skill.
-- The discrete tracking happens in the "catalog" node under each trackable.
------------------------------------------------------------------------------------------------------
---@param value number the value to increment the node by.
---@param index string "player_name:mob_name"
---@param pet_name string
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
m.Inc.Pet_Catalog = function(value, index, pet_name, trackable, action_name, metric)
	if not value or not index or not pet_name or not trackable or not action_name or not metric then
		_Debug.Error.Add("Inc.Pet_Catalog: {" .. tostring(index) .. "} {" .. tostring(pet_name) .. "} {" .. tostring(trackable) .. "} nil required parameter passed in." )
		return false
	end
	m.Data.Parse[index][pet_name][trackable][m.Enum.Node.CATALOG][action_name][metric]
	= m.Data.Parse[index][pet_name][trackable][m.Enum.Node.CATALOG][action_name][metric] + value
	return true
end

------------------------------------------------------------------------------------------------------
-- Gets data from a trackable metric.
-- If the mob filter is set then only actions towards that mob are counted.
------------------------------------------------------------------------------------------------------
---@param player_name string the player or entity name to search data for.
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
---@return number
------------------------------------------------------------------------------------------------------
m.Get.Data = function(player_name, trackable, metric)
	local total = 0
	local mob_focus = Window.Util.Get_Mob_Focus()
	for index, _ in pairs(m.Data.Parse) do
		if mob_focus == m.Enum.Misc.NONE then
			if string.find(index, player_name .. ":") then
				total = total + m.Data.Parse[index][trackable][metric]
			end
		else
			if string.find(index, player_name .. ":" .. mob_focus) then
				total = total + m.Data.Parse[index][trackable][metric]
			end
		end
	end
	return total
end

------------------------------------------------------------------------------------------------------
-- Gets data from a pet's trackable metric.
-- If the mob filter is set then only actions towards that mob are counted.
-- Consider that not every player:mob index will have a pet node.
------------------------------------------------------------------------------------------------------
---@param player_name string the player or entity name to search data for.
---@param pet_name string
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
---@return number
------------------------------------------------------------------------------------------------------
m.Get.Pet_Data = function(player_name, pet_name, trackable, metric)
	local total = 0
	local mob_focus = Window.Util.Get_Mob_Focus()
	for index, _ in pairs(m.Data.Parse) do
		if mob_focus == m.Enum.Misc.NONE then
			if string.find(index, player_name .. ":") then
				if m.Data.Parse[index][pet_name] then
					total = total + m.Data.Parse[index][pet_name][trackable][metric]
				end
			end
		else
			if string.find(index, player_name .. ":" .. mob_focus) then
				if m.Data.Parse[index][pet_name] then
					total = total + m.Data.Parse[index][pet_name][trackable][metric]
				end
			end
		end
	end
	return total
end

------------------------------------------------------------------------------------------------------
-- Gets data from a trackable's cataloged metric.
-- If the mob filter is set then only actions towards that mob are counted.
------------------------------------------------------------------------------------------------------
---@param player_name string the player or entity name to search data for.
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return number
------------------------------------------------------------------------------------------------------
m.Get.Catalog = function(player_name, trackable, action_name, metric)
	local total = 0
	if metric == m.Enum.Metric.MIN then total = m.Enum.Misc.MAX_DAMAGE end
	local mob_focus = Window.Util.Get_Mob_Focus()
	for index, _ in pairs(m.Data.Parse) do
		if mob_focus == m.Enum.Misc.NONE then
			if string.find(index, player_name) then
				total = m.Util.Catalog_Calc(total, index, trackable, action_name, metric)
			end
		else
			if string.find(index, player_name .. ":" .. mob_focus) then
				total = m.Util.Catalog_Calc(total, index, trackable, action_name, metric)
			end
		end
	end
	return total
end

------------------------------------------------------------------------------------------------------
-- Gets data from a pet's trackables cataloged metric.
-- If the mob filter is set then only actions towards that mob are counted.
------------------------------------------------------------------------------------------------------
---@param player_name string the player or entity name to search data for.
---@param pet_name string
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return number
------------------------------------------------------------------------------------------------------
m.Get.Pet_Catalog = function(player_name, pet_name, trackable, action_name, metric)
	local total = 0
	if metric == m.Enum.Metric.MIN then total = m.Enum.Misc.MAX_DAMAGE end
	local mob_focus = Window.Util.Get_Mob_Focus()
	for index, _ in pairs(m.Data.Parse) do
		if mob_focus == m.Enum.Misc.NONE then
			if string.find(index, player_name .. ":") then
				total = m.Util.Pet_Catalog_Calc(total, index, pet_name, trackable, action_name, metric)
			end
		else
			if string.find(index, player_name .. ":" .. mob_focus) then
				total = m.Util.Pet_Catalog_Calc(total, index, pet_name, trackable, action_name, metric)
			end
		end
	end
	return total
end

------------------------------------------------------------------------------------------------------
-- Retrieval function to get the list of mobs that have been acted upon.
------------------------------------------------------------------------------------------------------
m.Get.Mob_List_Sorted = function()
	return m.Data.Mob_List_Sorted
end

------------------------------------------------------------------------------------------------------
-- Retrieval function to get the list of players that have data.
------------------------------------------------------------------------------------------------------
m.Get.Player_List_Sorted = function()
	return m.Data.Player_List_Sorted
end

------------------------------------------------------------------------------------------------------
-- Helper function for getting cataloged data.
------------------------------------------------------------------------------------------------------
---@param value number the value to increment the node by.
---@param index string "player_name:mob_name"
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return number
------------------------------------------------------------------------------------------------------
m.Util.Catalog_Calc = function(value, index, trackable, action_name, metric)
	if m.Data.Parse[index][trackable][m.Enum.Node.CATALOG][action_name] then
		if     metric == m.Enum.Metric.MIN then value = m.Util.Catalog_Calc_Min(value, index, trackable, action_name, metric)
		elseif metric == m.Enum.Metric.MAX then value = m.Util.Catalog_Calc_Max(value, index, trackable, action_name, metric)
		else   value = value + m.Data.Parse[index][trackable][m.Enum.Node.CATALOG][action_name][metric] end
	end
	return value
end

------------------------------------------------------------------------------------------------------
-- Helper function for getting pet cataloged data.
-- Using an BST pet job ability like Razor Fang will create and index of player:pet with a nil pet node.
-- The actual damage will come later in the monster TP packet.
-- Data.Parse[index][pet_name] gets initialized in m.Init.Pet_Data.
------------------------------------------------------------------------------------------------------
---@param value number the value to increment the node by.
---@param index string "player_name:mob_name"
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return number
------------------------------------------------------------------------------------------------------
m.Util.Pet_Catalog_Calc = function(value, index, pet_name, trackable, action_name, metric)
	if not m.Data.Parse[index][pet_name] then
		_Debug.Error.Add("Util.Pet_Catalog_Calc: Tried referencing uninitialized node. " .. tostring(index) .. " " .. tostring(pet_name) .. " " .. tostring(action_name))
		return value
	end

	if m.Data.Parse[index][pet_name][trackable][m.Enum.Node.CATALOG][action_name] then
		if     metric == m.Enum.Metric.MIN then value = m.Util.Pet_Catalog_Calc_Min(value, index, pet_name, trackable, action_name, metric)
		elseif metric == m.Enum.Metric.MAX then value = m.Util.Pet_Catalog_Calc_Max(value, index, pet_name, trackable, action_name, metric)
		else   value = value + m.Data.Parse[index][pet_name][trackable][m.Enum.Node.CATALOG][action_name][metric] end
	end

	return value
end

------------------------------------------------------------------------------------------------------
-- Helper function for getting cataloged data for minimum metric.
------------------------------------------------------------------------------------------------------
---@param min number current observed minimum value.
---@param index string "player_name:mob_name"
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return number
------------------------------------------------------------------------------------------------------
m.Util.Catalog_Calc_Min = function(min, index, trackable, action_name, metric)
	if min > m.Data.Parse[index][trackable][m.Enum.Node.CATALOG][action_name][metric] then
		min =  m.Data.Parse[index][trackable][m.Enum.Node.CATALOG][action_name][metric]
	end
	return min
end

------------------------------------------------------------------------------------------------------
-- Helper function for getting pet cataloged data for minimum metric.
------------------------------------------------------------------------------------------------------
---@param min number current observed minimum value.
---@param index string "player_name:mob_name"
---@param pet_name string
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return number
------------------------------------------------------------------------------------------------------
m.Util.Pet_Catalog_Calc_Min = function(min, index, pet_name, trackable, action_name, metric)
	if min <= m.Data.Parse[index][pet_name][trackable][m.Enum.Node.CATALOG][action_name][metric] then
		min =  m.Data.Parse[index][pet_name][trackable][m.Enum.Node.CATALOG][action_name][metric]
	end
	return min
end


------------------------------------------------------------------------------------------------------
-- Helper function for getting cataloged data for maximum metric.
------------------------------------------------------------------------------------------------------
---@param max number current observed maximum value.
---@param index string "player_name:mob_name"
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return number
------------------------------------------------------------------------------------------------------
m.Util.Catalog_Calc_Max = function(max, index, trackable, action_name, metric)
	if m.Data.Parse[index][trackable][m.Enum.Node.CATALOG][action_name][metric] > max then
		max = m.Data.Parse[index][trackable][m.Enum.Node.CATALOG][action_name][metric]
	end
	return max
end

------------------------------------------------------------------------------------------------------
-- Helper function for getting pet cataloged data for maximum metric.
------------------------------------------------------------------------------------------------------
---@param max number current observed maximum value.
---@param index string "player_name:mob_name"
---@param pet_name string
---@param trackable string a tracked item from the trackable list.
---@param action_name string the name of the action to be cataloged.
---@param metric string a trackable's metric from the metric list.
---@return number
------------------------------------------------------------------------------------------------------
m.Util.Pet_Catalog_Calc_Max = function(max, index, pet_name, trackable, action_name, metric)
	if m.Data.Parse[index][pet_name][trackable][m.Enum.Node.CATALOG][action_name][metric] > max then
		max = m.Data.Parse[index][pet_name][trackable][m.Enum.Node.CATALOG][action_name][metric]
	end
	return max
end

------------------------------------------------------------------------------------------------------
-- DEPRECATED - When a party member leaves the denominator changes and makes peoples percent greater than 100%.
-- Calculates total party / alliance damage for use in percentages.
------------------------------------------------------------------------------------------------------
---@return number
------------------------------------------------------------------------------------------------------
m.Get.Total_Party_Damage = function()
    local party = A.Data.Party()
	if not party or not party.party1_count then
		_Debug.Error.Add("Get.Total_Party_Damage: Received nil party data from Ashita.")
		return -1
	end

    local player, player_name, index
    local total_damage = 0
    local pt1_count = party.party1_count - 1
    local pt2_count = party.party2_count - 1
    local pt3_count = party.party3_count - 1

    -- Party 1
	local starting_slot = A.Party.Start_Slot(1)
    for slot = starting_slot, pt1_count, 1 do
		player = party[slot]
        if not player then
			_Debug.Error.Add("Get.Total_Party_Damage: Received nil party member data in Party 1.")
			return -1
		end

        player_name = player.name
        index = m.Util.Build_Index(player_name, m.Enum.Index.DEBUG)

        m.Init.Data(index)

        total_damage = total_damage + m.Get.Data(player_name, m.Enum.Trackable.TOTAL, m.Enum.Metric.TOTAL)
    end

    -- Party 2
	if pt2_count > 0 then
		starting_slot = A.Party.Start_Slot(2)
		for slot = starting_slot, pt2_count + starting_slot, 1 do
			player = party[slot]
			if not player then
				_Debug.Error.Add("Get.Total_Party_Damage: Received nil party member data in Party 2.")
				return -1
			end

			player_name = player.name
			index = m.Util.Build_Index(player_name, m.Enum.Index.DEBUG)

			m.Init.Data(index)

			total_damage = total_damage + m.Get.Data(player_name, m.Enum.Trackable.TOTAL, m.Enum.Metric.TOTAL)
		end
	end

    -- Party 3
	if pt2_count > 0 then
		starting_slot = A.Party.Start_Slot(3)
		for slot = starting_slot, pt3_count + starting_slot, 1 do
			player = party[slot]
			if not player then
				_Debug.Error.Add("Get.Total_Party_Damage: Received nil party member data in Party 3.")
				return -1
			end

			player_name = player.name
			index = m.Util.Build_Index(player_name, m.Enum.Index.DEBUG)

			m.Init.Data(index)

			total_damage = total_damage + m.Get.Data(player_name, m.Enum.Trackable.TOTAL, m.Enum.Metric.TOTAL)
		end
	end

    return total_damage
end

------------------------------------------------------------------------------------------------------
-- Calculates the total damage from everyone currently on the Team display.
------------------------------------------------------------------------------------------------------
---@return number
------------------------------------------------------------------------------------------------------
m.Get.Team_Damage = function()
	local total = 0
	m.Sort.Damage()
	for rank, data in ipairs(m.Data.Total_Damage_Sorted) do
		if rank <= Team.Settings.Rank_Cutoff then
			local player_name = data[1]
			if Team.Settings.Include_SC_Damage then
				total = total + m.Get.Data(player_name, m.Enum.Trackable.TOTAL, m.Enum.Metric.TOTAL)
			else
				total = total + m.Get.Data(player_name, m.Enum.Trackable.TOTAL_NO_SC, m.Enum.Metric.TOTAL)
			end
		end
	end
	return total
end

------------------------------------------------------------------------------------------------------
-- Builds the primary index for Parse_Data of the form player_name:mob_name
------------------------------------------------------------------------------------------------------
---@param actor_name string name of the player or entity performing the action
---@param target_name? string name of the mob or entity receiving the action
---@return string [actor_name:target_name]
------------------------------------------------------------------------------------------------------
m.Util.Build_Index = function(actor_name, target_name)
	if not target_name then
		_Debug.Error.Add("Util.Build_Index: {" .. tostring(actor_name) .. "} {" .. tostring(target_name) .. "} nil target name passed in.")
		target_name = m.Enum.Index.DEBUG
	end
	if not actor_name then
		_Debug.Error.Add("Util.Build_Index: {" .. tostring(actor_name) .. "} {" .. tostring(target_name) .. "} nil actor name passed in.")
		return m.Enum.Index.DEBUG
	end
	return actor_name..":"..target_name
end

------------------------------------------------------------------------------------------------------
-- Checks to see if a mob has been intiialized for the Mob Filter list.
------------------------------------------------------------------------------------------------------
---@param target_name string
------------------------------------------------------------------------------------------------------
m.Util.Check_Mob_List = function(target_name)
	if target_name ~= m.Enum.Index.DEBUG and not m.Data.Initialized_Mobs[target_name] then
		m.Data.Initialized_Mobs[target_name] = true
		table.insert(m.Data.Mob_List_Sorted, target_name)
		table.sort(m.Data.Mob_List_Sorted)
	end
end

------------------------------------------------------------------------------------------------------
-- Keeps a tally of the last running accuracy limit amount of hit attempts.
-- This is called by the action handling functions.
------------------------------------------------------------------------------------------------------
---@param player_name string primary index for the Running_Accuracy_Data table
---@param hit boolean if true then there was a hit; miss otherwise
---@return boolean
------------------------------------------------------------------------------------------------------
m.Update.Running_Accuracy = function(player_name, hit)
	if not m.Data.Running_Accuracy[player_name] then
		_Debug.Error.Add("Update.Running_Accuracy: {" .. tostring(player_name) .. "} is missing in Data.Running_Accuracy.")
		return false
	end
	local max = #m.Data.Running_Accuracy[player_name]
    if max >= m.Settings.Running_Accuracy_Limit then table.remove(m.Data.Running_Accuracy[player_name], m.Settings.Running_Accuracy_Limit) end
	table.insert(m.Data.Running_Accuracy[player_name], 1, hit)
	return true
end

------------------------------------------------------------------------------------------------------
-- Returns the players accuracy for the last running accuracy limit amount of attempts.
------------------------------------------------------------------------------------------------------
---@param player_name string primary index for the Running_Accuracy_Data table
---@return table {hits, count}
------------------------------------------------------------------------------------------------------
m.Get.Running_Accuracy = function(player_name)
	-- This error can occur in mini mode when trying to load data before the player has been initialized. Not a big deal.
	if not m.Data.Running_Accuracy[player_name] then
		_Debug.Error.Add("Get.Running_Accuracy: Attempt to get {" .. tostring(player_name) .. "} running accuracy, but it didn't exist.")
		return {0, 0}
	end
	local hits = 0
	local count = 0

	-- Tally how hits the player had in the last {running accuracy limit} amount of attempts.
	for _, value in pairs(m.Data.Running_Accuracy[player_name]) do
		if value then hits = hits + 1 end
		count = count + 1
	end

	return {hits, count}
end

------------------------------------------------------------------------------------------------------
-- Sorting function for the sorting the total damage table.
------------------------------------------------------------------------------------------------------
m.Sort.Damage = function()
	m.Util.Populate_Total_Damage_Table()
	table.sort(m.Data.Total_Damage_Sorted, function (a, b)
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
m.Util.Populate_Total_Damage_Table = function()
	m.Data.Total_Damage_Sorted = {}
	local damage
	for index, _ in pairs(m.Data.Initialized_Players) do
		if Team.Settings.Include_SC_Damage then
			damage = m.Get.Data(index, m.Enum.Trackable.TOTAL, m.Enum.Metric.TOTAL)
		else
			damage = m.Get.Data(index, m.Enum.Trackable.TOTAL_NO_SC, m.Enum.Metric.TOTAL)
		end
		table.insert(m.Data.Total_Damage_Sorted, {index, damage})
	end
end

------------------------------------------------------------------------------------------------------
-- Sorting function for the sorted cataloged damage table.
------------------------------------------------------------------------------------------------------
---@param player_name string name of the player that did the cataloged action
---@param focus_type string the trackable that is of interest.
------------------------------------------------------------------------------------------------------
m.Sort.Catalog_Damage = function(player_name, focus_type)
	if not focus_type then
		_Debug.Error.Add("Sort.Catalog_Damage: {" .. tostring(player_name) .. "} focus_type wasn't provided.")
		return nil
	end
	m.Util.Populate_Catalog_Damage_Table(player_name, focus_type)
	table.sort(m.Data.Catalog_Damage_Race, function (a, b)
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
m.Sort.Pet_Catalog_Damage = function(player_name, pet_name)
	m.Util.Pet_Populate_Catalog_Damage_Table(player_name, pet_name)
	table.sort(m.Data.Pet_Catalog_Damage_Race, function (a, b)
		local a_damage = a[2]
		local b_damage = b[2]
		return (a_damage > b_damage)
	end)
end

------------------------------------------------------------------------------------------------------
-- Builds the sorted cataloged damage table.
-- This table contains the total amount of damage that each recognized player has done for a cataloged action.
------------------------------------------------------------------------------------------------------
---@param player_name string name of the player that did the cataloged action
---@param focus_type string the trackable that is of interest.
------------------------------------------------------------------------------------------------------
m.Util.Populate_Catalog_Damage_Table = function(player_name, focus_type)
	if not focus_type then
		_Debug.Error.Add("Util.Populate_Total_Damage_Table: {" .. tostring(player_name) .. "} focus_type wasn't provided.")
		return nil
	end
	m.Data.Catalog_Damage_Race = {}
	for action_name, _ in pairs(m.Data.Trackable[focus_type][player_name]) do
		table.insert(m.Data.Catalog_Damage_Race, {action_name, m.Get.Catalog(player_name, focus_type, action_name, m.Enum.Metric.TOTAL)})
	end
end

------------------------------------------------------------------------------------------------------
-- Builds the sorted cataloged damage table.
-- This table contains the total amount of damage that each recognized player has done for a cataloged action.
------------------------------------------------------------------------------------------------------
---@param player_name string name of the player that did the cataloged action
---@param pet_name string
------------------------------------------------------------------------------------------------------
m.Util.Pet_Populate_Catalog_Damage_Table = function(player_name, pet_name)
	m.Data.Pet_Catalog_Damage_Race = {}
	for _, trackable in pairs(m.Enum.Pet_Single_Trackable) do
		if m.Util.Pet_Catalog_Exists(trackable, player_name, pet_name) then
			for action_name, _ in pairs(m.Data.Pet_Trackable[trackable][player_name][pet_name]) do
				table.insert(m.Data.Pet_Catalog_Damage_Race, {action_name, 999, trackable})
			end
		end
	end
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
m.Util.Pet_Catalog_Exists = function(trackable, player_name, pet_name)
	if not m.Data.Pet_Trackable[trackable] then return false end
	if not m.Data.Pet_Trackable[trackable][player_name] then return false end
	if not m.Data.Pet_Trackable[trackable][player_name][pet_name] then return false end
	return true
end

return m