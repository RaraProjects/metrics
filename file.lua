File = {}

File.Addend_Path = "config\\Metrics"
File.Delimiter = ","
File.Pattern  = "([^" .. File.Delimiter .. "]+)"

-- ------------------------------------------------------------------------------------------------------
-- Write to file for the basic data.
-- ------------------------------------------------------------------------------------------------------
File.Save_Data = function()
    local path = File.Path()
    File.File_Exists(path)

    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.TargetString.ME)
    if not player then return nil end
    local filename = tostring(os.date("%m-%d-%Y %H-%M-%S Database ", os.time()) .. " " .. tostring(player.name) .. ".csv")

    ---@diagnostic disable-next-line: undefined-field
    local file = io.open(('%s/%s'):fmt(path, filename), "w")
    if file ~= nil then
        -- Headers
        file:write(tostring("Player")    .. File.Delimiter ..
                   tostring("Pet")       .. File.Delimiter ..
                   tostring("Target")    .. File.Delimiter ..
                   tostring("Action")    .. File.Delimiter ..
                   tostring("Trackable") .. File.Delimiter ..
                   tostring("Metric")    .. File.Delimiter ..
                   tostring("Value") .. "\n")

        -- Basic Player Data
        for player_name, _ in pairs(DB.Parse) do
            for target_name, _ in pairs(DB.Parse[player_name]) do
                for trackable, _ in pairs(DB.Parse[player_name][target_name]) do
                    for metric, data in pairs(DB.Parse[player_name][target_name][trackable]) do
                        if data and data > 0 then
                            if not (DB.Metric_Needs_Max_Value(metric) and data >= DB.Enum.MAX_DAMAGE) then
                                file:write(tostring(player_name) .. File.Delimiter ..
                                           tostring("")          .. File.Delimiter ..
                                           tostring(target_name) .. File.Delimiter ..
                                           tostring("")          .. File.Delimiter ..
                                           tostring(trackable)   .. File.Delimiter ..
                                           tostring(metric)      .. File.Delimiter ..
                                           tostring(data) .. "\n")
                            end
                        end
                    end
                end
            end
        end

        -- Basic Pet Data
        for player_name, _ in pairs(DB.Pet_Parse) do
            for pet_name, _ in pairs(DB.Pet_Parse[player_name]) do
                for target_name, _ in pairs(DB.Pet_Parse[player_name][pet_name]) do
                    for trackable, _ in pairs(DB.Pet_Parse[player_name][pet_name][target_name]) do
                        for metric, data in pairs(DB.Pet_Parse[player_name][pet_name][target_name][trackable]) do
                            if data and data > 0 then
                                if not (DB.Metric_Needs_Max_Value(metric) and data >= DB.Enum.MAX_DAMAGE) then
                                    file:write(tostring(player_name) .. File.Delimiter ..
                                               tostring(pet_name)    .. File.Delimiter ..
                                               tostring(target_name) .. File.Delimiter ..
                                               tostring("")          .. File.Delimiter ..
                                               tostring(trackable)   .. File.Delimiter ..
                                               tostring(metric)      .. File.Delimiter ..
                                               tostring(data) .. "\n")
                                end
                            end
                        end
                    end
                end
            end
        end

        -- Catalog Player Data
        for player_name, _ in pairs(DB.Parse_Catalog) do
            for target_name, _ in pairs(DB.Parse_Catalog[player_name]) do
                for action_name, _ in pairs(DB.Parse_Catalog[player_name][target_name]) do
                    for trackable, _ in pairs(DB.Parse_Catalog[player_name][target_name][action_name]) do
                        for metric, data in pairs(DB.Parse_Catalog[player_name][target_name][action_name][trackable]) do
                            if data and data > 0 then
                                if not (DB.Metric_Needs_Max_Value(metric) and data >= DB.Enum.MAX_DAMAGE) then
                                    file:write(tostring(player_name)  .. File.Delimiter ..
                                                tostring("")          .. File.Delimiter ..
                                                tostring(target_name) .. File.Delimiter ..
                                                tostring(action_name) .. File.Delimiter ..
                                                tostring(trackable)   .. File.Delimiter ..
                                                tostring(metric)      .. File.Delimiter ..
                                                tostring(data) .. "\n")
                                end
                            end
                        end
                    end
                end
            end
        end

        -- Catalog Pet Data
        for player_name, _ in pairs(DB.Pet_Parse_Catalog) do
            for pet_name, _ in pairs(DB.Pet_Parse_Catalog[player_name]) do
                for target_name, _ in pairs(DB.Pet_Parse_Catalog[player_name][pet_name]) do
                    for action_name, _ in pairs(DB.Pet_Parse_Catalog[player_name][pet_name][target_name]) do
                        for trackable, _ in pairs(DB.Pet_Parse_Catalog[player_name][pet_name][target_name][action_name]) do
                            for metric, data in pairs(DB.Pet_Parse_Catalog[player_name][pet_name][target_name][action_name][trackable]) do
                                if data and data > 0 then
                                    if not (DB.Metric_Needs_Max_Value(metric) and data >= DB.Enum.MAX_DAMAGE) then
                                        file:write(tostring(player_name)  .. File.Delimiter ..
                                                    tostring(pet_name)    .. File.Delimiter ..
                                                    tostring(target_name) .. File.Delimiter ..
                                                    tostring(action_name) .. File.Delimiter ..
                                                    tostring(trackable)   .. File.Delimiter ..
                                                    tostring(metric)      .. File.Delimiter ..
                                                    tostring(data) .. "\n")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        file:close()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Write to file for the battle log data.
-- ------------------------------------------------------------------------------------------------------
File.Save_Battlelog = function()
    local path = File.Path()
    File.File_Exists(path)

    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.TargetString.ME)
    if not player then return nil end
    local filename = tostring(os.date("%m-%d-%Y %H-%M-%S Battle Log ", os.time()) .. tostring(player.name) .. ".csv")

    ---@diagnostic disable-next-line: undefined-field
    local file = io.open(('%s/%s'):fmt(path, filename), "w")
    if file ~= nil then
        file:write(tostring("Time") .. File.Delimiter .. tostring("Flag") .. File.Delimiter .. tostring("Player Name") .. File.Delimiter
                .. tostring("Pet Name") .. File.Delimiter.. tostring("Damage") .. File.Delimiter .. tostring("Action") .. File.Delimiter .. tostring("Note") .. "\n")
        for _, data in pairs(Blog.Log) do
            local time        = data.Time
            local flag        = data.Flag
            local player_name = data.Player
            local pet_name    = data.Pet
            local damage      = data.Damage
            local action      = data.Action
            local note        = data.Note
            if not time or not flag or  not player_name or not pet_name or not damage or not action or not note then
                Debug.Error.Add(Debug.Error.ERROR, "File.Save_Battlelog", "Nil data: Time " .. tostring(time) .. " Flag: " .. tostring(flag) " Player Name: " .. tostring(player_name)
                              .. " Pet Name: " .. tostring(pet_name) .. " Damage: " .. tostring(damage) .. " Action: " .. tostring(action) .. " Note: " .. tostring(note))
            else
                file:write(tostring(time.Value) .. File.Delimiter .. tostring(flag.Value) .. File.Delimiter .. tostring(player_name.Value) .. File.Delimiter
                        .. tostring(pet_name.Value) .. File.Delimiter .. tostring(damage.Value) .. File.Delimiter .. tostring(action.Value) .. File.Delimiter
                        .. tostring(note.Value) .. "\n")
            end
        end
        file:close()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Write to file for the item tracking data.
-- ------------------------------------------------------------------------------------------------------
File.Save_Loot = function()
    local path = File.Path()
    File.File_Exists(path)

    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.TargetString.ME)
    if not player then return nil end
    local filename = tostring(os.date("%m-%d-%Y %H-%M-%S Loot ", os.time()) .. tostring(player.name) .. ".csv")

    ---@diagnostic disable-next-line: undefined-field
    local file = io.open(('%s/%s'):fmt(path, filename), "w")
    if file ~= nil then
        file:write(tostring("Entity Type") .. File.Delimiter .. tostring("Entity Name") .. File.Delimiter .. tostring("Item Name") .. File.Delimiter
                .. tostring("Item Count") .. File.Delimiter .. tostring("Defeated Count (Mobs)") .. "\n")

        local entity_type = "Player"
        for player_name, item_data in pairs(DB.Tracking.Received_Items) do
            for item_name, item_count in pairs(item_data) do
                file:write(
                tostring(entity_type) .. File.Delimiter .. tostring(player_name) .. File.Delimiter .. tostring(item_name) .. File.Delimiter ..
                tostring(item_count) .. File.Delimiter .. tostring(0) .. "\n")
            end
        end

        entity_type = "Mob"
        for mob_name, item_data in pairs(DB.Tracking.Drop_Rates) do
            for item_name, drop_count in pairs(item_data) do
                local defeated_count = DB.Tracking.Defeated_Mobs[mob_name] or 1
                file:write(
                tostring(entity_type) .. File.Delimiter .. tostring(mob_name) .. File.Delimiter .. tostring(item_name) .. File.Delimiter ..
                tostring(drop_count) .. File.Delimiter .. tostring(defeated_count) .. "\n")
            end
        end

        file:close()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Create the base file path.
-- ------------------------------------------------------------------------------------------------------
File.Path = function()
    local directory = tostring(AshitaCore:GetInstallPath()) .. File.Addend_Path
    ---@diagnostic disable-next-line: undefined-field
    return ('%s/'):fmt(directory)
end

-- ------------------------------------------------------------------------------------------------------
-- Check if the base directory exists. If it doesn't, create it.
-- ------------------------------------------------------------------------------------------------------
---@param path string
-- ------------------------------------------------------------------------------------------------------
File.File_Exists = function(path)
    if not ashita.fs.exists(path) then
        ashita.fs.create_dir(path)
    end
end