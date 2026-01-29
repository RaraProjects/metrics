Version = { }
-- Version Format: YYYY-MM-DD

local http = require('socket.http')
local json = require('json')

local curatedReleaseList = { }
local maxReleaseCount    = 3
local versionDataPulled  = false
local recentDownload     = nil
local hasTestRelease     = false

local gitOwner   = 'RaraProjects'
local repoName   = 'metrics'
local branchName = 'Testing'
local addonName  = addon.name or 'Addon'
local apiURL     = string.format('https://api.github.com/repos/%s/%s/releases', gitOwner, repoName)
local branchURL  = string.format('https://github.com/%s/%s/archive/refs/heads/%s.zip', gitOwner, repoName, branchName)

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
    Ashita.Chat.Echo(string.format('Opening URL: %s', url))

    if not url then
        return
    end

    if os.getenv('OS') == 'Windows_NT' then
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

    path = path:gsub('/', '\\')
    Ashita.Chat.Echo(string.format('Opening Directory: %s', path))

    os.execute(string.format('explorer %s', path))
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the first version update screen.
-- ------------------------------------------------------------------------------------------------------
local uiGetGitHubData = function()
    if versionDataPulled == false then
        UI.Text('Clicking this button will...')
        UI.Text(string.format('- Check Github for recent %s releases.', addonName))
        UI.Text('- Likely cause a very short system stutter.')
        UI.Text(string.format('- Show you a table of %s versions (in game).', addonName))
        UI.Text('- NOT download files to your computer.')
        UI.Text('')

        if UI.Button(string.format('Check for new %s releases.', addonName)) then
            Version.PullGithubData()
            versionDataPulled = true
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Basic install instructions.
-- ------------------------------------------------------------------------------------------------------
local basicInstallInstructions = function()
    UI.Text('1. Click Addon Folder button above to open your addons folder.')
    UI.Text(string.format('2. Move your %s.zip file to addons folder.', repoName))
    UI.Text(string.format('3. Unzip %s.zip.', repoName))
    UI.Text(string.format('4. You can overwrite the %s files.', repoName))
end

-- ------------------------------------------------------------------------------------------------------
-- Instructions that show after a download has taken place.
-- ------------------------------------------------------------------------------------------------------
local uiInstructions = function()
    if recentDownload then
        UI.Text('')
        UI.Text(string.format('You downloaded: %s! Next steps...', recentDownload))
        basicInstallInstructions()
    elseif hasTestRelease then
        UI.Text('')
        UI.Text('Brave soul! You downloaded the cutting edge development. Next steps...')
        basicInstallInstructions()
        UI.Text('5. If something breaks (badly) fall back to a release or pre-release.')
        UI.Text(string.format('6. Leave a comment in the %s Discord or Github Issues page.', addonName))
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Displays the version table.
-- ------------------------------------------------------------------------------------------------------
Version.Populate = function()
    uiGetGitHubData()

    if versionDataPulled == false then
        return
    end

    UI.Text(string.format('Your version is: %s.', addon.version))
    if UI.Button('Ashita Addon Folder - Quick Access') then
        openFolder(string.format('%saddons\\', AshitaCore:GetInstallPath()))
    end

    UI.Text('')
    UI.Text('Clicking...')
    UI.Text('- Doc: Open release info on Github website.')
    UI.Text('- Get: DOWNLOAD the release .zip file.')
    UI.Text('')

    local showReleaseColor = true
    local colFlags         = Column.Flags.None

    if UI.BeginTable('Versions', 6, Focus.Catalog.TableFlags) then
        UI.TableSetupColumn('Version',      colFlags)
        UI.TableSetupColumn('Pre-release?', colFlags)
        UI.TableSetupColumn('Update Date',  colFlags)
        UI.TableSetupColumn('Downloads',    colFlags)
        UI.TableSetupColumn('Info',         colFlags)
        UI.TableSetupColumn('DL',           colFlags)
        UI.TableHeadersRow()

        for _, release in ipairs(curatedReleaseList) do
            UI.TableNextColumn() UI.Text(string.format('%s', release.version))
            UI.TableNextColumn() UI.Text(string.format('%s', release.isPrerelease and 'Yes' or ''))
            UI.TableNextColumn() UI.Text(string.format('%s', convertDateString(release.updateTime)))
            UI.TableNextColumn() UI.Text(string.format('%s', release.downloadCount))

            UI.TableNextColumn()
            UI.PushID(string.format('Doc %s', release.version))
            if UI.SmallButton('Doc') then
                openUrl(release.htmlURL)
            end
            UI.PopID()


            UI.TableNextColumn()
            UI.PushID(string.format('Get %s', release.version))
            if UI.SmallButton('Get') then
                openUrl(release.downloadURL)
                recentDownload = release.version
                hasTestRelease = false
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

    UI.Text('')
    UI.Text('Feel free to try the newest unreleased features. It\'s what I use.')
    if UI.Button('Download - UNRELEASED EXPERIMENTAL - May Break!') then
        openUrl(branchURL)
        recentDownload = nil
        hasTestRelease = true
    end

    uiInstructions()
end

-- ------------------------------------------------------------------------------------------------------
-- Pull the release JSON data via Github API.
-- ------------------------------------------------------------------------------------------------------
Version.PullGithubData = function()
    local releaseData  = { }
    local body, status = http.request(apiURL)

    if status ~= 200 or not body then
        Ashita.Chat.Echo('Unable to reach GitHub.')
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
                htmlURL       = release.html_url,
                notes         = release.body,
            })
        end
    end

    curatedReleaseList = buildUpdateList(releaseData)
end

