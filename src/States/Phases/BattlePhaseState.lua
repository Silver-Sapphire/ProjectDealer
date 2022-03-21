--[[
    This state is a shell to represent (and parent) each of the battle sub phase states
]]

BattlePhaseState = Class{__includes = BaseState}

function BattlePhaseState:enter(pass)
    self.fields = pass.fields
    -- self.turnPlayer = pass.turnPlayer
    -- local turnPlayer = pass.turnPlayer

    vStateMachine:change('start', pass)
end

function BattlePhaseState:render()
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
end
