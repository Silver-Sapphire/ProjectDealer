

CloseStep = Class{__includes = BaseState}

function CloseStep:enter(pass)
    --boiler plate


    -- Event.dispatch()
    Event.dispatch("recursive-check-timing", "begin-close-step")

    pass.battles = nil
    bStateMachine:change("start", pass)
end

-- Close step
-- trigger untriggered  'at the end of battle/beginning of the close step' effects

-- check timing

-- imideatly remove all until end of battle effects 

-- stop all boosting/atking references

-- recur check timing

-- finish "to attack"action, or return to the start step if not 
