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
    ----[[

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
    -- local player
    self.player1Field = Field(_DECKLIST, false)
    -- peer player
    self.player2Field = Field(_DECKLIST, true)
    
    -- set starters from decks

    -- initialize and shuffle both players decks

    -- local player draws 5? (done in feild currently)

    -- redraw menu
    self.redrawMenu = MenuSelectUpToN {
        mandatoryFlag = false,
        maxCount = #self.player1Field.hand,

        items = self.player1Field.hand,

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
                local _ = table.remove(self.player1Field.hand, selectionIndex)
                table.insert(self.player1Field.deck, 1, _)
            end

            -- draw to 5
            while #self.player1Field.hand < 5 do
                local _ = table.remove(self.player1Field.deck)
                table.insert(self.player1Field.hand, _)
            end

            -- TODO shuffle deck
            --self.player1Field.deck:shuffle()

            -- TODO dispatch prepared event to server
            --gEvent.dispatch:redraw(#selections)

            -- delete menu after use
            self.redrawMenu.items = self.player1Field.hand
            self.redrawMenu.multiSelction.selections = {}
        end
    }
    --]]
end

function RedrawState:update(dt)
    -- players each redraw, in turn order

        -- push selection menu to local player

            -- wait for and submit local player's decision

    -- debug state pop
    if love.keyboard.isDown('m') then
        gStateStack:pop()
    end

    self.player1Field:update(dt)
    self.player2Field:update(dt)

    if self.redrawMenu then 
        self.redrawMenu:update(dt)
    end
end

function RedrawState:render()
    self.player1Field:render()
    self.player2Field:render()

    if self.redrawMenu then 
        self.redrawMenu:render()
    end
end
