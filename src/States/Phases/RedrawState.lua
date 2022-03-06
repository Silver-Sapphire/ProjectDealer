RedrawState = Class{__includes = BaseState}

function RedrawState:enter(fields)
    --TODO make work for both players FOR EVERY STATE w/ network events
    -- until then, use process ai instead
    self.fields = fields
    local handsize = #self.fields[1].hand
    if handsize ~= 0 then
        -- create a table of cards, with their
        local options = {}
        for i = 1, handsize do
            local option = {
                card = self.fields[1].hand[i],
                player = 1,
                table = 'hand',
                index = i
            }
            table.insert(options, option)
        end
        -- redraw menu
        gStateStack:push(MenuState(Menu{
            orientation = 'horizontal',
            text = 'Select cards to redraw w/enter, and submit w/space',
            font = gFonts['medium'],
            areCards = true,
            minSel = 0,
            maxSel = handsize,

            items = options,

            x = VIRTUAL_WIDTH/4,
            y = VIRTUAL_HEIGHT*3/4,
            width = VIRTUAL_WIDTH/2,
            height = VIRTUAL_HEIGHT/4,

            onSubmitFunction = function (selections) 
                -- event:dispatch(redraw(selections))
                -- return selected cards to deck
                if #selections > 0 then
                    -- go over selectings from highest index to lowest, to avoid messing with index math
                    for i = #selections, 1, -1 do
                        local _ = table.remove(self.fields[1].hand, selections[i].index)
                        table.insert(self.fields[1].deck, 1, _)
                    end
                    -- draw for each card redrawn
                    for k, selection in pairs(selections) do
                        Event.dispatch('draw', {['player']=1, ['qty']=1})
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

-- AI redraw functinallity
function RedrawState:processAI(context)
    local keepIndicies = {} -- store index of a card to keep
    -- redraw all triggers

    -- redraw any sentinels after the first

    -- keep a non sentinel 1

    -- redraw 3's to dig for 1's

    -- keep as many 2's as possible

    -- for i = 1, 5 do
        
end
