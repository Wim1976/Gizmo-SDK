--[[

Custom mouse cursor example.

When the mouse is in the top half of the window you should see a red circle as the mouse cursor.

--]]
function drawCursor()

	gl.PushMatrix()
		gl.Translate( mouse.x, mouse.y, 0 )
		
		gfx.texOff()
		gfx.setColor(1,0,0, 1)
		gfx.drawCircle( 20, 10 )
	
	
	gl.PopMatrix()
end



function main()
	if( mouse.y > 500 )then
		mouse.setCursor( "drawCursor" ) --custom cursor on
	else
		mouse.setCursor( "" ) --custom cursor off
	end
end