module MechRL
  class Mech
    class Component
      attr_accessor :durability, :max_durability, :heat

      def initialize
        self.durability = 1
        self.max_durability = 1
        self.heat = 0
      end

      def durability_percentage
        return 0 if max_durability == 0
        durability / max_durability.to_f
      end
    end
  end
end
