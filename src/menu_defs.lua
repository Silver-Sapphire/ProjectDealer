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
                    gStateStack[1].invisible = true
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

MENU_PROTOS = {
    ['small'] = {
        font = gFonts['small'],
        orientation = "horizontal",
        x = VIRTUAL_WIDTH*11/16,
        y = VIRTUAL_HEIGHT*13/16,
        width = VIRTUAL_WIDTH/8,
        height = VIRTUAL_HEIGHT/8
    },
    ['medium'] = {
        font = gFonts['medium'],
        orientation = "horizontal",
        x = VIRTUAL_WIDTH/4,
        y = VIRTUAL_HEIGHT*3/4,
        width = VIRTUAL_WIDTH/2,
        height = VIRTUAL_HEIGHT/4
    },
    ['medium-2'] = {
        font = gFonts['medium'],
        orientation = "vertical",
        x = VIRTUAL_WIDTH*5/8,
        y = VIRTUAL_HEIGHT/2,
        width = VIRTUAL_WIDTH/4,
        height = VIRTUAL_HEIGHT/3
    },
    ['large'] = {
        font = gFonts['large'],
        orientation = "horizontal",
        x = VIRTUAL_WIDTH/8,
        y = VIRTUAL_HEIGHT/2,
        width = VIRTUAL_WIDTH*3/4,
        height = VIRTUAL_HEIGHT/2
    }
}
