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
        -- game summary /log (win/lose state)
        ['results'] = function() return ResultsState() end
    }    
    -- setup stand/draw, ect event handlers
    -- self:settupEvents() -- now in self:init

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
    -- dmg rendering debug
    -- for i = 1, 5 do
    --     local card
    --     if i%2 == 0 then
    --         card = Card(CARD_IDS['test-crit'])
    --     else
    --         card = Card(CARD_IDS['test-heal'])
    --     end
    --     table.insert(self.fields[1].damage, card)
    --     table.insert(self.fields[2].damage, card)
    -- end
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

function VanguardState:init()
    -- setup game actions, with self discriptive name
    Event.on('draw', function(t)
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
    
    Event.on('ride', function (selection)
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

    Event.on('call', function(units)
        -- TODO make work with call to open R AND skills that call to any R
    end)

    Event.on('stand', function(unit)
        unit.state = "stand"
        --animate
    end)

    Event.on('rest', function(unit)
        unit.state = "rest"
        ---and here
    end)

    Event.on('turn-crit', function(request) --{unit, crit}
        request.unit.crit = request.unit.crit + request.crit
    end)

    Event.on('turn-boost', function(request) -- {unit, power}
        local unit = request.unit
        unit.turnBoost = unit.turnBoost + request.power
        unit.currentPower = unit.currentPower + request.power
    end)

    Event.on('battle-boost', function(request) -- {unit, power}
        request.attacker.battleBoost = request.attacker.battleBoost + request.power
    end)

    Event.on('crit-trigger', function(card_)
        if player == 1 then
            -- set up crit effects for our menu
            local callbackP = function(unit) 
                Event.dispatch('turn-boost', {unit, power})
            end

            local callbackC = function(unit) 
                Event.dispatch('turn-boost', {unit, CRITCONS})
            end

            local menu2effects = {
                ['both'] = {
                    text = 'Both',
                    callback = function(unit)
                        callbackP(unit)
                        callbackC(unit)
                    end
                },
                ['power'] = {
                    text = 'Power +10',
                    callback = callbackP
                },
                ['crit'] = {
                    text = 'Crit +1',
                    callback = callbackC
                },
                ['cancel'] = {
                    text = 'Cancel',
                    callback = function()
                        -- pops in other callback
                    end
                }
            }

            local critMenu1Callback = function(selection)
                -- setup the 2nd menu
                local unitPass = selection[1]
                
                local callback = function(selections)
                    for key, selection in pairs(selections) do
                        if key == 'power' then
                            selection.callback(unitPass)
                            -- push another menu for crit gain
                            gStateStack:pop()
                            gStateStack:pop()
                            self:pushTriggerMenu(card_.player, callbackC, "And the crit?")

                        elseif key == 'crit' then
                            selection.callback(unitPass)
                            -- push another menu for power gain   
                            gStateStack:pop()
                            gStateStack:pop()
                            self:pushTriggerMenu(card_.player, callbackP, "And the power?")

                        elseif key == 'both' then 
                            selection.callback(unitPass)
                            gStateStack:pop()
                            gStateStack:pop()

                        else -- cancel
                            gStateStack:pop()
                            -- return to unit menu
                        end
                    end
                end
                cirtMenu2 = CraftMenu('small', effects, callback)
                critMenu2.areCards = true -- not cards, but we need the functionallity (since the first menu was cards)
                gStateStack:push(MenuState())
            end

            self:pushTriggerMenu(card_.player, critMenu1Callback, "Who will gain the effects?")
        else
            -- AI / P2 
            
        end
    end)

    Event.on('heal', function(player)
        -- TODO turn into menu instead of auto
        if #self.fields[player].damage > 0 then
            self:moveCard({
                _field = player,
                _inputTable = "damage",

                _outputTable = "drop"
            })
        end
    end)

    Event.on('heal-trigger', function(card_)
        local player = card_.player
        --recover 1
        Event.dispatch('heal', player)

        if player == 1 then
            -- heal power menu
            local callback = function(selection)
                gStateStack:pop()
                Event.dispatch('turn-boost', {unit=selection[1].card, power=10}) -- TODO base off heal trigger instead of magic #
            end
            self:pushTriggerMenu(player, callback, "Who will get the power?")
        else -- AI / P2

        end
    end)

    Event.on('trigger-check', function(player)
        -- TODO animation
        local check = self:moveCard({
            _field = player,
            _inputTable = "deck",

            _outputTable = "trigger"
        })
        if check then
            --debug line
            -- Check = true
            local trigger = check.trigger
            if trigger then
                Check = true
                local triggerDispatch = trigger.."-trigger"
                CheckText = triggerDispatch
                table.insert(Checks, CheckText)
                Event.dispatch(triggerDispatch, check)-- TODO fix magic #
            else
                Check = false
            end
        end
    end)

    Event.on('damage-check', function(player) 
        Event.dispatch("trigger-check", player)
        Event.dispatch("check-timing")

        self:moveCard({
            _field = player,
            _inputTable = "trigger",

            _outputTable = "damage"
        })
        Event.dispatch("check-timing") -- check timing just to see if the player lost. needs tuneup
    end)

    Event.on("retire", function(unit)
        self:moveCard({
            _field = unit.player,
            _inputTable = unit.table,
            _inputIndex = 1,

            _outputTable = "drop"
        })
        Event.dispatch("retired", unit)
    end)

    RetiredHandler = RetiredHandler or Event.on("retired", function(unit)
        --
    end)

    Event.on("game-over", function(pass)
        local finalPass = pass
        finalPass.fields = self.fields
        --finalPass.log = self.log
        GameOver = true -- cringe global
        vStateMachine:change('results', finalPass)
    end)




end
