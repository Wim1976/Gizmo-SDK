

function TexPaint_OnCreate()
	local w,h = gfx.getScreenSize()

	gui.setWindowSize( gui_TexPaint, w - 400, 100, 350, 400 )
	gui.setWindowCaption( gui_TexPaint, "TexPaint - Browser" )
	
	gui.newButton( gui_TexPaint, "btnTexPrev", "<<<", 10, 30, 50 )
	gui.newButton( gui_TexPaint, "btnTexNext", ">>>", 290, 30, 50 )
	
	txtTexPaint_JumpTo_Id = gui.newTextBox( gui_TexPaint, "ignored", "42", 70, 30, 50 )
	gui.newButton( gui_TexPaint, "btnTexJump", "Jump", 120, 30, 50 )
	
	
	gui.newButton( gui_TexPaint, "btnLock", "LOCK", 180, 30, 30 )
	gui.newButton( gui_TexPaint, "btnBake", "BAKE", 210, 30, 40 )
	gui.newButton( gui_TexPaint, "btnReset", "RST", 250, 30, 30 )
	
	
	local cgwh = 74+(64*4)
	
	gui.newCustomWidget( gui_TexPaint, "thumbBackground",  10, 59+cgwh, (64*5)+10, 74+cgwh )
	
	--bang out a grid of custom widgets using a for loop....
		local hx=0 --how many cells accross
		local rx=1 --which row are we upto
		local thumb_x=1 --which thumbnail are we upto
		for thumb_x=1,25 do
			tmpName = string.format( "thumb%02i", thumb_x )
			gui.newCustomWidget( gui_TexPaint, tmpName, 15+(hx*64), (64*rx),  64,64  )
			hx = hx + 1
			if( hx >= 5 )then
				--if we have 5 horizontal items move to the next row
				rx = rx + 1
				hx = 0
			end
		end

	--now that we're dressed, show ourselves.
	gui.showWindow( gui_TexPaint ) 
	
end
gui_TexPaint = gui.newWindow("TexPaint")




function TexPaintInspector_OnCreate()
	local w,h = gfx.getScreenSize()
	
	gui.setWindowSize( gui_TexPaintInspector, w-950, 100, 542, 562 )
	gui.setWindowCaption( gui_TexPaintInspector, "TexPaint - Inspector" )
	--gui.hideWindow( gui_TexPaintInspector ) 
	
	gui.newCustomWidget( gui_TexPaintInspector, "textureZoom",  10, 30, 522, 522 )

	gui.showWindow( gui_TexPaintInspector ) 
	
end
gui_TexPaintInspector = gui.newWindow("TexPaintInspector")







function drawThumb( target_tex )
	
	--Turn texturing on
	gfx.setState(
			0, --fog
			1, --tex units
			0, --lighting
			1, --alpha test
			1, --alpha blend
			0, --depth test
			0  --depth write
		);
	
	
	local w,h = gui.getCustomWidgetSize()
	
		gfx.useTexture( target_tex );
		gl.Color( 1, 1, 1, 1 );
		
	    gl.Begin('QUADS');
		    gl.TexCoord( 0, 0 ); gl.Vertex( 0, 0, 0 );
		    gl.TexCoord( 0, 1 ); gl.Vertex( 0, h, 0 );
		    gl.TexCoord( 1, 1 ); gl.Vertex( w, h, 0 );
		    gl.TexCoord( 1, 0 ); gl.Vertex( w, 0, 0 );
	    gl.End();
	
	
	gfx.setState(
			0, --fog
			0, --tex units
			0, --lighting
			1, --alpha test
			1, --alpha blend
			0, --depth test
			0  --depth write
		);
	
	if( target_tex == inspector_texture_number )then
		gfx.setColor(1,0,0,  1)
	
	else
		gfx.setColor(0.5,0.5,0.5,  0.5)
	end
	gfx.drawBox(0,0,w,h)
	
	gfx.drawString(target_tex,5,5)
	
end






function thumbBackground_OnDraw()	
	local w,h = gui.getCustomWidgetSize()
		gfx.setState(
			0, --fog
			0, --tex units
			0, --lighting
			1, --alpha test
			1, --alpha blend
			0, --depth test
			0  --depth write
		);
	gl.Color( 1, 1, 1, 1 ); --light-gray
	gfx.drawFilledBox( 0,0, w,-h )
	
	
end




function textureZoom_OnMouseDown()
	return 1 --ask x-plane for more mouse data as its available.
end

gizmoTexPaint_MouseData = {}

function textureZoom_OnMouseDrag()
	
	local l,b = gui.getCustomWidgetPosition()
	local w,h = gui.getCustomWidgetSize()
	
	local rel_mx = mouse.x - l
	local rel_my = mouse.y - b
	if( rel_mx < w and rel_mx > 0 )then
		if( rel_my < h and rel_my > 0)then
			--sound.say( rel_mx .. " / " .. rel_my )
			
			gizmoTexPaint_MouseData[ #gizmoTexPaint_MouseData+1 ] = {rel_mx, rel_my}
			
		end
	end
	
	btnBake_OnClick()
	
end



function textureZoom_OnDraw()
			--turn texturing back on
		gfx.setState(
			0, --fog
			0, --tex units
			0, --lighting
			1, --alpha test
			1, --alpha blend
			0, --depth test
			0  --depth write
		);
		
	local w,h = gui.getCustomWidgetSize()
	gfx.setColor(1,1,1, 1 )
	gfx.drawFilledBox( 0,0, w,h )
	
	gfx.setColor(0,0,0, 1 )
	gfx.drawBox( 0,0, w,h )
	
		gl.PushMatrix()
			gl.Translate( 5, 5, 0 )
			drawTex()
			
		gl.PopMatrix()
end


function incTex( amount )
	texture_number = texture_number + amount
end
function decTex( amount )
	texture_number = texture_number - amount
end


texture_number = gfx.getTexture_UI()
inspector_texture_number = texture_number


function setInspectorTexture( tex_id )
	inspector_texture_number = tex_id
end





function btnTexPrev_OnClick()
	decTex( 24 )
end
function btnTexNext_OnClick()
	incTex( 24 )
end



function btnTexJump_OnClick()
	texture_number = gui.getWidgetValue( txtTexPaint_JumpTo_Id ) * 1
	setInspectorTexture( texture_number )
end







function btnLock_OnClick()
	--if( fbo_h == nil )then
		fbo_h = gfx.newFBO( inspector_texture_number, 1024, 1024 )
		sound.say("Lock")
	
	--else
	--	sound.say("FAIL")
		
	--end
end




function btnReset_OnClick()
		
	gizmoTexPaint_MouseData = {}
	
end




function btnBake_OnClick()
	if( fbo_h ~= nil )then
		gfx.useFBO(fbo_h)
		
			gfx.setState(
				0, --fog
				0, --tex units
				0, --lighting
				1, --alpha test
				1, --alpha blend
				0, --depth test
				0  --depth write
			);
	
			gfx.setColor(1,0,0,1)
			gl.LineWidth(2)
			
				for i=1,#gizmoTexPaint_MouseData-1 do
					local start = gizmoTexPaint_MouseData[i]
					local stop = gizmoTexPaint_MouseData[i+1]
					
					local x = (start[1])
					local y = (start[2])
					
					local a = (stop[1])
					local b = (stop[2])
					
					
					gfx.drawLine(  x,y, a,b )
				end
				
			gl.LineWidth(1)
		
		gfx.releaseFBO( fbo_h ) --helps?
	else
		
		sound.say("No lock.")
		
	end
end






function drawTex()
	
    --gl.BindTexture( "TEXTURE_2D", texture )
    local y_rat = 1.0
    
    gl.PushMatrix()
		
		--turn texturing back on
		gfx.setState(
			0, --fog
			1, --tex units
			0, --lighting
			1, --alpha test
			1, --alpha blend
			0, --depth test
			0  --depth write
		);
		
		--tell open GL to use the map texture
		gfx.useTexture( inspector_texture_number );
	
		gl.Color( 1, 1, 1, 1 ); --light-gray
		
		--use some OpenGL drawing to draw a textured square on the panel with our map on it!
	    gl.Begin('QUADS');
		    gl.TexCoord( 0, 0 ); gl.Vertex( 0, 0, 0 );
		    gl.TexCoord( 0, 1 ); gl.Vertex( 0, 512, 0 );
		    gl.TexCoord( 1, 1 ); gl.Vertex( 512, 512, 0 );
		    gl.TexCoord( 1, 0 ); gl.Vertex( 512, 0, 0 );
	    gl.End();
	    
    
	gl.PopMatrix()
    --end of map section
	
	--[[
	
	gfx.setState(
			0, --fog
			0, --tex units
			0, --lighting
			1, --alpha test
			1, --alpha blend
			0, --depth test
			0  --depth write
		);

		gfx.setColor(1,0,0,1)
		gl.LineWidth(2)
		
			for i=1,#gizmoTexPaint_MouseData-1 do
				local start = gizmoTexPaint_MouseData[i]
				local stop = gizmoTexPaint_MouseData[i+1]
				gfx.drawLine(  start[1],start[2], stop[1],stop[2] )
			end
			
		gl.LineWidth(1)
		
	--]]

end




















function thumb01_OnDraw()	
	drawThumb( texture_number )
end
function thumb02_OnDraw()	
	drawThumb( texture_number + 1 )
end
function thumb03_OnDraw()	
	drawThumb( texture_number + 2 )
end
function thumb04_OnDraw()	
	drawThumb( texture_number + 3 )
end
function thumb05_OnDraw()	
	drawThumb( texture_number + 4 )
end


function thumb06_OnDraw()	
	drawThumb( texture_number + 6 )
end
function thumb07_OnDraw()	
	drawThumb( texture_number + 7 )
end
function thumb08_OnDraw()	
	drawThumb( texture_number + 8 )
end
function thumb09_OnDraw()	
	drawThumb( texture_number + 9 )
end
function thumb10_OnDraw()	
	drawThumb( texture_number + 10 )
end


function thumb11_OnDraw()	
	drawThumb( texture_number + 11 )
end
function thumb12_OnDraw()	
	drawThumb( texture_number + 12 )
end
function thumb13_OnDraw()	
	drawThumb( texture_number + 13 )
end
function thumb14_OnDraw()	
	drawThumb( texture_number + 14 )
end
function thumb15_OnDraw()	
	drawThumb( texture_number + 15 )
end



function thumb16_OnDraw()	
	drawThumb( texture_number + 16 )
end
function thumb17_OnDraw()	
	drawThumb( texture_number + 17 )
end
function thumb18_OnDraw()	
	drawThumb( texture_number + 18 )
end
function thumb19_OnDraw()	
	drawThumb( texture_number + 19 )
end
function thumb20_OnDraw()	
	drawThumb( texture_number + 20 )
end



function thumb21_OnDraw()	
	drawThumb( texture_number + 21 )
end
function thumb22_OnDraw()	
	drawThumb( texture_number + 22 )
end
function thumb23_OnDraw()	
	drawThumb( texture_number + 23 )
end
function thumb24_OnDraw()	
	drawThumb( texture_number + 24 )
end
function thumb25_OnDraw()	
	drawThumb( texture_number + 25 )
end



------ mouse functions ------

function thumb01_OnMouseDown()	
	setInspectorTexture( texture_number )
end
function thumb02_OnMouseDown()	
	setInspectorTexture( texture_number + 1 )
end
function thumb03_OnMouseDown()	
	setInspectorTexture( texture_number + 2 )
end
function thumb04_OnMouseDown()	
	setInspectorTexture( texture_number + 3 )
end
function thumb05_OnMouseDown()	
	setInspectorTexture( texture_number + 4 )
end


function thumb06_OnMouseDown()	
	setInspectorTexture( texture_number + 6 )
end
function thumb07_OnMouseDown()	
	setInspectorTexture( texture_number + 7 )
end
function thumb08_OnMouseDown()	
	setInspectorTexture( texture_number + 8 )
end
function thumb09_OnMouseDown()	
	setInspectorTexture( texture_number + 9 )
end
function thumb10_OnMouseDown()	
	setInspectorTexture( texture_number + 10 )
end


function thumb11_OnMouseDown()	
	setInspectorTexture( texture_number + 11 )
end
function thumb12_OnMouseDown()	
	setInspectorTexture( texture_number + 12 )
end
function thumb13_OnMouseDown()	
	setInspectorTexture( texture_number + 13 )
end
function thumb14_OnMouseDown()	
	setInspectorTexture( texture_number + 14 )
end
function thumb15_OnMouseDown()	
	setInspectorTexture( texture_number + 15 )
end



function thumb16_OnMouseDown()	
	setInspectorTexture( texture_number + 16 )
end
function thumb17_OnMouseDown()	
	setInspectorTexture( texture_number + 17 )
end
function thumb18_OnMouseDown()	
	setInspectorTexture( texture_number + 18 )
end
function thumb19_OnMouseDown()	
	setInspectorTexture( texture_number + 19 )
end
function thumb20_OnMouseDown()	
	setInspectorTexture( texture_number + 20 )
end



function thumb21_OnMouseDown()	
	setInspectorTexture( texture_number + 21 )
end
function thumb22_OnMouseDown()	
	setInspectorTexture( texture_number + 22 )
end
function thumb23_OnMouseDown()	
	setInspectorTexture( texture_number + 23 )
end
function thumb24_OnMouseDown()	
	setInspectorTexture( texture_number + 24 )
end
function thumb25_OnMouseDown()	
	setInspectorTexture( texture_number + 25 )
end




