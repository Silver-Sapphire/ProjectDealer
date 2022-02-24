enet = require "enet"
socket = require "socket"
Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/constants'
require 'src/helpers'
require 'src/menu_defs'
require 'src/Shuffler'
require 'src/deck_list'
require 'src/StateMachine'
require 'src/StateStack'
require 'src/Util'

require 'src/Board/Field'
require 'src/Board/Deck'
-- require 'src/Board/Card'

require 'src/gui/Menu'
require 'src/gui/Panel'
require 'src/gui/ProgressBar'
require 'src/gui/Selection'
require 'src/gui/Textbox'

require 'src/gui/MenuSelectUpToN'
require 'src/gui/MultiSelection'

require 'src/states/BaseState'

require 'src/states/Game/ConnectState'
require 'src/states/Game/FadeInState'
require 'src/states/Game/FadeOutState'
require 'src/states/Game/ResultsState'
require 'src/states/Game/StartState'
require 'src/states/Game/TestState'
require 'src/states/Game/VanguardState'

require 'src/states/phases/RedrawState'
-- require 'src/states/phases/StandUpPhaseState'
-- require 'src/states/phases/StandPhaseState'
require 'src/states/phases/DrawPhaseState'
require 'src/states/phases/RidePhaseState'
require 'src/states/phases/MainPhaseState'
require 'src/states/phases/BattlePhaseState'
require 'src/states/phases/EndPhaseState'

-- require 'src/states/Actions/'

gTextures = {
    ['cursor'] = love.graphics.newImage('graphics/cursor.png'),
    ['background'] = love.graphics.newImage('graphics/background.png')
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}

gSounds = {
    ['blip'] = love.audio.newSource('sounds/blip.wav', 'static')
}
