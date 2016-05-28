function build_gameover_state()
    local state = lovestate()
    local time = 0

    state.init = function()
        time = 0
        love.graphics.setBackgroundColor( 255, 255, 255 )
    end

    state.draw = function()
        local c = winner_color
        love.graphics.setColor(c[1], c[2], c[3])
        love.graphics.printf("GAME OVER",
            SCREEN_WIDTH/2 - 200, SCREEN_HEIGHT/2-100, 400, 'center')
        love.graphics.printf(winner .. " WON",
            SCREEN_WIDTH/2 - 200, SCREEN_HEIGHT/2, 400, 'center')
    end

    state.update = function( dt )
        time = time + dt
        if time > 8 then
            switch_state('start_state')
        end
    end

    state.keypressed = function ( key )
        switch_state('start_state')
    end

    return state
end

