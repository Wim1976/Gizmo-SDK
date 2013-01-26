
-- This script demonstrates "Hooked Datarefs"




cdr_MyDataref = xp.newDataref( "my/dataref", "MyDatarefFunction" )

--Create a global table to store the value of our datarefs in.
--Gizmo does not manage the value of your dataref for you anymore.
dref_globals = {
  MyDataref = 1.2345
}

function MyDatarefFunction_OnWrite( value )
  -- the user is dragging a manipulator or some other action.
  -- probably a good idea to store value somewhere
  dref_globals.MyDataref = value
end

function MyDatarefFunction_OnRead()
  --X-Plane is asking for the value of your dataref.
  --This could be “Dataref Editor”, another plugin, OBJ8 animation, etc.
  return dref_globals.MyDataref
end



