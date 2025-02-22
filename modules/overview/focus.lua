Overview.Focus = { }

------------------------------------------------------------------------------------------------------
-- Content for the Focus screenshot window.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Overview.Focus.Content = function(playerName)
    UI.Text("Overall") Focus.OverallDamageBreakdown(playerName)
    UI.Separator() UI.Text("Melee")        Focus.Melee.Display(playerName)
    UI.Separator() UI.Text("Ranged")       Focus.Ranged.Display(playerName)
    UI.Separator() UI.Text("Weaponskills") Focus.WS.Display(playerName, true)
    UI.Separator() UI.Text("Magic")        Focus.Magic.Display(playerName, true)
    UI.Separator() UI.Text("Abilities")    Focus.Abilities.Display(playerName, true)
    UI.Separator() UI.Text("Pets")         Focus.Pets.Display(playerName)
    UI.Separator() UI.Text("Defense")      Focus.Defense.Display(playerName)
end