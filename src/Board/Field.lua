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

    self.vanguard = {{['grade'] = 0,
                      ['power'] = 7}}

    self.soul = {}

    self.guardianCircle = {}

    self.rearguard = {
        ['fontLeft'] = {},
        ['backLeft'] = {},
        ['backCenter'] = {},
        ['backRight'] = {},
        ['fontRight'] = {}
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

    -- Render deck
    -- make a larger deck thicker by drawing a rectangle for every 4 cards in our deck
    love.graphics.setColor(0,0,0.7,1)
    for i=1, math.floor(#self.deck/4) do
        love.graphics.rectangle('fill', VIRTUAL_WIDTH*3/4 + i,VIRTUAL_HEIGHT*5/8 - math.floor(i/2), CARD_WIDTH,CARD_HEIGHT)
    end

    -- display deck count

    -- Render drop

    -- display drop count

    -- Render bind

    -- display bind count

    -- Render R

    -- draw soul stack
    local vX, vY = VIRTUAL_WIDTH/2 - CARD_WIDTH/2, VIRTUAL_HEIGHT*5/8 - CARD_HEIGHT/2
    local soulOffset = 0
    if #self.soul > 2 then
        for i=1, math.floor(#self.soul/3) do
            love.graphics.setColor(0,0,0,1)--black
            love.graphics.rectangle('fill', vX,vY, CARD_WIDTH,CARD_HEIGHT)
            soulOffset = soulOffset + 1
        end
    end
    
    -- display soul count
	love.graphics.setColor(1,1,1,1)--white
	love.graphics.setFont(gFonts['small'])
    love.graphics.print('Soul:'.. #self.soul, vX, vY + CARD_HEIGHT)

    -- Render V(s?)
    if #self.vanguard == 1 then
        RenderCard(self.vanguard[1], vX + math.floor(soulOffset/2), vY - soulOffset)
    else
        -- legion rendering
    end
    -- Render G

    -- Render damage


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

    -- draw phase indicators (after pop, 
    -- so they're drawn in the same place, and it apears only 1 exists)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(1,1,1,1)

    love.graphics.print('Stand', VIRTUAL_WIDTH - 40, VIRTUAL_HEIGHT/2)
    love.graphics.print('Draw', VIRTUAL_WIDTH - 40, VIRTUAL_HEIGHT/2 - PHASE_TEXT_GAP)
    love.graphics.print('Ride', VIRTUAL_WIDTH - 40, VIRTUAL_HEIGHT/2 - PHASE_TEXT_GAP * 2)
    love.graphics.print('Main', VIRTUAL_WIDTH - 40, VIRTUAL_HEIGHT/2 - PHASE_TEXT_GAP * 3)
    love.graphics.print('Battle', VIRTUAL_WIDTH - 40, VIRTUAL_HEIGHT/2 - PHASE_TEXT_GAP * 4)
    love.graphics.print('End', VIRTUAL_WIDTH - 40, VIRTUAL_HEIGHT/2 - PHASE_TEXT_GAP * 5)
end
