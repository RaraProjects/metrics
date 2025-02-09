Ashita.Spell = { }

-- ------------------------------------------------------------------------------------------------------
-- Get spell data.
-- https://wiki.ashitaxi.com/doku.php?id=addons:adk:iresourcemanager
-- ------------------------------------------------------------------------------------------------------
---@param id integer spell ID.
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Spell.GetByID = function(id)
    if not id or math.type(id) ~= "integer" then
        Debug.Error.Add(Debug.Error.ERROR, "Ashita.Spell.GetByID", string.format("Parameter \"id\" was {%s}.", tostring(id)))
    end

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
    if not id or math.type(id) ~= "integer" then
        Debug.Error.Add(Debug.Error.ERROR, "Ashita.Spell.Name", string.format("Parameter \"id\" was {%s}.", tostring(id)))
    end

    local spell = data or Ashita.Spell.GetByID(id)

    if not spell or not spell.Name or not spell.Name[1] then
        return "Error"
    end

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
    if not id or math.type(id) ~= "integer" then
        Debug.Error.Add(Debug.Error.ERROR, "Ashita.Spell.MP", string.format("Parameter \"id\" was {%s}.", tostring(id)))
    end

    local spell = data or Ashita.Spell.GetByID(id)

    if not spell or not spell.ManaCost then
        return 0
    end

    return spell.ManaCost
end

-- ------------------------------------------------------------------------------------------------------
-- Get the skill a spell.
-- If we already have the spell data then we don't need to get it again.
-- ------------------------------------------------------------------------------------------------------
---@param id number spell ID.
---@param data? table spell table if we already have it.
---@return number
-- ------------------------------------------------------------------------------------------------------
Ashita.Spell.Skill = function(id, data)
    if not id or math.type(id) ~= "integer" then
        Debug.Error.Add(Debug.Error.ERROR, "Ashita.Spell.Skill", string.format("Parameter \"id\" was {%s}.", tostring(id)))
    end

    local spell = data or Ashita.Spell.GetByID(id)

    if not spell or not spell.Skill then
        return 0
    end

    return spell.Skill
end