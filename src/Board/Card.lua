Card = Class{}

function Card:init(def)
    self.x 
    self.y
    self.count = def.count
    self.name = def.name
    self.grade = def.grade
end