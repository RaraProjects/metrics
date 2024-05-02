DB = T{}

-- Primary Database
DB.Parse = T{}                          -- [index][trackable][metric]
                                        -- [index][trackable][m.Enum.Node.CATALOG][action_name]

-- Secondary Tracking Tables
DB.Tracking = T{}
DB.Tracking.Trackable = T{}             -- [trackable][player_name]
DB.Tracking.Pet_Trackable = T{}         -- [trackable][player_name][pet_name]
DB.Tracking.Initialized_Players = T{}   -- [player_name]
DB.Tracking.Initialized_Pets = T{}      -- [player_name][pet_name]
DB.Tracking.Initialized_Mobs = T{}      -- [mob_name]
DB.Tracking.Running_Accuracy = T{}
DB.Tracking.Defeated_Mobs = T{}

DB.Settings = T{}
DB.Settings.Accuracy_Warning = 0.80

-- These are used for user saved settings.
DB.Defaults = T{
	Running_Accuracy_Limit = 25
}

require("database._enum")
require("database.accuracy")
require("database.catalog")
require("database.data")
require("database.lists")
require("database.pet_catalog")
require("database.pet_data")

------------------------------------------------------------------------------------------------------
-- Resets the parsing data and clears the battle log.
------------------------------------------------------------------------------------------------------
DB.Initialize = function()
	DB.Parse = T{}

	DB.Tracking.Trackable = T{}
	DB.Tracking.Pet_Trackable = T{}
	DB.Tracking.Initialized_Players = T{}
    DB.Tracking.Initialized_Pets = T{}
    DB.Tracking.Initialized_Mobs = T{[Window.Dropdown.Enum.NONE] = true}
    DB.Tracking.Running_Accuracy = T{}
    DB.Tracking.Defeated_Mobs = T{}

	DB.Sorted.Players = T{[1] = Window.Dropdown.Enum.NONE}
	DB.Sorted.Mobs = T{[1] = Window.Dropdown.Enum.NONE}
	DB.Sorted.Total_Damage = T{}
	DB.Sorted.Catalog_Damage = T{}

	DB.Healing_Max = {}
	Window.Dropdown.Player.Index = 1
	Window.Dropdown.Mob.Index = 1
	for spell, threshold in pairs(DB.Enum.HEALING) do
		DB.Healing_Max[spell] = threshold
	end
	Blog.Reset_Log()
	Timers.Start("Metrics")
end

------------------------------------------------------------------------------------------------------
-- Calculates the total damage from everyone currently on the Team display.
------------------------------------------------------------------------------------------------------
---@return number
------------------------------------------------------------------------------------------------------
DB.Team_Damage = function()
	local total = 0
	DB.Lists.Sort.Total_Damage()
	for rank, data in ipairs(DB.Sorted.Total_Damage) do
		if rank <= Metrics.Team.Settings.Rank_Cutoff then
			local player_name = data[1]
			if Metrics.Team.Settings.Include_SC_Damage then
				total = total + DB.Data.Get(player_name, DB.Enum.Trackable.TOTAL, DB.Enum.Metric.TOTAL)
			else
				total = total + DB.Data.Get(player_name, DB.Enum.Trackable.TOTAL_NO_SC, DB.Enum.Metric.TOTAL)
			end
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