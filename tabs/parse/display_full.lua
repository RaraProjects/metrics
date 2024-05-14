Parse.Full = T{}
Parse.Full.Name = "Parse"

------------------------------------------------------------------------------------------------------
-- Loads the Team data to the screen.
------------------------------------------------------------------------------------------------------
Parse.Full.Populate = function()
    Window.Widget.Mob_Filter()

    -- Duration Timer
    if Metrics.Team.Settings.Show_Clock then
        if not Metrics.Team.Flags.Total_Damage_Only then UI.SameLine() UI.Text(" ") UI.SameLine() end
        local pause_string = ""
        if Timers.Is_Paused(Timers.Enum.Names.PARSE) then pause_string = " (paused)" end
        UI.Text("Duration: " .. tostring(Timers.Check("Metrics"))) UI.SameLine() UI.Text(pause_string) Parse.Widgets.Timer_Duration_Help_Text()
    end

    -- Main Body
    if UI.BeginTable(Parse.Full.Name, Parse.Columns.Current, Window.Table.Flags.Team) then
        Parse.Full.Headers()

        local player_name = "Debug"
        DB.Lists.Sort.Total_Damage()
        for rank, data in ipairs(DB.Sorted.Total_Damage) do
            if rank <= Metrics.Team.Settings.Rank_Cutoff then
                player_name = data[1]
                Parse.Full.Rows(player_name)
            end
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the headers for the Team table.
------------------------------------------------------------------------------------------------------
Parse.Full.Headers = function()
    local flags = Window.Columns.Flags.None
    UI.TableSetupColumn("Name", flags)
    UI.TableSetupColumn("DPS", flags)
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
Parse.Full.Rows = function(player_name)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(player_name)
    UI.TableNextColumn() Col.Damage.DPS(player_name, true)
    UI.TableNextColumn() Col.Damage.Total(player_name, true, true)
    UI.TableNextColumn() Col.Damage.Total(player_name, false, true)
    UI.TableNextColumn() Col.Acc.Running(player_name)
    if not Metrics.Team.Flags.Total_Damage_Only then
        UI.TableNextColumn() Col.Acc.By_Type(player_name, DB.Enum.Values.COMBINED, true)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE, false, true)
        if Metrics.Team.Flags.Crit then UI.TableNextColumn() Col.Crit.Rate(player_name, DB.Enum.Trackable.MELEE, true) end
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.WS, false, true)
        if Metrics.Team.Settings.Include_SC_Damage then UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.SC, false, true) end
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.RANGED, false, true)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MAGIC, false, true)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.ABILITY, false, true)
        if Metrics.Team.Flags.Pet then
            UI.TableNextColumn() Col.Acc.By_Type(player_name, DB.Enum.Trackable.PET_MELEE_DISCRETE)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET_MELEE, false, true)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET_WS, false, true)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET_RANGED, false, true)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET_ABILITY, false, true)
        end
        if Metrics.Team.Flags.Healing then UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.HEALING, false, true) end
        if Metrics.Team.Flags.Deaths then UI.TableNextColumn() Col.Deaths(player_name) end
    end
end