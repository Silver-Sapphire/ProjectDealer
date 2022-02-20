MENU_IDS = {
    'main-menu'
}

MENU_DEFS = {
    ['main-menu'] = {
        {
            text = 'Field Test',
            onSelect = function()
                -- gStateStack:pop()
                gStateStack:push(RedrawState())
            end
        },
        {
            text = 'Peer Connect Test',
            onSelect = function()
                gStateStack:pop()
                gStateStack:push(ConnectState())
            end
        },
        {
            text = 'Exit',
            onSelect = function()
                love.event.quit()
            end
        },
        {
            text = 'Options',
            onSelect = function()

            end
        },
        {
            text = "Self Connect Test",
            onSelect = function()
                gStateStack:pop()
                gStateStack:push(EndPhaseState())
            end
        }
    },
    ['redraw-menu'] = {
        -- a function implementation of a redraw, where the player selects any number of cards
        -- from their oppening hand to put on the bottom of the deck, and then draws till they have
        -- 5 in hand again, then shuffles the deck.
    }
}