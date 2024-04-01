local s = {}

s.Screen = {}

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
s.Screen.Settings = function()

    -- Overall
    if UI.CollapsingHeader("Overall Settings") then
        if UI.BeginTable("Overall Settings", 3) then
            UI.TableNextColumn()
            if UI.Checkbox("Compact Mode", {Monitor.Settings.Compact_Mode}) then
                Monitor.Settings.Compact_Mode = not Monitor.Settings.Compact_Mode
                Monitor.Calculate_Column_Flags()
            end

            UI.TableNextColumn()
            if UI.Checkbox("Include SC Damage", {Monitor.Settings.Include_SC_Damage}) then
                Monitor.Settings.Include_SC_Damage = not Monitor.Settings.Include_SC_Damage
                Monitor.Calculate_Column_Flags()
            end

            UI.TableNextColumn()
            if UI.Checkbox("Combine Crits", {Monitor.Settings.Combine_Crit}) then
                Monitor.Settings.Combine_Crit = not Monitor.Settings.Combine_Crit
            end


        UI.EndTable()
        end
    end

    -- Table
    if UI.CollapsingHeader("Table Settings") then
        if UI.BeginTable("Table Settings", 3) then
            UI.TableNextColumn()
            if UI.Checkbox("Total Damage Only", {Monitor.Display.Flags.Total_Damage_Only}) then
                Monitor.Display.Flags.Total_Damage_Only = not Monitor.Display.Flags.Total_Damage_Only
                Monitor.Calculate_Column_Flags()
            end

            UI.TableNextColumn()
            if UI.Checkbox("Total Accuracy", {Monitor.Display.Flags.Total_Acc}) then
                Monitor.Display.Flags.Total_Acc = not Monitor.Display.Flags.Total_Acc
                Monitor.Calculate_Column_Flags()
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show Crits", {Monitor.Display.Flags.Crit}) then
                Monitor.Display.Flags.Crit = not Monitor.Display.Flags.Crit
                Monitor.Calculate_Column_Flags()
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show Pets", {Monitor.Display.Flags.Pet}) then
                Monitor.Display.Flags.Pet = not Monitor.Display.Flags.Pet
                Monitor.Calculate_Column_Flags()
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show Healing", {Monitor.Display.Flags.Healing}) then
                Monitor.Display.Flags.Healing = not Monitor.Display.Flags.Healing
                Monitor.Calculate_Column_Flags()
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show Deaths", {Monitor.Display.Flags.Deaths}) then
                Monitor.Display.Flags.Deaths = not Monitor.Display.Flags.Deaths
                Monitor.Calculate_Column_Flags()
            end
        UI.EndTable()
        end
    end

    -- Rank_Cutoff = 6,
    -- Rank_Default = 6,
    -- Show_Percent = false,

    -- Focus Settings

    -- Battle Log Settings
    if UI.CollapsingHeader("Battle Log Settings") then
        if UI.BeginTable("Battle Log Settings", 3) then
            UI.TableNextColumn()
            if UI.Checkbox("Show Melee", {Blog.Display.Flags.Melee}) then
                Blog.Display.Flags.Melee = not Blog.Display.Flags.Melee
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show Ranged", {Blog.Display.Flags.Ranged}) then
                Blog.Display.Flags.Ranged = not Blog.Display.Flags.Ranged
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show WS", {Blog.Display.Flags.WS}) then
                Blog.Display.Flags.WS = not Blog.Display.Flags.WS
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show SC", {Blog.Display.Flags.SC}) then
                Blog.Display.Flags.SC = not Blog.Display.Flags.SC
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show Magic", {Blog.Display.Flags.Magic}) then
                Blog.Display.Flags.Magic = not Blog.Display.Flags.Magic
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show Ability", {Blog.Display.Flags.Ability}) then
                Blog.Display.Flags.Ability = not Blog.Display.Flags.Ability
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show Pet", {Blog.Display.Flags.Pet}) then
                Blog.Display.Flags.Pet = not Blog.Display.Flags.Pet
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show Healing", {Blog.Display.Flags.Healing}) then
                Blog.Display.Flags.Healing = not Blog.Display.Flags.Healing
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show Deaths", {Blog.Display.Flags.Deaths}) then
                Blog.Display.Flags.Deaths = not Blog.Display.Flags.Deaths
            end
        UI.EndTable()
        end
    end




    -- Theme Settings

end

return s