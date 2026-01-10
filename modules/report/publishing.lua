Report.Publishing = { }

Report.Publishing.Delay     = 1.80
Report.Publishing.Lock      = false                -- Stops multiple reports from being pushed to chat at the same time.
Report.Publishing.ChatIndex = 1
Report.Publishing.ChatMode  = Ashita.Chat.Modes[1] -- Party

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
        Ashita.Chat.AddToChat(Report.Publishing.ChatMode.Prefix, "Total Damage and Accuracy") coroutine.sleep(Report.Publishing.Delay)

        local sortedDamage = DB.Lists.GetSortedDataDamage()

        for rank, data in ipairs(sortedDamage) do
            if rank <= Parse.Config.RankCutoff() then

                local playerName    = data[1]
                local playerTotal   = Column.Damage.Total(playerName, false, false, true)
                local playerPercent = Column.Damage.Total(playerName, true, false, true)
                local playerAcc     = Column.Acc.ByType(playerName, DB.Enum.COMBINED, nil, false, nil, false, true)

                -- Only output if damage is above certain threshold to prevent a lot of waiting for long lists.
                if tonumber(playerPercent) >= Report.Settings.Damage_Threshold then
                    local chatString = tostring(playerName) .. ": " ..
                                       tostring(playerTotal) ..
                                       " (" .. tostring(playerPercent) .. "%) " ..
                                       "Acc: " .. tostring(playerAcc) .. "%"

                    Ashita.Chat.AddToChat(Report.Publishing.ChatMode.Prefix, chatString) coroutine.sleep(Report.Publishing.Delay)
                    found = true
                end
            end
        end

        if not found then
            Ashita.Chat.AddToChat(Report.Publishing.ChatMode.Prefix, "Nothing to report.") coroutine.sleep(Report.Publishing.Delay)
        end

        Report.Publishing.Lock = false
    end
end

------------------------------------------------------------------------------------------------------
-- Sends a report of total damage to game chat.
------------------------------------------------------------------------------------------------------
---@param trackable DB.Trackable
------------------------------------------------------------------------------------------------------
Report.Publishing.DamageByType = function(trackable)
    if not trackable then
        Ashita.Chat.AddToChat(Report.Publishing.ChatMode.Prefix, "Error") coroutine.sleep(Report.Publishing.Delay)
        return nil
    end

    if not Report.Publishing.Lock then
        Report.Publishing.Lock = true
        local found = false
        local suffix = DB.Trackable.SPELLS_HEALING and "" or " Damage"

        -- Header
        Ashita.Chat.AddToChat(Report.Publishing.ChatMode.Prefix, "Total " .. tostring(trackable) .. tostring(suffix)) coroutine.sleep(Report.Publishing.Delay)

        -- Loop through the data.
        local sortedDamage = DB.Lists.GetSortedDataDamage(trackable)

        for rank, data in ipairs(sortedDamage) do
            if rank <= Parse.Config.RankCutoff() then

                local playerName    = data[1]
                local playerDamage  = Column.Damage.ByType(playerName, trackable, nil, nil, false, nil, true)
                local playerPercent = Column.Damage.PercentTotalByType(playerName, trackable, nil, true)

                if tonumber(playerPercent) >= Report.Settings.Damage_Threshold then
                    local chatString = tostring(playerName) .. ": " .. tostring(playerDamage) .. " (" .. tostring(playerPercent) .. "%)"
                    found = true

                    Ashita.Chat.AddToChat(Report.Publishing.ChatMode.Prefix, chatString) coroutine.sleep(Report.Publishing.Delay)
                end

            end
        end

        if not found then
            Ashita.Chat.AddToChat(Report.Publishing.ChatMode.Prefix, "Nothing to report.") coroutine.sleep(Report.Publishing.Delay)
        end

        Report.Publishing.Lock = false
    end
end

------------------------------------------------------------------------------------------------------
-- Sends a report of cataloged damage to game chat.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable
------------------------------------------------------------------------------------------------------
Report.Publishing.Catalog = function(playerName, trackable)
    if not playerName then
        Ashita.Chat.Echo("There was an error trying to publish: No player name provided.")
        return nil
    end

    trackable = trackable or DB.Trackable.WEAPONSKILL

    if not DB.Lists.CatalogExists(playerName, trackable) then
        Ashita.Chat.Echo(tostring(playerName) .. " doesn't have " .. tostring(trackable) .. " data to publish.")
        return nil
    end

    if not Report.Publishing.Lock then
        Report.Publishing.Lock = true
        local found = false

        -- Headers
        Ashita.Chat.AddToChat(Report.Publishing.ChatMode.Prefix, tostring(trackable) .. " for " .. tostring(playerName)) coroutine.sleep(Report.Publishing.Delay)
        Ashita.Chat.AddToChat(Report.Publishing.ChatMode.Prefix, "WS: Total (Count) ~Average Min<Max") coroutine.sleep(Report.Publishing.Delay)

        -- Loop through weaponskill data.
        local sortedCatalogDamage = DB.Lists.GetSortedPlayerCatalogDamage(playerName, trackable)

        for _, data in ipairs(sortedCatalogDamage) do
            local actionName = data[1]
            local total   = Column.Damage.ByType(playerName, trackable, DB.Metric.TOTAL, actionName, false, false, true)
            local count   = Column.Damage.Attempts(playerName, trackable, nil, actionName, nil, true)
            local average = Column.Damage.ByTypeAverage(playerName, trackable, nil, actionName, nil, true)
            local max     = Column.Damage.ByType(playerName, trackable, DB.Metric.MAX, actionName, false, false, true)
            local min     = Column.Damage.ByType(playerName, trackable, DB.Metric.MIN, actionName, false, false, true)

            if min == tostring(DB.Enum.MAX_DAMAGE) then
                min = "0"
            end

            local chatString = tostring(actionName) .. ": " ..
                               tostring(total) ..
                               " (" .. tostring(count) .. ")" ..
                               " ~" .. tostring(average) ..
                               " "  .. tostring(min) ..
                               "<"  .. tostring(max)

            Ashita.Chat.AddToChat(Report.Publishing.ChatMode.Prefix, chatString) coroutine.sleep(Report.Publishing.Delay)

            found = true
        end

        if not found then
            Ashita.Chat.AddToChat(Report.Publishing.ChatMode.Prefix, "Nothing to report.") coroutine.sleep(Report.Publishing.Delay)
        end

        Report.Publishing.Lock = false
    end
end