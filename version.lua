Version = { }
-- Version Format: YYYY-MM-DD

local http = require('socket.http')
local json = require('json')
local os   = require('os')

local curatedReleaseList = { }
local apiURL             = 'https://api.github.com/repos/RaraProjects/metrics/releases'
local maxReleaseCount    = 3
local versionDataPulled  = false
local recentDownload     = nil

-- ------------------------------------------------------------------------------------------------------
-- Gets asset data from the Github JSON results.
-- ------------------------------------------------------------------------------------------------------
---@param release table
---@return table
-- ------------------------------------------------------------------------------------------------------
local getAssetData = function(release)
    if type(release.assets) ~= 'table' then
        return { }
    end

    if release.assets[1] then
        return
        {
            downloadURL   = release.assets[1].browser_download_url,
            downloadCount = release.assets[1].download_count,
            updateTime    = release.assets[1].updated_at,
        }
    end

    return { }
end

-- ------------------------------------------------------------------------------------------------------
-- Create a list of most recent release and recent pre-releases.
-- ------------------------------------------------------------------------------------------------------
---@param allReleases table
---@return table
-- ------------------------------------------------------------------------------------------------------
local function buildUpdateList(allReleases)
    local list = {}
    local prereleaseCount = 0
    local stableRelease

    -- Check for most recent release.
    for _, release in ipairs(allReleases) do
        if release.downloadURL and not release.isPrerelease then
            stableRelease = release
            break
        end
    end

    if stableRelease then
        table.insert(list, stableRelease)
    end

    -- Check for recent pre-releases.
    for _, release in ipairs(allReleases) do
        if release.downloadURL and release.isPrerelease and prereleaseCount < maxReleaseCount then
            table.insert(list, release)
            prereleaseCount = prereleaseCount + 1

            if prereleaseCount >= maxReleaseCount then
                break
            end
        end
    end

    return list
end

-- ------------------------------------------------------------------------------------------------------
-- Convert the Github string format to YYYY-MM-DD.
-- ------------------------------------------------------------------------------------------------------
---@param isoDateTime string
---@return string
-- ------------------------------------------------------------------------------------------------------
local convertDateString = function(isoDateTime)
    if isoDateTime and type(isoDateTime) == 'string' then
        return isoDateTime:sub(1, 10)
    end

    return isoDateTime
end

-- ------------------------------------------------------------------------------------------------------
-- Try to launch a web URL in the browser.
-- ------------------------------------------------------------------------------------------------------
---@param url string
-- ------------------------------------------------------------------------------------------------------
local openUrl = function(url)
    print(tostring(url))

    if not url then
        return
    end

    if os.getenv('OS') == 'Windows_NT' then
        print(string.format('Opening URL: %s', url))
        os.execute(string.format('start %s', url))
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Try to launch a Windows directory in the file explorer.
-- ------------------------------------------------------------------------------------------------------
---@param path string
-- ------------------------------------------------------------------------------------------------------
local openFolder = function(path)
    if not path then
        return
    end

    path = path:gsub("/", "\\")

    print(string.format('Opening Directory: %s', path))

    os.execute(string.format('explorer %s', path))
end

-- ------------------------------------------------------------------------------------------------------
-- Displays the version table.
-- ------------------------------------------------------------------------------------------------------
Version.Populate = function()
    if versionDataPulled == false then
        UI.Text('Clicking this button will pull data from Github.')
        UI.Text('You may experience a very short stutter in game.')
        UI.Text('This will not download files to your computer.')

        if UI.Button('Check version data from Github.') then
            Version.PullGithubData()
            versionDataPulled = true
        end
    end

    if versionDataPulled == false then
        return
    end

    UI.Text(string.format('Your version is: %s.', addon.version))
    UI.Text('Clicking \'Get\' will download the addon zip file to your computer.')
    UI.Text('You will then get a button to take you to your addon folder.')
    UI.Text('')

    local showReleaseColor = true
    local colFlags         = Column.Flags.None

    if UI.BeginTable('Versions', 5, Focus.Catalog.TableFlags) then
        UI.TableSetupColumn('Version',      colFlags)
        UI.TableSetupColumn('Pre-release?', colFlags)
        UI.TableSetupColumn('Date',         colFlags)
        UI.TableSetupColumn('Downloads',    colFlags)
        UI.TableSetupColumn('DL',           colFlags)
        UI.TableHeadersRow()

        for _, release in ipairs(curatedReleaseList) do
            UI.TableNextColumn() UI.Text(string.format('%s', release.version))
            UI.TableNextColumn() UI.Text(string.format('%s', release.isPrerelease and 'Yes' or ''))
            UI.TableNextColumn() UI.Text(string.format('%s', convertDateString(release.updateTime)))
            UI.TableNextColumn() UI.Text(string.format('%s', release.downloadCount))

            UI.TableNextColumn()

            UI.PushID(string.format('Get %s', release.version))
            if UI.SmallButton('Get') then
                openUrl(release.downloadURL)
                recentDownload = release.version
            end
            UI.PopID()

            if showReleaseColor then
                WindowManager.TableRowColor(1)
                showReleaseColor = false
            else
                WindowManager.TableRowColor(0)
            end
        end

        UI.EndTable()
    end

    if recentDownload then
        UI.Text('')
        if UI.Button('Ashita Addon Folder - Move File Here') then
            openFolder(string.format('%saddons\\', AshitaCore:GetInstallPath()))
        end
        UI.Text(string.format('You downloaded: %s!', recentDownload))
        UI.Text(string.format('Move your metrics.zip file here and unzip it.'))
        UI.Text(string.format('You can overwrite the metrics files.'))
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Pull the release JSON data via Github API.
-- ------------------------------------------------------------------------------------------------------
Version.PullGithubData = function()
    local releaseData  = { }
    local body, status = http.request(apiURL)

    if status ~= 200 or not body then
        print('Unable to reach GitHub.')
        return
    end

    local apiReleases = json.decode(body)
    local tagName

    for _, release in ipairs(apiReleases) do
        tagName = release.tag_name

        if tagName then
            local assetData = getAssetData(release)

            table.insert(releaseData,
            {
                version       = tagName,
                isPrerelease  = release.prerelease or false,
                isDateTag     = true,
                downloadURL   = assetData.downloadURL,
                downloadCount = assetData.downloadCount,
                updateTime    = assetData.updateTime,
                notes         = release.body,
            })
        end
    end

    curatedReleaseList = buildUpdateList(releaseData)
end

