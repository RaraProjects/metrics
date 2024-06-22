Report.Widgets = T{}

------------------------------------------------------------------------------------------------------
-- Toggles the settings showing for the battle log.
------------------------------------------------------------------------------------------------------
Report.Widgets.Settings_Button = function()
    if UI.SmallButton("Settings") then
        Report.Config.Show_Settings = not Report.Config.Show_Settings
    end
    if Report.Config.Show_Settings then
        Report.Config.Display()
    end
end

------------------------------------------------------------------------------------------------------
-- Creates a button to publish certain cataloged actions to the screen.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param focus_type string
---@param caption? string
------------------------------------------------------------------------------------------------------
Report.Widgets.Button = function(player_name, focus_type, caption)
    if not caption then caption = "Publish" end
    if UI.Button(caption) then
        Report.Publishing.Catalog(player_name, focus_type)
    end
end

------------------------------------------------------------------------------------------------------
-- Creates a dropdown menu to chat mode options for publishing.
------------------------------------------------------------------------------------------------------
Report.Widgets.Chat_Mode = function()
    local list = Ashita.Chat.Modes
    local flags = DB.Widgets.Dropdown.Flags
    if list[1] then
        UI.SetNextItemWidth(Ashita.Chat.Selection.Width)
        if UI.BeginCombo(Ashita.Chat.Selection.Title, list[Report.Publishing.Chat_Index].Name, flags) then
            for n = 1, #list, 1 do
                local is_selected = Ashita.Chat.Selection.Index == n
                if UI.Selectable(list[n].Name, is_selected) then
                    Report.Publishing.Chat_Index = n
                    Report.Publishing.Chat_Mode = list[n]
                end
                if is_selected then
                    UI.SetItemDefaultFocus()
                end
            end
            UI.EndCombo()
        end
    else
        if UI.BeginCombo(Ashita.Chat.Selection.Title, Ashita.Enum.Chat.PARTY, flags) then
            UI.EndCombo()
        end
    end
end