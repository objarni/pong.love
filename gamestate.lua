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
			pad[i].y = crop(pad[i].y, 0, SCREEN_HEIGHT-PAD_H)
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


