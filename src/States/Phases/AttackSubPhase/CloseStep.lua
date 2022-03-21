

CloseStep = Class{__includes = BattlePhaseState}

function CloseStep:enter(pass)
    --boiler plate


    -- Event.dispatch()
    Event.dispatch("recursive-check-timing", "begin-close-step")

    pass.battles = nil
    vStateMachine:change("start", pass)
end

function CloseStep:render()
    for k, field in pairs(self.fields) do
        field:render()
    end
    -- highlight current phase
    love.graphics.setFont(gFonts['large'])
    if self.turnPlayer == 1 then
        love.graphics.setColor(0,1,0,1) -- green
    else
        love.graphics.setColor(1,0,0,1) -- red
    end
    love.graphics.printf('Battle', 0, VIRTUAL_HEIGHT/2 + PHASE_TEXT_GAP * 2, VIRTUAL_WIDTH, 'right')
    love.graphics.print('Close Step', 200, 200)
end


-- Close step
-- trigger untriggered  'at the end of battle/beginning of the close step' effects

-- check timing

-- imideatly remove all until end of battle effects 

-- stop all boosting/atking references

-- recur check timing

-- finish "to attack"action, or return to the start step if not 
