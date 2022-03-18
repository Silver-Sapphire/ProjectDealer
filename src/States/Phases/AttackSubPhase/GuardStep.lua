
GuardStep = Class{__includes = BaseState}

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
    Event.dispatch("check-timing") -- TODO ensure its for op only

    -- TODO guard/no guard menu

    -- TODO only go to drive step if unit has drive checks instead of checking in drive step
    bStateMachine:change('drive', pass)
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