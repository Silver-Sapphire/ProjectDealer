MainPhaseState = Class{__includes = BaseState}

function MainPhaseState:enter(pass)
    self.fields = pass.fields
    self.turnPlayer = pass.turnPlayer
    local turnPlayer = pass.turnPlayer

    Event.dispatch('begin-main')
    Event.dispatch('check-timing')-- c.t. associated with play timing

    -- turn player gets a play timing
    if turnPlayer == 1 then
        local actions = {}
        if #self.fields[1].hand > 0 then
            local action = {
                text = 'Call',
                onSelect = function()
                    -- pull up call menu
                    local callableCards = self:determineCallableCards()
                    self:createCallMenu(callableCards)
                end
            }
            table.insert(actions, action)
        end

        -- if rightC > 0 or leftC > 0 then
            local action = {
                text = "Move Units", 
                onSelect = function()
                    self:createMoveMenu()
                end
            }
            table.insert(actions, action)
        -- end

        if self.fields[turnPlayer].turn ~= 1 then
            local action = {
                text = "Battle",
                onSelect = function()
                    -- confirmation menu here
                    gStateStack:pop()
                    vStateMachine:change('battle', pass)
                end
            }
            table.insert(actions, action)
        -- skip the first battle phase
        else
            local action = {
                text = "End Turn",
                onSelect = function()
                    -- confirmation menu here
                    gStateStack:pop()
                    vStateMachine:change('end', pass)
                end
            }
            table.insert(actions, action)
        end
        -- TODO insert ACT skills into actions menu

        -- TODO move units

        gStateStack:push(MenuState(Menu{
            font = gFonts['medium'],
            text = 'Actions:',
            items = actions,

            x = VIRTUAL_WIDTH/32,
            y = VIRTUAL_HEIGHT*5/8,
            width = VIRTUAL_WIDTH/3,
            height = VIRTUAL_HEIGHT*3/8
        }))
    else -- allow opponent a play timing
        self:processAI()
        vStateMachine:change('battle', pass)
    end
end

function MainPhaseState:render()
    -- draw fields
    for k, field in pairs(self.fields) do
        field:render()
    end
    -- highlight current phase
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(0,1,0,1) -- green
    -- TODO turn color red for opponents turn
    love.graphics.printf('Main', 0, VIRTUAL_HEIGHT/2 + PHASE_TEXT_GAP, VIRTUAL_WIDTH, 'right')
end

function MainPhaseState:determineCallableCards()
    local options = {}
    -- todo make work for both players
    local _vGrade = self.fields[self.turnPlayer].circles.vanguard.units[1].grade
    for i=1, #self.fields[self.turnPlayer].hand do
        local _card = self.fields[self.turnPlayer].hand[i]
        if _card.grade <= _vGrade then
            local option = {
                card = _card,
                player = self.turnPlayer,
                table = 'hand',
                index = i
            }
            table.insert(options, option)
        end
    end
    local option = {
        text = 'Done',
        onSelect = function()
            -- a pop to return to actions menu
            -- gStateStack:pop()
        end
    }
    
    table.insert(options, option)
    return options
end

function MainPhaseState:createCallMenu(options)
    gStateStack:push(MenuState(Menu{
        orientation = 'horizontal',
        text = 'Select a card to Call to R',
        font = gFonts['medium'],
        areCards = true,

        items = options,

        x = VIRTUAL_WIDTH/4,
        y = VIRTUAL_HEIGHT*3/4,
        width = VIRTUAL_WIDTH/2,
        height = VIRTUAL_HEIGHT/4,

        onSubmitFunction = function (selection)
            if selection[1].card then
                gStateStack:push(MenuState(Menu{
                    orientation = 'vertical',
                    font = gFonts['medium'],

                    items = self:chooseCircle(selection[1]),

                    x = VIRTUAL_WIDTH/32,
                    y = VIRTUAL_HEIGHT/4,
                    width = VIRTUAL_WIDTH/4,
                    height = VIRTUAL_HEIGHT/2,
                    onSubmitFunction = function()
                        -- this menu is popped by the item,
                        -- so we pop the call menu here and reinstatiate it without the called card
                        gStateStack:pop()
                        Event.dispatch("check-timing") -- c.t. associated with play timing
                        local callableCards = self:determineCallableCards()
                        self:createCallMenu(callableCards)
                    end
                }))
            else
                gStateStack:pop()
            end
        end
    }))
end

--- TODO work with stochia free move grade 1
function MainPhaseState:createMoveMenu()
    local moves = {}
    -- determine if we have cards on R to swap
    local leftC = 0
    local rightC = 0
    for k, circle in pairs(self.fields[self.turnPlayer].circles) do
        if #circle.units > 0 then
            local column = circle.column
            if column == "left" then
                leftC = leftC + 1
            elseif column == "right" then
                rightC = rightC + 1
            end
        end
    end

    -- create a swap event in a column, if theres units in it
    if leftC > 0 then
        local move = {
            text = "Left Swap",
            onSelect = function ()
                Event.dispatch("swap-left", self.turnPlayer)
                gStateStack:pop()
            end
        }
        table.insert(moves, move)
    end
    if rightC > 0 then
        local move = {
            text = "Right Swap",
            onSelect = function ()
                Event.dispatch("swap-right", self.turnPlayer)
                gStateStack:pop()
            end
        }
        table.insert(moves, move)
    end

    -- ... or not
    local move = {
        text = "Cancel",
        onSelect = function ()
            gStateStack:pop()
        end
    }
    table.insert(moves, move)

    local moveMenu = CraftMenu("medium-2", moves)
    gStateStack:push(MenuState(moveMenu))
end

function MainPhaseState:processAI()
    -- AI currently only cards cards, and doesn't move them or use skills
    -- The AI is desighned to play reactivly, and wait for the opponent to call rears,
    -- so it can then swing at them to try and build tempo. Only goes aggro when the opponent is at 4/5 dmg
    
    -- check to see how many R's the op has
    local opAtkTargets = 0
    for k, circle in pairs(self.fields[1].circles) do
        if circle.row == "front" and #circle.units > 1 then
            opAtkTargets = opAtkTargets + 1
        end
    end

    -- decide how many attacks were going to make
    local opDmg = #self.fields[1].damage
    local aiDmg = #self.fields[2].damage

    local opHandAmt = #self.fields[1].hand
    local aiHand = self.fields[2].hand

    local potentialBeaters = {}
    local potentialBoosters = {}
    local desperationCalls = {}
    -- determing which cards are reasonable to call
    for k, card in pairs(aiHand) do
        if card.grade == 1 and not card.sentinel then
            table.insert(potentialBoosters, card)
        elseif card.grade > 1 then
            table.insert(potentialBeaters, card)
        else
            table.insert(desperationCalls, card)
        end
    end

    local aiAtks = 0
    for k, circle in pairs(self.fields[2].circles) do
        if #circle.units > 1 then
            aiAtks = aiAtks + 1
        end
    end

    -- determing cards in hand to call

    if opDmg < 4 and aiDmg < 4 then -- if were not in the late game...

    elseif opDmg == 4 or aiDmg == 4 then -- late game desiction making...

    else -- 5 dmg means we push for game

    end
end
