Ashita.Chat = T{}

-- ------------------------------------------------------------------------------------------------------
-- Adds a message in game chat. Doesn't actually send anything to other people.
-- ------------------------------------------------------------------------------------------------------
---@param message string
-- ------------------------------------------------------------------------------------------------------
Ashita.Chat.Message = function(message)
    print("METRICS: " .. message)
end

-- ------------------------------------------------------------------------------------------------------
-- Adds a message in game chat. This is meant to be viewed by other people.
-- ------------------------------------------------------------------------------------------------------
---@param message string
-- ------------------------------------------------------------------------------------------------------
Ashita.Chat.Add_To_Chat = function(type, message)
    AshitaCore:GetChatManager():QueueCommand(1, tostring(type) .. " " .. tostring(message))
end