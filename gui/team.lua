local t = {}

t.Display = {}
t.Util = {}
t.Display.Screen = {}
t.Defaults = {}

t.Display.Columns = {
    Base = 4,
    Current = 10,
    Start = 6,
    Max = 18,
    Default = 10,
}
t.Defaults.Columns = {
    Base = 4,
    Current = 10,
    Max = 18,
    Default = 10,
}

t.Display.Flags = {
    Total_Damage_Only = false,
    Crit = false,
    Pet = false,
    Healing = false,
    Deaths = false,
}
t.Defaults.Flags = {
    Total_Damage_Only = false,
    Total_Acc = false,
    Crit = false,
    Pet = false,
    Healing = false,
    Deaths = false,
}

t.Settings = {
    Rank_Cutoff = 6,
    Condensed_Numbers = false,
    Include_SC_Damage = false
}
t.Defaults.Settings = {
    Rank_Cutoff = 6,
    Condensed_Numbers = false,
    Include_SC_Damage = false
}

------------------------------------------------------------------------------------------------------
-- Loads the Team data to the screen.
------------------------------------------------------------------------------------------------------
t.Populate = function()
    Window.Widget.Mob_Filter()
    if UI.BeginTable("Team", t.Display.Columns.Current, Window.Table.Flags.Team) then
        t.Display.Headers()
        local player_name = "Debug"
        Model.Sort.Damage()
        for rank, data in ipairs(Model.Data.Total_Damage_Sorted) do
            if rank <= t.Settings.Rank_Cutoff then
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
    if t.Display.Flags.Total_Damage_Only then
        t.Display.Columns.Current = t.Display.Columns.Base
    else
        local added_columns = t.Display.Columns.Start
        if t.Display.Flags.Pet then added_columns = added_columns + 4 end
        if t.Display.Flags.Crit then added_columns = added_columns + 1 end
        if t.Settings.Include_SC_Damage then added_columns = added_columns + 1 end
        if t.Display.Flags.Healing then added_columns = added_columns + 1 end
        if t.Display.Flags.Deaths then added_columns = added_columns + 1 end

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
    UI.TableSetupColumn("%A-" .. Model.Settings.Running_Accuracy_Limit, flags)
    if not t.Display.Flags.Total_Damage_Only then
        UI.TableSetupColumn("%A-T", flags)
        UI.TableSetupColumn("Melee", flags)
        if t.Display.Flags.Crit then UI.TableSetupColumn("Crit Rate", flags) end
        UI.TableSetupColumn("WS", flags)
        if t.Settings.Include_SC_Damage then UI.TableSetupColumn("SC", flags) end
        UI.TableSetupColumn("Ranged", flags)
        UI.TableSetupColumn("Magic", flags)
        UI.TableSetupColumn("JA", flags)
        if t.Display.Flags.Pet then
            UI.TableSetupColumn("Pet Melee", flags)
            UI.TableSetupColumn("Pet WS", flags)
            UI.TableSetupColumn("Pet Ranged", flags)
            UI.TableSetupColumn("Pet Ability", flags)
        end
        if t.Display.Flags.Healing then UI.TableSetupColumn("Healing", flags) end
        --if t.Display.Flags.Deaths then UI.TableSetupColumn("Deaths", flags) end
    end
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Loads data into the rows of the Team table.
------------------------------------------------------------------------------------------------------
t.Display.Rows = function(player_name)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(player_name)
    UI.TableNextColumn() Col.Damage.Total(player_name, true)
    UI.TableNextColumn() Col.Damage.Total(player_name)
    UI.TableNextColumn() Col.Acc.Running(player_name)
    if not t.Display.Flags.Total_Damage_Only then
        UI.TableNextColumn() Col.Acc.By_Type(player_name, Model.Enum.Misc.COMBINED)
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.MELEE))
        if t.Display.Flags.Crit then UI.TableNextColumn() UI.Text(Col.Crit.Rate(player_name, Model.Enum.Trackable.MELEE)) end
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.WS))
        if t.Settings.Include_SC_Damage then UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.SC)) end
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.RANGED))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.MAGIC))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.ABILITY))
        if t.Display.Flags.Pet then
            UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_MELEE))
            UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_WS))
            UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_RANGED))
            UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_ABILITY))
        end
        if t.Display.Flags.Healing then UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.HEALING)) end
        -- if t.Display.Flags.Deaths then UI.TableNextColumn() UI.Text(Col.Deaths(player_name)) end
    end
end

------------------------------------------------------------------------------------------------------
-- Loads shows just the Team tab with just the player.
------------------------------------------------------------------------------------------------------
t.Nano_Mode = function()
    local flags = Window.Columns.Flags.None
    local player = A.Mob.Get_Mob_By_Target(A.Enum.Mob.ME)
    if not player then return nil end
    local player_name = player.name

    if UI.BeginTable("Team Nano", 3, Window.Table.Flags.None) then
        UI.TableSetupColumn("%T", flags)
        UI.TableSetupColumn("Total", flags)
        UI.TableSetupColumn("%A-" .. Model.Settings.Running_Accuracy_Limit, flags)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() Col.Damage.Total(player_name, true)
        UI.TableNextColumn() Col.Damage.Total(player_name)
        UI.TableNextColumn() Col.Acc.Running(player_name)

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Loads shows just the Team tab with just the player.
------------------------------------------------------------------------------------------------------
t.Mini_Mode = function()
    local flags = Window.Columns.Flags.None

    if UI.BeginTable("Team Mini", 4, Window.Table.Flags.Borders) then
        UI.TableSetupColumn("Name", flags)
        UI.TableSetupColumn("%T", flags)
        UI.TableSetupColumn("Total", flags)
        UI.TableSetupColumn("%A-" .. Model.Settings.Running_Accuracy_Limit, flags)
        UI.TableHeadersRow()

        local player_name = "Debug"
        Model.Sort.Damage()
        for rank, data in ipairs(Model.Data.Total_Damage_Sorted) do
            if rank <= t.Settings.Rank_Cutoff then
                player_name = data[1]
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(player_name)
                UI.TableNextColumn() Col.Damage.Total(player_name, true)
                UI.TableNextColumn() Col.Damage.Total(player_name)
                UI.TableNextColumn() Col.Acc.Running(player_name)
            end
        end

        UI.EndTable()
    end
end

return t