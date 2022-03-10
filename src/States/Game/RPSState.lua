--[[
    Simulate a game of RPS to decide who goes first in a game of cards.
    
    if rock is 1, paper is 2, and scissors is 3
    
    !! Needs Netcode tuneup !!
]]

RPSOPTIONS = {["rock"] = 1, ["paper"] = 2, ["scissors"] = 3}

RPSState = Class{__includes = BaseState}

function RPSState:enter(fields)
    self.done = false
    self.fields = fields
    self.playerChoice = false
    self.winner = false
    self.opChoice = false
    self.bgAplpha = 1
    self.txAlpha = 1
    self.txY = VIRTUAL_HEIGHT/2

    self:pushRPSmenu()
end

function RPSState:update(dt)
    if not self.done then
        if self.playerChoice then
            self.opChoice = love.math.random(3)
            self.winner = self:determineWinner(self.playerChoice, self.opChoice)
        end

        if self.winner == 1 then
            TURNCONSTANT = 1
            self:transition()
            self.done = true
        elseif self.winner == 2 then
            TURNCONSTANT = 0
            self:transition()
            self.done = true
        else
            self:pushRPSmenu()
        end
    end
end

function RPSState:render()
    -- draw fields
    for k, field in pairs(self.fields) do
        field:render()
    end
    -- cover feilds till RPS is done.
    love.graphics.setColor(188/255, 143/255, 146/255, self.bgAplpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    -- going 1st/2nd text
    if self.winner == 1 then
        -- love.graphics.setColor(143/255, 143/255, 188/255, self.txAlpha)
        love.graphics.setColor(188/255, 143/255, 146/255, self.txAlpha)
        love.graphics.printf('You are going first', 0, self.txY, VIRTUAL_WIDTH, 'center')
    elseif self.winner == 2 then
        -- love.graphics.setColor(143/255, 188/255, 143/255, self.txAlpha)
        love.graphics.setColor(188/255, 143/255, 146/255, self.txAlpha)
        love.graphics.printf('You are going second', 0, self.txY, VIRTUAL_WIDTH, 'center')
    end
    -- draw RPS cards

end

function RPSState:pushRPSmenu()
    gStateStack:push(MenuState(Menu{
        orientation = 'horizontal',
        text = "We don't flip coins in this house.",
        font = gFonts['large'],
        minSel = 1,
        maxSel = 1,

        items = {
                    {text='Rock',onSelect=function()self.playerChoice=1 end},
                    {text='Paper',onSelect=function()self.playerChoice=2 end},
                    {text='Scissors',onSelect=function()self.playerChoice=3 end}
                },

        x = VIRTUAL_WIDTH/4,
        y = VIRTUAL_HEIGHT*5/8,
        width = VIRTUAL_WIDTH/2,
        height = VIRTUAL_HEIGHT/4,

        onSubmitFunction = function()
            gStateStack:pop()
        end
    }))
end

function RPSState:determineWinner(p1, p2)
    if p1 == p2 then
        return 0 -- tie
    elseif p1 + 1 == p2 then
        return 2 -- p2 wins if they '1-uped' p1
    elseif p1 - 2 == p2 then
        return 2
    else --if p1's option dosn't lose, then they win
        return 1 -- p1 wins
    end
end

function RPSState:transition()
    Timer.tween(2, {
        [self] = {bgAplpha = 0}
    })
    :finish(function()
        Timer.tween(1, {
            [self] = {txY = VIRTUAL_HEIGHT}
        })
        :finish(function()
            vStateMachine:change('redraw', {['fields']=self.fields, 
                                            ['turnPlayer']=self.winner})
        end)
    end)
end
