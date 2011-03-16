xplugins_example_fire__fire_sprite = {
	
	id='x-plugins.example.fire.sprite',
	
	
	a = 1,
	vx = 1,
	vy = -1,
	x = 0,
	y = 0,
	
	size = 50,
	decay = 10,

	--basic constructor; adapted from here: http://www.lua.org/pil/16.1.html
	new = function( self, o )
		o = o or {} --create object if none provided.
		setmetatable( o, self )
		self.__index = self
		return o
	end,
	
	
	draw = function( self )
	
		--gfx.drawBox( self.x-(self.size/2) + (math.random()*10), self.y+(self.size/2) + (math.random()*10), self.size, self.size )
		gfx.drawBox( self.x-(self.size/2), self.y+(self.size/2), self.size, self.size )
		self.x = self.x + (self.vx * xp.fps_m)
		self.y = self.y + (self.vy * xp.fps_m)
		self.size = self.size - self.decay * xp.fps_m;
		if( self.size <= 0 )then self.size = 0 end
	
	end
	
}



xplugins_example_fire = {
	
	id='x-plugins.example.fire',
	
	sprites = {
		xplugins_example_fire__fire_sprite:new( {vx=math.random(100), vy=math.random(100)}),
		xplugins_example_fire__fire_sprite:new( {vx=math.random(100), vy=math.random(100)}),
		xplugins_example_fire__fire_sprite:new( {vx=math.random(100), vy=math.random(100)}),
		xplugins_example_fire__fire_sprite:new( {vx=math.random(100), vy=math.random(100)}),
		xplugins_example_fire__fire_sprite:new( {vx=math.random(100), vy=math.random(100)}),
		xplugins_example_fire__fire_sprite:new( {vx=math.random(100), vy=math.random(100)}),
		xplugins_example_fire__fire_sprite:new( {vx=math.random(100), vy=math.random(100)}),
		xplugins_example_fire__fire_sprite:new( {vx=math.random(100), vy=math.random(100)}),
		xplugins_example_fire__fire_sprite:new( {vx=math.random(100), vy=math.random(100)}),
		xplugins_example_fire__fire_sprite:new( {vx=math.random(100), vy=math.random(100)})
		},
	
	last_x = 0,
	last_y = 0,
	
	
	onMouseClick = function(self)
		--sound.say("fire click plugin")
		self.origin = mouse.click
		return 0
	end,
	
	
	draw = function(self)
	
		--gfx.drawBox( fire.x-25, fire.y+25, 50, 50 )
		update = 0;
		
		if( self.last_x ~= self.origin.x )then self.last_x = self.origin.x; update = 1; end
		if( self.last_y ~= self.origin.y )then self.last_y = self.origin.y; update = 1; end
		
		
		for k,v in ipairs( self.sprites ) do
		
			if( update == 1 )then
				v.vx = math.random(100)
				v.vy = math.random(100)
				r = math.random( 10 )
				if( r > 5 )then
					v.vx = -1 * math.random( 100 )				
				end
				r = math.random( 10 )
				if( r > 5 )then
					v.vy = -1 * math.random( 100 )				
				end
				v.size = math.random(150)
				v.decay = math.random(100)
				v.x = self.origin.x + math.random(150)
				v.y = self.origin.y + math.random(150)
			end
			
			if( v.size > 0 )then
				v:draw()
			end
			
		end
		
		
	
	end

}
--]]



if( window_plugins ~= nil )then
	window_plugins:register( xplugins_example_fire )
end





if( mouse_click_plugins ~= nil )then
	mouse_click_plugins:register( xplugins_example_fire )
end