Overview = T{}

Overview.Name   = "Overview"
Overview.Title  = "Metrics - Overview"
Overview.Module = "Overview"
Overview.Window = Window:New({
    Name    = Overview.Name,
    Title   = Overview.Title,
    Module  = Overview.Module,
    Visible = {false},
    Show_Title = true,
})

Overview.Modes = T{
    PARSE = "Parse",
    FOCUS = "Focus",
    BLOG  = "Battle Log",
}
Overview.Mode = Overview.Modes.PARSE

require("modules.overview.config")
require("modules.overview.parse")
require("modules.overview.focus")

------------------------------------------------------------------------------------------------------
-- Opens a new window to show all tabs as a vertical column.
------------------------------------------------------------------------------------------------------
Overview.Content = function()
    if Overview.Mode == Overview.Modes.PARSE then
        Overview.Parse.Content()
    elseif Overview.Mode == Overview.Modes.FOCUS then
        local player_name = DB.Widgets.Util.Get_Player_Focus()
        if player_name == DB.Widgets.Dropdown.Enum.NONE then
            Focus.Screenshot_Mode[1] = false
            return nil
        end
        Overview.Focus.Content(player_name)
    else
        UI.Text("No content.")
    end
end

------------------------------------------------------------------------------------------------------
-- Button that opens the overview window with focus content.
------------------------------------------------------------------------------------------------------
Overview.Screenshot_Button = function()
    if UI.SmallButton("Screenshot") then
        if Overview.Mode == Overview.Modes.FOCUS then
            Overview.Window.Toggle_Visibility()
        else
            Overview.Window.Show()
            Overview.Mode = Overview.Modes.FOCUS
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Button that opens the overview window with parse content.
------------------------------------------------------------------------------------------------------
Overview.Overview_Button = function()
    if UI.SmallButton("Overview") then
        if Overview.Mode == Overview.Modes.PARSE then
            Overview.Window.Toggle_Visibility()
        else
            Overview.Window.Show()
            Overview.Mode = Overview.Modes.PARSE
        end
    end
end