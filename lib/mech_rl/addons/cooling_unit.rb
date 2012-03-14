module MechRL
  class Mech
    class CoolingUnit < AddOn
      attr_accessor :cooling_rate

      def initialize mech
        super mech
      end

      def update delta
        super delta
        return if @mech.heat == 0

        coolant = cooling_rate * delta
        heat = @mech.heat
        @mech.components.each do |c|
          c.addons.each do |a|
            coolant_share = (a.heat / heat.to_f)*coolant
            a.heat = [a.heat-coolant_share, 0].max
          end
        end
      end
    end
  end
end

