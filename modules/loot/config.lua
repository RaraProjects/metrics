Loot.Config = { }

Loot.Modes =
{
    [1] = "All",
    [2] = "Player",
    [3] = "Mob",
}

Loot.Config.Defaults = T{
    X         = 100,
    Y         = 100,
    Visible   = { false },
    Loot_Mode = 1           -- All
}

------------------------------------------------------------------------------------------------------
-- Creates a dropdown menu to select the loot mode.
------------------------------------------------------------------------------------------------------
Loot.Config.LootModeDropdown = function()
    local list  = Loot.Modes
    local flags = DB.Widgets.DropdownFlags

    UI.SetNextItemWidth(DB.Widgets.DropdownWidth)

    if UI.BeginCombo("Loot Mode", list[Loot.Settings.Loot_Mode] or DB.Enum.NONE, flags) then
        for index, mode in ipairs(list) do
            local isSelected = Loot.Settings.Loot_Mode == index

            if UI.Selectable(mode, isSelected) then
                Loot.Settings.Loot_Mode = index
            end

            if isSelected then
                UI.SetItemDefaultFocus()
            end
        end

        UI.EndCombo()
    end
end

------------------------------------------------------------------------------------------------------
-- Creates an input text box for the action filter.
------------------------------------------------------------------------------------------------------
Loot.Config.ItemFilterInput = function()
    UI.SetNextItemWidth(DB.Widgets.DropdownWidth) UI.InputText("Item Filter", Loot.ItemBuffer, 100, ImGuiInputTextFlags_AutoSelectAll)
end

------------------------------------------------------------------------------------------------------
-- Takes an item name and compares to the current item filter string.
------------------------------------------------------------------------------------------------------
---@param itemName string
---@return boolean
------------------------------------------------------------------------------------------------------
Loot.Config.ShowItem = function(itemName)
    if not itemName then
        return false
    end

    local itemFilter = Loot.ItemBuffer[1]

    return not itemFilter or string.find(itemName:lower(), itemFilter:lower()) ~= nil
end