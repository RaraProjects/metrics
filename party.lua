local pt = {}

pt.Data = {}
pt.Debug = {}
pt.Members = {}

-- ------------------------------------------------------------------------------------------------------
-- Checks if a mob ID is in the party.
-- ------------------------------------------------------------------------------------------------------
pt.Data.Is_Party_Member = function (index)
    if not index then return false end
    A.Chat.Message("Checking if " .. index .. " is in the party.")
    return pt.Members[index] == "Party"
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if a mob ID is in the alliance.
-- ------------------------------------------------------------------------------------------------------
pt.Data.Is_Alliance_Member = function (index)
    if not index then return false end
    return pt.Members[index] == "Alliance"
end

-- ------------------------------------------------------------------------------------------------------
-- Display party members in the chat.
-- ------------------------------------------------------------------------------------------------------
pt.Debug.Display = function()
    for id, type in pairs(pt.Members) do
        A.Chat.Message("Party: " .. id .. " " .. type)
    end
end

return pt