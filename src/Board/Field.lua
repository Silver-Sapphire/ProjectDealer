Field = Class{}

function Field:init(decklist, flipped)
    self.flipped = flipped
    -- self.deck = Deck(decklist)
    self.deck = decklist

    -- self.rideDeck = self.deck.rideDeck
    -- self.deck.shuffle()


    self.hand = {}

    self.dropZone = {}

    self.bindZone = {}

    self.triggerZone = {}

    self.orderZone = {}

    self.vanguard = {{['grade'] = 0}}

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
        love.graphics.setColor(150/255, 77/255, 40/255, 245/255)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH/12,0, 10*VIRTUAL_WIDTH/12,VIRTUAL_HEIGHT)
    end

    -- Render hand
    love.graphics.setFont(gFonts["medium"])
    local handsize = #self.hand
    local handX = VIRTUAL_WIDTH/2 - handsize/2
    local handY = VIRTUAL_HEIGHT -CARD_HEIGHT - 4
    
    for i=1, handsize do 
        -- TODO rotate cards in hand

        local _card = self.hand[i]
        -- draw a card
        -- set color based on attribute
        if _card.trigger == 'crit' then
            love.graphics.setColor(1,1,1/4,1)
        elseif _card.trigger == 'heal' then
            love.graphics.setColor(1/4,1,1/4,1)
        else
            love.graphics.setColor(0,0,0,1)
        end
        love.graphics.rectangle('fill', handX,handY, CARD_WIDTH,CARD_HEIGHT)
        
        -- display card grade
        love.graphics.setColor(1,0,0,1)
        -- love.graphics.print(_card.value, handX-CARD_HEIGHT/2,handY+CARD_WIDTH/2)
        love.graphics.print(_card.grade, handX+1, handY+1)

        -- change handX location for next loop
        handX = handX + CARD_WIDTH +4
    end

    -- Render deck
    -- make a larger deck thicker by drawing a rectangle for every 4 cards in our deck
    love.graphics.setColor(0,0,0.7,1)
    for i=1, math.floor(#self.deck/4) do
        love.graphics.rectangle('fill', VIRTUAL_WIDTH*3/4 +i,VIRTUAL_HEIGHT*5/8 -i ,CARD_WIDTH,CARD_HEIGHT)
    end

    -- display deck count

    -- Render drop

    -- display drop count

    -- Render bind

    -- display bind count

    -- Render R

    -- Render V(s?) + soul 
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2-CARD_WIDTH/2,VIRTUAL_HEIGHT*5/8-CARD_HEIGHT/2, CARD_WIDTH,CARD_HEIGHT)

    love.graphics.setColor(1,0,0,1)
    love.graphics.print(self.vanguard[1].grade, VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT*5/8)

    -- display soul count

    -- Render G

    -- Render damage

    -- display avalaible CB / dmg

    -- "unflip" by returning to draw to its original state
    if self.flipped then
        love.graphics.pop()
    end
end
