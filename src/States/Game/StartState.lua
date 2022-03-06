--[[
    A starting menu state with an automatically sized menu
]]

StartState = Class{__includes = BaseState}

function StartState:init()
    local widthCons = 520
    local heightCons = 100
    self.menuItems = MENU_DEFS['main-menu']
    self.mainMenu = Menu {
        x = VIRTUAL_WIDTH / 2 - widthCons / 2,
        y = VIRTUAL_HEIGHT / 2 - #self.menuItems * heightCons / 2,
        width = widthCons,
        height = #self.menuItems * heightCons,
        font = gFonts['large'],
        items = self.menuItems
    }
end

function StartState:update(dt)
    self.mainMenu:update(dt)
end

function StartState:render()
    self.mainMenu:render()
end
