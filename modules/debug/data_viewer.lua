Debug.DataView = { }

------------------------------------------------------------------------------------------------------
-- Populates the data viewer tab.
------------------------------------------------------------------------------------------------------
Debug.DataView.Populate = function()
    local stack = { }

    if UI.TreeNode("DB.Parse") then
        for index, value in pairs(DB.Parse) do
            if UI.TreeNode(tostring(index)) then
                Debug.DataView.Node(stack, value)
                UI.TreePop()
            end
        end
        UI.TreePop()
    end

    stack = { }
    if UI.TreeNode("DB.Parse_Catalog") then
        for index, value in pairs(DB.ParseCatalog) do
            if UI.TreeNode(tostring(index)) then
                Debug.DataView.Node(stack, value)
                UI.TreePop()
            end
        end
        UI.TreePop()
    end

    stack = { }
    if UI.TreeNode("DB.Pet_Parse") then
        for index, value in pairs(DB.PetParse) do
            if UI.TreeNode(tostring(index)) then
                Debug.DataView.Node(stack, value)
                UI.TreePop()
            end
        end
        UI.TreePop()
    end

    stack = { }
    if UI.TreeNode("DB.Pet_Parse_Catalog") then
        for index, value in pairs(DB.PetParseCatalog) do
            if UI.TreeNode(tostring(index)) then
                Debug.DataView.Node(stack, value)
                UI.TreePop()
            end
        end
        UI.TreePop()
    end

    if UI.TreeNode("Trackable Tracking") then
        for trackable, players in pairs(DB.Tracking.Trackables) do
            if UI.TreeNode(trackable) then
                for playerName, actions in pairs(players) do
                    if UI.TreeNode(playerName) then
                        for actionName, _ in pairs(actions) do
                            UI.Text(string.format("%s", actionName))
                        end
                        UI.TreePop()
                    end
                end
                UI.TreePop()
            end
        end
        UI.TreePop()
    end

    if UI.TreeNode("Party List") then
        for player_name, party_number in pairs(Ashita.Party.List) do
            UI.Text(tostring(player_name) .. ": " .. tostring(party_number))
        end
        UI.TreePop()
    end
end

------------------------------------------------------------------------------------------------------
-- Recursively go through the data nodes.
------------------------------------------------------------------------------------------------------
---@param stack table
---@param data table
------------------------------------------------------------------------------------------------------
Debug.DataView.Node = function(stack, data)
    for index, value in pairs(data) do
        if type(value) == "table" then
            table.insert(stack, index)
            Debug.DataView.Node(stack, value)
            table.remove(stack)
        else
            if value and value > 0 then
                if not (DB.MetricNeedsMaxValue(index) and value == DB.Enum.MAX_DAMAGE) then
                    for _, v in ipairs(stack) do
                        UI.Text(tostring(v)) UI.SameLine() UI.Text("|") UI.SameLine()
                    end
                    UI.Text(tostring(index) .. ": " .. tostring(value))
                end
            end
        end
    end
end