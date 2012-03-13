module MechRL
  module View
    class Debug < Base

      def initialize state
        super state
        @font = Gosu::Font.new(window, "Consolas", 18)
      end

      def draw
        status = [
          "Location: [%.2f, %.2f]" % [player.location[:x], player.location[:y]],
          "Velocity: %.2f/%.2f" % [player.velocity, player.target_velocity],
          "Acceleration: %.2f" % player.acceleration,
          "Movement Direction: %.2f" % player.movement_direction,
          "Viewing Direction: %.2f" % player.viewing_direction
        ]
        offset = 5
        status.each_with_index do |s,i|
          @font.draw(s,
                    offset,
                    offset + i*@font.height,
                    1)
        end
      end

      def player
        window.game.player
      end
    end
  end
end
