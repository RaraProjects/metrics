Res = { }

require("resources.weapon_skills_curated")
require("resources.spells_curated")
require("resources.abilities")
require("resources.buffs")
require("resources.pets")
require("resources.colors")
require("resources.game")
require("resources.jobs")
require("resources.items")

Res.WS.FullList      = require("resources.weapon_skills")
Res.Monster          = { }
Res.Monster.FullList = require("resources.monster_abilities")
Themes = require("resources.themes")

-- ------------------------------------------------------------------------------------------------------
-- Gets an elemental color.
-- ------------------------------------------------------------------------------------------------------
---@param elementId integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Colors.GetElement = function(elementId)
    return Res.Colors.Elements[elementId] or Res.Colors.Basic.WHITE
end

-- ------------------------------------------------------------------------------------------------------
-- Gets a job color.
-- ------------------------------------------------------------------------------------------------------
---@param jobId integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Colors.GetJob = function(jobId)
    return jobId and Res.Colors.Jobs[jobId] or Res.Colors.Basic.WHITE
end

-- ------------------------------------------------------------------------------------------------------
-- Gets xp color.
-- ------------------------------------------------------------------------------------------------------
---@param xpType XP.Type
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Colors.GetXP = function(xpType)
    return Res.Colors.XP[xpType] or Res.Colors.XP[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Gets job information.
-- ------------------------------------------------------------------------------------------------------
---@param jobId integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Jobs.GetJob = function(jobId)
    return jobId and Res.Jobs.List[jobId] or Res.Jobs.List[0]
end