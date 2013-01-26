







-- Queue management classes.

--Basically only differ in what core functions run.

--Draw Q
draw_q = {
	
	children = {},
	
	--basic constructor; adapted from here: http://www.lua.org/pil/16.1.html
	new = function( self, o )
		o = o or {} --create object if none provided.
		setmetatable( o, self )
		self.__index = self
		return o
	end,
	
	register = function(self, new_plugin)
		
		--alert('reg:' .. new_plugin.id)
		
		--clean
		local found = 0
		
		for k,v in ipairs( self.children )do
			if( v.id ~= nil )then
				if( v.id == new_plugin.id )then
					found = 1
					self.children[k] = new_plugin
					
				end
			end
		end
		
		--insert
		if( found == 0 )then
			table.insert( self.children, new_plugin )
		end
	
	end,
	
	
	draw = function(self)
		local i = 0
		local imax = #self.children
		
		--if( i == 0 )then return end
		
		--draw in reverse order, matches mouse click logic better, among other things
		for i = imax,1,-1 do
			v = self.children[i]
			if( v ~= nil )then
				v.draw( v )
			end
		end

	end,
	
	
	debug = function(self)
		
		
		gfx.setColor( 0, 0, 1, 0 )
		
		local y = 600
		local x = 20
		gfx.drawString( "draw q:" .. #self.children, x, y ); y = y - 15
		
		
		for k,v in ipairs( self.children )do
			
				gfx.drawString( " id: " .. v.id, x, y )
				y = y - 15
			
		end
		
		gfx.drawString( "fin", x, y ); y = y - 15
		
		if( mouse_click_plugins ~= nil )then
			mouse_click_plugins.y = y - 15
		end

	end

}










particle_update_q = {
	
	children = {},
	
	--basic constructor; adapted from here: http://www.lua.org/pil/16.1.html
	new = function( self, o )
		o = o or {} --create object if none provided.
		setmetatable( o, self )
		self.__index = self
		return o
	end,
	
	register = function(self, new_plugin)
		
		--alert('reg:' .. new_plugin.id)
		
		--clean
		local found = 0
		
		for k,v in ipairs( self.children )do
			if( v.id ~= nil )then
				if( v.id == new_plugin.id )then
					found = 1
					self.children[k] = new_plugin
					
				end
			end
		end
		
		--insert
		if( found == 0 )then
			table.insert( self.children, new_plugin )
		end
	
	end,
	
	
	update = function(self)
		local i = 0
		local imax = #self.children
		
		--if( i == 0 )then return end
		
		x,y,z,p,r,h = gfx.getAircraftPositionGL()
		
		--draw in reverse order, matches mouse click logic better, among other things
		for i = imax,1,-1 do
			v = self.children[i]
			if( v ~= nil )then
				--v.draw( v )
				
				particles.setZeroPointForNew( v,  x, y, z )
				
			end
		end

	end,
	
	
	debug = function(self)
		
		
		gfx.setColor( 0, 0, 1, 0 )
		
		local y = 600
		local x = 20
		gfx.drawString( "particles q:" .. #self.children, x, y ); y = y - 15
		
		
		for k,v in ipairs( self.children )do
			
				gfx.drawString( " id: " .. v.id, x, y )
				y = y - 15
			
		end
		
		gfx.drawString( "fin", x, y ); y = y - 15
		
		if( mouse_click_plugins ~= nil )then
			mouse_click_plugins.y = y - 15
		end

	end

}


















-- Mouse Click Q
click_q = {
	
	children = {},
	
	--basic constructor; adapted from here: http://www.lua.org/pil/16.1.html
	new = function( self, o )
		o = o or {} --create object if none provided.
		setmetatable( o, self )
		self.__index = self
		return o
	end,
	
	register = function(self, new_plugin)
		
		--alert('reg:' .. new_plugin.id)
		
		local found = 0
		--clean
		for k,v in ipairs( self.children )do
			if( v.id ~= nil )then
				if( v.id == new_plugin.id )then
					found = 1
					self.children[k] = new_plugin
					--sound.say("cull:".. v.id)
				end
			end
		end
		
		--insert
		if( found == 0)then
			table.insert( self.children, new_plugin )
		end
	
	end,
	
	
	onMouseClick = function(self)
		local ret = 0
		
		
		--first pass, for draggables, if a segment is dragging it should have first dibs on mouse action
		for k,v in ipairs( self.children )do
			if( v.dragging ~= nil )then
				if( v.dragging )then
					ret = v:onMouseClick()
					if( ret == 1 )then
						return ret
					end
				end
			end
		end
		
		--scan normal buttons
		for k,v in ipairs( self.children )do
			ret = v:onMouseClick()
			if( ret == 1 )then
				return ret
			end
		end
		
		
		return ret
		
	end,
	
	y = 300,
	debug = function(self)
		local x = 20
		gfx.drawString( "click q:" .. #self.children, x, self.y ); self.y = self.y - 15
		for k,v in ipairs( self.children )do
			--if( v.id ~= nil )then
				gfx.drawString( " id: " .. v.id, x, self.y )
				self.y = self.y - 15
			--end
		end
		gfx.drawString( "fin", x, self.y ); self.y = self.y - 15
		
		self.y = 300 --reset

	end


}






