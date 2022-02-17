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
    }
}