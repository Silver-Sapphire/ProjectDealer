BattlePhaseState = Class{__includes = BaseState}

function BattlePhaseState:enter(fields, turnPlayer)
    self.fields = fields
    self.turnPlayer = turnPlayer
    -- determine possible attacks
    -- local 
    
        -- beggining of battle phase/start step triggers
    
        -- player decides whether or not to attack
            -- check timing

            -- battle begins (incriment counter)
            -- beggining of the attack step trigger

            -- select a unit to attack with (from menu)

            -- break if for whatever reason, at any point
            -- (rules, wierdness, ect) no atks are possible

            -- find valid atk targets
            -- select a unit to target

            -- apply multi-target effects

            -- find booster 

            -- boost? (ask via prompt)

            -- trigger on atk/boost effects

            -- another check timing

            -- move to guard step

            -- drive checks

    -- move to end phase
end

function BattlePhaseState:update(dt)

end

function BattlePhaseState:render()
    -- draw fields
    for k, field in pairs(self.fields) do
        field:render()
    end
    -- highlight current phase
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(0,1,0,1) -- green
    -- TODO turn color red for opponents turn
    love.graphics.printf('Battle', 0, VIRTUAL_HEIGHT/2 + PHASE_TEXT_GAP * 2, VIRTUAL_WIDTH, 'right')
end

-- Gurad step
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


-- Drive step
-- trigger beginning of drive step effect

-- determine number of checks to make

-- put each card in trigger zone

    -- trigger trigger effects

    -- check timing

    -- add drive to hand

    -- check timing

-- check timing


-- Damage step
-- trigger beginning of dmg step effects

-- compare battling units total power

-- cancel atk if a battling unit dissapears

-- if atkP >= defP then
    -- if atkTarget.table == 'vanguard' then
        -- begin apropriate amt of dmg checks

        -- check timing

        -- event.dispatch('hit', 'vanguard')

    -- else (rearguard)
        -- retire rearguard

        -- check timing

        -- event.dispatch('hit', 'rearguard')

    -- end
-- else (atk dosn't hit)

-- end
-- check timing

-- retire all guardians, and return G guards

-- check timing


-- Close step
-- trigger at the end of battle/beginning of the close step effects

-- check timing

-- imideatly remove all until end of battle effects, and stop all boosting/atking references

-- recur check timing

-- finish "to attack"action, or return to the start step if not 
