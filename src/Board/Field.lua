Field = Class{}

function Field:init(decklist, flipped, player)
    self.turn = 0
    self.flipped = flipped
    self.player = player
    -- self.deck = Deck(decklist)
    self.mainSleeveArt = decklist.sleeveArt or false
    self.deck = decklist or self:CancelMatch('Missing Deck') -- todo tuneup with decklist rework

    self.rideSleeveArt = decklist.rideSleeveArt or false
    self.rideDeck = decklist.rideDeck or false
    
    self.gSleeveArt = decklist.gSleeveArt or false
    self.gDeck = decklist.gDeck or false

    self.markerSleeveArt = decklist.markerSleeveArt or false
    self.markerArt = decklist.markerArt or false

    -- self.deck.shuffle()

    self.hand = {}

    self.drop = {}

    self.bind = {}

    self.trigger = {}

    self.order = {}

    self.damage = {
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
                        
        ['vanguard'] = {['type'] = 'V',
                        ['column'] = 'middle',
                        ['row'] = 'front',
                        ['x'] = VX, ['y'] = VY,
                        ['units'] = {Card(CARD_IDS['test-starter'])}
                    },
        
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
    self.deckX = DECKX
    self.deckY = DECKY
    love.graphics.setColor(0,0,7/10,1)
    for i=1, math.floor(#self.deck/4) do
        love.graphics.rectangle('fill', self.deckX + i*2,self.deckY - i*2, CARD_WIDTH,CARD_HEIGHT)
    end
    -- display deck count
	love.graphics.setColor(1,1,1,1)--white
	love.graphics.setFont(gFonts['small'])
    love.graphics.print('Deck:'..#self.deck, self.deckX, self.deckY + CARD_HEIGHT)

    -- Render drop
    for i, card in ipairs(self.drop) do
        RenderCard(card, DECKX +i*2, DECKY + CARD_HEIGHT*4/3 -i*2)
    end

    -- display drop count
	love.graphics.setColor(1,1,1,1)--white
	love.graphics.setFont(gFonts['small'])
    if #self.drop > 0 then
        love.graphics.print('Drop:'..#self.drop, DECKX, DECKY + CARD_HEIGHT*7/3)
    end

    -- Render bind

    -- display bind count

    -- Render R-----------
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

    -- V and Soul ------------------------------------
    -- draw soul stack
    -- vanguard xy coords
    self.vX = VIRTUAL_WIDTH/2 - CARD_WIDTH/2
    self.vY = VIRTUAL_HEIGHT*5/8 - CARD_HEIGHT/2
    self.soulOffset = 0
    if #self.soul > 0 then
        self.soulOffset = 0
        for i=1, #self.soul do
            love.graphics.setColor(0,0,0,1)--black
            RenderCard(self.soul[i], self.vX + self.soulOffset, self.vY - self.soulOffset)
            self.soulOffset = self.soulOffset + 2
        end
    else
        self.soulOffset = 0
    end
    
    -- display soul count
	love.graphics.setColor(1,1,1,1)--white
	love.graphics.setFont(gFonts['small'])
    love.graphics.print('Soul:'.. #self.soul, self.vX, self.vY + CARD_HEIGHT)

    -- -- Render V(s?)
    if #self.circles.vanguard.units == 1 then
        RenderCard(self.circles.vanguard.units[1], self.vX + self.soulOffset, self.vY - self.soulOffset)
    end
    --     -- legion rendering
    -- end

    -- Render G -------
    love.graphics.draw(gTextures['R'], VIRTUAL_WIDTH/2 - 207, VIRTUAL_HEIGHT/2 - 69, 0, 0.45, 0.15)
    -- circle

    --cards

    --g z one
    --z one
    love.graphics.setColor(6/10, 6/10, 6/10, 6/10)--trans.gray
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/8,VIRTUAL_HEIGHT/2, CARD_WIDTH*2.5,CARD_HEIGHT*1.25)
    --cards

    -- trigger zone --------
    if #self.trigger > 0 then
        love.graphics.push()
        love.graphics.rotate(-math.pi/2)
        love.graphics.translate(-VIRTUAL_HEIGHT, 0)
        RenderCard(self.trigger[1], DECKY + CARD_WIDTH*5/4, DECKX- CARD_WIDTH/2)
        love.graphics.pop()
    end

    -- Render damage -------------
    -- z one
    love.graphics.setColor(7/10, 6/10, 6/10, 8/10)--trans.gray
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/8,VIRTUAL_HEIGHT*5/8, CARD_HEIGHT*2,CARD_WIDTH*6)
    -- cards
    if #self.damage > 0 then
        -- rotate cards      ---- this whole bit is a mess.....
        love.graphics.push()
        love.graphics.rotate(-math.pi/2) -- 90* rotation 
        love.graphics.translate(-VIRTUAL_HEIGHT, CARD_HEIGHT/6)

        for i = 1, #self.damage do
            local xpos_ = VIRTUAL_HEIGHT/32 - CARD_WIDTH/2 + CARD_WIDTH*17/32*i -- x pos ends up as y pos
            -- stager cards to make count more apparent
            if i % 2 == 1 then
                local staggerGap_ = CARD_HEIGHT*3/8
                RenderCard(self.damage[i], xpos_, VIRTUAL_WIDTH/10 + staggerGap_)
            else
                local staggerGap_ = CARD_HEIGHT
                RenderCard(self.damage[i], xpos_, VIRTUAL_WIDTH/10 + staggerGap_)
            end
        end
        love.graphics.pop()  --- end mess
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
