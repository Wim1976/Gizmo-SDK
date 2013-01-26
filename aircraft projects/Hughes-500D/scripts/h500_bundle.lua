-- (C) 2006,2008,2011 Ben Russell (br@x-plugins.com) and Alex Gifford.
-- This file is part of H500-Gizmo and distributed under the GNU Public License Version 3 (GPLv3)
-- Please see LICENSE.txt for more information.


-- This script exists to give us an easy way to include all the functionality modules into the init.lua script.


--Create and find all the dataref handles we will need.


--dofile("strict-gizmo.lua")


--logging.debug("loading drefs ..")

dofile("h500_datarefs.lua")
logging.debug("loaded datarefs..")

--Door animations
dofile("h500_doors.lua")
logging.debug("loaded doors..")

--Pilot animations, head etc.
dofile("h500_pilot.lua")
logging.debug("loaded pilot..")

--Rotor head animations. Math inside.
dofile("h500_rotor.lua")
logging.debug("loaded rotor..")

--Decodes an X-Plane variable into a set of more useful single datarefs.
dofile("h500_switches.lua")
logging.debug("loaded switches..")

--Produces vibration effects for different speeds.
dofile("h500_translational_shudder.lua")
logging.debug("loaded trans shudder..")













--these are maximum travel limits as defined by the ACF file, globalize.
    H500_CyclicAileron = xp.getFloat( xdr_CyclicAileron )
    H500_CyclicPitch = xp.getFloat( xdr_CyclicPitch )






--run everything.
function main()

  --gizmo.sleep(20)

  update_doors()            --done
  update_pilot()
  update_rotor()
  update_switches()

  --update_translational_shudder()
end









