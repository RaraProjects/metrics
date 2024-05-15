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