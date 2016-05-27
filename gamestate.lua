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
BALLSPEED=250
POINT_SOUND = love.audio.newSource('point.wav', 'static')
BOUNCE_SOUND = love.audio.newSource('bounce.wav', 'static')

function build_game_state()
    local lightup = love.graphics.newShader[[
        extern vec2 centre;
        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
          //vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
          float c = min(0.5, 1-distance(centre, screen_coords) / 400.0);
          return vec4(c);
        }
      ]]

    local keybindings = {}
    keybindings[0] = { w='up', s='down' }
    keybindings[1] = { up='up',down='down' }


    function buildPad(name, x, color, image, scoreX)
        return
        {
            name = name,
            x = x,
            y = PAD_START_Y,
            color = color,
            up = false,
            down = false,
            image = image,
            scoreX = scoreX,
            reset = function(pad)
                        pad.score = 0
                        pad.y = PAD_START_Y
                    end,
            pointIsInside = function(pad, x, y)
                if x < pad.x then return false end
                if x > pad.x + PAD_W then return false end
                if y < pad.y then return false end
                if y > pad.y + PAD_H then return false end
                return true
            end
        }
    end
    local pad = {}
    pad[0] = buildPad(
                'Left pad',
                PAD_X_OFFSET,
                PAD1_COLOR,
                PAD0IMAGE,
                SCREEN_WIDTH/8)
    pad[1] = buildPad(
                'Right pad',
                SCREEN_WIDTH-PAD_W-PAD_X_OFFSET,
                PAD2_COLOR,
                PAD1IMAGE,
                SCREEN_WIDTH/8*7)

    for i = 0, 1 do
        pad[i]:reset()
    end

    assert(pad[0].image)
    assert(pad[1].image)

    local dx = 1
    ball = {
        reset = function(ball)
            ball.x=SCREEN_WIDTH/2
            ball.y=SCREEN_HEIGHT/2
            if ball.dx then ball.dx = -ball.dx else ball.dx = -1 end
            ball.dy = 1 - 2*math.random(0, 1)
        end,
        padCollision = function(ball, pad)
            -- Check if leftmost- or rightmost point of
            -- ball is inside of pad rectangle
            leftmost = ball.x -- BALLSIZE
            rightmost = ball.x + BALLSIZE
            if pad:pointIsInside(leftmost, ball.y) then
                return true
            end
            -- if pad:pointIsInside(rightmost, ball.y) then
            --     return true
            -- end
            return false
        end
    }
    ball:reset()

    function drawBall(ball)
        love.graphics.circle('fill',
            ball.x,
            ball.y,
            BALLSIZE)
        lightup:send('centre', {ball.x, SCREEN_HEIGHT-ball.y})
        love.graphics.setBlendMode('additive')
        love.graphics.setShader(lightup)
        love.graphics.rectangle('fill', 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        love.graphics.setShader()
        love.graphics.setBlendMode('alpha')
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

    function scoreTo(padNum)
        POINT_SOUND:play()
        local newScore = pad[padNum].score + 1
        if newScore == 10 then
            switch_state('start_state')
        else
            pad[padNum].score = newScore
        end
    end

    function updateBall(ball, dt)
        ball.x = ball.x + ball.dx * dt * BALLSPEED
        ball.y = ball.y + ball.dy * dt * BALLSPEED
        if ball.y < 0 then
            ball.y = 1
            ball.dy = -ball.dy
            BOUNCE_SOUND:play()
        end
        if ball.y > SCREEN_HEIGHT then
            ball.y = SCREEN_HEIGHT - 1
            ball.dy = -ball.dy
            BOUNCE_SOUND:play()
        end
        if ball.x < 0 then
            ball.reset(ball)
            scoreTo(1)
        end
        if ball.x > SCREEN_WIDTH then
            ball.reset(ball)
            scoreTo(0)
        end
        for i = 0, 1 do
            if ball:padCollision(pad[i]) then
                ball.dx = -ball.dx
                while ball:padCollision(pad[i]) do
                    ball.x = ball.x + ball.dx
                end
                BOUNCE_SOUND:play()
            end
        end
    end

    local state = lovestate()

    state.init = function()
        pad[0].reset(pad[0])
        pad[1].reset(pad[1])
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


