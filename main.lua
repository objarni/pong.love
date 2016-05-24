
require('crop')
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
    switch_state( 'start_state' )
    font = love.graphics.newFont( 'font.ttf', 20 )
    love.graphics.setFont( font )
    debugtxt = 'hello'
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
