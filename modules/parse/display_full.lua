Parse.Full = T{}
Parse.Full.Name = "Parse"
Parse.Full.Table_Flags = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders)
Parse.Full.Width = T{
    Base = 410,
}

------------------------------------------------------------------------------------------------------
-- Loads the Team data to the screen.
------------------------------------------------------------------------------------------------------
Parse.Full.Populate = function()
    Parse.Widgets.Settings_Button()
    UI.SameLine() UI.Text(" ") UI.SameLine() Overview.Overview_Button()
    UI.SameLine() UI.Text(" ") UI.SameLine() Parse.Widgets.Filter_Button()
    UI.SameLine() UI.Text(" ") UI.SameLine() Focus.Config.Percent_Details()
    UI.SameLine() UI.Text(" ") UI.SameLine() Parse.Widgets.Timer_Button()
    UI.SameLine() UI.Text(" ") UI.SameLine() Parse.Widgets.Reset_Button()
    if Parse.Confirmation then UI.SameLine() UI.Text(" ") UI.SameLine() Parse.Widgets.Reset_Confirmation_Button() end
    if Metrics.Parse.Lurk_Mode then UI.SameLine() UI.Text(" Lurking...") end
    if Metrics.Parse.Show_Filter then DB.Widgets.Mob_Filter() end
    Parse.Widgets.Clock()

    local player = Ashita.Player.My_Mob()
    if not player then return nil end

    if UI.BeginTable(Parse.Full.Name, Parse.Columns.Current, Parse.Full.Table_Flags) then
        Parse.Full.Headers()

        local player_name = "Debug"
        DB.Lists.Sort.Total_Damage()
        for rank, data in ipairs(DB.Sorted.Total_Damage) do
            if rank <= Parse.Config.Rank_Cutoff() then
                player_name = data[1]
                Parse.Full.Rows(player_name)
            elseif data[1] == player.name then
                Parse.Full.Rows(player.name)
            end
            Window_Manager.Table_Row_Color(rank)
        end
        if Metrics.Parse.Grand_Totals and #DB.Sorted.Total_Damage > 0 then Parse.Full.Total_Row() end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the headers for the Team table.
------------------------------------------------------------------------------------------------------
Parse.Full.Headers = function()
    local flags = Column.Flags.None

    if Metrics.Parse.Focus then        UI.TableSetupColumn("Focus", flags) end
    if Metrics.Parse.Jobs then         UI.TableSetupColumn("Job",   flags) end

    UI.TableSetupColumn("Name",   flags)
    UI.TableSetupColumn("Total",  flags)
    UI.TableSetupColumn("%Total", flags)

    if Metrics.Parse.Attack_Speed then UI.TableSetupColumn("s/Melee",  flags) end
    if Metrics.Parse.DPS then          UI.TableSetupColumn(DB.DPS.Column_Header(), flags) end
    if Metrics.Parse.Running_Acc then  UI.TableSetupColumn("%A." .. Metrics.Model.Running_Accuracy_Limit, flags) end
    if Metrics.Parse.Total_Acc then    UI.TableSetupColumn("%A.Total", flags) end
    if Metrics.Parse.Crit then         UI.TableSetupColumn("%Crit",    flags) end
    if Metrics.Parse.Melee then        UI.TableSetupColumn("Melee",    flags) end
    if Metrics.Parse.Melee_Acc then    UI.TableSetupColumn("M.Acc",    flags) end
    if Metrics.Parse.Melee_Crit then   UI.TableSetupColumn("%M.Crit",  flags) end
    if Metrics.Parse.Weaponskill then  UI.TableSetupColumn("WS",       flags) end
    if Metrics.Parse.Average_WS then   UI.TableSetupColumn("WS Avg",   flags) end
    if Metrics.Parse.WS_TP then        UI.TableSetupColumn("WS ~TP",   flags) end
    if Metrics.Parse.WS_Accuracy then  UI.TableSetupColumn("WS Acc",   flags) end
    if Parse.Config.Include_SC_Damage() then UI.TableSetupColumn("SC", flags) end
    if Metrics.Parse.Ranged then       UI.TableSetupColumn("Ranged",   flags) end
    if Metrics.Parse.Ranged_Acc then   UI.TableSetupColumn("R.Acc",    flags) end
    if Metrics.Parse.Ranged_Crit then  UI.TableSetupColumn("%R.Crit",  flags) end
    if Metrics.Parse.Ranged_Dist then  UI.TableSetupColumn("R.Dist",   flags) end
    if Metrics.Parse.Magic then        UI.TableSetupColumn("Magic",    flags) end
    if Metrics.Parse.Ability then      UI.TableSetupColumn("JA",       flags) end
    if Metrics.Parse.Pet_Acc then      UI.TableSetupColumn("P.Acc",    flags) end
    if Metrics.Parse.Pet_Melee then    UI.TableSetupColumn("P.Melee",  flags) end
    if Metrics.Parse.Pet_Ranged then   UI.TableSetupColumn("P.RA",     flags) end
    if Metrics.Parse.Pet_WS then       UI.TableSetupColumn("P.WS",     flags) end
    if Metrics.Parse.Pet_Ability then  UI.TableSetupColumn("P.JA",     flags) end
    if Metrics.Parse.Healing then      UI.TableSetupColumn("Healing",  flags) end
    if Metrics.Parse.Damage_Taken then UI.TableSetupColumn("DT",       flags) end
    if Metrics.Parse.Deaths then       UI.TableSetupColumn("Deaths",   flags) end

    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Loads data into the rows of the Team table.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Parse.Full.Rows = function(player_name)
    UI.TableNextRow()

    if Metrics.Parse.Focus then        UI.TableNextColumn() Column.Util.Focus(player_name) end
    if Metrics.Parse.Jobs then         UI.TableNextColumn() Column.String.Job(player_name, Metrics.Parse.Hide_Subjob) end

    UI.TableNextColumn() Column.String.Format_Name(player_name)
    UI.TableNextColumn() Column.Damage.Total(player_name, false, true)
    UI.TableNextColumn() Column.Damage.Total(player_name, true, true)

    if Metrics.Parse.Attack_Speed then UI.TableNextColumn() Column.Attack_Speed.Get(player_name, true) end
    if Metrics.Parse.DPS then          UI.TableNextColumn() Column.Damage.DPS(player_name, true) end
    if Metrics.Parse.Running_Acc then  UI.TableNextColumn() Column.Acc.Running(player_name, true) end
    if Metrics.Parse.Total_Acc then    UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Enum.Values.COMBINED, true) end
    if Metrics.Parse.Crit then         UI.TableNextColumn() Column.Proc.Crit_Rate(player_name, DB.Enum.Values.COMBINED, true) end
    if Metrics.Parse.Melee then        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE, false, true) end
    if Metrics.Parse.Melee_Acc then    UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Enum.Trackable.MELEE, true) end
    if Metrics.Parse.Melee_Crit then   UI.TableNextColumn() Column.Proc.Crit_Rate(player_name, DB.Enum.Trackable.MELEE, true) end
    if Metrics.Parse.Weaponskill then  UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.WS, false, true) end
    if Metrics.Parse.Average_WS then   UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, DB.Enum.Trackable.WS, true) end
    if Metrics.Parse.WS_TP then        UI.TableNextColumn() Column.Damage.Average_TP(player_name, true) end
    if Metrics.Parse.WS_Accuracy then  UI.TableNextColumn() Column.General.Fraction(player_name, DB.Enum.Trackable.WS, DB.Enum.Metric.HIT_COUNT, DB.Enum.Metric.COUNT, true) end
    if Parse.Config.Include_SC_Damage() then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.SC, false, true) end
    if Metrics.Parse.Ranged then       UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.RANGED, false, true) end
    if Metrics.Parse.Ranged_Acc then   UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Enum.Trackable.RANGED, true) end
    if Metrics.Parse.Ranged_Crit then  UI.TableNextColumn() Column.Proc.Crit_Rate(player_name, DB.Enum.Trackable.RANGED, true) end
    if Metrics.Parse.Ranged_Dist then  UI.TableNextColumn() Column.Damage.Shot_Distance(player_name, true) end
    if Metrics.Parse.Magic then        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MAGIC, false, true) end
    if Metrics.Parse.Ability then      UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.ABILITY_DAMAGING, false, true) end
    if Metrics.Parse.Pet_Acc then      UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Enum.Trackable.PET_MELEE_DISCRETE, true) end
    if Metrics.Parse.Pet_Melee then    UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_MELEE, false, true) end
    if Metrics.Parse.Pet_Ranged then   UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_RANGED, false, true) end
    if Metrics.Parse.Pet_WS then       UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_WS, false, true) end
    if Metrics.Parse.Pet_Ability then  UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET_ABILITY, false, true) end
    if Metrics.Parse.Healing then      UI.TableNextColumn() Column.Healing.Total(player_name, false, true) end
    if Metrics.Parse.Damage_Taken then UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL, false, true) end
    if Metrics.Parse.Deaths then       UI.TableNextColumn() Column.Proc.Deaths(player_name, true) end

end

------------------------------------------------------------------------------------------------------
-- Shows totals for each column.
------------------------------------------------------------------------------------------------------
Parse.Full.Total_Row = function()
    UI.TableNextRow()
    local x, y, z, w = UI.GetStyleColorVec4(ImGuiCol_TableHeaderBg)
    local row_bg_color = UI.GetColorU32({x, y, z, w})
    UI.TableSetBgColor(ImGuiTableBgTarget_RowBg0, row_bg_color)

    if Metrics.Parse.Focus then        UI.TableNextColumn() UI.Text(" ") end
    if Metrics.Parse.Jobs then         UI.TableNextColumn() UI.Text(" ") end

    UI.TableNextColumn() UI.Text(" ")
    UI.TableNextColumn() Column.Damage.Parse_Total(true)
    UI.TableNextColumn() UI.Text(" ")

    if Metrics.Parse.Attack_Speed then UI.TableNextColumn() UI.Text(" ") end
    if Metrics.Parse.DPS then          UI.TableNextColumn() Column.Damage.Parse_DPS(true) end
    if Metrics.Parse.Running_Acc then  UI.TableNextColumn() UI.Text(" ") end
    if Metrics.Parse.Total_Acc then    UI.TableNextColumn() UI.Text(" ") end
    if Metrics.Parse.Crit then         UI.TableNextColumn() UI.Text(" ") end
    if Metrics.Parse.Melee then        UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Enum.Trackable.MELEE, true) end
    if Metrics.Parse.Melee_Acc then    UI.TableNextColumn() UI.Text(" ") end
    if Metrics.Parse.Melee_Crit then   UI.TableNextColumn() UI.Text(" ") end
    if Metrics.Parse.Weaponskill then  UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Enum.Trackable.WS, true) end
    if Metrics.Parse.Average_WS then   UI.TableNextColumn() UI.Text(" ") end
    if Metrics.Parse.WS_TP then        UI.TableNextColumn() UI.Text(" ") end
    if Metrics.Parse.WS_Accuracy then  UI.TableNextColumn() UI.Text(" ") end
    if Parse.Config.Include_SC_Damage() then UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Enum.Trackable.SC, true) end
    if Metrics.Parse.Ranged then       UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Enum.Trackable.RANGED, true) end
    if Metrics.Parse.Ranged_Acc then   UI.TableNextColumn() UI.Text(" ") end
    if Metrics.Parse.Ranged_Crit then  UI.TableNextColumn() UI.Text(" ") end
    if Metrics.Parse.Ranged_Dist then  UI.TableNextColumn() UI.Text(" ") end
    if Metrics.Parse.Magic then        UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Enum.Trackable.MAGIC, true) end
    if Metrics.Parse.Ability then      UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Enum.Trackable.ABILITY_DAMAGING, true) end
    if Metrics.Parse.Pet_Acc then      UI.TableNextColumn() UI.Text(" ") end
    if Metrics.Parse.Pet_Melee then    UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Enum.Trackable.PET_MELEE, true) end
    if Metrics.Parse.Pet_Ranged then   UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Enum.Trackable.PET_RANGED, true) end
    if Metrics.Parse.Pet_WS then       UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Enum.Trackable.PET_WS, true) end
    if Metrics.Parse.Pet_Ability then  UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Enum.Trackable.PET_ABILITY, true) end
    if Metrics.Parse.Healing then      UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Enum.Trackable.ALL_HEAL, true) end
    if Metrics.Parse.Damage_Taken then UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL, true) end
    if Metrics.Parse.Deaths then       UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Enum.Trackable.DEATH, true) end
end

------------------------------------------------------------------------------------------------------
-- Toggles full mode.
------------------------------------------------------------------------------------------------------
Parse.Full.Enable = function()
    Metrics.Parse.Display_Mode = Parse.Enum.Display_Mode.FULL
end