DB.Widgets = { }

DB.Widgets.DropdownWidth = 150
DB.Widgets.DropdownFlags = ImGuiComboFlags_None

DB.Widgets.DropdownPlayerFilterHeader = "Player"
DB.Widgets.DropdownPlayerFilterFocus  = DB.Enum.NONE
DB.Widgets.DropdownPlayerFilterIndex  = 1

DB.Widgets.DropdownMobFilterHeader = "Mob Filter"
DB.Widgets.DropdownMobFilterFocus  = DB.Enum.ALL_MOBS
DB.Widgets.DropdownMobFilterIndex  = 1

------------------------------------------------------------------------------------------------------
-- Utility function for accessing the name of the currently focused mob.
------------------------------------------------------------------------------------------------------
DB.Widgets.GetMobFocus = function()
    return DB.Widgets.DropdownMobFilterFocus
end

------------------------------------------------------------------------------------------------------
-- Utility function for accessing the name of the currently focused entity.
------------------------------------------------------------------------------------------------------
DB.Widgets.GetPlayerFocus = function()
    return DB.Widgets.DropdownPlayerFilterFocus
end

------------------------------------------------------------------------------------------------------
-- Switches to a player in the player filter based on partial matching.
------------------------------------------------------------------------------------------------------
---@param playerString string
------------------------------------------------------------------------------------------------------
DB.Widgets.PlayerSwitch = function(playerString)
    local list = DB.Lists.Players
    local searchKey = string.lower(playerString) or DB.Enum.DEBUG

    for index, playerName in pairs(list) do
        if string.match(string.lower(playerName), searchKey) then
            DB.Widgets.DropdownPlayerFilterIndex = index
            DB.Widgets.DropdownPlayerFilterFocus = playerName
            break
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Creates a dropdown menu to show only damage done by a certain entity.
------------------------------------------------------------------------------------------------------
---@param width integer
------------------------------------------------------------------------------------------------------
DB.Widgets.DropdownDPS = function(width)
    local list  = DB.DPS.Modes
    local flags = DB.Widgets.DropdownFlags

    UI.SetNextItemWidth(width)

    if UI.BeginCombo(DB.DPS.ModeHeader, list[DB.DPS.ModeIndex] or DB.DPS.Modes[1], flags) then
        for index, mode in ipairs(list) do
            local isSelected = DB.DPS.ModeIndex == index

            if UI.Selectable(mode, isSelected) then
                DB.DPS.ModeIndex = index
                DB.DPS.Mode = mode
            end

            if isSelected then
                UI.SetItemDefaultFocus()
            end
        end

        UI.EndCombo()
    end

    UI.SameLine() Window_Manager.Widgets.HelpMarker
    (
        "Average DPS is your total damage divided by the parse duration timer. The timer only runs while actions " ..
        "are taking place by your affiliates near you so idle time by the party won't hurt your DPS by much. " ..
        "Average DPS is smoother and averaged over a longer period. It won't drop over time as long as no one is taking a battle action. \n \n" ..
        "Recent DPS is spikey and closer to the present. Actions you do right now matter more. " ..
        "For example, if you were to stop taking actions for {X} amount of seconds your DPS would drop to zero. " ..
        "Use Recent DPS mode if you're more interested in what's happening right now."
    )
end

------------------------------------------------------------------------------------------------------
-- Creates a dropdown menu to show only damage done to a certain mob.
------------------------------------------------------------------------------------------------------
DB.Widgets.DropdownMobFilter = function()
    local list  = DB.Lists.Mobs
    local flags = DB.Widgets.DropdownFlags

    UI.SetNextItemWidth(DB.Widgets.DropdownWidth)

    if UI.BeginCombo(DB.Widgets.DropdownMobFilterHeader, list[DB.Widgets.DropdownMobFilterIndex] or DB.Enum.ALL_MOBS, flags) then
        for index, mobName in ipairs(list) do
            local isSelected = DB.Widgets.DropdownMobFilterIndex == index

            if UI.Selectable(mobName, isSelected) then
                DB.Widgets.DropdownMobFilterIndex = index
                DB.Widgets.DropdownMobFilterFocus = mobName
            end

            if isSelected then
                UI.SetItemDefaultFocus()
            end
        end

        UI.EndCombo()
    end

    UI.SameLine() Window_Manager.Widgets.HelpMarker
    (
        "You can filter to show only data for actions taken against mobs with a specific name.\n" ..
        "Notes:\n" ..
        "1. The filter may not be for individual mobs. It is for mobs with that name collectively.\n" ..
        "2. If the mob has a unique name (like an NM) then the data will be mob specific.\n" ..
        "3. The filter only affects actions taken against mobs with that name.\n" ..
        "4. The filter does not work for healing because those actions are taken on other players.\n" ..
        "5. The filter does not work for abilities that are used on yourself or other players.\n"
    )
end

------------------------------------------------------------------------------------------------------
-- Creates a dropdown menu to show only damage done by a certain entity.
------------------------------------------------------------------------------------------------------
DB.Widgets.DropdownPlayerFilter = function()
    local list  = DB.Lists.Players
    local flags = DB.Widgets.DropdownFlags

    UI.SetNextItemWidth(DB.Widgets.DropdownWidth)

    if UI.BeginCombo(DB.Widgets.DropdownPlayerFilterHeader, list[DB.Widgets.DropdownPlayerFilterIndex] or DB.Enum.NONE, flags) then
        for index, playerName in ipairs(list) do
            local isSelected = DB.Widgets.DropdownPlayerFilterIndex == index

            if UI.Selectable(playerName, isSelected) then
                DB.Widgets.DropdownPlayerFilterIndex = index
                DB.Widgets.DropdownPlayerFilterFocus = playerName
            end

            if isSelected then
                UI.SetItemDefaultFocus()
            end
        end

        UI.EndCombo()
    end

    UI.SameLine() Window_Manager.Widgets.HelpMarker
    (
        "Pick a player that you would like to see more detailed stats for.\n"
    )
end