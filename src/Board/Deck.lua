Deck = Class{}
-- A class that takes a decklist (already checked for validity)
-- made up of card IDs and

function Deck:init(decklist)
    self.deck = {}

    for i = #decklist, 1, -1 do
        -- local copy = decklist[i]
        -- local copy = Card(decklist[i])

        -- for j = 1, #decklist do
            table.insert(self.deck, decklist[i])
        -- end
    end

    --TODO make ride deck

    return self
end

function Deck:render()
    -- love.graphics.rectangle('fill', )
    love.graphics.print(#self.deck, VIRTUAL_WIDTH-30, VIRTUAL_HEIGHT - 30)
end

function Deck.shuffle()
    local shuffledDeck = {}
    local numberToShuffle = #self.deck

    for i = 1, numberToShuffle do
        table.insert(shuffledDeck, table.remove(self.deck, math.random(#self.deck)))
    end

    self.deck = shuffledDeck
    return self.deck
end

-- a method literally copy pasted from the shuffler.lua I wrote (for simplicity)
function Deck.shuffle(deck)
    local shuffledDeck = {}
    local cardsToShuffle = deck

    -- put a random card from the old 'pile' and put it in the new one
    -- Hypothises: running this once and eleven times should be identicly random
    local timesToShuffle = 1
    
    for i=1, timesToShuffle do
        -- shuffling of deck here
        while #cardsToShuffle > 0 do
            -- remove a random card from an input table, and move it to the output table
            table.insert(shuffledDeck, table.remove(cardsToShuffle, math.random(#cardsToShuffle)))
        end

        -- reset tables to shuffle again
        cardsToShuffle = shuffledDeck
        shuffledDeck = {}
    end

    return shuffledDeck
end