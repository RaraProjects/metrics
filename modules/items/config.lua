Loot.Config = {}

Loot.Modes = {
    [1] = "All",
    [2] = "Player",
    [3] = "Mob",
}

Loot.Config.Defaults = T{
    X = 100,
    Y = 100,
    Visible = {false},
    Loot_Mode = 1       -- All
}

------------------------------------------------------------------------------------------------------
-- Creates a dropdown menu to select the loot mode.
------------------------------------------------------------------------------------------------------
Loot.Config.Loot_Mode_Dropdown = function()
    local list = Loot.Modes
    local flags = DB.Widgets.Dropdown.Flags

    if list[1] then
        UI.SetNextItemWidth(DB.Widgets.Dropdown.Width)
        if UI.BeginCombo("Loot Mode", list[Loot.Settings.Loot_Mode], flags) then
            for n = 1, #list, 1 do
                local is_selected = Loot.Settings.Loot_Mode == n
                if UI.Selectable(list[n], is_selected) then
                    Loot.Settings.Loot_Mode = n
                end
                if is_selected then
                    UI.SetItemDefaultFocus()
                end
            end
            UI.EndCombo()
        end
    else
        if UI.BeginCombo("Loot Mode", DB.Widgets.Dropdown.Enum.NONE, flags) then
            UI.EndCombo()
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Creates an input text box for the action filter.
------------------------------------------------------------------------------------------------------
Loot.Config.Item_Filter_Input = function()
    UI.SetNextItemWidth(DB.Widgets.Dropdown.Width) UI.InputText("Item Filter", Loot.Item_Buffer, 100, ImGuiInputTextFlags_AutoSelectAll)
end

------------------------------------------------------------------------------------------------------
-- Takes an item name and compares to the current item filter string.
------------------------------------------------------------------------------------------------------
---@param item_name string
---@return boolean
------------------------------------------------------------------------------------------------------
Loot.Config.Show_Item = function(item_name)
    if not item_name then return false end
    local item_string = Loot.Item_Buffer[1]
    if not item_string then return true end
    return string.find(string.lower(item_name), string.lower(item_string)) ~= nil
end