--[[
    the part of the attack sub phase where you decide if you're going to battle,
    where you move to the attack step without choosing who's batting
]]

StartStep = Class{__includes = BaseState}

function StartStep:enter(pass)
    self.fields = pass.fields
    self.turnPlayer = pass.turnPlayer
    --local atkNum = pass.atkNum (or 0)
    
    if not PastFirstStartStep then
        -- beggining of battle phase/start step triggers
        Event.dispatch("begin-battle-phase")
        Event.distapch("begin-start-step")
        -- check timing
        Event.disptach("check-timing")
        PastFirstStartStep = true
    end
    -- assume the player will atk and move to atk step
    -- the player may decide not to atk in the attack step if they don't trigger any "start of atk step" effects
    bStateMachine:change("attack", pass)
end

function StartStep:update(dt)
    for k, field in pairs(self.fields) do
        field:update(dt)
    end
end

function StartStep:render()
    -- draw fields
    for k, field in pairs(self.fields) do
        field:render()
    end
end


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

