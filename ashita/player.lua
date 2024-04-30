Ashita.Player = T{}

-- ------------------------------------------------------------------------------------------------------
-- Get player data. If an attribute is provided then just get that attribute as long as it is handled.
-- ------------------------------------------------------------------------------------------------------
---@param attribute string the specific attribute to be returned.
---@return any
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.Get = function(attribute)
    local player = AshitaCore:GetMemoryManager():GetPlayer()
    if attribute == Ashita.Enum.Player_Attributes.ISZONING then
        return player:GetIsZoning()
    end
    return player
end

-- ------------------------------------------------------------------------------------------------------
-- Get player entity data.
-- I can't figure out where this function is defined, but it works. ¯\_(ツ)_/¯
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.Entity = function()
    return GetPlayerEntity()
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if the player is logged in so that the window doesn't show in character select.
-- I grabbed this from HXUI.
-- https://github.com/tirem/HXUI
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.Is_Logged_In = function()
    local logged_in = false
    local playerIndex = AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(0)
    if playerIndex ~= 0 then
        local entity = AshitaCore:GetMemoryManager():GetEntity()
        local flags = entity:GetRenderFlags0(playerIndex)
        if bit.band(flags, 0x200) == 0x200 and bit.band(flags, 0x4000) == 0 then
            logged_in = true
        end
    end
    return logged_in
end

-- ------------------------------------------------------------------------------------------------------
-- Get the index of the thing that the player is targetting.
-- I grabbed and adjusted this snippet from HXUI and mobdb.
-- https://github.com/tirem/HXUI
-- https://github.com/ThornyFFXI/mobdb
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.Target_Index = function()
    local memory_manager = AshitaCore:GetMemoryManager()
    local target_manager = memory_manager:GetTarget()
    return target_manager:GetTargetIndex(target_manager:GetIsSubTargetActive())
end

-- ------------------------------------------------------------------------------------------------------
-- Keeps track of if the player is zoning or not. Used to hide the window during zoning.
-- ------------------------------------------------------------------------------------------------------
---@param zoning boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.Zoning = function(zoning)
    Ashita.States.Zoning = zoning
end