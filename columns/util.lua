Column.Util = { }

------------------------------------------------------------------------------------------------------
-- Switches to a player in the player filter based on partial matching.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Column.Util.Focus = function(playerName)
    if not playerName then
        return nil
    end

    local focusCheck = playerName
    playerName = string.lower(playerName)

    UI.PushID(playerName)

    if UI.SmallButton('  F  ') then
        -- Default to the Overview tab when jumping from this column.
        Focus.Tabs.Switch[Focus.Tabs.Names.OVERVIEW] = ImGuiTabItemFlags_SetSelected

        -- If in multi-window mode toggle open and closing if the focus is already the given player.
        -- Always jump to Focus if in non-Window mode.
        if focusCheck ~= DB.Widgets.GetPlayerFocus() or not WindowManager.IsMultiWindow() then
            DB.Widgets.PlayerSwitch(playerName)
            WindowManager.SwitchModule(Focus.Name)
            Focus.Window.Show()
        else
            Focus.Window.ToggleVisibility()
        end
    end

    UI.PopID()
end
