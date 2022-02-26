--[[
    A class that takes a table or cards paired with their coresponding field index,
    and allows the player to select a specified amount of cards to be used
    with a given callback function, such as searching, redrwaing, riding, ect.

    !! requires input "items" table to be made of tables containing a card, and its index
]]

SelectCards = Class{}

function SelectCards:init(def)
    self.mandatoryFlag = def.mandatoryFlag
    self.maxSelections = def.maxSelections
    self.numSelected = 0
    self.items = def.items
    self.text = def.text

    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height= def.height
    self.font = def.font or gFonts['small']

    -- this gap creation method won't work for larger menus and will need a scrolling feature
    self.gapWidth = self.width / #self.items

    self.currentSelection = 1
    self.selections = {}
    self.onSubmitFunction = def.onSubmitFunction
end

function SelectCards:update(dt)
    -- move curser with keyboard input
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

    -- add/remove selected item to the total selections
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        if self.items[self.currentSelection].selected then
            self.items[self.currentSelection].selected = false
            self.numSelected = self.numSelected - 1

        --  ensure we don't select more than is valid
        elseif self.numSelected < self.maxSelections then
            self.items[self.currentSelection].selected = true
            self.numSelected = self.numSelected + 1
        end
        
        gSounds['blip']:stop()
        gSounds['blip']:play()
    end

    -- Submit selections
    if love.keyboard.wasPressed('space') then
        -- TODO push confirmation menu

        --enforce mandatory flag
        if self.mandatoryFlag and #self.selections ~= self.maxSelections then
            return false
        elseif #self.selections == 0 then
            return self.onSubmitFunction()
        end

        return self.onSubmitFunction(self.selections)
    end
end

function SelectCards:render()
    -- Display menu text/description
    if self.text then
        love.graphics.print(self.text, self.x + 4, self.y + 4)
    end
    
    -- local currentY = self.y 
    local currentX = self.x

    -- draw each item/card
    for i = 1, #self.items do
        local paddedX = currentX + (self.gapWidth / 2) - 4
        renderCard(self.items[i].card, currentX, self.y + self.height/4)
        -- draw selection marker if we're at the right index
        if i == self.currentSelection then
            love.graphics.setColor(1,1,1,1)
            love.graphics.draw(gTextures['cursor'], paddedX - 10, self.y + self.height/6)
        end
    end
end
