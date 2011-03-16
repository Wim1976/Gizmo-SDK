
--[[
DMax Glider Script - Thermaling Avionics.
--]]

drm.acfAuth("stock_panel_acf_sig")
drm.acfAuth("f3e840976726bb7bc1f12ae0e299d106") --customized panel and viewpoint specs, saved with 941, br.


drm.dofile("com.x-plugins.utils")

drm.dofile("com.x-plugins.repo")
xpl_repo__Package_Name = "Thermals"

--drm.dofile("com.x-plugins.thermals")
dofile("com.x-plugins.thermals.lua")