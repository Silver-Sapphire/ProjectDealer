StandPhaseState = Class{__includes = BaseState}

function StandPhaseState:enter(fields)
    self.fields = fields
    -- incriment turn count
    local turn = false
    for k, field in pairs(self.fields) do
        field.turn = field.turn + 1
        turn = field.turn
    end
    -- determine turn player
    self.turnPlayer = 1
    if turn % 2 == 0 then
        self.turnPlayer = 2
    end
    
    -- trigger at start of turn/stand phase effects
    Event.dispatch('begin-turn', self.turnPlayer)
    --check timing
    Event.dispatch('checktiming')

    -- stand all units
    -- local stoodUnits_ = {}
    for k, circle in pairs(self.fields[self.turnPlayer].circles) do
        if #circle.units ~= 0 then
            if circle.units[1].state == 'rest' then
                circle.units[1].state = 'stand'
                -- table.insert(stoodUnits_, circle.units[1])
                Event.dispatch('stand', circle.units[1])
            end
        end
    end

    -- check timing
    Event.dispatch('check-timing')

    vStateMachine:change('draw', self.fields, self.turnPlayer)
end

function StandPhaseState:update(dt)
    for k, field in pairs(self.fields) do
        field:update(dt)
    end
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
