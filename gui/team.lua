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
    Window.Dropdown.Mob_Filter()
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
    -- ImGui::TextColored(ImVec4(1.0f, 0.0f, 1.0f, 1.0f), "Pink");

    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(player_name)
    UI.TableNextColumn() UI.Text(Col.Damage.Total(player_name, true))
    UI.TableNextColumn() UI.Text(Col.Damage.Total(player_name))
    UI.TableNextColumn() UI.Text(Col.Acc.Running(player_name))
    if not monitor.Display.Flags.Total_Damage_Only then
        UI.TableNextColumn() UI.Text(Col.Acc.By_Type(player_name, Model.Enum.Misc.COMBINED))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.MELEE))
        if monitor.Display.Flags.Crit then UI.TableNextColumn() UI.Text(Col.Crit.Rate(player_name, Model.Enum.Trackable.MELEE)) end
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.WS))
        if monitor.Settings.Include_SC_Damage then UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.SC)) end
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.RANGED))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.MAGIC))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.ABILITY))
        if monitor.Display.Flags.Pet then
            UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_MELEE))
            UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_WS))
            UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_RANGED))
            UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_ABILITY))
        end
        if monitor.Display.Flags.Healing then UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.HEALING)) end
        if monitor.Display.Flags.Deaths then UI.TableNextColumn() UI.Text(Col.Deaths(player_name)) end
    end
end

return monitor