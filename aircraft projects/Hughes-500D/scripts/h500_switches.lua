-- (C) 2006,2008,2011 Ben Russell (br@x-plugins.com) and Alex Gifford.
-- This file is part of H500-Gizmo and distributed under the GNU Public License Version 3 (GPLv3)
-- Please see LICENSE.txt for more information.




--[[

switches.lua controls the datarefs that update the collins switch panel at the
bottom of the center console.

It looks at the value of 'sim/cockpit/switches/audio_panel_out' which is an enum
of sorts, and outputs an easy to use(with animation) bank of binary toggle values.

It seems that the values of the dataref we feed on (see above) have changed
since the original plugin was released. Testing the script in 8.64-Linux shows
different values being set for the switch presses. Annoying.
TODO; Double check the switch values using a mouse and joystick to operate the
3D cockpit.

Status; Port complete but values need double checking, see above.


CONFIRMED BROKEN BY X-PLANE

See: http://www.xsquawkbox.net/xpsdk/mediawiki/sim%252Fcockpit%252Fswitches%252Faudio_panel_out

For updated enum codes.

Lua's weak point is decoding enums at the moment.

--]]



function update_switches()
  --print("update_switches()...")

  AudioPanelStateFlag = xp.getInt( xdr_AudioPanel )

  --print("Audio Panel State Flag Value: " .. AudioPanelStateFlag )

  if AudioPanelStateFlag == 0 then
    --Nav1
    xp.setFloat( xcdr_audioPanelNav1, 1 )
    xp.setFloat( xcdr_audioPanelNav2, 0 )
    xp.setFloat( xcdr_audioPanelAdf1, 0 )
    xp.setFloat( xcdr_audioPanelAdf2, 0 )
    xp.setFloat( xcdr_audioPanelDme,  0 )
    xp.setFloat( xcdr_audioPanelCom1, 0 )
    xp.setFloat( xcdr_audioPanelCom2, 0 )

  elseif AudioPanelStateFlag == 1 then
    --Nav2
    xp.setFloat( xcdr_audioPanelNav1, 0 )
    xp.setFloat( xcdr_audioPanelNav2, 1 )
    xp.setFloat( xcdr_audioPanelAdf1, 0 )
    xp.setFloat( xcdr_audioPanelAdf2, 0 )
    xp.setFloat( xcdr_audioPanelDme,  0 )
    xp.setFloat( xcdr_audioPanelCom1, 0 )
    xp.setFloat( xcdr_audioPanelCom2, 0 )

  elseif AudioPanelStateFlag == 2 then
    --Adf1
    xp.setFloat( xcdr_audioPanelNav1, 0 )
    xp.setFloat( xcdr_audioPanelNav2, 0 )
    xp.setFloat( xcdr_audioPanelAdf1, 1 )
    xp.setFloat( xcdr_audioPanelAdf2, 0 )
    xp.setFloat( xcdr_audioPanelDme,  0 )
    xp.setFloat( xcdr_audioPanelCom1, 0 )
    xp.setFloat( xcdr_audioPanelCom2, 0 )

  elseif AudioPanelStateFlag == 3 then
    --Adf2
    xp.setFloat( xcdr_audioPanelNav1, 0 )
    xp.setFloat( xcdr_audioPanelNav2, 0 )
    xp.setFloat( xcdr_audioPanelAdf1, 0 )
    xp.setFloat( xcdr_audioPanelAdf2, 1 )
    xp.setFloat( xcdr_audioPanelDme,  0 )
    xp.setFloat( xcdr_audioPanelCom1, 0 )
    xp.setFloat( xcdr_audioPanelCom2, 0 )

  elseif AudioPanelStateFlag == 5 then
    --DME
    xp.setFloat( xcdr_audioPanelNav1, 0 )
    xp.setFloat( xcdr_audioPanelNav2, 0 )
    xp.setFloat( xcdr_audioPanelAdf1, 0 )
    xp.setFloat( xcdr_audioPanelAdf2, 0 )
    xp.setFloat( xcdr_audioPanelDme,  1 )
    xp.setFloat( xcdr_audioPanelCom1, 0 )
    xp.setFloat( xcdr_audioPanelCom2, 0 )

  elseif AudioPanelStateFlag == 10 then
    --Com1
    xp.setFloat( xcdr_audioPanelNav1, 0 )
    xp.setFloat( xcdr_audioPanelNav2, 0 )
    xp.setFloat( xcdr_audioPanelAdf1, 0 )
    xp.setFloat( xcdr_audioPanelAdf2, 0 )
    xp.setFloat( xcdr_audioPanelDme,  0 )
    xp.setFloat( xcdr_audioPanelCom1, 1 )
    xp.setFloat( xcdr_audioPanelCom2, 0 )

  elseif AudioPanelStateFlag == 11 then
    --Com2
    xp.setFloat( xcdr_audioPanelNav1, 0 )
    xp.setFloat( xcdr_audioPanelNav2, 0 )
    xp.setFloat( xcdr_audioPanelAdf1, 0 )
    xp.setFloat( xcdr_audioPanelAdf2, 0 )
    xp.setFloat( xcdr_audioPanelDme,  0 )
    xp.setFloat( xcdr_audioPanelCom1, 0 )
    xp.setFloat( xcdr_audioPanelCom2, 1 )

  else
    --print("Unknown switch block value, did they change?")

  end

  --print("end update_switches..")
end --end: function update_switches()
