Report.Publishing = T{}

Report.Publishing.Delay = 1.80
Report.Publishing.Lock = false  -- Stops multiple reports from being pushed to chat at the same time.
Report.Publishing.Chat_Index = 1
Report.Publishing.Chat_Mode = Ashita.Chat.Modes[1] -- Party

-- The screen flickers when publishing to the chat. I think it has to do with the sleep after each line.
-- The sleep is necessary because the chat can only accept inputs at a certain rate.

------------------------------------------------------------------------------------------------------
-- Sends a report of total damage to game chat.
------------------------------------------------------------------------------------------------------
Report.Publishing.Total_Damage = function()
    if not Report.Publishing.Lock then
        Report.Publishing.Lock = true
        local found = false
        Ashita.Chat.Add_To_Chat(Report.Publishing.Chat_Mode.Prefix, "Total Damage") coroutine.sleep(Report.Publishing.Delay)
        DB.Lists.Sort.Total_Damage()
        for rank, data in ipairs(DB.Sorted.Total_Damage) do
            if rank <= Metrics.Team.Settings.Rank_Cutoff then
                local player_name = data[1]
                local player_total = Col.Damage.Total(player_name, false, false, true)
                local player_percent = Col.Damage.Total(player_name, true, false, true)
                if tonumber(player_percent) >= Metrics.Report.Damage_Threshold then
                    local chat_string = tostring(player_name) .. ": " .. tostring(player_total) .. " (" .. tostring(player_percent) .. "%)"
                    Ashita.Chat.Add_To_Chat(Report.Publishing.Chat_Mode.Prefix, chat_string) coroutine.sleep(Report.Publishing.Delay)
                    found = true
                end
            end
        end
        if not found then
            Ashita.Chat.Add_To_Chat(Report.Publishing.Chat_Mode.Prefix, "Nothing to report.") coroutine.sleep(Report.Publishing.Delay)
        end
        Report.Publishing.Lock = false
    end
end

------------------------------------------------------------------------------------------------------
-- Sends a report of total accuracy to game chat.
------------------------------------------------------------------------------------------------------
Report.Publishing.Accuracy = function()
    if not Report.Publishing.Lock then
        Report.Publishing.Lock = true
        local found = false
        Ashita.Chat.Add_To_Chat(Report.Publishing.Chat_Mode.Prefix, "Total Accuracy") coroutine.sleep(Report.Publishing.Delay)
        DB.Lists.Sort.Total_Damage()
        for rank, data in ipairs(DB.Sorted.Total_Damage) do
            if rank <= Metrics.Team.Settings.Rank_Cutoff then
                local player_name = data[1]
                local player_acc = Col.Acc.By_Type(player_name, DB.Enum.Values.COMBINED, false, nil, true)
                local chat_string = tostring(player_name) .. ": " .. tostring(player_acc) .. "%"
                Ashita.Chat.Add_To_Chat(Report.Publishing.Chat_Mode.Prefix, chat_string) coroutine.sleep(Report.Publishing.Delay)
                found = true
            end
        end
        if not found then
            Ashita.Chat.Add_To_Chat(Report.Publishing.Chat_Mode.Prefix, "Nothing to report.") coroutine.sleep(Report.Publishing.Delay)
        end
        Report.Publishing.Lock = false
    end
end

------------------------------------------------------------------------------------------------------
-- Sends a report of total healing to game chat.
------------------------------------------------------------------------------------------------------
---@param trackable string
------------------------------------------------------------------------------------------------------
Report.Publishing.Damage_By_Type = function(trackable)
    if not trackable then
        Ashita.Chat.Add_To_Chat(Report.Publishing.Chat_Mode.Prefix, "Error") coroutine.sleep(Report.Publishing.Delay)
        return nil
    end

    if not Report.Publishing.Lock then
        Report.Publishing.Lock = true
        local found = false
        local suffix = " Damage"
        if trackable == DB.Enum.Trackable.HEALING then suffix = "" end
        Ashita.Chat.Add_To_Chat(Report.Publishing.Chat_Mode.Prefix, "Total " .. tostring(trackable) .. tostring(suffix)) coroutine.sleep(Report.Publishing.Delay)
        local sorted_damage = DB.Lists.Sort.Damage_By_Type(trackable)
        for rank, data in ipairs(sorted_damage) do
            if rank <= Metrics.Team.Settings.Rank_Cutoff then
                local player_name = data[1]
                local player_damage = Col.Damage.By_Type(player_name, trackable, false, nil, true)
                local player_percent = Col.Damage.Percent_Total_By_Type(player_name, trackable, nil, true)
                if tonumber(player_percent) >= Metrics.Report.Damage_Threshold then
                    local chat_string = tostring(player_name) .. ": " .. tostring(player_damage) .. " (" .. tostring(player_percent) .. "%)"
                    Ashita.Chat.Add_To_Chat(Report.Publishing.Chat_Mode.Prefix, chat_string) coroutine.sleep(Report.Publishing.Delay)
                    found = true
                end
            end
        end
        if not found then
            Ashita.Chat.Add_To_Chat(Report.Publishing.Chat_Mode.Prefix, "Nothing to report.") coroutine.sleep(Report.Publishing.Delay)
        end
        Report.Publishing.Lock = false
    end
end

------------------------------------------------------------------------------------------------------
-- Sends a report of cataloged damage to game chat.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param focus_type string
------------------------------------------------------------------------------------------------------
Report.Publishing.Catalog = function(player_name, focus_type)
    if not player_name then
        Ashita.Chat.Message("There was an error trying to publish: No player name provided.")
        return nil
    end
    if not focus_type then focus_type = DB.Enum.Trackable.WS end
    if not DB.Lists.Check.Catalog_Exists(player_name, focus_type) then
        Ashita.Chat.Message(tostring(player_name) .. " doesn't have " .. tostring(focus_type) .. " data to publish.")
        return nil
    end

    if not Report.Publishing.Lock then
        Report.Publishing.Lock = true
        local found = false
        Ashita.Chat.Add_To_Chat(Report.Publishing.Chat_Mode.Prefix, tostring(focus_type) .. " for " .. tostring(player_name)) coroutine.sleep(Report.Publishing.Delay)
        Ashita.Chat.Add_To_Chat(Report.Publishing.Chat_Mode.Prefix, "Total | Count | Average | Min | Max") coroutine.sleep(Report.Publishing.Delay)
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
            Ashita.Chat.Add_To_Chat(Report.Publishing.Chat_Mode.Prefix, chat_string) coroutine.sleep(Report.Publishing.Delay)
            found = true
        end
        if not found then
            Ashita.Chat.Add_To_Chat(Report.Publishing.Chat_Mode.Prefix, "Nothing to report.") coroutine.sleep(Report.Publishing.Delay)
        end
        Report.Publishing.Lock = false
    end
end