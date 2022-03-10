-- a state for our state stack designed to encapsulate
-- a state machine representing a game of CFV
VanguardState = Class{__includes = BaseState}

function VanguardState:enter()

    -- setup a state machine for keeing track of game phases
    vStateMachine = StateMachine {
        ['redraw'] = function() return RedrawState() end,
        ['stand-up'] = function() return StandUpState() end,
        
        ['stand'] = function() return StandPhaseState() end,
        ['draw'] = function() return DrawPhaseState() end,
        ['ride'] = function() return RidePhaseState() end,
        ['main'] = function() return MainPhaseState() end,
        ['battle'] = function() return BattlePhaseState() end,
        ['end'] = function() return EndPhaseState() end
    }    

    -- setup game actions, with self discriptive name
    Event.on('draw', function(t)
        for i = 1, t.qty do
            local _ = table.remove(self.fields[t.player].deck)
            table.insert(self.fields[t.player].hand, _)
        end
    end)
    
    Event.on('ride', function (selection)
        -- move selected card to V
        self:moveCard({
            _field = 1, -- todo make dynamic
            _inputTable = selection.table,
            _inputIndex = selection.index,

            _outputTable = "vanguard"-- and here
            -- output to end of table implied
        })

        -- move older vanguard unit to soul
        self:moveCard({
            _field = 1, -- todo make dynamic
            _inputTable = "vanguard",
            _inputIndex = 1,

            _outputTable = "soul"
            -- output to end of table implied
        })
   end)

    _DECKLIST = shuffle(DECKLIST)
    _DECKLIST2 = shuffle(DECKLIST)
    -- initialize boards
    self.fields = {}
    -- local player [1]
    local player1Field = Field(_DECKLIST, false)
    table.insert(self.fields, player1Field)
    -- peer player [2]
    local player2Field = Field(_DECKLIST2, true)
    table.insert(self.fields, player2Field)

    -- draw initial 5 cards -- needs netcode tuneup
    Event.dispatch('draw', {['player']=1, ['qty']=5})
    Event.dispatch('draw', {['player']=2, ['qty']=5})

    -- setup global access to state
    GVanguardState = self

    vStateMachine:change('redraw', self.fields)
end

function VanguardState:update(dt)
    vStateMachine:update(dt)
end

function VanguardState:render()
    vStateMachine:render()
end
