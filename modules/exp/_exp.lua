XP = { }

-- ASB Code: /src/map/utils/charutils.cpp->AddExperiencePoints
-- ASB Code: /src/map/utils/charutils.cpp->DistributeExperiencePoints
-- https://github.com/Shinzaku/Points

require("modules.exp.columns")
require("modules.exp.config")
require("modules.exp.messages")
require("modules.exp.tracking")
require("modules.exp.chains")
require("modules.exp.dedication")
require("modules.exp.widgets")

XP.Name   = "XP"
XP.Title  = "Metrics - EXP"
XP.Module = "XP"
XP.File   = "exp"

XP.TableFlags = bit.bor(ImGuiTableFlags_Borders)

XP.Type =
{
    ERROR      = 0,
    EXPERIENCE = 1,
    LIMIT      = 2,
    CAPACITY   = 3,
    EXEMPLAR   = 4,
}

XP.IsInitialized         = false
XP.DisplayMode           = XP.Type.EXPERIENCE
XP.FullBarHeight         = 18
XP.TinyBarHeight         = 8
XP.ShowAdditionalInfo    = false
XP.ShowResetConfirmation = false

-- ------------------------------------------------------------------------------------------------------
-- Initializes the XP module.
-- ------------------------------------------------------------------------------------------------------
XP.Initialize = function(settings)
    if not XP.IsInitialized and Ashita and Res and Window_Manager and UI and DB and Column then
        -- Get saved settings from file.
        XP.Settings = settings or Settings_File.load(XP.Config.Defaults, XP.File)

        -- Create the XP Window.
        XP.Window = Window:New
        ({
            Name     = XP.Name,
            Title    = XP.Title,
            Module   = XP.Module,
            Settings = XP.Settings,
        })

        XP.Window.Set_Background(XP.Settings.Show_Background)

        -- Dedication
        local needsReset = XP.Settings.Boost_Item_Rate <= 0
        XP.Dedication.Refresh()
        XP.Dedication.NeedDefaulting = needsReset
        XP.Dedication.AwaitingClear      = needsReset

        XP.Columns.Count()          -- Refresh the number of columns to show in the table.
        XP.RefreshDisplayMode()     -- Based on type of XP--experience, limit, etc.
        XP.Tracking.Initialize()

        XP.IsInitialized = true
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Populates the XP window.
-- ------------------------------------------------------------------------------------------------------
XP.Content = function()
    -- Settings buttons don't show when mini mode is enabled.
    if not XP.Settings.Mini_Mode_Enabled then
        XP.Config.SettingsButton()            -- Settings
        XP.Widgets.TrackingButton()           -- Tracking (if Debug mode is enabled)
        XP.Widgets.ResetButton()              -- Reset button
        XP.Widgets.ResetConfirmationButton()  -- Reset confirmation
    end

    -- Base content
    XP.RefreshDisplayMode()
    XP.DisplayTable()
    XP.Tracking.DebugContent()

    if Window_Manager.Can_Bar_Load() then
        XP.Widgets.LevelProgressBar()
        XP.Widgets.BoostProgressBar()
    else
        -- Show a loading message if the progress bar can't be loaded but it's set to show.
        if XP.Settings.Show_XP_Progress_Bar or XP.Settings.Show_Boost_Progress_Bar then
            UI.Text("Loading...")
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the experience points rows.
-- ------------------------------------------------------------------------------------------------------
XP.DisplayTable = function()
    local flags      = Column.Flags.None
    local tableFlags = bit.bor(XP.TableFlags, ImGuiTableFlags_RowBg)

    -- XP Mode determines which type of XP is displayed.
    local xpType = XP.DisplayMode or XP.Type.EXPERIENCE

    local typeString  = (xpType == XP.Type.LIMIT) and "LP" or "XP"
    local levelString = (xpType == XP.Type.LIMIT) and "M"  or "L"

    UI.PushStyleColor(ImGuiCol_TableRowBg, Window_Manager.Theme.TableRowBg)

    if UI.BeginTable("XP Metrics", XP.Columns.DisplayCount, tableFlags) then
        if XP.Settings.Show_Job                 then UI.TableSetupColumn("Job",                               flags) end
                                                     UI.TableSetupColumn("Chain",                             flags)
                                                     UI.TableSetupColumn(string.format("*%s/hr", typeString), flags)
        if XP.Settings.Show_Base_Rate           then UI.TableSetupColumn(string.format("%s/hr", typeString),  flags) end
        if XP.Settings.Show_Time_To_Level       then UI.TableSetupColumn(string.format("~TT%s", levelString), flags) end
        if XP.Settings.Show_Boost_Time_To_Level then UI.TableSetupColumn("TTB",                               flags) end
        if XP.Settings.Show_TNL                 then UI.TableSetupColumn(string.format("TN%s", levelString),  flags) end
        if XP.Settings.Show_Capacity_Base_Rate  then UI.TableSetupColumn("CP/hr",                             flags) end
        if XP.Settings.Show_Time_To_Job_Point   then UI.TableSetupColumn("~TTJP",                             flags) end
        if XP.Settings.Show_TNJP                then UI.TableSetupColumn("TNJP",                              flags) end
        if XP.Settings.Show_Exemplar_Base_Rate  then UI.TableSetupColumn("EP/hr",                             flags) end
        if XP.Settings.Show_Time_To_Mastery     then UI.TableSetupColumn("~TTML",                             flags) end
        if XP.Settings.Show_TNML                then UI.TableSetupColumn("TNML",                              flags) end
        if XP.Settings.Show_Kill_Rate           then UI.TableSetupColumn("Time/Kill",                         flags) end
        if XP.Settings.Show_Average_XP          then UI.TableSetupColumn("XP/Kill",                           flags) end
        if XP.Settings.Show_Total_XP_Gained     then UI.TableSetupColumn("Total",                             flags) end
        if XP.Settings.Show_Max_Chain           then UI.TableSetupColumn("Max Chain",                         flags) end
        if XP.Settings.Show_Zone_Time           then UI.TableSetupColumn("Zone Time",                         flags) end
        if XP.Settings.Show_Boost_Item          then UI.TableSetupColumn("Bonus",                             flags) end
        if XP.Settings.Show_Boost_Rate          then UI.TableSetupColumn("Bonus %",                           flags) end
        if XP.Settings.Show_Boost_Max           then UI.TableSetupColumn("Bonus Max",                         flags) end
        UI.TableHeadersRow()

        -- Content
        if XP.Settings.Show_Job                 then UI.TableNextColumn() XP.Columns.Job() end
                                                     UI.TableNextColumn() XP.Columns.Chain()
                                                     UI.TableNextColumn() UI.Text(XP.Columns.AverageRate(xpType))
        if XP.Settings.Show_Base_Rate           then UI.TableNextColumn() UI.Text(XP.Columns.AverageRate(xpType, true)) end
        if XP.Settings.Show_Time_To_Level       then UI.TableNextColumn() XP.Columns.TimeToLevel(xpType) end
        if XP.Settings.Show_Boost_Time_To_Level then UI.TableNextColumn() XP.Columns.TimeToFinishDedication(xpType) end
        if XP.Settings.Show_TNL                 then UI.TableNextColumn() UI.Text(XP.Columns.TNL(xpType)) end
        if XP.Settings.Show_Capacity_Base_Rate  then UI.TableNextColumn() UI.Text(XP.Columns.AverageRate(XP.Type.CAPACITY)) end
        if XP.Settings.Show_Time_To_Job_Point   then UI.TableNextColumn() XP.Columns.TimeToLevel(XP.Type.CAPACITY) end
        if XP.Settings.Show_TNJP                then UI.TableNextColumn() UI.Text(XP.Columns.TNL(XP.Type.CAPACITY)) end
        if XP.Settings.Show_Exemplar_Base_Rate  then UI.TableNextColumn() UI.Text(XP.Columns.AverageRate(XP.Type.EXEMPLAR)) end
        if XP.Settings.Show_Time_To_Mastery     then UI.TableNextColumn() XP.Columns.TimeToLevel(XP.Type.EXEMPLAR) end
        if XP.Settings.Show_TNML                then UI.TableNextColumn() UI.Text(XP.Columns.TNL(XP.Type.EXEMPLAR)) end
        if XP.Settings.Show_Kill_Rate           then
            local killTime = XP.Columns.AverageKillTime(XP.Tracking.EXP.LastXpInstant, XP.Tracking.EXP.KillTimes)
            if killTime < 0 then
                UI.TableNextColumn() UI.Text("--:--")
            else
                UI.TableNextColumn() UI.Text(Timers.Format(killTime, true))
            end
        end
        if XP.Settings.Show_Average_XP          then UI.TableNextColumn() UI.Text(string.format("%d", XP.Columns.AverageXP(xpType))) end
        if XP.Settings.Show_Total_XP_Gained     then UI.TableNextColumn() UI.Text(XP.Columns.TotalXP(xpType)) end
        if XP.Settings.Show_Max_Chain           then UI.TableNextColumn() UI.Text(XP.Columns.MaxChain()) end
        if XP.Settings.Show_Zone_Time           then UI.TableNextColumn() UI.Text(XP.Columns.ZoneTime()) end
        if XP.Settings.Show_Boost_Item          then UI.TableNextColumn() UI.Text(tostring(XP.Settings.Boost_Item_Name)) end
        if XP.Settings.Show_Boost_Rate          then UI.TableNextColumn() UI.Text(XP.Columns.DedicationBonus()) end
        if XP.Settings.Show_Boost_Max           then UI.TableNextColumn() UI.Text(XP.Columns.DedicationProgress()) end

        UI.EndTable()
    end
    UI.PopStyleColor(1)
end

-- ------------------------------------------------------------------------------------------------------
-- Primary XP driving function.
-- RoE quests that give EXP also come through here. They result in zero kill times.
-- ------------------------------------------------------------------------------------------------------
---@param rawPacket any
-- ------------------------------------------------------------------------------------------------------
XP.OnXpGained = function(rawPacket)
    if not rawPacket then
        return nil
    end

    -- Parse the packet. Added a short circuit here for unit testing.
    local parsedPacket = Ashita.Packets.EXP(rawPacket)
    if not parsedPacket then
        return nil
    end

    -- Exclude non-XP related content (like Records of Eminance).
    local messageId = parsedPacket.message_id
    if not XP.Messages.ALL[messageId] then
        return nil
    end

    local xpType = XP.GetMessageXPType(parsedPacket.message_id)
    if xpType == XP.Type.ERROR then
        return nil
    end

    local xpAmount = parsedPacket.xp_amount

    -- Kill time rate metrics. Add XP to sum total.
    if xpType == XP.Type.EXPERIENCE or xpType == XP.Type.LIMIT then
        XP.Tracking.AddEXP(xpAmount, xpType)
        XP.Tracking.EXP.LastXpInstant = XP.Tracking.AddKillTime(XP.Tracking.EXP.LastXpInstant, XP.Tracking.EXP.KillTimes)

    -- Kill time rate metrics. Add capacity to sum total.
    elseif xpType == XP.Type.CAPACITY then
        XP.Tracking.AddCP(xpAmount)
        XP.Tracking.Capacity.LastXpInstant = XP.Tracking.AddKillTime(XP.Tracking.Capacity.LastXpInstant, XP.Tracking.Capacity.KillTimes)

    elseif xpType == XP.Type.EXEMPLAR then
        XP.Tracking.AddEP(xpAmount)
        XP.Tracking.Exemplar.LastXpInstant = XP.Tracking.AddKillTime(XP.Tracking.Exemplar.LastXpInstant, XP.Tracking.Exemplar.KillTimes)
    end

    -- Handle chains for EM and above. I've observed 100 XP for EM mobs.
    if xpAmount >= 100 then
        XP.Chains.OnChain(parsedPacket.chain_count)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- CP needs to be tracked manually.
-- ------------------------------------------------------------------------------------------------------
---@param data table
-- ------------------------------------------------------------------------------------------------------
XP.OnCapacityUpdate = function(data)
    local parsedPacket = Ashita.Packets.CapacityAndLimitUpdate(data)

    if parsedPacket and parsedPacket.capacity_points_into_level then
        XP.Tracking.Capacity.Total = parsedPacket.capacity_points_into_level
    end
end

-- ------------------------------------------------------------------------------------------------------
-- EP needs to be tracked manually.
-- ------------------------------------------------------------------------------------------------------
---@param data table
-- ------------------------------------------------------------------------------------------------------
XP.OnExemplarUpdate = function(data)
    local parsedPacket = Ashita.Packets.StatUpdate(data)

    if parsedPacket and parsedPacket.exemplar_points_into_level and parsedPacket.exemplar_level_max then
        XP.Tracking.Exemplar.IntoLevel = parsedPacket.exemplar_points_into_level
        XP.Tracking.Exemplar.LevelMax  = parsedPacket.exemplar_level_max
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the XP is either XP or limit points.
-- ------------------------------------------------------------------------------------------------------
---@param messageId integer
---@return integer
-- ------------------------------------------------------------------------------------------------------
XP.GetMessageXPType = function(messageId)
    if not messageId then
        return XP.Type.ERROR
    end

    if XP.Messages.EXP[messageId] then
        return XP.Type.EXPERIENCE
    elseif XP.Messages.LP[messageId] then
        return XP.Type.LIMIT
    elseif XP.Messages.CP[messageId] then
        return XP.Type.CAPACITY
    elseif XP.Messages.EP[messageId] then
        return XP.Type.EXEMPLAR
    end

    return XP.Type.ERROR
end

-- ------------------------------------------------------------------------------------------------------
-- Sets XP display mode.
-- ------------------------------------------------------------------------------------------------------
XP.RefreshDisplayMode = function()
    if Ashita.Player.ExpTNL() == 1 then
        XP.DisplayMode = XP.Type.LIMIT
    else
        XP.DisplayMode = XP.Type.EXPERIENCE
    end
end

------------------------------------------------------------------------------------------------------
-- DEPRECATED (Keeping for future reference.)
-- Converts a codepoint to UTF8.
------------------------------------------------------------------------------------------------------
---@param codepoint any
---@return string
------------------------------------------------------------------------------------------------------
XP.Unicode_To_UTF8 = function(codepoint)
    if codepoint <= 0x7F then
        return string.char(codepoint)
    elseif codepoint <= 0x7FF then
        return string.char(0xC0 + math.floor(codepoint / 0x40), 0x80 + (codepoint % 0x40))
    elseif codepoint <= 0xFFFF then
        return string.char(0xE0 + math.floor(codepoint / 0x1000), 0x80 + (math.floor(codepoint / 0x40) % 0x40), 0x80 + (codepoint % 0x40))
    elseif codepoint <= 0x10FFFF then
        return string.char(0xF0 + math.floor(codepoint / 0x40000), 0x80 + (math.floor(codepoint / 0x1000) % 0x40), 0x80 + (math.floor(codepoint / 0x40) % 0x40), 0x80 + (codepoint % 0x40))
    else
        return "Codepoint out of range"
    end
end