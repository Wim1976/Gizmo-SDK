


--dofile("gizmo_firmware_GizmoXPilotChat.lua")





last_mx = -1
last_my = -1

--drag_in_progress = false




FilterBar = {

	height=20,
	b_width=150,

	buttons = {
			{
				name="source: fc.pitch()",
				color={1,0,0},
				run=function(self, x,y )
					local tmp_filter = FilterFactory:newYokePitchGenerator()
					
					tmp_filter.left = x + (tmp_filter.width * 2) + (50 * math.random())
					tmp_filter.bottom = y + ((tmp_filter.height * 2) + 50 * math.random() )
					
					AddRegion( tmp_filter )
					AddFilter( tmp_filter )
				end
			},
			{
				name="source: fc.roll()",
				color={1,0,0},
				run=function(self, x,y )
					local tmp_filter = FilterFactory:newYokeRollGenerator()
					
					tmp_filter.left = x + (tmp_filter.width * 2) + (50 * math.random())
					tmp_filter.bottom = y + ((tmp_filter.height * 2) + 50 * math.random() )
					
					AddRegion( tmp_filter )
					AddFilter( tmp_filter )
				end
			},
			{
				name="source: function()",
				color={1,0,0},
				run=function(self, x,y )
					local tmp_filter = FilterFactory:newSinFilter()
					
					tmp_filter.left = x + (tmp_filter.width * 2) + (50 * math.random())
					tmp_filter.bottom = y + ((tmp_filter.height * 2) + 50 * math.random() )
					
					AddRegion( tmp_filter )
					AddFilter( tmp_filter )
				end
			},
			{
				name="source: dataref",
				color={1,0,0},
				run=function(self, x,y )
					local tmp_filter = FilterFactory:newSinFilter()
					
					tmp_filter.left = x + (tmp_filter.width * 2) + (50 * math.random())
					tmp_filter.bottom = y + ((tmp_filter.height * 2) + 50 * math.random() )
					
					AddRegion( tmp_filter )
					AddFilter( tmp_filter )
				end
			},
			{
				name="source: time elapsed",
				color={1,0,0},
				run=function(self, x,y )
					local tmp_filter = FilterFactory:newSimTimeGenerator()
					
					tmp_filter.left = x + (tmp_filter.width * 2) + (50 * math.random())
					tmp_filter.bottom = y + ((tmp_filter.height * 2) + 50 * math.random() )
					
					AddRegion( tmp_filter )
					AddFilter( tmp_filter )
				end
			},
			
			--filters--
			{
				name="filter: absolute(v)",
				color={0,0.75,0},
				run=function(self, x,y )
					local tmp_filter = FilterFactory:newOptimistFilter()
					
					tmp_filter.left = x + (tmp_filter.width * 2) + (50 * math.random())
					tmp_filter.bottom = y + ((tmp_filter.height * 2) + 50 * math.random() )
					
					Regions[ #Regions+1 ] = tmp_filter
				end
			},
			{
				name="filter: -absolute(v)",
				color={0,0.75,0},
				run=function(self, x,y )
					local tmp_filter = FilterFactory:newPessimistFilter()
					
					tmp_filter.left = x + (tmp_filter.width * 2) + (50 * math.random())
					tmp_filter.bottom = y + ((tmp_filter.height * 2) + 50 * math.random() )
					
					Regions[ #Regions+1 ] = tmp_filter
				end
			},	
			{
				name="filter: average(v)",
				color={0,0.75,0},
				run=function(self, x,y )
					local tmp_filter = FilterFactory:newAverageFilter()
					
					tmp_filter.left = x + (tmp_filter.width * 2) + (50 * math.random())
					tmp_filter.bottom = y + ((tmp_filter.height * 2) + 50 * math.random() )
					
					Regions[ #Regions+1 ] = tmp_filter
				end
			},
			{
				name="filter: delay(v)",
				color={0,0.75,0},
				run=function(self, x,y )
					local tmp_filter = FilterFactory:newDelayFilter()
					
					tmp_filter.left = x + (tmp_filter.width * 2) + (50 * math.random())
					tmp_filter.bottom = y + ((tmp_filter.height * 2) + 50 * math.random() )
					
					Regions[ #Regions+1 ] = tmp_filter
				end
			},			
			{
				name="filter: inverse(v)",
				color={0,0.75,0},
				run=function(self, x,y )
					local tmp_filter = FilterFactory:newInverseFilter()
					
					tmp_filter.left = x + (tmp_filter.width * 2) + (50 * math.random())
					tmp_filter.bottom = y + ((tmp_filter.height * 2) + 50 * math.random() )
					
					Regions[ #Regions+1 ] = tmp_filter
				end
			},
			{
				name="filter: random(v)",
				color={0,0.75,0},
				run=function(self, x,y )
					local tmp_filter = FilterFactory:newRandomFilter()
					
					tmp_filter.left = x + (tmp_filter.width * 2) + (50 * math.random())
					tmp_filter.bottom = y + ((tmp_filter.height * 2) + 50 * math.random() )
					
					Regions[ #Regions+1 ] = tmp_filter
				end
			},
			{
				name="filter: sin(v)",
				color={0,0.75,0},
				run=function(self, x,y )
					local tmp_filter = FilterFactory:newSinFilter()
					
					tmp_filter.left = x + (tmp_filter.width * 2) + (50 * math.random())
					tmp_filter.bottom = y + ((tmp_filter.height * 2) + 50 * math.random() )
					
					Regions[ #Regions+1 ] = tmp_filter
				end
			},
			{
				name="filter: time_average(v)",
				color={0,0.75,0},
				run=function(self, x,y )
					local tmp_filter = FilterFactory:newTimeAverageFilter()
					
					tmp_filter.left = x + (tmp_filter.width * 2) + (50 * math.random())
					tmp_filter.bottom = y + ((tmp_filter.height * 2) + 50 * math.random() )
					
					Regions[ #Regions+1 ] = tmp_filter
				end
			},
			
			
			
			
			{
				name="out: graph scope",
				color={0.5,0.5,0.75},
				run=function(self)
					local tmp_graph = FilterFactory:newGrapherOutput()
					tmp_graph.half_shift = true
					tmp_graph.scale = 50
					AddRegion( tmp_graph )
					AddFilter( tmp_graph )
				end
			},
			{
				name="out: dataref",
				color={0.5,0.5,0.75},
				run=function(self) sound.say("new src!") end
			},
			{
				name="out: function",
				color={0.5,0.5,0.75},
				run=function(self) sound.say("new src!") end
			},

		},






	clickTest = function(self)
		local w,h = gfx.getScreenSize()
		
		local cx = 50
		local cy = #self.buttons * 22
		
			for i=1,#self.buttons do

				local hit = PointCollisionTest:testQuad( cx,cy, self.b_width,self.height, mouse.x,mouse.y )
				if( hit )then
					--gizmo.reboot()
					
					self.buttons[i]:run( cx, cy )
					
					return 1
				end
				cy = cy - 22
				--cx = cx + 120
			end			
	end,



	draw = function(self)
		local w,h = gfx.getScreenSize()
		
		local cx = 50
		local cy = #self.buttons * 22
		
		
		gl.PushMatrix()
			for i=1,#self.buttons do
				gfx.texOff()

				gfx.setColor(0.15,0.15,0.15, 0.95)
				gfx.drawFilledBox( cx-30,cy, self.b_width, self.height )

				gfx.setColor(1,1,1, 1)

				local hit = PointCollisionTest:testQuad( cx,cy, self.b_width,self.height, mouse.x,mouse.y )
				if( hit )then
					gfx.setColor(1,1,0.25, 1)
				end

				gfx.drawBox( cx-30,cy, self.b_width, self.height )
				
				gfx.setColor( self.buttons[i].color[1],self.buttons[i].color[2],self.buttons[i].color[3], 1 )
				gfx.drawString( self.buttons[i].name, cx-20,cy+7 )
				cy = cy - 22
				--cx = cx + 120
			end
			
		gl.PopMatrix()
	end,
}





FilterFactory = {
	new = function(self)
	
		local ret = {
		
			left = 50,
			bottom = 50,
					
			width = 64,
			height = 32,
			
			input_value = 0,
			output_value = 0,
			
			name = "undefined",
			type = "default",
			
			label = "hungry",
			
			parents = {},
			need_parents = 1,
			
			line_color = {
					math.random() + 0.1,
					math.random() + 0.1,
					math.random() + 0.1
						},
			
			
			outputs = {},
		
		
			draw = function(self)
				gl.PushMatrix()
					gl.Translate( self.left, self.bottom, 0 )
					
					gfx.texOff()
					
					
					if( self.type == "source" )then
						gfx.setColor( 0.35,0.15,0.15, 1 )
					elseif( self.type == "filter" )then
						gfx.setColor( 0.15,0.35,0.15, 1 )
					elseif( self.type == "output" )then
						gfx.setColor( 0.15,0.15,0.35, 1 )
					else
						gfx.setColor(0.15,0.15,0.15, 0.95)
					end
					
					gfx.drawFilledBox( 0,0, self.width,self.height )

					local click_within_bounds = PointCollisionTest:testQuad( self.left,self.bottom, self.width,self.height, mouse.x,mouse.y )
					
					if( click_within_bounds )then
						gfx.setColor(1,0.5,0,1)
					else
						gfx.setColor( self.line_color[1],self.line_color[2],self.line_color[3], 1 )
					end
					
					gl.LineWidth(2)
					gfx.drawBox(0,0, self.width,self.height)
					gl.LineWidth(1)
					
						--gfx.setColor( self.line_color[1],self.line_color[2],self.line_color[3], 1 )
						for i=1,#self.outputs do
							gfx.drawLine( self.width,0, self.outputs[i].left-self.left, self.outputs[i].bottom-self.bottom + self.outputs[i].height )
						end
					
					
					if( self.type ~= "source" )then
					gl.PushMatrix()
						--input handle
						gl.Translate(2.5,self.height-2.5,0)
						--if( self.parents[1] )then
						--	gfx.setColor( self.parents[1].line_color[1],self.parents[1].line_color[2],self.parents[1].line_color[3], 0.5 )
						--	gfx.drawFilledCircle(5,10)
						--else
							gfx.drawFilledCircle(5,10)
						--end
					gl.PopMatrix()
					end
					gl.PushMatrix()
						--output handle
						gfx.setColor( self.line_color[1],self.line_color[2],self.line_color[3], 0.5 )
						gl.Translate(self.width-2.5,2.5,0)
						gfx.drawFilledCircle(5,10)

					gl.PopMatrix()
						
					
					
					--draw the text last because it turns the textures back on.
					gfx.setColor( 1,1,1, 1 )
					gfx.drawString( self.name, 3,20 )
					--if( self.output_value )then
						--local sv = 
						gfx.drawString( self.label, 3,5 )
					--end
					
					
				gl.PopMatrix()
			end,
		
		
			setInput = function(self, value)
					self.input_value = value
			end,
			
			
			setName = function(self,new_name)
				self.width = gfx.measureString(new_name) + 10
				if( self.width < 75 )then
					self.width = 75
				end
				self.name = new_name
			end,
		
		
			run = function(self)
					self:run_core()
					
					if( self.need_parents <= #self.parents )then					
						for i=1,#self.outputs do
							self.outputs[i]:setInput( self.output_value )
							self.outputs[i]:run()
						end
						
						self.label = string.format( "%0.3f", self.output_value )
						
					else
						self.label = "hungry"
					end
			end,
		
		
			run_core = function(self)
				local sum = 0
				for i=1,#self.parents do
					sum = sum + self.parents[i].output_value
				end
			
				self.output_value = sum / #self.parents --pass through directly.
			end,
			
			
			register = function(self, h)
				self.outputs[ #self.outputs + 1 ] = h
				h.parents[ #h.parents + 1 ] = self
			end,
			
			deregister = function(self, h)
				for i=1,#self.outputs do
					if( self.outputs[i] == h )then
						table.remove( self.outputs, i )
					end
				end			
			end,
			
			
			handleMouseClicks = function(self)
					
					local click_within_bounds = PointCollisionTest:testQuad( self.left,self.bottom, self.width,self.height, mouse.click.x,mouse.click.y )
					
					if( click_within_bounds or self.drag_in_progress )then
						active_region = self
					
						if( last_mx == -1 )then
							last_mx = mouse.click.x
							last_my = mouse.click.y
						end
					
						--test to see if the user is dragging
						if( mouse.click.e == 2 )then
				
							
							self.drag_in_progress = true
							
							--lets look for corner clicks
							local bottom_right_hande_clicked = PointCollisionTest:testQuad( self.left+(self.width-5),self.bottom, 5,5, mouse.click.x,mouse.click.y )
							local top_left_hande_clicked = PointCollisionTest:testQuad( self.left,self.bottom+(self.height-5), 5,5, mouse.click.x,mouse.click.y )
							
							
							
							if( bottom_right_hande_clicked )then
								self.drawing_line = true
							elseif( top_left_hande_clicked )then
								--self.drawing_line = true							
								
								local removals = {}
								for ip=1,#self.parents do
									self.parents[ip]:deregister( self )
									removals[ #removals+1 ] = ip
								end
								for x=1,#removals do
									table.remove( self.parents, removals[x] )
								end
								
								
								self.drag_in_progress = nil --cancel mouse capture of the window
								active_region = nil

								
							end
									--calculate the mouse movement deltas and apply them to our origin point
									
							
									--the user is mouse dragging inside our bounds.
									if( self.drawing_line )then
									
										--this code will keep drawing the line even after the user has left the original test boundary.
									
											gfx.texOff()
											--gfx.setColor(1,1,1, 1)
											gl.LineWidth(3)
											--gfx.setColor( self.line_color[1],self.line_color[2],self.line_color[3], 1 )
											gfx.setColor( 1,0,0, 1 )
											gfx.drawLine( self.left+self.width, self.bottom,  mouse.x, mouse.y )
											gl.LineWidth(1)
										
					
									else
							
										if( mouse.click.x ~= last_mx )then
											local mxd = mouse.click.x - last_mx
											self.left = self.left + mxd
										end
										
										if( mouse.click.y ~= last_my )then
											local myd = mouse.click.y - last_my
											self.bottom = self.bottom + myd
										end
										
										
										--store the last known mouse location 
										last_mx = mouse.click.x
										last_my = mouse.click.y
										
									end
							
							
							
							
						else
							self.drag_in_progress = false
							if( mouse.click.e == 3 )then
								active_region = nil
								
								if( self.drawing_line )then
									
									--look to see if we have a drog target, if yes, connect!
									for i=1,#Regions do
										local rg = Regions[i]
										
										local drop_target_found = PointCollisionTest:testQuad( rg.left,rg.bottom, rg.width,rg.height, mouse.click.x,mouse.click.y )
										if( drop_target_found )then
											self:register( rg )
											--sound.say("registered!")
											i = #Regions --break out
										end
									end
									
									self.drawing_line = nil
								end
		
								--mouse was released, reset vars
								last_mx = -1
								last_my = -1
							end
						end
						
						return 1
				
					end		
			end,
			
		
		} --end ret table
		
		return ret
	
	end, --end plain new function
	
	
	
	






	--- source ----
	
	newSimTimeGenerator = function(self)
		local ret = self:new()
		ret.need_parents = 0
		ret.type = "source"
		ret:setName("src: sim time")
		ret.run_core = function(self)
			self.output_value = xp.getElapsedTime()
		end
		
		return ret
	end,
	


	newYokePitchGenerator = function(self)
		local ret = self:new()
		ret.need_parents = 0
		ret.type = "source"
		ret:setName("src: fc.pitch")
		ret.run_core = function(self)
			self.output_value = acf.getYokePitch()
		end
		
		return ret
	end,

	newYokeRollGenerator = function(self)
		local ret = self:new()
		ret.need_parents = 0
		ret.type = "source"
		ret:setName("src: fc.roll")
		ret.run_core = function(self)
			self.output_value = acf.getYokeRoll()
		end
		
		return ret
	end,
	




	newIASGenerator = function(self)
		local ret = self:new()
		ret.need_parents = 0
		ret.type = "source"
		ret:setName("src: ias")
		ret.run_core = function(self)
			self.output_value = acf.getIAS()
		end
		
		return ret
	end,
	





	--- filters ----
	
	newAverageFilter = function(self)
		local ret = self:new()
		ret.need_parents = 2
		ret.type = "filter"
		ret:setName("avg.filter")
				
		return ret
	end,
	
	newTimeAverageFilter = function(self)
		local ret = self:new()
		ret.type = "filter"
		ret:setName("time-avg.filter")
		ret.run_core = function(self)
			if( self.log_data )then
				self.log_data[ #self.log_data + 1 ] = self.input_value
				
				local sum = 0
				if( #self.log_data > 100 )then
					table.remove( self.log_data, 1 )
				end
				
				for i=1,#self.log_data do
					sum = sum + self.log_data[i]
				end
				
				self.output_value = sum/#self.log_data
				return
			else
				self.log_data = {}
				self.log_data[ #self.log_data + 1 ] = self.input_value
				
			end
			self.output_value = self.input_value --no valid data pool yet, just pass input for a bit.
			return
		end
		
		return ret
	end,

	newDelayFilter = function(self)
		local ret = self:new()
		ret.type = "filter"
		ret:setName("delay()")
		ret.run_core = function(self)
			if( self.log_data )then
				self.log_data[ #self.log_data + 1 ] = self.input_value
				
				if( #self.log_data > 200 )then
					self.output_value = self.log_data[1]
					table.remove( self.log_data, 1 )
					return
				end
			else
				self.log_data = {}
				self.log_data[ #self.log_data + 1 ] = self.input_value
				
			end
			self.output_value = self.input_value
			return
		end
		
		return ret
	end,
		
	newSinFilter = function(self)
		local ret = self:new()
		ret.type = "filter"
		ret:setName("sin()")
		ret.run_core = function(self)
			self.output_value = math.sin( self.input_value )
		end
		
		return ret
	end,
	
	newRandomFilter = function(self)
		local ret = self:new()
		ret.type = "filter"
		ret:setName("random()")
		ret.run_core = function(self)
			self.output_value = math.random() * self.input_value
		end
		
		return ret
	end,


	newOptimistFilter = function(self)
		local ret = self:new()
		ret.type = "filter"
		ret:setName("abs()")
		ret.run_core = function(self)
			if( self.input_value < 0 )then
				self.output_value = self.input_value * -1
			else
				self.output_value = self.input_value
			end
		end
		
		return ret
	end,

	newPessimistFilter = function(self)
		local ret = self:new()
		ret.type = "filter"
		ret:setName("-abs()")
		ret.run_core = function(self)
			if( self.input_value > 0 )then
				self.output_value = self.input_value * -1
			else
				self.output_value = self.input_value
			end
		end
		
		return ret
	end,

	
	newInverseFilter = function(self)
		local ret = self:new()
		ret.type = "filter"
		ret:setName("invert()")
		ret.run_core = function(self)
			self.output_value = -1 * self.input_value
		end
		
		return ret
	end,
	
	
	
	
	-- outputs --
	
	newGrapherOutput = function(self)
		local ret = self:new()
		ret.type = "output"
		ret:setName("grapher")
		
		ret.left = 800
		ret.bottom = 400
		ret.width = 200
		ret.height = 100
		ret.scale = 1
		
		ret.half_shift = false
		
		ret.scale = 1
		
		ret.data = {}
		
		ret.run_core = function(self)
			self.data[ #self.data + 1 ] = self.input_value
			if( #self.data > self.width )then
				table.remove( self.data, 1 )
			end
			--self.output_value = -1 * self.input_value  ------ we dont do output to this value.
		end
		

		ret.draw = function(self)
				-- [[	
				gl.PushMatrix()
					gl.Translate( self.left, self.bottom, 0 )
				
					gfx.texOff()
						gfx.setColor(0.25,0.25,0.25, 0.25)
						gfx.drawFilledBox(0,0,self.width,self.height)
						
						gfx.setColor(1,0.25,0.25, 1)
						gfx.drawBox(0,0,self.width,self.height)
	
						--draw the log data
						gl.PushMatrix()
							if( self.half_shift )then
								gl.Translate(0, self.height/2, 0)					
							end
								for i=1,#self.data do
									if( self.parent )then
										gfx.setColor( self.parent.line_color[1],self.parent.line_color[2],self.parent.line_color[3], 0.5 )
									else
										gfx.setColor(0,0.75,0, 1) --green
									end
									local v = self.data[i]*self.scale
									if( v > 100 )then
										v = 100
										gfx.setColor(1,0.75,0, 1) --orange - clipped
									end
									gfx.drawLine(i,0, i,v)
								end
						gl.PopMatrix()
						
					gl.PushMatrix()
						--input handle
						gl.Translate(0,self.height,0)
						if( self.parent )then
							gfx.setColor( self.parent.line_color[1],self.parent.line_color[2],self.parent.line_color[3], 1 )
							gfx.drawFilledCircle(3,10)
						else
							gfx.drawFilledCircle(3,10)
						end
					gl.PopMatrix()
					
					
				gl.PopMatrix()	
				--]]
			end
			
		
		return ret
	end,
	
	
}




FilterChains = {}
function AddFilter( newFilter )
	FilterChains[ #FilterChains+1 ] = newFilter
end


active_region = nil

Regions = {}
function AddRegion( newRegion )
	Regions[ #Regions+1 ] = newRegion
end




local sw,sh = gfx.getScreenSize()
local lx = 50
local ly = sh - 50
--[[
-- this code can be use to auto-layout the tree in a crap way
for i=1,#Regions do
	
	lx = lx + 50
	if( Regions[i].type == "generator" )then
		lx = 10
	end
	
	
	Regions[i].left = lx
	Regions[i].bottom = ly

	
	if( Regions[i].outputs )then
		if( #Regions[i].outputs > 0 )then
			ly = ly - 50
		end
	else
		--ly = ly - 5
	end
	
end
--]]	
	
	
	







function OnMouseClick()


	if( active_region )then
		ret = active_region:handleMouseClicks()
		return ret
	else

		if( FilterBar:clickTest() )then
			return 0 -- avoid drag interference.
		end
		
	
		for i=1,#Regions do
			local rg = Regions[i]
			ret = rg:handleMouseClicks()
			if( ret == 1 )then 
				return ret
			end
		end

	end
end





function OnDraw_Windows()

	for i=1,#FilterChains do
		FilterChains[i]:run()
	end


	local w,h = gfx.getScreenSize()
	
	gfx.texOff()
	gfx.setColor(0,0,0, 0.5)
	
	--gfx.drawFilledBox( 0,0, w,h )  -- <------- blank out the x-plane screen.
	
		gl.PushMatrix()
			for i=1,#Regions do
				Regions[i]:draw()
			end
		gl.PopMatrix()
		
		
		
	FilterBar:draw()
		
			
	--gizmo.sleep(50)

end






