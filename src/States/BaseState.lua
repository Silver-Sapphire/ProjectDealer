--[[
    GD50
    Match-3 Remake

    -- BaseState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Used as the base class for all of our states, so we don't have to
    define empty methods in each of them. StateMachine requires each
    State have a set of four "interface" methods that it can reliably call,
    so by inheriting from this base state, our State classes will all have
    at least empty versions of these methods even if we don't define them
    ourselves in the actual classes.
]]

BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end

-- the rest of the behaviour got used in almost every state, so putting it here seemed fitting
function BaseState:update(dt)
    if self.fields then
        for k, field in pairs(self.fields) do
            field:update(dt)
        end
    end
end

function BaseState:render()
    for k, field in pairs(self.fields) do
        field:render()
    end
end

-- -- functions we want for all our vanguard game states    
function BaseState:chooseCircle(_card)
    local circles = {
        {
            text = 'Front Left',
            onSelect = function()
                self:moveCard({
                    _field = _card.player,
                    _inputTable = _card.table,
                    _inputIndex = _card.index,

                    _outputTable = "frontLeft"
                })
                gStateStack:pop()
            end
        },
        {
            text = 'Back Left',
            onSelect = function()
                self:moveCard({
                    _field = _card.player,
                    _inputTable = _card.table,
                    _inputIndex = _card.index,

                    _outputTable = "backLeft"
                })
                gStateStack:pop()
            end
        },
        {
            text = 'Back Center',
            onSelect = function()
                self:moveCard({
                    _field = _card.player,
                    _inputTable = _card.table,
                    _inputIndex = _card.index,

                    _outputTable = "backCenter"
                })
                gStateStack:pop()
            end
        },
        {
            text = 'Back Right',
            onSelect = function()
                self:moveCard({
                    _field = _card.player,
                    _inputTable = _card.table,
                    _inputIndex = _card.index,

                    _outputTable = "backRight"
                })
            gStateStack:pop()
            end
        },
        {
            text = 'Front Right',
            onSelect = function()
                self:moveCard({
                    _field = _card.player,
                    _inputTable = _card.table,
                    _inputIndex = _card.index,

                    _outputTable = "frontRight"
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

-- function BseState:chooseOpenCircle(_card) end

function BaseState:determinePossibleAttacks(player)
    local possibleAttacks = {}
    for key, circle in pairs(self.fields[player].circles) do
        if circle.row == "front" and #circle.units > 0 then
            unit_ = circle.units[1] -- TODO change to stand with card ovehaul
            if unit_.state == "stand" and not unit_.cantAtk then
                local atk = {
                    ['card'] = unit_,
                    ['player'] = player,
                    ['circle'] = circle,
                    ['table'] = key,
                    ['index'] = 1
                }
                table.insert(possibleAttacks, atk)
            end
        end
    end
    return possibleAttacks
end

function BaseState:findBooster(attacker)
    local atkrCircle = attacker.circle
    local column = attacker.circle.column
    -- determine atkr column
    -- for k, circle in pairs(self.fields[attacker.player].circles) do
    --     if k == atkrCircle then
    --         column = circle.column
    --     end
    -- end

    for k, circle in pairs(self.fields[attacker.player].circles) do
        if circle.row == "back" and circle.column == column and #circle.units > 0 then
            if circle.units[1].ability == "boost" then
                return {
                    card = circle.units[1],
                    player = attacker.player,
                    circle = circle, 
                    table_ = k
                }
            end
        end
    end
end

-- a function that finds a list of cards in a z|one, to be later screened for target viability
-- function BaseState:findTargets(z ones)
--     local targets = {}
--     for table_, z one in pairs(z ones) do

--     end
-- end

-- a powerful multipurpose function that moves a card
-- from a given location at a given index, to another specified location, at at an option index
function BaseState:moveCard(request)
	-- setup variables
	local _field = request._field
    
	local _inputTable = request._inputTable
	local _inputIndex = request._inputIndex

	local _outputTable = request._outputTable
	local _outputIndex = request._outputIndex or false

	local _card

	-- get _card by removing it from the specified table index

	-- todo add ride deck and g z one
	if _inputTable == "hand" then
		_card = table.remove(self.fields[_field].hand, _inputIndex)
	
    elseif _inputTable == "deck" then
        if _inputIndex then
            _card = table.remove(self.fields[_field].deck, _inputIndex)
        else
            _card = table.remove(self.fields[_field].deck)
        end

    elseif _inputTable == "drop" then
		_card = table.remove(self.fields[_field].drop, _inputIndex)

	elseif _inputTable == "bind" then
		_card = table.remove(self.fields[_field].bind, _inputIndex)

	elseif _inputTable == "trigger" then
        -- if _inputIndex then
        --     _card = table.remove(self.fields[_field].trigger, _inputIndex)
        -- else
            _card = table.remove(self.fields[_field].trigger)
        -- end

	elseif _inputTable == "order" then
        if _inputIndex then
            _card = table.remove(self.fields[_field].order, _inputIndex)
        else
            _card = table.remove(self.fields[_field].order)
        end
        
	elseif _inputTable == "damage" then
        if _inputIndex then
            _card = table.remove(self.fields[_field].damage, _inputIndex)
        else
            _card = table.remove(self.fields[_field].damage)
        end

	elseif _inputTable == "soul" then
		_card = table.remove(self.fields[_field].soul, _inputIndex)

	elseif _inputTable == "guard" then
		_card = table.remove(self.fields[_field].circles.guardian.units, _inputIndex)

	elseif _inputTable == "vanguard" then
		_card = table.remove(self.fields[_field].circles.vanguard.units, _inputIndex)

	elseif _inputTable == "frontLeft" then
		_card = table.remove(self.fields[_field].circles.frontLeft.units, _inputIndex)
    
    elseif _inputTable == "backLeft" then
		_card = table.remove(self.fields[_field].circles.backLeft.units, _inputIndex)

    elseif _inputTable == "backCenter" then
		_card = table.remove(self.fields[_field].circles.backCenter.units, _inputIndex)

    elseif _inputTable == "backRight" then
		_card = table.remove(self.fields[_field].circles.backRight.units, _inputIndex)

    elseif _inputTable == "frontRight" then
		_card = table.remove(self.fields[_field].circles.frontRight.units, _inputIndex)
	
    elseif _inputTable == "accel" then
        _card = table.remove(self.fields[_field].circles.accel[_inputIndex].units, 1)
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
        -- if _outputIndex then
        --     table.insert(self.fields[_field].trigger, _outputIndex, _card)
        -- else
            table.insert(self.fields[_field].trigger, _card)
        -- end

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

	elseif _outputTable == "soul" then
        if _outputIndex then
            table.insert(self.fields[_field].soul, _outputIndex, _card)
        else
            table.insert(self.fields[_field].soul, _card)
        end

	elseif _outputTable == "guardian" then
        -- if _outputIndex then
        --     table.insert(self.fields[_field].circles.guardian, _outputIndex, _card)
        -- else
            table.insert(self.fields[_field].circles.guardian.units, _card)
        -- end

	elseif _outputTable == "vanguard" then
        -- if _outputIndex then
        --     table.insert(self.fields[_field].circles.vanguard, _outputIndex, _card)
        -- else
            table.insert(self.fields[_field].circles.vanguard.units, _card)
        -- end

    elseif _outputTable == "frontLeft" then
		table.insert(self.fields[_field].circles.frontLeft.units, _card)
    
    elseif _outputTable == "backLeft" then
		table.insert(self.fields[_field].circles.backLeft.units, _card)

    elseif _outputTable == "backCenter" then
		table.insert(self.fields[_field].circles.backCenter.units, _card)

    elseif _outputTable == "backRight" then
		table.insert(self.fields[_field].circles.backRight.units, _card)

    elseif _outputTable == "frontRight" then
		table.insert(self.fields[_field].circles.frontRight.units, _card)

    -- note: accel REQUIRES an output index (the circle #)
    elseif _outputTable == "accel" then
        table.insert(self.fields[_field].circles.accel[_outputIndex].units, _card)
    end
    return _card or false
end
--
-- function BaseState:checkTiming()
--     -- resolve all rule actions ---------------
--     for i = 1, 2 do
--         -- check to see if a player lost the game
--         if #self.fields[i].damage > 5 then -- TODO work with greedun
--             Event.dispatch('game-over', {['player'] = i,
--                                             ['cause'] = "lethal"} )
--             break
--         elseif #self.fields[i].deck == 0 then
--             Event.dispatch('game-over', {['player'] = i,
--                                             ['cause'] = "deckout"} )
--             break
--         end
--         -- retire R that were called over
--         for k, circle in pairs(self.fields[i].circles) do
--             if #circle.units > 1 then
--                 if #circle.units == 2 then
--                     local unit = circle.units[1]
--                     unit.table = k
--                     unit.index = 1
--                     Event.dispatch("retire", unit)
--                 else -- if more than 1 card were called over something, the player picks one to keep
                    
--                     -- After re-reading the rules, this should never happen. I was cheating for years,
--                     -- but you /would/ chose the order in which they were called (affecting the one you keep)
--                     -- and prock both call events
--                 end
--             end
--         end
--     end

--     -- turn player imaginary gift resolution----------
--     -- resolve all rule actions

--     -- nonturn player imaginary gift resolution---------
--     -- resolve all rule actions
    
--     -- turn player auto skill resolution-------------
--     -- resolve all rule actions
    
--     -- nonturn player auto skill resolution----------
--     -- resolve all rule actions
-- end

-- function BaseState:recursiveCheckTiming(event, callback)
--     Event.dispatch(event)
--     self:checkTiming()
--     callback()
--     Event.dispatch(event)
--     if #Standby > 0 then
--         self:recursiveCheckTiming(event, callback)
--     end
-- end
