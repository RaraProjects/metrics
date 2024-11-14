Ashita.Player = T{}

Ashita.Player.Buffs = T{
    DEDICATION = 249,
}

-- ------------------------------------------------------------------------------------------------------
-- Get player data. If an attribute is provided then just get that attribute as long as it is handled.
-- ------------------------------------------------------------------------------------------------------
---@param attribute? string the specific attribute to be returned.
---@return any
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.Get = function(attribute)
    local player = AshitaCore:GetMemoryManager():GetPlayer()
    if not player then return nil end
    if attribute == Ashita.Enum.Player_Attributes.ISZONING then
        return player:GetIsZoning()
    elseif attribute == Ashita.Enum.Player_Attributes.PET_TP then
        return player:GetPetTP()
    end
    return player
end

-- ------------------------------------------------------------------------------------------------------
-- Returns string in the form "WHM75/BLM37"
-- ------------------------------------------------------------------------------------------------------
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.Job_Data = function()
    local default_color = Res.Colors.Basic.WHITE
    local player = AshitaCore:GetMemoryManager():GetPlayer()
    if not player then
        return {main = "NON", main_level = 0, main_color = default_color, sub = "NON", sub_level = 0, sub_color = default_color}
    end
    local main_color = default_color
    local sub_color = default_color
    local main = Res.Jobs.Get_Job(player:GetMainJob())
    if not main then main = Res.Jobs.List[0] end
    main_color = Res.Colors.Get_Job(main.id)
    local main_short = main.ens
    local main_lvl = player:GetMainJobLevel()
    local sub = Res.Jobs.Get_Job(player:GetSubJob())
    if not sub then sub = Res.Jobs.List[0] end
    sub_color = Res.Colors.Get_Job(sub.id)
    local sub_short = sub.ens
    local sub_lvl = player:GetSubJobLevel()
    return {main = main_short, main_level = main_lvl, main_color = main_color, sub = sub_short, sub_level = sub_lvl, sub_color = sub_color}
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
-- Checks if the player has a specific buff or not.
-- ------------------------------------------------------------------------------------------------------
---@param buff_id integer
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.Has_Buff = function(buff_id)
    local player = AshitaCore:GetMemoryManager():GetPlayer()
    if not player then return false end
    local buffs = player:GetBuffs()
    for _, buff in pairs(buffs) do
        if buff == buff_id then return true end
    end
    return false
end

-- ------------------------------------------------------------------------------------------------------
-- Returns whether limit mode is enabled or not.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.Is_Limit_Mode_Enabled = function()
    local player = Ashita.Player.Get()
    if not player then return false end
    return player:GetIsLimitModeEnabled()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the player's TNL.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.Exp_TNL = function()
    local player = Ashita.Player.Get()
    if not player then return 99999 end
    return player:GetExpNeeded() - player:GetExpCurrent()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the player's current level's total XP to next level.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.Level_XP = function()
    local player = Ashita.Player.Get()
    if not player then return 99999 end
    return player:GetExpNeeded()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the player's current XP through the level.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.Current_XP = function()
    local player = Ashita.Player.Get()
    if not player then return 99999 end
    return player:GetExpCurrent()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the player's TNLP.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.Exp_TNM = function()
    local player = Ashita.Player.Get()
    if not player then return 99999 end
    return 10000 - player:GetLimitPoints()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the player's current limit points through the level.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.Limit_XP = function()
    local player = Ashita.Player.Get()
    if not player then return 99999 end
    return player:GetLimitPoints()
end

-- ------------------------------------------------------------------------------------------------------
-- Get the index of the thing that the player is targetting.
-- I grabbed and adjusted this snippet from HXUI and mobdb.
-- https://github.com/tirem/HXUI
-- https://github.com/ThornyFFXI/mobdb
-- ------------------------------------------------------------------------------------------------------
---@return integer
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

-- ------------------------------------------------------------------------------------------------------
-- Returns whether the player is zoning or not.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.Is_Zoning = function()
    return Ashita.States.Zoning
end

-- ------------------------------------------------------------------------------------------------------
-- Get the player's mob structure.
-- ------------------------------------------------------------------------------------------------------
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.My_Mob = function()
    return Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
end