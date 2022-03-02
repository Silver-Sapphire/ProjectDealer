RidePhaseState = Class{__includes = BaseState}

function RidePhaseState:enter(fields)
    self.fields = fields
    if #self.fields[1].hand ~= 0 then
        local options = {}
        local _vGrade = self.fields[1].vanguard[1].grade
        -- determine ridable cards
        for i=1, #self.fields[1].hand do
            local _card = self.fields[1].hand[i]
            if _card.grade == _vGrade or 
               _card.grade == _vGrade + 1 then
                local option = {
                    card = _card,
                    player = 1,
                    table = 'hand',
                    index = i
                }
                table.insert(options, option)
            end
        end

        gStateStack:push(MenuState(Menu{
            oreintation = 'horizontal',
            text = 'Select a card to ride w/enter, and submit w/space',
            areCards = true,
            minSel = 0,
            maxSel = 1,

            items = options,

            x = 0,
            y = VIRTUAL_HEIGHT*3/4,
            width = VIRTUAL_WIDTH/2,
            height = VIRTUAL_HEIGHT/4,

            onSubmitFunction = function (selection)
                if #selection > 0 then
                    Event.dispatch('ride', selection)
                end
                -- todo, trigger on ride skills
                gStateStack:pop()
                vStateMachine:change('main', self.fields)
            end
        }))
    end
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
