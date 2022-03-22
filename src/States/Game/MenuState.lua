--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

MenuState = Class{__includes = BaseState}

function MenuState:init(menu)
    self.menu = menu
end

function MenuState:update(dt)
    self.menu:update(dt)
end

function MenuState:render()
    self.menu:render()
end

function MenuState:enter()
    for k, item in pairs(self.menu.selection.items) do
        item.selected = false
    end
end
