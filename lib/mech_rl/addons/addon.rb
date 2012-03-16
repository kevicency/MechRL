module MechRL
  class Mech
    class AddOn
      attr_accessor :weight, :heat, :name
      attr_reader :mech

      def initialize mech = nil
        @weight = 0
        @heat = 0
        attach_to mech
      end

      def attach_to mech
        @mech = mech
      end

      def update delta
        return if @mech.nil?
      end

      def is_weapon?
        false
      end
    end

    class Weapon < AddOn
      attr_accessor :base_weight, :ammo_weight, :ammo_count, :cooldown, :cooldown_left

      def initialize mech = nil
        super mech

        @cooldown = 0
        @cooldown_left = 0
        @ammo_count = 0
        @ammo_per_shot = 1
        @is_selected = false
      end

      def weight
        base_weight +
          (@ammo_count == Float::INFINITY ? 0 : ammo_weight*ammo_count)
      end

      def weight= value
        self.base_weight=value
      end

      def is_weapon?
        true
      end

      def is_selected?
        @is_selected
      end

      def toggle_selected
        @is_selected = !@is_selected
      end

      def is_selected= value
        @is_selected = value
      end

      def is_on_cooldown?
        @cooldown_left > 0
      end

      def has_cooldown?
        @cooldown > 0
      end

      def cooldown_left= value
        @cooldown_left = [value, 0].max
      end

      def shoot target
        unless is_on_cooldown? || @ammo_count == 0
          shots = [@ammo_per_shot, @ammo_count].min
          @ammo_count -= shots
          @cooldown_left = @cooldown
        end
      end

      def update delta
        self.cooldown_left -= delta if is_on_cooldown?
      end
    end
  end
end
