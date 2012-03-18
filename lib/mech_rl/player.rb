module MechRL
  class Player
    attr_accessor :mech, :name

    def initialize
      self.name = "kev"

      init_mech
    end

    private

    def init_mech
      self.mech = Mech.new :timber_wolf
      mech.rotary_speed = 60
      mech.location[:x] = Constants::Window::ScreenWidth/2
      mech.location[:y] = Constants::Window::ScreenHeight/2

      mech.torso.rotary_speed = 45
      mech.torso.max_rotation = 90
      mech.torso.addon_slots[0][:addon] = begin
        engine = Mech::Engine.new mech
        engine.name = "Default Engine"
        engine.weight = 250
        engine.power = 5000
        engine.heat_generation = 5
        engine
      end

      mech.torso.addon_slots[1][:addon] = begin
        cu = (Mech::CoolingUnit.new mech)
        cu.name = "Cooler Master 2000"
        cu.weight = 15
        cu.cooling_rate = 4
        cu
      end

      mech.shoulders.addon_slots[0][:addon] = begin
        weapon = Mech::MissileLauncher.new mech
        weapon.base_weight = 25
        weapon.name = "SRM 10"
        weapon.ammo_count = 100
        weapon.ammo_weight = 0.5
        weapon.ammo_burst = 10
        weapon.ammo_heat = 1.5
        weapon.ammo_damage = 15
        weapon.reload_time = 10

        weapon
      end
      mech.left_arm.addon_slots[0][:addon] = begin
        weapon = Mech::Gun.new mech
        weapon.base_weight = 10
        weapon.name = "Dual Gun"
        weapon.ammo_count = 1000
        weapon.ammo_weight = 0.01
        weapon.ammo_burst = 2
        weapon.ammo_heat = 0.01
        weapon.ammo_damage = 1.5
        weapon.reload_time = 0.2

        weapon
      end
      mech.left_arm.addon_slots[1][:addon] = begin
        weapon = Mech::Laser.new mech
        weapon.name = "Pew Pew Laser"
        weapon.base_weight = 5
        weapon.heat_generation = 10
        weapon.intensity = 15

        weapon
      end

      Mech::COMPONENTS.each do |c|
        component = mech.send c
        component.damage = rand(component.armor)
      end
    end
  end
end
