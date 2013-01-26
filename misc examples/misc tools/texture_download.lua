--[[
This script briefly demonstrates how to download a blob image off the net and upload it to the users video card.
--]]

tex_downloaded_blob = gfx.newTexture()
function get_http_texture(data, url, size)
  gfx.loadTgaBlob( data, tex_downloaded_blob, size )
end
http.get("http://192.168.1.139/tga.php?u=radar.weather.gov/ridge/Conus/RadarImg/southeast.gif", "get_http_texture")