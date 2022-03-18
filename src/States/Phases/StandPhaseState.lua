StandPhaseState = Class{__includes = BaseState}

function StandPhaseState:enter(pass)
    -- cringe global var reset
    AttackNum = 0
    self.pass = pass
    self.fields = pass.fields
    -- incriment turn count
    for k, field in pairs(self.fields) do
        field.turn = field.turn + 1
        self.turn = field.turn
    end

    -- determine turn player (work into extra turn functionallity)
    if self.turn % 2 == TURNCONSTANT then
        self.pass.turnPlayer = 1
    else
        self.pass.turnPlayer = 2
    end
    local turnPlayer = self.pass.turnPlayer
    
    -- trigger at start of turn/stand phase effects
    Event.dispatch('begin-turn', turnPlayer)
    Event.dispatch('check-timing')

    -- stand all units
    for k, circle in pairs(self.fields[
        turnPlayer].circles) do
        if #circle.units ~= 0 then
            if circle.units[1].state == 'rest' then
                circle.units[1].state = 'stand'
                -- table.insert(stoodUnits_, circle.units[1])
                Event.dispatch('stand', circle.units[1])
            end
        end
    end
    Event.dispatch('check-timing')

    vStateMachine:change('draw', self.pass)
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
