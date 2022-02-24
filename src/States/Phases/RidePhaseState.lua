RidePhaseState = Class{__includes = BaseState}

function RidePhaseState:enter(fields)
    self.fields = fields

    -- self.rideMenu =
end

function RidePhaseState:update(dt)

end

function RidePhaseState:render()
    -- draw fields
    for k, field in pairs(self.fields) do
        field:render()
    end

    -- draw gui
    love.graphics.print('Select a card to ride w/enter, and submit w/space', 36, VIRTUAL_HEIGHT*3/5)
    if self.rideMenu then 
        self.rideMenu:render()
    end
end
