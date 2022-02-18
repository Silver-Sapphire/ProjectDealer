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

    --]]
end

function RedrawState:update(dt)
    -- players each redraw, in turn order

        -- push selection menu to local player

            -- wait for and submit local player's decision

    -- debug state pop
    if love.keyboard.isDown('space') then
        gStateStack:pop()
    end

end

function RedrawState:render()
    self.player1Field:render()
    self.player2Field:render()
end
