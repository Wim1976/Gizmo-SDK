-- (C) 2006,2008,2011 Ben Russell (br@x-plugins.com) and Alex Gifford.
-- This file is part of H500-Gizmo and distributed under the GNU Public License Version 3 (GPLv3)
-- Please see LICENSE.txt for more information.



--[[

This file contains the code which controls the Rotor Head and Tail Rotor.
It handles the spin logic, the blade transition logic and,
the piece-de-resistance, individual blade-pitch that is mechanically correct in
accordance with Pitch/Roll of the Cyclic and Pull of the Collective.

Status: Working. Confirm AoA cycle. Occasional bugs with stowed rotor position, haven't seen reproduced.

--]]


function update_rotor()
  --logging.debug("update rotor")

	--Stuff them in a table. Remember, tables start from element [1], not [0].
	local tacValues = { xp.getFloatV( xdr_TachRad, 1, 8 ) }

	local v1 = 0
	local v2 = 0

	local maxRotation = 720.0;


    local bRotorDemoMode = true

    --calculate rotor locations.
    if( bRotorDemoMode )then --rotor demo mode.
        --rotor spins automatically

        --roughly matched to max camera orbit speed when using arrow keys.
            --v1 = xcdr_rotorPositionDegreesMain.getFloat() + (13.0f * fFrameRate) --test code for checking cyclic deflections

        --4* faster for the demo version destined for mass consumption
            local demo_r_speed = 30

            v1 = xp.getFloat(xcdr_rotorPositionDegreesMain) + (demo_r_speed * gfx.getM()) --test code for checking cyclic deflections
            v2 = xp.getFloat(xcdr_rotorPositionDegreesTail) + (demo_r_speed * gfx.getM()) --tail rotor

    else --rotor spins according to x-plane physics.
          v1 = xp.getFloat(xcdr_rotorPositionDegreesMain) + math.deg(tacValues[1])  * gfx.getM()
          if( v1 > maxRotation )then
            v1 = v1 - maxRotation
          elseif( v1 < -maxRotation )then
            v1 = v1 + maxRotation
          end

        --calculate tail rotor spin
        v2 = xp.getFloat(xcdr_rotorPositionDegreesTail) + math.deg(tacValues[2])  * gfx.getM()
        if( v2 > maxRotation )then
          v2 = v2 - maxRotation
        elseif( v2 < -maxRotation )then
         v2 = v2 + maxRotation
        end


    end --check to see if we're in demo mode.




	xp.setFloat( xcdr_rotorPositionDegreesMain, v1 )
	xp.setFloat( xcdr_rotorPositionDegreesTail, v2 )




    --currect disc tilt for main and tail rotors.
    local discTiltPitch 	= xp.getFloatV( xdr_TiltPitch, 1, 1 )
    local discTiltRoll 	    = xp.getFloatV( xdr_TiltRoll, 1, 1 )


    --storage for new values.
    local fNewDiscTiltPitch = 0
    local fNewDiscTiltRoll = 0

    local fNewDiscTiltPitchMutingLow = 0
    local fNewDiscTiltRollMutingLow = 0


    --look at tacrad speed, if >= 15.0, set flag and pass on 0.0 for disc tilt and roll
    --if <= 15.0, clear flag and pass disc tilt and roll straight through.
    if( tacValues[1] >= 15.0 ) and (not bRotorDemoMode)then   --TODO; rotor demo mode
      xp.setFloat( xcdr_rotorDiscTacradsHighMain, 1 )
      xp.setFloat( xcdr_rotorPositionDegressMainMuted, 0 )

      --//used for low speed rotor
      fNewDiscTiltPitch = 0
      fNewDiscTiltRoll = 0

      --//used for high speed rotor
      fNewDiscTiltPitchMutingLow = discTiltPitch;
      fNewDiscTiltRollMutingLow = discTiltRoll;

      --//alexs new fps based accumulators
          local fpsAccMain = xp.getFloat( xcdr_rotorPositionDegreesFpsMatchedMainMuting )
          if( fpsAccMain > 36000 )then fpsAccMain = fpsAccMain - 36000 end
          xp.setFloat( xcdr_rotorPositionDegreesFpsMatchedMainMuting, (fpsAccMain + 36) )


    else
      xp.setFloat( xcdr_rotorDiscTacradsHighMain, 0 )
      xp.setFloat( xcdr_rotorPositionDegreesMainMuted, v1 )

      --//used for low speed rotors
      fNewDiscTiltPitch = discTiltPitch;
      fNewDiscTiltRoll = discTiltRoll;

      --//used for hi-speed rotors
      fNewDiscTiltPitchMutingLow = 0
      fNewDiscTiltRollMutingLow = 0

      xp.setFloat( xcdr_rotorPositionDegreesFpsMatchedMainMuting, 0 )

    end



    --this code handles actuating the blade hub and makes the blades follow the swashplate.
    xp.setFloat( xcdr_rotorDiscTiltPitch, fNewDiscTiltPitch )
    xp.setFloat( xcdr_rotorDiscTiltRoll, fNewDiscTiltRoll )

    xp.setFloat( xcdr_rotorDiscTiltPitchMutingLow, fNewDiscTiltPitchMutingLow )
    xp.setFloat( xcdr_rotorDiscTiltRollMutingLow, fNewDiscTiltRollMutingLow )


    --//filtered disc tilt values, upto 15.0 tacrads the disc tilt/roll is simply copied
    --//above 15.0 it is set to 0.0 and a flag is set true.
    if( tacValues[2] >= 15.0 )then -- && ! bRotorDemoMode ){
      --xp.setInt( xcdr_rotorDiscTacradsHighTail, 1 )
      xp.setFloat( xcdr_rotorDiscTacradsHighTail, 1 )
      xp.setFloat( xcdr_rotorPositionDegreesTailMuted, 0.0 )

      --//alex's new fps based accumulators.
      local fpsAccTail = xp.getFloat( xcdr_rotorPositionDegreesFpsMatchedTailMuting )
      if( fpsAccTail > 36000 )then fpsAccTail = fpsAccTail - 36000; end
      xp.setFloat( xcdr_rotorPositionDegreesFpsMatchedTailMuting, (fpsAccTail + 36) )

    else
      --xp.setInt( xcdr_rotorDiscTacradsHighTail, 0 )
      xp.setFloat( xcdr_rotorDiscTacradsHighTail, 0 )
      xp.setFloat( xcdr_rotorPositionDegreesTailMuted, v2 )
      xp.setFloat( xcdr_rotorPositionDegreesFpsMatchedTailMuting, 0.0 )

    end









-- Blade Pitch Code
	--alex's blade pitch code.
    --todo; deal with n blades instead of hard coded to 5 blades.
    --[[
        The variables are:

        a = prop angle in degrees (CCW is positive from above)
        b = individual blade pitch
        P = sim/joystick/yolk_pitch_ratio // pitch request -1/1 full fwd/full back
        R = sim/joystick/yolk_roll_ratio // roll request -1/1 full left/full right
        C = sim/flightmodel/engine/POINT_pitch_deg[0] //collective request -2/12.5
        n = blade number 0...4 // blade 0 is north, blade 1 is at 72º west etc

        The math is:

        b[n] = {3.75 * R * cos(a + (72 * n))} - {6 * P * sin(a + (72 * n))} + C
    --]]



    -- [[
    --faBladePitch = {1, 2, 3, 4, 5}; -- 5 element table.
    local faBladePitch = {}

    local fBladeCount = xp.getFloatV( xdr_BladeCount, 1, 1 ) --blade count for main rotor head only thanks.
    if( fBladeCount > 5.0 )then fBladeCount = 5.0; end --//cap at 5 blades max, dataref logic limit....

    local fBladeOffsetStep = 360 / fBladeCount;

    local fPropAngle = xp.getFloat( xcdr_rotorPositionDegreesMain ) - (fBladeOffsetStep * 0.5)

    local fCollectiveRequest = xp.getFloatV( xdr_CollectiveRequest, 1, 1 )


    --print("cyclic ranges: a:" .. fCyclicAileron .. " p:" .. fCyclicPitch )

    for i=1,5 do
      local fBladeOffset = math.rad( fPropAngle + (i * fBladeOffsetStep) )

      faBladePitch[i] =
          ((
              ( H500_CyclicAileron * xp.getFloat( xdr_FlightControlRoll ) * math.cos( fBladeOffset ) )
              -
              ( H500_CyclicPitch * xp.getFloat( xdr_FlightControlPitch ) * math.sin( fBladeOffset ) )
          ) * -1.0 ) + fCollectiveRequest

    end

    --reminder: Lua arrays start at index 1, not 0.
    xp.setFloat( xcdr_rotorBladePitch0, faBladePitch[1] )
    xp.setFloat( xcdr_rotorBladePitch1, faBladePitch[2] )
    xp.setFloat( xcdr_rotorBladePitch2, faBladePitch[3] )
    xp.setFloat( xcdr_rotorBladePitch3, faBladePitch[4] )
    xp.setFloat( xcdr_rotorBladePitch4, faBladePitch[5] )


end --end: function update_rotor()
