Card = Class{}

function Card:init(def)
    self.x = def.x or VIRTUAL_WIDTH
    self.y = def.y or VIRTUAL_HEIGHT
    self.width = CARD_WIDTH
    self.height = CARD_HEIGHT

    self.state = def.state or "stand"
    ----------------   CARD INFO    ---------------------
    self.names = {def.name} or {"_"}

    self.baseGrade = def.grade or 0
    self.grade = def.grade or 0

    self.baseShield = def.shield or 0
    self.shield = def.shield or 0

    self.basePower = def.power or 0
    self.contBoost = 0
    self.turnBoost = 0
    self.battleBoost = 0
    self.currentPower = def.power or 0

    self.baseCrit = def.baseCrit or 1
    self.crit = def.crit or 1

    self.nation = def.nation or "Cray Elemental"
    self.clan = def.clan or "Cray Elemental"
    self.race = def.race or "Elemental"

    self.sentinel = def.sentinel or false
    self.trigger = def.trigger or false
    self.type = def.type or "Normal Unit"
    self.skillIcon = def.skillIcon or "boost"
    self.text = def.text or "_"
    self.flavor = def.flavor or "_"
    self.specialIcon = def.specialIcon or false

    self.skillFunctions = def.skillFunctions or {function()end}

    self.art = def.art or false
    self.setData = def.setData or "_"

    self.oLocked = false
    self.locked = false
    self.cantAtk = false

    -- a way of storing if a unit can attack multiple (bonus) units
    self.bonus = false

    self.player = 0
    self.master = 0

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

-- move cards to other z ones
function Card:move(request)

end
