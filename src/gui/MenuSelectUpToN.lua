--[[
    An alternate form of menu that alows the user to select up to N
    of the menu's option for simultanious submission (for redraws, rides, ect.)
]]
MenuSelectUpToN = Class{}

function MenuSelectUpToN:init(def)
    self.panel = Panel(def.x, def.y, def.width, def.height)

    self.multiSelction = MultiSelction {
        -- this flag is set if a certain amount N MUST be selected, and is false if the user can select up to or less than N
        mandatoryFlag = def.mandatoryFlag,
        maxCount = def.maxCount,
        items = def.items,
        
        x = def.x,
        y = def.y,
        width = def.width,
        height = def.height,

        -- a reference to our field, so menus can affect the board state
        -- fields = def.fields,

        -- the function the menu calls is detached from any individual item,
        -- and instead takes the selected items as arguments
        onSubmitFunction = def.onSubmitFunction
    }
end

function MenuSelectUpToN:update(dt)
    self.multiSelction:update(dt)
end

function MenuSelectUpToN:render()
    self.panel:render()
    self.multiSelction:render()
end
