--[[

This scripts demonstrates loading and drawing some objects from inside X-Planes resource folders.

The gfx.loadObject API will change soon. This example will need to be updated.
2010-11-20

-]]


object_folder = "/Resources/default scenery/sim objects/dynamic/"
object_names = {
	"deer_doe.obj",
	"deer_buck.obj",
	"Nimitz.obj",
}


--this code will break shortly, but fun for now.
objects = {
	deer_doe = gfx.loadObject( object_folder .. object_names[1] ),
	deer_buck = gfx.loadObject( object_folder .. object_names[2] ),
	
	nimitz = gfx.loadObject( object_folder .. object_names[3] ),
}


offset_y = {
	100,
	200,
	300,
	400,
	500,
}

offset_y_speed = {
	30,
	40,
	50,
	40,
	30,
}


local pm = 0
local rm = 0
local hm = 0

function OnDraw_World()

	local x,y,z,p,r,h = gfx.getAircraftPositionGL()
		
	gfx.drawObjectGL( objects.nimitz, x+50, y+offset_y[1],z, p+pm,r+rm,h+hm )
	gfx.drawObjectGL( objects.nimitz, x+250,y+offset_y[2],z, p+pm*1.2,r+rm*1.3,h+hm*1.4 )
	gfx.drawObjectGL( objects.nimitz, x+450,y+offset_y[3],z, p+pm*1.4,r+rm*1.1,h+hm*1.6 )
	gfx.drawObjectGL( objects.nimitz, x+650,y+offset_y[4],z, p+pm*1.2,r+rm*1.3,h+hm*1.4 )
	gfx.drawObjectGL( objects.nimitz, x+850,y+offset_y[5],z, p,r,h )
	
	pm = pm + gfx.getFrameSpeed( 10 )
	rm = rm + gfx.getFrameSpeed( 20 )	
	hm = hm + gfx.getFrameSpeed( 5 )
	
	
	--this is the loop that creates the movement of the objects up and down.
	for i=1,5 do
		if( offset_y[i] < 0 )then
			offset_y_speed[i] = offset_y_speed[i] * -1
		elseif( offset_y[i] > 500 )then
			offset_y_speed[i] = offset_y_speed[i] * -1
		end
		
		local frame_movement = gfx.getFrameSpeed( offset_y_speed[i] )	
		offset_y[i] = offset_y[i] + frame_movement
		
	end

end
