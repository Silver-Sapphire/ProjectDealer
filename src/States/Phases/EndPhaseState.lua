EndPhaseState = Class{__includes = BaseState}

function EndPhaseState:init()
    -- end phase triggers
    -- remove all "unitl end of turn" effect
    -- pass turn
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
