
DriveStep = Class{__includes = BaseState}

function DriveStep:enter(pass)
    self.fields = pass.fields
    self.battles = pass.battles
    self.attacker = self.battles[1].attacker
    self.turnPlayer = self.attacker.player
    -- TODO check for drive amount instead of just checking V and grade

    -- trigger beginning of drive step effect
    Event.dispatch("begin-drive-step")
    Event.dispatch("check-timing")

    -- determine number of checks to make
    local drive = 0
    if self.attacker.table == "vanguard" then
        if self.attacker.card.grade == 3 then
            drive = 2
        else
            drive = 1
        end
    end

    for i = drive, 1, -1 do -- reverse loop to do nothing when drive = 0
        Event.dispatch("drive-check")
    end

    Event.dispatch("check-timing")
    bStateMachine:change("damage", pass)
end

function DriveStep:init()
    Event.on("drive-check", function ()
        -- put each card in trigger zone (moved to trigger check dispatch)
        -- trigger trigger effects
        Event.dispatch("trigger-check", self.turnPlayer)
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
