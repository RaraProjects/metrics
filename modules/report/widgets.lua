Report.Widgets = { }

------------------------------------------------------------------------------------------------------
-- Toggles the settings showing for the battle log.
------------------------------------------------------------------------------------------------------
Report.Widgets.SettingsButton = function()
    if UI.SmallButton("Settings") then
        Config.ButtonToggle(Config.ModuleFile.REPORT)
    end
end

------------------------------------------------------------------------------------------------------
-- Creates a button to publish certain cataloged actions to the screen.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable
---@param caption?   string
------------------------------------------------------------------------------------------------------
Report.Widgets.Button = function(playerName, trackable, caption)
    caption = caption or "Publish"

    if UI.Button(caption) then
        Report.Publishing.Catalog(playerName, trackable)
    end
end

------------------------------------------------------------------------------------------------------
-- Creates a dropdown menu to chat mode options for publishing.
------------------------------------------------------------------------------------------------------
Report.Widgets.ChatMode = function()
    local list  = Ashita.Chat.Modes
    local flags = DB.Widgets.DropdownFlags

    UI.SetNextItemWidth(150)

    if UI.BeginCombo("Chat Mode", list[Report.Publishing.ChatIndex].Name or Ashita.ChatMode.PARTY, flags) then
        for index, mode in ipairs(list) do
            local isSelected = Report.Publishing.ChatIndex == index

            if UI.Selectable(mode.Name, isSelected) then
                Report.Publishing.ChatIndex = index
                Report.Publishing.ChatMode  = mode
            end

            if isSelected then
                UI.SetItemDefaultFocus()
            end
        end

        UI.EndCombo()
    end
end