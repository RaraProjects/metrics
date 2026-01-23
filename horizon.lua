Horizon = { }

local horizonMap =
{
    Rage =
    {
        -- Carbuncle
        [513] = 907,    -- Poison Nails
        [516] = 910,    -- Meteorite
        [518] = 912,    -- Searing Light

        -- Fenrir
        [528] = 831,    -- Moonlit Charge
        [529] = 832,    -- Crescent Fang
        [534] = 836,    -- Eclipse Bite
        [536] = 839,    -- Howling Moon (main)
                        -- [537] = Lunar Bay does not exist on Horizon.
                        -- [539] = Impact does not exist on Horizon.

        -- Ifrit
        [544] = 840,    -- Punch
        [545] = 841,    -- Fire II
        [546] = 842,    -- Burning Strike
        [547] = 843,    -- Double Punch
        [549] = 845,    -- Fire IV
        [550] = 846,    -- Flaming Crush
        [551] = 847,    -- Meteor Strike
        [552] = 848,    -- Inferno

        -- Titan
        [560] = 849,    -- Rock Throw
        [561] = 850,    -- Stone II
        [562] = 851,    -- Rock Buster
        [563] = 852,    -- Megalith Throw
        [565] = 854,    -- Stone IV
        [566] = 855,    -- Mountain Buster
        [567] = 856,    -- Geocrush
        [568] = 857,    -- Earthen Fury

        -- Leviathan
        [576] = 858,    -- Barracuda Dive
        [577] = 859,    -- Water II
        [578] = 860,    -- Tail Whip
        [581] = 863,    -- Water IV
        [582] = 864,    -- Spinning Dive
        [583] = 865,    -- Grand Fall
        [584] = 866,    -- Tidal Wave

        -- Garuda
        [592] = 867,    -- Claw
        [593] = 868,    -- Aero II
        [597] = 872,    -- Aero IV
        [598] = 873,    -- Predator Claws
        [599] = 874,    -- Wind Blade
        [600] = 875,    -- Aerial Blast

        -- Shiva
        [608] = 876,    -- Axe Kick
        [609] = 877,    -- Blizzard II
        [612] = 880,    -- Double Slap
        [613] = 881,    -- Blizzard IV
        [614] = 882,    -- Rush
        [615] = 883,    -- Heavenly Strike
        [616] = 884,    -- Diamond Dust

        -- Ramuh
        [624] = 885,    -- Shock Strike
        [625] = 886,    -- Thunder II
        [627] = 888,    -- Thunderspark
        [629] = 890,    -- Thunder IV
        [630] = 891,    -- Chaotic Strike
        [631] = 892,    -- Thunderstorm
        [632] = 893,    -- Judgment Bolt

        -- Diabolos
        [656] = 1903,   -- Camisado
        [657] = 1904,   -- Somnolence
        [662] = 1910,   -- Nether Blast
        [663] = 1909,   -- Cacodemonia
        [664] = 1911,   -- Ruinous Omen
        [665] = 3554,   -- Night Terror
    },

    Ward =
    {
        -- Fenrir
        [530] = 833,    -- Lunar Cry
        [531] = 835,    -- Lunar Roar
        [532] = 834,    -- Ecliptic Growl
        [533] = 837,    -- Ecliptic Howl

        -- Ifrit
        [548] = 844, -- Crimson Howl

        -- Titan
        [564] = 853, -- Earthen Ward

        -- Leviathan
        [579] = 861, -- Spring Water (Healing → Ward)
        [580] = 862, -- Slowga

        -- Garuda
        [595] = 870, -- Hastega
        [596] = 871, -- Aerial Armor

        -- Shiva
        [610] = 878, -- Frost Armor
        [611] = 879, -- Sleepga

        -- Ramuh
        [626] = 887, -- Rolling Thunder
        [628] = 889, -- Lightning Armor

        -- Carbuncle
        [514] = 908, -- Shining Ruby
        [515] = 909, -- Glittering Ruby

        -- Diabolos
        [660] = 1905, -- Noctoshield
        [659] = 1906, -- Ultimate Terror
        [661] = 1907, -- Dream Shroud
        [658] = 1908, -- Nightmare
    },

    Healing =
    {
        -- Garuda
        [594] = 869, -- Whispering Wind

        -- Carbuncle
        [512] = 906, -- Healing Ruby
        [517] = 911, -- Healing Ruby II
    }
}

------------------------------------------------------------------------------------------------------
-- Returns whether Horizon mode is enabled or not.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
local isActive = function()
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
    elseif isActive() and Res.Pets.HealingHorizon[abilityID] then
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
    if isActive() then
        local horizonID = horizonMap.Rage[abilityID]

        return horizonID and Res.Pets.BloodPactRageHorizon[horizonID]
    end

    return Res.Pets.BloodPactRage[abilityID]
end

------------------------------------------------------------------------------------------------------
-- Handle ability ID differences between Horizon and retail.
------------------------------------------------------------------------------------------------------
---@param abilityID integer
------------------------------------------------------------------------------------------------------
Horizon.WardList = function(abilityID)
    if isActive() then
        local horizonID = horizonMap.Ward[abilityID]

        return horizonID and Res.Pets.BloodPactWardHorizon[horizonID]
    end

    return Res.Pets.BloodPactWard[abilityID]
end

------------------------------------------------------------------------------------------------------
-- Handle ability ID differences between Horizon and retail.
-- Wyvern healing is accounted for in the basic tables but not avatar healing.
------------------------------------------------------------------------------------------------------
---@param abilityID integer
------------------------------------------------------------------------------------------------------
Horizon.HealingList = function(abilityID)
    if isActive() then
        local horizonID = horizonMap.Healing[abilityID]

        return horizonID and Res.Pets.HealingHorizon[horizonID]
    end

    return Res.Pets.Healing[abilityID]
end
