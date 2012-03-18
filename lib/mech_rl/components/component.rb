module MechRL
  class Mech
    class Component
      attr_reader :addon_slots
      attr_accessor :armor, :max_armor, :base_weight, :damage, :armor_weight

      def initialize
        self.armor = 1
        self.max_armor = 1
        self.armor_weight = 0
        self.damage = 0
        self.base_weight = 0
        @addon_slots = []
      end

      def update delta
        self.addons.each do |addon|
          addon.update delta unless addon.nil?
        end
      end

      def damage_percentage
        return 0 if armor == 0
        damage / armor.to_f
      end

      def heat
        addons.reject(&:nil?).map(&:heat).reduce(&:+) || 0
      end

      def weight
        base_weight + (armor*armor_weight) + (addons.reject(&:nil?).map(&:weight).reduce(&:+) || 0)
      end

      def addons
        @addon_slots.map do |slot|
          slot[:addon]
        end
      end

      private

      def find_addon key
        if (key.kind_of? Module)
          addons.select {|a| a.kind_of? key }.first
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
      attr_accessor :payload
    end

    #class Rear < Component

    #end

    #class Shoulder < Component

    #end
  end
end
