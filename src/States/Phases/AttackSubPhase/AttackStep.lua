AttackStep = Class{__includes = BaseState}

function AttackStep:enter(pass)
    self.pass = pass
    self.fields = pass.fields
    self.turnPlayer = pass.turnPlayer
    local turnPlayer = pass.turnPlayer
    if turnPlayer == 1 then
        self.op = 2
    else
        self.op = 1
    end

    -- a global flag for functions that locks us into atacking
    CommitFlag = false
    self.possibleAttacks = self:determinePossibleAttacks(turnPlayer)

    if #self.possibleAttacks > 0 then
        AttackNum = AttackNum + 1 or 1
        Event.dispatch("begin-attack-step")
        Event.dispatch("check-timing")
    else
        vStateMachine:change("end", self.pass)
        return 0
    end

    -- TODO enable mouse/touch selection -------------------

    self:pushAtkMenu()
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
    local text = "Select a unit to attack with"
    local callback = function()
        if #selection > 0 and selection[1].card then
            card_ = selection[1].card
            self:pushAtkTargetMenu(card_)
        end
    end
    -- Begin battle with chosen unit
    local atkMenu = CraftMenu("medium", self.possibleAttacks, callback)
    atkMenu.text = text
    atkMenu.areCards = true
    -- Only let us pass turn if we aren't forced to atk
    if not CommitFlag then
        local option = {
            text = "End Turn",
            onSelect = function()
                gStateStack:pop()
                vStateMachine:change('end', self.pass)
            end
        }
        table.insert(self.possibleAttacks, option)
    end

    -- select atk target
    gStateStack:push(MenuState(atkMenu))
end

function AttackStep:pushAtkTargetMenu(attacker)
    -- ensure attcker can attack
    if attacker and attacker.state == "stand" and not attacker.cantAtk then
        -- create a table of options to target for attacks
        local targets = self:findAtkTargets(bonus)
        --
        local cancel = {
            text = "Cancel",
            onSelect = function()
                gStateStack:pop()
            end
        }
        table.insert(targets, cancel)

        local targetMenu = CraftMenu("medium", targets)
        targetMenu.onSubmitFunction = function (targets_)
            -- TODO make boosting optional ----------------------
           
            -- IMPORTANT EVENT 1/2 -----
            Event.dispatch("boost", card_) -- auto finds the booster of card_ 

            -- IMPORTANT EVENT 2/2 ---------
            Event.dispatch("attack", {attacker=attacker, targets_=targets_})

            -- setup an individual battles for units that attack more than one unit at a time
            local battles = {}
            for k, target in pairs(targets_) do
                local battle = {
                    attacker = attacker,
                    booster = self:findBooster(attacker), -- TODO- work with dynamic boosters
                    defender = target
                }
            end
            -- CHECK TIMING --------------
            Event.dispatch("check-timing")

            bStateMachine:change('guard', pass, battles)
        end

        gStateStack:push(Menu(targetMenu))
    else
        -- proceed to the close step if we can't atk for some reason
        bStateMachine:change('close', self.pass)
    end
end

function AttackStep:findAtkTargets()
    local targets = {}
    for k, circle in pairs(self.fields[self.op].circles) do
        if circle.row == "front" and #circle.units > 0 then 
            local target = {
                card = circle.units[1],
                player = self.op,
                table = k,
                index = 1
            }
            table.insert(targets, target)
        end
    end
    return targets
end

function AttackStep:findBooster(attacker)
    local column = attacker.column
    for k, circle in pairs(self.fields[self.turnPlayer].circles) do
        if circle.row == "back" and circle.column == column and #circle.units > 0 then
            if circle.units[1].ability == "boost" then
                return circle.units[1]
            end
        end
    end
end

-- establish boost event handler
function AttackStep:init()
    -- a global scope, as a priemptive debug effort to avoid more than one handler existing
    BoostHandler = BoostHandler or Event.on("boost", function(attacker)
        booster_ = self:findBooster(attacker)
        if booster_ then
            Event.dispatch("rest", booster_)
            Event.dispatch("battle-boost", {attacker=attacker, power=booster_.currentPower or 0})
        end
    end)
end
