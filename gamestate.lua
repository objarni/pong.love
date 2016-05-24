require('crop')

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
BALLSIZE=20
BALLSPEED=350


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
			   image = PAD0IMAGE,
			   scoreX = SCREEN_WIDTH/8
			 }
	pad[1] = { name='pad1',
	           x=SCREEN_WIDTH-PAD_W-PAD_X_OFFSET,
	           y=PAD_START_Y,
	           color=PAD2_COLOR,
	           score = 0,
			   up = false,
			   down = false,
			   image = PAD1IMAGE,
			   scoreX = SCREEN_WIDTH/8*7
	       	 }
	assert(pad[0].image)
	assert(pad[1].image)

	ball = {
		reset = function(ball)
			ball.x=SCREEN_WIDTH/2
			ball.y=SCREEN_HEIGHT/2
			ball.dx = -1
			ball.dy = -1
		end
	}
	ball.reset(ball)

	function drawBall(ball)
		love.graphics.circle('fill',
			ball.x-BALLSIZE/2,
			ball.y-BALLSIZE/2,
			BALLSIZE)
	end

	function drawPad(pad)
		love.graphics.setColor(pad.color)
		love.graphics.rectangle('fill',
			pad.x, pad.y,
			PAD_W, PAD_H)
		assert(pad.image)
		love.graphics.draw(pad.image, pad.x, pad.y)
	end

	function drawScore(pad)
		love.graphics.setColor(pad.color)
		love.graphics.printf(pad.score, pad.scoreX, 0, 50, 'center')
	end

	function updatePadStateByKey(key, pressed, pad, bindings)
		if bindings[key] then
			pad[bindings[key]] = pressed
		end
	end

	function updatePad(pad, dt)
		if pad.up then
			-- debugtxt = 'moving up'
			pad.y = pad.y - dt * PAD_SPEED
		end
		if pad.down then
			-- debugtxt = 'moving down'
			pad.y = pad.y + dt * PAD_SPEED
		end
		pad.y = crop(pad.y, 0, SCREEN_HEIGHT-PAD_H)
	end

	function updateBall(ball, dt)
		ball.x = ball.x + ball.dx * dt * BALLSPEED
		ball.y = ball.y + ball.dy * dt * BALLSPEED
		if ball.y < 0 or ball.y > SCREEN_HEIGHT then
			ball.dy = -ball.dy
		end
		if ball.x < 0 then
			ball.reset(ball)
		end
	end

	local state = lovestate()

	state.init = function()
		love.graphics.setBackgroundColor(  25, 174, 255 )
	end

	state.draw = function()
		for i = 0, 1 do
			drawScore(pad[i])
			drawPad(pad[i])
		end
		drawBall(ball)
	end

	state.update = function( dt )
		-- debugtxt = tostring(pad[0].up) .. ' ' .. tostring(pad[0]['down'])
		for i = 0, 1 do
			updatePad(pad[i], dt)
		end
		updateBall(ball, dt)
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


