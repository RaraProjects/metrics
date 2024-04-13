_Debug = {}
_Debug.Enabled = false

------------------------------------------------------------------------------------------------------
-- Is debug mode enabled.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
_Debug.Is_Enabled = function()
    return _Debug.Enabled
end

------------------------------------------------------------------------------------------------------
-- Toggles debug mode.
------------------------------------------------------------------------------------------------------
_Debug.Toggle = function()
    _Debug.Enabled = not _Debug.Enabled
end

-- ------------------------------------------------------------------------------------------------------
-- Adds a message in game chat if the debug mode is enabled.
-- ------------------------------------------------------------------------------------------------------
---@param message string
-- ------------------------------------------------------------------------------------------------------
_Debug.Message = function(message)
    if _Debug.Enabled then print("METRICS DEBUG: " .. message) end
end

-- FUTURE CONSIDERATIONS
-- Unit tests
-- p.Handler.Ability = function(ability_data, metadata, actor_mob, target_name, owner_mob)
-- p.Handler.Spell_Damage = function(spell_data, metadata, player_name, target_name, burst)
-- p.Handler.Skillchain = function(metadata, player_name, target_name, sc_name)
-- p.Handler.Weaponskill = function(metadata, player_name, target_name, ws_name, owner_mob)
-- p.Handler.Ranged = function(metadata, player_name, target_name, owner_mob)
-- p.Handler.Melee = function(metadata, player_name, target_name, owner_mob)