local widgets = { }

widgets.sliderWidth = 100

------------------------------------------------------------------------------------------------------
-- Creates a help text marker.
------------------------------------------------------------------------------------------------------
widgets.HelpMarker = function(text)
    UI.SameLine()
    UI.TextDisabled('(?)')
    if UI.IsItemHovered() then
        UI.BeginTooltip()
        UI.PushTextWrapPos(UI.GetFontSize() * 25)
        UI.TextUnformatted(text)
        UI.PopTextWrapPos()
        UI.EndTooltip()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets window scaling.
------------------------------------------------------------------------------------------------------
widgets.slider = function(args)
    if not args or not args.settingTable or not args.settingName then
        return UI.Text('Unable to parse settings table.')
    end

    local currentSetting = args.settingTable[args.settingName]

    if type(currentSetting) ~= 'number' then
        return UI.Text('Invalid slider value.')
    end

    local width  = args.width or widgets.sliderWidth
    local label  = args.label or 'Slider Name'
    local step   = args.step or 0.005
    local min    = args.min or 0
    local max    = args.max or 1
    local format = args.format or '%.2f'
    local flags  = args.flags or ImGuiSliderFlags_None
    local value = { currentSetting }

    UI.SetNextItemWidth(width)

    if UI.DragFloat(label, value, step, min, max, format, flags) then
        local v = value[1]

        v = math.clamp(v, min, max)

        args.settingTable[args.settingName] = v
    end

    if args.help then
        widgets.HelpMarker(args.help)
    end
end

------------------------------------------------------------------------------------------------------
-- Creates a checkbox that can toggle a setting.
-- I'm trying to take advantage of Lua passing tables by reference, but I have send the setting name via string.
------------------------------------------------------------------------------------------------------
---@param caption         string
---@param settingsPointer table
---@param settingName     string
------------------------------------------------------------------------------------------------------
widgets.ToggleCheckbox = function(caption, settingsPointer, settingName)
    if not caption or not settingsPointer or not settingName then
        return nil
    end

    if settingsPointer[settingName] == nil then
        return nil
    end

    if UI.Checkbox(tostring(caption), {settingsPointer[settingName]}) then
        settingsPointer[settingName] = not settingsPointer[settingName]
    end
end

return widgets
