Window = {}

function Window:New(init_settings)

    local self = {}
    init_settings = init_settings or {}

    local name       = init_settings.Name       or "Default"
    local title      = init_settings.Title      or "Default Title"
    local module     = init_settings.Module     or "Default"
    local settings   = init_settings.Settings   or {}
    local show_title = init_settings.Show_Title or false
    local show_bg    = true

    local need_position_reset = true
    local scaling_set = false
    local visible = {settings.Visible[1]}

    local flags_default = bit.bor(
        ImGuiWindowFlags_AlwaysAutoResize,  -- This prevents manual resizing, but without it things look messed up.
        ImGuiWindowFlags_NoSavedSettings,
        ImGuiWindowFlags_NoNav
    )

    ------------------------------------------------------------------------------------------------------
    -- Populates the window.
    ------------------------------------------------------------------------------------------------------
    ---@param content? function
    ------------------------------------------------------------------------------------------------------
    self.Populate = function(content)
        visible[1] = Window_Manager.Get_Visibility(module)
        if Ashita.Player.Is_Zoning() or not visible[1] then return nil end

        UI.PushStyleVar(ImGuiStyleVar_Alpha, Window_Manager.Config.Get_Alpha())
        UI.PushStyleVar(ImGuiStyleVar_CellPadding, {10, 1})
        UI.PushStyleVar(ImGuiStyleVar_WindowPadding, {7, 3})
        UI.PushStyleVar(ImGuiStyleVar_ItemSpacing, {0, 5})
        UI.PushStyleVar(ImGuiStyleVar_ItemInnerSpacing, {5, 0})

        local flags = flags_default
        if not Window_Manager.Settings.Show_Title and not show_title then flags = bit.bor(flags, ImGuiWindowFlags_NoTitleBar) end
        if not show_bg then flags = bit.bor(flags, ImGuiWindowFlags_NoBackground) end
        self.Check_Position()

        if UI.Begin(title, visible, flags) then
            self.Update_Settings()
            self.Set_Scaling()
            Window_Manager.Theme.Set()
            if content then content() end
            UI.End()
        end

        UI.PopStyleVar(5)
    end

    ------------------------------------------------------------------------------------------------------
    -- Checks if the position of the window needs to be reset ex: switching characters.
    ------------------------------------------------------------------------------------------------------
    self.Check_Position = function()
        if need_position_reset then
            UI.SetNextWindowPos({settings.X, settings.Y}, ImGuiCond_Always)
            need_position_reset = false
        end
    end

    ------------------------------------------------------------------------------------------------------
    -- Updates the window position for the settings file.
    ------------------------------------------------------------------------------------------------------
    self.Update_Settings = function()
        settings.X, settings.Y = UI.GetWindowPos()
        settings.Visible[1] = visible[1]
    end

    ------------------------------------------------------------------------------------------------------
    -- Checks whether the window is currently visible.
    ------------------------------------------------------------------------------------------------------
    self.Is_Visible = function()
        return visible[1]
    end

    ------------------------------------------------------------------------------------------------------
    -- Toggles window visibility.
    ------------------------------------------------------------------------------------------------------
    self.Toggle_Visibility = function()
        visible[1] = not visible[1]
        settings.Visible[1] = visible[1]
    end

    ------------------------------------------------------------------------------------------------------
    -- Makes the window visible.
    ------------------------------------------------------------------------------------------------------
    self.Show = function()
        visible[1] = true
        settings.Visible[1] = visible[1]
    end

    ------------------------------------------------------------------------------------------------------
    -- Makes the window invisible.
    ------------------------------------------------------------------------------------------------------
    self.Hide = function()
        visible[1] = false
        settings.Visible[1] = visible[1]
    end

    ------------------------------------------------------------------------------------------------------
    -- Makes the window active either by switching to the tab or by toggling the window.
    ------------------------------------------------------------------------------------------------------
    self.Make_Active = function()
        Window_Manager.Switch_Module(name)
        self.Toggle_Visibility()
    end

    ------------------------------------------------------------------------------------------------------
    -- Forces the position to need a reset for cases like character switch.
    ------------------------------------------------------------------------------------------------------
    self.Settings_Reset = function()
        need_position_reset = true
        scaling_set = false
    end

    ------------------------------------------------------------------------------------------------------
    -- Sets the window scaling.
    ------------------------------------------------------------------------------------------------------
    self.Set_Scaling = function()
        if not scaling_set then
            UI.SetWindowFontScale(Window_Manager.Config.Get_Scaling())
            scaling_set = true
        end
    end

    ------------------------------------------------------------------------------------------------------
    -- Forces the scaling flag to reset after toggling the scaling setting.
    ------------------------------------------------------------------------------------------------------
    self.Force_Scaling_Reset = function()
        scaling_set = false
    end

    ------------------------------------------------------------------------------------------------------
    -- Forces the scaling flag to reset after toggling the scaling setting.
    ------------------------------------------------------------------------------------------------------
    ---@param background boolean
    ------------------------------------------------------------------------------------------------------
    self.Set_Background = function(background)
        show_bg = background
    end

    -- Adds this window to the Window Manager list of windows.
    Window_Manager.Add_Window(module, module, self)

    return self
end
