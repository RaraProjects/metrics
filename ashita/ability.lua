Ashita.Ability = T{}

-- ------------------------------------------------------------------------------------------------------
-- Get ability data.
-- https://wiki.ashitaxi.com/doku.php?id=addons:adk:iresourcemanager
-- Type 1  = Special Ability (2-hour), Third Eye,
-- Type 6  = SMN using BloodPactRage
-- Type 10 = BloodPactWard
-- Type 18 = BloodPactRage
-- Offsets
-- WS have zero offset.
-- Abilities have 512 offset.
-- ------------------------------------------------------------------------------------------------------
---@param id number
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Ability.Get_By_ID = function(id)
    return AshitaCore:GetResourceManager():GetAbilityById(id)
end

-- ------------------------------------------------------------------------------------------------------
-- Get the name of an ability.
-- If we already have the ability data then we don't need to get it again.
-- ------------------------------------------------------------------------------------------------------
---@param id number ability ID.
---@param data? table ability table if we already have it. 
---@return string
-- ------------------------------------------------------------------------------------------------------
Ashita.Ability.Name = function(id, data)
    local ability = data
    if not ability then
        ability = Ashita.Ability.Get_By_ID(id)
    end
    if not ability then return "Error" end
    return ability.Name[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Get the current recast time for an ability by the abilities ID.
-- ------------------------------------------------------------------------------------------------------
---@param id number ability ID.
---@return number
-- ------------------------------------------------------------------------------------------------------
Ashita.Ability.Recast_ID = function(id)
    local ability_id
    local recast = 0
    local found = false
    for i = 0, 31 do
        if not found then
            ability_id = AshitaCore:GetMemoryManager():GetRecast():GetAbilityTimerId(i)
            if ability_id == id then
                recast = math.floor(AshitaCore:GetMemoryManager():GetRecast():GetAbilityTimer(i) / 60)
                found = true
            end
        end
    end
    return recast
end