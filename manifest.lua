-- This file defines a list of loadable modules to explore.

if( GizmoToyBox ~= nil )then

	GizmoToyBox.manifest =
	{

		{
		name="Bouncy Objects",
		desc="Bouncy Bouncy Aircraft Carriers.",
		type="obj8",
		path="/examples/misc/BouncyObjects/BouncyObjects.lua",
		},		
		
		{
		name="Pathing Scribbles",
		desc="Quick Hack to define paths in-sim.",
		type="gui",
		path="/examples/misc/guiPathingScribbles/guiPathingScribbles.lua",
		},		
		
		{
		name="Flight-Plan-Database.tk",
		desc="Flight Plan Integration Widget",
		type="gui",
		path="/examples/misc/guiFlightPlanDb/guiFlightPlanDb.lua",
		},
		
		{
		name="8Track",
		desc="Multi channel sound player with hot keys..",
		type="gui",
		path="/examples/misc/gui8Track/gui8Track.lua",
		},
		
		{
		name="Lua Shell",
		desc="Interactive Lua shell.",
		type="gui",
		path="/examples/misc/guiLuaShell/guiLuaShell.lua",
		},
		
		{
		name="Mini Map",
		desc="PopUp Moving Map - need to port cirrus demo.",
		type="popup",
		path="/examples/popup/MiniMap/popupMiniMap.lua",
		},
		
		{
		name="Cirrus Jet - Moving Map Gauge",
		desc="Moving Map on the Cirrus Jet EFIS screen as seen in demo video.",
		type="gauge",
		path="/examples/Cirrus%20Jet/scripts/c4_panel_taws.lua",
		},
		
		{
		name="Sound Desk",
		desc="Basic sound desk example, allows live editing of Pitch and Gain with a playhead on loop.",
		type="gui",
		path="/examples/misc/guiSoundDesk/guiSoundDesk.lua",
		},
	
		{
		name="Tex Paint",
		desc="Explore the VRAM stack inside X-Plane.",
		type="gui",
		path="/examples/misc/guiTexPaint/guiTexPaint.lua",
		},
	
	
	} --end of Manifest table.

end --end check for GizmoToyBox presence.