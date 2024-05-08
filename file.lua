File = T{}

File.Addend_Path = "config\\Metrics"
File.Delimter = ","
File.Pattern  = "([^" .. File.Delimter .. "]+)"

-- ------------------------------------------------------------------------------------------------------
-- Write to file for the basic data.
-- ------------------------------------------------------------------------------------------------------
File.Save_Data = function()
    local path = File.Path()
    File.File_Exists(path)

    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    if not player then return nil end
    local filename = tostring(os.date("%m-%d-%Y %H-%M-%S Basic ", os.time()) .. " " .. tostring(player.name) .. ".csv")

    ---@diagnostic disable-next-line: undefined-field
    local file = io.open(('%s/%s'):fmt(path, filename), "w")
    if file ~= nil then
        file:write(tostring("Actor") .. File.Delimter .. tostring("Target") .. File.Delimter .. tostring("Trackable") .. File.Delimter
                .. tostring("Metric") .. File.Delimter .. tostring("Value") .. "\n")
        for index, trackable_data in pairs(DB.Parse) do
            for trackable, metric_data in pairs(trackable_data) do
                for metric, data in pairs(metric_data) do
                    if not metric or not data then
                        _Debug.Error.Add("File.Save_Data: Nil data: Metric: " .. tostring(metric) .. " Data: " .. tostring(data))
                    elseif metric ~= DB.Enum.Values.CATALOG and data > 0 then
                        local player_target = index:gsub(":", File.Delimter)
                        file:write(tostring(player_target) .. File.Delimter .. tostring(trackable) .. File.Delimter
                                .. tostring(metric) .. File.Delimter .. tostring(data) .. "\n")
                    end
                end
            end
        end
        file:close()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Write to file for cataloged data.
-- ------------------------------------------------------------------------------------------------------
File.Save_Catalog = function()
    local path = File.Path()
    File.File_Exists(path)

    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    if not player then return nil end
    local filename = tostring(os.date("%m-%d-%Y %H-%M-%S Catalog ", os.time()) .. tostring(player.name) .. ".csv")

    ---@diagnostic disable-next-line: undefined-field
    local file = io.open(('%s/%s'):fmt(path, filename), "w")
    if file ~= nil then
        file:write(tostring("Actor") .. File.Delimter .. tostring("Target") .. File.Delimter .. tostring("Trackable") .. File.Delimter
                .. tostring("Action") .. File.Delimter .. tostring("Metric") .. File.Delimter .. tostring("Value") .. "\n")
        for index, trackable_data in pairs(DB.Parse) do
            for trackable, metric_data in pairs(trackable_data) do
                for catalog_metric, catalog_data in pairs(metric_data) do
                    if catalog_metric == DB.Enum.Values.CATALOG then
                        for action_name, action_data in pairs(catalog_data) do
                            for metric, data in pairs(action_data) do
                                if not metric or not data then
                                    _Debug.Error.Add("File.Save_Catalog: Nil data: Metric: " .. tostring(metric) .. " Data: " .. tostring(data))
                                elseif data > 0 then
                                    local player_target = index:gsub(":", File.Delimter)
                                    file:write(tostring(player_target) .. File.Delimter .. tostring(trackable) .. File.Delimter
                                        .. tostring(action_name) .. File.Delimter .. tostring(metric) .. File.Delimter .. tostring(data) .. "\n")
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

    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    if not player then return nil end
    local filename = tostring(os.date("%m-%d-%Y %H-%M-%S Battle Log ", os.time()) .. tostring(player.name) .. ".csv")

    ---@diagnostic disable-next-line: undefined-field
    local file = io.open(('%s/%s'):fmt(path, filename), "w")
    if file ~= nil then
        file:write(tostring("Time") .. File.Delimter .. tostring("Name") .. File.Delimter
                .. tostring("Damage") .. File.Delimter .. tostring("Action") .. File.Delimter .. tostring("Note") .. "\n")
        for _, data in pairs(Blog.Log) do
            local time = data.Time
            local name = data.Name
            local damage = data.Damage
            local action = data.Action
            local note = data.Note
            if not time or not name or not damage or not action or not note then
                _Debug.Error.Add("File.Save_Battlelog: Nil data: Time " .. tostring(time) .. " Name: " .. tostring(name.Value)
                              .. " Damage: " .. tostring(damage.Value) .. " Action: " .. tostring(action.Value) .. " Note: " .. tostring(note))
            else
                file:write(tostring(time) .. File.Delimter .. tostring(name.Value) .. File.Delimter
                        .. tostring(damage.Value) .. File.Delimter .. tostring(action.Value) .. File.Delimter .. tostring(note) .. "\n")
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