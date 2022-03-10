MainPhaseState = Class{__includes = BaseState}

function MainPhaseState:enter(pass)
    self.fields = pass.fields
    self.turnPlayer = pass.turnPlayer
    local turnPlayer = pass.turnPlayer

    -- turn player gets a play timing
    if turnPlayer == 1 then
        local actions = {
            {
                text = 'Call',
                onSelect = function()
                    -- pull up call menu
                    local callableCards = self:determineCallableCards()
                    self:createCallMenu(callableCards)
                end
            }
        }
        if self.fields[turnPlayer].turn ~= 1 then
            local action = {
                text = "Battle",
                onSelect = function()
                    -- confirmation menu here
                    gStateStack:pop()
                    vStateMachine:change('battle', {['fields']=self.fields, 
                                                    ['turnPlayer']=self.turnPlayer})
                end
            }
            table.insert(actions, action)
        -- skip the first battle phase
        else
            local action = {
                text = "End Turn",
                onSelect = function()
                    -- confirmation menu here
                    gStateStack:pop()
                    vStateMachine:change('end', {['fields']=self.fields,
                                                ['turnPlayer']=self.turnPlayer})
                end
            }
            table.insert(actions, action)
        end
        -- insert ACT skills into actions menu

        gStateStack:push(MenuState(Menu{
            font = gFonts['medium'],
            text = 'Actions:',
            items = actions,

            x = VIRTUAL_WIDTH/32,
            y = VIRTUAL_HEIGHT*3/4,
            width = VIRTUAL_WIDTH/3,
            height = VIRTUAL_HEIGHT/4
        }))
    else -- allow opponent a play timing
        self:processAI()
        vStateMachine:change('battle', {['fields']=self.fields,
                                        ['turnPlayer']=self.turnPlayer})
    end
end

function MainPhaseState:update(dt)
    
end

function MainPhaseState:render()
    -- draw fields
    for k, field in pairs(self.fields) do
        field:render()
    end
    -- highlight current phase
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(0,1,0,1) -- green
    -- TODO turn color red for opponents turn
    love.graphics.printf('Main', 0, VIRTUAL_HEIGHT/2 + PHASE_TEXT_GAP, VIRTUAL_WIDTH, 'right')
end

function MainPhaseState:determineCallableCards()
    local options = {}
    -- todo make work for both players
    local _vGrade = self.fields[self.turnPlayer].circles.vanguard.units[1].grade
    for i=1, #self.fields[self.turnPlayer].hand do
        local _card = self.fields[self.turnPlayer].hand[i]
        if _card.grade <= _vGrade then
            local option = {
                card = _card,
                player = self.turnPlayer,
                table = 'hand',
                index = i
            }
            table.insert(options, option)
        end
    end
    local option = {
        text = 'Done',
        onSelect = function()
            -- a pop to return to actions menu
            gStateStack:pop()
        end
    }
    
    table.insert(options, option)
    return options
end

function MainPhaseState:createCallMenu(options)
    gStateStack:push(MenuState(Menu{
        orientation = 'horizontal',
        text = 'Select a card to Call to R',
        font = gFonts['medium'],
        areCards = true,

        items = options,

        x = VIRTUAL_WIDTH/4,
        y = VIRTUAL_HEIGHT*3/4,
        width = VIRTUAL_WIDTH/2,
        height = VIRTUAL_HEIGHT/4,

        onSubmitFunction = function (selection)
            if selection then
                gStateStack:push(MenuState(Menu{
                    orientation = 'vertical',
                    font = gFonts['medium'],

                    items = self:chooseCircle(selection[1]),

                    x = VIRTUAL_WIDTH/32,
                    y = VIRTUAL_HEIGHT/4,
                    width = VIRTUAL_WIDTH/4,
                    height = VIRTUAL_HEIGHT/2,
                    onSubmitFunction = function()
                        -- this menu is popped by the item,
                        -- so we pop the call menu here and reinstatiate it without the called card
                        gStateStack:pop()
                        local callableCards = self:determineCallableCards()
                        self:createCallMenu(callableCards)
                    end
                }))
            end
        end
    }))
end

function MainPhaseState:processAI()

end
