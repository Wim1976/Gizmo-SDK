
if( xpl_button ~= nil )then xpl_button = nil end


xpl_button = {
	id = 'x-plugins.widgets.button',
	
	left=250, top=150,
	width=128, height=64,
	
	value='button value',
	
	texture_id=0,
	
	--color = {
	--		current = {r=0.0, g=0.0, b=0.0, a=0.75},
	--		idle  = { r=0.5, g=0, b=0, a=0.5 },
	--		hover = { r=1, g=0, b=0, a=1 },
	--		click = { r=0, g=1, b=0, a=1 }
	--		},
		
	border = {
		color = {
			current = {r=0.75, g=0.75, b=0.75, a=0.75},
			idle  = { r=0.5, g=0, b=0, a=0.5 },
			hover = { r=1, g=0, b=0, a=1 },
			click = { r=0, g=1, b=0, a=1 }
			},
		width = 5
	},
	
	draggable = false, --enable/disable draggability.
	dragging = false,

	drag_delta_top = -1,
	drag_delta_left = -1,
	

	new = function( self, o )
		o = o or {} --create object if none provided.
		setmetatable( o, self )
		self.__index = self
		
		
		
		
			self.color = {
			current = {r=0.0, g=0.0, b=0.0, a=0.75},
			idle  = { r=0.5, g=0, b=0, a=0.5 },
			hover = { r=1, g=0, b=0, a=1 },
			click = { r=0, g=1, b=0, a=1 }
			}
		
		
		
		return o
	end,


	
	onMouseClick = function(self)
		if( self:mouse_bounds_test() or self.dragging )then
			if( mouse.click.e == 1 )then
				self.drag_delta_top = (screen.h - mouse.click.y) - self.top
				self.drag_delta_left = mouse.click.x - self.left
				self:click()
			elseif( mouse.click.e == 2 )then
				self:drag()
			elseif( mouse.click.e == 3 )then
				self.drag_delta_top = -1
				self.drag_delta_left = -1
				self.dragging = false
				--self:mouseUp()
			end
			
			return 1
			--self.border.color = self.border.color_hover
		else
			return 0
		end
	end,
	
	
	mouse_bounds_test = function(self)
		local ret = false
		
			screen.w,screen.h = gfx.getScreenSize()
			mouse.x,mouse.y = mouse.getXY()
			
			if( (mouse.x > self.left) and (mouse.x < (self.left + self.width)) )then
				
				local my_screen_y_top = screen.h - self.top
				local my_screen_y_bot = (screen.h - self.top)-self.height
			
				if( (mouse.y > my_screen_y_bot) and (mouse.y < my_screen_y_top) )then
					ret = true
				end
			end
		
		return ret

	end,
	

	click = function(self)
		sound.say( self.id .. ':clicky:' .. mouse.click.e)
	end,
	
	
	drag = function(self)
		if( self.draggable )then
			self.dragging = true
			
			self.left = mouse.click.x - self.drag_delta_left
			self.top = (screen.h - mouse.click.y) - self.drag_delta_top
		
			--sound.say( self.id .. ':draggy:' .. mouse.click.e)
			--
			--if( self.drag_start_x == -1 )then
			--	self.drag_start_x = mouse.click.x
			--	self.drag_start_y = mouse.click.y
			--end
			--
			--if( self.drag_start_x ~= mouse.click.x )then
			--	self.left = mouse.click.x - (self.width/2)
			--	self.top = (screen.h - mouse.click.y) - (self.height/2)
			--end
			
		end
	end,
	
	
	draw_bg = function(self)
		gfx.setColor( self.color.current.r, self.color.current.g, self.color.current.b, self.color.current.a )
		gfx.drawQuad( self.left, (screen.h - self.top)-self.height, self.width, self.height )
	end,
		
	
	draw_border = function(self)
		gfx.setColor( self.border.color.current.r, self.border.color.current.g, self.border.color.current.b, self.border.color.current.a )
		gl.LineWidth( self.border.width )
		
			--top line
			gfx.drawLine( self.left, screen.h - self.top,     self.left+self.width+1, (screen.h - self.top) )
			--bottom line
			gfx.drawLine( self.left, (screen.h - self.top)-self.height,     self.left+self.width+1, (screen.h - self.top)-self.height )
		
			--left line
			gfx.drawLine( self.left, screen.h - self.top,     self.left, (screen.h - self.top)-self.height )
			--right line
			gfx.drawLine( self.left+self.width+1, screen.h - self.top,     self.left+self.width+1, (screen.h - self.top)-self.height )


		gl.LineWidth(1)
	
	end,

	
	draw_caption = function(self)
		s_len = gfx.measureString( self.value )	
		gfx.drawString(self.value, (self.left + (self.width/2))-(s_len/2), (screen.h - self.top) - ((self.height/2)+5))
	end,
	
	
	draw = function(self)
		
		gfx.setState(
					0, --fog
					0, --tex units
					0, --lighting
					1, --alpha test
					1, --alpha blend
					0, --depth test
					0  --depth write
				);
	
		
		self.border.color.current = self.border.color.idle
		
				screen.w,screen.h = gfx.getScreenSize()
				mouse.x,mouse.y = mouse.getXY()
				
				
				if( self:mouse_bounds_test() )then
					if( mouse.click.e ~= 3 )then
						self.border.color.current = self.border.color.click
					else
						self.border.color.current = self.border.color.hover
					end
				end
			
			self:draw_bg()
			self:draw_border()
			self:draw_caption()
		
	end,
	
	
}


if( screen == nil )then screen = {} end