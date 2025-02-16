Ashita.Player = { }

Ashita.Player.Buffs =
{
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
    if not player then
        return nil
    end

    if attribute then
        if attribute == Ashita.PlayerAttributes.IS_ZONING then
            return player:GetIsZoning()
        elseif attribute == Ashita.PlayerAttributes.PET_TP then
            return player:GetPetTP()
        end
    end

    return player
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the player's current job ID.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.MainJobID = function()
    local player = Ashita.Player.Get()
    if not player then
        return 0
    end

    return player:GetMainJob()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns string in the form "WHM75/BLM37"
-- ------------------------------------------------------------------------------------------------------
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.JobData = function()
    local defaultColor  = Res.Colors.Basic.WHITE
    local ANON_JOB   = "NON"
    local ANON_LEVEL = 0

    local player = AshitaCore:GetMemoryManager():GetPlayer()
    if not player then
        return
        {
            main = ANON_JOB, main_level = ANON_LEVEL, main_color = defaultColor,
            sub  = ANON_JOB, sub_level  = ANON_LEVEL, sub_color  = defaultColor,
        }
    end

    -- Helper function to get job data.
    local function getJobData(jobId)
        local job = Res.Jobs.GetJob(jobId)
        if not job then
            job = Res.Jobs.List[0]
        end
        local jobColor = Res.Colors.GetJob(job.id)
        local jobShort = job.ens
        return jobShort, player:GetJobLevel(jobId), jobColor
    end

    local mainShort, mainLevel, mainColor = getJobData(player:GetMainJob())
    local subShort,  subLevel,  subColor  = getJobData(player:GetSubJob())

    return
    {
        main = mainShort, main_level = mainLevel, main_color = mainColor,
        sub = subShort,   sub_level  = subLevel,  sub_color  = subColor
    }
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
Ashita.Player.IsLoggedIn = function()
    local playerIndex = AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(0)

    if playerIndex == 0 then
        return false
    end

    local entity = AshitaCore:GetMemoryManager():GetEntity()
    local flags  = entity:GetRenderFlags0(playerIndex)
    return bit.band(flags, 0x200) == 0x200 and bit.band(flags, 0x4000) == 0
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if the player has a specific buff or not.
-- ------------------------------------------------------------------------------------------------------
---@param buffId integer
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.HasBuff = function(buffId)
    local player = AshitaCore:GetMemoryManager():GetPlayer()
    if not player then
        return false
    end

    local buffs = player:GetBuffs()

    for _, buff in pairs(buffs) do
        if buff == buffId then
            return true
        end
    end

    return false
end

-- ------------------------------------------------------------------------------------------------------
-- Returns whether limit mode is enabled or not.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.IsLimitModeEnabled = function()
    local player = Ashita.Player.Get()
    if not player then
        return false
    end

    return player:GetIsLimitModeEnabled()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the player's current level's total XP to next level.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.LevelMaxXP = function()
    local player = Ashita.Player.Get()
    if not player then
        return 99999
    end

    return player:GetExpNeeded()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the player's current XP through the level.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.CurrentXP = function()
    local player = Ashita.Player.Get()
    if not player then
        return 99999
    end

    return player:GetExpCurrent()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the player's TNL.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.ExpTNL = function()
    local player = Ashita.Player.Get()
    if not player then
        return 99999
    end

    return player:GetExpNeeded() - player:GetExpCurrent()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the player's current limit points through the level.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.CurrentLimit = function()
    local player = Ashita.Player.Get()
    if not player then
        return 99999
    end

    return player:GetLimitPoints()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the player's TNLP.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.ExpTNM = function()
    local player = Ashita.Player.Get()
    if not player then
        return 99999
    end

    return 10000 - player:GetLimitPoints()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the player's current limit points through the level.
-- ------------------------------------------------------------------------------------------------------
---@param job_id integer
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.CurrentCapacityPoints = function(job_id)
    local player = Ashita.Player.Get()
    if not player or not job_id then
        return 99999
    end

    return player:GetCapacityPoints(job_id)
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the player's current exemplar points through the level.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.CurrentExemplarPoints = function()
    local player = Ashita.Player.Get()
    if not player then
        return 99999
    end

    return player:GetMasteryExp()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the player's current max EP needed to go to the next level..
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.ExemplarLevelMax = function()
    local player = Ashita.Player.Get()
    if not player then
        return 99999
    end

    return player:GetMasteryExpNeeded()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the player's exemplar points needed to get the next master level.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.TNML = function()
    local player = Ashita.Player.Get()
    if not player then
        return 99999
    end

    return player:GetMasteryExp() - player:GetMasteryExpNeeded()
end

-- ------------------------------------------------------------------------------------------------------
-- Get the index of the thing that the player is targetting.
-- I grabbed and adjusted this snippet from HXUI and mobdb.
-- https://github.com/tirem/HXUI
-- https://github.com/ThornyFFXI/mobdb
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.TargetIndex = function()
    local memoryManager = AshitaCore:GetMemoryManager()
    local targetManager = memoryManager:GetTarget()
    return targetManager:GetTargetIndex(targetManager:GetIsSubTargetActive())
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
Ashita.Player.IsZoning = function()
    return Ashita.States.Zoning
end

-- ------------------------------------------------------------------------------------------------------
-- Get the player's mob structure.
-- ------------------------------------------------------------------------------------------------------
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Player.MyMob = function()
    return Ashita.Mob.GetMobByTarget(Ashita.TargetString.ME)
end