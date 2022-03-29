--[[
    the part of the attack sub phase where you decide if you're going to battle,
    where you move to the attack step without choosing who's batting
]]

StartStep = Class{__includes = BattlePhaseState}

function StartStep:enter(pass)
    self.fields = pass.fields
    self.turnPlayer = pass.turnPlayer
    --local atkNum = pass.atkNum (or 0)
    
    if not PastFirstStartStep and not GameOver then
        -- beggining of battle phase/start step triggers
        Event.dispatch("begin-battle-phase")
        Event.dispatch("begin-start-step")
        -- check timing
        Event.dispatch("check-timing")
        PastFirstStartStep = true
        Event.dispatch("test", pass)
    end

    if not GameOver then 
        -- assume the player will atk and move to atk step (this may cause some issues down the road...)
        -- the player may decide not to atk in the attack step if they don't trigger any "start of atk step" effects
        Event.dispatch("check-timing")
        vStateMachine:change("attack", pass)
    end
end

Event.on("test", function(pass)
    pass.player = 2
    Event.dispatch("game-over", pass)
end)