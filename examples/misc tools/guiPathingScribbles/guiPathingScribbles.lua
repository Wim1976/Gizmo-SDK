--[[

This script is a quick hack to demonstrated drawing paths in the sim for objects, data, camera, sounds, or something to follow.

Doesn't work real well, the path following algorithm is nasty, but it shows how one might get path data at least.

2010-11-20 - Ben Russell - br@x-plugins.com

--]]

function guiObj8PathScribbles_OnCreate()
	local w,h = gfx.getScreenSize()
	
	gui.setWindowSize( gui_Obj8PathScribbles, w-950, 100, 542, 600 )
	gui.setWindowCaption( gui_Obj8PathScribbles, "Gizmo - OBJ8 Path Scribbles" )
	--gui.hideWindow( gui_Obj8PathScribbles ) 
	
	-- OBJ8 Filenames
		guiObj8PathScribbles_txtObjFilename = gui.newTextBox( gui_Obj8PathScribbles, "ignored", "Clear Path", 	20, 30, 200 )
		gui.newButton( gui_Obj8PathScribbles, "guiObj8PathScribbles_btnLoadObject", "Load Object", 				220, 30, 100 )

	-- Pathing Feedback stuff.
		gui.newButton( gui_Obj8PathScribbles, "guiObj8PathScribbles_btnClearPath", "Clear Path", 				320, 30, 100 )
		gui.newCustomWidget( gui_Obj8PathScribbles, "pathScribbler",  											10, 60, 522, 522 )

	--push
		gui.newButton( gui_Obj8PathScribbles, "guiObj8PathScribbles_btnSetPath", "Set Path", 					420, 30, 100 )


	gui.showWindow( gui_Obj8PathScribbles ) 
	
end
gui_Obj8PathScribbles = gui.newWindow("guiObj8PathScribbles")





function guiObj8PathScribbles_btnLoadObject_OnClick()
	local obj_filename = gui.getWidgetValue( guiObj8PathScribbles_txtObjFilename )
	--FIXME: Load obj8
end

function guiObj8PathScribbles_btnClearPath_OnClick()
	-- reset mouse pathing data
	guiObj8PathScribbles_MouseData = {}
end


function guiObj8PathScribbles_btnSetPath_OnClick()
	guiObj8PathScribbles_MouseData_Active = guiObj8PathScribbles_MouseData
---	guiObj8PathScribbles_MouseData = {}
end









function pathScribbler_OnMouseDown()
	return 1 --ask x-plane for more mouse data as its available.
end

guiObj8PathScribbles_MouseData = {} --scratch pad data
guiObj8PathScribbles_MouseData_Active = {} --actual vehicle path


function pathScribbler_OnMouseUp()
	guiObj8PathScribbles_MouseData[ #guiObj8PathScribbles_MouseData+1 ] = {-1,-1}
end

function pathScribbler_OnMouseDrag()
	
	local l,b = gui.getCustomWidgetPosition()
	local w,h = gui.getCustomWidgetSize()
	
	local rel_mx = mouse.x - l
	local rel_my = mouse.y - b
	if( rel_mx < w and rel_mx > 0 )then
		if( rel_my < h and rel_my > 0)then
			--sound.say( rel_mx .. " / " .. rel_my )
			
			guiObj8PathScribbles_MouseData[ #guiObj8PathScribbles_MouseData+1 ] = {rel_mx, rel_my}
			
		end
	end
	
	--btnBake_OnClick()
	
end



function pathScribbler_OnDraw()
			--turn texturing back on
		gfx.setState(
			0, --fog
			0, --tex units
			0, --lighting
			1, --alpha test
			1, --alpha blend
			0, --depth test
			0  --depth write
		);
		
	local w,h = gui.getCustomWidgetSize()
	gfx.setColor(1,1,1, 1 )
	gfx.drawFilledBox( 0,0, w,h )
	
	gfx.setColor(0,0,0, 1 )
	gfx.drawBox( 0,0, w,h )
	
		gl.PushMatrix()
			
				-- [[
	
				gfx.setState(
						0, --fog
						0, --tex units
						0, --lighting
						1, --alpha test
						1, --alpha blend
						0, --depth test
						0  --depth write
					);
			
					gfx.setColor(1,0,0,1)
					gl.LineWidth(2)
					
						for i=1,#guiObj8PathScribbles_MouseData-1 do
							local start = guiObj8PathScribbles_MouseData[i]
							local stop = guiObj8PathScribbles_MouseData[i+1]
							if(( start[1] > -1 ) and ( stop[1] > -1 ))then
								gfx.drawLine(  start[1],start[2], stop[1],stop[2] )
							end
						end
						
					gl.LineWidth(1)
					
				--]]
			
			gfx.drawBox(0,0,w,h)
			
		gl.PopMatrix()
end



guiObj8PathScribbles_DrawVehicle = false
guiObj8PathScribbles_DrawVehicle_X = 0
guiObj8PathScribbles_DrawVehicle_Y = 0
guiObj8PathScribbles_DrawVehicle_Z = 0


guiObj8PathScribbles_VehilePositionOnPath = 0

function OnDraw_World()


	guiObj8PathScribbles_VehilePositionOnPath = guiObj8PathScribbles_VehilePositionOnPath + gfx.getFrameSpeed(0.05)
	if( guiObj8PathScribbles_VehilePositionOnPath > 0.9 )then
		guiObj8PathScribbles_VehilePositionOnPath = 0
	end
	
	--logging.debug( guiObj8PathScribbles_VehilePositionOnPath )

	local x,y,z,p,r,h = gfx.getAircraftPositionGL()


		gl.PushMatrix()
			gl.Translate( x,y,z )
			gl.Rotate( -90,  1,0,0 )
			
				-- [[
	
				gfx.setState(
						0, --fog
						0, --tex units
						0, --lighting
						1, --alpha test
						1, --alpha blend
						0, --depth test
						0  --depth write
					);
			
					gfx.setColor(1,0,0,1)
					gl.LineWidth(2)
					
						for i=1,#guiObj8PathScribbles_MouseData-1 do
						
							local ipercent = i / (#guiObj8PathScribbles_MouseData)
							
								local win_a = math.floor(ipercent * 100)
								local win_b = math.floor(guiObj8PathScribbles_VehilePositionOnPath * 100)
								
								--local s = string.format("a: %0.3f  b: %0.3f", win_a, win_b)
								--logging.debug(s)
								
								
							
						
							local start = guiObj8PathScribbles_MouseData[i]
							local stop = guiObj8PathScribbles_MouseData[i+1]
							if(( start[1] > -1 ) and ( stop[1] > -1 ))then
								gfx.drawLine(  start[1],start[2], stop[1],stop[2] )
								
								
								if( win_a == win_b )then
									guiObj8PathScribbles_DrawVehicle = true
									
									guiObj8PathScribbles_DrawVehicle_X = stop[1]
									guiObj8PathScribbles_DrawVehicle_Y = stop[2]
									
								end

								
							end
						end

								if( guiObj8PathScribbles_DrawVehicle )then
									gfx.setColor(1,0,1, 1)
								
									gl.PushMatrix()
										gl.Translate( guiObj8PathScribbles_DrawVehicle_X, guiObj8PathScribbles_DrawVehicle_Y, 0 )
										gfx.drawCircle( 10, 10 )
									gl.PopMatrix()
								end						
					
						
					
					
				--]]
			
			gfx.drawBox(0,0,w,h)
			
		gl.PopMatrix()
end
