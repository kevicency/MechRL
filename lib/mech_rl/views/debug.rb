module MechRL
  module View
    class Debug < Base

      def initialize state
        super state
        @font = Resources::Fonts[:log]
      end

      def draw
        status = [
          "Location: [%.2f, %.2f]" % [mech.location[:x], mech.location[:y]],
          "Velocity: %.2f/%.2f" % [mech.velocity, mech.target_velocity],
          "Acceleration: %.2f" % mech.acceleration,
          "Heat: %.2f" % mech.heat,
          "Rotation: %.2f" % mech.rotation,
          "Torso Rotation: %.2f" % mech.torso.rotation
        ]
        offset = 5
        status.each_with_index do |s,i|
          @font.draw(s,
                    offset,
                    offset + i*@font.height,
                    1)
        end
      end
    end
  end
end
