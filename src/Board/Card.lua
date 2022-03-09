Card = Class{}

function Card:init(def)
    self.x = def.x or VIRTUAL_WIDTH
    self.y = def.y or VIRTUAL_HEIGHT
    self.width = CARD_WIDTH
    self.height = CARD_HEIGHT
    self.state = def.state or "stand"

    self.name = def.name "_"
    self.grade = def.grade or 0
    self.shield = def.shield or 0
    self.power = def.power or 0
    self.crit = def.crit or 1
    self.nation = def.nation or "Cray Elemental"
    self.clan = def.clan or "Cray Elemental"
    self.race = def.race or "Elemental"

    self.trigger = def.trigger or false
    self.type = def.type of "Normal Unit"
    self.skillIcon = def.skillIcon or "boost"
    self.text = def.text or "_"
    self.flavor = def.flavor or "_"
    self.specialIcon = def.specialIcon or false

    self.art = def.art or false
    self.setData = def.setData or "_"

    self.locked = false
    self.table = false
    self.index = false
end

function Card:render()
    -- rotate card if rested
    if self.state == "rest" then
        love.graphics.push()
        love.graphics.translate(VIRTUAL_WIDTH, 0)
        love.graphics.rotate(math.pi/2) --90* (x and y will be swapped on output)

        adjX = self.y - CARD_HEIGHT/6
        adjy = self.x - CARD_HEIGHT/6
        RenderCard(self, adjX, adjY)
        
        love.graphics.pop()
    else
        RenderCard(self, self.x, self.y)
    end
end

-- animate turning a card 90*
function Card:rest()

end

-- inverse rest anim
function Card:stand()

end

-- lock/trigger/draw anim
function Card:flip()

end

-- move cards to other zones
function Card:move(request)

end
