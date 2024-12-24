Parse.Full = {}
Parse.Full.Name = "Parse"
Parse.Full.Table_Flags = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders)
Parse.Full.Width = {
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
    if Parse.Settings.Lurk_Mode then UI.SameLine() UI.Text(" Lurking...") end
    if Parse.Settings.Show_Filter then DB.Widgets.Mob_Filter() end
    Parse.Widgets.Clock()

    local player = Ashita.Player.My_Mob()
    if not player then return nil end

    if UI.BeginTable(Parse.Full.Name, Parse.Columns.Current, Parse.Full.Table_Flags) then
        Parse.Full.Headers()

        local player_name = DB.Enum.DEBUG
        local sorted_damage = DB.Lists.Sort.Total_Damage()
        for rank, data in ipairs(sorted_damage) do
            if rank <= Parse.Config.Rank_Cutoff() then
                player_name = data[1]
                Parse.Full.Rows(player_name)
            elseif data[1] == player.name then
                Parse.Full.Rows(player.name)
            end
            Window_Manager.Table_Row_Color(rank)
        end
        if Parse.Settings.Grand_Totals and #sorted_damage > 0 then Parse.Full.Total_Row() end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the headers for the Team table.
------------------------------------------------------------------------------------------------------
Parse.Full.Headers = function()
    local flags = Column.Flags.None

    if Parse.Settings.Show_Focus_Jump then UI.TableSetupColumn("Focus", flags) end
    if Parse.Settings.Show_Jobs then       UI.TableSetupColumn("Job",   flags) end

    UI.TableSetupColumn("Name",   flags)
    UI.TableSetupColumn("Total",  flags)
    UI.TableSetupColumn("%Total", flags)

    if Parse.Settings.Show_Melee_Delay           then UI.TableSetupColumn("s/Melee",   flags) end
    if Parse.Settings.Show_DPS                   then UI.TableSetupColumn(DB.DPS.Column_Header(), flags) end
    if Parse.Settings.Show_Accuracy_Recent       then UI.TableSetupColumn("%A." .. Metrics.Model.Running_Accuracy_Limit, flags) end
    if Parse.Settings.Show_Accuracy_Combined     then UI.TableSetupColumn("%A.Total", flags) end
    if Parse.Settings.Show_Crit_Combined         then UI.TableSetupColumn("%Crit",    flags) end
    if Parse.Settings.Show_Total_Melee           then UI.TableSetupColumn("Melee",    flags) end
    if Parse.Settings.Show_Accuracy_Melee        then UI.TableSetupColumn("M.Acc",    flags) end
    if Parse.Settings.Show_Crit_Melee            then UI.TableSetupColumn("%M.Crit",  flags) end
    if Parse.Settings.Show_Total_Weaponskill     then UI.TableSetupColumn("WS",       flags) end
    if Parse.Settings.Show_Weaponskill_Average   then UI.TableSetupColumn("WS Avg",   flags) end
    if Parse.Settings.Show_Weaponskill_TP        then UI.TableSetupColumn("WS ~TP",   flags) end
    if Parse.Settings.Show_Accuracy_Weaponskill  then UI.TableSetupColumn("WS Acc",   flags) end
    if Parse.Settings.Show_Total_Skillchain      then UI.TableSetupColumn("SC",       flags) end
    if Parse.Settings.Show_Total_Ranged          then UI.TableSetupColumn("Ranged",   flags) end
    if Parse.Settings.Show_Accuracy_Ranged       then UI.TableSetupColumn("R.Acc",    flags) end
    if Parse.Settings.Show_Crit_Ranged           then UI.TableSetupColumn("%R.Crit",  flags) end
    if Parse.Settings.Show_Ranged_Distance       then UI.TableSetupColumn("R.Dist",   flags) end
    if Parse.Settings.Show_Total_Nuking          then UI.TableSetupColumn("Nuking",   flags) end
    if Parse.Settings.Show_Total_Ability         then UI.TableSetupColumn("JA",       flags) end
    if Parse.Settings.Show_Pet_Total             then UI.TableSetupColumn("P.Total",  flags) end
    if Parse.Settings.Show_Pet_Accuracy          then UI.TableSetupColumn("P.Acc",    flags) end
    if Parse.Settings.Show_Pet_Melee             then UI.TableSetupColumn("P.Melee",  flags) end
    if Parse.Settings.Show_Pet_Ranged            then UI.TableSetupColumn("P.RA",     flags) end
    if Parse.Settings.Show_Pet_TP_Move           then UI.TableSetupColumn("P.TP",     flags) end
    if Parse.Settings.Show_Pet_Healing           then UI.TableSetupColumn("P.Heals",  flags) end
    if Parse.Settings.Show_Total_Healing         then UI.TableSetupColumn("Healing",  flags) end
    if Parse.Settings.Show_Damage_Taken          then UI.TableSetupColumn("DT",       flags) end
    if Parse.Settings.Show_Player_Deaths         then UI.TableSetupColumn("Deaths",   flags) end

    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Loads data into the rows of the Team table.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Parse.Full.Rows = function(player_name)
    UI.TableNextRow()

    if Parse.Settings.Show_Focus_Jump then UI.TableNextColumn() Column.Util.Focus(player_name) end
    if Parse.Settings.Show_Jobs then       UI.TableNextColumn() Column.String.Job(player_name, Parse.Settings.Hide_Subjob) end

    UI.TableNextColumn() Column.String.Format_Name(player_name)
    UI.TableNextColumn() Column.Damage.Total(player_name, false, true)
    UI.TableNextColumn() Column.Damage.Total(player_name, true, true)

    if Parse.Settings.Show_Melee_Delay           then UI.TableNextColumn() Column.Attack_Speed.Get(player_name, true) end
    if Parse.Settings.Show_DPS                   then UI.TableNextColumn() Column.Damage.DPS(player_name, true) end
    if Parse.Settings.Show_Accuracy_Recent       then UI.TableNextColumn() Column.Acc.Recent(player_name, true) end
    if Parse.Settings.Show_Accuracy_Combined     then UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Enum.COMBINED, nil, false, nil, true) end
    if Parse.Settings.Show_Crit_Combined         then UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Enum.COMBINED, 0, true, nil, true) end
    if Parse.Settings.Show_Total_Melee           then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.MELEE_OVERALL, nil, nil, false, true) end
    if Parse.Settings.Show_Accuracy_Melee        then UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.MELEE_OVERALL, nil, false, nil, true) end
    if Parse.Settings.Show_Crit_Melee            then UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.MELEE_OVERALL, 0, true, nil, true) end
    if Parse.Settings.Show_Total_Weaponskill     then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.WEAPONSKILL, nil, nil, false, true) end
    if Parse.Settings.Show_Weaponskill_Average   then UI.TableNextColumn() Column.Damage.By_Type_Average(player_name, DB.Trackable.WEAPONSKILL, nil, nil, true) end
    if Parse.Settings.Show_Weaponskill_TP        then UI.TableNextColumn() Column.Damage.Per_Unit_Average(player_name, DB.Trackable.WEAPONSKILL, DB.Metric.TP_SPENT, nil, true) end
    if Parse.Settings.Show_Accuracy_Weaponskill  then UI.TableNextColumn() Column.General.Fraction(player_name, DB.Trackable.WEAPONSKILL, DB.Metric.HITS_ON_USE, DB.Metric.ATTEMPTS_ON_USE, true) end
    if Parse.Settings.Show_Total_Skillchain      then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.SKILLCHAIN, nil, nil, false, true) end
    if Parse.Settings.Show_Total_Ranged          then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.RANGED_OVERALL, nil, nil, false, true) end
    if Parse.Settings.Show_Accuracy_Ranged       then UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.RANGED_OVERALL, nil, false, nil, true) end
    if Parse.Settings.Show_Crit_Ranged           then UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.RANGED_OVERALL, 0, true, nil, true) end
    if Parse.Settings.Show_Ranged_Distance       then UI.TableNextColumn() Column.Damage.Shot_Distance(player_name, true) end
    if Parse.Settings.Show_Total_Nuking          then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.SPELLS_NUKING, nil, nil, false, true) end
    if Parse.Settings.Show_Total_Ability         then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.ABILITY_DAMAGING, nil, nil, false, true) end
    if Parse.Settings.Show_Pet_Total             then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_OVERALL, nil, nil, false, true)end
    if Parse.Settings.Show_Pet_Accuracy          then UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.PET_MELEE_DISCRETE, nil, false, nil, true) end
    if Parse.Settings.Show_Pet_Melee             then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_MELEE_OVERALL, nil, nil, false, true) end
    if Parse.Settings.Show_Pet_Ranged            then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_RANGED_OVERALL, nil, nil, false, true) end
    if Parse.Settings.Show_Pet_TP_Move           then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_TP, nil, nil, false, true) end
    if Parse.Settings.Show_Pet_Healing           then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_HEALING, nil, nil, false, true)end
    if Parse.Settings.Show_Total_Healing         then UI.TableNextColumn() Column.Healing.Total(player_name, false, true) end
    if Parse.Settings.Show_Damage_Taken          then UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, false, true) end
    if Parse.Settings.Show_Player_Deaths         then UI.TableNextColumn() Column.Proc.Deaths(player_name, true) end

end

------------------------------------------------------------------------------------------------------
-- Shows totals for each column.
------------------------------------------------------------------------------------------------------
Parse.Full.Total_Row = function()
    UI.TableNextRow()
    local x, y, z, w = UI.GetStyleColorVec4(ImGuiCol_TableHeaderBg)
    local row_bg_color = UI.GetColorU32({x, y, z, w})
    UI.TableSetBgColor(ImGuiTableBgTarget_RowBg0, row_bg_color)

    if Parse.Settings.Show_Focus_Jump then UI.TableNextColumn() UI.Text(" ") end
    if Parse.Settings.Show_Jobs then       UI.TableNextColumn() UI.Text(" ") end

    UI.TableNextColumn() UI.Text(" ")
    UI.TableNextColumn() Column.Damage.Parse_Total(true)
    UI.TableNextColumn() UI.Text(" ")

    if Parse.Settings.Show_Melee_Delay           then UI.TableNextColumn() UI.Text(" ") end
    if Parse.Settings.Show_DPS                   then UI.TableNextColumn() Column.Damage.Parse_DPS(true) end
    if Parse.Settings.Show_Accuracy_Recent       then UI.TableNextColumn() UI.Text(" ") end
    if Parse.Settings.Show_Accuracy_Combined     then UI.TableNextColumn() UI.Text(" ") end
    if Parse.Settings.Show_Crit_Combined         then UI.TableNextColumn() UI.Text(" ") end
    if Parse.Settings.Show_Total_Melee           then UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Trackable.MELEE_OVERALL, true) end
    if Parse.Settings.Show_Accuracy_Melee        then UI.TableNextColumn() UI.Text(" ") end
    if Parse.Settings.Show_Crit_Melee            then UI.TableNextColumn() UI.Text(" ") end
    if Parse.Settings.Show_Total_Weaponskill     then UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Trackable.WEAPONSKILL, true) end
    if Parse.Settings.Show_Weaponskill_Average   then UI.TableNextColumn() UI.Text(" ") end
    if Parse.Settings.Show_Weaponskill_TP        then UI.TableNextColumn() UI.Text(" ") end
    if Parse.Settings.Show_Accuracy_Weaponskill  then UI.TableNextColumn() UI.Text(" ") end
    if Parse.Settings.Show_Total_Skillchain      then UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Trackable.SKILLCHAIN, true) end
    if Parse.Settings.Show_Total_Ranged          then UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Trackable.RANGED_OVERALL, true) end
    if Parse.Settings.Show_Accuracy_Ranged       then UI.TableNextColumn() UI.Text(" ") end
    if Parse.Settings.Show_Crit_Ranged           then UI.TableNextColumn() UI.Text(" ") end
    if Parse.Settings.Show_Ranged_Distance       then UI.TableNextColumn() UI.Text(" ") end
    if Parse.Settings.Show_Total_Nuking          then UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Trackable.SPELLS_NUKING, true)end
    if Parse.Settings.Show_Total_Ability         then UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Trackable.ABILITY_DAMAGING, true) end
    if Parse.Settings.Show_Pet_Total             then UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Trackable.PET_OVERALL, true)end
    if Parse.Settings.Show_Pet_Accuracy          then UI.TableNextColumn() UI.Text(" ") end
    if Parse.Settings.Show_Pet_Melee             then UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Trackable.PET_MELEE_OVERALL, true) end
    if Parse.Settings.Show_Pet_Ranged            then UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Trackable.PET_RANGED_OVERALL, true) end
    if Parse.Settings.Show_Pet_TP_Move           then UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Trackable.PET_TP, true) end
    if Parse.Settings.Show_Pet_Healing           then UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Trackable.PET_HEALING, true)end
    if Parse.Settings.Show_Total_Healing         then UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Trackable.ALL_HEAL, true) end
    if Parse.Settings.Show_Damage_Taken          then UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, true) end
    if Parse.Settings.Show_Player_Deaths         then UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Trackable.DEATH, true) end
end

------------------------------------------------------------------------------------------------------
-- Toggles full mode.
------------------------------------------------------------------------------------------------------
Parse.Full.Enable = function()
    Parse.Settings.Display_Mode = Parse.Enum.Display_Mode.FULL
end