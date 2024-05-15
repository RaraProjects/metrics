Res = T{}

require("resources.monster_abilities_curated")
require("resources.weapon_skills_curated")
require("resources.spells_curated")
require("resources.avatars")
require("resources.abilities")
require("resources.pets")
require("resources.colors")

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
-- Checks whether the spell is a spikes spell.
-- ------------------------------------------------------------------------------------------------------
---@param spell_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Spells.Get_Spikes = function(spell_id)
    return Res.Spells.Spikes[spell_id]
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
-- Checks whether the ability does damage.
-- ------------------------------------------------------------------------------------------------------
---@param ability_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Abilities.Get_Damaging = function(ability_id)
    return Res.Abilities.Damaging[ability_id]
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
    return Res.Colors.Elements[element_id]
end