Blog.Widgets = T{}

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
    if UI.SmallButton("Settings") then
        Blog.Config.Show_Settings = not Blog.Config.Show_Settings
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the filter pages showing.
------------------------------------------------------------------------------------------------------
Blog.Widgets.Show_Page = function()
    if UI.SmallButton("Paging") then
        Metrics.Blog.Flags.Paging = not Metrics.Blog.Flags.Paging
    end
end

------------------------------------------------------------------------------------------------------
-- Displays the battle log page buttons.
------------------------------------------------------------------------------------------------------
Blog.Widgets.Page_Buttons = function()
    Blog.Widgets.First_Page()
    UI.SameLine() UI.Text(" ") UI.SameLine() Blog.Widgets.Previous_Page()
    UI.SameLine() UI.Text(" ") UI.SameLine() Blog.Widgets.Page()
    UI.SameLine() UI.Text(" ") UI.SameLine() Blog.Widgets.Next_Page()
    UI.SameLine() UI.Text(" ") UI.SameLine() Blog.Widgets.Last_Page()
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