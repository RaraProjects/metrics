Report.Publishing = {}

Report.Publishing.Delay = 1.80
Report.Publishing.Lock = false  -- Stops multiple reports from being pushed to chat at the same time.
Report.Publishing.Chat_Index = 1
Report.Publishing.Chat_Mode = Ashita.Chat.Modes[1] -- Party

-- The screen flickers when publishing to the chat. I think it has to do with the sleep after each line.
-- The sleep is necessary because the chat can only accept inputs at a certain rate.

------------------------------------------------------------------------------------------------------
-- Sends a report of total damage to game chat.
------------------------------------------------------------------------------------------------------
Report.Publishing.Overall = function()
    if not Report.Publishing.Lock then
        Report.Publishing.Lock = true
        local found = false

        -- Chat header.
        Ashita.Chat.AddToChat(Report.Publishing.Chat_Mode.Prefix, "Total Damage and Accuracy") coroutine.sleep(Report.Publishing.Delay)

        local sorted_damage = DB.Lists.Sort.Total_Damage()
        for rank, data in ipairs(sorted_damage) do
            if rank <= Parse.Config.Rank_Cutoff() then

                local player_name = data[1]
                local player_total = Column.Damage.Total(player_name, false, false, true)
                local player_percent = Column.Damage.Total(player_name, true, false, true)
                local player_acc = Column.Acc.By_Type(player_name, DB.Enum.COMBINED, nil, false, nil, false, true)

                -- Only output if damage is above certain threshold to prevent a lot of waiting for long lists.
                if tonumber(player_percent) >= Report.Settings.Damage_Threshold then
                    local chat_string = tostring(player_name) .. ": " ..
                                        tostring(player_total) ..
                                        " (" .. tostring(player_percent) .. "%) " ..
                                        "Acc: " .. tostring(player_acc) .. "%"
                    Ashita.Chat.AddToChat(Report.Publishing.Chat_Mode.Prefix, chat_string) coroutine.sleep(Report.Publishing.Delay)
                    found = true
                end
            end
        end
        if not found then
            Ashita.Chat.AddToChat(Report.Publishing.Chat_Mode.Prefix, "Nothing to report.") coroutine.sleep(Report.Publishing.Delay)
        end
        Report.Publishing.Lock = false
    end
end

------------------------------------------------------------------------------------------------------
-- Sends a report of total damage to game chat.
------------------------------------------------------------------------------------------------------
---@param trackable string
------------------------------------------------------------------------------------------------------
Report.Publishing.Damage_By_Type = function(trackable)
    if not trackable then
        Ashita.Chat.AddToChat(Report.Publishing.Chat_Mode.Prefix, "Error") coroutine.sleep(Report.Publishing.Delay)
        return nil
    end

    if not Report.Publishing.Lock then
        Report.Publishing.Lock = true
        local found = false
        local suffix = " Damage"
        if trackable == DB.Trackable.SPELLS_HEALING then suffix = "" end

        -- Header
        Ashita.Chat.AddToChat(Report.Publishing.Chat_Mode.Prefix, "Total " .. tostring(trackable) .. tostring(suffix)) coroutine.sleep(Report.Publishing.Delay)

        -- Loop through the data.
        local sorted_damage = DB.Lists.Sort.Damage_By_Type(trackable)
        for rank, data in ipairs(sorted_damage) do
            if rank <= Parse.Config.Rank_Cutoff() then

                local player_name = data[1]
                local player_damage = Column.Damage.By_Type(player_name, trackable, nil, nil, false, nil, true)
                local player_percent = Column.Damage.Percent_Total_By_Type(player_name, trackable, nil, true)
                if tonumber(player_percent) >= Report.Settings.Damage_Threshold then
                    local chat_string = tostring(player_name) .. ": " .. tostring(player_damage) .. " (" .. tostring(player_percent) .. "%)"
                    Ashita.Chat.AddToChat(Report.Publishing.Chat_Mode.Prefix, chat_string) coroutine.sleep(Report.Publishing.Delay)
                    found = true
                end

            end
        end

        if not found then
            Ashita.Chat.AddToChat(Report.Publishing.Chat_Mode.Prefix, "Nothing to report.") coroutine.sleep(Report.Publishing.Delay)
        end

        Report.Publishing.Lock = false
    end
end

------------------------------------------------------------------------------------------------------
-- Sends a report of cataloged damage to game chat.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string
------------------------------------------------------------------------------------------------------
Report.Publishing.Catalog = function(player_name, trackable)
    if not player_name then
        Ashita.Chat.Echo("There was an error trying to publish: No player name provided.")
        return nil
    end

    if not trackable then trackable = DB.Trackable.WEAPONSKILL end
    if not DB.Lists.Check.Catalog_Exists(player_name, trackable) then
        Ashita.Chat.Echo(tostring(player_name) .. " doesn't have " .. tostring(trackable) .. " data to publish.")
        return nil
    end

    if not Report.Publishing.Lock then
        Report.Publishing.Lock = true
        local found = false

        -- Headers
        Ashita.Chat.AddToChat(Report.Publishing.Chat_Mode.Prefix, tostring(trackable) .. " for " .. tostring(player_name)) coroutine.sleep(Report.Publishing.Delay)
        Ashita.Chat.AddToChat(Report.Publishing.Chat_Mode.Prefix, "WS: Total (Count) ~Average Min<Max") coroutine.sleep(Report.Publishing.Delay)

        -- Loop through weaponskill data.
        local action_name
        local sorted_catalog_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
        for _, data in ipairs(sorted_catalog_damage) do
            action_name = data[1]
            local total = Column.Damage.By_Type(player_name, trackable, DB.Metric.TOTAL, action_name, false, false, true)
            local count = Column.Damage.Attempts(player_name, trackable, nil, action_name, nil, true)
            local average = Column.Damage.By_Type_Average(player_name, trackable, action_name, nil, nil, true)
            local min = Column.Damage.By_Type(player_name, trackable, DB.Metric.MIN, action_name, false, false, true)
            if min == tostring(DB.Enum.MAX_DAMAGE) then min = "0" end
            local max = Column.Damage.By_Type(player_name, trackable, DB.Metric.MAX, action_name, false, false, true)

            local chat_string = tostring(action_name) .. ": " ..
                                tostring(total) ..
                                " (" .. tostring(count) .. ")" ..
                                " ~" .. tostring(average) ..
                                " "  .. tostring(min) ..
                                "<"  .. tostring(max)
            Ashita.Chat.AddToChat(Report.Publishing.Chat_Mode.Prefix, chat_string) coroutine.sleep(Report.Publishing.Delay)

            found = true
        end

        if not found then
            Ashita.Chat.AddToChat(Report.Publishing.Chat_Mode.Prefix, "Nothing to report.") coroutine.sleep(Report.Publishing.Delay)
        end

        Report.Publishing.Lock = false
    end
end