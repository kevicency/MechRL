module MechRL
  class Mech
    class Engine < AddOn
      attr_accessor :power, :heat_generation
      attr_reader :acceleration

      def initialize mech
        super mech
        @acceleration = 0
      end

      def update delta
        super delta

        dv = @mech.target_velocity - @mech.velocity
        if dv.abs < 0.1
          @acceleration = 0
        else
          @acceleration = max_acceleration
          if (dv < 0)
            @acceleration *= (@mech.velocity > 0 ? -2 : -0.5)
            self.heat += 0.1 * heat_generation * delta
          else
            self.heat += @acceleration/max_acceleration * heat_generation * delta
          end
        end
      end

      def max_acceleration
        power / @mech.weight
      end
    end
  end
end
