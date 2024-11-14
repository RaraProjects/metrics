Column.Util = T{}

------------------------------------------------------------------------------------------------------
-- Switches to a player in the player filter based on partial matching.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Column.Util.Focus = function(player_name)
    if not player_name then return nil end
    local focus_check = player_name
    player_name = string.lower(player_name)
    UI.PushID(player_name)
    if UI.SmallButton("  F  ") then
        -- Default to the Overview tab when jumping from this column.
        Focus.Tabs.Switch[Focus.Tabs.Names.OVERVIEW] = ImGuiTabItemFlags_SetSelected

        -- If in multi-window mode toggle open and closing if the focus is already the given player.
        -- Always jump to Focus if in non-Window mode.
        if focus_check ~= DB.Widgets.Util.Get_Player_Focus() or not Metrics.Window.Multi_Window then
            DB.Widgets.Util.Player_Switch(player_name)
            Window_Manager.Switch_Module(Focus.Name)
            Focus.Window.Show()
        else
            Focus.Window.Toggle_Visibility()
        end
    end
    UI.PopID()
end