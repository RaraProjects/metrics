XP = {}
-- ASB Code: /src/map/utils/charutils.cpp->AddExperiencePoints
-- ASB Code: /src/map/utils/charutils.cpp->DistributeExperiencePoints
-- https://github.com/Shinzaku/Points

require("modules.exp.columns")
require("modules.exp.config")
require("modules.exp.tracking")
require("modules.exp.chains")
require("modules.exp.dedication")
require("modules.exp.widgets")

XP.Name   = "XP"
XP.Title  = "Metrics - EXP"
XP.Module = "XP"
XP.File   = "exp"

XP.Table_Flags = bit.bor(ImGuiTableFlags_Borders)

XP.Type = {
    ERROR      = 0,
    EXPERIENCE = 1,
    LIMIT      = 2,
    CAPACITY   = 3,
    EXEMPLAR   = 4,
}

XP.Messages = {}
XP.Messages.ALL = {
    [8]   = true,   -- EXP No chain
    [253] = true,   -- EXP Chain
    [371] = true,   -- LP No chain
    [372] = true,   -- LP Chain
    [718] = true,   -- CP No chain
    [735] = true,   -- CP Chain
    [809] = true,   -- EP No chain
    [810] = true,   -- EP Chain
}
XP.Messages.EXP = {
    [8]   = true,   -- No chain
    [253] = true,   -- Chain
}
XP.Messages.LP = {
    [371] = true,   -- No chain
    [372] = true,   -- Chain
}
XP.Messages.CP = {
    [718] = true,   -- No chain
    [735] = true,   -- Chain
}
XP.Messages.EP = {
    [809] = true,   -- No chain
    [810] = true,   -- Chain
}
XP.Messages.Chain = {
    [253] = true,   -- Experience points
    [372] = true,   -- Limit points
    [735] = true,   -- Capacity points
    [810] = true,   -- Exemplar points
}

XP.Full_Bar_Height = 18
XP.Tiny_Bar_Height = 8
XP.Is_Initialized  = false
XP.Display_Mode    = XP.Type.EXPERIENCE
XP.Show_Additional_Info    = false
XP.Show_Reset_Confirmation = false

-- ------------------------------------------------------------------------------------------------------
-- Initializes the XP module.
-- ------------------------------------------------------------------------------------------------------
XP.Initialize = function(settings)
    if not XP.Is_Initialized then
        if Ashita and Res and Window_Manager and UI and DB and Column then

            -- Get saved settings from file.
            XP.Settings = settings or Settings_File.load(XP.Config.Defaults, XP.File)

            -- Create the XP Window.
            XP.Window = Window:New({
                Name     = XP.Name,
                Title    = XP.Title,
                Module   = XP.Module,
                Settings = XP.Settings,
            })

            XP.Window.Set_Background(XP.Settings.Show_Background)

            -- Dedication
            XP.Dedication.Check()
            XP.Dedication.Need_Defaulting = false
            XP.Dedication.Need_Clear      = false
            if XP.Settings.Boost_Item_Rate <= 0 then
                XP.Dedication.Need_Defaulting = true
                XP.Dedication.Need_Clear      = true
            end

            XP.Columns.Count()          -- Refresh the number of columns to show in the table.
            XP.Refresh_Display_Mode()   -- Based on type of XP--experience, limit, etc.

            -- Tracking
            XP.Tracking.Initialize()

            XP.Is_Initialized   = true
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Populates the XP window.
-- ------------------------------------------------------------------------------------------------------
XP.Content = function()
    if not XP.Settings.Mini_Mode_Enabled then
        XP.Config.Settings_Button()             -- Settings
        XP.Widgets.Tracking_Button()            -- Tracking (if Debug mode is enabled)
        XP.Widgets.Reset_Button()               -- Reset button
        XP.Widgets.Reset_Confirmation_Button()  -- Reset confirmation
    end

    XP.Refresh_Display_Mode()
    XP.Display_Table()
    XP.Tracking.Debug_Content()

    if Window_Manager.Can_Bar_Load() then
        XP.Widgets.Level_Progress_Bar()
        XP.Widgets.Boost_Progress_Bar()
    else
        -- Show a loading message if the progress bar can't be loaded but it's set to show.
        if XP.Settings.Show_XP_Progress_Bar or XP.Settings.Show_Boost_Progress_Bar then UI.Text("Loading...") end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the experience points rows.
-- ------------------------------------------------------------------------------------------------------
XP.Display_Table = function()
    local flags       = Column.Flags.None
    local table_flags = XP.Table_Flags
    table_flags       = bit.bor(table_flags, ImGuiTableFlags_RowBg)

    -- XP Mode determines which type of XP is displayed.
    local xp_type = XP.Display_Mode
    if not xp_type then xp_type = XP.Type.EXPERIENCE end

    local type_string  = "XP"
    local level_string = "L"
    if xp_type == XP.Type.LIMIT then
        type_string  = "LP"
        level_string = "M"
    end

    UI.PushStyleColor(ImGuiCol_TableRowBg, Window_Manager.Theme.Table_Row_Bg)
    if UI.BeginTable("XP Metrics", XP.Columns.Display_Count, table_flags) then
        -- Headers
        if XP.Settings.Show_Job                 then UI.TableSetupColumn("Job", flags) end
        UI.TableSetupColumn("Chain", flags)
        UI.TableSetupColumn("*" .. type_string .. "/hr", flags)
        if XP.Settings.Show_Base_Rate           then UI.TableSetupColumn(type_string .. "/hr",  flags) end
        if XP.Settings.Show_Time_To_Level       then UI.TableSetupColumn("~TT" .. level_string, flags) end
        if XP.Settings.Show_Boost_Time_To_Level then UI.TableSetupColumn("TTB",                 flags) end
        if XP.Settings.Show_TNL                 then UI.TableSetupColumn("TN" .. level_string,  flags) end
        if XP.Settings.Show_Capacity_Base_Rate  then UI.TableSetupColumn("CP/hr",               flags) end
        if XP.Settings.Show_Time_To_Job_Point   then UI.TableSetupColumn("~TTJP",               flags) end
        if XP.Settings.Show_TNJP                then UI.TableSetupColumn("TNJP",                flags) end
        if XP.Settings.Show_Exemplar_Base_Rate  then UI.TableSetupColumn("EP/hr",               flags) end
        if XP.Settings.Show_Time_To_Mastery     then UI.TableSetupColumn("~TTML",               flags) end
        if XP.Settings.Show_TNML                then UI.TableSetupColumn("TNML",                flags) end
        if XP.Settings.Show_Kill_Rate           then UI.TableSetupColumn("Time/Kill",           flags) end
        if XP.Settings.Show_Average_XP          then UI.TableSetupColumn("XP/Kill",             flags) end
        if XP.Settings.Show_Total_XP_Gained     then UI.TableSetupColumn("Total",               flags) end
        if XP.Settings.Show_Max_Chain           then UI.TableSetupColumn("Max Chain",           flags) end
        if XP.Settings.Show_Zone_Time           then UI.TableSetupColumn("Zone Time",           flags) end
        if XP.Settings.Show_Boost_Item          then UI.TableSetupColumn("Bonus",               flags) end
        if XP.Settings.Show_Boost_Rate          then UI.TableSetupColumn("Bonus %",             flags) end
        if XP.Settings.Show_Boost_Max           then UI.TableSetupColumn("Bonus Max",           flags) end
        UI.TableHeadersRow()

        -- Content
        if XP.Settings.Show_Job                 then UI.TableNextColumn() XP.Columns.Job() end
                                                     UI.TableNextColumn() XP.Columns.Chain()
                                                     UI.TableNextColumn() UI.Text(XP.Columns.Average_Rate(xp_type))
        if XP.Settings.Show_Base_Rate           then UI.TableNextColumn() UI.Text(XP.Columns.Average_Rate(xp_type, true)) end
        if XP.Settings.Show_Time_To_Level       then UI.TableNextColumn() XP.Columns.Time_To_Level(xp_type) end
        if XP.Settings.Show_Boost_Time_To_Level then UI.TableNextColumn() XP.Columns.Time_To_Finish_Dedication(xp_type) end
        if XP.Settings.Show_TNL                 then UI.TableNextColumn() UI.Text(XP.Columns.TNL(xp_type)) end
        if XP.Settings.Show_Capacity_Base_Rate  then UI.TableNextColumn() UI.Text(XP.Columns.Average_Rate(XP.Type.CAPACITY)) end
        if XP.Settings.Show_Time_To_Job_Point   then UI.TableNextColumn() XP.Columns.Time_To_Level(XP.Type.CAPACITY) end
        if XP.Settings.Show_TNJP                then UI.TableNextColumn() UI.Text(XP.Columns.TNL(XP.Type.CAPACITY)) end
        if XP.Settings.Show_Exemplar_Base_Rate  then UI.TableNextColumn() UI.Text(XP.Columns.Average_Rate(XP.Type.EXEMPLAR)) end
        if XP.Settings.Show_Time_To_Mastery     then UI.TableNextColumn() XP.Columns.Time_To_Level(XP.Type.EXEMPLAR) end
        if XP.Settings.Show_TNML                then UI.TableNextColumn() UI.Text(XP.Columns.TNL(XP.Type.EXEMPLAR)) end
        if XP.Settings.Show_Kill_Rate           then
            local kill_time = XP.Columns.Average_Kill_Time(XP.Tracking.Last_XP_Gain_Time, XP.Tracking.Kill_Times_XP)
            if kill_time < 0 then
                UI.TableNextColumn() UI.Text("--:--")
            else
                UI.TableNextColumn() UI.Text(Timers.Format(kill_time, true))
            end
        end
        if XP.Settings.Show_Average_XP          then UI.TableNextColumn() UI.Text(string.format("%d", XP.Columns.Average_XP(xp_type))) end
        if XP.Settings.Show_Total_XP_Gained     then UI.TableNextColumn() UI.Text(XP.Columns.Total_XP(xp_type)) end
        if XP.Settings.Show_Max_Chain           then UI.TableNextColumn() UI.Text(XP.Columns.Max_Chain()) end
        if XP.Settings.Show_Zone_Time           then UI.TableNextColumn() UI.Text(XP.Columns.Zone_Time()) end
        if XP.Settings.Show_Boost_Item          then UI.TableNextColumn() UI.Text(tostring(XP.Settings.Boost_Item_Name)) end
        if XP.Settings.Show_Boost_Rate          then UI.TableNextColumn() UI.Text(XP.Columns.Dedication_Bonus()) end
        if XP.Settings.Show_Boost_Max           then UI.TableNextColumn() UI.Text(XP.Columns.Dedication_Progress()) end

        UI.EndTable()
    end
    UI.PopStyleColor(1)
end

-- ------------------------------------------------------------------------------------------------------
-- Primary XP driving function.
-- RoE quests that give EXP also come through here. They result in zero kill times.
-- ------------------------------------------------------------------------------------------------------
---@param raw_packet any
-- ------------------------------------------------------------------------------------------------------
XP.Handle_Packet = function(raw_packet)
    if not raw_packet then return nil end

    -- Parse the packet.
    local parsed_packet = Ashita.Packets.EXP(raw_packet)
    if not parsed_packet then return nil end

    -- Records of Eminance also come through this packet. Exclude non-XP related content.
    local message_id = parsed_packet.message_id
    if not XP.Messages.ALL[message_id] then return nil end

    local xp_type = XP.Get_Message_XP_Type(parsed_packet.message_id)
    if xp_type == XP.Type.ERROR then return nil end

    local xp_amount = parsed_packet.xp_amount

    -- Kill time rate metrics. Add XP to sum total.
    if xp_type == XP.Type.EXPERIENCE or xp_type == XP.Type.LIMIT then
        XP.Tracking.Add_Total_XP(xp_amount, xp_type)
        XP.Tracking.Last_XP_Gain_Time = XP.Tracking.Set_Kill_Time(XP.Tracking.Last_XP_Gain_Time, XP.Tracking.Kill_Times_XP)

    -- Kill time rate metrics. Add capacity to sum total.
    elseif xp_type == XP.Type.CAPACITY then
        XP.Tracking.Add_Total_CP(xp_amount)
        XP.Tracking.Last_CP_Gain_Time = XP.Tracking.Set_Kill_Time(XP.Tracking.Last_CP_Gain_Time, XP.Tracking.Kill_Times_CP)

    elseif xp_type == XP.Type.EXEMPLAR then
        XP.Tracking.Add_Total_EP(xp_amount)
        XP.Tracking.Last_EP_Gain_Time = XP.Tracking.Set_Kill_Time(XP.Tracking.Last_EP_Gain_Time, XP.Tracking.Kill_Times_EP)
    end

    -- Handle chains for EM and above. I've observed 100 XP for EM mobs.
    if xp_amount >= 100 then XP.Chains.Start(parsed_packet.chain_count) end
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the XP is either XP or limit points.
-- ------------------------------------------------------------------------------------------------------
---@param message_id integer
---@return integer
-- ------------------------------------------------------------------------------------------------------
XP.Get_Message_XP_Type = function(message_id)
    if not message_id then return XP.Type.ERROR end

    if     XP.Messages.EXP[message_id] then return XP.Type.EXPERIENCE
    elseif XP.Messages.LP[message_id]  then return XP.Type.LIMIT
    elseif XP.Messages.CP[message_id]  then return XP.Type.CAPACITY
    elseif XP.Messages.EP[message_id]  then return XP.Type.EXEMPLAR
    end

    return XP.Type.ERROR
end

-- ------------------------------------------------------------------------------------------------------
-- Sets XP display mode.
-- ------------------------------------------------------------------------------------------------------
XP.Refresh_Display_Mode = function()
    if Ashita.Player.Exp_TNL() == 1 then
        XP.Display_Mode = XP.Type.LIMIT
    else
        XP.Display_Mode = XP.Type.EXPERIENCE
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