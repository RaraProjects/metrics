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

require("modules.overview.config")

------------------------------------------------------------------------------------------------------
-- Opens a new window to show all tabs as a vertical column.
------------------------------------------------------------------------------------------------------
Overview.Content = function()
    local player_name = DB.Widgets.Util.Get_Player_Focus()
    if player_name == DB.Widgets.Dropdown.Enum.NONE then
        Focus.Screenshot_Mode[1] = false
        return nil
    end

    if Debug.Is_Enabled() then
        Debug.Content()
    else
        UI.Text("Overall") Focus.Overall(player_name)
        UI.Separator() UI.Text("Melee")        Focus.Melee.Display(player_name)
        UI.Separator() UI.Text("Ranged")       Focus.Ranged.Display(player_name)
        UI.Separator() UI.Text("Weaponskills") Focus.WS.Display(player_name, true)
        UI.Separator() UI.Text("Magic")        Focus.Magic.Display(player_name, true)
        UI.Separator() UI.Text("Abilities")    Focus.Abilities.Display(player_name, true)
        UI.Separator() UI.Text("Pets")         Focus.Pets.Display(player_name)
        UI.Separator() UI.Text("Defense")      Focus.Defense.Display(player_name)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the settings showing for the battle log.
------------------------------------------------------------------------------------------------------
Overview.Screenshot_Button = function()
    if UI.SmallButton("Screenshot") then
        Overview.Window.Toggle_Visibility()
    end
end