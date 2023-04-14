suit = require 'suit'

http = require 'socket.http'

count = 1
imagecount = 5
mouse = {}
width, height = 900,500


function love.resize(w, h)
  print(("Window resized to width: %d and height: %d."):format(w, h))
  width = w
  height = h
end

function love.load()
love.window.setMode(width, height, {resizable=true, vsync=0, minwidth=400, minheight=300, centered=true})
	imagedata = love.image.newImageData("img/20220711-152642.jpg")
	seeun = love.graphics.newImage(imagedata)
--	imgwidth = seeun:getWidth( )
--	imgheight = seeun:getHeight( )
--	iscaleX = width/imgwidth
--	iscaleY = height/imgheight
--	iscale = math.min(iscaleX, iscaleY)
--	imglocx = width/2 - imgwidth/2
--	imglocy = height/2 - imgheight/2
	imglocx = 0
	imglocy = 0
	url = 'https://pbs.twimg.com/media/FZSjRHwaAAAkvzh?format=jpg&name=small'
	onlineimage = imageFromUrl(url)

	
end


function love.draw()
--    love.graphics.draw(seeun)
    love.graphics.setColor(255, 255, 255)
	imgwidth = seeun:getWidth( )
	imgheight = seeun:getHeight( )
	iscaleX = width/imgwidth
	iscaleY = height/imgheight
	iscale = math.min(iscaleX, iscaleY)
	imglocy = 0

	if imgheight < height or imgwidth < width  then 
		imgscale = 1 
		imglocx = width/2 -  imgwidth/2
	else 
		imgscale = tonumber(string.format("%.3f", iscale))
	end

    love.graphics.print("Mouse Coordinates: " .. mouse.x .. ", " .. mouse.y)
	love.graphics.print("SeeunW : " .. imgscale*seeun:getWidth(), 100, 100)
	local ofs = love.graphics.getWidth() - imgscale*seeun:getWidth()
	love.graphics.print("OFFSET : " .. (ofs/2), 100, 150)
	love.graphics.print("WindowW : " .. love.graphics.getWidth(), 100, 200)
	
	love.graphics.draw(onlineimage, 0, 0)
--		local ox, oy = love.graphics.getWidth()/2- seeun:getWidth()/2, 0 -- get center point
		love.graphics.draw(
			seeun, 	-- texture
			ofs/2, 		-- x pos
			imglocy, 		-- y pos
			0, 				-- rotation
			imgscale, 	-- x scale
			imgscale 	-- y scale
		)
	
--	love.graphics.draw(seeun, imglocx, imglocy, angle, imgscale, imgscale, offsetX)

    suit.draw()
--        love.graphics.circle("fill", love.graphics.getWidth()/2, love.graphics.getHeight()/2, love.graphics.getHeight()/2)

end

function love.keypressed(key)
    if key == "space" then
		seeun = love.graphics.newImage(getNextImage(count))
		count = count + 1
		if count > imagecount then count = 1 end
    end
	if key == "f11" then
		fullscreen = not fullscreen
		love.window.setFullscreen(fullscreen, "exclusive")
	end
end


function getNextImage(count)
	ImageNames = love.filesystem.getDirectoryItems( "img/" )
	imgTable = {}
	for i = 1, #ImageNames do
			local path = "img/" .. ImageNames[i]
			imgTable[i] = path
	end
	return imgTable[count]
end


local show_message = false

function love.update(dt)
    mouse.x, mouse.y = love.mouse.getPosition()  -- This gets the x and y coordinates of the mouse and assigns those to these respectively.
    msx, msy = love.mouse.getPosition()  -- This gets the x and y coordinates of the mouse and assigns those to these respectively.

	
    -- Put a button on the screen. If hit, show a message.
    if suit.Button("Prev", width/2 - 110, height - 60, 100, 50).hit then
		seeun = love.graphics.newImage(getNextImage(count))
		if count < 2 then count = imagecount end
		count = count - 1
        show_message = true
    end

    -- Put a button on the screen. If hit, show a message.
    if suit.Button("Next", width/2 + 10, height - 60, 100, 50).hit then
		seeun = love.graphics.newImage(getNextImage(count))
		count = count + 1
		if count > imagecount then count = 1 end
        show_message = true
    end

    -- if the button was pressed at least one time, but a label below
    if show_message then
        suit.Label("How are you today?", 100,150, 300,30)
    end
end

function imageFromUrl(url)
	return love.graphics.newImage(
	       love.image.newImageData(
	       love.filesystem.newFileData(
	       http.request(url), '', 'file')))
end