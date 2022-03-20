BattlePhaseState = Class{__includes = BaseState}

function BattlePhaseState:enter(pass)
    -- self.fields = pass.fields
    self.turnPlayer = pass.turnPlayer
    -- local turnPlayer = pass.turnPlayer

    -- if not vStateMachine then
    --     vStateMachine = StateMachine {
    --     }
    -- end

    -- enter our sub-phase state machine with our atk'r's table
    vStateMachine:change('start', pass)
end

function BattlePhaseState:update(dt)
    vStateMachine:update(dt)
end

function BattlePhaseState:render()
    vStateMachine:render()
    
    -- highlight current phase
    love.graphics.setFont(gFonts['large'])
    if self.turnPlayer == 1 then
        love.graphics.setColor(0,1,0,1) -- green
    else
        love.graphics.setColor(1,0,0,1) -- red
    end
    love.graphics.printf('Battle', 0, VIRTUAL_HEIGHT/2 + PHASE_TEXT_GAP * 2, VIRTUAL_WIDTH, 'right')
end
