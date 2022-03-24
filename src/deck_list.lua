function shuffle(deck)
    local shuffledDeck = {}
    local cardsToShuffle = {}
    
    -- copy deck into cards to shuffle
    for k, card in pairs(deck) do
        local _ = card
        table.insert(cardsToShuffle, _)
    end

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


-- todo set starters from decks

-- initialize and shuffle both players decks
-- a deck making hack for prototyping
function MakeDeck()
    local deck = {}
    --G0
    for i=1, 16 do
        -- if i%4 == 0 then -- 4
        --     table.insert(deck, Card(CARD_IDS['test-heal']))
        -- else             -- 12
            table.insert(deck, Card(CARD_IDS['test-crit']))
        -- end
    end
    -- --G1
    -- for i=1, 14 do
    --     if i < 11 then -- 10
    --         table.insert(deck, Card(CARD_IDS['test-1']))
    --     else           -- 4
    --         table.insert(deck, Card(CARD_IDS['test-sentinel']))
    --     end
    -- end
    -- --G2
    -- for i=1, 11 do
    --     table.insert(deck, Card(CARD_IDS['test-2']))
    -- end
    -- --G3
    -- for i=1, 8 do
    --     table.insert(deck, Card(CARD_IDS['test-3']))
    -- end

    return deck
end


--[[
DECK_LIST = {
    ['P-GB-Beatrice Control'] = {
        ['#1 Starter'] = {
            count = 1,
            name = 'Captain Nightkid',
            grade = 0
        },
        ['#2 R.S. Banshee *crit*'] = {
            count = 4,
            name = 'Rough Seas Banshee',
            grade = 0
        },
        ['#3 Crit'] = {
            count = 3,
            name = 'Crit',
            grade = 0
        },
        ['#4 Mick The Ghostie And Family'] = {
            count = 1,
            name = 'G0 Heal',
            grade = 0
        },
        ['#5 G3 Heal'] = {
            count = 4,
            name = 'G3 Heal',
            grade = 3
        },
        ['#7 OverTrigger'] = {
            count = 1,
            name = 'OT',
            grade = 0
        },
        ['#8 Draw P.G.'] = {
            count = 3,
            name = 'P.G.',
            grade = 0
        },
        ['#9 Chappie'] = {
            count = 2,
            name = 'Chappie The Ghostie',
            grade = 0
        },
        ['#10 Ghostie P.G.'] = {
            count = 1,
            name = 'P.G.',
            grade = 1
        },
        ['Bale'] ={
            count = 1,
            name = 'Bale The Ghostie',
            grade = 1
        },
        ['honoly'] = {
            count = 1,
            name = 'Honloy',
            grade = 1
        },
        ['Rollock'] = {
            count = 2,
            name = 'Rollock',
            grade = 1
        },
        ['R.B'] = {
            count = 1,
            name = 'Ripple Banshee',
            grade = 1
        },
        ['SSB'] = {
            count = 4,
            name = 'Sea Stolling Banshee',
            grade = 1
        },
        ['V negrobone'] = {
            count = 1,
            name = 'V Negrobone',
            grade = 1
        },
        ['G negrobone'] = {
            count = 1,
            name = 'G Negrobone',
            grade = 1
        },
        ['King Serpent'] = {
            count = 1,
            name = 'King Serpent',
            grade = 2
        },
        ['Canoneer'] = {
            count = 1,
            name = 'Canoneer',
            grade = 2
        },
        ['Collumbard'] = {
            count = 4,
            name = 'Collumbard',
            grade = 2
        },
        ['Greed'] = {
            count = 4,
            name = 'Greed Shade',
            grade = 2
        },
        ['Dragon'] = {
            count = 2,
            name = 'Skull Dragon',
            grade = 3
        },
        ['Nightrose'] = {
            count = 3,
            name = 'Nightrose',
            grade = 3
        },
        ['Beatrice'] = {
            count = 3,
            name = 'Beatrice',
            grade = 3
        },
        ['Nightstorm'] = {
            count = 1,
            name = 'Nightstorm',
            grade = 3
        }
    }
}
--]]