MENU_IDS = {
    'main-menu'
}

MENU_DEFS = {
    ['main-menu'] = {
        {
            text = 'Field Test',
            onSelect = function() -- push a game of CFV over our main menu
                gStateStack:push(FadeInState({
                    r = 0, g = 0, b = 0 -- fade to black
                }, 0.5,
                function ()
                    gStateStack:push(VanguardState())
                    gStateStack:push(FadeOutState({
                        r = 0, g = 0, b = 0
                    }, 0.5, 
                    function() end))
                end))
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
        }
    },
    ['redraw-menu'] = {
        -- a function implementation of a redraw, where the player selects any number of cards
        -- from their oppening hand to put on the bottom of the deck, and then draws till they have
        -- 5 in hand again, then shuffles the deck.
    }
}