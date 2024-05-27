Report = T{}

Report.Section = T{}

-- Load dependencies
require("tabs.report.config")
require("tabs.report.publishing")
require("tabs.report.widgets")

------------------------------------------------------------------------------------------------------
-- Creates some buttons to publish various party metrics to chat.
------------------------------------------------------------------------------------------------------
Report.Populate = function()
    Report.Widgets.Settings_Button()
    UI.Separator() Report.Section.Chat_Reports()
    UI.Separator() Report.Section.File()
    UI.Separator() Report.Section.Monsters_Defeated()
end

------------------------------------------------------------------------------------------------------
-- Builds the chat report section.
------------------------------------------------------------------------------------------------------
Report.Section.Chat_Reports = function()
    local col_flags = Column.Flags.None
    local width = Column.Widths.Report
    UI.Text("Chat Reports")
    Report.Widgets.Chat_Mode()
    if UI.BeginTable("Chat Reports", 4, Window.Table.Flags.None) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)
        UI.TableSetupColumn("Col 4", col_flags, width)

        UI.TableNextRow()
        UI.TableNextColumn()
        if UI.Button("Total Damage") then
            Report.Publishing.Total_Damage()
            return nil
        end
        UI.TableNextColumn()
        if UI.Button("Accuracy    ") then
            Report.Publishing.Accuracy()
            return nil
        end
        UI.TableNextColumn()
        UI.TableNextColumn()
        --
        UI.TableNextColumn()
        if UI.Button("Melee       ") then
            Report.Publishing.Damage_By_Type(DB.Enum.Trackable.MELEE)
            return nil
        end
        UI.TableNextColumn()
        if UI.Button("Weaponskills") then
            Report.Publishing.Damage_By_Type(DB.Enum.Trackable.WS)
            return nil
        end
        UI.TableNextColumn()
        if UI.Button("Magic       ") then
            Report.Publishing.Damage_By_Type(DB.Enum.Trackable.MAGIC)
            return nil
        end
        UI.TableNextColumn()
        if UI.Button("Pet         ") then
            Report.Publishing.Damage_By_Type(DB.Enum.Trackable.PET)
            return nil
        end
        --
        UI.TableNextColumn()
        if UI.Button("Abilities   ") then
            Report.Publishing.Damage_By_Type(DB.Enum.Trackable.ABILITY)
            return nil
        end
        UI.TableNextColumn()
        if UI.Button("Healing     ") then
            Report.Publishing.Damage_By_Type(DB.Enum.Trackable.HEALING)
            return nil
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Builds the file section.
------------------------------------------------------------------------------------------------------
Report.Section.File = function()
    local col_flags = Column.Flags.None
    local width = Column.Widths.Report
    UI.Text("Create CSV File")
    UI.Text("Files can be found in: /config/Metrics/")

    local blog_length = #Blog.Log
    if blog_length >= 50000 then
        UI.Text("NOTICE: There are " .. tostring(blog_length) .. " entries in the battle log.")
        UI.Text("        You may notice a stagger when saving it.")
    end

    if UI.BeginTable("Save File", 4, Window.Table.Flags.None) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextRow()
        UI.TableNextColumn()
        if UI.Button("Database    ") then
            File.Save_Data()
            File.Save_Catalog()
            return nil
        end
        UI.TableNextColumn()
        if UI.Button("Battle Log  ") then
            File.Save_Battlelog()
            return nil
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Builds the monsters defeated section.
------------------------------------------------------------------------------------------------------
Report.Section.Monsters_Defeated = function()
    UI.Text("Monsters Defeated")
    local mobs_defeated = 0
    for mob_name, count in pairs(DB.Tracking.Defeated_Mobs) do
        UI.BulletText(mob_name .. ": " .. tostring(count))
        mobs_defeated = mobs_defeated + 1
    end
    if mobs_defeated == 0 then UI.BulletText("None") end
end