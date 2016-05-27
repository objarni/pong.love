function build_start_state()
	local state = lovestate()
	local angle = 0

	state.init = function()
		love.graphics.setBackgroundColor( 255, 255, 62 )
	end

	state.draw = function()
		love.graphics.setColor(
			math.ceil(angle) * 200,
			math.ceil(angle) * 300,
			math.ceil(angle) * 100,
			255)
		love.graphics.printf("[PRESS SPACE TO PLAY]",
			SCREEN_WIDTH/2 - 200, SCREEN_HEIGHT/2-30, 400, 'center')
		-- love.graphics.printf('1   1',
	    --     SCREEN_WIDTH/2-100, 0, 200, 'center')
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

