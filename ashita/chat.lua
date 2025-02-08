Ashita.Chat = { }

Ashita.Chat.Modes = {
    [1] = { Name = "Party",       Prefix = "/p"  },
    [2] = { Name = "Linkshell 1", Prefix = "/l"  },
    [3] = { Name = "Linkshell 2", Prefix = "/l2" },
    [4] = { Name = "Say",         Prefix = "/s"  },
}

-- ------------------------------------------------------------------------------------------------------
-- Adds a message in game chat. Doesn't actually send anything to other people.
-- ------------------------------------------------------------------------------------------------------
---@param message string
-- ------------------------------------------------------------------------------------------------------
Ashita.Chat.Echo = function(message)
    print(string.format("METRICS: %s", tostring(message)))
end

-- ------------------------------------------------------------------------------------------------------
-- Adds a message in game chat. This is meant to be viewed by other people.
-- ------------------------------------------------------------------------------------------------------
---@param message string
-- ------------------------------------------------------------------------------------------------------
Ashita.Chat.AddToChat = function(type, message)
    AshitaCore:GetChatManager():QueueCommand(1, tostring(type) .. " " .. tostring(message))
end