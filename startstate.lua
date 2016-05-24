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

