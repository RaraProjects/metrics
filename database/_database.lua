DB = { }

-- Primary Database
DB.Parse           = { }              	-- [player_name][target_name][trackable][metric]
DB.ParseCatalog    = { }				-- [player_name][target_name][action_name][trackable][metric]
DB.PetParse        = { }				-- [player_name][pet][target_name][trackable][metric]
DB.PetParseCatalog = { }				-- [player_name][pet][target_name][action_name][trackable][metric]
DB.TotalDamage = 0
DB.TotalDamageNoSkillchain = 0

-- Secondary Tracking Tables
DB.Tracking                    = { }
DB.Tracking.Trackables         = { }  	-- [trackable][player_name]
DB.Tracking.PetTrackables      = { }  	-- [trackable][player_name][pet_name]
DB.Tracking.InitializedPlayers = { }  	-- [player_name]
DB.Tracking.InitializedPets    = { }  	-- [player_name][pet_name]
DB.Tracking.InitializedMobs    = { }  	-- [mob_name]
DB.Tracking.RunningAccuracy    = { }	-- [player_name]
DB.Tracking.RunningAttackSpeed = { }  	-- [player_name]
DB.Tracking.RunningDamage      = { }	-- [player_name]
DB.Tracking.MultiAttack        = { }	-- [player_name][multi-rank]
DB.Tracking.DefeatedMobs       = { }	-- [mob_name]
DB.Tracking.TotalItems         = { }	-- [item_name]
DB.Tracking.ReceivedItems      = { }	-- [recipient_name][item_name]
DB.Tracking.DropRates          = { }	-- [mob_name][item_name]

-- Used to hold column data for performance improvements.
DB.Cache           = { }				-- [player_name][trackable][metric]
DB.CatalogCache    = { }				-- [player_name][action_name][trackable][metric]
DB.PetCache        = { }				-- [player_name][pet_name][trackable][metric]
DB.PetCatalogCache = { }				-- [player_name][pet_name][action_name][trackable][metric]

DB.Settings = { }
DB.Settings.AccuracyWarning = 0.80

-- These are used for user saved settings. Keep the "T" on this one.
DB.Defaults = T{
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
---@param isManualReset? boolean true: manual reset; false: normal initialization
------------------------------------------------------------------------------------------------------
DB.Initialize = function(isManualReset)
	if Report and Report.Settings and Report.Settings.Auto_Save and isManualReset then
		File.SaveData()
		File.SaveBattlelog()
	end

	DB.Parse           = { }
	DB.ParseCatalog    = { }
	DB.PetParse        = { }
	DB.PetParseCatalog = { }
	DB.TotalDamage = 0
	DB.TotalDamageNoSkillchain = 0

	DB.Cache           = { }
	DB.CatalogCache    = { }
	DB.PetCache        = { }
	DB.PetCatalogCache = { }

	DB.Tracking.Trackables         = { }
	DB.Tracking.PetTrackables      = { }
	DB.Tracking.InitializedPlayers = { }
    DB.Tracking.InitializedPets    = { }
    DB.Tracking.InitializedMobs    = { [DB.Enum.ALL_MOBS] = true }
    DB.Tracking.RunningAccuracy    = { }
	DB.Tracking.RunningDamage      = { }
	DB.Tracking.MultiAttack        = { }
    DB.Tracking.DefeatedMobs       = { }
	DB.Tracking.TotalItems         = { }
	DB.Tracking.ReceivedItems      = { }
	DB.Tracking.DropRates          = { }

	DB.HealingMax = { }

	DB.Widgets.DropdownPlayerFilterFocus = DB.Enum.NONE
	DB.Widgets.DropdownPlayerFilterIndex = 1

    DB.Lists.Mobs = { DB.Enum.ALL_MOBS }

    if isManualReset then
        local focus = DB.Widgets.DropdownMobFilterFocus
        table.insert(DB.Lists.Mobs, focus)
        DB.Tracking.InitializedMobs[focus] = true
    end

    DB.Widgets.DropdownMobFilterIndex = isManualReset and 2 or 1

	for spell, threshold in pairs(DB.HealingMaxDefaults) do
		DB.HealingMax[spell] = threshold
	end

	DB.AttackSpeed.Reset()

	Timers.Reset(Timers.Types.PARSE)
end

------------------------------------------------------------------------------------------------------
-- Calculates the total damage from everyone currently on the Parse display.
------------------------------------------------------------------------------------------------------
---@return number
------------------------------------------------------------------------------------------------------
DB.GetTeamDamage = function()
	local totalDamage = 0
	local trackable   = Parse.Config.IncludeSkillchainDamage() and DB.Trackable.TOTAL_DAMAGE or DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN

	for playerName, _ in pairs(DB.Tracking.InitializedPlayers) do
		totalDamage = totalDamage + DB.Data.Get(playerName, trackable, DB.Metric.TOTAL)
	end

	return totalDamage
end

------------------------------------------------------------------------------------------------------
-- Calculates the total damage by type from everyone currently on the Parse display.
------------------------------------------------------------------------------------------------------
---@param trackable DB.Trackable
---@return number
------------------------------------------------------------------------------------------------------
DB.GetTeamDamageByType = function(trackable)
	local totalDamage  = 0
	local sortedDamage = DB.Lists.GetSortedDamage()
	local rankCutoff   = Parse.Config.RankCutoff()

	for rank, data in ipairs(sortedDamage) do
		if rank <= rankCutoff then
			local player_name = data[1]
			totalDamage = totalDamage + (DB.Data.Get(player_name, trackable, DB.Metric.TOTAL) or 0)
		end
	end

	return totalDamage
end

------------------------------------------------------------------------------------------------------
-- Keeps track of how many mobs have been defeated.
------------------------------------------------------------------------------------------------------
---@param mobName string
------------------------------------------------------------------------------------------------------
DB.TallyDefeatedMob = function(mobName)
	DB.Tracking.DefeatedMobs[mobName] = (DB.Tracking.DefeatedMobs[mobName] or 0) + 1
end

------------------------------------------------------------------------------------------------------
-- Checks if a trackable should update total metrics or not.
------------------------------------------------------------------------------------------------------
---@param trackable DB.Trackable
---@return boolean
------------------------------------------------------------------------------------------------------
DB.IsTotalDamageTrackable = function(trackable)
	local excludedTrackables =
	{
		[DB.Trackable.SPELLS_HEALING]       = true,
		[DB.Trackable.DEF_HEALING_RECEIVED] = true,
		[DB.Trackable.ALL_HEAL]             = true,
		[DB.Trackable.ABILITY_HEALING]      = true,
		[DB.Trackable.ABILITY_MP_RECOVERY]  = true,
		[DB.Trackable.PET_HEALING]          = true,
		[DB.Trackable.SPELLS_MP_DRAIN]      = true,
		[DB.Trackable.WEAPONSKILL_MP_DRAIN] = true,
		[DB.Trackable.DEF_NUKING]           = true,
		[DB.Trackable.DEF_NUKING_PET]       = true,
		[DB.Trackable.DEF_SPIKES]           = true,
		[DB.Trackable.DEF_TP_MOVE]          = true,
		[DB.Trackable.DEF_TP_MOVE_PET]      = true,
		[DB.Trackable.DEF_MELEE]            = true,
		[DB.Trackable.DEF_MELEE_PET]        = true,
		[DB.Trackable.DEF_MP_DRAIN]         = true,
	}

	return not excludedTrackables[trackable]
end

------------------------------------------------------------------------------------------------------
-- Checks if a metric requires its base value to be MAX_VALUE instead of zero.
------------------------------------------------------------------------------------------------------
---@param metric DB.Metric
---@return boolean
------------------------------------------------------------------------------------------------------
DB.MetricNeedsMaxValue = function(metric)
	return metric and (metric == DB.Metric.MIN or metric == DB.Metric.CRITICAL_MIN) or false
end

------------------------------------------------------------------------------------------------------
-- Checks if a value nil.
------------------------------------------------------------------------------------------------------
---@param caller    string
---@param value     any
---@param valueName string
---@return boolean
------------------------------------------------------------------------------------------------------
DB.IsValueEmpty = function(caller, value, valueName)
	if not value or value == "" then
		local errorMessage = string.format("%s is empty {%s}.", tostring(valueName), tostring(value))
		Debug.Error.Add(Debug.Error.ERROR, caller, errorMessage)
		return true
	end

	return false
end