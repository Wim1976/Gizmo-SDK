-- Repository Manager Script --


xpl_repo_file_list = {}

if( xpl_utils_avail ~= nil )then
  function xpl_repo_DrawUpdateStatus()
    
    w,h = gfx.getScreenSize()
    y = h - 400
    for i,v in ipairs(xpl_repo_file_list)do
      gfx.drawString( "updating: " .. v, 100, y )
      y = y - 17
    end
    
  end
  registerDrawingCallBack_Windows( xpl_repo_DrawUpdateStatus)
end





--this file downloads individual items from the manifest.
function cb_http_get_repo_item( data, url, size )
  --logging.debug( "rx " .. size .. " bytes: " .. url )
  
  
  _, _, module_name = string.find( url, "^.*/(.*)$")
  --logging.debug("name from url: " .. module_name)
  
  full_module_name = module_name --this may be stripped later to fit disk filename requirements.
  
  
  for i,v in ipairs(xpl_repo_file_list) do 
    -- clear out the expected files table as each one completes.
    if( v == module_name )then
      table.remove( xpl_repo_file_list, i )
    end
  end
  
  
  --put together a debug string so we can verify that the files are arriving and the list gets shorter
  s_remaining = ""
  for i,v in ipairs(xpl_repo_file_list) do 
    s_remaining = s_remaining .. v .. ", "
  end
  

  
  --find the module subname so that we can see if we have the init module and need to change the disk filename
  _, _, module_subname = string.find( module_name, "^.*%.(.*)$")
  if( module_subname == "init" )then
    --we shorten this to a generic filename so that the XPL can find it more easily.
    module_name = "init"
  end
  
  
  
  --save filename to disk as update
  fname = xp.getAircraftFolder() .. "scripts/" .. module_name
  
  
  local f = io.open( fname, "wb")
  f:write( data )
  f:close()
  
  
  
  logging.debug("Updated: " .. full_module_name .. ": Remaining: " .. s_remaining)
  if( #xpl_repo_file_list == 0 )then
    sound.say("Update complete, restarting script engine.")
    logging.debug("Update complete, restarting script engine.")
    gizmo.reset()
  end
  
  
  
  
  
end







--this function processes the manifest file and decides what to do.
function cb_http__get_repo_update( data, url, size )
  --sound.say('dl complete: ' .. url)
  
  fname = xp.getAircraftFolder() .. "scripts/manifest"
  --fname = "new_manifest" -- this ends up puting the file next to x-plane.exe, not much use.
  
  local f = io.open( fname, "wb")
  f:write( data )
  f:close()
  
  --drm.dofile(fname)
  drm.dofile("manifest")
    
  --sound.say( new_manifest.version )
  
  
  
  --not smart about updates, always grab a new copy, faster dev work.
  --if( 1 )then
  if( new_manifest.version > manifest.version )then
      sound.say("Downloading updates..")
      
      
      for k,v in ipairs(new_manifest) do
        --logging.debug("module name: " .. v.name)
        table.insert( xpl_repo_file_list, v.name ) --store the module name that we have started to download.
        http.get( "http://x-plugins.com/gizmo/scripts/" .. v.name, "cb_http_get_repo_item" )
      end
    
      
      manifest = new_manifest
        
  else
      sound.say("You are up to date..")
      
  end --end check manifest version delta
    
end




--this variable will be populated with correct data by the file that's calling on us.
xpl_repo__Package_Name = "Broken";






function cb_menu_CheckForUpdates__OnClick()
  sound.say("Checking for updates..")
  url = 'http://x-plugins.com/gizmo/scripts/manifest.' .. xpl_repo__Package_Name
  http.get( url, 'cb_http__get_repo_update' )
end

menu.newItem("Check for Updates..", "cb_menu_CheckForUpdates")
menu.newItem("---", "spacer")





--load our initial copy of the manifest
--fname = xp.getAircraftFolder() .. "scripts/manifest"
drm.dofile( "manifest")

if( new_manifest ~= nil )then
  --manifest file contains code that will populate the new_manifest table, so we copy it into manifest. :)
  manifest = new_manifest
else
  --init to nothing, no manifest file found, assume out of date.
  manifest = {version=0}
  new_manifest=manifest
end




