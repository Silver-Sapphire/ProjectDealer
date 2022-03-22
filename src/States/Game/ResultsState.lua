ResultsState = Class{__includes = BaseState}

function ResultsState:enter(pass)
    self.fields = pass.fields
    self.log = pass.log
    local loser = pass.player
    self.resultString = "You "
    if loser == 1 then
        self.resultString = self.resultString .. "lost..."
    else
        self.resultString = self.resultString .. "won!!"
    end
end

function ResultsState:update(dt)
    if love.keyboard.wasPressed('space') then
        gStateStack:pop()        
        -- gStateStack:pop() -- an extra pop to get rid of the hidden vanguard state underneath
    end
end

function ResultsState:render()
    for i, field in ipairs(self.fields) do
        self.fields[i]:render()
    end

    if loser == 2 then
        love.graphics.setColor(2/3, 2/3, 1, 3/4)
    else
        love.graphics.setColor(1, 2/3, 2/3, 3/4)
    end
    love.graphics.rectangle('fill', 0,0, VIRTUAL_WIDTH,VIRTUAL_HEIGHT)

    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(gFonts['massive'])
    love.graphics.printf(self.resultString, 0, VIRTUAL_HEIGHT/5, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Press space to return to main menu", 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')

end
