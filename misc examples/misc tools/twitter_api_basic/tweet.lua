--[[
This script uses Twitters most basic Web-API.
It Tweets which version of Gizmo you're using when X-Plane loads.

You need to change your username and password to make it work.
--]]


twitter_username = ""
twitter_password = ""




sTweet = "Started X-Plane, testing Gizmo: " .. gizmo.getVersion()
payload = http.urlEncode( sTweet, #sTweet )

twitter_url = "http://" .. twitter_username .. ":" .. twitter_password .. "@twitter.com/statuses/update.json"

http.post(twitter_url, "get_http_twitter", "status=" .. payload )




--Enable this function to recieve feedback about what Twitter sent back.
--[[
function get_http_twitter(data, url, size)
  sound.say("twitter returned:" .. data)
end
--]]

