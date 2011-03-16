
xplugins_example_mouse_trails = {
	
	id='x-plugins.example.mouse-trails',
	
	
	x = 100,
	y = 500,
	dy = 100,
	dx = 100,
	
	last_fix = { x=0, y=0 },
	
	
	--basic constructor; adapted from here: http://www.lua.org/pil/16.1.html
	new = function( self, o )
		o = o or {} --create object if none provided.
		setmetatable( o, self )
		self.__index = self
		return o
	end,
	
	draw=function(self)
	
			tlx = 0
			tly = 0
			
			gl.Enable('LINE_SMOOTH');
			gl.LineWidth( 3 )
			
						gfx.setState(
										0, --fog
										0, --tex units
										0, --lighting
										1, --alpha test
										1, --alpha blend
										0, --depth test
										0  --depth write
									);
			for k,v in ipairs( mouse_history )do
			
				--gl.LineWidth( 10 * v.a )
				
				if( tlx == 0 )then
					tlx = v.x
					tly = v.y
				end
			
				--start red and fade out to blue
				--gfx.setColor( 1-(1-v.a), 0, 1-v.a, v.a*4 )
				
				--start green and fade out to red
				gfx.setColor( 0.75-v.a, 1-(1-v.a), 0, v.a*4 )
				
				
				gfx.drawLine( tlx, tly, v.x, v.y )
				
				v.a = v.a - (0.1 * xp.fps_m)
				
				tlx = v.x
				tly = v.y
				
				
				--squiggle = true
				if( squiggle ~= nil )then
					if( math.random(10) > 5 )then
						v.x = v.x - (math.random(200) * xp.fps_m)
					else
						v.x = v.x + (math.random(200) * xp.fps_m)
					end
					
					
					if( math.random(10) > 5 )then
						v.y = v.y - (math.random(200) * xp.fps_m)
					else
						v.y = v.y + (math.random(200) * xp.fps_m)
					end
				end
				
				
				--v.y = v.y - (v.vy * xp.fps_m)
				--v.vy = v.vy + 0.5
				--v.vy = math.random(100)
				
				
			end
			gl.LineWidth( 1 )
			gfx.setColor( 1, 1, 1, 1 )	
		
	end
}


if( window_plugins ~= nil )then
	window_plugins:register( xplugins_example_mouse_trails )
end
