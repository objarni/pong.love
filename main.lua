
require('lovestates')
require('startstate')
require('gamestate')

states = {
	start_state = build_start_state(),
	game_state = build_game_state()
}


-- LOVE 2D WRAPPERS
function love.load()
	love.window.setTitle( 'My first love 2d game' )
    w, h, flags = love.window.getMode( )
    switch_state( 'game_state' )
    font = love.graphics.newFont( 'font.ttf', 40 )
    love.graphics.setFont( font )
    debugtxt = 'hello'
end

function love.update( dt )
	state.update( dt )
end

function love.draw()
	if debugtxt then
		local posy = SCREEN_HEIGHT-40
	    love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print(debugtxt, 0, posy, 0, 0.5, 0.5)
		love.graphics.print('FPS:' .. love.timer.getFPS(),
			SCREEN_WIDTH-150, posy, 0, 0.5, 0.5)
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
