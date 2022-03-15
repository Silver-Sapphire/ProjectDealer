
GuradStep = Class{__includes = BaseState}

function GuradStep:enter(pass, battles)

end

function AttackStep:update(dt)
    for k, field in pairs(self.fields) do
        field:update(dt)
    end
end

function AttackStep:render()
    -- draw fields
    for k, field in pairs(self.fields) do
        field:render()
    end
end

-- trigger beginning of guard step effects

-- non-turn player gets a play timing (begin recursion)

    -- pass?

    -- force pass if they can't guard (also counts unit atk'd no longer existing)

    -- call cards from hand to G

    -- enable G guard

    -- check intercepts

        -- trigger intercpet effects

    -- play blitz order

-- check timing

-- repeat till pass (end recursion)