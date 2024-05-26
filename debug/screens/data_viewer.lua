_Debug.Data_View = {}

------------------------------------------------------------------------------------------------------
-- Populates the data viewer tab.
------------------------------------------------------------------------------------------------------
_Debug.Data_View.Populate = function()
    if UI.TreeNode("Model.Data") then
        for index, value in pairs(DB.Parse) do
            if UI.TreeNode(tostring(index)) then
                _Debug.Data_View.Node(value)
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
_Debug.Data_View.Node = function(data)
    for index, value in pairs(data) do
        if type(value) == "table" then
            if UI.TreeNode(tostring(index)) then
                _Debug.Data_View.Node(value)
                UI.TreePop()
            end
        else
            if value and value > 0 then
                UI.Text(tostring(index) .. ": " .. tostring(value))
            end
        end
    end
end