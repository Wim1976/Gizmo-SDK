
--some useful constants from the ACF file.
xpl_thermals_Vne = xp.getFloat( xp.getDataref("sim/aircraft/view/acf_Vne") )
xpl_thermals_Vno = xp.getFloat( xp.getDataref("sim/aircraft/view/acf_Vno") )
xpl_thermals_Vs = xp.getFloat( xp.getDataref("sim/aircraft/view/acf_Vs") )

xpl_thermals_Gpos_max = xp.getFloat( xp.getDataref("sim/aircraft/view/acf_Gpos") )
xpl_thermals_Gneg_max = xp.getFloat( xp.getDataref("sim/aircraft/view/acf_Gneg") )


xpl_thermals_dr_IAS = xp.getDataref("sim/flightmodel/position/indicated_airspeed") --kias
xpl_thermals_dr_TAS = xp.getDataref("sim/flightmodel/position/true_airspeed") --mtr/sec
xpl_thermals_dr_GS = xp.getDataref("sim/flightmodel/position/groundspeed") --mtr/sec

xpl_thermals_dr_MagPsi = xp.getDataref("sim/flightmodel/position/magpsi") --magnetic heading

xpl_thermals_dr_Psi = xp.getDataref("sim/flightmodel/position/psi") --heading
xpl_thermals_dr_Phi = xp.getDataref("sim/flightmodel/position/phi") --roll
xpl_thermals_dr_Theta = xp.getDataref("sim/flightmodel/position/theta") --pitch


xpl_thermals_dr_P = xp.getDataref("sim/flightmodel/position/P") --roll
xpl_thermals_dr_Q = xp.getDataref("sim/flightmodel/position/Q") --pitch
xpl_thermals_dr_R = xp.getDataref("sim/flightmodel/position/R") --yaw



xpl_thermals_dr_usr_pitch = xp.getDataref("sim/joystick/yoke_pitch_ratio")
xpl_thermals_dr_usr_roll = xp.getDataref("sim/joystick/yoke_roll_ratio")
xpl_thermals_dr_usr_heading = xp.getDataref("sim/joystick/yoke_heading_ratio")

xpl_thermals_dr_as_pitch = xp.getDataref("sim/joystick/artstab_pitch_ratio")
xpl_thermals_dr_as_roll = xp.getDataref("sim/joystick/artstab_roll_ratio")
xpl_thermals_dr_as_heading = xp.getDataref("sim/joystick/artstab_heading_ratio")

xpl_thermals_dr_fc_pitch = xp.getDataref("sim/joystick/FC_ptch")
xpl_thermals_dr_fc_roll = xp.getDataref("sim/joystick/FC_roll")
xpl_thermals_dr_fc_heading = xp.getDataref("sim/joystick/FC_hdng")



xpl_thermals_dr_alpha = xp.getDataref("sim/flightmodel/position/alpha")
xpl_thermals_dr_beta = xp.getDataref("sim/flightmodel/position/beta")

xpl_thermals_dr_hpath = xp.getDataref("sim/flightmodel/position/hpath") --actual path over ground

xpl_thermals_dr_elevation = xp.getDataref("sim/flightmodel/position/elevation") --MSL - meters
xpl_thermals_dr_agl = xp.getDataref("sim/flightmodel/position/y_agl") --AGL - meters
xpl_thermals_dr_vs = xp.getDataref("sim/flightmodel/position/vh_ind") --vertical speed, meters per second

xpl_thermals_dr_lat = xp.getDataref("sim/flightmodel/position/latitude")
xpl_thermals_dr_lon = xp.getDataref("sim/flightmodel/position/longitude")


xp_thermals_dr_speedbreak_actual = xp.getDataref("sim/flightmodel/controls/sbrkrat")
xp_thermals_dr_speedbreak_requested = xp.getDataref("sim/flightmodel/controls/sbrkrqst")

xpl_thermals_dr_wind_hdg = xp.getDataref("sim/cockpit2/gauges/indicators/wind_heading_deg_mag")
xpl_thermals_dr_wind_spd = xp.getDataref("sim/cockpit2/gauges/indicators/wind_speed_kts")


xpl_thermals_dr_G_load_normal = xp.getDataref("sim/flightmodel/forces/g_nrml")



xpl_thermals_asr = 0.0



flash_x = 0




xp.setInt( xp.getDataref("sim/operation/override/override_artstab"), 1 ) --take control of artstab

xp.newCommand("xplugins/thermals/attitude_hold", "Attempt to hold current alpha roll and heading.", "attitude_hold")






last_as_pitch = 0.0
function main()
    --xpl_thermals_hold_roll_angle()
    
   xpl_thermals_auto_spoilers()

    if( xplugins_thermals_attitude_hold_on )then
	xpl_thermals_attitude_hold()
    end



--    local usr_pitch = xp.getFloat( xpl_thermals_dr_usr_pitch )
--    local as_pitch = xp.getFloat( xpl_thermals_dr_as_pitch )
--
--    if( usr_pitch > as_pitch )then
--	as_pitch = as_pitch + 0.01
--    elseif( usr_pitch < as_pitch )then
--	as_pitch = as_pitch - 0.01
--    end
--
--    xp.setFloat( xpl_thermals_dr_as_pitch, as_pitch )
--
--    xp.setFloat(xpl_thermals_dr_fc_pitch, xpl_thermals_dr_usr_pitch + as_pitch)



end





function xpl_thermals_attitude_hold()


    local js_r = xp.getFloat( xpl_thermals_dr_usr_roll )
    local js_p = xp.getFloat( xpl_thermals_dr_usr_pitch )


    xplugins_thermals_attitude_target_roll = xplugins_thermals_attitude_target_roll + (js_r * 2.0)
    xplugins_thermals_attitude_target_pitch = xplugins_thermals_attitude_target_pitch + (js_p * 2.0)

    if( xplugins_thermals_attitude_target_roll < -45.0 )then
	xplugins_thermals_attitude_target_roll = -45.0
    elseif( xplugins_thermals_attitude_target_roll > 45.0 )then
	xplugins_thermals_attitude_target_roll = 45.0
    end


    if( xplugins_thermals_attitude_target_pitch < -45.0 )then
	xplugins_thermals_attitude_target_pitch = -45.0
    elseif( xplugins_thermals_attitude_target_pitch > 45.0 )then
	xplugins_thermals_attitude_target_pitch = 45.0
    end






--AOA CODE - doesnt work very well for a glider with no power
--    local pitch = xp.getFloat( xpl_thermals_dr_alpha )
--    --local pitch = xp.getFloat( xpl_thermals_dr_Theta )
--    
--    local q = xp.getFloat( xpl_thermals_dr_Q )
--    max_q = 20.0
--    
--    pitch_delta = xplugins_thermals_attitude_target_pitch - pitch
--    
--    f_max = 0.95
--    
--    pct = pitch_delta / 1.5 --more than 15 degrees off pitch target will input 100% force.
--    if( pct > 1.0 )then pct = 1.0 end
--    
--    pct_q = q / max_q
--    pct = pct - pct_q --apply reductions in force applied as output increases
--    
--    f = pct * f_max
--    
--    --if( p_inv )then
--    --    f = f * -1.0
--    --end
--    
--    if( f > 0.95 )then
--	f = 0.95
--    elseif( f < -0.95 )then
--	f = -0.95
--    end
--    
--    xp.setFloat( xpl_thermals_dr_as_pitch, f )










    local pitch = xp.getFloat( xpl_thermals_dr_Theta )
    
    local q = xp.getFloat( xpl_thermals_dr_Q )
    max_q = 50.0
    
    pitch_delta = xplugins_thermals_attitude_target_pitch - pitch
    
    f_max = 0.75
    
    pct = pitch_delta / 5.0 --more than 15 degrees off pitch target will input 100% force.
    if( pct > 1.0 )then pct = 1.0 end
    
    pct_q = q / max_q
    pct = pct - pct_q --apply reductions in force applied as output increases
    
    f = pct * f_max
    
    --if( p_inv )then
    --    f = f * -1.0
    --end
    
    if( f > 0.75 )then
	f = 0.75
    elseif( f < -0.75 )then
	f = -0.75
    end
    
    xp.setFloat( xpl_thermals_dr_as_pitch, f )










	local hdg = xp.getFloat( xpl_thermals_dr_MagPsi )
	
	local r = xp.getFloat( xpl_thermals_dr_R )
	max_r = 100.0
    
	hdg_delta = 0
	track_wind = false
	if( track_wind )then
	    hdg_delta = xp.getFloat(xpl_thermals_dr_wind_hdg) - hdg
	else
	    hdg_delta = xplugins_thermals_attitude_target_heading - hdg
	end
    
	f_max = 0.75
	
	pct = hdg_delta / 5.0 --more than 15 degrees off pitch target will input 100% force.
	if( pct > 1.0 )then pct = 1.0 end
	
	pct_r = r / max_r
	pct = pct - pct_r --apply reductions in force applied as output increases
	
	f = pct * f_max
	
	if( f > 0.75 )then
	    f = 0.75
	elseif( f < -0.75 )then
	    f = -0.75
	end
	
	--xp.setFloat( xpl_thermals_dr_as_heading, f )
    

    local heading_change_f = 0.0 --f








    local roll = xp.getFloat( xpl_thermals_dr_Phi )
    
    local p = xp.getFloat( xpl_thermals_dr_P )
    max_p = 50.0
    
    roll_delta = xplugins_thermals_attitude_target_roll - roll
    
	f_max = 0.75
	
	pct = roll_delta / 5.0 --more than 15 degrees off pitch target will input 100% force.
	if( pct > 1.0 )then pct = 1.0 end
	
	pct_p = p / max_p
	pct = pct - pct_p --apply reductions in force applied as output increases
	
	f = pct * f_max
	
	if( f > 0.75 )then
	    f = 0.75
	elseif( f < -0.75 )then
	    f = -0.75
	end
	
	if( heading_change_f ~= 0.0 )then
	    f = f + ((heading_change_f * 0.75))
	end
	
	xp.setFloat( xpl_thermals_dr_as_roll, f )












    
    
end







function xpl_thermals_auto_spoilers()
    --this function will automatically deploy the spoilers to avoid overspeed. Seems to work quite nicely too.

    local ias = xp.getFloat( xpl_thermals_dr_IAS )
    
    local x_deploy = 0
    if( ias > 140 )then
	
	local x = 150 - ias
	local x_pct = x / 10
	x_deploy = 1.0 - x_pct
	
    end
    sbrk_request = xp.getFloat(xp_thermals_dr_speedbreak_requested)
    if( sbrk_request > x_deploy )then
	x_deploy = sbrk_request
    end
    
    if( x_deploy > 1.0 )then
	x_deploy = 1.0
    elseif( x_deploy < 0.0 )then
	x_deploy = 0.0
    end
    
    xp.setFloat( xp_thermals_dr_speedbreak_actual, x_deploy )
end






function OnDraw_Gauges()
    OnDraw_Gauges_3D()
end

function OnDraw_Gauges_3D()
--[[
    gfx.setColor(1,0,0,1)

    gfx.drawString( string.format("Vne: %0.0f", xp.getFloat(xpl_thermals_dr_Vne)), 400, 400)
    gfx.drawString( string.format("Vs: %0.0f", xp.getFloat(xpl_thermals_dr_Vs)), 400, 380)

    gfx.drawString( string.format("+G: %0.1f", xp.getFloat(xpl_thermals_dr_Gpos)), 400, 360)
--]]

    --top left: 	334, 437
    --bottom right: 	674, 692


   
    gfx.setState(
          0, --fog
          0, --tex units
          0, --lighting
          1, --alpha test
          1, --alpha blend
          0, --depth test
          0  --depth write
        );
    --draw a mask over the existing efis displays to hide the X-P shit
    gfx.setColor(0,0,0.2,0.75)
    gfx.drawQuad( 334, (1024-437)-250, 350, 250 )




    gfx.setColor(1,1,1,1)
    gl.PushMatrix()
	--gl.Rotate(0,0,1, 45)
    
	gl.Translate( 512, 450, 0 )



	gl.LineWidth(2)
	
	    --draw acf icon
	    gfx.setColor(1,1,1,0.5)
	    gfx.drawLine(-40,0,40,0) -- wings
	    gfx.drawLine(-15,-35,15,-35) --tail
	    gfx.drawLine(0,22,0,-45) --body
    

	
	gl.LineWidth(5)
	





	
	--draw wind direction and strength
	    gfx.setColor(0,0.5,1,0.25)
	    local wind_delta = xp.getFloat(xpl_thermals_dr_wind_hdg) - xp.getFloat(xpl_thermals_dr_MagPsi)
	    
	    --gfx.drawRadial( wind_delta+180, 0, xp.getFloat(xpl_thermals_dr_wind_spd) )
	    
	    --gfx.setColor(1,0.5,1,0.05)
	    gl.PushMatrix()
		--gl.Rotate(0,0,1, wind_delta)
		h = xp.getFloat(xpl_thermals_dr_wind_hdg)
		h = wind_delta + 180
		gl.Rotate(h, 0,0,-1)
		
		
		local w_spd = (xp.getFloat( xpl_thermals_dr_wind_spd ) * 3.0)
		
		gl.Translate( -30, 0, 0)		
		    gfx.drawLine(-10,-20,0,20)
		    gfx.drawLine(10,-20,0,20)
		    gfx.drawLine(0,-w_spd,0,20)
		
		gl.Translate( 60, 0, 0)		
		    gfx.drawLine(-10,-20,0,20)
		    gfx.drawLine(10,-20,0,20)
		    gfx.drawLine(0,-w_spd,0,20)
		
		gl.Rotate(180, 0,0,-1)    
		gl.Scale(2,2,0)
		    --gfx.drawString(string.format("%0.0f",w_spd), 10,30)
		
		
		--gfx.drawRadial(h, 0, 50)
		
	    gl.PopMatrix() --end drawing wind vectors
	
    
    
    
    
	    gfx.setColor(0,1,0,1)
	    local hpath_delta = xp.getFloat( xpl_thermals_dr_hpath ) - xp.getFloat(xpl_thermals_dr_MagPsi)
	    
	    hpath_size = xp.getFloat(xpl_thermals_dr_GS) --xpl_thermals_Vs
	    if( hpath_size < 5 )then
		hpath_size = 5
	    end
	    
	    gl.LineWidth(1)
	    
	    gfx.drawRadial( hpath_delta, 0,  hpath_size )
    
    
    


	    --draw v/s
	    gl.PushMatrix()
		gl.Translate(220,0,0)
		
		gfx.setColor(1,1,1,1)
		gfx.drawRadial( xp.getFloat(xpl_thermals_dr_vs)+270, 50, 50 )
	    gl.PopMatrix()
	
    

    
    
	gl.LineWidth(1)
    
    gl.PopMatrix()






    gfx.setColor(1,1,1,1)
    gfx.setState(
          0, --fog
          1, --tex units
          0, --lighting
          1, --alpha test
          1, --alpha blend
          0, --depth test
          0  --depth write
        );


    gl.PushMatrix()
	
	gl.Translate(340, (1024-450), 0)
	
	s=2
	

	--airspeed
	    --Vne
	    --Vs
	    --Vno
	    --ground speed

	gl.PushMatrix()
	    
	    gfx.setColor(0,1,0,1)
	    
	    local ias = xp.getFloat(xpl_thermals_dr_IAS)
	    local tas = xp.getFloat(xpl_thermals_dr_TAS)
	    local gs = xp.getFloat(xpl_thermals_dr_GS)
	    
	    local show_Vne = false
	    local show_Vs = false
	    
	    --if we're getting close to stall make the speed blue
	    if( ias < xpl_thermals_Vs*1.2 )then
		gfx.setColor(0,1,1,1)
		show_Vs = true
	    end
	    
	    --if we're getting close to Vne make the speed yellow.
	    if( ias > xpl_thermals_Vne*0.85 )then
		gfx.setColor(1,1,0,1)
		show_Vne = true
	    end
	    
	    
	    gl.Translate(0, -10, 0)
	    gl.PushMatrix()
		gl.Scale(s,s,0)
		    gfx.drawString(string.format("IAS %.0f", ias), 0, 0)
		--gl.PopMatrix()
		
		    flash_x = flash_x + 1 * gfx.getM()
		
		    if( flash_x > 1.0 )then
			show_Vne = false
			show_Vs = false
			
			if( flash_x > 1.25 )then
			    --0.5 seconds on, 0.25 seconds off.
			    flash_x = 0
				
			end
			
		    end
		    
		
		
		    if( show_Vne )then
			gl.PushMatrix()
			gl.Translate(45, 0, 0)
			    gfx.setColor(1,0,0,1)
			    gfx.drawString(string.format("%.0f Vne", xpl_thermals_Vne), 0, 0)
			gl.PopMatrix()
		    end
		
		
		    if( show_Vs )then
			gl.PushMatrix()
			gl.Translate(40, 0, 0)
			    gfx.setColor(1,1,1,1)
			    gfx.drawString(string.format("%.0f Vs", xpl_thermals_Vs), 0, 0)
			gl.PopMatrix()		    
		    end
		
		
		gfx.setColor(0,0.75,0,1)
		gl.Translate(0, -12, 0)
		    gfx.drawString(string.format(" gs %.0f", xp.getFloat(xpl_thermals_dr_GS)*1.94384449), 0, 0)
		
		
		local g_load = xp.getFloat(xpl_thermals_dr_G_load_normal)
		gl.Translate(0, -50, 0)
		    gfx.drawString(string.format(" G %.2f", g_load), 0, 0)
		
		
		
		
		gfx.setState(
		    0, --fog
		    0, --tex units
		    0, --lighting
		    1, --alpha test
		    1, --alpha blend
		    0, --depth test
		    0  --depth write
		  );

		
		
		
		local g_pct = 0
		
		if( g_load > 0 )then
		    g_pct = g_load / xpl_thermals_Gpos_max
		    gfx.drawRadial( (g_pct * 90) + 90, 0, 20 )
		else
		    g_pct = g_load / (xpl_thermals_Gneg_max)
		    --g_pct = g_pct * -1.0
		    gfx.drawRadial( (g_pct * 90) + 90, 0, 20 )
		end
		
	    gl.PopMatrix() --undo scale up for text
	
	gl.PopMatrix() --end of drawing airspeed data
	
	
	
	
	
	
	
	
	
	
	--draw altitude data
	    --pressure
	    --AGL
	gl.PushMatrix()
	
	    gfx.setColor(0,1,0,1)
	    
	    local agl = xp.getFloat( xpl_thermals_dr_agl )
	    
	    gl.Translate(280, -10, 0)
	    gl.PushMatrix()
		gl.Scale(s,s,0)
		gfx.drawString(string.format("%.0f", agl), 0, 0)
		
		gl.Translate(0, -10, 0)
		gfx.drawString("AGL", 0, 0)
	    gl.PopMatrix()
	
	gl.PopMatrix() --end altitude data
	
	
	
	
	
	gl.PushMatrix()
	    gl.Scale(s,s,0)
	    
	    local sbrk = xp.getFloat( xp_thermals_dr_speedbreak_actual )
	
	    if( sbrk > 0 )then
	    
		gl.Translate( 68, -110, 0 )
		
		gfx.setColor(1,0,0,1)
		gfx.drawString("SPDBRK", 0, 0)
		
		gfx.setState(
				0, --fog
				0, --tex units
				0, --lighting
				1, --alpha test
				1, --alpha blend
				0, --depth test
				0  --depth write
			      );

		gl.Translate( 0, -5, 0 )
		gl.LineWidth(2)
		gfx.setColor(0.25,0,0,1)
		gfx.drawLine( 0, 0, 36, 0)
		gfx.setColor(1,0,0,1)
		gfx.drawLine( 0, 0, (sbrk * 36), 0)
	    
	    end
	    
	gl.PopMatrix()
	
	
	
	
	
	
	
	
	gl.PushMatrix()
	    gl.Scale(s,s,0)
	    
	    local alpha = xp.getFloat( xpl_thermals_dr_alpha )
	    local beta = xp.getFloat( xpl_thermals_dr_beta )
	
	    
		gl.Translate( 0, -100, 0 )
		gfx.setColor(0,1,0,1)
		gfx.drawString(string.format("a %.2f", alpha), 0, 0)

		gl.Translate( 0, -10, 0 )
		gfx.setColor(0,1,0,1)
		gfx.drawString(string.format("b %.2f", beta), 0, 0)


		if( xplugins_thermals_attitude_hold_on )then
		    gl.Translate( 70, 10, 0 )
		    gfx.setColor(1,0.5,0,1)
        	    gfx.drawString(string.format("P %.1f/%.1f", xp.getFloat( xpl_thermals_dr_Theta ), xplugins_thermals_attitude_target_pitch), 0, 0)
		    gl.Translate( 0, -10, 0 )
		    gfx.drawString(string.format("R %.1f/%.1f", xp.getFloat( xpl_thermals_dr_Phi ), xplugins_thermals_attitude_target_roll), 0, 0)
		end

	    
	gl.PopMatrix()
	
	
	
	
	
	
	
	
    gl.PopMatrix() --end of drawing to ipad display area



    --compass
	--HDG bug for 1st/2nd field options
    
    --Energy meter
    
    --radio freq
    
    --thermalling insigh
	--vs trend
	--energy trend
	--2d top down heatmap of thermals?
    
    --control looping, record input and playback at btn press?

end









function xpl_thermals_hold_roll_angle()

    local P = xp.getFloat( xpl_thermals_dr_P )
    local phi = xp.getFloat( xpl_thermals_dr_Phi )
    
    --local as_roll = xp.getFloat( xpl_thermals_dr_as_roll )
    local as_roll = xpl_thermals_asr
    
    local max_P = 2.0 --the maximum roll rate
    local max_phi = 5.0 --the roll angle to hold
    
    local def_max = 0.05 --maximum art-stab authority, allow for adequate human over-ride!
    
    local phi_delta = max_phi - phi
    if( phi_delta < 0.0 )then phi_delta = phi_delta * -1.0 end
    local phi_pct = phi_delta / max_phi
    
    --max_phi = max_phi * phi_pct
    max_P = max_P * phi_pct
    
    local deflect = def_max * phi_pct
    
    if( phi < max_phi )then
	if( P < max_P )then
	    if( as_roll < 0.5 )then
		as_roll = as_roll + deflect
	    end
	elseif( P > max_P )then	
	    if( as_roll > -0.5 )then
		as_roll = as_roll - deflect
	    end
	end
	
	
    elseif( phi > max_phi )then
	as_roll = as_roll - deflect

	--this should be more complicated......

    end
    
    
    --safety clamps
    if( as_roll > 0.5 )then
	as_roll = 0.5
    elseif( as_roll < -0.5 )then
	as_roll = -0.5
    end
    
    
    xp.setFloat( xpl_thermals_dr_as_roll, as_roll )
    xpl_thermals_asr = as_roll
    



end













xplugins_thermals_attitude_target_pitch = 0.0
xplugins_thermals_attitude_target_roll = 0.0


xplugins_thermals_attitude_hold_on = false
function attitude_hold__OnStop()

    if( xplugins_thermals_attitude_hold_on )then
	xplugins_thermals_attitude_hold_on = false
	
	xp.setFloat( xpl_thermals_dr_as_pitch, 0.0 )
	xp.setFloat( xpl_thermals_dr_as_roll, 0.0 )
	xp.setFloat( xpl_thermals_dr_as_heading, 0.0 )
	
    else
	xplugins_thermals_attitude_hold_on = true
	xplugins_thermals_attitude_target_pitch = xp.getFloat( xpl_thermals_dr_Theta )
	xplugins_thermals_attitude_target_roll = xp.getFloat( xpl_thermals_dr_Phi )
	xplugins_thermals_attitude_target_heading = xp.getFloat( xpl_thermals_dr_MagPsi )
    end


end




