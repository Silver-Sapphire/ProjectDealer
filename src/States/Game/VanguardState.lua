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

    -- setup game actions, with self discriptive name
    Event.on('draw', function()
        local _ = table.remove(self.fields[1].deck)
        table.insert(self.fields[1].hand, _)
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
    _DECKLIST2 = _DECKLIST
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
    local player2Field = Field(_DECKLIST2, true)
    table.insert(self.fields, player2Field)

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

function VanguardState:chooseCircle(_card)
    local circles = {
        {
            text = 'Front Left',
            onSelect = function()
                self:moveCard({
                    field = 1, -- needs to be dynamic
                    _inputTable = _card.table,
                    _inputIndex = _card.index,

                    _outputTable = self.fields[1].rearguard.frontLeft -- and here
                })
                gStateStack:pop()
            end
        },
        {
            text = 'Back Left',
            onSelect = function()
                self:moveCard({
                    field = 1, -- needs to be dynamic
                    _inputTable = _card.table,
                    _inputIndex = _card.index,

                    _outputTable = self.fields[1].rearguard.backLeft -- and here
                })
                gStateStack:pop()
            end
        },
        {
            text = 'Back Center',
            onSelect = function()
                self:moveCard({
                    field = 1, -- needs to be dynamic
                    _inputTable = _card.table,
                    _inputIndex = _card.index,

                    _outputTable = self.fields[1].rearguard.backCenter -- and here
                })
                gStateStack:pop()
            end
        },
        {
            text = 'Back Right',
            onSelect = function()
                self:moveCard({
                    field = 1, -- needs to be dynamic
                    _inputTable = _card.table,
                    _inputIndex = _card.index,

                    _outputTable = self.fields[1].rearguard.backRight -- and here
                })
            gStateStack:pop()
            end
        },
        {
            text = 'Front Right',
            onSelect = function()
                self:moveCard({
                    field = 1, -- needs to be dynamic
                    _inputTable = _card.table,
                    _inputIndex = _card.index,

                    _outputTable = self.fields[1].rearguard.fronRight -- and here
                })
                gStateStack:pop()
            end
        },
        {
            text = 'Cancel',
            onSelect = function()
                gStateStack:pop()
            end
        }
    }
    return circles
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
    -- -- using a fancier method
    -- local _output = "self.fields[" .. _field .. "]." .. _outputTable
    -- if _outputIndex then
    --     table.insert(_output, _outputIndex, _card)
    -- else
    --     table.insert(_output, _card)
    -- end
    --Fancier method failed, because you can't directly index a table via string.
    --TODO find a way to access a table via string?

    if _outputTable == "hand" then
        if _outputIndex then
            table.insert(self.fields[_field].hand, _outputIndex, _card)
        else
            table.insert(self.fields[_field].hand, _card)
        end
    elseif _outputTable == "deck" then
        if _outputIndex then
            table.insert(self.fields[_field].deck, _outputIndex, _card)
        else
            table.insert(self.fields[_field].deck, _card)
        end
    elseif _outputTable == "drop" then
        if _outputIndex then
            table.insert(self.fields[_field].drop, _outputIndex, _card)
        else
            table.insert(self.fields[_field].drop, _card)
        end
	elseif _outputTable == "bind" then
        if _outputIndex then
            table.insert(self.fields[_field].bind, _outputIndex, _card)
        else
            table.insert(self.fields[_field].bind, _card)
        end
	elseif _outputTable == "trigger" then
        if _outputIndex then
            table.insert(self.fields[_field].trigger, _outputIndex, _card)
        else
            table.insert(self.fields[_field].trigger, _card)
        end
	elseif _outputTable == "order" then
        if _outputIndex then
            table.insert(self.fields[_field].order, _outputIndex, _card)
        else
            table.insert(self.fields[_field].order, _card)
        end
	elseif _outputTable == "damage" then
        if _outputIndex then
            table.insert(self.fields[_field].damage, _outputIndex, _card)
        else
            table.insert(self.fields[_field].damage, _card)
        end
	elseif _outputTable == "guard" then
        if _outputIndex then
            table.insert(self.fields[_field].guard, _outputIndex, _card)
        else
            table.insert(self.fields[_field].guard, _card)
        end
	elseif _outputTable == "soul" then
        if _outputIndex then
            table.insert(self.fields[_field].soul, _outputIndex, _card)
        else
            table.insert(self.fields[_field].soul, _card)
        end
	elseif _outputTable == "vanguard" then
        if _outputIndex then
            table.insert(self.fields[_field].vanguard, _outputIndex, _card)
        else
            table.insert(self.fields[_field].vanguard, _card)
        end
	elseif _outputTable == "rearguard" then
        if _outputIndex then
            table.insert(self.fields[_field].rearguard, _outputIndex, _card)
        else
            table.insert(self.fields[_field].rearguard, _card)
        end
	-- insert front/back row, ect here
	end
end
