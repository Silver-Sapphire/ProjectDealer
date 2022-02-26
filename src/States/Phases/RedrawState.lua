RedrawState = Class{__includes = BaseState}

function RedrawState:enter(fields)
    self.fields = fields
    if #self.fields[1].hand ~= 0 then
        -- redraw menu
        gStateStack:push(MenuState(MenuSelectUpToN{
            text = 'Select cards to redraw w/enter, and submit w/space',
            mandatoryFlag = false,
            maxCount = #self.fields[1].hand,

            items = self.fields[1].hand,

            x = 0,
            y = VIRTUAL_HEIGHT*3/4,
            width = VIRTUAL_WIDTH*3/8,
            height = VIRTUAL_HEIGHT/4,

            onSubmitFunction = function (selections) 
                -- event:dispatch(redraw(selections))
                -- return selected cards to deck
                local _indexAdjuster = 0
                if selections then
                    for k, selectionIndex in pairs(selections) do
                        -- the following line are debug code to address selection table indexing mis-matching
                        selectionIndex = selectionIndex - _indexAdjuster
                        _indexAdjuster = _indexAdjuster + 1
            
                        -- cringe manual looping to expant itirater scope
                        local _ = table.remove(self.fields[1].hand, selectionIndex)
                        table.insert(self.fields[1].deck, 1, _)
                    end
                    -- draw for each card redrawn
                    for k, selection in pairs(selections) do
                        Event.dispatch('draw')
                    end
                end
                -- TODO shuffle deck
                --self.fields.player1Field.deck:shuffle()
        
                -- TODO dispatch prepared event to server
                --gEvent.dispatch:redraw(#selections)
        
                -- proceed to rest of game
                gStateStack:pop()
                vStateMachine:change('draw', self.fields)
            end
        }))
    end
end

function RedrawState:update(dt)
    -- players each redraw, in turn order

        -- push selection menu to local player

            -- wait for and submit local player's decision

    -- debug state pop
    if love.keyboard.isDown('m') then
        gStateStack:pop()
    end

    for k, field in pairs(self.fields) do
        field:update(dt)
    end
end

function RedrawState:render()
    -- draw fields
    for k, field in pairs(self.fields) do
        field:render()
    end
end
