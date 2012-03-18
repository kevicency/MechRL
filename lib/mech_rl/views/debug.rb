module MechRL
  module View
    class Debug < Base
      attr_accessor :left, :top

      def initialize state
        super state
        @font = Resources::Fonts[:log]
        @left = 0
        @top = 0
      end

      def draw
        status = [
          "Location: [%.2f, %.2f]" % [mech.location[:x], mech.location[:y]],
          "Velocity: %.2f/%.2f" % [mech.velocity, mech.max_velocity],
          "Target Velocity: %.2f" % mech.target_velocity,
          "Acceleration: %.2f" % mech.acceleration,
          "Heat: %.2f" % mech.heat,
          "Rotation: %.2f" % mech.rotation,
          "Torso Rotation: %.2f" % mech.torso.rotation,
          "Friction: %.2f" % mech.friction
        ]
        status.each_with_index do |s,i|
          @font.draw s,
                     left,
                     top + i*@font.height,
                     1
        end
      end
    end
  end
end
