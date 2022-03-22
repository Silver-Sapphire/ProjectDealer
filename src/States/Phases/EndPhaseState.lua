EndPhaseState = Class{__includes = BaseState}

function EndPhaseState:enter(pass)
    -- cleanup a global variable used in battle phase
    PastFirstStartStep = false
    
    self.fields = pass.fields
    self.turnPlayer = pass.turnPlayer
    local turnPlayer = pass.turnPlayer
    
    -- return all G units, unlock cards, spin astral plane unit, ect ----

    -- unlock triggers
    for k, circle in pairs(self.fields[turnPlayer].circles) do
        if #circle.units > 0 then
            card_ = circle.units[1]
            if card_.locked then
                Event.dispatch('unlock', card_)
            elseif card_.oLocked then
                card_.locked = true
                card_.oLocked = false
            end
        end
    end

    -- retire music orders
    -- spin astral plane unit

    Event.dispatch("check-timing")

    -- trigger untriggered at the beginning of the end phase/at end of turn triggers (recursive)
    Event.dispatch("recursive-check-timing", "begin-end",
        function()
            for k, field in pairs(self.fields) do
                for k, circle in pairs(field.circles) do
                    if #circle.units > 0 then
                        local unit = circle.units[1]
                        local powerLoss = unit.turnBoost
                        unit.turnBoost = 0
                        unit.currentPower = unit.currentPower - powerLoss
                    
                        unit.crit = unit.baseCrit
                    end
                end
            end
        end
    )

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
