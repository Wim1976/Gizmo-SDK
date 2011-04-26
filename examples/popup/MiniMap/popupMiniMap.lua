

popupMiniMap_visible = true

map_texture = gfx.newTexture()

gfx.setTerrainMapMode_Topographic()


--setup a new timer to update the map 10 times per second
timer.newTimer( "update_map", 0.1 )

menu.newItem("Mini Map", "mnuTogglePopupMiniMap")


function update_map()
    speed = acf.getIAS() -- get speed in meters per second
    if( speed < 10 )then
      speed = 10
    elseif( speed > 1000 )then
      speed = 1000
    end
    
    gfx.setTerrainMapOption_Range( speed ) --map will now zoom with speed
    gfx.bakeTerrainMap( map_texture )

end


	


--this function will run when the user clicks the "Toggle Popup" menu item.
function mnuTogglePopupMiniMap_OnClick()

	--all we have to do here is switch the value from on to off   or   off to on.

	if( popupMiniMap_visible )then
		popupMiniMap_visible = false
	else
		popupMiniMap_visible = true
	end

end




--setup some values to define how big our popup will be.
popupMiniMap_coords = {

	top = 150,
	left = 50,
	width = 200,
	height = 128,
	
	testClick = function( self, x, y )
		if(
			( x > self.left) and ( x < (self.left + self.width))
			and
			( y < self.top) and ( y > (self.top - self.height))
		  )then
			return true
			
		else
			return false
		end
	end
}

sw,sh = gfx.getScreenSize()
popupMiniMap_coords.left = sw - (popupMiniMap_coords.width * 2)
popupMiniMap_coords.top = sh - (popupMiniMap_coords.height)


function OnDraw_Windows()

	local w,h = gfx.getScreenSize()
	local pc = popupMiniMap_coords --grab a local reference for a fraction more speed, and shorthand

	if( popupMiniMap_visible )then
		gfx.texOff()
		gfx.setColor(1,0,0,1)
		
		--draw a box, coordinates are left, top, width, height
		gfx.drawBox(  pc.left, pc.top-pc.height,  pc.width, pc.height  )
		
		gfx.setColor(0,0.5,0,0.5)
		gfx.drawFilledBox(  pc.left+128, pc.top-pc.height,  pc.width-128, pc.height  )
		
		--draw the SDK box
		--gfx.drawTranslucentDarkBox(  pc.left, pc.top,  pc.width, pc.height  )
	
		--draw the rest of the gauge here.
		
		gl.PushMatrix()
			gl.Translate( pc.left, pc.top-pc.height, 0 )
			
				gfx.setColor( 1,1,1,1 )
				local fix = string.format("%0.2f/%0.2f", acf.getLat(), acf.getLon())
				gfx.drawString( fix, 130, 100 )

				local alt = string.format("alt: %0.1f", acf.getAltAgl() )
				gfx.drawString( alt, 130, 85 )


				local kias = string.format("ias: %0.2f", acf.getIAS() * 1.94384449 )
				gfx.drawString( kias, 130, 70 )


				gfx.texOn()
				
				gfx.useTexture( map_texture )
				
				gl.Color( 0.75, 0.75, 0.75,   0.75 ) --gray, 75% opaque
				
				gl.Begin('QUADS')
					gl.TexCoord(0,1); gl.Vertex(0,0,0)
					gl.TexCoord(0,0); gl.Vertex(0,128,0)
					gl.TexCoord(1,0); gl.Vertex(128,128,0)
					gl.TexCoord(1,1); gl.Vertex(128,0,0)
				gl.End()
		gl.PopMatrix()
	
	end

end


last_mx = -1
last_my = -1

drag_in_progress = false

function OnMouseClick()
 
	--sound.say("click: " .. mouse.click.x .. " / " .. mouse.click.y .. " / " .. mouse.click.e )
	
	--sound.say( popupMiniMap_coords:testClick(mouse.click.x,mouse.click.y) )
	--events; 1 = Down 2 = Drag 3 = Up
	

	
	if( popupMiniMap_coords:testClick(mouse.click.x,mouse.click.y)  or  drag_in_progress  )then
		if( last_mx == -1 )then
			last_mx = mouse.click.x
			last_my = mouse.click.y
		end
	
		--sound.say("eat click" .. mouse.click.e)
		
		--test to see if the user is dragging
		if( mouse.click.e == 2 )then
			drag_in_progress = true
			
			--the user is mouse dragging inside our bounds.
			
			--calculate the mouse movement deltas and apply them to our origin point
			
			if( mouse.click.x ~= last_mx )then
				local mxd = mouse.click.x - last_mx
				popupMiniMap_coords.left = popupMiniMap_coords.left + mxd
			end
			
			if( mouse.click.y ~= last_my )then
				local myd = mouse.click.y - last_my
				popupMiniMap_coords.top = popupMiniMap_coords.top + myd
			end
			
			
			--store the last known mouse location 
			last_mx = mouse.click.x
			last_my = mouse.click.y
			
		else
			drag_in_progress = false
			if( mouse.click.e == 3 )then
				--mouse was released, reset vars
				last_mx = -1
				last_my = -1
			end
		end
		
		return 1
	else
		--sound.say("ignore click")
	end
 
end

--init_popups()


--[[
--Seem to use this alot for drawing vector graphics, should add an api call.
gfx.texOff = function()
	 gfx.setState(
			0, --fog off
			0, --1 tex unit
			0, --no lighting
			1, --alpha test on
			1, --alpha blend on
			0, --depth test off
			0 --depth write off
			)
end


gfx.texOn = function()
     gfx.setState(
            0, --fog off
            1, --1 tex unit
            0, --no lighting
            1, --alpha test on
            1, --alpha blend on
            0, --depth test off
            0 --depth write off
            )
end
--]]