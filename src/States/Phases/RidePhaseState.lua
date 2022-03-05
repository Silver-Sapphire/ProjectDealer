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
            orientation = 'horizontal',
            text = 'Select a card to ride w/enter, and submit w/space',
            font = gFonts['medium'],
            areCards = true,
            minSel = 0,
            maxSel = 1,

            items = options,

            x = 0,
            y = VIRTUAL_HEIGHT*3/4,
            width = VIRTUAL_WIDTH,
            height = VIRTUAL_HEIGHT/4,

            onSubmitFunction = function (selection)
                if #selection > 0 then
                    Event.dispatch('ride', selection[1]) -- there should only be one selectin, but its still in a table, so we need to index into it
                end
                -- todo, trigger on ride skills
                gStateStack:pop()
                vStateMachine:change('main', self.fields)
            end
        }))
    end
    self.flag_ = false
    self.selection = false
end

function RidePhaseState:update(dt)

end

function RidePhaseState:render()
    -- draw fields
    for k, field in pairs(self.fields) do
        field:render()
    end

    if self.flag_ then
        if self.selection then
            love.graphics.setFont(gFonts['large'])
            love.graphics.setColor(1,1,0,1)
            RenderCard(self.selection.card, 10, 10)
        end
    end
end

function RidePhaseState:debugPrint(selection)
    self.selection = selection
    self.flag_ = true
end
