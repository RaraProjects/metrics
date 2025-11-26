File = { }

File.Addend_Path  = "config\\Metrics"
File.Delimiter    = ","
File.Pattern      = "([^" .. File.Delimiter .. "]+)"

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
File.FileExists = function(path)
    if not ashita.fs.exists(path) then
        ashita.fs.create_dir(path)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Split CSV data into a table.
-- ------------------------------------------------------------------------------------------------------
---@param csvData string
---@return table
-- ------------------------------------------------------------------------------------------------------
File.SplitCSV = function(csvData)
    local fields = {}

    for piece in (csvData .. ","):gmatch("([^,]*),") do
        table.insert(fields, piece)
    end

    return fields
end

-- ------------------------------------------------------------------------------------------------------
-- Write to file for the basic data.
-- ------------------------------------------------------------------------------------------------------
File.SaveData = function()
    local path = File.Path()
    File.FileExists(path)

    local player = Ashita.Mob.GetMobByTarget(Ashita.TargetString.ME)

    if not player then
        return
    end

    local filename = tostring(os.date("%m-%d-%Y %H-%M-%S", os.time()) .. " Database " .. tostring(player.name) .. ".csv")

    ---@diagnostic disable-next-line: undefined-field
    local file = io.open(('%s/%s'):fmt(path, filename), "w")

    if file ~= nil then
        -- Headers
        file:write
        (
            tostring("Player")    .. File.Delimiter ..
            tostring("Pet")       .. File.Delimiter ..
            tostring("Target")    .. File.Delimiter ..
            tostring("Action")    .. File.Delimiter ..
            tostring("Trackable") .. File.Delimiter ..
            tostring("Metric")    .. File.Delimiter ..
            tostring("Value") .. "\n"
        )

        -- Basic Player Data
        for playerName, _ in pairs(DB.Parse) do
            for targetName, _ in pairs(DB.Parse[playerName]) do
                for trackable, _ in pairs(DB.Parse[playerName][targetName]) do
                    for metric, data in pairs(DB.Parse[playerName][targetName][trackable]) do
                        if data and data > 0 then
                            if not (DB.MetricNeedsMaxValue(metric) and data >= DB.Enum.MAX_DAMAGE) then
                                file:write
                                (
                                    tostring(playerName) .. File.Delimiter ..
                                    tostring("")         .. File.Delimiter ..
                                    tostring(targetName) .. File.Delimiter ..
                                    tostring("")         .. File.Delimiter ..
                                    tostring(trackable)  .. File.Delimiter ..
                                    tostring(metric)     .. File.Delimiter ..
                                    tostring(data) .. "\n"
                                )
                            end
                        end
                    end
                end
            end
        end

        -- Basic Pet Data
        for playerName, _ in pairs(DB.PetParse) do
            for petName, _ in pairs(DB.PetParse[playerName]) do
                for targetName, _ in pairs(DB.PetParse[playerName][petName]) do
                    for trackable, _ in pairs(DB.PetParse[playerName][petName][targetName]) do
                        for metric, data in pairs(DB.PetParse[playerName][petName][targetName][trackable]) do
                            if data and data > 0 then
                                if not (DB.MetricNeedsMaxValue(metric) and data >= DB.Enum.MAX_DAMAGE) then
                                    file:write
                                    (
                                        tostring(playerName) .. File.Delimiter ..
                                        tostring(petName)    .. File.Delimiter ..
                                        tostring(targetName) .. File.Delimiter ..
                                        tostring("")         .. File.Delimiter ..
                                        tostring(trackable)  .. File.Delimiter ..
                                        tostring(metric)     .. File.Delimiter ..
                                        tostring(data) .. "\n"
                                    )
                                end
                            end
                        end
                    end
                end
            end
        end

        -- Catalog Player Data
        for playerName, _ in pairs(DB.ParseCatalog) do
            for targetName, _ in pairs(DB.ParseCatalog[playerName]) do
                for actionName, _ in pairs(DB.ParseCatalog[playerName][targetName]) do
                    for trackable, _ in pairs(DB.ParseCatalog[playerName][targetName][actionName]) do
                        for metric, data in pairs(DB.ParseCatalog[playerName][targetName][actionName][trackable]) do
                            if data and data > 0 then
                                if not (DB.MetricNeedsMaxValue(metric) and data >= DB.Enum.MAX_DAMAGE) then
                                    file:write
                                    (
                                        tostring(playerName) .. File.Delimiter ..
                                        tostring("")         .. File.Delimiter ..
                                        tostring(targetName) .. File.Delimiter ..
                                        tostring(actionName) .. File.Delimiter ..
                                        tostring(trackable)  .. File.Delimiter ..
                                        tostring(metric)     .. File.Delimiter ..
                                        tostring(data) .. "\n"
                                    )
                                end
                            end
                        end
                    end
                end
            end
        end

        -- Catalog Pet Data
        for playerName, _ in pairs(DB.PetParseCatalog) do
            for petName, _ in pairs(DB.PetParseCatalog[playerName]) do
                for targetName, _ in pairs(DB.PetParseCatalog[playerName][petName]) do
                    for actionName, _ in pairs(DB.PetParseCatalog[playerName][petName][targetName]) do
                        for trackable, _ in pairs(DB.PetParseCatalog[playerName][petName][targetName][actionName]) do
                            for metric, data in pairs(DB.PetParseCatalog[playerName][petName][targetName][actionName][trackable]) do
                                if data and data > 0 then
                                    if not (DB.MetricNeedsMaxValue(metric) and data >= DB.Enum.MAX_DAMAGE) then
                                        file:write
                                        (
                                            tostring(playerName) .. File.Delimiter ..
                                            tostring(petName)    .. File.Delimiter ..
                                            tostring(targetName) .. File.Delimiter ..
                                            tostring(actionName) .. File.Delimiter ..
                                            tostring(trackable)  .. File.Delimiter ..
                                            tostring(metric)     .. File.Delimiter ..
                                            tostring(data) .. "\n"
                                        )
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
File.SaveBattlelog = function()
    local path = File.Path()
    File.FileExists(path)

    local player = Ashita.Mob.GetMobByTarget(Ashita.TargetString.ME)

    if not player then
        return
    end

    local filename = tostring(os.date("%m-%d-%Y %H-%M-%S Battle Log ", os.time()) .. tostring(player.name) .. ".csv")

    ---@diagnostic disable-next-line: undefined-field
    local file = io.open(('%s/%s'):fmt(path, filename), "w")

    if file ~= nil then
        file:write
        (
            tostring("Time")        .. File.Delimiter ..
            tostring("Flag")        .. File.Delimiter ..
            tostring("Player Name") .. File.Delimiter ..
            tostring("Pet Name")    .. File.Delimiter ..
            tostring("Damage")      .. File.Delimiter ..
            tostring("Action")      .. File.Delimiter ..
            tostring("Note")        .. "\n"
        )

        for _, data in pairs(Blog.Log) do
            local time       = data.Time
            local flag       = data.Flag
            local playerName = data.Player
            local petName    = data.Pet
            local damage     = data.Damage
            local action     = data.Action
            local note       = data.Note

            if not time or not flag or  not playerName or not petName or not damage or not action or not note then
                Debug.Error.Add(Debug.Error.ERROR, "File.Save_Battlelog", "Nil data: Time " .. tostring(time) .. " Flag: " .. tostring(flag) .. " Player Name: " ..
                                tostring(playerName) .. " Pet Name: " .. tostring(petName) .. " Damage: " .. tostring(damage) .. " Action: " ..
                                tostring(action) .. " Note: " .. tostring(note))
            else
                file:write
                (
                    tostring(time.Value)       .. File.Delimiter ..
                    tostring(flag.Value)       .. File.Delimiter ..
                    tostring(playerName.Value) .. File.Delimiter ..
                    tostring(petName.Value)    .. File.Delimiter ..
                    tostring(damage.Value)     .. File.Delimiter ..
                    tostring(action.Value)     .. File.Delimiter ..
                    tostring(note.Value) .. "\n"
                )
            end
        end

        file:close()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Write to file for the item tracking data.
-- ------------------------------------------------------------------------------------------------------
File.SaveLoot = function()
    local path = File.Path()
    File.FileExists(path)

    local player = Ashita.Mob.GetMobByTarget(Ashita.TargetString.ME)

    if not player then
        return
    end

    local filename = tostring(os.date("%m-%d-%Y %H-%M-%S Loot ", os.time()) .. tostring(player.name) .. ".csv")

    ---@diagnostic disable-next-line: undefined-field
    local file = io.open(('%s/%s'):fmt(path, filename), "w")

    if file ~= nil then
        file:write
        (
            tostring("Entity Type") .. File.Delimiter ..
            tostring("Entity Name") .. File.Delimiter ..
            tostring("Item Name")   .. File.Delimiter ..
            tostring("Item Count")  .. File.Delimiter ..
            tostring("Defeated Count (Mobs)") .. "\n"
        )

        local entityType = "Player"

        for playerName, itemData in pairs(DB.Tracking.ReceivedItems) do
            for itemName, itemCount in pairs(itemData) do
                file:write
                (
                    tostring(entityType) .. File.Delimiter ..
                    tostring(playerName) .. File.Delimiter ..
                    tostring(itemName)   .. File.Delimiter ..
                    tostring(itemCount)  .. File.Delimiter ..
                    tostring(0) .. "\n"
                )
            end
        end

        entityType = "Mob"
        for mobName, itemData in pairs(DB.Tracking.DropRates) do
            for itemName, dropCount in pairs(itemData) do
                local defeatedCount = DB.Tracking.DefeatedMobs[mobName] or 1

                file:write
                (
                    tostring(entityType) .. File.Delimiter ..
                    tostring(mobName)    .. File.Delimiter ..
                    tostring(itemName)   .. File.Delimiter ..
                    tostring(dropCount)  .. File.Delimiter ..
                    tostring(defeatedCount) .. "\n"
                )
            end
        end

        file:close()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Import data into Metrics.
-- ------------------------------------------------------------------------------------------------------
---@param path string
-- ------------------------------------------------------------------------------------------------------
File.Import = function(path)
    local file = io.open(path, "r")

    if file then
        DB.Initialize(true)

        local isHeader = true

        for line in file:lines() do
            line = (line or ""):gsub("\r$", "") -- ???

            if line ~= "" then

                -- Skip the first line.
                if isHeader then
                    isHeader = false
                else
                    local fields = File.SplitCSV(line)
                    local data =
                    {
                        Player    = fields[1] or "",
                        Pet       = fields[2] or "",
                        Target    = fields[3] or "",
                        Action    = fields[4] or "",
                        Trackable = fields[5] or "",
                        Metric    = fields[6] or "",
                        Value     = tonumber(fields[7] or "") or 0
                    }

                    local hasAction = data.Action ~= ""
                    local hasPet    = data.Pet    ~= ""

                    if hasAction and hasPet then
                        DB.PetCatalog.Initialize (data.Player, data.Pet, data.Target, data.Action, data.Trackable)
                        if not DB.PetParseCatalog[data.Player] then DB.PetParseCatalog[data.Player] = { } end
                        if not DB.PetParseCatalog[data.Player][data.Pet] then DB.PetParseCatalog[data.Player][data.Pet] = { } end
                        if not DB.PetParseCatalog[data.Player][data.Pet][data.Target] then DB.PetParseCatalog[data.Player][data.Pet][data.Target] = { } end
                        if not DB.PetParseCatalog[data.Player][data.Pet][data.Target][data.Action] then DB.PetParseCatalog[data.Player][data.Pet][data.Target][data.Action] = { } end
                        if not DB.PetParseCatalog[data.Player][data.Pet][data.Target][data.Action][data.Trackable] then DB.PetParseCatalog[data.Player][data.Pet][data.Target][data.Action][data.Trackable] = { } end
                        if not DB.PetParseCatalog[data.Player][data.Pet][data.Target][data.Action][data.Trackable][data.Metric] then DB.PetParseCatalog[data.Player][data.Pet][data.Target][data.Action][data.Trackable][data.Metric] = { } end
                        DB.PetParseCatalog[data.Player][data.Pet][data.Target][data.Action][data.Trackable][data.Metric] = data.Value

                    elseif hasAction then
                        DB.Catalog.Initialize(data.Player, data.Target, data.Action, data.Trackable, data.Pet)

                        if not DB.ParseCatalog[data.Player] then DB.ParseCatalog[data.Player] = { } end
                        if not DB.ParseCatalog[data.Player][data.Target] then DB.ParseCatalog[data.Player][data.Target] = { } end
                        if not DB.ParseCatalog[data.Player][data.Target][data.Action] then DB.ParseCatalog[data.Player][data.Target][data.Action] = { } end
                        if not DB.ParseCatalog[data.Player][data.Target][data.Action][data.Trackable] then DB.ParseCatalog[data.Player][data.Target][data.Action][data.Trackable] = { } end
                        if not DB.ParseCatalog[data.Player][data.Target][data.Action][data.Trackable][data.Metric] then DB.ParseCatalog[data.Player][data.Target][data.Action][data.Trackable][data.Metric] = { } end
                        DB.ParseCatalog[data.Player][data.Target][data.Action][data.Trackable][data.Metric] = data.Value

                    elseif hasPet then
                        DB.PetData.Initialize(data.Player, data.Pet, data.Target)
                        if not DB.PetParse[data.Player] then DB.PetParse[data.Player] = { } end
                        if not DB.PetParse[data.Player][data.Pet] then DB.PetParse[data.Player][data.Pet] = { } end
                        if not DB.PetParse[data.Player][data.Pet][data.Target] then DB.PetParse[data.Player][data.Pet][data.Target] = { } end
                        if not DB.PetParse[data.Player][data.Pet][data.Target][data.Trackable] then DB.PetParse[data.Player][data.Pet][data.Target][data.Trackable] = { } end
                        if not DB.PetParse[data.Player][data.Pet][data.Target][data.Trackable][data.Metric] then DB.PetParse[data.Player][data.Pet][data.Target][data.Trackable][data.Metric] = { } end
                        DB.PetParse[data.Player][data.Pet][data.Target][data.Trackable][data.Metric] = data.Value

                    else
                        DB.Data.Initialize(data.Player, data.Target)
                        if not DB.Parse[data.Player] then DB.Parse[data.Player] = { } end
                        if not DB.Parse[data.Player][data.Target] then DB.Parse[data.Player][data.Target] = { } end
                        if not DB.Parse[data.Player][data.Target][data.Trackable] then DB.Parse[data.Player][data.Target][data.Trackable] = { } end
                        if not DB.Parse[data.Player][data.Target][data.Trackable][data.Metric] then DB.Parse[data.Player][data.Target][data.Trackable][data.Metric] = { } end
                        DB.Parse[data.Player][data.Target][data.Trackable][data.Metric] = data.Value
                    end
                end
            end
        end

        file:close()
    else
        print(string.format("Failed to open file: %s", path))
    end
end
