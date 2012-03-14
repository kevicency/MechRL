require_relative "rotatable"

module MechRL
  class Mech
    class Component
      attr_reader :addons
      attr_accessor :durability, :max_durability, :base_weight

      def initialize
        self.durability = 1
        self.max_durability = 1
        self.base_weight = 0
        @addons = []
      end

      def durability_percentage
        return 0 if max_durability == 0
        durability / max_durability.to_f
      end

      def heat
        addons.map(&:heat).reduce(&:+) || 0
      end

      def weight
        base_weight + (@addons.map(&:weight).reduce(&:+) || 0)
      end

      def apply_coolant coolant
        return coolant if heat == 0

        heat = self.heat
        if (coolant > heat)
          addons.each { |x| x.heat = 0 }
          return coolant - heat
        else
          addons.each do |addon|
            coolant_share = (addon.heat / heat.to_f)*coolant
            addon.heat -= coolant_share
          end
          return 0
        end
      end

      private

      def find_addon key
        if (key.kind_of? Module)
          @addons.select {|a| a.kind_of? key }.first
        end || (raise "Addon #{key} not found.")
      end
    end

    class Torso < Component
      include Rotatable

      def engine
        find_addon Engine
      end

      def cooling_unit
        find_addon CoolingUnit
      end
    end

    #class Head < Component

    #end

    #class Arm < Component

    #end

    class Leg < Component
      include MechRL::Mech::Rotatable

    end

    #class Rear < Component

    #end

    #class Shoulder < Component

    #end
  end
end
