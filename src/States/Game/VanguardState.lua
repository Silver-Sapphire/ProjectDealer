-- a state for our state stack designed to encapsulate
-- a state machine representing a game of CFV
VanguardState = Class{__includes = BaseState}

function VanguardState:enter()

    -- setup a state machine for keeing track of game phases
    vStateMachine = StateMachine {
        ['RPS'] = function() return RPSState() end,
        ['redraw'] = function() return RedrawState() end,
        ['stand-up'] = function() return StandUpState() end,

        ['stand'] = function() return StandPhaseState() end,
        ['draw'] = function() return DrawPhaseState() end,
        ['ride'] = function() return RidePhaseState() end,
        ['main'] = function() return MainPhaseState() end,
        ['battle'] = function() return BattlePhaseState() end,
        ['end'] = function() return EndPhaseState() end
    }    
    -- setup stand/draw, ect event handlers
    -- self:settupEvents() -- now in self:init

    _DECKLIST = shuffle(MakeDeck())
    _DECKLIST2 = shuffle(MakeDeck())
    -- initialize boards
    self.fields = {}
    -- local player [1]       --decklist, flip, player
    local player1Field = Field(_DECKLIST, false, 1)
    table.insert(self.fields, player1Field)
    -- peer player [2]
    local player2Field = Field(_DECKLIST2, true, 2)
    table.insert(self.fields, player2Field)

    -- setup global access to state
    -- GVanguardState = self

    vStateMachine:change('RPS', self.fields)
end

function VanguardState:update(dt)
    vStateMachine:update(dt)
end

function VanguardState:render()
    vStateMachine:render()
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
        request.unit.turnBoost = request.unit.turnBoost + request.power
    end)

    Event.on('battle-boost', function(request) -- {unit, power}
        request.attacker.battleBoost = request.attacker.battleBoost + request.power
    end)

    Event.on('critical-trigger', function(player, power)
        if player == 1 then
            -- set up crit effects for our menu
            local callbackP = function(unit) 
                Event.dispatch('turn-boost', {unit, power})
            end

            local callbackC = function(unit) 
                Event.dispatch('turn-boost', {unit, CRITCONS})
            end

            local effects = {
                ['both'] = {
                    text = 'Both',
                    callback = function(unit)
                        callbackP(unit)
                        callbackC(unit)
                    end
                },
                ['power'] = {
                    text = 'Power +'..power,
                    callback = callbackP
                },
                ['crit'] = {
                    text = 'Crit + 1',
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
                local unitPass = selection[1]
                
                local callback = function(selection)
                    for key, selection in pairs(selections) do
                        if key == 'power' then
                            selection.callback(unitPass)
                            -- push another menu for crit gain
                            gStateStack:pop()
                            gStateStack:pop()
                            self:pushTriggerMenu(player, callbackC)

                        elseif key == 'crit' then
                            selection.callback(unitPass)
                            -- push another menu for power gain   
                            gStateStack:pop()
                            gStateStack:pop()
                            self:pushTriggerMenu(player, callbackP)

                        elseif key == 'both' then 
                            selection.callback(unitPass)
                            gStateStack:pop()
                            gStateStack:pop()

                        else -- cancel
                            gStateStack:pop()
                        end
                    end
                end

                local critMenu2 = CraftMenu('small', effects, callback)
                gStateStack:push(MenuState(critMenu2))
            end

            self:pushTriggerMenu(player, critMenu1Callback)
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

    Event.on('heal-trigger', function(player, power)
        --recover 1
        Event.dispatch('heal', player)

        if player == 1 then
            -- heal power menu
            local effectCallback = function(selection)
                Event.dispatch('turn-boost', {selection[1].unit, 10}) -- TODO base off heal trigger instead of magic #
            end
            self:pushTriggerMenu(player, effectCallback)
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

        local trigger = check.trigger
        if trigger then
            local triggerDispatch = "".. trigger.."-trigger"
            Event.dispatch(triggerDispatch, {player, 10})-- TODO fix magic #
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
end

function VanguardState:pushTriggerMenu(player, effects) --effects = {type, callback}
    local options = {}
    for k, circle in pairs(self.fields[player].circles) do
        if #circle.units > 0 then
            -- for i = 1, #circle.units do
            local option = { -- TODO work with legion?? maybe
                card = circle.units[1],
                player = player,
                table = k,
                index = 1
            }
            table.insert(options, option)
        end
    end
    local tMenu = CraftMenu('medium', options, effects.callback)
    tMenu.selection.text = "Select a unit to give the ".. effects.type .." trigger effects to. "--(" .. effects.power..")"
    tMenu.areCards = true

    gStateStack:push(MenuState(tMenu))
end
