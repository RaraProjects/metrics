Column.Util = T{}

------------------------------------------------------------------------------------------------------
-- Switches to a player in the player filter based on partial matching.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Column.Util.Focus = function(player_name)
    if not player_name then return nil end
    player_name = string.lower(player_name)
    UI.PushID(player_name)
    if UI.SmallButton("  F  ") then
        DB.Widgets.Util.Player_Switch(player_name)
        Window.Tabs.Switch[Window.Tabs.Names.FOCUS] = ImGuiTabItemFlags_SetSelected
        Metrics.Window.Focus_Window_Visible[1] = true
    end
    UI.PopID()
end