StandPhaseState = Class{__includes = BaseState}

function StandPhaseState:enter(fields)
    self.fields = fields
    -- incriment turn count
    local turn = false
    for k, field in pairs(self.fields) do
        field.turn = field.turn + 1
        turn = field.turn
    end
    local turnPlayer = 1
    if turn % 2 == 0 then
        turnPlayer = 2
    end
    -- trigger at start of turn/stand phase effects

    -- stand all units

    -- check timing

    vStateMachine:change('draw', self.fields, turnPlayer)
end

function StandPhaseState:update(dt)
    
end

function StandPhaseState:render()
    -- draw fields
    for k, field in pairs(self.fields) do
        field:render()
    end
    -- highlight current phase
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(0,1,0,1) -- green
    -- TODO turn color red for opponents turn
    love.graphics.printf('Stand', 0, VIRTUAL_HEIGHT/2 - PHASE_TEXT_GAP * 2, VIRTUAL_WIDTH, 'right')
end
