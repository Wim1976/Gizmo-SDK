







function gizmoLuaShell_OnCreate()
	
	local sw,sh = gfx.getScreenSize()
	local w = 800
	local h = 360
	
	local x = sw/2 - w/2
	local y = sh/2 - h/2


	gui.setWindowSize( gui_gizmoLuaShell, x, y, w, h )
	gui.setWindowCaption( gui_gizmoLuaShell, "Gizmo LuaShell - Alpha" )
	
	
	gui.newCustomWidget( gui_gizmoLuaShell, "gizmoLuaShellConsole",  0, 18, 800, 330 )
	
	gui_gizmoLuaShell_txtCommand 	= gui.newTextBox( gui_gizmoLuaShell, "gui_gizmoLuaShell_txtCommand", "", 0, 348, 800 )
	
	
		gizmoLuaShell_ConsoleBuffer_Log("Gizmo LuaShell 10.11.15.0330")
	
	
	--now that we're dressed, show ourselves.
	gui.showWindow( gui_gizmoLuaShell ) 
	
end
gui_gizmoLuaShell = gui.newWindow("gizmoLuaShell")







gizmoLuaShell_ConsoleBuffer = {} --stuff on the screen
gizmoLuaShell_CommandHistory = {} --stuff the user inputs

function gizmoLuaShellConsole_OnDraw()
	local w,h = gui.getCustomWidgetSize()
	
		gfx.setState(
			0, --fog
			0, --tex units
			0, --lighting
			1, --alpha test
			1, --alpha blend
			0, --depth test
			0  --depth write
		)

		gfx.setColor( 0.122, 0.239, 0.388, 1 )
		gfx.drawFilledBox(0,0, w,h)
		
			gfx.setColor(0.5,0.5,1, 1)
			--for i=1,#gizmoLuaShell_ConsoleBuffer do
			local txt_y = 10
			
			local start_i =  1
			if #gizmoLuaShell_ConsoleBuffer > 20 then
				start_i = #gizmoLuaShell_ConsoleBuffer - 20
			end
			
			for i=start_i+20,start_i,-1 do
				gfx.drawString( gizmoLuaShell_ConsoleBuffer[i], 10, txt_y )
				txt_y = txt_y + 15
			end
		
		
		gfx.setState(
			0, --fog
			0, --tex units
			0, --lighting
			1, --alpha test
			1, --alpha blend
			0, --depth test
			0  --depth write
		)

		gfx.setColor(0.5,0.5,0.5,1)
		gfx.drawBox(0,0, w,h)
	
end



function gizmoLuaShell_ConsoleBuffer_Log( msg )
	gizmoLuaShell_ConsoleBuffer[ #gizmoLuaShell_ConsoleBuffer+1 ] = msg
	return
end

function print(...)
	local tmp = ""
      for i,v in ipairs(arg) do
		if( v ~= nil )then
			tmp = tmp .. tostring(v) .. "    "
		end
      end
	if( tmp ~= "" )then
		gizmoLuaShell_ConsoleBuffer_Log( "> "..tmp )
	else
		gizmoLuaShell_ConsoleBuffer_Log( "> nil" )
	end
end


function gui_gizmoLuaShell_txtCommand_OnMouseDown()
	sound.say("Accepting mouse click")
	return 1 --accept focus click
end

function gui_gizmoLuaShell_txtCommand_OnKeyHold( char, keyCode, shift, alt, control )
	return gui_gizmoLuaShell_txtCommand_OnKeyDown( char, keyCode, shift, alt, control ) --fwd
end
function gui_gizmoLuaShell_txtCommand_OnKeyDown( char, keyCode, shift, alt, control )

	--detect the enter key and use it to start chewing on inputs.
	if( keyCode == 13 )then
		
		local cmd = gui.getWidgetValue( gui_gizmoLuaShell_txtCommand )
		gui.setWidgetValue( gui_gizmoLuaShell_txtCommand, "" )
		
		if( cmd == "" )then
			--ignore blank commands
			return
		end
		
		
		
		
		--lets look for slash commands
			if( cmd == "/hide" )then
				gui.hideWindow( gui_gizmoLuaShell )
				return
				
			elseif( cmd == "/clear" )then
				gizmoLuaShell_ConsoleBuffer = {}
				return
			
			elseif( cmd == "/reboot" )then
				scripts.restart()
				return
			
			end
		
		
		
		
		
		gizmoLuaShell_CommandHistory[ #gizmoLuaShell_CommandHistory+1 ] = cmd
		gizmoLuaShell_ConsoleBuffer_Log( "$ " .. cmd )
			
			
			local func = loadstring(cmd)
			if( func == nil )then
				gizmoLuaShell_ConsoleBuffer_Log( string.format("Unknown command.") )
			else
				gizmoLuaShell_ConsoleBuffer_Log( func() )
			end
			
		
		return 1
	end
end


