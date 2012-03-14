$LOAD_PATH << './lib'

require 'rubygems'
require 'gosu'

require 'mech_rl/constants'
require 'mech_rl/game'
require 'mech_rl/mech'
require 'mech_rl/game_window'
require 'mech_rl/resources'

require 'mech_rl/components/component'
require 'mech_rl/components/rotatable'

require 'mech_rl/addons/addon'
require 'mech_rl/addons/engine'
require 'mech_rl/addons/cooling_unit'

require 'mech_rl/views/base'
require 'mech_rl/views/debug'
require 'mech_rl/views/game'
require 'mech_rl/views/test'
require 'mech_rl/views/mech'

require 'mech_rl/states/base'
require 'mech_rl/states/game'
