--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A Menu is simply a Selection layered onto a Panel, at least for use in this
    game. More complicated Menus may be collections of Panels and Selections that
    form a greater whole.
]]

Menu = Class{}

function Menu:init(def)
    self.panel = Panel(def.x, def.y, def.width, def.height)
    
    self.selection = Selection {
        orientation = def.orientation or 'vertical',
        text = def.text or false,
        areCards = def.areCards or false,
        -- a minimum and maximum number of selections to be made
        minSel = def.minSel or 1,
        maxSel = def.maxSel or 1,
        
        items = def.items,
        
        x = def.x,
        y = def.y,
        width = def.width,
        height = def.height,
        onSubmitFunction = def.onSubmitFunction or function () end
    }
end

function Menu:update(dt)
    self.selection:update(dt)
end

function Menu:render()
    self.panel:render()
    -- if self.selection.cursor = true
    self.selection:render()
end
