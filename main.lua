-- CONSTANTS
PAD1_COLOR = {154, 222, 0}
PAD2_COLOR = {220, 0, 0}
PAD_W, PAD_H = 20, 80
PAD_X_OFFSET = 20
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
PAD_START_Y = SCREEN_HEIGHT/2 - PAD_H/2
PAD_SPEED = 500
PAD0IMAGE = love.graphics.newImage('pad0.png')
PAD1IMAGE = love.graphics.newImage('pad1.png')

require('lovestates')

-- UTILITY
function crop(value, max)
	if value<0 then return 0 end
	if value>max then return max end
	return value
end

-- GAME STATE CONSTRUCTORS --

function build_start_state()
	local state = lovestate()
	local angle = 0

	state.init = function()
		love.graphics.setBackgroundColor( 255, 255, 62 )
	end

	state.draw = function()
		love.graphics.setColor(
			math.floor(angle) * 200,
			math.floor(angle) * 300,
			math.floor(angle) * 100,
			255)
		love.graphics.print("[PRESS SPACE TO PLAY]",
			400, 300, angle, 4, 4, 75, 0)
	end

	state.update = function( dt )
		angle = angle + dt * 2.0
		-- debugtxt = angle
	end

	state.keypressed = function ( key )
		if key == ' ' then 
			switch_state('game_state')
		end
	end

	return state
end

function build_game_state()
	local pad = {}

	local keybindings = {}
	keybindings[0] = { w='up', s='down' }
	keybindings[1] = { up='up',down='down' }

	pad[0] = { name='pad0image',
	           x=PAD_X_OFFSET,
			   y=PAD_START_Y,
			   color=PAD1_COLOR,
			   score = 0,
			   up = false,
			   down = false,
			   image = PAD0IMAGE
			 }
	pad[1] = { name='pad1',
	           x=SCREEN_WIDTH-PAD_W-PAD_X_OFFSET,
	           y=PAD_START_Y,
	           color=PAD2_COLOR,
	           score = 0,
			   up = false,
			   down = false,
			   image = PAD1IMAGE
	       	 }
	assert(pad[0].image)
	assert(pad[1].image)

	function drawPad(pad)
		love.graphics.setColor(pad.color)
		love.graphics.rectangle('fill',
			pad.x, pad.y,
			PAD_W, PAD_H)
		assert(pad.image)
		love.graphics.draw(pad.image, pad.x, pad.y)
	end

	function updatePadStateByKey(key, pressed, pad, bindings)
		if bindings[key] then
			pad[bindings[key]] = pressed
		end
	end

	local state = lovestate()

	state.init = function()
		love.graphics.setBackgroundColor(  25, 174, 255 )
	end

	state.draw = function()
		love.graphics.printf('1-1', SCREEN_WIDTH/2, 0, 200)
		drawPad(pad[0])
		drawPad(pad[1])
		love.graphics.circle('fill', 400, 300, 20)
	end

	state.update = function( dt )
		-- debugtxt = tostring(pad[0].up) .. ' ' .. tostring(pad[0]['down'])
		for i = 0, 1 do
			if pad[i].up then
				-- debugtxt = 'moving up'
				pad[i].y = pad[i].y - dt * PAD_SPEED
			end
			if pad[i].down then
				-- debugtxt = 'moving down'
				pad[i].y = pad[i].y + dt * PAD_SPEED
			end
			pad[i].y = crop(pad[i].y, SCREEN_HEIGHT-PAD_H)
		end
	end

	state.keypressed = function ( key )
		updatePadStateByKey(key, true, pad[0], keybindings[0])
		updatePadStateByKey(key, true, pad[1], keybindings[1])
	end

	state.keyreleased = function ( key )
		updatePadStateByKey(key, false, pad[0], keybindings[0])
		updatePadStateByKey(key, false, pad[1], keybindings[1])
	end

	return state
end


states = {}
states.start_state = build_start_state()
states.game_state = build_game_state()


-- LOVE 2D WRAPPERS
function love.load()
	love.window.setTitle( 'My first love 2d game' )
    w, h, flags = love.window.getMode( )
    switch_state( 'start_state' )
    font = love.graphics.newFont( 'font.ttf', 20 )
    love.graphics.setFont( font )
end

function love.update( dt )
	state.update( dt )
end

function love.draw()
	if debugtxt then
	    love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print(debugtxt, 0, 550, 0, 2, 2)
		love.graphics.print('FPS:' .. love.timer.getFPS(), SCREEN_WIDTH-150, 0, 0, 2, 2)
	end
	state.draw()
end

function love.keypressed( key )
	state.keypressed( key )
	-- debugtxt = 'Key string: ' .. key
end

function love.keyreleased( key )
	state.keyreleased( key )
	-- debugtxt = 'Key string: ' .. key
end
