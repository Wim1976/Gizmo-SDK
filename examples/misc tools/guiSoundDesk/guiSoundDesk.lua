
function SoundDesk_OnCreate()
	
	local sw,sh = gfx.getScreenSize()
	local w = 808
	local h = 404
	
	local x = sw/2 - w/2
	local y = sh/2 - h/2


	gui.setWindowSize( gui_SoundDesk, x, y, w, h )
	gui.setWindowCaption( gui_SoundDesk, "Gizmo SoundDesk - Alpha" )
	
	local btn_x = 10
	local btn_w = 50
	
	gui.newButton( gui_SoundDesk, "gizmoSoundDesk_Load", 	"Load", 	btn_x, 30, btn_w); btn_x = btn_x + btn_w
	gui.newButton( gui_SoundDesk, "gizmoSoundDesk_Rewind", 	"Rewind", 	btn_x, 30, btn_w ); btn_x = btn_x + btn_w
	gui.newButton( gui_SoundDesk, "gizmoSoundDesk_Play", 	"Play", 	btn_x, 30, btn_w ); btn_x = btn_x + btn_w
	gui.newButton( gui_SoundDesk, "gizmoSoundDesk_Pause", 	"Pause", 	btn_x, 30, btn_w ); btn_x = btn_x + btn_w
	gui.newButton( gui_SoundDesk, "gizmoSoundDesk_Stop", 	"Stop", 	btn_x, 30, btn_w ); btn_x = btn_x + btn_w
	gui.newButton( gui_SoundDesk, "gizmoSoundDesk_Loop", 	"Loop", 	btn_x, 30, btn_w ); btn_x = btn_x + btn_w
	
	
	
	gui.newLabel(  gui_SoundDesk, "", 	"Gain Points:", 	10, 70, btn_w );
	gizmoSoundDesk_txtGainPoints = gui.newTextBox(  gui_SoundDesk, "", "{ 0.5, 1, 1.2, 1, 0.75, 0.5 }", 	80, 70, 400 );
	gui.newButton( gui_SoundDesk, "gizmoSoundDesk_GainPointsUpdate", 	"UPDATE", 	480, 70, btn_w );
	
	gui.newCustomWidget( gui_SoundDesk, "gizmoSoundDesk_GainBar",  10, 90, 788, 64 )
	
	
	
	gui.newLabel(  gui_SoundDesk, "", 	"Pitch Points:", 	10, 190, btn_w );
	gizmoSoundDesk_txtPitchPoints = gui.newTextBox(  gui_SoundDesk, "", "{ 1, 1.3, 1.2, 0.4, 0.3, 0.8, 1.7, 1.0 }", 	80, 190, 400 );
	gui.newButton( gui_SoundDesk, "gizmoSoundDesk_PitchPointsUpdate", 	"UPDATE", 	480, 190, btn_w );
	
	gui.newCustomWidget( gui_SoundDesk, "gizmoSoundDesk_PitchBendBar",  10, 210, 788, 64 )
	
	
	
	--now that we're dressed, show ourselves.
	gui.showWindow( gui_SoundDesk ) 
	
end
gui_SoundDesk = gui.newWindow("SoundDesk")



function gizmoSoundDesk_GainPointsUpdate_OnClick()

	local new_data = gui.getWidgetValue( gizmoSoundDesk_txtGainPoints )
	f = loadstring( "gizmoSoundDesk_GainData_Raw = " .. new_data )
	f()
	gizmoSoundDesk_GainData = interp( gizmoSoundDesk_GainData_Raw, 1, 788 )
	
end



function gizmoSoundDesk_PitchPointsUpdate_OnClick()

	local new_data = gui.getWidgetValue( gizmoSoundDesk_txtPitchPoints )
	f = loadstring( "gizmoSoundDesk_PitchData_Raw = " .. new_data )
	f()
	gizmoSoundDesk_PitchData = interp( gizmoSoundDesk_PitchData_Raw, 1, 788 )
	
end





function interp( inTable, freq, outSteps )

	inTable[#inTable] = inTable[#inTable] --extend the end item by one automatically. 

	sample_count = #inTable
	
	samplesPerStep = outSteps/sample_count

	ret = {}

	local step_x = 1
	for ix=1,#inTable-1 do
		local inc = 0
		--if( ix+1 <= #inTable )then
			inc = (inTable[ix+1] - inTable[ix]) / samplesPerStep
		--end
		local v = inTable[ix]
	
		for sx=1,samplesPerStep do
			ret[step_x] = v
			v = v + inc
			step_x = step_x + 1
		end
	end

	return ret

end

gizmoSoundDesk_PitchData_Raw = {1,1.3,1.2,0.4,0.3,0.8,1.7,1.0}
gizmoSoundDesk_PitchData = interp( gizmoSoundDesk_PitchData_Raw, 1, 788 )



gizmoSoundDesk_GainData_Raw = { 0.5, 1, 1.2, 1, 0.75, 0.5 }
gizmoSoundDesk_GainData = interp( gizmoSoundDesk_GainData_Raw, 1, 788 )







--this code handles advancing the scrubber bar
gizmoSoundDesk_ScrubberPosition = 0
gizmoSoundDesk_ScrubberPosition_Max = 21.0

gizmoSoundDesk_ScrubberPosition_Pitch = 0
gizmoSoundDesk_ScrubberPosition_Gain = 0

function timerScrubberAdvance()
	gizmoSoundDesk_ScrubberPosition = gizmoSoundDesk_ScrubberPosition + gfx.getFrameSpeed(1.0)
	
	if( gizmoSoundDesk_ScrubberPosition > gizmoSoundDesk_ScrubberPosition_Max )then
		gizmoSoundDesk_ScrubberPosition = 0 --LOOP
	end
	
	
	local scrubber_p = gizmoSoundDesk_ScrubberPosition/gizmoSoundDesk_ScrubberPosition_Max
	
	gizmoSoundDesk_ScrubberPosition_Pitch = gizmoSoundDesk_PitchData[ math.floor(scrubber_p*788) ]
	if( gizmoSoundDesk_ScrubberPosition_Pitch == nil )then
		gizmoSoundDesk_ScrubberPosition_Pitch = 1
	end
	sound.setPitch(  gizmoSoundDesk_Sounds[1],  gizmoSoundDesk_ScrubberPosition_Pitch)
	
	gizmoSoundDesk_ScrubberPosition_Gain = gizmoSoundDesk_GainData[ math.floor(scrubber_p*788) ]
	if( gizmoSoundDesk_ScrubberPosition_Gain == nil )then
		gizmoSoundDesk_ScrubberPosition_Gain = 1
	end
	sound.setGain(  gizmoSoundDesk_Sounds[1],  gizmoSoundDesk_ScrubberPosition_Gain)
	
end
timer.newTimer("timerScrubberAdvance",-1.0)






--this function draws our custom pitch bend bar data.
function gizmoSoundDesk_PitchBendBar_OnDraw()
	gizmoSoundDesk_DrawDataBlock( gizmoSoundDesk_PitchData, "Pitch", {0.75, 0, 0, 1} )
end








--this function draws our custom pitch bend bar data.
function gizmoSoundDesk_GainBar_OnDraw()
	gizmoSoundDesk_DrawDataBlock( gizmoSoundDesk_GainData, "Gain", {0, 0.75, 0, 1} )
end





function gizmoSoundDesk_DrawDataBlock( data, label, color )
	local w,h = gui.getCustomWidgetSize()
	
	gfx.setState(
			0, --fog
			0, --tex units
			0, --lighting
			1, --alpha test
			1, --alpha blend
			0, --depth test
			0  --depth write
		)
	
	--draw widget background
	gfx.setColor( 0.122, 0.239, 0.388, 1 )
	gfx.drawFilledBox(0,0,w,h)
	
	--set dark green pen
	gfx.setColor( color[1], color[2], color[3], color[4] )
	--gfx.setColor(0,0.75,0,1)
	
	--draw our data samples
	local step = 1
	for i=1,#data do
		local v = data[i]
		v = v / 2
		gfx.drawFilledBox(step*1, 0, 1, v*h )
		step = step + 1
	end
	
	--switch to black pen
	gfx.setColor(1,1,1,0.5) --black
	
	--Mid line grid lines, no work :(
	gfx.drawLine(0,32, w,32)
	
	--todo; change to drawline? --2verts instead
	gfx.drawFilledBox( (gizmoSoundDesk_ScrubberPosition/gizmoSoundDesk_ScrubberPosition_Max)*w,0, 2,h )
	
	
	--draw a black border around the widget
	gfx.drawBox(0,0, w,h)
	
	--draw a text label for the widget in the top right hand corner
	gfx.drawString(label,w-40,52)
	gfx.drawString( string.format("%0.3f", gizmoSoundDesk_ScrubberPosition_Gain), w-40, 40 )
	
end








gizmoSoundDesk_Sounds = { sound.newSound() } --create a table of sounds
gizmoSoundDesk_LoopFlags = { 1 }

function gizmoSoundDesk_Load_OnClick()
	
	local file = xp.getAircraftFolder() .. "sounds/beefcake.wav"
	sound.say("loading sound: " .. file)
	
	sound.load( gizmoSoundDesk_Sounds[1], file )
	
end


function gizmoSoundDesk_Play_OnClick()
	sound.play( gizmoSoundDesk_Sounds[1] )
end

function gizmoSoundDesk_Stop_OnClick()
	sound.stop( gizmoSoundDesk_Sounds[1] )
end


function gizmoSoundDesk_Loop_OnClick()
	if( gizmoSoundDesk_LoopFlags[1] == 1 )then
		sound.setLoop(  gizmoSoundDesk_Sounds[1], 0 )
		gizmoSoundDesk_LoopFlags[1] = 0
	else
		sound.setLoop(  gizmoSoundDesk_Sounds[1], 1 )
		gizmoSoundDesk_LoopFlags[1] = 1
	end
end










