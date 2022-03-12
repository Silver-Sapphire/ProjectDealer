RidePhaseState = Class{__includes = BaseState}

function RidePhaseState:enter(pass)
    self.fields = pass.fields
    self.turnPlayer = pass.turnPlayer
    local turnPlayer = pass.turnPlayer

    -- trigger beginning of ride phase effects

    -- make ride menu
    if turnPlayer == 1 then
        if #self.fields[1].hand ~= 0 then
            local options = {}
            local _vGrade = self.fields[1].circles.vanguard.units[1].grade
            -- determine ridable cards
            for i=1, #self.fields[1].hand do
                local _card = self.fields[1].hand[i]
                if _card.grade == _vGrade or 
                _card.grade == _vGrade + 1 then

                    local option = {
                        ['card'] = _card,
                        ['player'] = 1,
                        ['table'] = "hand",
                        ['index'] = i
                    }
                    table.insert(options, option)
                end
            end
            local option = {
                ['text'] = 'Skip',
                onSelect = function() end
            }
            table.insert(options, option)
            -- Ride phase menu
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
                    if #selection > 0 and selection[1].card then
                        Event.dispatch('ride', {['player'] = selection[1].player,
                                                ['table'] = selection[1].table,
                                                ['index'] = selection[1].index} ) -- there should only be one selectin, but its still in a table, so we need to index into it
                    end
                    -- todo, trigger on ride skills and add stride step
                    gStateStack:pop()                
                    vStateMachine:change('main', {['fields']=self.fields, 
                                                  ['turnPlayer']=self.turnPlayer})
                end
            }))
        end
    else -- opponents turn logic
        --TODO add op netcode
        self:processAI(self.fields[2].hand)

        -- proceed to op main phase
        vStateMachine:change('main', {['fields']=self.fields, 
                                     ['turnPlayer']=self.turnPlayer})
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

-- needs a ride-deck integration tune up (and ride prio tune up for V)
function RidePhaseState:processAI(hand)
    local vGrade_ = self.fields[2].circles.vanguard.units[1].grade
    if vGrade_ ~= 3 and #self.fields[2].hand ~= 0 then -- Don't override our 3
        for i = 1, #self.fields[2].hand do
            -- check to see if we can avoid riding a sentinel
            local card_ = self.fields[2].hand[i]
            if card_.grade == vGrade_ + 1 and not card_.sentinel then
                Event.dispatch('ride', {['player'] = 2,
                                        ['table'] = "hand",
                                        ['index'] = i} )
                return 0
            end
        end
        for i = 1, #self.fields[2].hand do
            local card_ = self.fields[2].hand[i]
            if card_.grade == vGrade_ + 1 and card_.sentinel then
                Event.dispatch('ride', {['player'] = 2,
                                        ['table'] = "hand",
                                        ['index'] = i} )
                return 0
            end
        end
    end
    return 1
end
