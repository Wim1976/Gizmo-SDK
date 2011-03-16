function xplugins_particles_controller__OnCreate()


  gui.setWindowCaption(
    xplugins_particles_controller.WindowID,
    "Gizmo - Particles Controller"
    );

  gui.setWindowSize(
    xplugins_particles_controller.WindowID,
    700, 500,
    250, 250
    );

  --gui.showWindow( xplugins_particles_controller.WindowID );


    widget_y = 30
      gui.newLabel( xplugins_particles_controller.WindowID,
        "", "ID ",
        8, widget_y, 115 );
      xplugins_particles_controller.txtParticles_ID = gui.newTextBox(
        xplugins_particles_controller.WindowID,
        "", 0, 50, widget_y, 100 );


    widget_y = widget_y + 20
      gui.newLabel( xplugins_particles_controller.WindowID,
        "", "tex ",
        8, widget_y, 115 );
      xplugins_particles_controller.txtParticles_Texture = gui.newTextBox(
        xplugins_particles_controller.WindowID,
        "", "212", 50, widget_y, 100 );


          gui.newButton(
            xplugins_particles_controller.WindowID,
            "btn_Particles_TexDown",
            " <",
            150,
            widget_y,
            30
            );

          gui.newButton(
            xplugins_particles_controller.WindowID,
            "btn_Particles_TexUp",
            " >",
            180,
            widget_y,
            30
            );





    widget_y = widget_y + 20
      gui.newLabel( xplugins_particles_controller.WindowID,
        "", "size ",
        8, widget_y, 115 );
      xplugins_particles_controller.txtParticles_Size = gui.newTextBox(
        xplugins_particles_controller.WindowID,
        "", "0.5", 50, widget_y, 100 );


    widget_y = widget_y + 20
      gui.newLabel( xplugins_particles_controller.WindowID,
        "", "life ",
        8, widget_y, 115 );
      xplugins_particles_controller.txtParticles_Life = gui.newTextBox(
        xplugins_particles_controller.WindowID,
        "", "1", 50, widget_y, 100 );


    widget_y = widget_y + 20
      gui.newLabel( xplugins_particles_controller.WindowID,
        "", "emax ",
        8, widget_y, 115 );
      xplugins_particles_controller.txtParticles_EnergyMax = gui.newTextBox(
        xplugins_particles_controller.WindowID,
        "", "0.15", 50, widget_y, 100 );


    widget_y = widget_y + 20
      gui.newLabel( xplugins_particles_controller.WindowID,
        "", "emin ",
        8, widget_y, 115 );
      xplugins_particles_controller.txtParticles_EnergyMin = gui.newTextBox(
        xplugins_particles_controller.WindowID,
        "", "0.05", 50, widget_y, 100 );


    widget_y = widget_y + 20
      gui.newLabel( xplugins_particles_controller.WindowID,
        "", "gravity ",
        8, widget_y, 115 );
      xplugins_particles_controller.txtParticles_Gravity = gui.newTextBox(
        xplugins_particles_controller.WindowID,
        "", "0", 50, widget_y, 100 );


    widget_y = widget_y + 20
      gui.newLabel( xplugins_particles_controller.WindowID,
        "", "growth ",
        8, widget_y, 115 );
      xplugins_particles_controller.txtParticles_GrowthRate = gui.newTextBox(
        xplugins_particles_controller.WindowID,
        "", "1", 50, widget_y, 100 );


    widget_y = widget_y + 20
      gui.newButton(
        xplugins_particles_controller.WindowID,
        "btn_Particles_Set",
        "Set",
        8,
        widget_y,
        145
        );


    widget_y = widget_y + 20
      gui.newButton(
        xplugins_particles_controller.WindowID,
        "btn_Particles_New",
        "New",
        8,
        widget_y,
        145
        );




end






function btn_Particles_New__OnClick()

  local particles_new = particles.newParticles( 1000 )
  particles.setTexture( particles_new, 212 ) --212 = black particle, 224 aurora,
  particles.setSize( particles_new, 5 )
  particles.setLife( particles_new, 30 )
  particles.setEnergyMax( particles_new, 5 )
  particles.setEnergyMin( particles_new, 1 )
  particles.setGravity( particles_new, 10 )
  particles.setGrowthRate( particles_new, 1 )
  --particles.setType_Cubic( particles_new )
  
  
  logging.debug("setting type as stream v2")
  
  particles.setType_Stream( particles_new )
  particles.init( particles_new )

  sound.say("new particle sys: " .. particles_new )

  --particle_update_q:register( particles_new )

end

----------------------------

particles_debug_string = "..."

function btn_Particles_Set__OnClick()
  
  logging.debug("Particles Controller: Set clicked..")

  local pid =  gui.getWidgetValue( xplugins_particles_controller.txtParticles_ID )
  local tex =  gui.getWidgetValue( xplugins_particles_controller.txtParticles_Texture )
  local size =  gui.getWidgetValue( xplugins_particles_controller.txtParticles_Size )
  local life =  gui.getWidgetValue( xplugins_particles_controller.txtParticles_Life )
  local emax =  gui.getWidgetValue( xplugins_particles_controller.txtParticles_EnergyMax )
  local emin =  gui.getWidgetValue( xplugins_particles_controller.txtParticles_EnergyMin )
  local gravity =  gui.getWidgetValue( xplugins_particles_controller.txtParticles_Gravity )
  local growth =  gui.getWidgetValue( xplugins_particles_controller.txtParticles_GrowthRate )

  logging.debug("Particles Controller: Values gathered.")

  particles.setTexture( pid, tex ) --212 = black particle, 224 aurora,
  particles.setSize( pid, size )
  particles.setLife( pid, life )
  particles.setEnergyMax( pid, emax )
  particles.setEnergyMin( pid, emin )
  particles.setGravity( pid, gravity )
  particles.setGrowthRate( pid, growth )
  
  logging.debug("Particles Controller: Engine values updated.")
  
  local dbg_vars = 'texid:' .. tex .. ' size:' .. size .. ' life:' .. life .. ' emax:' .. emax .. ' emin:' .. emin .. ' gravity:' .. gravity .. ' growth:' .. growth
  
  logging.debug("var vals:"..dbg_vars)
  
  particles_debug_string = dbg_vars

end












function btn_Particles_TexDown__OnClick()
  local tex =  gui.getWidgetValue( xplugins_particles_controller.txtParticles_Texture )
  tex = tex - 1
  gui.setWidgetValue( xplugins_particles_controller.txtParticles_Texture, tex )

  local pid =  gui.getWidgetValue( xplugins_particles_controller.txtParticles_ID )
  particles.setTexture( pid, tex )
end

function btn_Particles_TexUp__OnClick()
  local tex =  gui.getWidgetValue( xplugins_particles_controller.txtParticles_Texture )
  tex = tex + 1
  gui.setWidgetValue( xplugins_particles_controller.txtParticles_Texture, tex )

  local pid =  gui.getWidgetValue( xplugins_particles_controller.txtParticles_ID )
  particles.setTexture( pid, tex )
end








if( xpl_utils_avail ~= nil )then
  function xpl_particles_controller_DrawDbg()
    w,h = gfx.getScreenSize()
    gfx.drawString( "p.opts:" .. particles_debug_string , 100, 150)
  end
  registerDrawingCallBack_Windows( xpl_particles_controller_DrawDbg )
end





--instantiate.
  xplugins_particles_controller = { 
      WindowID = gui.newWindow( "xplugins_particles_controller" ) 
      };


