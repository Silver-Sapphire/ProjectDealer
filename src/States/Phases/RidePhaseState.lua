RidePhaseState = Class{__includes = BaseState}

function RidePhaseState:enter(fields)
    self.fields = fields
    if #self.fields[1].hand ~= 0 then
        local options = {}
        -- determine ridable cards
        -- for i=1, #self.fields[1].hand do
        --     if self.fields[1].hand[i].grade == self.fields[1].vanguard.grade or 
        --        self.fields[1].hand[i].grade == self.fields[1].vanguard.grade + 1 then
        --         table.insert(options, self.fields[1].hand[i])
        --     end
        -- end

        gStateStack:push(MenuState(MenuSelectUpToN{
                mandatoryFlag = false,
            maxCount = 1,
            items = options,

            x = 0,
            y = VIRTUAL_HEIGHT*3/4,
            width = VIRTUAL_WIDTH/2,
            height = VIRTUAL_HEIGHT/4,
            onSubmitFunction = function (selection)
                gStateStack:pop()
                if selection then
                    Event.dispatch('ride', selection)
                end

                vStateMachine:change('main', self.fields)
            end
        }))
    end
   Event.on('ride', function (selection) 
        -- determine selection's index
        local _ = table.remove(self.fields[1].hand, selection[1])
        table.insert(self.fields[1].vanguard, _)

        _ = table.remove(self.fields[1].vanguard, 1)
        table.insert(self.fields[1].soul, _)
   end)
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
end
