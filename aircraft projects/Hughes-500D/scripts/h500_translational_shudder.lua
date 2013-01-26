-- (C) 2006,2008,2011 Ben Russell (br@x-plugins.com) and Alex Gifford.
-- This file is part of H500-Gizmo and distributed under the GNU Public License Version 3 (GPLv3)
-- Please see LICENSE.txt for more information.



-- This file handles translation shudder effects as the helo passes through various speeds.


--init some static vars
	fLastTacSinP = 0.0;
	fLastTacSinQ = 0.0;


function update_translational_shudder()
    logging.debug("update trans shudder")

	--Stuff them in a table. Remember, tables start from element [1], not [0].
	tacValues = { xp.getFloatV( xdr_TachRad, 1, 8 ) };

		--//calculate P and Q dot values
			p = xp.getFloat( xdr_PDot )
			q = xp.getFloat( xdr_QDot )

			if( xp.getInt( xdr_OnGround ) )then
				--we attentuate the raw data when the aircraft is on the ground
				p = p * 0.001;
				q = q * 0.5; --random noise in pitch axis is no where near as bad.
			end




			--add noise to the P signal, driven by the overhead rotor.
			fTacSinP = math.sin( tacValues[5] * 0.03) * (tacValues[1] * 0.05)

				p = p + fTacSinP;

			fLastTacSinP = fTacSinP;


			--add noisie to the Q signal, driven by the tail rotor.

			fTacSinQ = math.sin( tacValues[6] * 0.03) * (tacValues[2] * 0.005)

				q = q + fTacSinQ;

			fLastTacSinQ = fTacSinQ;


			xp.setFloat( xcdr_P, p )
			xp.setFloat( xcdr_Q, q )

		--end P and Q

end --end: function update_shudder()
