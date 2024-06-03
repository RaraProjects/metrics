Blog.Widgets = T{}

------------------------------------------------------------------------------------------------------
-- Toggles whether damage highlighting takes place in the battle log.
------------------------------------------------------------------------------------------------------
Blog.Widgets.Damage_Highlighting = function()
    if UI.Checkbox("DMG Coloring", {Metrics.Blog.Flags.Damage_Highlighting}) then
        Metrics.Blog.Flags.Damage_Highlighting = not Metrics.Blog.Flags.Damage_Highlighting
    end
    UI.SameLine() Window.Widgets.HelpMarker("Damage over certain limits causes the text to highlight. "
                                    .. "It's a way for you to easily see if you or others are meeting your damage goals. "
                                    .. "Set the bar high and strive to win.")
end

------------------------------------------------------------------------------------------------------
-- Set the battle log damage highlighting threshold for weaponskills.
------------------------------------------------------------------------------------------------------
Blog.Widgets.WS_Threshold = function()
    local ws_threshold = {[1] = Metrics.Blog.Thresholds.WS}
    UI.SetNextItemWidth(Blog.Config.Slider_Width)
    if UI.DragInt("Weaponskill", ws_threshold, 1, 0, 99999, "%d", ImGuiSliderFlags_None) then
        Metrics.Blog.Thresholds.WS = ws_threshold[1]
    end
    UI.SameLine() Window.Widgets.HelpMarker("Weaponskill damage over this amount will be highlighted "
                                    .. "in the battle log.")
end

------------------------------------------------------------------------------------------------------
-- Set the battle log damage highlighting threshold for magic.
------------------------------------------------------------------------------------------------------
Blog.Widgets.Magic_Threshold = function()
    local magic_threshold = {[1] = Metrics.Blog.Thresholds.MAGIC}
    UI.SetNextItemWidth(Blog.Config.Slider_Width)
    if UI.DragInt("Spell", magic_threshold, 1, 0, 99999, "%d", ImGuiSliderFlags_None) then
        Metrics.Blog.Thresholds.MAGIC = magic_threshold[1]
    end
    UI.SameLine() Window.Widgets.HelpMarker("Magic damage over this amount will be highlighted "
                                    .. "in the battle log.")
end

------------------------------------------------------------------------------------------------------
-- Toggles the settings showing for the battle log.
------------------------------------------------------------------------------------------------------
Blog.Widgets.Settings_Button = function()
    if UI.Button("Settings") then
        Blog.Config.Show_Settings = not Blog.Config.Show_Settings
    end
    if Blog.Config.Show_Settings then
        Blog.Config.Display()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets the current battle log page.
------------------------------------------------------------------------------------------------------
Blog.Widgets.Page = function()
    local last_page = Blog.Max_Page()
    local page = {[1] = Blog.Page}
    UI.SetNextItemWidth(Blog.Config.Page_Slider_Width)
    if UI.DragInt("Page", page, 0.1, 1, last_page, "%d", ImGuiSliderFlags_None) then
        if last_page > 1 then Blog.Page = page[1] end
    end
end

------------------------------------------------------------------------------------------------------
-- Jumps to the first page in the battle log.
------------------------------------------------------------------------------------------------------
Blog.Widgets.First_Page = function()
    if UI.Button("First") then
        Blog.Page = 1
    end
end

------------------------------------------------------------------------------------------------------
-- Jumps to the previous page in the battle log.
------------------------------------------------------------------------------------------------------
Blog.Widgets.Previous_Page = function()
    if UI.Button("<") then
        local prev_page = Blog.Page - 1
        if prev_page < 1 then return nil end
        Blog.Page = prev_page
    end
end

------------------------------------------------------------------------------------------------------
-- Jumps to the next page in the battle log.
------------------------------------------------------------------------------------------------------
Blog.Widgets.Next_Page = function()
    if UI.Button(">") then
        local last_page = Blog.Max_Page()
        local next_page = Blog.Page + 1
        if next_page > last_page then return nil end
        Blog.Page = next_page
    end
end

------------------------------------------------------------------------------------------------------
-- Jumps to the last page in the battle log.
------------------------------------------------------------------------------------------------------
Blog.Widgets.Last_Page = function()
    local last_page = Blog.Max_Page()
    if UI.Button("Last (" .. tostring(last_page) .. ")") then
        Blog.Page = last_page
    end
end