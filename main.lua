--[[
    CS50
    Final Project

    Project Dealer

    Author: Me mostly, with some functions (state machine, state stack, ect.) borrowed from other games in the CS50 course

    The goal of this project is to create a simulation of a game of Cardfight!! Vanguard, 
    where all game elements (such as attack power and effect cost) are handeled automatically instead of manually.

]]

require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('ProjectDealer')
    -- love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false,
        vsync = true,
        canvas = false,
        resizable = true
    })

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}
    
    -- keep track of scrolling our background on the X axis
    backgroundX = 0

    -- start game --
    gStateStack = StateStack()
    gStateStack:push(StartState())

    --debug lines
    Check = false
    Checks = {}
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    ---- debug commands ----
    if key == "q" then
        gStateStack:pop()
    end

    if key == "d" then
        local card = Card(CARD_IDS['test-heal'])
        
        table.insert(vStateMachine.current.fields[1].damage, card)
    end

    if key == "L" then
        Event.dispatch("log-toggle")
    end
    --------
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mousepressed(x, y, key)
    love.mouse.keysPressed[key] = true
end

function love.mousereleased(x, y, key)
    love.mouse.keysReleased[key] = true 
end

function love.mouse.wasPressed(key)
    return love.mouse.keysPressed[key]
end

function love.mouse.wasReleased(key)
    return love.mouse.keysReleased[key]
end

function love.update(dt)
    Timer.update(dt)
    gStateStack:update(dt)
    
    -- scroll background, used across all states
    backgroundX = backgroundX - BACKGROUND_SCROLL_SPEED * dt
    
    -- if we've scrolled the entire image, reset it to 0
    if backgroundX <= -1*VIRTUAL_WIDTH + 120 then
        backgroundX = 0
    end

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}
end

function love.draw()
    push:start()

    -- scrolling background drawn behind every state
    love.graphics.draw(gTextures['background-large'], backgroundX, 0)

    gStateStack:render()
    push:finish()
    displayFPS()
    --debug lines
    for i, check in ipairs(Checks) do
        love.graphics.print(check, 10, 50*i)
    end
    if Check then 
        love.graphics.setColor(1/3, 1/3, 1/3, 1/3)
        love.graphics.rectangle('fill', 0,0, VIRTUAL_WIDTH,VIRTUAL_HEIGHT)
    end
end

function love.resize(w, h)
    push:resize(w, h)
end
