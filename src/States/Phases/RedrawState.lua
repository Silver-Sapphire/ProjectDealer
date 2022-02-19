RedrawState = Class{__includes = BaseState}

function RedrawState:init()
    ----[[

    DECKLIST = {}
    
    for i=50, 1, -1 do
        table.insert(DECKLIST, {['value'] = i})
    end
    

    -- initialize boards
    -- local player
    self.player1Field = Field(DECKLIST, false)
    -- peer player
    self.player2Field = Field(DECKLIST, true)
    
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
            for k, selection in pairs(selections) do
                local ptr, i = 0, 1
                while ptr == 0 do
                    if selection.value == self.player1Field.hand[i].value then
                        ptr = i 
                    end
                    i = i + 1
                end

                local _ = table.remove(self.player1Field.hand, i)
                table.insert(self.player1Field.deck, 1, _)
            end

            while #self.player1Field.hand < 5 do
                local _ = table.remove(self.player1Field.deck)
                table.insert(self.player1Field.hand, _)
            end

            --TODO shuffle deck
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

    self.redrawMenu:update(dt)
end

function RedrawState:render()
    self.player1Field:render()
    self.player2Field:render()

    self.redrawMenu:render()
end
