local r = T{}

r.Section = T{}
r.Publish = T{}
r.Data = T{}
r.Delay = 1.80

r.Defaults = T{
    Damage_Threshold = 5,   -- Controls what damage percent is needed for showing up in a cross-player chat report.
}

r.Lock = false  -- Stops multiple reports from being pushed to chat at the same time.
r.Publish.Chat_Index = 1
r.Publish.Chat_Mode = Ashita.Enum.Chat.PARTY

-- The screen flickers when publishing to the chat. I think it has to do with the sleep after each line.
-- The sleep is necessary because the chat can only accept inputs at a certain rate.

------------------------------------------------------------------------------------------------------
-- Creates some buttons to publish various party metrics to chat.
------------------------------------------------------------------------------------------------------
r.Populate = function()
    r.Section.Chat_Reports()
    UI.Separator()
    r.Section.File()
    UI.Separator()
    r.Section.Monsters_Defeated()
end

------------------------------------------------------------------------------------------------------
-- Builds the chat report section.
------------------------------------------------------------------------------------------------------
r.Section.Chat_Reports = function()
    local col_flags = Window.Columns.Flags.None
    local width = Window.Columns.Widths.Report
    UI.Text("Chat Reports")
    r.Dropdown()
    if UI.BeginTable("Chat Reports", 4, Window.Table.Flags.None) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)
        UI.TableSetupColumn("Col 4", col_flags, width)

        UI.TableNextRow()
        UI.TableNextColumn()
        if UI.Button("Total Damage") then
            r.Publish.Total_Damage()
            return nil
        end
        UI.TableNextColumn()
        if UI.Button("Accuracy    ") then
            r.Publish.Accuracy()
            return nil
        end
        UI.TableNextColumn()
        UI.TableNextColumn()
        --
        UI.TableNextColumn()
        if UI.Button("Melee       ") then
            r.Publish.Damage_By_Type(DB.Enum.Trackable.MELEE)
            return nil
        end
        UI.TableNextColumn()
        if UI.Button("Weaponskills") then
            r.Publish.Damage_By_Type(DB.Enum.Trackable.WS)
            return nil
        end
        UI.TableNextColumn()
        if UI.Button("Magic       ") then
            r.Publish.Damage_By_Type(DB.Enum.Trackable.MAGIC)
            return nil
        end
        UI.TableNextColumn()
        if UI.Button("Pet         ") then
            r.Publish.Damage_By_Type(DB.Enum.Trackable.PET)
            return nil
        end
        --
        UI.TableNextColumn()
        if UI.Button("Abilities   ") then
            r.Publish.Damage_By_Type(DB.Enum.Trackable.ABILITY)
            return nil
        end
        UI.TableNextColumn()
        if UI.Button("Healing     ") then
            r.Publish.Damage_By_Type(DB.Enum.Trackable.HEALING)
            return nil
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Builds the file section.
------------------------------------------------------------------------------------------------------
r.Section.File = function()
    local col_flags = Window.Columns.Flags.None
    local width = Window.Columns.Widths.Report
    UI.Text("Create CSV File")
    UI.Text("Files can be found in: /config/Metrics/")
    if UI.BeginTable("Save File", 4, Window.Table.Flags.None) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextRow()
        UI.TableNextColumn()
        if UI.Button("Database    ") then
            File.Save_Data()
            File.Save_Catalog()
            return nil
        end
        UI.TableNextColumn()
        if UI.Button("Battle Log  ") then
            File.Save_Battlelog()
            return nil
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Builds the monsters defeated section.
------------------------------------------------------------------------------------------------------
r.Section.Monsters_Defeated = function()
    UI.Text("Monsters Defeated")
    local mobs_defeated = 0
    for mob_name, count in pairs(DB.Tracking.Defeated_Mobs) do
        UI.BulletText(mob_name .. ": " .. tostring(count))
        mobs_defeated = mobs_defeated + 1
    end
    if mobs_defeated == 0 then UI.BulletText("None") end
end

------------------------------------------------------------------------------------------------------
-- Sends a report of total damage to game chat.
------------------------------------------------------------------------------------------------------
r.Publish.Total_Damage = function()
    if not r.Lock then
        r.Lock = true
        local found = false
        Ashita.Chat.Add_To_Chat(r.Publish.Chat_Mode.Prefix, "Total Damage") coroutine.sleep(r.Delay)
        DB.Lists.Sort.Total_Damage()
        for rank, data in ipairs(DB.Sorted.Total_Damage) do
            if rank <= Metrics.Team.Settings.Rank_Cutoff then
                local player_name = data[1]
                local player_total = Col.Damage.Total(player_name, false, false, true)
                local player_percent = Col.Damage.Total(player_name, true, false, true)
                if tonumber(player_percent) >= Metrics.Report.Damage_Threshold then
                    local chat_string = tostring(player_name) .. ": " .. tostring(player_total) .. " (" .. tostring(player_percent) .. "%)"
                    Ashita.Chat.Add_To_Chat(r.Publish.Chat_Mode.Prefix, chat_string) coroutine.sleep(r.Delay)
                    found = true
                end
            end
        end
        if not found then
            Ashita.Chat.Add_To_Chat(r.Publish.Chat_Mode.Prefix, "Nothing to report.") coroutine.sleep(r.Delay)
        end
        r.Lock = false
    end
end

------------------------------------------------------------------------------------------------------
-- Sends a report of total accuracy to game chat.
------------------------------------------------------------------------------------------------------
r.Publish.Accuracy = function()
    if not r.Lock then
        r.Lock = true
        local found = false
        Ashita.Chat.Add_To_Chat(r.Publish.Chat_Mode.Prefix, "Total Accuracy") coroutine.sleep(r.Delay)
        DB.Lists.Sort.Total_Damage()
        for rank, data in ipairs(DB.Sorted.Total_Damage) do
            if rank <= Metrics.Team.Settings.Rank_Cutoff then
                local player_name = data[1]
                local player_acc = Col.Acc.By_Type(player_name, DB.Enum.Values.COMBINED, false, nil, true)
                local chat_string = tostring(player_name) .. ": " .. tostring(player_acc) .. "%"
                Ashita.Chat.Add_To_Chat(r.Publish.Chat_Mode.Prefix, chat_string) coroutine.sleep(r.Delay)
                found = true
            end
        end
        if not found then
            Ashita.Chat.Add_To_Chat(r.Publish.Chat_Mode.Prefix, "Nothing to report.") coroutine.sleep(r.Delay)
        end
        r.Lock = false
    end
end

------------------------------------------------------------------------------------------------------
-- Sends a report of total healing to game chat.
------------------------------------------------------------------------------------------------------
---@param trackable string
------------------------------------------------------------------------------------------------------
r.Publish.Damage_By_Type = function(trackable)
    if not trackable then
        Ashita.Chat.Add_To_Chat(r.Publish.Chat_Mode.Prefix, "Error") coroutine.sleep(r.Delay)
        return nil
    end

    if not r.Lock then
        r.Lock = true
        local found = false
        Ashita.Chat.Add_To_Chat(r.Publish.Chat_Mode.Prefix, "Total " .. tostring(trackable)) coroutine.sleep(r.Delay)
        local sorted_damage = DB.Lists.Sort.Damage_By_Type(trackable)
        for rank, data in ipairs(sorted_damage) do
            if rank <= Metrics.Team.Settings.Rank_Cutoff then
                local player_name = data[1]
                local player_damage = Col.Damage.By_Type(player_name, trackable, false, nil, true)
                local player_percent = Col.Damage.Percent_Total_By_Type(player_name, trackable, nil, true)
                if tonumber(player_percent) >= Metrics.Report.Damage_Threshold then
                    local chat_string = tostring(player_name) .. ": " .. tostring(player_damage) .. " (" .. tostring(player_percent) .. "%)"
                    Ashita.Chat.Add_To_Chat(r.Publish.Chat_Mode.Prefix, chat_string) coroutine.sleep(r.Delay)
                    found = true
                end
            end
        end
        if not found then
            Ashita.Chat.Add_To_Chat(r.Publish.Chat_Mode.Prefix, "Nothing to report.") coroutine.sleep(r.Delay)
        end
        r.Lock = false
    end
end

------------------------------------------------------------------------------------------------------
-- Sends a report of cataloged damage to game chat.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param focus_type string
------------------------------------------------------------------------------------------------------
r.Publish.Catalog = function(player_name, focus_type)
    if not player_name then
        Ashita.Chat.Message("There was an error trying to publish: No player name provided.")
        return nil
    end
    if not focus_type then focus_type = DB.Enum.Trackable.WS end
    if not DB.Lists.Check.Catalog_Exists(player_name, focus_type) then
        Ashita.Chat.Message(tostring(player_name) .. " doesn't have " .. tostring(focus_type) .. " data to publish.")
        return nil
    end

    if not r.Lock then
        r.Lock = true
        local found = false
        Ashita.Chat.Add_To_Chat(r.Publish.Chat_Mode.Prefix, tostring(focus_type) .. " for " .. tostring(player_name)) coroutine.sleep(r.Delay)
        Ashita.Chat.Add_To_Chat(r.Publish.Chat_Mode.Prefix, "Total | Count | Average | Min | Max") coroutine.sleep(r.Delay)
        local action_name
        DB.Lists.Sort.Catalog_Damage(player_name, focus_type)
        for _, data in ipairs(DB.Sorted.Catalog_Damage) do
            action_name = data[1]
            local total = Col.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.TOTAL, false, true)
            local count = Col.Single.Attempts(player_name, action_name, focus_type, true)
            local average = Col.Single.Average(player_name, action_name, focus_type, true)
            local min = Col.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.MIN, false, true)
            if min == "100000" then min = "0" end
            local max = Col.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.MAX, false, true)
            local chat_string = tostring(action_name) .. ": " .. tostring(total) .. " | " .. tostring(count) .. " | " 
                                .. tostring(average) .. " | " .. tostring(min) .. " | " .. tostring(max)
            Ashita.Chat.Add_To_Chat(r.Publish.Chat_Mode.Prefix, chat_string) coroutine.sleep(r.Delay)
            found = true
        end
        if not found then
            Ashita.Chat.Add_To_Chat(r.Publish.Chat_Mode.Prefix, "Nothing to report.") coroutine.sleep(r.Delay)
        end
        r.Lock = false
    end
end

------------------------------------------------------------------------------------------------------
-- Creates a button to publish certain cataloged actions to the screen.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param focus_type string
---@param caption? string
------------------------------------------------------------------------------------------------------
r.Publish.Button = function(player_name, focus_type, caption)
    if not caption then caption = "Publish" end
    if UI.Button(caption) then
        r.Publish.Catalog(player_name, focus_type)
    end
end

------------------------------------------------------------------------------------------------------
-- Creates a dropdown menu to show only damage done by a certain entity.
------------------------------------------------------------------------------------------------------
r.Dropdown = function()
    local list = Ashita.Chat.Modes
    local flags = Window.Dropdown.Flags
    if list[1] then
        UI.SetNextItemWidth(Ashita.Chat.Selection.Width)
        if UI.BeginCombo(Ashita.Chat.Selection.Title, list[r.Publish.Chat_Index].Name, flags) then
            for n = 1, #list, 1 do
                local is_selected = Ashita.Chat.Selection.Index == n
                if UI.Selectable(list[n].Name, is_selected) then
                    r.Publish.Chat_Index = n
                    r.Publish.Chat_Mode = list[n]
                end
                if is_selected then
                    UI.SetItemDefaultFocus()
                end
            end
            UI.EndCombo()
        end
    else
        if UI.BeginCombo(Ashita.Chat.Selection.Title, Ashita.Enum.Chat.PARTY, flags) then
            UI.EndCombo()
        end
    end
end

return r