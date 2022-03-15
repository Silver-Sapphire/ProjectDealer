AttackStep = Class{__includes = BaseState}

function AttackStep:enter(pass)
    self.pass = pass
    self.fields = pass.fields
    self.turnPlayer = pass.turnPlayer
    -- a global flag for functions that locks us into atacking to use
    CommitFlag = false

end

function AttackStep:update(dt)
    for k, field in pairs(self.fields) do
        field:update(dt)
    end
end

function AttackStep:render()
    -- draw fields
    for k, field in pairs(self.fields) do
        field:render()
    end
end

function AttackStep:pushAtkMenu()
    local possibleAttacks = self:determinePossibleAttacks(self.turnPlayer)
    local text = "Select a unit to attack with"

    if not CommitFlag then
        local option = {
            ['text'] = "End Turn",
            onSelect = function()
                gStateStack:pop()
                vStateMachine:change('end', self.pass)
            end
        }
        table.insert(possibleAttacks, option)
    end

    -- Begin battle with chose unit
    local atkMenu = CraftMenu("medium", possibleAttacks)
    atkMenu.onSubmitFunction = function()
        if #selection > 0 and selection[1].card then
            -- TODO make boosting optional
            -- booster = self:findBooster(selection[1].circle)
        end
    end

    gStateStack:push(MenuState(atkMenu))
end
