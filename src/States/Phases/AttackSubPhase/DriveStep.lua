
DriveStep = Class{__includes = BattlePhaseState}

function DriveStep:enter(pass)
    self.fields = pass.fields
    self.battles = pass.battles
    self.pass = pass
    self.attacker = self.battles[1].attacker
    self.turnPlayer = self.attacker.player
    local splits = {
        -- TODO check for drive amount instead of just checking V and grade
        ['begin'] = function()
            -- trigger beginning of drive step effect
            Event.dispatch("begin-drive-step")
            Event.dispatch("check-timing")
        end,
        ['drive'] = function() -- further split in each drive check
            -- determine number of checks to make
            self.drive = 0
            self.finishedChecks = 0
            if self.attacker.table == "vanguard" then
                if self.attacker.card.grade == 3 then
                    self.drive = 2
                else
                    self.drive = 1
                end
            end
            for i = self.drive, 1, -1 do -- reverse loop to do nothing when drive = 0
                Event.dispatch("drive-check")
            end
            Event.dispatch("check-timing")
        end
    }
    PhaseSplitter(splits)
end

-- move to the next state only after we finish our drive checks
function DriveStep:update(dt)
    local split = {
        ['change'] = function()
            vStateMachine:change("damage", self.pass)
        end
    }
    if self.drive == self.finishedChecks then
        PhaseSplitter(split)
    end
end

function DriveStep:init()
    DriveCheckStart = DriveCheckStart or Event.on("drive-check", function ()
        -- put each card in trigger z|one (moved to trigger check dispatch)
        -- trigger trigger effects
        Event.dispatch("trigger-check", "drive", self.turnPlayer)
        Event.dispatch("check-timing")
    end)
    DriveCheckFinish = DriveCheckFinish or Event.on('drive-check-finish', function(player)
        -- add drive check to hand
        self:moveCard({
            _field = player,
            _inputTable = "trigger",

            _outputTable = "hand"
        })
        Event.dispatch("check-timing")
        self.finishedChecks = self.finishedChecks + 1
    end)
end

function DriveStep:render()
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
    love.graphics.print('Drive Step', 200, 200)
end

