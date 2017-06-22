function build_start_state()
	local state = lovestate()
	local angle = 0
	local offset = 0
	local terrain = love.graphics.newImage('terrain1.png')

	state.init = function()
		love.graphics.setBackgroundColor( 150, 170, 255 )
	end

	state.draw = function()
		love.graphics.setColor(
			math.ceil(angle) * 200,
			math.ceil(angle) * 300,
			math.ceil(angle) * 100,
			255)
		love.graphics.printf("[PRESS SPACE TO PLAY]",
			SCREEN_WIDTH/2 - 200, SCREEN_HEIGHT/2-50, 400, 'center')
		y = 312
		i = 32
		j = 6
		love.graphics.setColor(i, i, i, i)
		love.graphics.draw(terrain, -offset/8, y + j)
		i = i*2
		j = j*2
		love.graphics.setColor(i, i, i, i)
		love.graphics.draw(terrain, -offset/4, y + j)
		i = i*2
		j = j*2
		love.graphics.setColor(i, i, i, i)
		love.graphics.draw(terrain, -offset/2, y + j)
		i = i*2
		j = j*2
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(terrain, -offset, y + j)
		-- love.graphics.printf('1   1',
	    --     SCREEN_WIDTH/2-100, 0, 200, 'center')
	end

	state.update = function( dt )
		angle = angle + dt * 2.0
		offset = offset + dt * 100
		-- debugtxt = angle
	end

	state.keypressed = function ( key )
		if key == ' ' then 
			switch_state('game_state')
		end
	end

	return state
end

