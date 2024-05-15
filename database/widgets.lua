DB.Widgets = T{}

DB.Widgets.Util = T{}

DB.Widgets.Dropdown = T{}
DB.Widgets.Dropdown.Enum = T{
    MOB   = "Mob Filter",
    FOCUS = "Player",
    NONE  = "!NONE",
}
DB.Widgets.Dropdown.Flags = ImGuiComboFlags_None
DB.Widgets.Dropdown.Player = T{}
DB.Widgets.Dropdown.Player.Focus = DB.Widgets.Dropdown.Enum.NONE
DB.Widgets.Dropdown.Player.Index = 1
DB.Widgets.Dropdown.Mob = T{}
DB.Widgets.Dropdown.Mob.Focus = DB.Widgets.Dropdown.Enum.NONE
DB.Widgets.Dropdown.Mob.Index = 1
DB.Widgets.Dropdown.Width = 150

------------------------------------------------------------------------------------------------------
-- Creates a dropdown menu to show only damage done to a certain mob.
------------------------------------------------------------------------------------------------------
DB.Widgets.Mob_Filter = function()
    local list = DB.Lists.Get.Mob()
    local flags = DB.Widgets.Dropdown.Flags
    if list[1] then
        UI.SetNextItemWidth(DB.Widgets.Dropdown.Width)
        if UI.BeginCombo(DB.Widgets.Dropdown.Enum.MOB, list[DB.Widgets.Dropdown.Mob.Index], flags) then
            for n = 1, #list, 1 do
                local is_selected = DB.Widgets.Dropdown.Mob.Index == n
                if UI.Selectable(list[n], is_selected) then
                    DB.Widgets.Dropdown.Mob.Index = n
                    DB.Widgets.Dropdown.Mob.Focus = list[n]
                end
                if is_selected then
                    UI.SetItemDefaultFocus()
                end
            end
            UI.EndCombo()
        end
    else
        if UI.BeginCombo(DB.Widgets.Dropdown.Enum.MOB, DB.Widgets.Dropdown.Enum.NONE, flags) then
            UI.EndCombo()
        end
    end
    DB.Widgets.Mob_Filter_Help_Text()
end

------------------------------------------------------------------------------------------------------
-- Shows the help text for the mob filter.
------------------------------------------------------------------------------------------------------
DB.Widgets.Mob_Filter_Help_Text = function()
    UI.SameLine() Window.Widgets.HelpMarker("You can filter to show only data for actions taken against mobs with a specific name.\n"
                                        .. "Notes:\n"
                                        .. "1. The filter may not be for individual mobs. It is for mobs with that name collectively.\n"
                                        .. "2. If the mob has a unique name (like an NM) then the data will be mob specific.\n"
                                        .. "3. The filter only affects actions taken against mobs with that name.\n"
                                        .. "4. The filter does not work for healing because those actions are taken on other players.\n"
                                        .. "5. The filter does not work for abilities that are used on yourself or other players.\n")
end

------------------------------------------------------------------------------------------------------
-- Creates a dropdown menu to show only damage done by a certain entity.
------------------------------------------------------------------------------------------------------
DB.Widgets.Player_Filter = function()
    local list = DB.Lists.Get.Players()
    local flags = DB.Widgets.Dropdown.Flags
    if list[1] then
        UI.SetNextItemWidth(DB.Widgets.Dropdown.Width)
        if UI.BeginCombo(DB.Widgets.Dropdown.Enum.FOCUS, list[DB.Widgets.Dropdown.Player.Index], flags) then
            for n = 1, #list, 1 do
                local is_selected = DB.Widgets.Dropdown.Player.Index == n
                if UI.Selectable(list[n], is_selected) then
                    DB.Widgets.Dropdown.Player.Index = n
                    DB.Widgets.Dropdown.Player.Focus = list[n]
                end
                if is_selected then
                    UI.SetItemDefaultFocus()
                end
            end
            UI.EndCombo()
        end
    else
        if UI.BeginCombo(DB.Widgets.Dropdown.Enum.FOCUS, DB.Widgets.Dropdown.Enum.NONE, flags) then
            UI.EndCombo()
        end
    end
    DB.Widgets.Player_Filter_Help_Text()
end

------------------------------------------------------------------------------------------------------
-- Shows the help text for the player filter.
------------------------------------------------------------------------------------------------------
DB.Widgets.Player_Filter_Help_Text = function()
    UI.SameLine() Window.Widgets.HelpMarker("Pick a player that you would like to see more detailed stats for.\n")
end

------------------------------------------------------------------------------------------------------
-- Switches to a player in the player filter based on partial matching.
------------------------------------------------------------------------------------------------------
DB.Widgets.Util.Player_Switch = function(player_string)
    local list = DB.Lists.Get.Players()
    local found = false
    for n, player_name in pairs(list) do
        if not found then
            if string.find(string.lower(player_name), player_string) then
                DB.Widgets.Dropdown.Player.Index = n
                DB.Widgets.Dropdown.Player.Focus = list[n]
                found = true
            end
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Utility function for accessing the name of the currently focused entity.
------------------------------------------------------------------------------------------------------
DB.Widgets.Util.Get_Player_Focus = function()
    return DB.Widgets.Dropdown.Player.Focus
end

------------------------------------------------------------------------------------------------------
-- Utility function for accessing the name of the currently focused mob.
------------------------------------------------------------------------------------------------------
DB.Widgets.Util.Get_Mob_Focus = function()
    return DB.Widgets.Dropdown.Mob.Focus
end