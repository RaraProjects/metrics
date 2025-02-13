Blog.Widgets = {}

Blog.Widgets.Player_Focus = DB.Enum.NONE
Blog.Widgets.Player_Index = 1

Blog.Widgets.Action_Buffer = {}

------------------------------------------------------------------------------------------------------
-- Toggles the settings showing for the battle log.
------------------------------------------------------------------------------------------------------
Blog.Widgets.Settings_Button = function()
    if UI.SmallButton("Settings") then
        Config.Button_Toggle(Config.Enum.File.BLOG)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the filter pages showing.
------------------------------------------------------------------------------------------------------
Blog.Widgets.Show_Page = function()
    if UI.SmallButton("Paging") then
        Blog.Settings.Is_Paging_Enabled = not Blog.Settings.Is_Paging_Enabled
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
    UI.SetNextItemWidth(Blog.Enum.SLIDER_WIDTH_PAGE)
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

------------------------------------------------------------------------------------------------------
-- Creates a dropdown menu to show only damage done by a certain entity.
------------------------------------------------------------------------------------------------------
Blog.Widgets.Player_Filter = function()
    local list = DB.Lists.Players or { }
    local flags = DB.Widgets.Dropdown.Flags
    if list[1] then
        UI.SetNextItemWidth(DB.Widgets.Dropdown.Width)
        if UI.BeginCombo(DB.Widgets.Dropdown.Enum.FOCUS, list[Blog.Widgets.Player_Index], flags) then
            for n = 1, #list, 1 do
                local is_selected = Blog.Widgets.Player_Index == n
                if UI.Selectable(list[n], is_selected) then
                    Blog.Widgets.Player_Index = n
                    Blog.Widgets.Player_Focus = list[n]
                end
                if is_selected then
                    UI.SetItemDefaultFocus()
                end
            end
            UI.EndCombo()
        end
    else
        if UI.BeginCombo(DB.Widgets.Dropdown.Enum.FOCUS, DB.Enum.NONE, flags) then
            UI.EndCombo()
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Creates an input text box for the action filter.
------------------------------------------------------------------------------------------------------
Blog.Widgets.Action_Filter_Input = function()
    UI.SetNextItemWidth(150) UI.InputText("Action", Blog.Widgets.Action_Buffer, 100, ImGuiInputTextFlags_AutoSelectAll)
end