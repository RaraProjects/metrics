_Debug.Mob = {}

------------------------------------------------------------------------------------------------------
-- Populates the Mob Viewer tab.
------------------------------------------------------------------------------------------------------
_Debug.Mob.Populate = function(mob)
    if mob then
        if UI.BeginTable("table1", 2, Window.Table.Flags.Team) then
            _Debug.Mob.Headers()
            _Debug.Mob.Rows(mob)
            UI.EndTable()
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Handles setting up the headers for the mob viewer.
------------------------------------------------------------------------------------------------------
_Debug.Mob.Headers = function()
    local flags = Column.Flags.None
    UI.TableSetupColumn("Flag", flags)
    UI.TableSetupColumn("Data", flags)
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Creates the rows of the mob viewer.
------------------------------------------------------------------------------------------------------
_Debug.Mob.Rows = function(mob)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("name")
    UI.TableNextColumn() UI.Text(tostring(mob.name))
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("id")
    UI.TableNextColumn() UI.Text(tostring(mob.id_num))
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("index")
    UI.TableNextColumn() UI.Text(tostring(mob.index))
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("entity_type")
    UI.TableNextColumn() UI.Text(tostring(mob.entity_type))
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("status")
    UI.TableNextColumn() UI.Text(tostring(mob.status))
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("distance")
    UI.TableNextColumn() UI.Text(Column.String.Format_Number(mob.distance))
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("hpp")
    UI.TableNextColumn() UI.Text(tostring(mob.hpp))
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("x")
    UI.TableNextColumn() UI.Text(Column.String.Format_Number(mob.x))
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("y")
    UI.TableNextColumn() UI.Text(Column.String.Format_Number(mob.y))
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("z")
    UI.TableNextColumn() UI.Text(Column.String.Format_Number(mob.z))
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("target_index")
    UI.TableNextColumn() UI.Text(tostring(mob.target_index))
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("pet_index")
    UI.TableNextColumn() UI.Text(tostring(mob.pet_index))
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("claim_id")
    UI.TableNextColumn() UI.Text(tostring(mob.claim_id))
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("spawn_flags")
    UI.TableNextColumn() UI.Text(tostring(mob.spawn_flags))
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("in_party")
    UI.TableNextColumn() UI.Text(tostring(mob.in_party))
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("in_alliance")
    UI.TableNextColumn() UI.Text(tostring(mob.in_alliance))
end