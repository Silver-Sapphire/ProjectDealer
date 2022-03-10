Field = Class{}

function Field:init(decklist, flipped, player)
    self.turn = 0
    self.flipped = flipped
    self.player = player
    -- self.deck = Deck(decklist)
    self.deck = decklist

    -- self.rideDeck = self.deck.rideDeck
    -- self.deck.shuffle()

    self.hand = {}

    self.dropZone = {}

    self.bindZone = {}

    self.triggerZone = {}

    self.orderZone = {}

    self.damageZone = {
        --[[
        ['1'] = {},
        ['2'] = {},
        ['3'] = {},
        ['4'] = {},
        ['5'] = {},
        ['6'] = {}
        --]]
    }

    self.soul = {}

    self.circles = {
        ['vanguard'] = {['type'] = 'V',
                        ['column'] = 'middle',
                        ['row'] = 'front',
                        ['x'] = VX, ['y'] = VY,
                        ['units'] = {  {['grade'] = 0,
                                       ['power'] = 7}} },
                        
        ['frontLeft'] = {['type'] = 'R',
                         ['column'] = 'left',
                         ['row'] = 'front',
                         ['x'] = FLX, ['y'] = FLY,
                         ['units'] = {} },

        ['backLeft'] = {['type'] = 'R',
                        ['column'] = 'left',
                        ['row'] = 'back',
                        ['x'] = BLX, ['y'] = BLY,
                        ['units'] = {} },
        
        ['backCenter'] = {['type'] = 'R',
                          ['column'] = 'middle',
                          ['row'] = 'back',
                          ['x'] = BCX, ['y'] = BCY,
                          ['units'] = {} },
        
        ['backRight'] = {['type'] = 'R',
                         ['column'] = 'right',
                         ['row'] = 'back',
                         ['x'] = BRX, ['y'] = BRY,
                         ['units'] = {} },
        
        ['frontRight'] = {['type'] = 'R',
                          ['column'] = 'right',
                          ['row'] = 'front',
                          ['x'] = FRX, ['y'] = FRY,
                          ['units'] = {} },

        ['guardian'] = {['type'] = 'G',
                        ['x'] = GX, ['y'] = GY,
                        ['units'] = {} }
    }
end

function Field:update(dt)
    -- if deck clicked then
    --     draw
    -- end

    -- if card in hand clicked then
    --     move to board
    -- end

    -- if card in field clicked then
    --     move to drop
    -- end

    -- if drop clicked then
    --     move to deck
    -- end

    -- rotate field 180 for the opponent
    -- if flipped then

    -- end
    if #self.deck == 0 then
        Event.dispatch('game-over', {['player']=self.player,
                                    ['cause']="deckout"})
    end
end

-- Both fields are intially drawn on the bottom half of the screen,
-- but the oponent's field is drawn first, and then rotated to to the top
function Field:render()
    -- set up rotation
    if self.flipped then
        love.graphics.push()
        love.graphics.translate(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        love.graphics.rotate(math.pi) -- 180*, upside down (which will cause it to be a V-width/height above and left of the window)
        love.graphics.setColor(1/2, 1/8, 1/8, 1/2)
    -- ensure we draw the playmat once, before we draw anything else
    else
        -- draw "playmat"
        love.graphics.setColor(150/255, 77/255, 40/255, 245/255)
        love.graphics.rectangle('fill', -10,-10, VIRTUAL_WIDTH+10,VIRTUAL_HEIGHT+10)
        love.graphics.setColor(1/8, 1/8, 1/2, 1/2)
    end
    -- playmat pt2
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/8,VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH*3/4,VIRTUAL_HEIGHT/2)

    -- Render deck
    -- make a larger deck thicker by drawing a rectangle for every 4 cards in our deck
    self.deckX = VIRTUAL_WIDTH*3/4
    self.deckY = VIRTUAL_HEIGHT*5/8
    love.graphics.setColor(0,0,7/10,1)
    for i=1, math.floor(#self.deck/4) do
        love.graphics.rectangle('fill', self.deckX + i,self.deckY - math.floor(i/2), CARD_WIDTH,CARD_HEIGHT)
    end
    -- display deck count
	love.graphics.setColor(1,1,1,1)--white
	love.graphics.setFont(gFonts['small'])
    love.graphics.print('Deck:'..#self.deck, self.deckX, self.deckY + CARD_HEIGHT)

    -- Render drop

    -- display drop count

    -- Render bind

    -- display bind count

    -- Render R
    --circles
    local rR = 50
    local rX = VIRTUAL_WIDTH/3
    for i = 1, 3 do
        local rY = VIRTUAL_HEIGHT*5/8
        for i =1,2 do
            love.graphics.draw(gTextures['R'], rX - rR, rY - rR, 0, 0.15, 0.15)
            rY = rY + VIRTUAL_HEIGHT/8
        end
        rX = rX + VIRTUAL_WIDTH/6
    end
    --cards
    for k, circle in pairs(self.circles) do
        if #circle.units ~= 0 then
            local x = circle.x or VIRTUAL_WIDTH
            local y = circle.y or VIRTUAL_HEIGHT
            if circle.type ~= 'G' then
                for k, unit in pairs(circle.units) do
                    RenderCard(unit, x, y)
                    x = x + CARD_WIDTH/2
                    y = y - CARD_HEIGHT/4
                end
            else--if 'G' then rotate
                love.graphics.push()
                for k, unit in pairs(circle.units) do
                    RenderCard(unit, y, x)
                    x = x + CARD_WIDTH/2
                    y = y + CARD_HEIGHT/4
                end
                love.graphics.pop()
            end
        end
    end

    -- draw soul stack
    -- vanguard xy coords
    self.vX = VIRTUAL_WIDTH/2 - CARD_WIDTH/2
    self.vY = VIRTUAL_HEIGHT*5/8 - CARD_HEIGHT/2
    self.soulOffset = 0
    if #self.soul > 2 then
        self.soulOffset = 0
        for i=1, math.floor(#self.soul/3) do
            love.graphics.setColor(0,0,0,1)--black
            love.graphics.rectangle('fill', self.vX,self.vY, CARD_WIDTH,CARD_HEIGHT)
            self.soulOffset = self.soulOffset + 1
        end
    else
        self.soulOffset = 0
    end
    
    -- display soul count
	love.graphics.setColor(1,1,1,1)--white
	love.graphics.setFont(gFonts['small'])
    love.graphics.print('Soul:'.. #self.soul, self.vX, self.vY + CARD_HEIGHT)

    -- -- Render V(s?)
    -- if #self.circles.vanguard == 1 then
    --     RenderCard(self.circles.vanguard[1], self.vX + math.floor(self.soulOffset/2), self.vY - self.soulOffset)
    -- else
    --     -- legion rendering
    -- end
    -- Render G

    --gzone
    --zone
    love.graphics.setColor(6/10, 6/10, 6/10, 6/10)--trans.gray
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/8,VIRTUAL_HEIGHT/2, CARD_WIDTH*2.5,CARD_HEIGHT*1.25)
    --cards

    -- Render damage -------------
    -- zone
    love.graphics.setColor(7/10, 6/10, 6/10, 8/10)--trans.gray
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/8,VIRTUAL_HEIGHT*5/8, CARD_HEIGHT*2,CARD_WIDTH*6)
    -- cards
    if #self.damageZone > 0 then
        for i = 1, #self.damageZone do
            -- rotate cards
            love.graphics.push()
            love.graphics.translate(VIRTUAL_WIDTH, 0)
            love.graphics.rotate(math.pi/2) -- 90* rotation
            -- stager cards to make count more apparent
            if i % 2 == 1 then
                local staggerGap_ = CARD_HEIGHT/2
                local xpos_ = VIRTUAL_HEIGHT/16 + CARD_WIDTH/2*i
                RenderCard(self.damageZone[i], xpos_, VIRTUAL_WIDTH/10 + staggerGap_)
            else
                local staggerGap_ = CARD_HEIGHT
                local xpos_ = VIRTUAL_HEIGHT/16 + CARD_WIDTH/2*i -- x pos ends up as y pos
                RenderCard(self.damageZone[i], xpos_, VIRTUAL_WIDTH/10 + staggerGap_)
            end
            love.graphics.pop()
        end
    end
    -- display avalaible CB / dmg


    -- Render hand
    local handsize = #self.hand
    local handX, handY = VIRTUAL_WIDTH/2 - handsize/2, VIRTUAL_HEIGHT -CARD_HEIGHT - 4
    for i=1, handsize do 
        -- TODO rotate cards in hand

        local _card = self.hand[i]
        RenderCard(_card, handX, handY)

        -- change handX location for next loop
        handX = handX + CARD_WIDTH +4
    end

    -- "unflip" by returning to draw to its original state
    if self.flipped then
        love.graphics.pop()
    end
    -- things below are drawn "once"
    -- draw phase indicators
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(self.turn, 10,10)

    love.graphics.printf('Stand', 0, VIRTUAL_HEIGHT/2 - PHASE_TEXT_GAP * 2, VIRTUAL_WIDTH, 'right')
    love.graphics.printf('Draw', 0, VIRTUAL_HEIGHT/2 - PHASE_TEXT_GAP, VIRTUAL_WIDTH, 'right')
    love.graphics.printf('Ride', 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'right')
    love.graphics.printf('Main', 0, VIRTUAL_HEIGHT/2 + PHASE_TEXT_GAP, VIRTUAL_WIDTH, 'right')
    love.graphics.printf('Battle', 0, VIRTUAL_HEIGHT/2 + PHASE_TEXT_GAP * 2, VIRTUAL_WIDTH, 'right')
    love.graphics.printf('End', 0, VIRTUAL_HEIGHT/2 + PHASE_TEXT_GAP * 3, VIRTUAL_WIDTH, 'right')
end
