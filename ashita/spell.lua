Ashita.Spell = T{}

-- ------------------------------------------------------------------------------------------------------
-- Get spell data.
-- https://wiki.ashitaxi.com/doku.php?id=addons:adk:iresourcemanager
-- ------------------------------------------------------------------------------------------------------
---@param id number spell ID.
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Spell.Get_By_ID = function(id)
    return AshitaCore:GetResourceManager():GetSpellById(id)
end

-- ------------------------------------------------------------------------------------------------------
-- Get the name of a spell.
-- If we already have the spell data then we don't need to get it again.
-- ------------------------------------------------------------------------------------------------------
---@param id number spell ID.
---@param data? table spell table if we already have it.
---@return string
-- ------------------------------------------------------------------------------------------------------
Ashita.Spell.Name = function(id, data)
    local spell = data
    if not spell then
        spell = Ashita.Spell.Get_By_ID(id)
    end
    if not spell then return "Error" end
    return spell.Name[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Get the MP cost of a spell.
-- If we already have the spell data then we don't need to get it again.
-- ------------------------------------------------------------------------------------------------------
---@param id number spell ID.
---@param data? table spell table if we already have it.
---@return number
-- ------------------------------------------------------------------------------------------------------
Ashita.Spell.MP = function(id, data)
    local spell = data
    if not spell then
        spell = Ashita.Spell.Get_By_ID(id)
    end
    if not spell then return 0 end
    return spell.ManaCost
end