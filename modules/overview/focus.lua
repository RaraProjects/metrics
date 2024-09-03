Overview.Focus = T{}

------------------------------------------------------------------------------------------------------
-- Content for the Focus screenshot window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Overview.Focus.Content = function(player_name)
    UI.Text("Overall") Focus.Overall(player_name)
    UI.Separator() UI.Text("Melee")        Focus.Melee.Display(player_name)
    UI.Separator() UI.Text("Ranged")       Focus.Ranged.Display(player_name)
    UI.Separator() UI.Text("Weaponskills") Focus.WS.Display(player_name, true)
    UI.Separator() UI.Text("Magic")        Focus.Magic.Display(player_name, true)
    UI.Separator() UI.Text("Abilities")    Focus.Abilities.Display(player_name, true)
    UI.Separator() UI.Text("Pets")         Focus.Pets.Display(player_name)
    UI.Separator() UI.Text("Defense")      Focus.Defense.Display(player_name)
end