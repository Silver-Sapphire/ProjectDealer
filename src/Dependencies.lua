-- enet = require "enet"
-- socket = require "socket"
Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/constants'
require 'src/helpers'
require 'src/Shuffler'
require 'src/card_defs'
require 'src/deck_list'
require 'src/StateMachine'
require 'src/StateStack'
require 'src/Util'

require 'src/Board/Field'
require 'src/Board/Deck'
require 'src/Board/Card'

require 'src/gui/Menu'
require 'src/gui/Panel'
require 'src/gui/ProgressBar'
require 'src/gui/SelectCards'
require 'src/gui/Selection'
require 'src/gui/Textbox'

require 'src/gui/MenuSelectUpToN'
require 'src/gui/MultiSelection'

require 'src/states/BaseState'

require 'src/states/Game/ConnectState'
require 'src/states/Game/FadeInState'
require 'src/states/Game/FadeOutState'
require 'src/states/Game/MenuState'
require 'src/states/Game/ResultsState'
require 'src/states/Game/RPSState'
require 'src/states/Game/SlideMenuState'
require 'src/states/Game/StartState'
require 'src/states/Game/TestState'
require 'src/states/Game/VanguardState'

require 'src/states/phases/RedrawState'
-- require 'src/states/phases/StandUpPhaseState'
require 'src/states/phases/StandPhaseState'
require 'src/states/phases/DrawPhaseState'
require 'src/states/phases/RidePhaseState'
require 'src/states/phases/MainPhaseState'
require 'src/states/phases/BattlePhaseState'
require 'src/states/phases/EndPhaseState'

require 'src/states/phases/AttackSubPhase/StartStep'
require 'src/states/phases/AttackSubPhase/AttackStep'
require 'src/states/phases/AttackSubPhase/GuardStep'
require 'src/states/phases/AttackSubPhase/DriveStep'
require 'src/states/phases/AttackSubPhase/DamageStep'
require 'src/states/phases/AttackSubPhase/CloseStep'

require 'src/states/Actions/CheckTiming'

gTextures = {
    ['cursor'] = love.graphics.newImage('graphics/cursor.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['background-large'] = love.graphics.newImage('graphics/backgroundLarge.png'),
    ['R'] = love.graphics.newImage('graphics/RG.png')
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 24),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 48),
    ['xl'] = love.graphics.newFont('fonts/font.ttf', 64),
    ['massive']  = love.graphics.newFont('fonts/font.ttf', 128)
}

gSounds = {
    ['blip'] = love.audio.newSource('sounds/blip.wav', 'static')
}
-- very lame placment to solve font indexing issues
require 'src/menu_defs'
