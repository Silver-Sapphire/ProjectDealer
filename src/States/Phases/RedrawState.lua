RedrawState = Class{__includes = BaseState}

local function shuffle(deck)
    local shuffledDeck = {}
    local cardsToShuffle = deck

    -- put a random card from the old 'pile' and put it in the new one
    -- Hypothises: running this once and eleven times should be identicly random
    local timesToShuffle = 1
    
    for i=0, timesToShuffle do
        -- shuffling of deck here
        shuffledDeck = {}
        while #cardsToShuffle > 0 do
            -- remove a random card from an input table, and move it to the output table
            local _ = table.remove(cardsToShuffle, math.random(#cardsToShuffle))
            table.insert(shuffledDeck, _)
        end

        -- reset tables to shuffle again
        cardsToShuffle = shuffledDeck
    end

    return shuffledDeck
end

function RedrawState:init()
    -- redraw menu prototype, C style
    REDRAWMENU = function () end
    
    -- todo set starters from decks

    -- initialize and shuffle both players decks
    -- a deck making hack for prototyping
    DECKLIST = {}
    for i=1, 16 do
        table.insert(DECKLIST, {['grade'] = 0})
    end

    for i=1, 14 do
        table.insert(DECKLIST, {['grade'] = 1})
    end

    for i=1, 11 do
        table.insert(DECKLIST, {['grade'] = 2})
    end

    for i=1, 8 do
        table.insert(DECKLIST, {['grade'] = 3})
    end

    _DECKLIST = shuffle(DECKLIST)

    -- initialize boards
    self.fields = {}
    -- local player [1]
    local player1Field = Field(_DECKLIST, false)
    table.insert(self.fields, player1Field)
    -- peer player [2]
    local player2Field = Field(_DECKLIST, true)
    table.insert(self.fields, player2Field)

    -- local player draws 5? (done in feild currently)
    -- redraw menu
    REDRAWMENU = MenuSelectUpToN {
        mandatoryFlag = false,
        maxCount = #self.fields[1].hand,

        items = self.fields[1].hand,

        x = 0,
        y = VIRTUAL_HEIGHT*3/4,
        width = VIRTUAL_WIDTH/2,
        height = VIRTUAL_HEIGHT/4,

        onSubmitFunction = function (selections) 
            -- return selected cards
            local _indexAdjuster = 0
            for k, selectionIndex in pairs(selections) do
                -- the following line are debug code to address selection table indexing mis-matching
                selectionIndex = selectionIndex - _indexAdjuster
                _indexAdjuster = _indexAdjuster + 1
    
                -- cringe manual looping to expant itirater scope
                local _ = table.remove(self.fields[1].hand, selectionIndex)
                table.insert(self.fields[1].deck, 1, _)
            end
    
            -- draw to 5
            while #self.fields[1].hand < 5 do
                local _ = table.remove(self.fields[1].deck)
                table.insert(self.fields[1].hand, _)
            end
    
            -- TODO shuffle deck
            --self.fields.player1Field.deck:shuffle()
    
            -- TODO dispatch prepared event to server
            --gEvent.dispatch:redraw(#selections)
    
            -- proceed to rest of game
            vStateMachine:change('ride', self.fields)
                    
            -- _REDRAWMENU = REDRAWMENU
            -- self.redrawMenu = _REDRAWMENU
        end
    }
    
    _REDRAWMENU = REDRAWMENU
    self.redrawMenu = _REDRAWMENU
end

function RedrawState:update(dt)
    -- players each redraw, in turn order

        -- push selection menu to local player

            -- wait for and submit local player's decision

    -- debug state pop
    if love.keyboard.isDown('m') then
        gStateStack:pop()
    end

    for k, field in pairs(self.fields) do
        field:update(dt)
    end

    if self.redrawMenu then 
        self.redrawMenu:update(dt)
    end
end

function RedrawState:render()
    -- draw fields
    for k, field in pairs(self.fields) do
        field:render()
    end

    -- draw gui
    love.graphics.print('Select cards to redraw w/enter, and submit w/space', 36, VIRTUAL_HEIGHT*3/4)
    if self.redrawMenu then 
        self.redrawMenu:render()
    end
end
