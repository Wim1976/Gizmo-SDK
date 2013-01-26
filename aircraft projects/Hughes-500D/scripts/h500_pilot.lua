-- (C) 2006,2008,2011 Ben Russell (br@x-plugins.com) and Alex Gifford.
-- This file is part of H500-Gizmo and distributed under the GNU Public License Version 3 (GPLv3)
-- Please see LICENSE.txt for more information.



-- 2011-01-29 - Tested and working under Gizmo 11.2-unstable and X-Plane ~9.62


--[[

Code in this file looks after animating the pilots head.
It makes the pilot look at the camera when the aircraft is on the ground.
When the aircraft is in the air the pilots head will roughly follow the roll of
the aircraft, he will look into the roll.

--]]




--Pilot-Head Heading Code, make the pilot figure look at the camera...
function update_pilot()
  --logging.debug("update pilot")

  --print("Updating Pilot..")

  local TargetHeading = 0 --this will be dynamically calculated based on:
                              --the position of the camera relative to the airframe.
                              --travel limits of the human neck
                              --vis limits of the virtual pilot through the airframe, left/right travel differs slightly.

  local HeadCurrentHeading = xp.getFloat( xcdr_pilotHeadHeadingDegrees ) --where are we now? use the dataref as the global bucket.
  local OnGroundFlag = xp.getInt( xdr_OnGround ) --the virtual pilot only looks at the camera if we're on the ground.


  if( OnGroundFlag == 1 )then
    --logging.debug("on the ground")

    --find camera relative to airframe.
    TargetHeading = trig.courseToLocation(
                xp.getFloat( xdr_CameraX ) - xp.getFloat( xdr_LocalX ),
                xp.getFloat( xdr_CameraZ ) - xp.getFloat( xdr_LocalZ )
                )
                - xp.getFloat( xdr_Psi )

    --logging.debug("got a target heading of: " .. tostring(TargetHeading) )

                                                --)
    --do some heading corrections... basically converts everything to a +-180 degree system
    if( TargetHeading > 180.0 )then
        TargetHeading = TargetHeading - 360.0;
    elseif( TargetHeading < -180.0 )then
        TargetHeading = TargetHeading + 360.0;
    end

    --if the camera is out of a reasonable range we stop looking at it.
    --we can see further to the left(-) than to the right(+) due to door structure.
    --this code needs to be door-open sensitive!!!
    if( TargetHeading > 92.0 or TargetHeading < -100.0 )then
        TargetHeading = 0.0; --20.0f = ~instruments.
    end


  else --aircraft is not on the ground


    --TODO; we expand this to do an instrument scan occasionally ?
    --TODO; expand this so that the pilot will risk a look at the camera if he has sufficient height AGL?
    TargetHeading = xp.getFloat( xdr_Phi ) --when off the ground, heading of head = roll of aircraft...

  end --OnGroundFlag check


  --logging.debug(" pilot head target heading: " .. TargetHeading )



  --cap ranges - human neck limits.
  if( TargetHeading < -70.0 )then
      TargetHeading = -70.0;
  elseif( TargetHeading > 70.0 )then
      TargetHeading = 70.0;
  end


  --setup a distance based speed rate. the divisor is a window of degrees in which to effect the slowdown. (35.0f) in first build
  local HeadingTargetDistancePercent = (TargetHeading - HeadCurrentHeading) / 25.0;

  --cap at max of 100% speed, can be negative or positive depending on turn direction
  if( HeadingTargetDistancePercent > 1.0 )then
      HeadingTargetDistancePercent = 1.0;
  elseif( HeadingTargetDistancePercent < -1.0 )then
      HeadingTargetDistancePercent = -1.0;
  end


  local HeadRotationSpeed = 150.0; --120.0f in first build

  local HeadTurnSpeedMax = HeadRotationSpeed * HeadingTargetDistancePercent;
  --print("hpd: " .. HeadingTargetDistancePercent)


  --adjust our turn rate using x-plane fps multiplier
  HeadCurrentHeading = HeadCurrentHeading + (HeadTurnSpeedMax * gfx.getM())
  --print("head Current heading: " .. HeadCurrentHeading )

  --do intertia modelling(? comment might be out of date...)
      if( HeadCurrentHeading < -70.0 )then
          --we have gone too far, clip.
          HeadCurrentHeading = -70.0;
      elseif( HeadCurrentHeading > 70.0 )then
          --we have gone too far, clip.
          HeadCurrentHeading = 70.0;
      end


  --printf(" pilot head heading: %2.3f\n", fHeadCurrentHeading )

  --xcdr_pilotHeadHeadingDegrees.setFloat( fHeadCurrentHeading )
  xp.setFloat( xcdr_pilotHeadHeadingDegrees, HeadCurrentHeading )




end --end: function update_pilot()
