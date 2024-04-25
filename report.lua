local r = {}

r.Publish = {}
r.Data = {}
r.Delay = 1.50

-- The screen flickers when publishing to the chat. I think it has to do with the sleep after each line.
-- The sleep is necessary because the chat can only accept inputs at a certain rate.

------------------------------------------------------------------------------------------------------
-- Creates some buttons to publish various party metrics to chat.
------------------------------------------------------------------------------------------------------
r.Populate = function()
    local col_flags = Window.Columns.Flags.None
    local width = Window.Columns.Widths.Report
    if UI.BeginTable("Reports", 4, Window.Table.Flags.Team) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextRow()
        UI.TableNextColumn()
        if UI.Button("Total Damage") then
            r.Publish.Total_Damage()
            return nil
        end
        UI.TableNextColumn()
        if UI.Button("Accuracy") then
            r.Publish.Accuracy()
            return nil
        end
        UI.TableNextColumn()
        UI.TableNextColumn()
        --
        UI.TableNextColumn()
        if UI.Button("Melee") then
            r.Publish.Damage_By_Type(Model.Enum.Trackable.MELEE)
            return nil
        end
        UI.TableNextColumn()
        if UI.Button("Weaponskills") then
            r.Publish.Damage_By_Type(Model.Enum.Trackable.WS)
            return nil
        end
        UI.TableNextColumn()
        if UI.Button("Magic") then
            r.Publish.Damage_By_Type(Model.Enum.Trackable.MAGIC)
            return nil
        end
        UI.TableNextColumn()
        if UI.Button("Pet") then
            r.Publish.Damage_By_Type(Model.Enum.Trackable.PET)
            return nil
        end
        --
        UI.TableNextColumn()
        if UI.Button("Healing") then
            r.Publish.Damage_By_Type(Model.Enum.Trackable.HEALING)
            return nil
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sends a report of total damage to game chat.
------------------------------------------------------------------------------------------------------
r.Publish.Total_Damage = function()
    A.Chat.Add_To_Chat(A.Enum.Chat.PARTY, "Total Damage") coroutine.sleep(r.Delay)
    Model.Sort.Total_Damage()
    for rank, data in ipairs(Model.Data.Total_Damage_Sorted) do
        if rank <= Metrics.Team.Settings.Rank_Cutoff then
            local player_name = data[1]
            local player_total = Col.Damage.Total(player_name, false, false, true)
            local player_percent = Col.Damage.Total(player_name, true, false, true)
            local chat_string = tostring(player_name) .. ": " .. tostring(player_total) .. " (" .. tostring(player_percent) .. "%)"
            A.Chat.Add_To_Chat(A.Enum.Chat.PARTY, chat_string) coroutine.sleep(r.Delay)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Sends a report of total accuracy to game chat.
------------------------------------------------------------------------------------------------------
r.Publish.Accuracy = function()
    A.Chat.Add_To_Chat(A.Enum.Chat.PARTY, "Total Accuracy") coroutine.sleep(r.Delay)
    Model.Sort.Total_Damage()
    for rank, data in ipairs(Model.Data.Total_Damage_Sorted) do
        if rank <= Metrics.Team.Settings.Rank_Cutoff then
            local player_name = data[1]
            local player_acc = Col.Acc.By_Type(player_name, Model.Enum.Misc.COMBINED, false, nil, true)
            local chat_string = tostring(player_name) .. ": " .. tostring(player_acc) .. "%"
            A.Chat.Add_To_Chat(A.Enum.Chat.PARTY, chat_string) coroutine.sleep(r.Delay)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Sends a report of total healing to game chat.
------------------------------------------------------------------------------------------------------
---@param trackable string
------------------------------------------------------------------------------------------------------
r.Publish.Damage_By_Type = function(trackable)
    if not trackable then
        A.Chat.Add_To_Chat(A.Enum.Chat.PARTY, "Error") coroutine.sleep(r.Delay)
        return nil
    end
    A.Chat.Add_To_Chat(A.Enum.Chat.PARTY, "Total " .. tostring(trackable)) coroutine.sleep(r.Delay)
    local sorted_damage = Model.Sort.Damage_By_Type(trackable)
    for rank, data in ipairs(sorted_damage) do
        if rank <= Metrics.Team.Settings.Rank_Cutoff then
            local player_name = data[1]
            local player_damage = Col.Damage.By_Type(player_name, trackable, false, nil, true)
            local player_percent = Col.Damage.By_Type(player_name, trackable, true, nil, true)
            local chat_string = tostring(player_name) .. ": " .. tostring(player_damage) .. " (" .. tostring(player_percent) .. "%)"
            A.Chat.Add_To_Chat(A.Enum.Chat.PARTY, chat_string) coroutine.sleep(r.Delay)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Sends a report of cataloged damage to game chat.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param focus_type string
---@param total? boolean true: raw total damage; false: average damage
------------------------------------------------------------------------------------------------------
r.Publish.Catalog = function(player_name, focus_type, total)
    if not player_name then
        A.Chat.Add_To_Chat(A.Enum.Chat.PARTY, "Error") coroutine.sleep(r.Delay)
        return nil
    end
    if not focus_type then focus_type = Model.Enum.Trackable.WS end
    local type = " (Avg)"
    if total then type = "" end
    A.Chat.Add_To_Chat(A.Enum.Chat.PARTY, tostring(focus_type) .. " for " .. tostring(player_name) .. type) coroutine.sleep(r.Delay)
    local action_name
    Model.Sort.Catalog_Damage(player_name, focus_type)
    local damage
    for _, data in ipairs(Model.Data.Catalog_Damage_Race) do
        action_name = data[1]
        if total then
            damage = Col.Single.Damage(player_name, action_name, focus_type, Model.Enum.Metric.TOTAL, false, true)
        else
            damage = Col.Single.Average(player_name, action_name, focus_type, true)
        end
        local chat_string = tostring(action_name) .. ": " .. tostring(damage)
        A.Chat.Add_To_Chat(A.Enum.Chat.PARTY, chat_string) coroutine.sleep(r.Delay)
    end
end

------------------------------------------------------------------------------------------------------
-- Creates a button to publish certain cataloged actions to the screen.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param focus_type string
------------------------------------------------------------------------------------------------------
r.Publish.Button = function(player_name, focus_type)
    if UI.Button("Publish") then
        r.Publish.Catalog(player_name, focus_type)
    end
end

return r