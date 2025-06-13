Horizon = { }

------------------------------------------------------------------------------------------------------
-- Returns whether Horizon mode is enabled or not.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Horizon.IsActive = function()
    if not Parse or not Parse.Settings then
        return false
    end

    return Parse.Settings.Is_Horizon
end

------------------------------------------------------------------------------------------------------
-- Get rage names.
------------------------------------------------------------------------------------------------------
---@param abilityID   integer
---@param defaultName string
------------------------------------------------------------------------------------------------------
Horizon.GetAbilityName = function(abilityID, defaultName)
    if Horizon.RageList(abilityID) then
        return Horizon.RageList(abilityID).en

    elseif Horizon.WardList(abilityID) then
        return Horizon.WardList(abilityID).en

    elseif Horizon.HealingList(abilityID) then
        return Horizon.HealingList(abilityID).en
    end

    return defaultName
end

------------------------------------------------------------------------------------------------------
-- Handle ability ID differences between Horizon and retail.
------------------------------------------------------------------------------------------------------
---@param abilityID integer
------------------------------------------------------------------------------------------------------
Horizon.RageList = function(abilityID)
    local list = Horizon.IsActive() and Res.Pets.BloodPactRageHorizon or Res.Pets.BloodPactRage

    return list[abilityID]
end

------------------------------------------------------------------------------------------------------
-- Handle ability ID differences between Horizon and retail.
------------------------------------------------------------------------------------------------------
---@param abilityID integer
------------------------------------------------------------------------------------------------------
Horizon.WardList = function(abilityID)
    local list = Horizon.IsActive() and Res.Pets.BloodPactWardHorizon or Res.Pets.BloodPactWard

    return list[abilityID]
end

------------------------------------------------------------------------------------------------------
-- Handle ability ID differences between Horizon and retail.
------------------------------------------------------------------------------------------------------
---@param abilityID integer
------------------------------------------------------------------------------------------------------
Horizon.HealingList = function(abilityID)
    local list = Horizon.IsActive() and Res.Pets.HealingHorizon or Res.Pets.Healing

    return list[abilityID]
end