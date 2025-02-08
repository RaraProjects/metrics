Ashita.Ability = { }

-- ------------------------------------------------------------------------------------------------------
-- Get ability data.
-- https://wiki.ashitaxi.com/doku.php?id=addons:adk:iresourcemanager
-- Types
-- * 1  = Most self-targetting abilities including 2-hours.
-- * 6  = SMN using BloodPactRage
-- * 10 = BloodPactWard
-- * 12 = Curing Waltz
-- * 13 = Steps
-- * 14 = Animated Flourish
-- * 16 = Spectral Jig
-- * 17 = Building Flourish
-- * 18 = BloodPactRage
-- * 21 = Rune Enchantment
-- * 23 = Swipe, Lunge
-- Offsets
-- * WS have zero offset.
-- * Abilities have 512 offset.
-- ------------------------------------------------------------------------------------------------------
---@param id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Ability.GetByID = function(id)
    if not id or math.type(id) ~= "integer" then
        Debug.Error.Add(Debug.Error.ERROR, "Ashita.Abiliity.GetByID", "Parameter \"id\" was " .. tostring(id))
    end

    return AshitaCore:GetResourceManager():GetAbilityById(id)
end

-- ------------------------------------------------------------------------------------------------------
-- Get the name of an ability. If we already have the ability data then we don't need to get it again.
-- ------------------------------------------------------------------------------------------------------
---@param id    integer ability ID
---@param data? table   ability table if we already have it.
---@return string
-- ------------------------------------------------------------------------------------------------------
Ashita.Ability.Name = function(id, data)
    if not id or math.type(id) ~= "integer" then
        Debug.Error.Add(Debug.Error.ERROR, "Ashita.Ability.Name", "Parameter \"id\" was " .. tostring(id))
    end

    local ability = data or Ashita.Ability.GetByID(id)
    if not ability or not ability.Name or not ability.Name[1] then
        return "Error"
    end

    return ability.Name[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Get the current recast time for an ability by the abilities ID.
-- ------------------------------------------------------------------------------------------------------
---@param id number ability ID
---@return number
-- ------------------------------------------------------------------------------------------------------
Ashita.Ability.RecastID = function(id)
    if not id or math.type(id) ~= "integer" then
        Debug.Error.Add(Debug.Error.ERROR, "Ashita.Ability.RecastID", "Parameter \"id\" was " .. tostring(id))
    end

    local memoryManager = AshitaCore:GetMemoryManager()

    for i = 0, 31 do
        local abilityId = memoryManager:GetRecast():GetAbilityTimerId(i)
        if abilityId == id then
            return math.floor(memoryManager:GetRecast():GetAbilityTimer(i) / 60)
        end
    end

    return 0
end