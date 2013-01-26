-- (C) 2006,2008,2011 Ben Russell (br@x-plugins.com) and Alex Gifford.
-- This file is part of H500-Gizmo and distributed under the GNU Public License Version 3 (GPLv3)
-- Please see LICENSE.txt for more information.


-- This file is responsible for either registration/lookup or creation, of dataref handles.




------------ X-Plane built-in datarefs  ------------



xdr_YokePitch         = xp.getDataref("sim/joystick/yolk_pitch_ratio")
xdr_YokeRoll          = xp.getDataref("sim/joystick/yolk_roll_ratio")
xdr_YokeHeading       = xp.getDataref("sim/joystick/yolk_heading_ratio")

xdr_Aoa               = xp.getDataref("sim/flightmodel/position/alpha")
xdr_HPath             = xp.getDataref("sim/flightmodel/position/psi")
xdr_Tas               = xp.getDataref("sim/flightmodel/position/true_airspeed")

xdr_PilotsHeadPsi     = xp.getDataref("sim/graphics/view/pilots_head_psi")
xdr_PilotsHeadTheta   = xp.getDataref("sim/graphics/view/pilots_head_the")
xdr_Buttons           = xp.getDataref("sim/joystick/joystick_button_values")


xdr_Paused            = xp.getDataref("sim/time/paused")

xdr_TachRad           = xp.getDataref( "sim/flightmodel/engine/POINT_tacrad" ) --//8 item float, the first 2 we use.
--//xdr_Throttle = xp.getDataref("sim/flightmodel/engine/ENGN_thro_use" ) //8 item array.

xdr_PDot              = xp.getDataref( "sim/flightmodel/position/P_dot" )
xdr_QDot              = xp.getDataref( "sim/flightmodel/position/Q_dot" )

xdr_OnGround          = xp.getDataref("sim/flightmodel/failures/onground_any")

xdr_FrameRate         = xp.getDataref("sim/operation/misc/frame_rate_period")

xdr_AudioPanel        = xp.getDataref( "sim/cockpit/switches/audio_panel_out" )

xdr_TiltPitch         = xp.getDataref("sim/flightmodel/cyclic/cyclic_elev_disc_tilt")
xdr_TiltRoll          = xp.getDataref("sim/flightmodel/cyclic/cyclic_ailn_disc_tilt")

xdr_FlightControlPitch = xp.getDataref("sim/joystick/yolk_pitch_ratio")
xdr_FlightControlRoll = xp.getDataref("sim/joystick/yolk_roll_ratio")

--//alex swashplate drefs.
xdr_PropAngle = xp.getDataref("sim/flightmodel/engine/POINT_prop_ang_deg") --//we want item 0
xdr_CollectiveRequest = xp.getDataref("sim/flightmodel/engine/POINT_pitch_deg") --//iitem 0


xdr_Phi = xp.getDataref("sim/flightmodel/position/phi")
xdr_Psi = xp.getDataref("sim/flightmodel/position/psi")


xdr_SpeedbreakRequest = xp.getDataref("sim/flightmodel/controls/sbrkrqst") --//moving map - done.
xdr_FlapRequest = xp.getDataref("sim/flightmodel/controls/flaprqst") --//doors
xdr_ArrestorGear = xp.getDataref("sim/cockpit/switches/arresting_gear") --//gps toggle




--//the camera and aircraft location is used to calculate the heading for the pilots head.
xdr_CameraX = xp.getDataref("sim/graphics/view/view_x")
xdr_CameraZ = xp.getDataref("sim/graphics/view/view_z")

xdr_LocalX = xp.getDataref("sim/flightmodel/position/local_x")
xdr_LocalZ = xp.getDataref("sim/flightmodel/position/local_z")




--//blade count and cyclic travel ranges
xdr_BladeCount = xp.getDataref("sim/aircraft/prop/acf_num_blades") --//float 8
xdr_CyclicAileron = xp.getDataref("sim/aircraft/vtolcontrols/acf_cyclic_ailn")
xdr_CyclicPitch = xp.getDataref("sim/aircraft/vtolcontrols/acf_cyclic_elev")









--these arent used.
xcdr_cosPitch = xp.newDataref("abb/controls/cos_pitch" )
xcdr_cosRoll = xp.newDataref("abb/controls/cos_roll" )
xcdr_cosHeading = xp.newDataref("abb/controls/cos_heading" )

xcdr_translationalShudder = xp.newDataref("abb/dynamics/helo/shudder")

xcdr_filteredAoa = xp.newDataref("abb/dynamics/filtered/aoa")
--not used






xcdr_P = xp.newDataref("abb/dynamics/att/p")
xcdr_Q = xp.newDataref("abb/dynamics/att/q")


xcdr_rotorPositionDegreesMain = xp.newDataref("abb/rotor/position/degrees/main")
xcdr_rotorPositionDegreesMainMuted = xp.newDataref("abb/rotor/position/degrees/main/muting")

xcdr_rotorPositionDegreesTail = xp.newDataref("abb/rotor/position/degrees/tail")
xcdr_rotorPositionDegreesTailMuted = xp.newDataref("abb/rotor/position/degrees/tail/muting")


xcdr_rotorPositionDegreesFpsMatchedMainMuting = xp.newDataref("abb/rotor/position/main/fps/muting")
xcdr_rotorPositionDegreesFpsMatchedTailMuting = xp.newDataref("abb/rotor/position/tail/fps/muting")



xcdr_rotorDiscTiltPitch = xp.newDataref("abb/rotor/disc/tilt/pitch/muting")
xcdr_rotorDiscTiltRoll = xp.newDataref("abb/rotor/disc/tilt/roll/muting")



--//these provide a muting disc pitch source for our custom hi-speed rotor.
xcdr_rotorDiscTiltPitchMutingLow = xp.newDataref("abb/rotor/disc/tilt/pitch/muting/low")
xcdr_rotorDiscTiltRollMutingLow = xp.newDataref("abb/rotor/disc/tilt/roll/muting/low")




xcdr_rotorBladePitch0 = xp.newDataref("abb/rotor/blades/pitch/0")
xcdr_rotorBladePitch1 = xp.newDataref("abb/rotor/blades/pitch/1")
xcdr_rotorBladePitch2 = xp.newDataref("abb/rotor/blades/pitch/2")
xcdr_rotorBladePitch3 = xp.newDataref("abb/rotor/blades/pitch/3")
xcdr_rotorBladePitch4 = xp.newDataref("abb/rotor/blades/pitch/4")



xcdr_pilotHeadHeadingDegrees = xp.newDataref("abb/pilot/head/heading/degrees")





--//-------------- boolean flags below this point ------------
xcdr_rotorDiscTacradsHighMain = xp.newDataref("abb/flags/rotor/disc/tacrads/high/main")
--xcdr_rotorDiscTacradsHighMain.setType( xplmType_Int )
xcdr_rotorDiscTacradsHighTail = xp.newDataref("abb/flags/rotor/disc/tacrads/high/tail")
--xcdr_rotorDiscTacradsHighTail.setType( xplmType_Int )



xcdr_audioPanelNav1 = xp.newDataref("abb/flags/audio/panel/nav1")
--xcdr_audioPanelNav1.setType( xplmType_Int )
xcdr_audioPanelNav2 = xp.newDataref("abb/flags/audio/panel/nav2")
--xcdr_audioPanelNav2.setType( xplmType_Int )
xcdr_audioPanelAdf1 = xp.newDataref("abb/flags/audio/panel/adf1")
--xcdr_audioPanelAdf1.setType( xplmType_Int )
xcdr_audioPanelAdf2 = xp.newDataref("abb/flags/audio/panel/adf2")
--xcdr_audioPanelAdf2.setType( xplmType_Int )
xcdr_audioPanelDme = xp.newDataref("abb/flags/audio/panel/dme")
--xcdr_audioPanelDme.setType( xplmType_Int )
xcdr_audioPanelCom1 = xp.newDataref("abb/flags/audio/panel/com1")
--xcdr_audioPanelCom1.setType( xplmType_Int )
xcdr_audioPanelCom2 = xp.newDataref("abb/flags/audio/panel/com2")
--xcdr_audioPanelCom2.setType( xplmType_Int )


xcdr_switchDoorsLeft = xp.newDataref("abb/doors/left/cockpit/position")
--//xcdr_switchDoorsLeft.setType( xplmType_Int )

xcdr_switchDoorsRight = xp.newDataref("abb/doors/right/cockpit/position")
--//xcdr_switchDoorsRight.setType( xplmType_Int )

--- end int block --











