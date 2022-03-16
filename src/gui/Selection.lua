--[[
    a modification of the orignal GD50 selection menu that now supports multiple functionalites
]]

Selection = Class{}

function Selection:init(def) -- defaults
    self.orientation = def.orientation --or 'vertical'
    self.text = def.text --or false,
    self.areCards = def.areCards --or false,
    -- a minimum and maximum number of selections to be made
    self.minSel = def.minSel --or 1,
    self.maxSel = def.maxSel --or 1,

    self.items = def.items or {0}

    self.x = def.x
    self.y = def.y
    self.height = def.height
    self.width = def.width
    self.font = def.font --or gFonts['medium']
    self.onSubmitFunction = def.onSubmitFunction -- or function()end

    self.gapHeight = self.height / #self.items
    self.gapWidth = self.width / #self.items

    self.currentSelection = def.currentSelection -- or 1
    self.numSelected = 0
    self.selections = {}
end

function Selection:update(dt)
    -- move cursor in memory
    if self.maxSel ~= 0 then
        if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('left') then
            if self.currentSelection == 1 then
                self.currentSelection = #self.items
            else
                self.currentSelection = self.currentSelection - 1
            end
            
            gSounds['blip']:stop()
            gSounds['blip']:play()
        elseif love.keyboard.wasPressed('down') or love.keyboard.wasPressed('right') then
            if self.currentSelection == #self.items then
                self.currentSelection = 1
            else
                self.currentSelection = self.currentSelection + 1
            end
            
            gSounds['blip']:stop()
            gSounds['blip']:play()
        end
    end
        
    -- subbmission actions
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gSounds['blip']:stop()
        gSounds['blip']:play()

        -- different behaviors for different menu types
        local _selection = self.items[self.currentSelection]
        -- max selection being 0 is a sort of nonsense way to skip confirmation...
        if self.maxSel == 0 then
            -- confirmation/wait type functionallity
            _selection.onSelect()
    
        elseif self.maxSel == 1 and self.minSel == 1 then
            -- submit a single item w/o confirmation
            -- TODO add confirmation feature
            if self.areCards and _selection.card then
                _selection.selected = true
                self:subimtSelections()
            else 
                _selection.onSelect()
                self.onSubmitFunction()
            end  
        else
            -- prime to submit or more items
            if not _selection.selected and self.numSelected < self.maxSel then
                _selection.selected = true
                self.numSelected = self.numSelected + 1
            elseif _selection.selected then
                _selection.selected = false
                self.numSelected = self.numSelected - 1
            elseif not _selection.card then
                _selection.onSelect()
            end
        end
    end

    -- submit multiple selections
    if love.keyboard.wasPressed('space') and self.maxSel >= 1 then
        -- ensure we submit a minimum requirement, if one exists
        if self.numSelected >= self.minSel then
            self:subimtSelections()
        end
    end
end

function Selection:render()
    local currentX = self.x + self.gapWidth/2
    local currentY = self.y + self.gapHeight/2
    if self.text then
        love.graphics.setFont(self.font)
        love.graphics.printf(self.text, self.x +4, self.y +4, -- +4 to avoid overlapping with menu boarder
                             self.width, 'left')
    end

    -- draw each item
    for i = 1, #self.items do
        local paddedY = currentY - self.font:getHeight() / 2
        local paddedX = currentX - 6--self.font:getWidth() / 2

        -- render things from left to right, or top to bottom
        if self.orientation == 'vertical' then
            -- draw cards if they are the items
            if self.areCards and self.items[i].card then
                RenderCard(self.items[i].card, self.x + CARD_WIDTH*2/3, paddedY - CARD_HEIGHT*2/3)
                if self.items[i].selected then
                    love.graphics.setColor(1/2, 1/2, 2/2, 1/3)
                    love.graphics.rectangle('fill', paddedX - CARD_WIDTH/2, self.y + CARD_HEIGHT/2, CARD_WIDTH,CARD_HEIGHT)
                end
            elseif self.items[i].text then -- render text if not cards
                if self.items[i].selected then
                    love.graphics.setColor(2/4, 3/4, 1, 1)
                else
                    love.graphics.setColor(1,1,1,1)
                end
                love.graphics.setFont(self.font)
                love.graphics.printf(self.items[i].text, self.x, paddedY, self.width, 'center')
            end
            -- draw selection marker if we're at the right index
            if i == self.currentSelection and self.maxSel then
                love.graphics.setColor(1, 1, 1, 1)--white
                love.graphics.draw(gTextures['cursor'], self.x + self.width/6, paddedY, 0, 3, 3) -- -9 to avoid overlap
            end
            currentY = currentY + self.gapHeight
        
        else--if self.orientation --'horizontal' then
            -- same as above section, but with the relvant x and y swaps
             -- draw cards if they are the items
            if self.items[i].card then
                RenderCard(self.items[i].card, paddedX - CARD_WIDTH/2, self.y + CARD_HEIGHT/2)
                if self.items[i].selected then
                    love.graphics.setColor(1/2, 1/1, 2/2, 2/3)
                    love.graphics.rectangle('fill', paddedX - CARD_WIDTH/2, self.y + CARD_HEIGHT/2, CARD_WIDTH,CARD_HEIGHT)
                end

            elseif self.items[i].text then -- render text if not cards
                if self.items[i].selected then
                    love.graphics.setColor(1/2, 1/2, 1, 1)
                else
                    love.graphics.setColor(1,1,1,1)
                end
                love.graphics.setFont(self.font)
                love.graphics.print(self.items[i].text, paddedX, self.y + self.height/2)
            end
            -- draw selection marker if we're at the right index
            if i == self.currentSelection and self.maxSel then
                love.graphics.setColor(1, 1, 1, 1)--white
                love.graphics.draw(gTextures['cursor'], paddedX - CARD_WIDTH*2/3 - 4, self.y + CARD_HEIGHT*2/3, 0, 3, 3) -- +9 to avoid overlap
            end
           
            currentX = currentX + self.gapWidth
        end
    end
end

function Selection:subimtSelections()
    --todo, add confirmation feature
    for k, item in pairs(self.items) do
        if item.selected then
            table.insert(self.selections, item)
        end
    end
    self.onSubmitFunction(self.selections)
end
