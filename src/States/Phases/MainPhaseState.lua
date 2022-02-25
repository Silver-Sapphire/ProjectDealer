MainPhaseState = Class{__includes = BaseState}

function MainPhaseState:enter(fields)
    self.fields = fields
end

function MainPhaseState:update(dt)
    if love.keyboard.wasPressed('m') then
        vStateMachine:change('redraw')
    end

    if love.keyboard.wasPressed('q') then
        gStateStack:pop()
    end
end

function MainPhaseState:render()
    -- draw fields
    for k, field in pairs(self.fields) do
        field:render()
    end
end
