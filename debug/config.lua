_Debug.Config = T{}

_Debug.Config.Column_Flags = Column.Flags.None
_Debug.Config.Column_Width = Column.Widths.Settings

_Debug.Config.Show_Demo = false
_Debug.Config.Show_Unit_Tests = false

------------------------------------------------------------------------------------------------------
-- Shows settings that affect debugging.
------------------------------------------------------------------------------------------------------
_Debug.Config.Display = function()
    local col_flags = _Debug.Config.Column_Flags
    local width = _Debug.Config.Column_Width

    if UI.BeginTable("Parse General", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        -- Row 1
        UI.TableNextColumn()
        if UI.Checkbox("Show Demo", {_Debug.Config.Show_Demo}) then
            _Debug.Config.Show_Demo = not _Debug.Config.Show_Demo
        end

        UI.TableNextColumn()
        if UI.Checkbox("Show Unit Tests", {_Debug.Config.Show_Unit_Tests}) then
            _Debug.Config.Show_Unit_Tests = not _Debug.Config.Show_Unit_Tests
        end
        UI.TableNextColumn()

        UI.EndTable()
    end
end