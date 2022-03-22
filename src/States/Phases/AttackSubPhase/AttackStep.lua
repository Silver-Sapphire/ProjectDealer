AttackStep = Class{__includes = BattlePhaseState}

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
        AttackNum = AttackNum + 1

        Event.dispatch("begin-attack-step")
        Event.dispatch("check-timing")

        -- TODO enable mouse/touch selection -------------------
    
        -- push menu to turn player
        if turnPlayer == 1 then
            self:pushAtkMenu()
        else
            -- AI /p2 input TODO--------
            vStateMachine:change("end", self.pass)
        end
    else -- turn ends if we can't attack
        vStateMachine:change("end", self.pass)
    end
end

function AttackStep:pushAtkMenu()
    local text = "Select a unit to attack with"
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
    local callback = function(selection)
        if selection and #selection > 0 then 
            if selection[1].card then
                self:pushAtkTargetMenu(selection[1])
            end
        end
    end
    -- Begin battle with chosen unit
    local atkMenu = CraftMenu("medium", self.possibleAttacks, callback)
    atkMenu.selection.text = text
    atkMenu.selection.areCards = true

    -- select atk target
    gStateStack:push(MenuState(atkMenu))
end

-- this whole function is part of a callback to a menu, so popping it is still mandatory
function AttackStep:pushAtkTargetMenu(attacker)
    -- ensure attcker can attack    --  TODO change to stand with card overhaul
    if attacker and attacker.card.state == "stand" and not attacker.card.cantAtk then
        -- create a table of options to target for attacks
        self.targets = self:findAtkTargets(attacker.card.bonus) or {}
        local callback = function (targets_) if targets_ then self:atkCallback(targets_, attacker) end end
        local cancel = {
            ['text'] = "Cancel",
            onSelect = function()
                gStateStack:pop() -- popping the atkTarget menu to return to orignal menu
            end
        }
        table.insert(self.targets, cancel)

        local targetMenu = CraftMenu("medium-2", self.targets, callback)
        targetMenu.selection.areCards = true
        targetMenu.selection.text = "Select a unit to attack"
        targetMenu.selection.maxSel = attacker.card.aoeAtks or 1

        gStateStack:push(MenuState(targetMenu))
    else
        -- proceed to the close step if we can't atk for some reason
        gStateStack:pop() -- aformentioned pop
        vStateMachine:change('close', self.pass)
    end
end

function AttackStep:findAtkTargets(bonus)
    local targets = {}
    for k, circle in pairs(self.fields[self.op].circles) do
        if 
        -- k == bonus or circle.row == "front" and 
        #circle.units > 0 then 
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
    local atkrCircle = attacker.circle
    local column = attacker.circle.column
    -- determine atkr column
    -- for k, circle in pairs(self.fields[attacker.player].circles) do
    --     if k == atkrCircle then
    --         column = circle.column
    --     end
    -- end

    for k, circle in pairs(self.fields[self.turnPlayer].circles) do
        if circle.row == "back" and circle.column == column and #circle.units > 0 then
            if circle.units[1].ability == "boost" then
                return circle.units[1]
            end
        end
    end
end

function AttackStep:atkCallback(targets_, attacker)
    -- TODO make boosting optional ----------------------

    -- IMPORTANT EVENT 1/2 -----
    Event.dispatch("boost", attacker) -- auto finds the booster of card_ 

    -- IMPORTANT EVENT 2/2 ---------
    -- the acutal attacking code isnt part of the event handler,
    -- instead this allows skills with the "when this unit attacks/ is attacked" timing
    Event.dispatch("rest", attacker.card)
    Event.dispatch("attack", {attacker=attacker, targets_=targets_})

    -- setup an individual battles for units that attack more than one unit at a time
    local battles = {}
    for k, target in pairs(targets_) do
        local battle = {
            attacker = attacker,
            booster = self.booster or false, -- TODO- work with dynamic boosters
            
            defender = target,
            guardians = {}
        }
        table.insert(battles, battle)
    end
    self.pass.battles = battles

    -- CHECK TIMING --------------
    Event.dispatch("check-timing")

    -- pop atk menus
    gStateStack:pop()
    gStateStack:pop()

    vStateMachine:change('guard', self.pass)
end

function AttackStep:render()
    for k, field in pairs(self.fields) do
        field:render()
    end
    -- highlight current phase
    love.graphics.setFont(gFonts['large'])
    if self.turnPlayer == 1 then
        love.graphics.setColor(0,1,0,1) -- green
    else
        love.graphics.setColor(1,0,0,1) -- red
    end
    love.graphics.printf('Battle', 0, VIRTUAL_HEIGHT/2 + PHASE_TEXT_GAP * 2, VIRTUAL_WIDTH, 'right')
    love.graphics.print('Attack Step', 200, 200)
end
