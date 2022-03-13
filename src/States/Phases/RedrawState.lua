RedrawState = Class{__includes = BaseState}

function RedrawState:enter(pass)
    --TODO make work for both players FOR EVERY STATE w/ network events
    -- until then, use process ai instead
    self.fields = pass.fields
    self.turnPlayer = pass.turnPlayer

    -- draw initial 5 cards -- needs netcode tuneup
    Event.dispatch('draw', {['player']=1, ['qty']=5})
    Event.dispatch('draw', {['player']=2, ['qty']=5})

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
        -- a request for our tween state
        -- local request_ = 

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
            y = VIRTUAL_HEIGHT *3/4,
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
                -- shuffle deck
                --self.fields.player1Field.deck:shuffle()
        
                -- TODO dispatch prepared event to server
                --gEvent.dispatch:redraw(#selections)
        
                -- proceed to rest of game
                gStateStack:pop()
                -- change logic to go away in multiplayer
                self:processAI({['hand']=self.fields[2].hand})
                
                vStateMachine:change('stand', {['fields']=self.fields, 
                                               ['turnPlayer']=self.turnPlayer})
            end
        }
        -- , 
        -- {['destY']=VIRTUAL_HEIGHT*3/4, ['time']=1/2}, 

        -- function () end
        ))
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

-- AI redraw functinallity (without ride deck)

-- could be optimised by doing more things per loop through options, 
-- but the readability of this code seems to be far more useful than any 1 or 2 frames saved

-- very basic for vanilla gameplay, and needs a tune up later
function RedrawState:processAI(context)
    local options = makeAIRedrawOptions(context.hand)
    local numBack = 0 -- record how many cards we're going to put back
    
    -- determine grade to dig for
    local missingGrade = false
    for i = 1, 3 do -- for each grade we need to ride...
        local flag_ = true 
        for k, card in pairs(options) do
            if card.grade == i then -- if we don't have a card of that grade...
                flag_ = false
            end
        end
        if flag_ then
            missingGrade = i -- then we flag that as our primary grade to dig for.
            break
        end
    end
    
    -------- trigger/ sentinel logic

    -- redraw all triggers (change to keep a g3 heal guard / s.f. crit / sentiel trigger)
    for k, option in pairs(options) do
        if option.card.trigger and not option.selected then
            option.selected = true
            numBack = numBack + 1
        end
    end

    -- redraw any sentinels after the first (change to count g3 heal guards and rollock type cards as sentiels)
    local sentinelCount = 0
    for k, option in pairs(options) do
        if option.card.sentinel and not option.selected then
            sentinelCount = sentinelCount + 1
            if sentinelCount > 1 then
                option.selected = true
                numBack = numBack + 1
            end
        end
    end

    -------- grade logic

    -- keep a non sentinel 1
    local g1flag_ = false
    if missingGrade ~= 1 then
        for k, option in pairs(options) do
            if not option.selected and option.card.grade == 1 then
                if not g1flag_ then
                    g1flag_ = true -- change our flag to signify we found a g1 to keep
                else
                    option.selected = true
                    numBack = numBack + 1
                end
            end
        end
    end

    -- redraw 3's to dig for 1's
    local g3Count = 0
    if missingGrade ~= 3 then
        for k, option in pairs(options) do
            if not option.selected and option.card.grade == 3 then
                if missingGrade == 1 then
                    option.selected = true -- redraw all 3's looking for a g1
                    numBack = numBack + 1
                else
                    g3Count = g3Count + 1
                    if g3Count > 1 then -- only keep 1 g3 if we keep any
                        option.selected = true 
                        numBack = numBack + 1
                    end
                end
            end
        end
    end

    -- keep as many 2's as possible
    local g2Count = 0
    if missingGrade and missingGrade ~= 2 then
        for k, option in pairs(options) do
            if not option.selected and option.card.grade == 2 then
                g2Count = g2Count + 1
                if missingGrade == 1 and g2Count > 1 then
                    option.selected = true
                    numBack = numBack + 1
                elseif g2Count > 2 then -- digging for a 3 implied
                    option.selected = true
                    numBack = numBack + 1
                end
            end
        end
    end

    -- submit redraw selections
    for i = #options, 1, -1 do
        if options[i].selected then
            local _ = table.remove(self.fields[2].hand, i)
            table.insert(self.fields[2].deck, 1, _)
        end
    end
    if numBack > 0 then
        for i = 1, numBack do
            Event.dispatch('draw', {['player']=2, ['qty']=1})
        end
    end
end

function makeAIRedrawOptions(hand)
    local options = {}
    for i = 1, #hand do
        local option = {['card'] = hand[i],
                        ['index'] = i,
                        ['selected'] = false }
        table.insert(options, option)
    end
    return options
end
