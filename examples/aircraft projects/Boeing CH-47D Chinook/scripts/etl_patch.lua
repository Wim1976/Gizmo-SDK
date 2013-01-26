
dr_sim_empty_weight = xp.getDataref("sim/aircraft/weight/acf_m_empty")
dr_sim_flight_time = xp.getDataref("sim/time/total_flight_time_sec")
dr_sim_airspeed = xp.getDataref("sim/flightmodel/position/indicated_airspeed")

g_empty_weight = xp.getFloat(dr_empty_weight) * 0.45359


event.register("OnUpdate", "OnUpdate_ETL_Patch")


function OnUpdate_ETL_Patch()

	local sim_airspeed = xp.getFloat(dr_sim_airspeed)

	if sim_airspeed > 3 and sim_airspeed < 6 then
		xp.setFloat(dr_empty_weight, g_empty_weight * 1.09)
	elseif sim_airspeed > 6 and sim_airspeed < 9 then
		xp.setFloat(dr_empty_weight, g_empty_weight * 1.15)
	elseif sim_airspeed > 9 and sim_airspeed < 14.5 then
		xp.setFloat(dr_empty_weight, g_empty_weight * 1.2)
	elseif sim_airspeed > 14.5 and sim_airspeed < 17 then
		xp.setFloat(dr_empty_weight, g_empty_weight * 0.755)
	elseif sim_airspeed > 17 and sim_airspeed < 20 then
		xp.setFloat(dr_empty_weight, g_empty_weight * 1.18)
	elseif sim_airspeed > 20 and sim_airspeed < 25 then
		xp.setFloat(dr_empty_weight, g_empty_weight * 1.25)
	elseif sim_airspeed > 25 and sim_airspeed < 30 then
		xp.setFloat(dr_empty_weight, g_empty_weight * 1.30)
	elseif sim_airspeed > 30 and sim_airspeed < 35 then
		xp.setFloat(dr_empty_weight, g_empty_weight * 1.35)
	elseif sim_airspeed > 35 and sim_airspeed < 55 then
		xp.setFloat(dr_empty_weight, g_empty_weight * 1.30)
	elseif sim_airspeed > 55 and sim_airspeed < 65 then
		xp.setFloat(dr_empty_weight, g_empty_weight * 1.20)
	elseif sim_airspeed > 65 and sim_airspeed < 70 then
		xp.setFloat(dr_empty_weight, g_empty_weight * 1.10)
	else
		xp.setFloat(dr_empty_weight, g_empty_weight)		
		end

end



event.register("OnDraw_Windows", "OnDraw_Windows_ETL_Patch")

function OnDraw_Windows_ETL_Patch()
	
	if xp.getFloat(dr_sim_flight_time) < 5 then
		gfx.setColor( 0.0, 1.0, 1.0, 1 ) -- R,G,B,A. I set the text color to cyan
		-- Draw some text 200 pixels from the left and about 500 pixels up 
		gfx.drawString( "Loaded CH-47D ETL fix", 200, 500 )			
		gfx.drawString( "Based on ND Art & Technology's Translational lift fix script", 200, 480 )			
		end
		
end

