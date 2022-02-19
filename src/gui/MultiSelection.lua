--[[
    A class for multi-selection menus that allows the player to either;
    choose exactly N options, or choose up to N options, set via flag.
]]

MultiSelction = Class{}

function MultiSelction:init(def)
    -- afformentioned flag
    self.mandatoryFlag = def.mandatoryFlag
    self.maxCount = def.maxCount
    self.curCount = 0

    self.items = def.items
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height
    self.font = def.font or gFonts['small']

    -- only one should be used at a time, but having both calculated might be useful later
    self.gapHeight = self.height / #self.items
    self.gapWidth = self.width / #self.items

    self.currentSelection = 1
    self.selections = {}
    self.onSubmitFunction = def.onSubmitFunction
end

function MultiSelction:update(dt)
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
            self.curCount = self.curCount - 1

        --  ensure we don't select more than is valid
        elseif self.curCount < self.maxCount then
            self.items[self.currentSelection].selected = true
            self.curCount = self.curCount + 1
        end
        
        gSounds['blip']:stop()
        gSounds['blip']:play()
        -- TODO make flag to render a checkmark/oppacity or something
        -- to make visually distinct something is selected
    end

    -- confirm and submit all selections
    if love.keyboard.wasPressed('space') then
        -- TODO make mandtary flag work
            -- TODO make confirmation menu


            for i=1, #self.items do
                if self.items[i].selected then
                    table.insert(self.selections, self.items[i])
                end
            end
            -- pass selections into whatever function the menu was for
            self.onSubmitFunction(self.selections)
    end
end 

function MultiSelction:render()
    local currentY = self.y 
    local currentX = self.x 

    for i = 1, #self.items do
        local paddedX = currentX + (self.gapWidth / 2) - 4

        -- draw selection marker if we're at the right index
        if i == self.currentSelection then
            love.graphics.draw(gTextures['cursor'], paddedX - 9, self.y)
        end

        love.graphics.setColor(1,0,0,1)
        love.graphics.printf(self.items[i].value, paddedX, self.y, self.width, 'center')

        currentX = currentX + self.gapWidth
    end
end
