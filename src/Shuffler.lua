Shuffler = Class{}

function Shuffler.shuffle(deck)
    local shuffledDeck = {}
    local cardsToShuffle = deck

    -- put a random card from the old 'pile' and put it in the new one
    -- Hypothises: running this once and eleven times should be identicly random
    local timesToShuffle = 1
    
    for i=1, i<timesToShuffle, 1 do
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

-- recursive test function
-- function Shuffler.multiShuffle(deck, shuffles)
--     local multiShuffledDeck = deck
--     for i, shuffles do
--         multiShuffledDeck = shuffle(multiShuffledDeck)
--     end
--     return multiShuffledDeck
-- end