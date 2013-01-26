
if( xplugins_example_bouncy_sprite ~= nil )then
	xplugins_example_bouncy_sprite = nil
end

if( xplugins_example_bouncy ~= nil )then
	xplugins_example_bouncy = nil
end



xplugins_example_bouncy_sprite = {
	
	id='x-plugins.example.bouncy.sprite',
	
	x = 100,
	y = 500,
	dy = 100,
	dx = 100,
	
	bounce=0.9,
	
	max_x,max_y = gfx.getScreenSize(),
	
	last_fix = { x=0, y=0 },
	
	
	--basic constructor; adapted from here: http://www.lua.org/pil/16.1.html
	new = function( self, o )
		o = o or {} --create object if none provided.
		setmetatable( o, self )
		self.__index = self
		return o
	end,
	
	draw=function(self)
		
		self.y = self.y + (self.dy * xp.fps_m)
		self.x = self.x + (self.dx * xp.fps_m)
		
			self.draw_sprite( self )
		
		self.last_fix.x = self.x
		self.last_fix.y = self.y
		
		
		--[[
		if( self.dx > 0 )then
			self.dx = self.dx - (10 * xp.fps_m)
		end
		if( self.dy > 0 )then
			self.dy = self.dy - (10 * xp.fps_m)
		end
		if( self.y > 0 )then self.dy = self.dy - (9.8 * xp.fps_m) end
		--]]
		
		
		screen.w,screen.h = gfx.getScreenSize()
		
		if( self.x >= (screen.w-50) )then
			self.dx = (self.dx * -1) * self.bounce
			self.x = self.x - 2
		end
		if( self.x <= 50 )then
			self.dx = (self.dx * -1) * self.bounce
			self.x = self.x + 2
		end
		
		if( self.y >= (screen.h-50) )then
			self.dy = (self.dy * -1) * self.bounce
			self.y = self.y - 2;
		end
		if( self.y <= 50 )then
			self.dy = (self.dy * -1) * self.bounce
			self.y = self.y + 2;
		end
		
	end,
	
	
	
	sprite_color = { r=1, g=0, b=0, a=1 },
	
	draw_sprite = function(self)
	
		
		--gfx.drawBox( self.x-50, self.y+50, 100, 100 )
		--gfx.drawString("gizmO", self.x, self.y-25)
		--gfx.drawString("<3", self.x, self.y-25)
		-- [[
		gfx.setState(
								0, --fog
								0, --tex units
								0, --lighting
								1, --alpha test
								1, --alpha blend
								0, --depth test
								0  --depth write
							);
		--]]
		
		gl.PushMatrix()
			gl.Translate( self.x, self.y, 0 )
			
			--[[
			--gl.Color( 1, 0, 0, 1 );
			if( drm.getRegistered() == 1 )then
				if( drm.getLifeRemaining() > 120 )then
					gl.Color( 0, 1, 0, 1 );
				else
					gl.Color( 1, 1, 0, 1 );
				end
				
			else
				gl.Color( self.sprite_color.r, self.sprite_color.g, self.sprite_color.b, self.sprite_color.a );
			end
			--]]
			gl.Color( 0, 0, 1, 0.5 );
			gfx.drawCircle( 50, 20 );
			--gl.Color( 1, 0, 0, 1 );
			--gfx.drawCircle( 48, 20 );
		
			--gfx.drawQuad( 10, 20 );
		
		gl.PopMatrix()
	
	
	end
	
}





xplugins_example_bouncy = {

	id='x-plugins.example.bouncy',

	sprites = {},


	--basic constructor; adapted from here: http://www.lua.org/pil/16.1.html
	new = function( self, o )
		o = o or {} --create object if none provided.
		setmetatable( o, self )
		self.__index = self
		return o
	end,
	

	draw = function(self)
		--sound.say('yay')
		for k,v in ipairs( self.sprites )do
			v:draw()
		end
	end,
	
	
	populate = function(self)
		for i = 1,1000 do
			local new_sprite = xplugins_example_bouncy_sprite:new({
																x=math.random(1000),
																y=math.random(600),
																dx=math.random(200),
																dy=math.random(200)
																})
			table.insert( self.sprites, new_sprite )
			new_sprite = nil
		end
		
		
	end
	
}
xplugins_example_bouncy:populate()


window_plugins:register( xplugins_example_bouncy )