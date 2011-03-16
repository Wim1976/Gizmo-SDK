

--FIXME: Better global manangement..
route_summary_human = "..."
time_estimate = "..."
distance_estimate = "..."
alt_estimate = "..."
fp_notes = "..."


gizmoFlightPlanDb_routeData_lat = {}
gizmoFlightPlanDb_routeData_lon = {}



-- This function is called by Gizmo to create a new window and fill it with Widgets.
function gizmoFlightPlanDb_OnCreate()
	
	local sw,sh = gfx.getScreenSize()
	local w = 720
	local h = 390
	
	local x = sw/2 - w/2
	local y = sh/2 - h/2


	gui.setWindowSize( gui_gizmoFlightPlanDb, x, y, w, h )
	gui.setWindowCaption( gui_gizmoFlightPlanDb, "flight-plan-database.tk - Lemon's FP DB" )


		local bg_offset = 18
		gui.newCustomWidget( gui_gizmoFlightPlanDb, "btnCustomWidgetWindowBg", 0, bg_offset, w, h-bg_offset )

		
		local wid_x = 200
	
		gui.newLabel( gui_gizmoFlightPlanDb, "ignored", "Departure: ", wid_x, 30, 75 )
		wid_x = wid_x + 65
		
		gizmoFlightPlanDb_txtDeparture 	= gui.newTextBox( gui_gizmoFlightPlanDb, "ignored", "YSSY", wid_x, 30, 75 )
		wid_x = wid_x + 95
		
		gui.newLabel( gui_gizmoFlightPlanDb, "ignored", "Arrival: ", wid_x, 30, 75 )
		wid_x = wid_x + 45
		
		gizmoFlightPlanDb_txtArrival 	= gui.newTextBox( gui_gizmoFlightPlanDb, "ignored", "KLAX", wid_x, 30, 75 )
		wid_x = wid_x + 110
		
		gui.newButton( gui_gizmoFlightPlanDb, "btnSearch", "Search", wid_x, 30, 80 )
		wid_x = wid_x + 110
		
		gui.newButton( gui_gizmoFlightPlanDb, "btnLoad", "TODO: Load", wid_x, 30, 80 )
		wid_x = wid_x + 110
		
		gui.newCustomWidget( gui_gizmoFlightPlanDb, "btnCustomWidgetMap", 10, 52, 700, 320 )
		
		
		
		
	
	--now that we're dressed, show ourselves.
	gui.showWindow( gui_gizmoFlightPlanDb ) 
	
end
gui_gizmoFlightPlanDb = gui.newWindow("gizmoFlightPlanDb")




function btnCustomWidgetWindowBg_OnDraw()
	local w,h = gui.getCustomWidgetSize()


	gfx.setState(
			0, --fog
			0, --tex units
			0, --lighting
			1, --alpha test
			1, --alpha blend
			0, --depth test
			0  --depth write
		);

	local bright = 3.5
		
	gfx.setColor( 0.122 * bright, 0.239 * bright, 0.388 * bright, 1 )
	gfx.drawFilledBox( 0,0, w, h )
--[[
	bright = 3.5
	gfx.setColor( 0.122 * bright, 0.239 * bright, 0.388 * bright, 1 )
	gfx.drawFilledBox( 0,h-50, w, 50 )
--]]
	
end	
	


function btnCustomWidgetMap_OnDraw()
	local w,h = gui.getCustomWidgetSize()


	gfx.setState(
			0, --fog
			0, --tex units
			0, --lighting
			1, --alpha test
			1, --alpha blend
			0, --depth test
			0  --depth write
		);
		
	gfx.setColor( 0.122 * 1.2, 0.239 * 1.2, 0.388 * 1.2, 1 )
	gfx.drawFilledBox( 0,0, w, h )

	gfx.setState(
			0, --fog
			1, --tex units
			0, --lighting
			1, --alpha test
			1, --alpha blend
			0, --depth test
			0  --depth write
		);



		gfx.useTexture( 62 );
		gl.Color( 1, 1, 1, 1 );
		
	    gl.Begin('QUADS');
		    gl.TexCoord( 0, 0 ); gl.Vertex( 0, 0, 0 );
		    gl.TexCoord( 0, 1 ); gl.Vertex( 0, h, 0 );
		    gl.TexCoord( 1, 1 ); gl.Vertex( w/2, h, 0 );
		    gl.TexCoord( 1, 0 ); gl.Vertex( w/2, 0, 0 );
	    gl.End();

		gfx.useTexture( 63 );
	    gl.Begin('QUADS');
		    gl.TexCoord( 0, 0 ); gl.Vertex( w/2, 0, 0 );
		    gl.TexCoord( 0, 1 ); gl.Vertex( w/2, h, 0 );
		    gl.TexCoord( 1, 1 ); gl.Vertex( w, h, 0 );
		    gl.TexCoord( 1, 0 ); gl.Vertex( w, 0, 0 );
	    gl.End();
	
	
	gfx.setState(
			0, --fog
			0, --tex units
			0, --lighting
			1, --alpha test
			1, --alpha blend
			0, --depth test
			0  --depth write
		);






	
	
	
	local half_w = w/2
	local half_h = h/2



		--this code plots the flight plan coords	
		--magenta
		gl.LineWidth(1)
		gfx.setColor(0.9,0.0,1,1)
			
			gl.PushMatrix()
				gl.Translate( half_w, half_h, 0 )
				
					--we are now at 0,0
					
					
					--lets draw the users aircraft as it is right now.
					gl.PushMatrix()
						gfx.setColor(1, 1, 1,  1)
						
						local px, py = convertToMapPixels( acf.getLat(), acf.getLon() )
						
						gl.Translate( px, py, 0 )
						gfx.drawCircle(7,10)
						gfx.drawString( "<You are here.", 12, -3 )
						
						
							gfx.setState(
									0, --fog
									0, --tex units
									0, --lighting
									1, --alpha test
									1, --alpha blend
									0, --depth test
									0  --depth write
								);
						

					gl.PopMatrix()
				
				-------------------------------------------------- *****************************************
							-- plot the flight plan data.
			
							if( #gizmoFlightPlanDb_routeData_lat > 0 )then
								if( #gizmoFlightPlanDb_routeData_lat == #gizmoFlightPlanDb_routeData_lon )then
								
								
									--local lx = gizmoFlightPlanDb_routeData_lon[1]
									--local ly = gizmoFlightPlanDb_routeData_lat[1]
								
									for i=2,#gizmoFlightPlanDb_routeData_lat do
										local x,y = convertToMapPixels( gizmoFlightPlanDb_routeData_lat[i], gizmoFlightPlanDb_routeData_lon[i] )
											
											local leg_len = 2
											gfx.drawLine( x-leg_len,y, x+leg_len,y )
											gfx.drawLine( x,y-leg_len, x,y+leg_len )
											
									end
								
								end
							end
							
							

			
				--gfx.drawLine( 0,0, 45,45 )
			
			gl.PopMatrix()
	
	
	
	
	
	--back to white
	gl.LineWidth(1)
	gfx.setColor(0.9,0.9,1,0.5)
	

	gfx.drawLine( 0, h/2,  w, h/2 )
	gfx.drawLine( half_w, 0,  half_w, h )

	-- [[
		gfx.setColor(0.9,0.9,1,0.25)
		--vertical sectors
		gfx.drawLine( w/4, 0,  w/4, h )
		gfx.drawLine( half_w + (w/4), 0,  half_w + (w/4), h )
	
		--h secotrs
		gfx.drawLine( 0, h/4,  w, h/4 )
		gfx.drawLine( 0, half_h + (h/4),  w, half_h + (h/4) )
	--]]



		gfx.setColor( 0.122 * 1.6, 0.239 * 1.6, 0.388 * 1.6, 1 )
		gfx.drawFilledBox( 0,h-28, w, 28 )

		gfx.setColor( 0.122 * 1.4, 0.239 * 1.4, 0.388 * 1.4, 1 )
		gfx.drawFilledBox( 0,0, w, 55 )


		gfx.setColor( 1,1,1, 1 )
		--draw all info text beween these marks ~~~~~~~~~~~~~~~~ 
		
			--local route_summary_human 	= "Sydney Intl -> Los Angeles Intl"
			local est_duration 			= string.format("Estimated Duration: %s", time_estimate)
			
			gfx.drawString( route_summary_human, 15, h-18 )
			gfx.drawString( est_duration, w-250, h-18 )
	
			gfx.drawString( string.format("- Distance: %s", distance_estimate), 15, 35 )			
			gfx.drawString( string.format("- Altitude: %s", alt_estimate), 15, 15 )
			
			gfx.drawString( "Notes: ", 185, 35 )			
			
			gfx.drawString( fp_notes, 195, 15 )			
			
			
			
		-- end of info text drawing ~~~~~~~~~~~~~~~~~~
	
	
	gfx.setState(
			0, --fog
			0, --tex units
			0, --lighting
			1, --alpha test
			1, --alpha blend
			0, --depth test
			0  --depth write
		);


	gfx.setColor(0.9,0.9,1,0.2)
	gfx.drawLine( w/4, 0,  w/4, 55 ) -- seperator line on GUI
			
			


	gfx.setColor(0.9,0.9,1,1)
	
	gl.LineWidth(2)
	gfx.setColor(0.9,0.9,1,1)
	gfx.drawBox( 0,0, w, h )

	
	
end







function convertToMapPixels( lat, lon ) --comes in as y,x
	--return lat*1.95, lon*1.7
	return lon*1.95,lat*1.7 --returns as x,y
end









function btnSearch_OnClick()
	local dep_code = gui.getWidgetValue( gizmoFlightPlanDb_txtDeparture )
	local arr_code = gui.getWidgetValue( gizmoFlightPlanDb_txtArrival )
	
	local url = "http://flight-plan-database.tk/qroute.php?" .. "fromic=".. dep_code .. "&toic=" .. arr_code
	
	route_summary_human = "Searching... Please wait..."
	time_estimate = "< 10 seconds.."
	alt_estimate = 0
	distance_estimate = "..."
	fp_notes = "Searching flight plan database..."
	
	http.get(url, "gizmoFlightPlanDb_qroute_cb")
	
end






fp_data_url = ""

function timerStartFpLeech_OneShot()
	--this action is defered because of a thread locking bug in gizmo 10.11.15
	http.get(fp_data_url, "gizmoFlightPlanDb_fullroute_cb")
end



function gizmoFlightPlanDb_qroute_cb( data, size, url )
	--data will contain a route ID or...
	local fp_id_number = tonumber(data)
	if( fp_id_number == nil )then
		--sound.say(data)
		logging.debug(data)
		
	else
		fp_data_url = "http://flight-plan-database.tk/xmlhttp/plan.php?id=" .. fp_id_number
		timer.newOneShot( "timerStartFpLeech_OneShot", 0.1 )
		
	end
	
end





function gizmoFlightPlanDb_fullroute_cb( data, size, url )

	logging.debug("gizmoFlightPlanDb_fullroute_cb")
	logging.debug(data)


	local long_arrival 		= string.match (data, "%<FROM%>%<%!%[CDATA%[(.*)%]%]%>%</FROM%>")
	local long_destin 		= string.match (data, "%<TO%>%<%!%[CDATA%[(.*)%]%]%>%</TO%>")

	local location_fixes 	= string.match (data, "%<LOCATION%>%<%!%[CDATA%[(.*)%]%]%>%</LOCATION%>") 

	distance_estimate 	= string.match (data, "%<DISTANCE%>%<%!%[CDATA%[(.*)%]%]%>%</DISTANCE%>") .. " nm"
	time_estimate	 	= string.match (data, "%<TIME%>%<%!%[CDATA%[(.*)%]%]%>%</TIME%>")
	alt_estimate 		= string.match (data, "%<ALT%>%<%!%[CDATA%[(.*)%]%]%>%</ALT%>") .. " ft"

	fp_notes 			= string.match (data, "%<NOTES%>%<%!%[CDATA%[(.*)%]%]%>%</NOTES%>")


	local traceroute_raw_chunk = string.match (data, "%<TRUEROUTE%>(.*)%</TRUEROUTE%>")
	
	
	route_summary_human = string.format("%s  >>>  %s", long_arrival, long_destin);


	--reset the data storage
	gizmoFlightPlanDb_routeData_lat = {}
	gizmoFlightPlanDb_routeData_lon = {}
	
	for line in traceroute_raw_chunk:gmatch("[^\r\n]+") do 
		--logging.debug(line)
		
		local lat = string.match(line, "%<LAT%>(.*)%</LAT%>")
		local lon = string.match(line, "%<LON%>(.*)%</LON%>") 
		
		--local foo = lat .. " / " .. lon
		--logging.debug( foo )
		
		gizmoFlightPlanDb_routeData_lat[ #gizmoFlightPlanDb_routeData_lat+1 ] = tonumber(lat)
		gizmoFlightPlanDb_routeData_lon[ #gizmoFlightPlanDb_routeData_lon+1 ] = tonumber(lon)
		
		
	end
	


	--[[
	local summarize = string.format("\n arr: %s\n dest: %s\n fixes: %s\n dist: %s\n time: %s\n alt: %s\n notes: %s\n",
									long_arrival,
									long_destin,
									location_fixes,
									distance_estimate,
									time_estimate,
									alt_estimate,
									fp_notes
									)
	
	
	logging.debug( summarize )

	sound.say( summarize )
	--]]
end