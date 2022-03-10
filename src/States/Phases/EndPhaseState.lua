EndPhaseState = Class{__includes = BaseState}

function EndPhaseState:enter(pass)
    self.fields = pass.fields
    self.turnPlayer = pass.turnPlayer
    local turnPlayer = pass.turnPlayer

    -- return all G units, unlock cards, spin astral plane unit, ect

    -- unlock triggers

    -- trigger untriggered at the beginning of the end phase/at end of turn triggers (recursive)

    -- remove all "unitl end of turn" effect (recursive)
    
    -- recursivly check there are no triggers left (recursive)

    -- pass turn
    vStateMachine:change('stand', {['fields']=self.fields})
end

function EndPhaseState:update(dt)

end

function EndPhaseState:render()
    -- draw fields
    for k, field in pairs(self.fields) do
        field:render()
    end
    -- highlight current phase
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(0,1,0,1) -- green
    -- TODO turn color red for opponents turn
    love.graphics.printf('End', 0, VIRTUAL_HEIGHT/2 + PHASE_TEXT_GAP * 3, VIRTUAL_WIDTH, 'right')
end
