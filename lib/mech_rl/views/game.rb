module MechRL
  module View
    class Game < Base
      def initialize state
        super state
        @mech_img = Gosu::Image.new(window, "./assets/images/@.png", true)
        @view_img = Gosu::Image.new(window, "./assets/images/@view.png", true)
      end

      def draw
        @mech_img.draw_rot(@state.player.location[:x],
                           @state.player.location[:y],
                           1,
                           @state.player.movement_direction)

        @view_img.draw_rot(@state.player.location[:x],
                           @state.player.location[:y],
                           1,
                           @state.player.facing_direction)
      end

      def player
      end
    end
  end
end
