--[[
    A starting menu state with an automatically sized menu
]]

StartState = Class{__includes = BaseState}

function StartState:init()
    local widthCons = 160
    local heightCons = 36
    self.menuItems = MENU_DEFS['main-menu']
    self.mainMenu = Menu {
        x = VIRTUAL_WIDTH / 2 - widthCons / 2,
        y = VIRTUAL_HEIGHT / 2 - #self.menuItems * heightCons / 2,
        width = widthCons,
        height = #self.menuItems * heightCons,
        cursor = true,
        items = self.menuItems
    }
end

function StartState:update(dt)
    self.mainMenu:update(dt)
end

function StartState:render()
    love.graphics.setFont(gFonts["medium"])
    self.mainMenu:render()
end
