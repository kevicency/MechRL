module MechRL
  class Player
    attr_accessor :mech, :name

    def initialize
      self.name = "kev"

      init_mech
    end

    private

    def init_mech
      self.mech = Mech.new
      mech.type = :timber_wolf
      mech.rotary_speed = 60
      mech.location[:x] = Constants::Window::ScreenWidth/2
      mech.location[:y] = Constants::Window::ScreenHeight/2

      mech.torso = Mech::Torso.new
      mech.torso.rotary_speed = 45
      mech.torso.max_rotation = 90
      mech.torso.base_weight = 100
      mech.torso.addons << (Mech::Engine.new mech)
      mech.torso.engine.weight = 250
      mech.torso.engine.power = 2000
      mech.torso.engine.heat_generation = 5

      mech.torso.addons << (Mech::CoolingUnit.new mech)
      mech.torso.cooling_unit.weight = 50
      mech.torso.cooling_unit.cooling_rate = 4

      mech.left_leg = Mech::Leg.new
      mech.right_leg = Mech::Leg.new
      mech.shoulders = Mech::Component.new
      mech.head = Mech::Component.new
      mech.right_arm = Mech::Component.new
      mech.right_arm.addons << begin
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
      mech.left_arm = Mech::Component.new
      mech.left_arm.addons << begin
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
      mech.left_arm.addons << begin
        weapon = Mech::Laser.new mech
        weapon.name = "Pew Pew Laser"
        weapon.base_weight = 5
        weapon.heat_generation = 10
        weapon.intensity = 15

        weapon
      end

      Mech::COMPONENTS.each do |c|
        component = mech.send c
        component.max_durability = 100
        component.durability = rand(100)
      end
    end
  end
end
