-- a state for our state stack designed to encapsulate
-- a state machine representing a game of CFV
VanguardState = Class{__includes = BaseState}

function VanguardState:enter()
    -- setup a state machine for keeing track of game phases
    vStateMachine = StateMachine {
        ['redraw'] = function() return RedrawState() end,
        ['stand-up'] = function() return StandUpState() end,
        -- ['stand'] = function() return StandPhaseState() end,
        ['draw'] = function() return DrawPhaseState() end,
        ['ride'] = function() return RidePhaseState() end,
        ['main'] = function() return MainPhaseState() end,
        ['battle'] = function() return BattlePhaseState() end,
        ['end'] = function() return EndPhaseState() end
    }    

    Event.on('draw', function()
        local _ = table.remove(self.fields[1].deck)
        table.insert(self.fields[1].hand, _)
    end)

    _DECKLIST = shuffle(DECKLIST)
    -- initialize boards
    self.fields = {}
    -- local player [1]
    local player1Field = Field(_DECKLIST, false)
    table.insert(self.fields, player1Field)
    -- draw initial 5 cards
    for i=1, 5 do
        Event.dispatch('draw')
    end
    -- peer player [2]
    local player2Field = Field(_DECKLIST, true)
    table.insert(self.fields, player2Field)

    vStateMachine:change('redraw', self.fields)
end

function VanguardState:update(dt)
    vStateMachine:update(dt)
end

function VanguardState:render()
    vStateMachine:render()
end
