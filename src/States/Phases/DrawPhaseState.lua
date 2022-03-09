DrawPhaseState = Class{__includes = BaseState}

function DrawPhaseState:enter(fields, turnPlayer)
    -- trigger at the beggining of the draw phase effect

    -- draw for turn
    Event.dispatch('draw', {['player']=turnPlayer, ['qty']=1})
    
    -- G assist Step
    -- if not ride deck then
        self:gAssistCheck(self.fields[turnPlayer].hand)

    -- change phase
    vStateMachine:change('ride', self.fields, turnPlayer)
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
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(0,1,0,1) -- green
    -- TODO turn color red for opponents turn
    love.graphics.printf('Draw', 0, VIRTUAL_HEIGHT/2 - PHASE_TEXT_GAP, VIRTUAL_WIDTH, 'right')
end

function DrawPhaseState:gAssistCheck(hand)

end
