DrawPhaseState = Class{__includes = BaseState}

function DrawPhaseState:enter(fields)
    self.fields = fields
    Event.dispatch('draw')
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