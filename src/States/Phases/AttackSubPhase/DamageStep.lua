
DamageStep = Class{__includes = BaseState}

function DamageStep:enter(pass, battles)
    self.pass = pass
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
    self:determineHits(battles)
    Event.dispatch("check-timing")

    -- resolve a dmg check/reitre for each hit
    for k, hit in pairs(hits) do
        self:hitHandler(hit)
    end
    Event.dispatch("check-timing")

    Event.dispatch("attack-hit", self.hits)
    Event.dispatch("attack-whiff", self.whiffs)
    Event.dispatch("check-timing")

    self:cleanup()
    Event.dispatch("check-timing")

    bStateMachine:change("close", pass, battles)
end

function DamageStep:determineHits(battles) -- TODO remove VG from hits when dmg resolves or something else
    -- compare battling units total power

    -- cancel atk if a battling unit dissapears / master changes / moves circle


    -- no dmg is inflicted if a unit dissapears / master changes / moves circle

    -- if atkP >= defP then
        -- if atkTarget.table == 'vanguard' then
            -- begin apropriate amt of dmg checks

            -- check timing

            -- event.dispatch('hit', 'vanguard')

        -- else (rearguard)
            -- retire rearguard

            -- check timing

            -- event.dispatch('hit', 'rearguard')

        -- end
    -- else (atk dosn't hit)
end

function DamageStep:hitHandler(hit)

end

function DamageStep:cleanup()
    -- clear G
    local G = self.fields[self.op].circles.guardian.units
    if G > 0 then
        for i = 1, G do
            -- retire all normal guardians
            if G[i].type ~= 'gGuard' then
                self:moveCard({
                    _field = self.op,
                    _inputTable = "guradian",
                    _inputIndex = i,

                    _outputTable = "drop"
                })

            -- return g gurads
            else

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

