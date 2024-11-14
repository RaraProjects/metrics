Res = T{}

require("resources.monster_abilities_curated")
require("resources.weapon_skills_curated")
require("resources.spells_curated")
require("resources.avatars")
require("resources.abilities")
require("resources.buffs")
require("resources.pets")
require("resources.colors")
require("resources.game")
require("resources.jobs")
require("resources.items")

Res.WS.Full_List = require("resources.weapon_skills")
Res.Monster.Full_List = require("resources.monster_abilities")
Themes = require("resources.themes")

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the ability is a monster ability.
-- ------------------------------------------------------------------------------------------------------
---@param ability_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Monster.Get_Full_List = function(ability_id)
    return Res.Monster.Full_List[ability_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether a monster ability is one that does damage.
-- ------------------------------------------------------------------------------------------------------
---@param ability_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Monster.Get_Damaging_Ability = function(ability_id)
    return Res.Monster.Damaging_Abilities[ability_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether an ability is a PUP maneuver ability.
-- ------------------------------------------------------------------------------------------------------
---@param ability_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Abilities.Get_Maneuver = function(ability_id)
    return Res.Abilities.Maneuvers[ability_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether an ability is a COR Phantom Roll ability.
-- ------------------------------------------------------------------------------------------------------
---@param ability_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Abilities.Get_Roll = function(ability_id)
    return Res.Abilities.Phantom_Roll[ability_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Gets phantrom roll lucky/unlucky stats.
-- ------------------------------------------------------------------------------------------------------
---@param ability_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Abilities.Get_Roll_Lucky = function(ability_id)
    return Res.Abilities.Phantom_Roll_Lucky[ability_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether an ability is a pet command ability.
-- ------------------------------------------------------------------------------------------------------
---@param ability_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Abilities.Get_Pet_Command = function(ability_id)
    return Res.Abilities.Pet_Commands[ability_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the ability is an avatar rage blood pact.
-- ------------------------------------------------------------------------------------------------------
---@param ability_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Avatar.Get_Rage = function(ability_id)
    return Res.Avatar.Rage[ability_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the ability is an avatar ward blood pact.
-- ------------------------------------------------------------------------------------------------------
---@param ability_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Avatar.Get_Ward = function(ability_id)
    return Res.Avatar.Ward[ability_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the ability is an avatar healing blood pact.
-- ------------------------------------------------------------------------------------------------------
---@param ability_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Avatar.Get_Healing = function(ability_id)
    return Res.Avatar.Healing[ability_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the spell is an enspell.
-- ------------------------------------------------------------------------------------------------------
---@param spell_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Spells.Get_Enspell = function(spell_id)
    return Res.Spells.Enspell[spell_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks the type of enspell (element) based on the animation ID.
-- ------------------------------------------------------------------------------------------------------
---@param animation_id integer
---@return string
-- ------------------------------------------------------------------------------------------------------
Res.Spells.Get_Enspell_Type = function(animation_id)
    return Res.Spells.Enspell_Type[animation_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the spell is a healing spell.
-- ------------------------------------------------------------------------------------------------------
---@param spell_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Spells.Get_Healing = function(spell_id)
    return Res.Spells.Healing[spell_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the spell is an avatar spell.
-- ------------------------------------------------------------------------------------------------------
---@param spell_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Spells.Get_Avatar = function(spell_id)
    return Res.Spells.Avatar[spell_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the spell is a debuff removal spell.
-- ------------------------------------------------------------------------------------------------------
---@param spell_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Spells.Get_Debuff_Removal = function(spell_id)
    return Res.Spells.Debuff_Removal[spell_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the spell is a buff spell.
-- ------------------------------------------------------------------------------------------------------
---@param spell_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Spells.Get_Buff = function(spell_id)
    return Res.Spells.Buffs[spell_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the spell is a spikes spell.
-- ------------------------------------------------------------------------------------------------------
---@param spell_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Spells.Get_Spikes = function(spell_id)
    return Res.Spells.Spikes[spell_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the spell is a dispelling spell.
-- ------------------------------------------------------------------------------------------------------
---@param spell_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Spells.Get_Dispel = function(spell_id)
    return Res.Spells.Dispel[spell_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the spell is an enfeebling spell.
-- ------------------------------------------------------------------------------------------------------
---@param spell_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Spells.Get_Enfeeble = function(spell_id)
    return Res.Spells.Enfeebling[spell_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the spell is a damage over time spell.
-- ------------------------------------------------------------------------------------------------------
---@param spell_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Spells.Get_DoT = function(spell_id)
    return Res.Spells.DoT[spell_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the spell is an MP drain spell.
-- ------------------------------------------------------------------------------------------------------
---@param spell_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Spells.Get_MP_Drain = function(spell_id)
    return Res.Spells.MP_Drain[spell_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the spell is an area of effect spell.
-- ------------------------------------------------------------------------------------------------------
---@param spell_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Spells.Get_AOE = function(spell_id)
    return Res.Spells.AOE[spell_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the spell is a spell that does damage.
-- ------------------------------------------------------------------------------------------------------
---@param spell_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Spells.Get_Damaging = function(spell_id)
    return Res.Spells.Damaging[spell_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the spell is a spell that is a BRD buff song.
-- ------------------------------------------------------------------------------------------------------
---@param spell_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Spells.Get_Buff_Song = function(spell_id)
    return Res.Spells.Buff_Songs[spell_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the ability does damage.
-- ------------------------------------------------------------------------------------------------------
---@param ability_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Abilities.Get_Damaging = function(ability_id)
    return Res.Abilities.Damaging[ability_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the ability does heals a player.
-- ------------------------------------------------------------------------------------------------------
---@param ability_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Abilities.Get_Player_Healing = function(ability_id)
    return Res.Abilities.Healing[ability_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the ability heals a pet.
-- ------------------------------------------------------------------------------------------------------
---@param ability_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Abilities.Get_Pet_Healing = function(ability_id)
    return Res.Abilities.Pet_Healing[ability_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the ability recovers MP.
-- ------------------------------------------------------------------------------------------------------
---@param ability_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Abilities.Get_MP_Recovery = function(ability_id)
    return Res.Abilities.MP_Recovery[ability_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the ability is a damaging wyvern breath.
-- ------------------------------------------------------------------------------------------------------
---@param ability_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Pets.Get_Damaging_Wyvern_Breath = function(ability_id)
    return Res.Pets.Damaging_Wyvern_Breath[ability_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the ability is a healing wyvern breath.
-- ------------------------------------------------------------------------------------------------------
---@param ability_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Pets.Get_Healing_Wyvern_Breath = function(ability_id)
    return Res.Pets.Healing_Wyvern_Breath[ability_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the TP action is a weaponskill.
-- ------------------------------------------------------------------------------------------------------
---@param action_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.WS.Get_Full_List = function(action_id)
    return Res.WS.Full_List[action_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the TP action is a weaponskill that is missing from the weaponskill list.
-- ------------------------------------------------------------------------------------------------------
---@param action_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.WS.Get_Missing = function(action_id)
    return Res.WS.Missing[action_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the TP action is an ability that is handled as a weaponskill.
-- ------------------------------------------------------------------------------------------------------
---@param action_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.WS.Get_Ability = function(action_id)
    return Res.WS.Abilities[action_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the TP action is a weaponskill that deals with MP instead of HP.
-- ------------------------------------------------------------------------------------------------------
---@param action_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.WS.Get_MP_Drain = function(action_id)
    return Res.WS.MP_Drain[action_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the action is a skillchain.
-- ------------------------------------------------------------------------------------------------------
---@param action_id integer
---@return string
-- ------------------------------------------------------------------------------------------------------
Res.WS.Get_Skillchain = function(action_id)
    return Res.WS.Skillchains[action_id]
end

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
-- Gets the animation ID of an additional effect.
-- ------------------------------------------------------------------------------------------------------
---@param animation_id integer
---@return string
-- ------------------------------------------------------------------------------------------------------
Res.Game.Get_Additional_Effect_Animation = function(animation_id)
    return Res.Game.Effect_Animation[animation_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Gets buff information.
-- ------------------------------------------------------------------------------------------------------
---@param buff_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Buffs.Get_Buff = function(buff_id)
    return Res.Buffs.List[buff_id]
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
-- Gets dedication item information.
-- ------------------------------------------------------------------------------------------------------
---@param item_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Items.Get_Dedication = function(item_id)
    if not item_id then return {} end
    return Res.Items.Dedication[item_id]
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