--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

StateStack = Class{}

function StateStack:init()
    self.states = {}
end

function StateStack:update(dt)
    -- customization to allow updating of all states we desire,
    -- defaulting to only the top state
    local topState = self.states[#self.states]
    topState.active = true
    for i, state in ipairs(self.states) do
        local iState = self.states[i]
        if iState.active then
            iState:update(dt)
        end
    end
end

function StateStack:processAI(params, dt)
    self.states[#self.states]:processAI(params, dt)
end

function StateStack:render()
    -- customization to allow hiding of certain states,
    -- with states defaulting to visible
    for i, state in ipairs(self.states) do
        if not state.invisible then
            state:render()
        end
    end
end

function StateStack:clear()
    self.states = {}
end

function StateStack:push(state)
    table.insert(self.states, state)
    state:enter()
end

function StateStack:pop()
    self.states[#self.states]:exit()
    table.remove(self.states)
end