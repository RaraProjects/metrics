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
-- Helper function for crawling through tables.
-- ------------------------------------------------------------------------------------------------------
---@param parent table
---@param key string
---@return table
-- ------------------------------------------------------------------------------------------------------
local getOrCreate = function(parent, key)
    local child = parent[key]

    if not child then
        child = { }
        parent[key] = child
    end

    return child
end

-- ------------------------------------------------------------------------------------------------------
-- Import specific pet catalog data row.
-- ------------------------------------------------------------------------------------------------------
---@param player    string
---@param pet       string
---@param target    string
---@param action    string
---@param trackable string
---@param metric    string
---@param value     any
---@param sortTable table
-- ------------------------------------------------------------------------------------------------------
local importPetCatalogRow = function(player, pet, target, action, trackable, metric, value, sortTable)
    local catalog  = DB.PetParseCatalog
    local tracking = DB.Tracking.PetTrackables

    DB.PetCatalog.Initialize(player, pet, target, action, trackable)

    -- Database
    local db = getOrCreate(catalog, player)
    db = getOrCreate(db, pet)
    db = getOrCreate(db, target)
    db = getOrCreate(db, action)
    db = getOrCreate(db, trackable)
    db[metric] = value

    -- Needed for catalog actions to show in Focus.
    local sort = getOrCreate(tracking, trackable)
    sort = getOrCreate(sort, player)
    sort = getOrCreate(sort, pet)
    sort[action] = true

    sortTable[player] = sortTable[player] or { }
    sortTable[player][pet] = true
end

-- ------------------------------------------------------------------------------------------------------
-- Import specific catalog data row.
-- ------------------------------------------------------------------------------------------------------
---@param player    string
---@param pet       string
---@param target    string
---@param action    string
---@param trackable string
---@param metric    string
---@param value     any
---@param sortTable table
-- ------------------------------------------------------------------------------------------------------
local importCatalogRow = function(player, pet, target, action, trackable, metric, value, sortTable)
    local catalog   = DB.ParseCatalog
    local tracking  = DB.Tracking.Trackables

    DB.Catalog.Initialize(player, target, action, trackable, pet)

    -- Database
    local db = getOrCreate(catalog, player)
    db = getOrCreate(db, target)
    db = getOrCreate(db, action)
    db = getOrCreate(db, trackable)
    db[metric] = value

    -- Needed for catalog actions to show in Focus.
    local sort = getOrCreate(tracking, trackable)
    sort = getOrCreate(sort, player)
    sort[action] = true

    sortTable[trackable] = sortTable[trackable] or { }
    sortTable[trackable][player] = true
end

-- ------------------------------------------------------------------------------------------------------
-- Import specific pet data row.
-- ------------------------------------------------------------------------------------------------------
---@param player    string
---@param pet       string
---@param target    string
---@param trackable string
---@param metric    string
---@param value     any
---@param sortTable table
-- ------------------------------------------------------------------------------------------------------
local importPetDataRow = function(player, pet, target, trackable, metric, value, sortTable)
    local parse     = DB.PetParse
    local initPets  = DB.Tracking.InitializedPets

    DB.PetData.Initialize(player, pet, target)

    -- Database
    local db = getOrCreate(parse, player)
    db = getOrCreate(db, pet)
    db = getOrCreate(db, target)
    db = getOrCreate(db, trackable)
    db[metric] = value

    -- Needed to populate lists in Focus.
    local sort = getOrCreate(initPets, player)
    sort[pet] = true

    sortTable[player] = true
end

-- ------------------------------------------------------------------------------------------------------
-- Import data row.
-- ------------------------------------------------------------------------------------------------------
---@param player    string
---@param target    string
---@param trackable string
---@param metric    string
---@param value     any
---@param sortTable table
-- ------------------------------------------------------------------------------------------------------
local importDataRow = function(player, target, trackable, metric, value, sortTable)
    local parse = DB.Parse

    DB.Data.Initialize(player, target)

    local db = getOrCreate(parse, player)
    db = getOrCreate(db, target)
    db = getOrCreate(db, trackable)
    db[metric] = value

    sortTable[trackable] = true
end

-- ------------------------------------------------------------------------------------------------------
-- Import data into Metrics.
-- ------------------------------------------------------------------------------------------------------
---@param path string
-- ------------------------------------------------------------------------------------------------------
File.Import = function(path)
    local sortPetCatalog = { }
    local sortCatalog    = { }
    local sortPets       = { }
    local sortTrackables = { }

    local file = io.open(path, "r")

    if file then
        DB.Initialize(true)

        local isHeader = true

        for line in file:lines() do
            line = (line or ""):gsub("\r$", "")

            if line ~= "" then
                -- Skip the first line.
                if isHeader then
                    isHeader = false
                else
                    local fields = File.SplitCSV(line)

                    local player    = fields[1] or ""
                    local pet       = fields[2] or ""
                    local target    = fields[3] or ""
                    local action    = fields[4] or ""
                    local trackable = fields[5] or ""
                    local metric    = fields[6] or ""
                    local value     = tonumber(fields[7] or "") or 0

                    local hasAction = action ~= ""
                    local hasPet    = pet    ~= ""

                    if hasAction and hasPet then
                        importPetCatalogRow(player, pet, target, action, trackable, metric, value, sortPetCatalog)

                    elseif hasAction then
                        importCatalogRow(player, pet, target, action, trackable, metric, value, sortCatalog)

                    elseif hasPet then
                        importPetDataRow(player, pet, target, trackable, metric, value, sortPets)

                    else
                        importDataRow(player, target, trackable, metric, value, sortTrackables)
                    end
                end
            end
        end

        file:close()
    else
        Ashita.Chat.Echo(string.format("Failed to open file: %s", path))
    end

    -- Refresh the sorted list caches.
    local lists = DB.Lists
    lists.ResortDataDamage(DB.Trackable.TOTAL_DAMAGE)
    lists.ResortDataDamage(DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN)

    for player, pets in pairs(sortPetCatalog) do
        for pet, _ in pairs(pets) do
            lists.ResortPetCatalogDamage(player, pet)
        end
    end

    for trackable, players in pairs(sortCatalog) do
        for player, _ in pairs(players) do
            lists.ResortPlayerCatalogDamage(player, trackable)
        end
    end

    for trackable, _ in pairs(sortTrackables) do
        lists.ResortDataDamage(trackable)
    end

    for player, _ in pairs(sortPets) do
        lists.ResortPetDamage(player)
    end
end
