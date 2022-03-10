RidePhaseState = Class{__includes = BaseState}

function RidePhaseState:enter(fields, turnPlayer)
    self.fields = fields
    self.turnPlayer = turnPlayer

    -- trigger beginning of ride phase effects

    -- make ride menu
    if #self.fields[turnPlayer].hand ~= 0 then
        local options = {}
        local _vGrade = self.fields[turnPlayer].vanguard[1].grade
        -- determine ridable cards
        for i=1, #self.fields[turnPlayer].hand do
            local _card = self.fields[turnPlayer].hand[i]
            if _card.grade == _vGrade or 
               _card.grade == _vGrade + 1 then
                local option = {
                    card = _card,
                    player = turnPlayer,
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

            x = VIRTUAL_WIDTH/4,
            y = VIRTUAL_HEIGHT*3/4,
            width = VIRTUAL_WIDTH/2,
            height = VIRTUAL_HEIGHT/4,

            onSubmitFunction = function (selection)
                if #selection > 0 then
                    Event.dispatch('ride', selection[1]) -- there should only be one selectin, but its still in a table, so we need to index into it
                end
                -- todo, trigger on ride skills and add stride step
                gStateStack:pop()                
                vStateMachine:change('main', self.fields, turnPlayer)
            end
        }))
    end
end

function RidePhaseState:update(dt)
        -- trigger check timing

end

function RidePhaseState:render()
    -- draw fields
    for k, field in pairs(self.fields) do
        field:render()
    end

    -- highlight current phase
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(0,1,0,1) -- green
    -- TODO turn color red for opponents turn
    love.graphics.printf('Ride', 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'right')
end
