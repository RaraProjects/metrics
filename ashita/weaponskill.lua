Ashita.WS = { }

-- ------------------------------------------------------------------------------------------------------
-- Gets properties for a WS.
-- The resource file used to do this is from Windower.
-- Some things are treated as weaponskills, but aren't actually. Those can be missing from the WS file.
-- For those I keep track of them in Missing_WS define in the lists.lua
-- ------------------------------------------------------------------------------------------------------
---@param id number weaponskill ID.
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.WS.GetByID = function(id)
    return Res.WS.Full_List[id] or Res.WS.Missing[id] or { }
end