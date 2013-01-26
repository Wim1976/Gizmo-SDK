--[[
TRANSLATIONAL LIFT FIX SCRIPT, v 1.0
by nils@nd-art-and-technology.com, 2011

This script mitigates the irritating "lift dip" that occurs in X-Plane helicopters when passing in and out of translational lift speed.
The script does this by temporarily reducing the aircraft empty weight when the airspeed is in the regime where the lift dip occurs.
I have provided comments to try to encourage people to start exploring Gizmo.

If you like this script, you should really make a donation to br@x-plugins.com who gave the X-Plane community Gizmo and the power of Lua scripting.
--]]





-- First we register handles to the three datarefs we are going to be using. I use "dr_" as prefix for these.
dr_sim_empty_weight = xp.getDataref("sim/aircraft/weight/acf_m_empty")
dr_sim_flight_time = xp.getDataref("sim/time/total_flight_time_sec")
dr_sim_airspeed = xp.getDataref("sim/flightmodel/position/indicated_airspeed")

-- Then we get and store the aircraft empty weight and convert it from kg to lbs. 
-- I use the "g_" prefix to indicate that this is a global variable, available to all functions in the script.
g_empty_weight = xp.getFloat(dr_empty_weight) * 0.45359





-- All instructions in this main function will be executed once every "frame" when the sim is runnning.
function main()

	-- let's get the indicated airspeed! "local" means this variable is only available within this function.
	local sim_airspeed = xp.getFloat(dr_sim_airspeed)

	-- logic: if airspeed is within 12-15 knots, we reduce acf empty weight to 75%, otherwise we restore it to 100%.
	if sim_airspeed > 12 and sim_airspeed < 17 then
		xp.setFloat(dr_empty_weight, g_empty_weight * 0.75)
	else
		xp.setFloat(dr_empty_weight, g_empty_weight)		
		end

end


-- In this function we can put things that we want to display at the same "drawing phase" as the x-plane user interface (menu etc.)
function OnDraw_Windows()

	-- Here, I want to display some credits for 5 seconds after the helicopter has been loaded.
	-- This serves as an indication to the user that his gizmo setup is working and the script is up and running.
	
	if xp.getFloat(dr_sim_flight_time) < 5 then
		gfx.setColor( 0.0, 1.0, 1.0, 1 ) -- R,G,B,A. I set the text color to cyan
		-- Draw some text 200 pixels from the left and about 500 pixels up 
		gfx.drawString( "Loaded Translational Lift fix script v 1.0", 200, 500 )			
		gfx.drawString( "www.nd-art-and-technology.com, 2011", 200, 480 )			
		end
		
end

