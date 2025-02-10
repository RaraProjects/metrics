Res = {}

require("resources.weapon_skills_curated")
require("resources.spells_curated")
require("resources.abilities")
require("resources.buffs")
require("resources.pets")
require("resources.colors")
require("resources.game")
require("resources.jobs")
require("resources.items")

Res.WS.Full_List = require("resources.weapon_skills")
Res.Monster = {}
Res.Monster.Full_List = require("resources.monster_abilities")
Themes = require("resources.themes")

-- ------------------------------------------------------------------------------------------------------
-- Gets an elemental color.
-- ------------------------------------------------------------------------------------------------------
---@param element_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Colors.Get_Element = function(element_id)
    local color = Res.Colors.Elements[element_id]
    if not color then color = Res.Colors.Basic.WHITE end
    return color
end

-- ------------------------------------------------------------------------------------------------------
-- Gets a job color.
-- ------------------------------------------------------------------------------------------------------
---@param job_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Colors.Get_Job = function(job_id)
    if not job_id then return Res.Colors.Basic.WHITE end
    local color = Res.Colors.Jobs[job_id]
    if not color then color = Res.Colors.Basic.WHITE end
    return color
end

-- ------------------------------------------------------------------------------------------------------
-- Gets xp color.
-- ------------------------------------------------------------------------------------------------------
---@param xp_type integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Colors.Get_XP = function(xp_type)
    if not xp_type then return Res.Colors.XP[1] end
    local color = Res.Colors.XP[xp_type]
    if not color then color = Res.Colors.XP[1] end
    return color
end

-- ------------------------------------------------------------------------------------------------------
-- Gets job information.
-- ------------------------------------------------------------------------------------------------------
---@param job_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Jobs.Get_Job = function(job_id)
    if not job_id then return Res.Jobs.List[0] end
    return Res.Jobs.List[job_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Returns a table of dedication items indexed by name.
-- ------------------------------------------------------------------------------------------------------
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Items.Get_Dedication_Selection = function()
    return Res.Items.Dedication_Selection
end

-- ------------------------------------------------------------------------------------------------------
-- Returns a dedication ID based on a dedication item name.
-- ------------------------------------------------------------------------------------------------------
---@param item_name string
---@return integer
-- ------------------------------------------------------------------------------------------------------
Res.Items.Get_Dedication_ID_From_Name = function(item_name)
    if not item_name then return 0 end
    local id = Res.Items.Dedication_Name_To_ID[item_name]
    if not id then return 0 end
    return id
end