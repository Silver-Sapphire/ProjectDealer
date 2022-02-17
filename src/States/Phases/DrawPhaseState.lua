DrawPhaseState = Class{__includes = BaseState}

function DrawPhaseState:init(field)
    --[[
    self.field = field

    beggining of turn triggers here
    check timing

    for circle in rear
        circle.unit.state = stand

    check timing

    trigger timing
    check timing

    cardToDraw = field.deck[#deck]
    
    check timing
    g assist step
    ]]
end

function DrawPhaseState:update(dt)
    --[[
        if mouse click on card or primary key pressed
            play draw animation
            add card to hand

            pop drawphase
            push ride phase
    ]]
end

function DrawPhaseState:render()

end