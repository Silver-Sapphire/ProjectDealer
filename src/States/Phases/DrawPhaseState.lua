DrawPhaseState = Class{__includes = BaseState}

function DrawPhaseState:enter(fields)
    self.fields = fields
    -- incriment turn count (move to stand phase)
    local turn = false
    for k, field in pairs(self.fields) do
        field.turn = field.turn + 1
        turn = field.turn
    end
    
    local turnPlayer = 1
    if turn % 2 == 0 then
        turnPlayer = 2
    end

    Event.dispatch('draw', {['player']=turnPlayer, ['qty']=1})
    vStateMachine:change('ride', self.fields)
end

function DrawPhaseState:update(dt)
    --[[
        if mouse click on card or primary key pressed
            play draw animation
            add card to hand

            pop drawphase
            push ride phase
    ]]
end

function DrawPhaseState:render()
    -- draw fields
    for k, field in pairs(self.fields) do
        field:render()
    end
end