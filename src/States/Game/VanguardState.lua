-- a state for our state stack designed to encapsulate
-- a state machine representing a game of CFV
VanguardState = Class{__includes = BaseState}

function VanguardState:enter()
    -- a global flag to represent the end of the game
    GameOver = false
    Standby = {}
    -- the number of states under the game (to maintain whatever menu was underneath (options, deckbuilding, ect.))
    self.numHeldStates = #gStateStack - 1
    -- setup a state machine for keeing track of game phases
    vStateMachine = StateMachine {
        -- pre-game/setup
        ['rps'] = function() return RPSState() end,
        ['redraw'] = function() return RedrawState() end,
        ['stand-up'] = function() return StandUpState() end,
        -- phases
        ['stand'] = function() return StandPhaseState() end,
        ['draw'] = function() return DrawPhaseState() end,
        ['ride'] = function() return RidePhaseState() end,
        ['main'] = function() return MainPhaseState() end,
        ['battle'] = function() return BattlePhaseState() end,
        ['end'] = function() return EndPhaseState() end,
        -- attack sub phase
        ['start'] = function() return StartStep() end,
        ['attack'] = function() return AttackStep() end,
        ['guard'] = function() return GuardStep() end,
        ['drive'] = function() return DriveStep() end,
        ['damage'] = function() return DamageStep() end,
        ['close'] = function() return CloseStep() end,
        -- game summary/log (win/lose state)
        ['results'] = function() return ResultsState() end
    }    
    -- setup stand/draw, ect event handlers
    -- self:settupEvents() -- now in self:init

    for k, handler in pairs(self.handlers) do
        if not handler.isRegistered then
            handler.register(handler)
        end
    end

    _DECKLIST = shuffle(MakeDeck())
    for k, card in pairs(_DECKLIST) do
        card.player = 1 
    end

    _DECKLIST2 = shuffle(MakeDeck())
    for k, card in pairs(_DECKLIST2) do
        card.player = 2 
    end
    -- initialize boards
    self.fields = {}
    -- local player [1]       --decklist, flip, player
    local player1Field = Field(_DECKLIST, false, 1)
    table.insert(self.fields, player1Field)
    -- peer player [2]
    local player2Field = Field(_DECKLIST2, true, 2)
    table.insert(self.fields, player2Field)

    ------- DEBUG LINES ------------
    ---- dmg rendering debug
    for i = 1, 3 do
        local card
        if i%2 == 0 then
            card = Card(CARD_IDS['test-crit'])
        else
            card = Card(CARD_IDS['test-heal'])
        end
        table.insert(self.fields[1].damage, card)
        table.insert(self.fields[2].damage, card)
    end
    --------
    vStateMachine:change('rps', self.fields)
end

function VanguardState:update(dt)
    vStateMachine:update(dt)
end

function VanguardState:render()
    vStateMachine:render()
end

function VanguardState:pushTriggerMenu(player, effects, text_) --effects = {type, callback}
    local unitOptions = {}
    for k, circle in pairs(self.fields[player].circles) do
        if #circle.units > 0 then
            -- for i = 1, #circle.units do
            local option = { -- TODO work with legion?? maybe
                card = circle.units[1],
                player = player,
                table = k,
                index = 1
            }
            table.insert(unitOptions, option)
        end
    end
    local tMenu = CraftMenu('medium', unitOptions, effects)
    -- tMenu.selection.text = "Select a unit to give the ".. effects.type .." trigger effects to. "--(" .. effects.power..")"
    tMenu.selection.text = text_
    tMenu.areCards = true

    gStateStack:push(MenuState(tMenu))
end

------ EVENT HANDLERS ------
function VanguardState:init()
    self.handlers = {}
    -- setup game actions, with self discriptive name
    local DrawHandler = DrawHandler or Event.on('draw', function(t)
        for i = 1, t.qty do
            if #self.fields[t.player].deck ~= 0 then
                local _ = table.remove(self.fields[t.player].deck)
                table.insert(self.fields[t.player].hand, _)
            else
                Event.dispatch('game-over', {['player']=t.player,
                                             ['cause']="deckout"} )
            end
        end
    end)
    table.insert(self.handlers, DrawHandler)
    
    local RideHandler = RideHandler or Event.on('ride', function (selection)
        -- move selected card to V
        self:moveCard({
            _field = selection.player,
            _inputTable = selection.table,
            _inputIndex = selection.index,

            _outputTable = "vanguard"
            -- output to end of table implied
        })

        -- move older vanguard unit to soul
        self:moveCard({
            _field = selection.player,
            _inputTable = "vanguard",
            _inputIndex = 1,

            _outputTable = "soul"
            -- output to end of table implied
        })
    end)
    table.insert(self.handlers, RideHandler)

    local CallHandler = CallHandler or Event.on('call', function(units)
        -- TODO make work with call to open R AND skills that call to any R
    end)
    table.insert(self.handlers, CallHandler)

    local StandHandler = StandHandler or Event.on('stand', function(unit)
        unit.state = "stand"
        --animate
    end)
    table.insert(self.handlers, StandHandler)

    local RestHandler = RestHandler or Event.on('rest', function(unit)
        unit.state = "rest"
        ---and here
    end)
    table.insert(self.handlers, RestHandler)

    local TurnCritHandler = TurnCritHandler or Event.on('turn-crit', function(unit, amt) --{unit, crit}
        if not unit then 
            return false
        end
        unit.crit = unit.crit + amt
    end)
    table.insert(self.handlers, TurnCritHandler)

    local TurnBoostHandler = TurnBoostHandler or Event.on('turn-boost', function(unit, power) -- {unit, power}
        -- local unit = request.unit
        if not unit then 
            return false
        end
        unit.turnBoost = unit.turnBoost + power
        unit.currentPower = unit.currentPower + power
    end)
    table.insert(self.handlers, TurnBoostHandler)

    local BattleBoostHandler = BattleBoostHandler or Event.on('battle-boost', function(request) -- {unit, power}
        request.attacker.battleBoost = request.attacker.battleBoost + request.power
    end)
    table.insert(self.handlers, BattleBoostHandler)

    local CritTriggerHandler = CritTriggerHandler or Event.on('crit-trigger', function(card_, type_)
        local player = card_.player        
        local finishDispatch = type_.."-check-finish"

        if player == 1 then
            local critMenu1Callback = function(selection)
                -- setup the 2nd menu
                local unitPass = selection[1].card
                -- set up crit effects for our menu
                local callbackP = function() 
                    Event.dispatch('turn-boost', unitPass, 10)
                end
    
                local callbackC = function() 
                    Event.dispatch('turn-crit', unitPass, CRITCONS)
                end
    
                local menu2effects = {
                    {
                        text = 'Both',
                        callback = function()
                            callbackP()
                            callbackC()
                        end
                    },
                    {
                        text = 'Power +10',
                        callback = callbackP
                    },
                    {
                        text = 'Crit +1',
                        callback = callbackC
                    },
                    {
                        text = 'Cancel',
                        callback = function()
                            -- pops in other callback
                        end
                    }
                }
                local callback2 = function(selections)
                    for k, selection in pairs(selections) do
                        local key = selection.text
                        if key == 'Power +10' then
                            selection.callback()
                            -- push another menu for crit gain  
                            gStateStack:pop()
                            local lastCall = function()
                                gStateStack:pop()
                                gStateStack:pop()
                                callbackC()
                                local finishDispatch = type_.."-check-finish"
                                Event.dispatch(finishDispatch, player)
                            end
                            self:pushTriggerMenu(player, lastCall, "And the crit?")

                        elseif key == 'Crit +1' then
                            selection.callback()
                            -- push another menu for power gain 
                            gStateStack:pop()
                            local lastCall = function()
                                gStateStack:pop()
                                gStateStack:pop()
                                callbackP()
                                local finishDispatch = type_.."-check-finish"
                                Event.dispatch(finishDispatch, player)
                            end
                            self:pushTriggerMenu(player, lastCall, "And the power?")

                        elseif key == 'Both' then 
                            selection.callback()
                            gStateStack:pop()
                            gStateStack:pop()
                            local finishDispatch = type_.."-check-finish"
                            Event.dispatch(finishDispatch, player)

                        else -- cancel
                            gStateStack:pop()
                            -- return to unit menu
                        end
                    end
                end
                local critMenu2 = CraftMenu('small', menu2effects, callback2)
                critMenu2.selection.areCards = true -- not cards, but we need the functionallity (since the first menu was cards)
                gStateStack:push(MenuState(critMenu2))
            end

            self:pushTriggerMenu(player, critMenu1Callback, "Who will gain the effects?")
        else
            -- AI / P2 
            Event.dispatch(finishDispatch, player)
        end
    end)
    table.insert(self.handlers, CritTriggerHandler)

    local HealHandler = HealHandler or Event.on('heal', function(player)
        -- TODO turn into menu instead of auto
        if #self.fields[player].damage > 0 then
            self:moveCard({
                _field = player,
                _inputTable = "damage",

                _outputTable = "drop"
            })
        end
    end)
    table.insert(self.handlers, HealHandler)

    local HealTriggerHandler = HealTriggerHandler or Event.on('heal-trigger', function(card_, type_)
        local player = card_.player
        --recover 1
        Event.dispatch('heal', player)
        local finishDispatch = type_.."-check-finish"

        if player == 1 then
            -- heal power menu
            local callback = function(selection)
                gStateStack:pop()
                Event.dispatch('turn-boost', selection[1].card, 0) -- TODO base off heal trigger instead of magic #
                Event.dispatch(finishDispatch, player)
            end
            self:pushTriggerMenu(player, callback, "Who will get the power?")
        else -- AI / P2
            Event.dispatch(finishDispatch, player)
        end
    end)
    table.insert(self.handlers, HealTriggerHandler)

    local TriggerCheckHandler = TriggerCheckHandler or Event.on('trigger-check', function(type_, player)
        -- TODO animation
        local check = self:moveCard({
            _field = player,
            _inputTable = "deck",

            _outputTable = "trigger"
        })
        if check then
            local trigger = check.trigger
            if trigger then
                -- wait for menu selection to continue after a trigger is revealed
                local triggerDispatch = trigger.."-trigger"
                CheckText = triggerDispatch
                table.insert(Checks, CheckText)
                Event.dispatch(triggerDispatch, check, type_)-- TODO fix magic #
            else
                -- finish trigger check if no trigger
                local triggerDispatch = type_ .."-check-finish"
                Event.dispatch(triggerDispatch, player)
            end
        end
    end)
    table.insert(self.handlers, TriggerCheckHandler)

    local DamageCheckHandler = DamageCheckHandler or Event.on('damage-check', function(player) 
        Event.dispatch("trigger-check", "damage", player)
        Event.dispatch("check-timing")
    end)
    table.insert(self.handlers, DamageCheckHandler)

    local DamageCheckFinishHandler = DamageCheckFinishHandler or Event.on('damage-check-finish', function (player)
        self:moveCard({
            _field = player,
            _inputTable = "trigger",

            _outputTable = "damage"
        })
        Event.dispatch("check-timing") -- check timing just to see if the player lost. needs tuneup
    end)
    table.insert(self.handlers, DamageCheckFinishHandler)

    local RetireHandler = RetireHandler or Event.on("retire", function(unit)
        self:moveCard({
            _field = unit.player,
            _inputTable = unit.table,
            _inputIndex = 1,

            _outputTable = "drop"
        })
        Event.dispatch("retired", unit)
    end)
    table.insert(self.handlers, RetireHandler)

    local RetiredHandler = RetiredHandler or Event.on("retired", function(unit)
        --
    end)
    table.insert(self.handlers, RetiredHandler)

    local GameOverHandler = GameOverHandler or Event.on("game-over", function(pass)
        local finalPass = pass
        finalPass.fields = self.fields
        --finalPass.log = self.log
        GameOver = true -- cringe global
        vStateMachine:change('results', finalPass)
    end)
    table.insert(self.handlers, GameOverHandler)
  
    local CheckTimingHandler = CheckTimingHandler or Event.on("check-timing", function()
        -- resolve all rule actions ---------------
        for i = 1, 2 do
            -- check to see if a player lost the game
            if #self.fields[i].damage > 5 then -- TODO work with greedun
                Event.dispatch('game-over', {['player'] = i,
                                                ['cause'] = "lethal"} )
                break
            elseif #self.fields[i].deck == 0 then
                Event.dispatch('game-over', {['player'] = i,
                                                ['cause'] = "deckout"} )
                break
            end
            -- retire R that were called over
            for k, circle in pairs(self.fields[i].circles) do
                if #circle.units > 1 then
                    if #circle.units == 2 then
                        local unit = circle.units[1]
                        unit.table = k
                        unit.index = 1
                        Event.dispatch("retire", unit)
                    else -- if more than 1 card were called over something, the player picks one to keep
                        
                        -- After re-reading the rules, this should never happen. I was cheating for years,
                        -- but you /would/ chose the order in which they were called (affecting the one you keep)
                        -- and prock both call events
                    end
                end
            end
        end

        -- turn player imaginary gift resolution----------
        -- resolve all rule actions

        -- nonturn player imaginary gift resolution---------
        -- resolve all rule actions
        
        -- turn player auto skill resolution-------------
        -- resolve all rule actions
        
        -- nonturn player auto skill resolution----------
        -- resolve all rule actions
    end)
    table.insert(self.handlers, CheckTimingHandler)

    local RecursiveCheckTimingHandler = RecursiveCheckTimingHandler or Event.on("recursive-check-timing", function(event, callback)
        Event.dispatch(event)
        Event.dispatch("check-timing")
        -- self:checkTiming()
        callback()
        Event.dispatch(event)
        if #Standby > 0 then
            Event.dispatch("recursive-check-timing", event, callback)
            -- self:recursiveCheckTiming(event, callback)
        end
    end)    
    table.insert(self.handlers, RecursiveCheckTimingHandler)

    local SwapHandler = SwapHandler or Event.on("swap", function(circles)
        -- if #circles ~= then 2 return false end
        -- local _ = circles[1].
    end)
    table.insert(self.handlers, SwapHandler)
    
    local SwapLeftHandler = SwapLeftHandler or Event.on("swap-left", function(player)
        
    end)
    table.insert(self.handlers, SwapLeftHandler)
    
    local SwapRightHandler = SwapRightHandler or Event.on("swap-right", function(player)
        
    end)
    table.insert(self.handlers, SwapRightHandler)
end

function VanguardState:exit()
    for k, handler in pairs(self.handlers) do
        handler:remove(handler)
        handler = nil
    end
end
