module MechRL
  class Game
    attr_reader :player

    def initialize
      @player = Mech.new
      @player.location[:x] = 10
      @player.location[:y] = 10
      @player.velocity = 0.01
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
