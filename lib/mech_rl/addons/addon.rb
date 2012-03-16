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
      attr_accessor :base_weight

      def initialize mech = nil
        super mech

        self.is_selected = false
      end

      def weight
        self.base_weight
      end

      def weight= value
        self.base_weight=value
      end

      def is_weapon?
        true
      end

      def has_ammo?
        false
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

      def shoot target, delta = 0
      end

      def update delta
      end
    end

    class Laser < Weapon
      attr_accessor :intensity, :heat_generation

      def initialize mech = nil
        super mech

        @intensity = 0
        @heat_generation = 0
      end

      def shoot target, delta
        shoot_intensity = intensity*delta
        self.heat += heat_generation * delta
      end
    end

    class WeaponWithAmmo < Weapon
      attr_accessor :ammo_count, :ammo_weight, :ammo_burst, :ammo_heat, :ammo_damage
      attr_accessor :reload_time
      attr_reader   :reloading_timer

      def initialize mech = nil
        super mech
        @ammo_count     = 0
        @ammo_weight    = 0
        @ammo_burst     = 1
        @ammo_heat      = 0
        @ammo_damage    = 0
        @reload_time    = 0
        @reloading_timer= 0
      end

      def weight
        total_ammo_weight = ammo_weight*ammo_count
        super + total_ammo_weight
      end

      def has_ammo?
        true
      end

      def is_reloading?
        reloading_timer > 0
      end

      def update delta
        @reloading_timer -= delta if is_reloading?
      end

      def shoot target, delta = nil
        super target, delta

        unless is_reloading? || ammo_count == 0
            shots = [ammo_burst, ammo_count].min
            self.ammo_count -= shots
            self.heat += shots*ammo_heat
            self.reloading_timer = reload_time
        end
      end

      private

      def reloading_timer= value
        @reloading_timer = [value, 0].max
      end

    end

    class MissileLauncher < WeaponWithAmmo

    end

    class Gun < WeaponWithAmmo

    end
  end
end
