Field = Class{}

function Field:init(decklist, flipped)
    self.flipped = flipped
    self.deck = Deck(decklist)
    -- self.rideDeck = self.deck.rideDeck
    -- self.deck.shuffle()


    self.hand = {}

    self.dropZone = {}

    self.bindZone = {}

    self.triggerZone = {}

    self.orderZone = {}

    self.vanguard = {}

    self.soul = {}

    self.guardianCircle = {}

    self.rearguard = {
        ['font-left'] = {},
        ['back-left'] = {},
        ['back-center'] = {},
        ['back-right'] = {},
        ['font-right'] = {}
    }

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

    -- draw initial 5 cards
    for i=1, 5 do
        local _ = table.remove(self.deck)
        table.insert(self.hand, _)
    end
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
    
    -- ensure we draw the playmat once, before we draw anything else
    else
        -- draw "playmat"
        love.graphics.setColor(160, 77, 0, 245)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH/12,VIRTUAL_HEIGHT/12, 10*VIRTUAL_WIDTH/12,10*VIRTUAL_HEIGHT/12)
    end

    -- Render hand
    love.graphics.setFont(gFonts["medium"])
    local handsize = #self.hand
    local handX = VIRTUAL_WIDTH/2 - handsize/2
    local handY = VIRTUAL_HEIGHT -CARD_HEIGHT - 4
    
    for i=1, handsize do 
        -- draw a card
        love.graphics.setColor(0,0,0,1)
        love.graphics.rectangle('fill', handX,handY, CARD_WIDTH,CARD_HEIGHT)
        
        -- debug rendering
        love.graphics.setColor(1,0,0,1)
        love.graphics.print(self.hand[i].value, handX+CARD_HEIGHT/2,handY-CARD_WIDTH/2)

        -- change handX location for next loop
        handX = handX + CARD_WIDTH -2
    end

    -- Render deck
    self.deck:render()

    -- display deck count

    -- Render drop

    -- display drop count

    -- Render bind

    -- display bind count

    -- Render R

    -- Render V + soul 

    -- display soul count

    -- Render G

    -- Render damage

    -- display avalaible CB / dmg

    -- "unflip" by returning to draw to its original state
    if self.flipped then
        love.graphics.pop()
    end
end
