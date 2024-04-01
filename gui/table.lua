-- Horse_Race_Window = Window:New({
--     name       = 'Horse Race',
--     message    = 'Horse Race',
--     x_pos      = 600,
--     y_pos      = 120,
--     padding    = 1,
--     bg_alpha   = 225,
--     bg_red     = 0,
--     bg_green   = 0,
--     bg_blue    = 15,
--     bg_visible = true,
-- })

-- Top_Rank_Default = 6

local monitor = {}

monitor.Display = {}
monitor.Display.Screen = {}
monitor.Display.Item = {}

monitor.Display.Columns = {
    Base = 4,
    Unhidden = 6,
    Current = 11,
    Max = 18,
    Default = 11,
}
monitor.Display.Flags = {
    Total_Damage_Only = false,
    Total_Acc = false,
    Crit = false,
    Pet = false,
    Healing = false,
    Deaths = false,
}
monitor.Display.Dropdown = {}
monitor.Display.Dropdown.Mob = {}
monitor.Display.Dropdown.Mob.Index = 1

monitor.Settings = {
    Rank_Cutoff = 6,
    Rank_Default = 6,
    Compact_Mode = false,
    Show_Percent = false,
    Combine_Crit = true
}
monitor.Settings.Accuracy_Show_Attempts = false
monitor.Settings.Show_Help_Text = false
monitor.Settings.Include_SC_Damage = false

-- monitor.Display.Columns = {
--     ["pet"] = 4,
--     ["crit"] = 1,
--     ["sc"] = 1,
--     ["heal"] = 1,
--     ["death"] = 1,
-- }



------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
monitor.Test = function(test)
    A.Chat.Message("Inside Test " .. tostring(test))
    test = false
    -- local list = Model.Data.Initialized_Players
    -- local flags = ImGuiComboFlags_None
    -- local item_current_idx = 1

    -- local name_sort = {}
    -- for player_name, _ in pairs(list) do
    --     table.insert(name_sort, player_name)
    -- end
    -- table.sort(name_sort)
    -- list = name_sort

    -- for i, player_name in ipairs(list) do
    --     A.Chat.Message(tostring(i) .. player_name)
    -- end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
monitor.Calculate_Column_Flags = function()
    if monitor.Display.Flags.Total_Damage_Only then
        monitor.Display.Columns.Current = monitor.Display.Columns.Base
    else
        local added_columns = monitor.Display.Columns.Unhidden
        if monitor.Display.Flags.Pet then added_columns = added_columns + 4 end
        if monitor.Display.Flags.Crit then added_columns = added_columns + 1 end
        if monitor.Settings.Include_SC_Damage then added_columns = added_columns + 1 end
        if monitor.Display.Flags.Healing then added_columns = added_columns + 1 end
        if monitor.Display.Flags.Deaths then added_columns = added_columns + 1 end
        monitor.Display.Columns.Current = monitor.Display.Columns.Base + added_columns
        if monitor.Display.Columns.Current > monitor.Display.Columns.Max then
            monitor.Display.Columns.Current = monitor.Display.Columns.Max
        end
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
monitor.Display.Screen.Table = function()
    monitor.Display.Item.Mob_Filter()
    if UI.BeginTable("table1", monitor.Display.Columns.Current, Window.Table.Flags.None) then
        monitor.Display.Item.Headers()
        local player_name = "Debug"
        Model.Sort.Damage()
        for rank, data in ipairs(Model.Data.Total_Damage_Sorted) do
            if rank <= monitor.Settings.Rank_Cutoff then
                player_name = data[1]
                monitor.Display.Item.Rows(player_name)
            end
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
monitor.Display.Item.Mob_Filter = function()
    local list = Model.Data.Mob_List_Sorted
    local flags = ImGuiComboFlags_None
    if list[1] then
        if UI.BeginCombo("Mob Filter", list[monitor.Display.Dropdown.Mob.Index], flags) then
            for n = 1, #list, 1 do
                local is_selected = monitor.Display.Dropdown.Mob.Index == n
                if UI.Selectable(list[n], is_selected) then
                    monitor.Display.Dropdown.Mob.Index = n
                    Model.Mob_Filter = list[n]
                end
                -- Set the initial focus when opening the combo (scrolling + keyboard navigation focus)
                if is_selected then
                    UI.SetItemDefaultFocus()
                end
            end
            UI.EndCombo()
        end
    else
        if UI.BeginCombo("Mob Filter", "!NONE", flags) then
            UI.EndCombo()
        end
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
monitor.Display.Item.Headers = function()
    local flags = Window.Columns.Flags.None
    UI.TableSetupColumn("Name", flags)
    UI.TableSetupColumn("%T", flags)
    UI.TableSetupColumn("Total", flags)
    UI.TableSetupColumn("%A-" .. Model.Settings.Running_Accuracy_Limit, flags)
    if not monitor.Display.Flags.Total_Damage_Only then
        UI.TableSetupColumn("%A-T", flags)
        UI.TableSetupColumn("Melee", flags)
        if monitor.Display.Flags.Crit then UI.TableSetupColumn("Crit Rate", flags) end
        UI.TableSetupColumn("WS", flags)
        if monitor.Settings.Include_SC_Damage then UI.TableSetupColumn("SC", flags) end
        UI.TableSetupColumn("Ranged", flags)
        UI.TableSetupColumn("Magic", flags)
        UI.TableSetupColumn("JA", flags)
        if monitor.Display.Flags.Pet then
            UI.TableSetupColumn("Pet Melee", flags)
            UI.TableSetupColumn("Pet WS", flags)
            UI.TableSetupColumn("Pet Ranged", flags)
            UI.TableSetupColumn("Pet Ability", flags)
        end
        if monitor.Display.Flags.Healing then UI.TableSetupColumn("Healing", flags) end
        if monitor.Display.Flags.Deaths then UI.TableSetupColumn("Deaths", flags) end
    end
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
monitor.Display.Item.Rows = function(player_name)
    local melee_attempts = Model.Get.Data(player_name, 'melee', 'count')

    -- ImGui::TextColored(ImVec4(1.0f, 0.0f, 1.0f, 1.0f), "Pink");

    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(player_name)
    UI.TableNextColumn() UI.Text(Col.Damage.Total(player_name, true))
    UI.TableNextColumn() UI.Text(Col.Damage.Total(player_name))
    UI.TableNextColumn() UI.Text(Col.Acc.Running(player_name))
    if not monitor.Display.Flags.Total_Damage_Only then
        UI.TableNextColumn() UI.Text(Col.Acc.By_Type(player_name, "combined"))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, "melee"))
        if monitor.Display.Flags.Crit then UI.TableNextColumn() UI.Text(Col.Crit.Rate(player_name, melee_attempts)) end
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, "ws"))
        if monitor.Settings.Include_SC_Damage then UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, "sc")) end
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, "ranged"))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, "magic"))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, "ability"))
        if monitor.Display.Flags.Pet then
            UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, "pet_melee"))
            UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, "pet_ws"))
            UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, "pet_ranged"))
            UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, "pet_ability"))
        end
        if monitor.Display.Flags.Healing then UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, "healing")) end
        if monitor.Display.Flags.Deaths then UI.TableNextColumn() UI.Text(Col.Deaths(player_name)) end
    end
end

return monitor