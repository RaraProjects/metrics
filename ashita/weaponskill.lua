Ashita.WS = T{}

-- ------------------------------------------------------------------------------------------------------
-- Gets properties for a WS.
-- The resource file used to do this is from Windower.
-- Some things are treated as weaponskills, but aren't actually. Those can be missing from the WS file.
-- For those I keep track of them in Missing_WS define in the lists.lua
-- ------------------------------------------------------------------------------------------------------
---@param id number weaponskill ID.
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.WS.Get_By_ID = function(id)
    local ws = Res.WS.Get_Full_List(id)
    if not ws then ws = Res.WS.Get_Missing(id) end
    return ws
end