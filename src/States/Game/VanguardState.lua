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
    -- draw initial 5 cards -- needs netcode tuneup
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

-- a powerful multipurpose function that moves a card
-- from a given location at a given index, to another specified location, at at an option index
function VanguardState:moveCard(request)
	-- setup variables
	local _field = request._field 
	local _inputTable = request._inputTable
	local _inputIndex = request._inputIndex
	local _outputTable = request._outputTable
	local _outputIndex = request._outputIndex or false

	local _card

	-- get _card by removing it from the specified table index

	-- todo add ride deck and gzone
	if _inputTable == "hand" then
		_card = table.remove(self.fields[_field].hand, _inputIndex)
	
    elseif _inputTable == "deck" then
		_card = table.remove(self.fields[_field].deck, _inputIndex)
	
    elseif _inputTable == "drop" then
		_card = table.remove(self.fields[_field].drop, _inputIndex)

	elseif _inputTable == "bind" then
		_card = table.remove(self.fields[_field].bind, _inputIndex)

	elseif _inputTable == "trigger" then
		_card = table.remove(self.fields[_field].trigger, _inputIndex)

	elseif _inputTable == "order" then
		_card = table.remove(self.fields[_field].order, _inputIndex)

	elseif _inputTable == "damage" then
		_card = table.remove(self.fields[_field].damage, _inputIndex)

	elseif _inputTable == "guard" then
		_card = table.remove(self.fields[_field].guard, _inputIndex)

	elseif _inputTable == "soul" then
		_card = table.remove(self.fields[_field].soul, _inputIndex)

	elseif _inputTable == "vanguard" then
		_card = table.remove(self.fields[_field].vanguard, _inputIndex)

	elseif _inputTable == "rearguard" then
		_card = table.remove(self.fields[_field].rearguard, _inputIndex)

	-- insert front/back row, ect here
	end

	-- move _card to it's destination
    -- using a fancier method
    local _output = "self.fields[" .. _field .. "]." .. _outputTable 
    if _outputIndex then
        table.insert(_output, _outputIndex, _card)
    else
        table.insert(_output, _card)
    end
end
