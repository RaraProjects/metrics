local t = T{}

t.Display = {}
t.Util = {}
t.Display.Screen = {}

t.Display.Columns = {
    Base = 4,
    Current = 10,
    Start = 6,
    Max = 18,
    Default = 10,
}
t.Display.Flags = {

}
t.Settings = {

}

t.Defaults = T{}
t.Defaults.Flags = T{
    Total_Damage_Only = false,
    Total_Acc = false,
    Crit = false,
    Pet = false,
    Healing = false,
    Deaths = false,
}
t.Defaults.Settings = T{
    Show_Clock = true,
    Rank_Cutoff = 6,
    Condensed_Numbers = false,
    Include_SC_Damage = false
}

------------------------------------------------------------------------------------------------------
-- Initializes the Team screen.
------------------------------------------------------------------------------------------------------
t.Initialize = function()
    t.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Loads the Team data to the screen.
------------------------------------------------------------------------------------------------------
t.Populate = function()
    Window.Widget.Mob_Filter() 
    if Metrics.Team.Settings.Show_Clock then
        if not Metrics.Team.Flags.Total_Damage_Only then UI.SameLine() UI.Text(" ") UI.SameLine() end
        UI.Text("Duration: " .. tostring(Timers.Check("Metrics")))
    end
    if UI.BeginTable("Team", t.Display.Columns.Current, Window.Table.Flags.Team) then
        t.Display.Headers()
        local player_name = "Debug"
        Model.Sort.Total_Damage()
        for rank, data in ipairs(Model.Data.Total_Damage_Sorted) do
            if rank <= Metrics.Team.Settings.Rank_Cutoff then
                player_name = data[1]
                t.Display.Rows(player_name)
            end
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Resets the Team window to default settings.
------------------------------------------------------------------------------------------------------
t.Reset_Settings = function()
    for index, _ in pairs(t.Settings) do
        t.Settings[index] = t.Defaults.Settings[index]
    end
    for index, _ in pairs(t.Display.Flags) do
        t.Display.Flags[index] = t.Defaults.Flags[index]
    end
    t.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Calculates how many columns should be shown on the Team table based on column visibility flags.
------------------------------------------------------------------------------------------------------
t.Util.Calculate_Column_Flags = function()
    if Metrics.Team.Flags.Total_Damage_Only then
        t.Display.Columns.Current = t.Display.Columns.Base
    else
        local added_columns = t.Display.Columns.Start
        if Metrics.Team.Flags.Pet then added_columns = added_columns + 5 end
        if Metrics.Team.Flags.Crit then added_columns = added_columns + 1 end
        if Metrics.Team.Settings.Include_SC_Damage then added_columns = added_columns + 1 end
        if Metrics.Team.Flags.Healing then added_columns = added_columns + 1 end
        if Metrics.Team.Flags.Deaths then added_columns = added_columns + 1 end

        -- Apply new column count.
        t.Display.Columns.Current = t.Display.Columns.Base + added_columns

        if t.Display.Columns.Current > t.Display.Columns.Max then
            t.Display.Columns.Current = t.Display.Columns.Max
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the headers for the Team table.
------------------------------------------------------------------------------------------------------
t.Display.Headers = function()
    local flags = Window.Columns.Flags.None
    UI.TableSetupColumn("Name", flags)
    UI.TableSetupColumn("%T", flags)
    UI.TableSetupColumn("Total", flags)
    UI.TableSetupColumn("%A-" .. Metrics.Model.Running_Accuracy_Limit, flags)
    if not Metrics.Team.Flags.Total_Damage_Only then
        UI.TableSetupColumn("%A-T", flags)
        UI.TableSetupColumn("Melee", flags)
        if Metrics.Team.Flags.Crit then UI.TableSetupColumn("Crit Rate", flags) end
        UI.TableSetupColumn("WS", flags)
        if Metrics.Team.Settings.Include_SC_Damage then UI.TableSetupColumn("SC", flags) end
        UI.TableSetupColumn("Ranged", flags)
        UI.TableSetupColumn("Magic", flags)
        UI.TableSetupColumn("JA", flags)
        if Metrics.Team.Flags.Pet then
            UI.TableSetupColumn("Pet Acc", flags)
            UI.TableSetupColumn("Pet Melee", flags)
            UI.TableSetupColumn("Pet WS", flags)
            UI.TableSetupColumn("Pet Ranged", flags)
            UI.TableSetupColumn("Pet Ability", flags)
        end
        if Metrics.Team.Flags.Healing then UI.TableSetupColumn("Healing", flags) end
        if Metrics.Team.Flags.Deaths then UI.TableSetupColumn("Deaths", flags) end
    end
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Loads data into the rows of the Team table.
------------------------------------------------------------------------------------------------------
t.Display.Rows = function(player_name)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(player_name)
    UI.TableNextColumn() Col.Damage.Total(player_name, true, true)
    UI.TableNextColumn() Col.Damage.Total(player_name, false, true)
    UI.TableNextColumn() Col.Acc.Running(player_name)
    if not Metrics.Team.Flags.Total_Damage_Only then
        UI.TableNextColumn() Col.Acc.By_Type(player_name, Model.Enum.Misc.COMBINED, true)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.MELEE, false, true)
        if Metrics.Team.Flags.Crit then UI.TableNextColumn() Col.Crit.Rate(player_name, Model.Enum.Trackable.MELEE, true) end
        UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.WS, false, true)
        if Metrics.Team.Settings.Include_SC_Damage then UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.SC, false, true) end
        UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.RANGED, false, true)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.MAGIC, false, true)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.ABILITY, false, true)
        if Metrics.Team.Flags.Pet then
            UI.TableNextColumn() Col.Acc.By_Type(player_name, Model.Enum.Trackable.PET_MELEE_DISCRETE)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_MELEE, false, true)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_WS, false, true)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_RANGED, false, true)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_ABILITY, false, true)
        end
        if Metrics.Team.Flags.Healing then UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.HEALING, false, true) end
        if Metrics.Team.Flags.Deaths then UI.TableNextColumn() Col.Deaths(player_name) end
    end
end

------------------------------------------------------------------------------------------------------
-- Loads shows just the Team tab with just the player.
------------------------------------------------------------------------------------------------------
t.Nano_Mode = function()
    local flags = Window.Columns.Flags.None
    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    if not player then return nil end
    local player_name = player.name

    if UI.BeginTable("Team Nano", 3, Window.Table.Flags.None) then
        UI.TableSetupColumn("%T", flags)
        UI.TableSetupColumn("Total", flags)
        UI.TableSetupColumn("%A-" .. Metrics.Model.Running_Accuracy_Limit, flags)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() Col.Damage.Total(player_name, true, true)
        UI.TableNextColumn() Col.Damage.Total(player_name, false, true)
        UI.TableNextColumn() Col.Acc.Running(player_name)

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Loads shows just the Team tab with just the player.
------------------------------------------------------------------------------------------------------
t.Mini_Mode = function()
    local flags = Window.Columns.Flags.None

    local columns = 4
    if Metrics.Team.Flags.Pet then columns = columns + 2 end

    if UI.BeginTable("Team Mini", columns, Window.Table.Flags.Borders) then
        UI.TableSetupColumn("Name", flags)
        UI.TableSetupColumn("%T", flags)
        UI.TableSetupColumn("Total", flags)
        UI.TableSetupColumn("%A-" .. Metrics.Model.Running_Accuracy_Limit, flags)
        if Metrics.Team.Flags.Pet then
            UI.TableSetupColumn("Pet D.", flags)
            UI.TableSetupColumn("Pet A.", flags)
        end
        UI.TableHeadersRow()

        local player_name = "Debug"
        Model.Sort.Total_Damage()
        for rank, data in ipairs(Model.Data.Total_Damage_Sorted) do
            if rank <= Metrics.Team.Settings.Rank_Cutoff then
                player_name = data[1]
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(player_name)
                UI.TableNextColumn() Col.Damage.Total(player_name, true, true)
                UI.TableNextColumn() Col.Damage.Total(player_name, false, true)
                UI.TableNextColumn() Col.Acc.Running(player_name)
                if Metrics.Team.Flags.Pet then
                    UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET)
                    UI.TableNextColumn() Col.Acc.By_Type(player_name, Model.Enum.Trackable.PET_MELEE_DISCRETE)
                end
            end
        end

        UI.EndTable()
    end
end

return t