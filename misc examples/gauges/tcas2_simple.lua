
-- TCAS 2 Gauge, (C) 2009, Ben Russell - br@x-plugins.com
	


xplugins_gauges_tcas2 = {
	
	id='x-plugins.gauges.tcas2',
	
	
	init = function(self)
			
			self.gfx_path = xp.getAircraftFolder() .. "graphics/tcas2/";
				--gauge background?
			
			self.dref_vertSpeed = xp.getDataref("sim/cockpit2/gauges/indicators/vvi_fpm_pilot");
			
			--self.dref_ai_	= xp.getDataref("sim/multiplayer/")
		
		
		--How big is the gauge in pixels..
			self.gauge_size = 200;
			self.gauge_half = self.gauge_size / 2;
	
	end,
	
	
	init_sound = function(self)
		--[[
			snd_path = xp.getAircraftFolder() .. "sounds/tcas2/";
				snd_traffic 				= sound.getSoundSlot();
				snd_climb					= sound.getSoundSlot();
				snd_descend				= sound.getSoundSlot();
				snd_crossing_climb 		= sound.getSoundSlot();
				snd_crossing_descend		= sound.getSoundSlot();
				snd_adjust_vs				= sound.getSoundSlot();
				snd_climb_now				= sound.getSoundSlot();
				snd_descend_now			= sound.getSoundSlot();
				snd_increase_climb		= sound.getSoundSlot();
				snd_increase_descent		= sound.getSoundSlot();
				snd_maintain_vs			= sound.getSoundSlot();
				snd_maintain_vs_crossing	= sound.getSoundSlot();
				snd_monitor_vs			= sound.getSoundSlot();
				snd_clear_of_conflict		= sound.getSoundSlot();
			
			sound.load( snd_traffic, 					snd_path .. "traffic.wav" );
			sound.load( snd_climb, 					snd_path .. "climb.wav" );
			sound.load( snd_descend, 					snd_path .. "descend.wav" );
			sound.load( snd_crossing_climb, 			snd_path .. "crossing_climb.wav" );
			sound.load( snd_crossing_descend, 		snd_path .. "crossing_descend.wav" );
			sound.load( snd_adjust_vs, 				snd_path .. "adjust_vs.wav" );
			sound.load( snd_climb_now, 				snd_path .. "climb_now.wav" );
			sound.load( snd_descend_now, 				snd_path .. "descend_now.wav" );
			sound.load( snd_increase_climb, 			snd_path .. "increase_climb.wav" );
			sound.load( snd_increase_descent, 		snd_path .. "increase_descent.wav" );
			sound.load( snd_maintain_vs, 				snd_path .. "maintain_vs.wav" );
			sound.load( snd_maintain_vs_crossing, 	snd_path .. "maintain_vs_crossing.wav" );
			sound.load( snd_monitor_vs, 				snd_path .. "monitor_vs.wav" );
			sound.load( snd_clear_of_conflict, 		snd_path .. "clear_of_conflict.wav" );
		--]]	
	
	end,


	-- Define utility function for mapping fpm rates to gauge positions.
	fpm_to_degrees = function( self, fpm )
		local max_fpm = 6000;
		local max_gauge_range = 160;
	
			local fpm_gauge = (fpm / max_fpm);
			if( fpm_gauge > 1 )then
				fpm_gauge = 1;
			elseif( fpm_gauge < -1 )then
				fpm_gauge = -1;
			end
			fpm_gauge = fpm_gauge * max_gauge_range;
	
		return fpm_gauge;
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
							)
		
		self.val_fpm = xp.getFloat( self.dref_vertSpeed );
		
		--These can be used here to redefine the gauge size on the fly without rebooting the scripts.
		--They have been moved to init_tcas2.lua for optimization.
		--[[
		gauge_size = 150;
		gauge_half = gauge_size / 2;
		--]]
		
		gl.PushMatrix();
			--Position on screen in useful location.
			gl.Translate( 900, 400, 0 );
			
			--Draw black backing-box.
			gl.PushMatrix();
				gl.Color( 0, 0, 0, 1 );
				gl.Translate( -(self.gauge_half+5), -(self.gauge_half+5), 0 );
				--gfx.drawQuad( self.gauge_size+10, self.gauge_size+10 );
				gfx.drawFilledBox( 0,0, self.gauge_size+10, self.gauge_size+10 );
			gl.PopMatrix();
			


			--calculate target arcs....
			self.target_vs = -1500;
			self.target_vs_window_min = self.target_vs - 500;
			self.target_vs_window_max = self.target_vs + 500;



			--draw VS target arcs
				gl.LineWidth(2);
					
					self.green_start 	= self:fpm_to_degrees( self.target_vs_window_min )+270;
					self.green_stop	= self:fpm_to_degrees( self.target_vs_window_max )+270;
					

					--draw red arc
					gl.Color( 1,0,0, 1 );
					if( self.green_start >= 270 )then
						--if the target vs is positive we mark anything less than the target vs as red
						for i=120, self.green_start, 0.5 do
							gfx.drawRadial( i, self.gauge_half, -30 );
						end
					else
						--if the target vs is negative we mark anything greater than the target vs as red
						for i=self.green_stop, 420, 0.5 do
							gfx.drawRadial( i, self.gauge_half, -30 );
						end
					end
					

					--draw green arc
					gl.Color( 0,1,0, 1 );
					--for i=0, 30, 0.5 do
					for i=self.green_start, self.green_stop, 0.5 do
						gfx.drawRadial( i, self.gauge_half, -30 );
					end
			
			gl.LineWidth(2);


			
			gl.Color( 1, 1, 1, 1 );
			gfx.drawCircle( self.gauge_half, 40 );
			

			
			--draw tick marks
			for i=270, 430, 30 do
				gfx.drawRadial( i, self.gauge_half, -20 );
			end
			for i=120, 270, 30 do
				gfx.drawRadial( i, self.gauge_half, -20 );
			end
			
			
			
			
				gl.PushMatrix();
					gl.Rotate( 270, 0, 0, -1 );
					
					self.val_fpm_gauge = self:fpm_to_degrees( self.val_fpm );
					
					--draw needle!
					gl.LineWidth(3);
					gfx.drawRadial( self.val_fpm_gauge, 0, self.gauge_half-20 );
					
				gl.PopMatrix();
			
			--]]
			gl.LineWidth(1);
			
		gl.PopMatrix();
		
	end	
}

xplugins_gauges_tcas2:init()





do
	 local old_OnDraw_Windows = OnDraw_Windows

	function OnDraw_Windows()

		xplugins_gauges_tcas2:draw()

		--[[
		if( old_OnDraw_Windows )then
			old_OnDraw_Windows()
		end
		--]]

	end

end
