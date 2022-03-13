--[[
    A class that takes a menu uesed in the menu state,
    and slides it (either onto of off) on screen, 
    optinally allowing updating while sliding on

    request contains; 
    xTween/yTween (bool), destX/Y (final x/y pos), time (time), dontUpdate (bool)
]]

SlideMenuState = Class{__includes = BaseState}

function SlideMenuState:init(menu, request, onTweenComplete)
    self.menu = menu or false
    self.time = request.time
    self.destX = request.destX or false
    self.destY = request.destY or false
    self.dontUpdate = request.dontUpdate or false

    if self.menu then -- debug test
        Timer.tween(self.time, {
            [self.menu] = {x = self.destX or x,
                            y = self.destY or y}
        })
        :finish(function()
            onTweenComplete()
        end)
    end
end

function SlideMenuState:update(dt)
    if not self.dontUpdate then
        self.menu:update(dt)
    end
end

function SlideMenuState:render()
    self.menu:render()
end
