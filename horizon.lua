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

    -- Wyvern damage breath on both Horizon and Retail.
    elseif Res.Pets.BloodPactRage[abilityID] then
        return Res.Pets.BloodPactRage[abilityID.en]

    -- Wyvern healing on both Horizon and Retail.
    elseif Res.Pets.Healing[abilityID] then
        return Res.Pets.Healing[abilityID].en

    -- Avatar healing on Horizon.
    elseif Horizon.IsActive() and Res.Pets.HealingHorizon[abilityID] then
        return Res.Pets.HealingHorizon[abilityID].en
    end

    return defaultName
end

------------------------------------------------------------------------------------------------------
-- Handle ability ID differences between Horizon and retail.
------------------------------------------------------------------------------------------------------
---@param abilityID integer
------------------------------------------------------------------------------------------------------
Horizon.RageList = function(abilityID)
    local list = Res.Pets.BloodPactRage

    -- If we can't find the ability in the regular list and Horizon mode is on then check Horizon list.
    if Horizon.IsActive() and not list[abilityID] then
        list = Res.Pets.BloodPactRageHorizon
    end

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
-- Wyvern healing is accounted for in the basic tables but not avatar healing.
------------------------------------------------------------------------------------------------------
---@param abilityID integer
------------------------------------------------------------------------------------------------------
Horizon.HealingList = function(abilityID)
    local list = Res.Pets.Healing

    -- If we can't find the ability in the regular list and Horizon mode is on then check Horizon list.
    if Horizon.IsActive() and not list[abilityID] then
        list = Res.Pets.HealingHorizon
    end

    return list[abilityID]
end
