module MechRL
  class Game
    attr_reader :player

    def initialize
      @player = Player.new
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
      @player.mech.update delta
      state.update delta

      if state.finished?
        state = @states.pop
        state.deactivate
        self.state.activate unless self.state.nil?
      end
    end
  end
end
