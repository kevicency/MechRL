module MechRL
  module View
    class Game < Base
      def initialize state
        super state
        @mech_img = Gosu::Image.new(window, "./assets/images/@.png", true)
      end

      def update delta
      end

      def draw
        @mech_img.draw_rot(@state.player.location[:x],
                           @state.player.location[:y],
                           1,
                           @state.player.movement_direction)
      end

      def player
      end
    end
  end
end
