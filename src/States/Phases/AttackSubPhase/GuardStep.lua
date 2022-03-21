
GuardStep = Class{__includes = BattlePhaseState}

function GuardStep:enter(pass)
    self.pass = pass
    self.battles = pass.battles
    self.fields = pass.fields
    self.turnPlayer = pass.turnPlayer
    local turnPlayer = pass.turnPlayer
    if turnPlayer == 1 then
        self.op = 2
    else
        self.op = 1
    end

    -- trigger guard step skills
    Event.dispatch("begin-guard-step")
    Event.dispatch("check-timing") -- TODO ensure its for op only?

    -- TODO guard/no guard menu

    -- TODO only go to drive step if unit has drive checks instead of checking in drive step
    vStateMachine:change('drive', pass)
end
function GuardStep:render()
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
    love.graphics.print('Guard Step', 200, 200)
end



-- non-turn player gets a play timing (begin recursion)

    -- pass?

    -- force pass if they can't guard (also counts unit being atk'd no longer existing)

    -- call cards from hand to G

    -- enable G guard

    -- check intercepts

        -- trigger intercpet effects (needs to be on G stay on standby)

    -- play blitz order

-- check timing

-- repeat till pass (end recursion)