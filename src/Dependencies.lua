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
require 'src/Util'

require 'src/Board/Field'
require 'src/Board/Deck'
-- require 'src/Board/Card'

require 'src/gui/Menu'
require 'src/gui/Panel'
require 'src/gui/ProgressBar'
require 'src/gui/Selection'
require 'src/gui/Textbox'

require 'src/states/TestState'

require 'src/states/BaseState'
require 'src/states/ConnectState'
require 'src/states/ResultsState'
require 'src/states/StartState'
require 'src/states/StateStack'

require 'src/states/phases/RedrawState'
require 'src/states/phases/EndPhaseState'

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
