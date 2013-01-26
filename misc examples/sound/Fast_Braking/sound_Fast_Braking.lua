--[[

This script plays a special wav file if you're going faster than 50 KIAS and use more than half brake force.


Thank you to "cessna_man" on the Org for suggesting this example.
http://forums.x-plane.org/index.php?showuser=71021

--]]

snd_fast_braking = sound.newSound()
sound.load( snd_fast_braking, xp.getAircraftFolder() .. "sounds/fast_braking.wav" )
sound.setLoop( snd_fast_braking, 1 ) --sound will now loop forever when played

--im not sure if this is the right dataref
dr_brakes = xp.getDataref("sim/cockpit2/controls/parking_brake_ratio")


sound_playing = false --should probably make a gizmo function for this ;)

function main()
 braking_amount = xp.getFloat( dr_brakes )
 
 if( acf.getKIAS() > 50 )then
  --we are going faster than 50 KIAS

   if( braking_amount > 0.5 )then
    if( sound_playing == false )then
     sound_playing = true
     sound.play( snd_fast_braking )
    end

   elseif( braking_amount < 0.5 )then
    if( sound_playing )then
     sound_playing = false
     sound.stop( snd_fast_braking )
    end

   end --end of looking at braking pressure

  end --end of decision about speed and what to do when fast

end --end of main() loop that runs every frame