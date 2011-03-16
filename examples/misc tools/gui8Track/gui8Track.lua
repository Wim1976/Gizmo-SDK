
--Change this to true and we will load all the sounds when we start automatically.
gizmo8Track_load_all_sounds_at_boot = false


-- Create a Lua "table" to store our sound filenames in.
-- At the moment these are only used as "defaults". This is just a quick demo script.
gizmo8Track_SoundTable_Filenames = {
	"sounds/CH47D prop1.wav",
	"sounds/Hurricane star1.wav",
	"sounds/L5 flap.wav",
	"sounds/Sea King engn1.wav",
	"sounds/Sea King prop1.wav",
	"sounds/Sea King prop2.wav",
	"sounds/a.english.wav",
	"sounds/x.english.wav",
}


-- Create another Lua table to put some "sound handles" in.
-- These handles allow us to control which sound is playing, what the pitch is for a .wav file, etc.
-- Each sound you want to play requires it's own handle.
gizmo8Track_SoundTable = {
	sound.newSound(),
	sound.newSound(),
	sound.newSound(),
	sound.newSound(),
	sound.newSound(),
	sound.newSound(),
	sound.newSound(),
	sound.newSound(),
}


-- This function is called by Gizmo to create a new window and fill it with Widgets.
function gizmo8Track_OnCreate()
	
	local sw,sh = gfx.getScreenSize()
	local w = 755
	local h = 280
	
	local x = sw/2 - w/2
	local y = sh/2 - h/2


	gui.setWindowSize( gui_gizmo8Track, x, y, w, h )
	gui.setWindowCaption( gui_gizmo8Track, "Gizmo 8 Track - Alpha" )
	
	
	--We will now create 8 GUI "slots" to load and play our wav files.
	--[sound_name.wav ][load][play]
	
		--Call a sub-function for clarity and neatness.
		-- You can find this function somewhere near the bottom of this file.
		gizmo8Track_CreateSoundSlotWidgets()
	
	
	--now that we're dressed, show ourselves.
	gui.showWindow( gui_gizmo8Track ) 
	
end
gui_gizmo8Track = gui.newWindow("gizmo8Track")




function gizmo8Track_CreateCustomCommands()
	xp.newCommand("gizmo/8track/play_one", 		"Play slot One", "gizmo8Track_PlaySlot_A")
	xp.newCommand("gizmo/8track/play_two", 		"Play slot Two", "gizmo8Track_PlaySlot_B")
	xp.newCommand("gizmo/8track/play_three", 	"Play slot Three", "gizmo8Track_PlaySlot_C")
	xp.newCommand("gizmo/8track/play_four", 	"Play slot Four", "gizmo8Track_PlaySlot_D")
	
	xp.newCommand("gizmo/8track/play_five", 	"Play slot Five", "gizmo8Track_PlaySlot_E")
	xp.newCommand("gizmo/8track/play_six", 		"Play slot Six", "gizmo8Track_PlaySlot_F")
	xp.newCommand("gizmo/8track/play_seven", 	"Play slot Seven", "gizmo8Track_PlaySlot_G")
	xp.newCommand("gizmo/8track/play_eight", 	"Play slot Eight", "gizmo8Track_PlaySlot_H")
end

--Now we will prepare a batch of functions that will respond to the user when they start pressing their js button or hot key.
function gizmo8Track_PlaySlot_A_OnStart()
  --button or key was pressed
 sound.play( gizmo8Track_SoundTable[1] )
end

function gizmo8Track_PlaySlot_B_OnStart()
  --button or key was pressed
 sound.play( gizmo8Track_SoundTable[2] )
end

function gizmo8Track_PlaySlot_C_OnStart()
  --button or key was pressed
 sound.play( gizmo8Track_SoundTable[3] )
end

function gizmo8Track_PlaySlot_D_OnStart()
  --button or key was pressed
 sound.play( gizmo8Track_SoundTable[4] )
end


function gizmo8Track_PlaySlot_E_OnStart()
  --button or key was pressed
 sound.play( gizmo8Track_SoundTable[5] )
end

function gizmo8Track_PlaySlot_F_OnStart()
  --button or key was pressed
 sound.play( gizmo8Track_SoundTable[6] )
end

function gizmo8Track_PlaySlot_G_OnStart()
  --button or key was pressed
 sound.play( gizmo8Track_SoundTable[7] )
end

function gizmo8Track_PlaySlot_H_OnStart()
  --button or key was pressed
 sound.play( gizmo8Track_SoundTable[8] )
end


--[[
Now that we have prepare all the functions and commands we need to handle the
users hot keys we will call the function that registers all our custom commands.
We "defined" this function on line 32 of this file.
--]]
gizmo8Track_CreateCustomCommands()










--These have been moved to a sub-function for clarity and neatness.
-- This function creates all the GUI widgets that let the user type in the name of a .WAV file and load and test play it.
function gizmo8Track_CreateSoundSlotWidgets()
	
	local widget_vertical_location = 30
	local widget_vertical_spacing = 30

		gui_gizmo8Track_txtFile_A 			= gui.newTextBox( gui_gizmo8Track, 	"ignored", gizmo8Track_SoundTable_Filenames[1], 10, widget_vertical_location, 650 )
			gui_gizmo8Track_btnLoad_A 		= gui.newButton( gui_gizmo8Track, 	"gizmo8Track_btnLoad_A", "load", 670, widget_vertical_location, 30 )
			gui_gizmo8Track_btnPlay_A 		= gui.newButton( gui_gizmo8Track, 	"gizmo8Track_btnPlay_A", "play", 710, widget_vertical_location, 30 )
		
		widget_vertical_location = widget_vertical_location + widget_vertical_spacing
		
		
		gui_gizmo8Track_txtFile_B 			= gui.newTextBox( gui_gizmo8Track, 	"ignored", gizmo8Track_SoundTable_Filenames[2], 10, widget_vertical_location, 650 )
			gui_gizmo8Track_btnLoad_B 		= gui.newButton( gui_gizmo8Track, 	"gizmo8Track_btnLoad_B", "load", 670, widget_vertical_location, 30 )
			gui_gizmo8Track_btnPlay_B 		= gui.newButton( gui_gizmo8Track, 	"gizmo8Track_btnPlay_B", "play", 710, widget_vertical_location, 30 )
		
		widget_vertical_location = widget_vertical_location + widget_vertical_spacing
		
		
		gui_gizmo8Track_txtFile_C 			= gui.newTextBox( gui_gizmo8Track, 	"ignored", gizmo8Track_SoundTable_Filenames[3], 10, widget_vertical_location, 650 )
			gui_gizmo8Track_btnLoad_C 		= gui.newButton( gui_gizmo8Track, 	"gizmo8Track_btnLoad_C", "load", 670, widget_vertical_location, 30 )
			gui_gizmo8Track_btnPlay_C 		= gui.newButton( gui_gizmo8Track, 	"gizmo8Track_btnPlay_C", "play", 710, widget_vertical_location, 30 )
		
		widget_vertical_location = widget_vertical_location + widget_vertical_spacing
		
		
		gui_gizmo8Track_txtFile_D 			= gui.newTextBox( gui_gizmo8Track, 	"ignored", gizmo8Track_SoundTable_Filenames[4], 10, widget_vertical_location, 650 )
			gui_gizmo8Track_btnLoad_D 		= gui.newButton( gui_gizmo8Track, 	"gizmo8Track_btnLoad_D", "load", 670, widget_vertical_location, 30 )
			gui_gizmo8Track_btnPlay_D 		= gui.newButton( gui_gizmo8Track, 	"gizmo8Track_btnPlay_D", "play", 710, widget_vertical_location, 30 )
		
		widget_vertical_location = widget_vertical_location + widget_vertical_spacing
		
		
		gui_gizmo8Track_txtFile_E 			= gui.newTextBox( gui_gizmo8Track, 	"ignored", gizmo8Track_SoundTable_Filenames[5], 10, widget_vertical_location, 650 )
			gui_gizmo8Track_btnLoad_E 		= gui.newButton( gui_gizmo8Track, 	"gizmo8Track_btnLoad_E", "load", 670, widget_vertical_location, 30 )
			gui_gizmo8Track_btnPlay_E 		= gui.newButton( gui_gizmo8Track, 	"gizmo8Track_btnPlay_E", "play", 710, widget_vertical_location, 30 )
		
		widget_vertical_location = widget_vertical_location + widget_vertical_spacing
		
		
		gui_gizmo8Track_txtFile_F 			= gui.newTextBox( gui_gizmo8Track, 	"ignored", gizmo8Track_SoundTable_Filenames[6], 10, widget_vertical_location, 650 )
			gui_gizmo8Track_btnLoad_F 		= gui.newButton( gui_gizmo8Track, 	"gizmo8Track_btnLoad_F", "load", 670, widget_vertical_location, 30 )
			gui_gizmo8Track_btnPlay_F 		= gui.newButton( gui_gizmo8Track, 	"gizmo8Track_btnPlay_F", "play", 710, widget_vertical_location, 30 )
		
		widget_vertical_location = widget_vertical_location + widget_vertical_spacing
		
		
		gui_gizmo8Track_txtFile_G 			= gui.newTextBox( gui_gizmo8Track, 	"ignored", gizmo8Track_SoundTable_Filenames[7], 10, widget_vertical_location, 650 )
			gui_gizmo8Track_btnLoad_G 		= gui.newButton( gui_gizmo8Track, 	"gizmo8Track_btnLoad_G", "load", 670, widget_vertical_location, 30 )
			gui_gizmo8Track_btnPlay_G 		= gui.newButton( gui_gizmo8Track, 	"gizmo8Track_btnPlay_G", "play", 710, widget_vertical_location, 30 )
		
		widget_vertical_location = widget_vertical_location + widget_vertical_spacing
		
		
		gui_gizmo8Track_txtFile_H 			= gui.newTextBox( gui_gizmo8Track, 	"ignored", gizmo8Track_SoundTable_Filenames[8], 10, widget_vertical_location, 650 )
			gui_gizmo8Track_btnLoad_H 		= gui.newButton( gui_gizmo8Track, 	"gizmo8Track_btnLoad_H", "load", 670, widget_vertical_location, 30 )
			gui_gizmo8Track_btnPlay_H 		= gui.newButton( gui_gizmo8Track, 	"gizmo8Track_btnPlay_H", "play", 710, widget_vertical_location, 30 )

end







function gizmo8Track_btnLoad_A_OnClick()
	local sound_filename = xp.getAircraftFolder() .. gui.getWidgetValue( gui_gizmo8Track_txtFile_A )
	sound.say("Loading: " .. sound_filename )
	sound.load( gizmo8Track_SoundTable[1], sound_filename )
end
function gizmo8Track_btnPlay_A_OnClick()
	sound.play(gizmo8Track_SoundTable[1])
end


function gizmo8Track_btnLoad_B_OnClick()
	local sound_filename = xp.getAircraftFolder() .. gui.getWidgetValue( gui_gizmo8Track_txtFile_B )
	sound.say("Loading: " .. sound_filename )
	sound.load( gizmo8Track_SoundTable[2], sound_filename )
end
function gizmo8Track_btnPlay_B_OnClick()
	sound.play(gizmo8Track_SoundTable[2])
end


function gizmo8Track_btnLoad_C_OnClick()
	local sound_filename = xp.getAircraftFolder() .. gui.getWidgetValue( gui_gizmo8Track_txtFile_C )
	sound.say("Loading: " .. sound_filename )
	sound.load( gizmo8Track_SoundTable[3], sound_filename )
end
function gizmo8Track_btnPlay_C_OnClick()
	sound.play(gizmo8Track_SoundTable[3])
end


function gizmo8Track_btnLoad_D_OnClick()
	local sound_filename = xp.getAircraftFolder() .. gui.getWidgetValue( gui_gizmo8Track_txtFile_D )
	sound.say("Loading: " .. sound_filename )
	sound.load( gizmo8Track_SoundTable[4], sound_filename )
end
function gizmo8Track_btnPlay_D_OnClick()
	sound.play(gizmo8Track_SoundTable[4])
end






function gizmo8Track_btnLoad_E_OnClick()
	local sound_filename = xp.getAircraftFolder() .. gui.getWidgetValue( gui_gizmo8Track_txtFile_E )
	sound.say("Loading: " .. sound_filename )
	sound.load( gizmo8Track_SoundTable[5], sound_filename )
end
function gizmo8Track_btnPlay_E_OnClick()
	sound.play(gizmo8Track_SoundTable[5])
end


function gizmo8Track_btnLoad_F_OnClick()
	local sound_filename = xp.getAircraftFolder() .. gui.getWidgetValue( gui_gizmo8Track_txtFile_F )
	sound.say("Loading: " .. sound_filename )
	sound.load( gizmo8Track_SoundTable[6], sound_filename )
end
function gizmo8Track_btnPlay_F_OnClick()
	sound.play(gizmo8Track_SoundTable[6])
end

function gizmo8Track_btnLoad_G_OnClick()
	local sound_filename = xp.getAircraftFolder() .. gui.getWidgetValue( gui_gizmo8Track_txtFile_G )
	sound.say("Loading: " .. sound_filename )
	sound.load( gizmo8Track_SoundTable[7], sound_filename )
end
function gizmo8Track_btnPlay_G_OnClick()
	sound.play(gizmo8Track_SoundTable[7])
end


function gizmo8Track_btnLoad_H_OnClick()
	local sound_filename = xp.getAircraftFolder() .. gui.getWidgetValue( gui_gizmo8Track_txtFile_H )
	sound.say("Loading: " .. sound_filename )
	sound.load( gizmo8Track_SoundTable[8], sound_filename )
end
function gizmo8Track_btnPlay_H_OnClick()
	sound.play(gizmo8Track_SoundTable[8])
end






if( gizmo8Track_load_all_sounds_at_boot )then

	local sound_filename = ""

	sound_filename = xp.getAircraftFolder() .. gui.getWidgetValue( gui_gizmo8Track_txtFile_A )
	sound.load( gizmo8Track_SoundTable[1], sound_filename )

	sound_filename = xp.getAircraftFolder() .. gui.getWidgetValue( gui_gizmo8Track_txtFile_B )
	sound.load( gizmo8Track_SoundTable[2], sound_filename )

	sound_filename = xp.getAircraftFolder() .. gui.getWidgetValue( gui_gizmo8Track_txtFile_C )
	sound.load( gizmo8Track_SoundTable[3], sound_filename )
	
	sound_filename = xp.getAircraftFolder() .. gui.getWidgetValue( gui_gizmo8Track_txtFile_D )
	sound.load( gizmo8Track_SoundTable[4], sound_filename )

	sound_filename = xp.getAircraftFolder() .. gui.getWidgetValue( gui_gizmo8Track_txtFile_E )
	sound.load( gizmo8Track_SoundTable[5], sound_filename )

	sound_filename = xp.getAircraftFolder() .. gui.getWidgetValue( gui_gizmo8Track_txtFile_F )
	sound.load( gizmo8Track_SoundTable[6], sound_filename )

	sound_filename = xp.getAircraftFolder() .. gui.getWidgetValue( gui_gizmo8Track_txtFile_G )
	sound.load( gizmo8Track_SoundTable[7], sound_filename )

	sound_filename = xp.getAircraftFolder() .. gui.getWidgetValue( gui_gizmo8Track_txtFile_H )
	sound.load( gizmo8Track_SoundTable[8], sound_filename )

end


-- that's it, job's done.
