
DamageStep = Class{__includes = BaseState}

function DamageStep:enter(pass)
    self.pass = pass    
    self.battles = pass.battles
    self.fields = pass.fields
    self.turnPlayer = pass.turnPlayer
    local turnPlayer = pass.turnPlayer
    if turnPlayer == 1 then
        self.op = 2
    else
        self.op = 1
    end

    Event.dispatch("begin-damage-step")
    Event.dispatch("check-timing")

    -- check to see if each attack hits
    self.whiffs = {}
    self.hits = {}
    self:determineHits()
    Event.dispatch("check-timing")

    -- resolve a dmg check / mark for reitre for each hit
    if #self.hits > 0 then 
        self:hitHandler()
    end
    Event.dispatch("check-timing")

    if #self.hits > 0 then
        Event.dispatch("attack-hit", self.hits)
    end
    if #self.whiffs > 0 then
        Event.dispatch("attack-whiff", self.whiffs)
    end
    Event.dispatch("check-timing")

    self:cleanup()
    Event.dispatch("check-timing")

    bStateMachine:change("close", pass)
end

function DamageStep:determineHits()
    for i = 1, #self.battles do
        local battle = self.battles[i]
        local shield = 0
        for k, guardian in pairs(battle.guardians) do
            shield = shield + guardian.shield
        end
        -- compare battling units total power
        local attacker = battle.attacker.card or false
        local totalAtkPower = attacker.basePower + attacker.battleBoost
                           + attacker.turnBoost + attacker.contBoost or 0

        if totalAtkPower >= battle.defender.card.currentPower + shield then 
            local _ = table.remove(self.battles, i)
            table.insert(self.hits, _)
        else --(atk dosn't hit)
            local _ = table.remove(self.battles, i)
            table.insert(self.whiffs, _)
        end
    end
end

function DamageStep:hitHandler() 
    for i = 1, #self.hits do
        local hit = self.hits[i]
        -- rearugards are retired during the cleanup function later
        if hit.defender.table == "vanguard" then
            local crit = hit.attacker.card.crit 
            if crit > 0 then
                for i = 1, crit do
                    Event.dispatch("damage-check", self.op)
                end

            table.remove(self.hits, i) -- remove hit from table, now that its resolved.
            
            break -- the vanguard won't be in the table twice
            end
        end
    end
end

function DamageStep:cleanup()
    -- clear G
    local G = self.fields[self.op].circles.guardian.units
    if #G > 0 then
        for i = 1, #G do
            -- retire all normal guardians
            if G[i].type ~= 'gGuard' then
                self:moveCard({
                    _field = self.op,
                    _inputTable = "guradian",
                    _inputIndex = i,

                    _outputTable = "drop"
                })

            else -- return g gurads

            end
        end
    end

    -- retire all hit rearguards
    for k, hit in pairs(self.hits) do
        self:moveCard({
            _field = self.op,
            _inputTable = hit.table,
            _inputIndex = 1,

            _outputTable = "drop"
        })
    end
end
