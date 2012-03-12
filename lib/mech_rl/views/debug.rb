module MechRL
  module View
    class Debug < Base

      def initialize
        @font = Gosu::Font.new(window, "Consolas", 18)
      end

      def draw
        status = [
          "Location: [%.2f, %.2f]" % player.location[:x], player.location[:y],
          "Velocity: %.2f/%.2f" % player.velocity, player.desired_velocity,
          "Acceleration: %.2f" % player.acceleration
          "Movement Direction: %.2f/%.2f" % player.movement_angle
        ]
       @font.draw("x: %.2f, y: %.2f, vel: %.2f, acc: %.2f, angle: %.2f" % [@x,@y,@vel,@acc,@angle], 3, 3, 1, 1, 1, 0xFF000000)
      end

      def player
        window.game.player
      end
    end
  end
end
