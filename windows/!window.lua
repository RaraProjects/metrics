Window = { }

function Window:New(initSettings)

    local self = { }
    initSettings = initSettings or { }

    local name      = initSettings.Name       or "Default"
    local title     = initSettings.Title      or "Default Title"
    local module    = initSettings.Module     or "Default"
    local settings  = initSettings.Settings   or { }
    local showTitle = initSettings.Show_Title or false
    local showBg    = true

    local needPositionReset = true
    local isScalingSet      = false
    local isVisible         = { settings.Visible[1] }

    local flagDefaults = bit.bor
    (
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
        isVisible[1] = WindowManager.GetVisibility(module)

        if Ashita.Player.IsZoning() or not isVisible[1] then
            return nil
        end

        UI.PushStyleVar(ImGuiStyleVar_Alpha, WindowManager.Config.GetAlpha())
        UI.PushStyleVar(ImGuiStyleVar_CellPadding,      { 10, 1 })
        UI.PushStyleVar(ImGuiStyleVar_WindowPadding,    { 7,  3 })
        UI.PushStyleVar(ImGuiStyleVar_ItemSpacing,      { 0,  5 })
        UI.PushStyleVar(ImGuiStyleVar_ItemInnerSpacing, { 5,  0 })

        local flags = flagDefaults

        -- Title Bar
        if not WindowManager.Settings.Show_Title and not showTitle then
            flags = bit.bor(flags, ImGuiWindowFlags_NoTitleBar)
        end

        -- Background
        if not showBg then
            flags = bit.bor(flags, ImGuiWindowFlags_NoBackground)
        end

        self.CheckPosition()

        if UI.Begin(title, isVisible, flags) then
            self.UpdateSettings()
            self.SetScaling()
            WindowManager.Theme.Set()

            if content and type(content) == "function" then
                content()
            end

            UI.End()
        end

        UI.PopStyleVar(5)
    end

    ------------------------------------------------------------------------------------------------------
    -- Checks if the position of the window needs to be reset ex: switching characters.
    ------------------------------------------------------------------------------------------------------
    self.CheckPosition = function()
        if needPositionReset then
            UI.SetNextWindowPos({ settings.X, settings.Y }, ImGuiCond_Always)
            needPositionReset = false
        end
    end

    ------------------------------------------------------------------------------------------------------
    -- Updates the window position for the settings file.
    ------------------------------------------------------------------------------------------------------
    self.UpdateSettings = function()
        settings.X, settings.Y = UI.GetWindowPos()
        settings.Visible[1]    = isVisible[1]
    end

    ------------------------------------------------------------------------------------------------------
    -- Checks whether the window is currently visible.
    ------------------------------------------------------------------------------------------------------
    ---@return boolean
    ------------------------------------------------------------------------------------------------------
    self.IsVisible = function()
        return isVisible[1]
    end

    ------------------------------------------------------------------------------------------------------
    -- Toggles window visibility.
    ------------------------------------------------------------------------------------------------------
    self.ToggleVisibility = function()
        isVisible[1]        = not isVisible[1]
        settings.Visible[1] = isVisible[1]
    end

    ------------------------------------------------------------------------------------------------------
    -- Makes the window visible.
    ------------------------------------------------------------------------------------------------------
    self.Show = function()
        isVisible[1]        = true
        settings.Visible[1] = isVisible[1]
    end

    ------------------------------------------------------------------------------------------------------
    -- Makes the window invisible.
    ------------------------------------------------------------------------------------------------------
    self.Hide = function()
        isVisible[1]        = false
        settings.Visible[1] = isVisible[1]
    end

    ------------------------------------------------------------------------------------------------------
    -- Makes the window active either by switching to the tab or by toggling the window.
    ------------------------------------------------------------------------------------------------------
    self.MakeActive = function()
        WindowManager.SwitchModule(name)
        self.ToggleVisibility()
    end

    ------------------------------------------------------------------------------------------------------
    -- Forces the position to need a reset for cases like character switch.
    ------------------------------------------------------------------------------------------------------
    self.SettingsReset = function()
        needPositionReset = true
        isScalingSet      = false
    end

    ------------------------------------------------------------------------------------------------------
    -- Sets the window scaling.
    ------------------------------------------------------------------------------------------------------
    self.SetScaling = function()
        if not isScalingSet then
            if UI.GetStyle then
                local style = UI.GetStyle()

                -- Ashita 4.2.0.1+
                if style and style.FontScaleMain ~= nil then
                    style.FontScaleMain = WindowManager.Settings.Window_Scaling
                end

                -- Ashita Legacy
                if WindowManager.IO and WindowManager.IO.FontGlobalScale ~= nil then
                    WindowManager.IO.FontGlobalScale = WindowManager.Settings.Window_Scaling
                end
            end
            isScalingSet = true
        end
    end

    ------------------------------------------------------------------------------------------------------
    -- Forces the scaling flag to reset after toggling the scaling setting.
    ------------------------------------------------------------------------------------------------------
    self.ForceScalingReset = function()
        isScalingSet = false
    end

    ------------------------------------------------------------------------------------------------------
    -- Forces the scaling flag to reset after toggling the scaling setting.
    ------------------------------------------------------------------------------------------------------
    ---@param background boolean
    ------------------------------------------------------------------------------------------------------
    self.SetBackground = function(background)
        showBg = background
    end

    -- Adds this window to the Window Manager list of windows.
    WindowManager.AddWindow(module, module, self)

    return self
end
