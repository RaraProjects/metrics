DB = {}

-- Primary Database
DB.Parse = {}                          	-- [index][trackable][metric]
DB.Parse_Catalog = {}					-- [index][action_name][trackable][metric]
DB.Pet_Parse = {}						-- [index][pet][trackable][metric]
DB.Pet_Parse_Catalog = {}				-- [index][pet][action_name][trackable][metric]
DB.Total_Damage = 0
DB.Total_Damage_No_Skillchain = 0

-- Secondary Tracking Tables
DB.Tracking = {}
DB.Tracking.Trackable = {}             	-- [trackable][player_name]
DB.Tracking.Pet_Trackable = {}         	-- [trackable][player_name][pet_name]
DB.Tracking.Initialized_Players = {}   	-- [player_name]
DB.Tracking.Initialized_Pets = {}      	-- [player_name][pet_name]
DB.Tracking.Initialized_Mobs = {}      	-- [mob_name]
DB.Tracking.Running_Accuracy = {}		-- [player_name]
DB.Tracking.Running_Attack_Speed = {}  	-- [player_name]
DB.Tracking.Running_Damage = {}			-- [player_name]
DB.Tracking.Multi_Attack = {}			-- [player_name][multi-rank]
DB.Tracking.Defeated_Mobs = {}			-- [mob_name]

-- Used to hold column data for performance improvements.
DB.Cache = {}							-- [player_name][trackable][metric]
DB.Catalog_Cache = {}					-- [player_name][action_name][trackable][metric]
DB.Pet_Cache = {}						-- [player_name][pet_name][trackable][metric]
DB.Pet_Catalog_Cache = {}				-- [player_name][pet_name][action_name][trackable][metric]

DB.Settings = {}
DB.Settings.Accuracy_Warning = 0.80

-- These are used for user saved settings.
DB.Defaults = {
	Running_Accuracy_Limit = 25
}

require("database._enum")
require("database.accuracy")
require("database.dps")
require("database.attack_speed")
require("database.catalog")
require("database.data")
require("database.lists")
require("database.pet_catalog")
require("database.pet_data")
require("database.widgets")

------------------------------------------------------------------------------------------------------
-- Resets the parsing data and clears the battle log.
------------------------------------------------------------------------------------------------------
---@param manual_reset? boolean true: manual reset; false: normal initialization
------------------------------------------------------------------------------------------------------
DB.Initialize = function(manual_reset)
	if Metrics.Report.Auto_Save and manual_reset then
		File.Save_Data()
		File.Save_Battlelog()
	end

	DB.Parse = {}
	DB.Parse_Catalog = {}
	DB.Pet_Parse = {}
	DB.Pet_Parse_Catalog = {}
	DB.Total_Damage = 0
	DB.Total_Damage_No_Skillchain = 0

	DB.Cache = {}
	DB.Catalog_Cache = {}
	DB.Pet_Cache = {}
	DB.Pet_Catalog_Cache = {}

	DB.Tracking.Trackable = {}
	DB.Tracking.Pet_Trackable = {}
	DB.Tracking.Initialized_Players = {}
    DB.Tracking.Initialized_Pets = {}
    DB.Tracking.Initialized_Mobs = {[DB.Enum.ALL_MOBS] = true}
    DB.Tracking.Running_Accuracy = {}
	DB.Tracking.Running_Damage = {}
	DB.Tracking.Multi_Attack = {}
    DB.Tracking.Defeated_Mobs = {}

	DB.Sorted.Players = {[1] = DB.Widgets.Dropdown.Enum.NONE}
	DB.Sorted.Mobs = {[1] = DB.Enum.ALL_MOBS}

	DB.Healing_Max = {}
	DB.Widgets.Dropdown.Player.Focus = DB.Widgets.Dropdown.Enum.NONE
	DB.Widgets.Dropdown.Player.Index = 1
	DB.Widgets.Dropdown.Mob.Focus = DB.Enum.ALL_MOBS
	DB.Widgets.Dropdown.Mob.Index = 1
	for spell, threshold in pairs(DB.Healing_Max_Defaults) do
		DB.Healing_Max[spell] = threshold
	end
	DB.Attack_Speed.Reset()
	Timers.Reset(Timers.Enum.Names.PARSE)
end

------------------------------------------------------------------------------------------------------
-- Calculates the total damage from everyone currently on the Parse display.
------------------------------------------------------------------------------------------------------
---@return number
------------------------------------------------------------------------------------------------------
DB.Team_Damage = function()
	local damage = DB.Total_Damage_No_Skillchain
    if Parse.Config.Include_SC_Damage() then damage = DB.Total_Damage end
	return damage
end

------------------------------------------------------------------------------------------------------
-- Calculates the total damage by type from everyone currently on the Parse display.
------------------------------------------------------------------------------------------------------
---@return number
------------------------------------------------------------------------------------------------------
DB.Team_Damage_By_Type = function(damage_type)
	local total = 0
	local sorted_damage = DB.Lists.Sort.Total_Damage()
	for rank, data in ipairs(sorted_damage) do
		if rank <= Parse.Config.Rank_Cutoff() then
			local player_name = data[1]
			total = total + DB.Data.Get(player_name, damage_type, DB.Metric.TOTAL)
		end
	end
	return total
end

------------------------------------------------------------------------------------------------------
-- Keeps track of how many mobs have been defeated.
------------------------------------------------------------------------------------------------------
---@param mob_name string
------------------------------------------------------------------------------------------------------
DB.Defeated_Mob = function(mob_name)
	if not DB.Tracking.Defeated_Mobs[mob_name] then DB.Tracking.Defeated_Mobs[mob_name] = 0 end
	DB.Tracking.Defeated_Mobs[mob_name] = DB.Tracking.Defeated_Mobs[mob_name] + 1
end

------------------------------------------------------------------------------------------------------
-- Checks if a trackable should update total metrics or not.
------------------------------------------------------------------------------------------------------
---@param trackable string a tracked item from the trackable list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Is_Total_Damage_Trackable = function(trackable)
	if trackable == DB.Trackable.SPELLS_HEALING or
	   trackable == DB.Trackable.DEF_HEALING_RECEIVED or
	   trackable == DB.Trackable.ALL_HEAL or
	   trackable == DB.Trackable.ABILITY_HEALING or
	   trackable == DB.Trackable.ABILITY_MP_RECOVERY or
	   trackable == DB.Trackable.PET_HEALING or
	   trackable == DB.Trackable.SPELLS_MP_DRAIN or
	   trackable == DB.Trackable.DEF_NUKING or
	   trackable == DB.Trackable.DEF_NUKING_PET or
	   trackable == DB.Trackable.DEF_SPIKES or
	   trackable == DB.Trackable.DEF_TP_MOVE or
	   trackable == DB.Trackable.DEF_TP_MOVE_PET or
	   trackable == DB.Trackable.DEF_MELEE or
	   trackable == DB.Trackable.DEF_MELEE_PET then
		return false
	end
	return true
end

------------------------------------------------------------------------------------------------------
-- Checks if a metric requires its base value to be MAX_VALUE instead of zero.
------------------------------------------------------------------------------------------------------
---@param metric string
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Metric_Needs_Max_Value = function(metric)
	if not metric then return false end
	return metric == DB.Metric.MIN or metric == DB.Metric.CRITICAL_MIN
end

------------------------------------------------------------------------------------------------------
-- Checks if a value nil.
------------------------------------------------------------------------------------------------------
---@param caller string
---@param value any
---@param value_name string
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Is_Value_Empty = function(caller, value, value_name)
	if not value or value == "" then
		Debug.Error.Add(Debug.Error.ERROR, caller, tostring(value_name) .. " is empty {" .. tostring(value) .. "}.")
		return true
	end
	return false
end