-- (C) 2006,2008,2011 Ben Russell (br@x-plugins.com) and Alex Gifford.
-- This file is part of H500-Gizmo and distributed under the GNU Public License Version 3 (GPLv3)
-- Please see LICENSE.txt for more information.


-- This code handles the custom door open and close logic including a nice bounce.


-- 2011-01-29 - This code has been ported and tested in X-Plane 9.62 ish. br@x-plugins.com



fDoorSpeedMax = 0.4 --//alex default was 0.4f;
fDoorSpeed = 0.0
bDoorBounce = 0


function update_doors()

	--this code watches flaps inputs and changes our data-refs to reflect a door open request accordingly.
	if( xp.getFloat( xdr_FlapRequest ) > 0.0 )then
		bDoorOpenState = 1
	else
		bDoorOpenState = 0
	end

	--print("bDoorOpenState: " .. bDoorOpenState )


			if( bDoorOpenState == 1 )then
				--print("Door switch left: " .. xp.getFloat( xcdr_switchDoorsLeft ) )
				if( xp.getFloat( xcdr_switchDoorsLeft ) < 1.0 and ( bDoorBounce == 0 ) )then
					--print("Opening..")

					bDoorBounce = 0

					fDoorSpeed = fDoorSpeedMax * ( 1.5 - xp.getFloat( xcdr_switchDoorsLeft ) )
					--print("Door speed: " .. fDoorSpeed)

					fNewVal = xp.getFloat( xcdr_switchDoorsLeft ) + (fDoorSpeed * gfx.getM() )

					if( fNewVal > 1.0 )then
						fNewVal = 1.0
					end
					--print("fNewVal: " .. fNewVal)

					xp.setFloat( xcdr_switchDoorsLeft, fNewVal )
					xp.setFloat( xcdr_switchDoorsRight, fNewVal )


				else

					bDoorBounce = 1

					fDoorSpeed = fDoorSpeedMax * (( xp.getFloat( xcdr_switchDoorsLeft ) - 0.87 ))

					if( fDoorSpeed < 0.01 )then
                      --if the door speed gets really low then we clamp it to 0
                      fDoorSpeed = 0.0
                    end

					
                    if( fDoorSpeed > 0.0 )then
						fNewVal = xp.getFloat( xcdr_switchDoorsLeft ) - (fDoorSpeed * gfx.getM() )
						if( fNewVal < 0.0 )then
							fNewVal = 0.0;
							bDoorBounce = 0;
						end

						--print("Bouncing: " .. fNewVal)

						xp.setFloat( xcdr_switchDoorsLeft, fNewVal )
						xp.setFloat( xcdr_switchDoorsRight, fNewVal )
					end
				end
			else
				bDoorBounce = 0;

				fDoorSpeed = fDoorSpeedMax * ( 1.2 - xp.getFloat( xcdr_switchDoorsLeft ) )

				if( xp.getFloat( xcdr_switchDoorsLeft ) > 0.0 )then
					--print("Closing..")
					fNewVal = xp.getFloat( xcdr_switchDoorsLeft ) - (fDoorSpeed * gfx.getM() )
					if( fNewVal < 0.0 )then
						fNewVal = 0.0;
					end
					--print("nv: " .. fNewVal )
					xp.setFloat( xcdr_switchDoorsLeft, fNewVal )
					xp.setFloat( xcdr_switchDoorsRight, fNewVal )
				end
			end


end --end: function update_doors()
