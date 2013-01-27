--[[

OpenGL Frame Buffer Object Example Script for Gizmo

Copyright 2013, Ben Russell - br@x-plugins.com

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

--]]


function OnBoot()
	-- Textures don’t have a “size” … you can upload or draw to them.
	tex_MyTexture = gfx.newTexture()
	
	-- Create an FBO and set the target as our new texture.
	-- FBO’s are like a virtual screen and need a size to work.
	fbo_MyTexture = gfx.newFBO(
							tex_MyTexture,
							256, 256  --texture width,height
						   )
	
	-- Create a new timer that runs every 10th of a second.
	tmr_MyTextureUpdateTimer = timer.newTimer( "MyTimer", 0.1 )
	
end



function MyTimer()
	
	-- This function should render to the FBO.
	
	gfx.useFBO( fbo_MyTexture )
	
	--Do GL drawing of stuff here.
	
	-- Set the pen color to red and draw words in mid screen.
	gfx.setColor( 1,0,0, 1 ) --r,g,b, alpha
	gfx.drawString( "OpenGL FBO Working", 128, 128 )
	
	gfx.releaseFBO( fbo_MyTexture ) -- <-- good luck if you forget this!
	
end



function OnDraw_Windows()
	
	gfx.texOn()
	
	gfx.useTexture( tex_MyTexture )
	gfx.drawTexturedQuad( 512,512, 256, 256 )
	
end