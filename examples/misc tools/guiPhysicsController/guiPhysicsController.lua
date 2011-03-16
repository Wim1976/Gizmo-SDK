

function xplugins_physics_controller__OnCreate()


  gui.setWindowCaption(
    xplugins_physics_controller.WindowID,
    "Gizmo - Physics Controller"
    );
  
  gui.setWindowSize(
    xplugins_physics_controller.WindowID,
    518,
    23,
    230,
    193
    );
  
  gui.showWindow( xplugins_physics_controller.WindowID );
  
  
  xplugins_physics_controller.btnPhysicsExplodingStack = gui.newButton(
    xplugins_physics_controller.WindowID,
    "btn_PhysicsDemo_ExplodingStack",
    "Exploding Stack",
    118,
    129,
    100
    );
  
  
  xplugins_physics_controller.btnPhysicsPause = gui.newButton(
    xplugins_physics_controller.WindowID,
    "btn_PhysicsTogglePause",
    "Pause",
    118,
    24,
    100
    );
  
  xplugins_physics_controller.btnPhysicsToggle = gui.newButton(
    xplugins_physics_controller.WindowID,
    "btn_PhysicsToggle",
    "Toggle",
    8,
    24,
    100
    );
  
  xplugins_physics_controller.btnPhysicsDebugDraw = gui.newButton(
    xplugins_physics_controller.WindowID,
    "btn_PhysicsToggleDebugDraw",
    "Debug Draw",
    8,
    49,
    100
    );
  
  xplugins_physics_controller.btnPhysicsNextFrame = gui.newButton(
    xplugins_physics_controller.WindowID,
    "btn_PhysicsNextStep",
    "Next Frame",
    118,
    49,
    100
    );
  
  
  


-- cursor
--[[
  xplugins_physics_controller.labCallSign = gui.newLabel(
    xplugins_physics_controller.WindowID,
    "script_na",
    "Physics Cursor XYZ ",
    8,
    81,
    117
    );
  
  xplugins_physics_controller.txtPhysicsCursorX = gui.newTextBox(
    xplugins_physics_controller.WindowID,
    "script_na",
    "0",
    8,
    100,
    30
    );
  
  xplugins_physics_controller.txtPhysicsCursorY = gui.newTextBox(
    xplugins_physics_controller.WindowID,
    "script_na",
    "0",
    50,
    100,
    30
    );
  
  xplugins_physics_controller.txtPhysicsCursorZ = gui.newTextBox(
    xplugins_physics_controller.WindowID,
    "script_na",
    "0",
    92,
    100,
    30
    );
  
  xplugins_physics_controller.btnPhysicsSetCursorXYZ = gui.newButton(
    xplugins_physics_controller.WindowID,
    "btn_PhysicsSetCursorXYZ",
    "Set",
    135,
    101,
    43
    );
--]]
  
  
  
  xplugins_physics_controller.btnPhysicsCreateStage = gui.newButton(
    xplugins_physics_controller.WindowID,
    "btn_PhysicsDemo_CreateStage",
    "Create Stage..",
    8,
    130,
    100
    );
  
  xplugins_physics_controller.btnPhysicsExplodingStack = gui.newButton(
    xplugins_physics_controller.WindowID,
    "btn_PhysicsReset",
    "RESET",
    118,
    163,
    100
    );

end







----------------------------

function btn_PhysicsDemo_ExplodingStack__OnClick()
  
  if( objBox == nil )then return end
  
  
  --set defaults for new objects
  physics.setBrush( objBox );
  physics.setCursor( 0, 0, 0 );
  physics.setMass( 50 );





  --xplanes gravity is actually rarely square on with OpenGL/Bullet coords-space
  drop_height = 1;

  
  make_stack = true;
  if( make_stack )then
    for i=0,100 do
      
      physics.setCursor( 10, drop_height, 0 );
      
      physics.newBox( 5,2,5 );
      --physics.createSphere( 1.2 );
      
      
      --drop_height = drop_height   2.5; --drip stack
      --drop_height = drop_height   2.0; --perfect stack
      drop_height = drop_height + 0.5; --exploding stack
      
    end
  end
end



function btn_PhysicsTogglePause__OnClick()

  if( physics_paused == nil )then physics_paused = false end

  if( physics_paused )then
    physics_paused = false
    physics.setPaused( 0 )
  else
    physics_paused = true
    physics.setPaused( 1 )
  end
end





function btn_PhysicsToggle__OnClick()
  --physics is on by default at startup
  
  if( do_physics_demo == nil )then do_physics_demo = true end

  if( do_physics_demo )then
    do_physics_demo = false
    physics.setEnabled( 0 )
    sound.say("physics off")
    physics.setDrawingHackEnabled( 0 )
  
  else
    do_physics_demo = true
    physics.setEnabled( 1 )
    sound.say("physics on")
    physics.setDrawingHackEnabled( 1 )
  
  end
end


function btn_PhysicsToggleDebugDraw__OnClick()
  sound.say("todo: debug draw toggle")
end

function btn_PhysicsNextStep__OnClick()
  physics.stepOnce( 1 );
end

function btn_PhysicsSetCursorXYZ__OnClick()
  sound.say("todo: read vals, Set Cursor")
end



function btn_PhysicsDemo_CreateStage__OnClick()
  --object load/unload is now working. array based. icky.
  obj_filename = "/Resources/default scenery/900 us objects/buildings/b1_60_15_6.obj"
  logging.debug("Loading: " .. obj_filename)
  objBox = gfx.loadObject( obj_filename )
  logging.debug("physics.controller: obj loaded, ID: " .. objBox)


  logging.debug("Calling for physics..")

  physics.setCursor( 0, 0, 0 )
  
  logging.debug("Physics API works..")

  physics.setDebugMode(1)
  physics.setDrawingHackEnabled(1)
  physics.setGravityVector( 0, -9.8, 0 )
  physics.setSimSteps( 2 )

  --create ground
  physics.setBrush( -1 ) --dont draw the ground or wall objects
  physics.setMass( 0 )
  physics.newBox( 1000, 0.1, 1000 )


  physics.setCursor( 0, 400, 0 )
  physics.newBox( 50, 5, 50 )


  --create walls
  
  local wall_h = 100
  
    --physics.setBrush( objFlower )
    physics.setCursor(50, 200, 0 )
    physics.newBox( 5, 200, 50 )

    physics.setCursor(-50, 200, 0 )
    physics.newBox( 5, 200, 50 )


    physics.setCursor(0, 200, 50 )
    physics.newBox( 50, 200, 5 )

    physics.setCursor(0, 200, -50 )
    physics.newBox( 50, 200, 5 )
end




function btn_PhysicsReset__OnClick()

  physics.restart()
  physics.setDrawingHackEnabled(1)
  physics.setDebugMode(1)

  sound.say("Bullet Physics Reset.")

end


