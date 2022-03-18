DrawPhaseState = Class{__includes = BaseState}

function DrawPhaseState:enter(pass)
    self.fields = pass.fields
    self.turnPlayer = pass.turnPlayer
    local turnPlayer = pass.turnPlayer
    -- trigger at the beggining of the draw phase effect
    Event.dispatch("begin-draw")
    Event.dispatch("check-timing")

    -- draw for turn
    Event.dispatch('draw', {['player']=turnPlayer, ['qty']=1})
    Event.dispatch("check-timing")
    
    -- G assist Step
    -- if not ride deck then
        self:gAssistCheck(self.fields[turnPlayer].hand)
    --end

    -- change phase
    vStateMachine:change('ride', pass)
end

function DrawPhaseState:gAssistCheck(hand)
    Event.dispatch("begin-assist")
    Event.dispatch("check-timing")

    -- determine if we can't ride up
        --  reveal hand
        -- check top 5 for missing grade
        -- add if we find it
        -- remove 2 cards in hand from game
        -- shuffle deck

    Event.dispatch("check-timing")
end
