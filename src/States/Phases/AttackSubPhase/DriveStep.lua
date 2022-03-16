
DamageStep = Class{__includes = BaseState}

function DamageStep:enter(pass, battles)
    self.fields = pass.fields
    self.attacker = battles[1].attacker
    self.turnPlayer = attacker.player
    -- TODO check for dive amount instead of just checking V and grade

    -- trigger beginning of drive step effect
    Event.dispatch("begin-drive-step")
    Event.dispatch("check-timing")

    -- determine number of checks to make
    local drive = 0
    if attacker.table == "vanguard" then
        if attacker.card.grade == 3 then
            drive = 2
        else
            drive = 1
        end
    end

    for i = drive, 1, -1 do -- reverse loop to do nothing when drive = 0
        Event.dispatch("drive-check")
    end

    Event.dispatch("check-timing")
    bStateMachine:change("damage", pass, battles)
end

function DamageStep:init()
    Event.on("drive-check", function ()
        -- put each card in trigger zone
        -- TODO animation
        self:moveCard({
            _field = self.attacker.player,
            _inputTable = "deck",
            _outputTable = "trigger"
        })

        -- trigger trigger effects
        self:triggerCheck(self.fields[self.turnPlayer].trigger[1])

        Event.dispatch("check-timing")

        -- add drive to hand
        self:moveCard({
            _field = self.attacker.player,
            _inputTable = "trigger",
            _outputTable = "hand"
        })

        Event.dispatch("check-timing")
    end)
end
