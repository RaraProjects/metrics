Blog.Widgets = { }

Blog.Widgets.PlayerFocus  = DB.Enum.NONE
Blog.Widgets.PlayerIndex  = 1
Blog.Widgets.ActionBuffer = { }

------------------------------------------------------------------------------------------------------
-- Toggles the settings showing for the battle log.
------------------------------------------------------------------------------------------------------
Blog.Widgets.SettingsButton = function()
    if UI.SmallButton("Settings") then
        Config.Button_Toggle(Config.Enum.File.BLOG)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the filter pages showing.
------------------------------------------------------------------------------------------------------
Blog.Widgets.ShowPage = function()
    if UI.SmallButton("Paging") then
        Blog.Settings.Is_Paging_Enabled = not Blog.Settings.Is_Paging_Enabled
    end
end

------------------------------------------------------------------------------------------------------
-- Displays the battle log page buttons.
------------------------------------------------------------------------------------------------------
Blog.Widgets.PageButtons = function()
    Blog.Widgets.FirstPage()
    UI.SameLine() UI.Text(" ") UI.SameLine() Blog.Widgets.PreviousPage()
    UI.SameLine() UI.Text(" ") UI.SameLine() Blog.Widgets.Page()
    UI.SameLine() UI.Text(" ") UI.SameLine() Blog.Widgets.NextPage()
    UI.SameLine() UI.Text(" ") UI.SameLine() Blog.Widgets.LastPage()
end

------------------------------------------------------------------------------------------------------
-- Sets the current battle log page.
------------------------------------------------------------------------------------------------------
Blog.Widgets.Page = function()
    local lastPage = Blog.MaxPage()
    local page     = { Blog.Page }

    UI.SetNextItemWidth(Blog.Enum.SLIDER_WIDTH_PAGE)

    if UI.DragInt("Page", page, 0.1, 1, lastPage, "%d", ImGuiSliderFlags_None) then
        if lastPage > 1 then
            Blog.Page = page[1]
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Jumps to the first page in the battle log.
------------------------------------------------------------------------------------------------------
Blog.Widgets.FirstPage = function()
    if UI.Button("First") then
        Blog.Page = 1
    end
end

------------------------------------------------------------------------------------------------------
-- Jumps to the previous page in the battle log.
------------------------------------------------------------------------------------------------------
Blog.Widgets.PreviousPage = function()
    if UI.Button("<") and Blog.Page > 1 then
        Blog.Page = Blog.Page - 1
    end
end

------------------------------------------------------------------------------------------------------
-- Jumps to the next page in the battle log.
------------------------------------------------------------------------------------------------------
Blog.Widgets.NextPage = function()
    if UI.Button(">") then
        local lastPage = Blog.MaxPage()
        local nextPage = Blog.Page + 1

        if nextPage > lastPage then
            return nil
        end

        Blog.Page = nextPage
    end
end

------------------------------------------------------------------------------------------------------
-- Jumps to the last page in the battle log.
------------------------------------------------------------------------------------------------------
Blog.Widgets.LastPage = function()
    local lastPage = Blog.MaxPage()

    if UI.Button(string.format("Last (%d)", tostring(lastPage))) then
        Blog.Page = lastPage
    end
end

------------------------------------------------------------------------------------------------------
-- Creates a dropdown menu to show only damage done by a certain entity.
------------------------------------------------------------------------------------------------------
Blog.Widgets.PlayerFilter = function()
    local list  = DB.Lists.Players or { }
    local flags = DB.Widgets.DropdownFlags

    UI.SetNextItemWidth(DB.Widgets.DropdownWidth)

    if UI.BeginCombo(DB.Widgets.DropdownPlayerFilterHeader, list[Blog.Widgets.PlayerIndex] or DB.Enum.NONE, flags) then
        for index, mode in ipairs(list) do
            local isSelected = Blog.Widgets.PlayerIndex == index

            if UI.Selectable(mode, isSelected) then
                Blog.Widgets.PlayerIndex = index
                Blog.Widgets.PlayerFocus = mode
            end

            if isSelected then
                UI.SetItemDefaultFocus()
            end
        end

        UI.EndCombo()
    end
end

------------------------------------------------------------------------------------------------------
-- Creates an input text box for the action filter.
------------------------------------------------------------------------------------------------------
Blog.Widgets.ActionFilterInput = function()
    UI.SetNextItemWidth(150) UI.InputText("Action", Blog.Widgets.ActionBuffer, 100, ImGuiInputTextFlags_AutoSelectAll)
end