--[[
CH-47D Gizmo Scripts.

This is a port of the CH-47D plugin.
Copyright 2013, Ben Russell - br@x-plugins.com

This script is intended to supplement this aircraft:
http://forums.x-plane.org/index.php?app=downloads&showfile=9519


LICENSE

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


--]]



function OnBoot()
	
	--bind our data refs
	xpdr_OverrideFlightControls = dref.getDataref("sim/operation/override/override_flightcontrol");
	
	xpdr_KIAS		= dref.getDataref("sim/flightmodel/position/indicated_airspeed");
	
	xpdr_JsPitch	= dref.getDataref("sim/joystick/yolk_pitch_ratio");
	xpdr_AsPitch	= dref.getDataref("sim/joystick/artstab_pitch_ratio");
	xpdr_FcPitch	= dref.getDataref("sim/joystick/FC_ptch");
	xpdr_TrPitch	= dref.getDataref("sim/flightmodel/controls/elv_trim");
	
	xpdr_JsRoll		= dref.getDataref("sim/joystick/yolk_roll_ratio");
	xpdr_AsRoll		= dref.getDataref("sim/joystick/artstab_roll_ratio");
	xpdr_FcRoll		= dref.getDataref("sim/joystick/FC_roll");
	xpdr_TrRoll		= dref.getDataref("sim/flightmodel/controls/ail_trim");
	
	xpdr_JsRudder	= dref.getDataref("sim/joystick/yolk_heading_ratio");
	xpdr_AsRudder	= dref.getDataref("sim/joystick/artstab_heading_ratio");
	xpdr_FcRudder	= dref.getDataref("sim/joystick/FC_hdng");
	xpdr_TrRudder	= dref.getDataref("sim/flightmodel/controls/rud_trim");
	
	--rotor angle.
	xpdr_RotorVector = dref.getDataref("sim/aircraft/prop/acf_vertcant"); --array, 8 items
	
	xpdr_FrameRatePeriod = dref.getDataref("sim/operation/misc/frame_rate_period");
	
	xpdr_PlayerAircraftWOW = dref.getDataref("sim/flightmodel/forces/fnrml_gear");
	
	--the parachute switch has been "hacked" to turn it into a gear-unlock switch.
	xpdr_ParachuteSwitch = dref.getDataref("sim/cockpit/switches/parachute_on");
	xpdr_GearSteers	= dref.getDataref("sim/aircraft/overflow/acf_gear_steers"); --array, 73 items


	logging.debug("drefs aquired.")

end




-- Global Vars that control the way the helo responds.
--these are used for inflight rotor-back pressure to induce forward stick input from the pilot
g_speedMax = 75.0		--maximum expected speed. 150 is more likely but I've added a margin.
g_deflectMax = 0.60		--maximum control deflection.


--these are used for on-ground rotor transition
g_frontRotorMinimum = 81.0			--min rotor vect
g_frontRotorDefault = 82.199997		--max rotor vect

g_rearRotorMinimum = 86.0			--min rotor vect
g_rearRotorDefault = 89.19997		--max rotor vect

g_transitionSpeed = 2.0				--how fast the rotor will transition from one position to another in deg/sec






--main flight-loop logic
function OnUpdate()

	local newPitch	= 0.0;
	local newRoll	= 0.0;
	local newRudder	= 0.0;

	--pitch augmentation based on speed to induce forward stick input from the pilot at speed.
	local kias = dref.getFloat( xpdr_KIAS );

	--calculate deflection augmentation based on KIAS, straight linear calculation.
	local deflectNow = ((kias / g_speedMax) * g_deflectMax);

	--integrate the joystick, augmentation, art-stab and trim values
	newPitch =	dref.getFloat( xpdr_JsPitch ) + 
				deflectNow + 
				dref.getFloat( xpdr_AsPitch ) + 
				dref.getFloat( xpdr_TrPitch );
	
	--enforce control cieling.
	if( newPitch > 1.0 )then
		newPitch = 1.0; 
	elseif( newPitch < -1.0 )then
		newPitch = -1.0;
	end

	--the other axis are simple enough, just integrate the stick inputs with artstab and trim
	newRoll		= dref.getFloat( xpdr_JsRoll ) + dref.getFloat( xpdr_AsRoll ) + dref.getFloat( xpdr_TrRoll );
	newRudder	= dref.getFloat( xpdr_JsRudder ) + dref.getFloat( xpdr_AsRudder ) + dref.getFloat( xpdr_TrRudder );


	--push the values back into the flight model.
	dref.setFloat( xpdr_FcPitch,		newPitch );
	dref.setFloat( xpdr_FcRoll,		newRoll );
	dref.setFloat( xpdr_FcRudder,	newRudder );


	--rotor transition when on ground to allow "correct" taxi behaviour.
	
	frp = dref.getFloat( xpdr_FrameRatePeriod );
	local transitionSpeed = g_transitionSpeed * frp; 
	
	
	--C code
	--float rotorValues[8];
	--XPLMGetDatavf( xpdr_RotorVector, rotorValues, 0, 8 );
	local rotorValues = { dref.getFloatV( xpdr_RotorVector, 1, 8 ) };
	
	local wow_value = dref.getFloat( xpdr_PlayerAircraftWOW )
	--check for weight on wheels, if true, we're on the ground, if false, we're in the air.
	if( wow_value > 0.0 )then
		--transition front rotor
			--move forward to taxi position
			if( rotorValues[1] > g_frontRotorMinimum )then
				rotorValues[1] = rotorValues[1] - transitionSpeed;
			end
			
			--move forward into taxi position
			if( rotorValues[2] > g_rearRotorMinimum )then
				rotorValues[2] = rotorValues[2] - transitionSpeed;
			end

	else
		--transition rear rotor
			--move back into flight position
			if( rotorValues[1] < g_frontRotorDefault )then
				rotorValues[1] = rotorValues[1] + transitionSpeed;
			else
				rotorValues[1] = g_frontRotorDefault;
			end

			--move back into flight position
			if( rotorValues[2] < g_rearRotorDefault )then
				rotorValues[2] = rotorValues[2] + transitionSpeed;
			else
				rotorValues[2] = g_rearRotorDefault;
			end
	
	end
	
	dref.setFloatV( xpdr_RotorVector, 1, rotorValues );



	--customised gear lock
	--int gearsThatSteer[73];
	tmp_gearsThatSteer = { dref.getIntV( xpdr_GearSteers, 1, 4 ) }
	
	if( dref.getInt( xpdr_ParachuteSwitch ) == 1 )then
		--switch is on, enable steering.
		--XPLMGetDatavi( xpdr_GearSteers, gearsThatSteer, 0, 73 );
		
		tmp_gearsThatSteer[1] = 0;
		tmp_gearsThatSteer[2] = 0;
		tmp_gearsThatSteer[3] = 1;
		tmp_gearsThatSteer[4] = 1;
		
	else
		--XPLMGetDatavi( xpdr_GearSteers, gearsThatSteer, 0, 73 );
		
		tmp_gearsThatSteer[1] = 0;
		tmp_gearsThatSteer[2] = 0;
		tmp_gearsThatSteer[3] = 0;
		tmp_gearsThatSteer[4] = 0;
		
	end

	--XPLMSetDatavi( xpdr_GearSteers, gearsThatSteer, 0, 73 );
	dref.setIntV( xpdr_GearSteers, 1, tmp_gearsThatSteer )

end






--eof
