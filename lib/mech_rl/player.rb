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
      mech.torso.engine.power = 4000
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
        weapon = Mech::Weapon.new mech
        weapon.name = "SRM OVER 9000"
        weapon.ammo_count = 100
        weapon.cooldown = 0
        weapon.base_weight = 10
        weapon.ammo_weight = 0.1
        weapon
      end
      mech.left_arm = Mech::Component.new
      mech.left_arm.addons << begin
        weapon = Mech::Weapon.new mech
        weapon.name = "Pew Pew Lazer"
        weapon.ammo_count = Float::INFINITY
        weapon.cooldown = 5
        weapon.base_weight = 15
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
