module MechRL
  class Game
    attr_reader :player

    def initialize
      @player = Mech.new
      @player.location[:x] = 100
      @player.location[:y] = 100

      @player.torso = Mech::Torso.new
      @player.torso.rotary_speed = 45
      @player.torso.max_rotation = 90
      @player.torso.base_weight = 100
      @player.torso.addons << (Mech::Engine.new @player)
      @player.torso.engine.weight = 250
      @player.torso.engine.power = 3000
      @player.torso.engine.heat_generation = 5

      @player.torso.addons << (Mech::CoolingUnit.new @player)
      @player.torso.cooling_unit.weight = 50
      @player.torso.cooling_unit.cooling_rate = 4

      @player.left_leg = Mech::Leg.new
      @player.left_leg.rotary_speed = 60
      @player.right_leg = Mech::Leg.new
      @player.right_leg.rotary_speed = 60

      @states = []
    end

    def state
      @states.last
    end

    def transition_to state
      @states.push state
      state.activate
    end

    def update delta
      @player.update delta
      state.update delta

      if state.finished?
        state = @states.pop
        state.deactivate
        self.state.activate unless self.state.nil?
      end
    end
  end
end
