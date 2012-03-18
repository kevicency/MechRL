module MechRL
  class Mech
    include Rotatable

    class << (Data = Hash.new);end

    COMPONENTS = [
      :head,
      :torso,
      :shoulders,
      :left_arm,
      :right_arm,
      :left_leg,
      :right_leg
    ]

    attr_accessor :type
    attr_accessor :location
    attr_accessor :velocity, :target_velocity

    COMPONENTS.each do |component|
      define_method component do
        @components[component] || (raise "Component #{component} missing.")
      end

      define_method "#{component}=" do |value|
        @components[component] = value
      end
    end

    def initialize mech_type
      self.location = {x:0, y:0}
      self.velocity = 0
      @target_velocity = 0
      @components = {}
      @friction_base = 0.025
      @friction_factor = 0.0005
      @type = mech_type

      self.head = Mech::Component.new
      self.shoulders = Mech::Component.new
      self.torso = Mech::Torso.new
      self.left_arm = Mech::Component.new
      self.right_arm = Mech::Component.new
      self.left_leg = Mech::Leg.new
      self.right_leg = Mech::Leg.new

      self.head.armor = 10
      self.shoulders.armor = 75
      self.torso.armor = 125
      self.left_arm.armor = 50
      self.right_arm.armor = 50
      self.left_leg.armor = 75
      self.right_leg.armor = 75

      self.head.max_armor = 15
      self.shoulders.max_armor = 80
      self.torso.max_armor = 150
      self.left_arm.max_armor = 60
      self.right_arm.max_armor = 60
      self.left_leg.max_armor = 75
      self.right_leg.max_armor = 75

      self.head.base_weight = 10
      self.shoulders.base_weight = 50
      self.torso.base_weight = 100
      self.left_arm.base_weight = 30
      self.right_arm.base_weight = 30
      self.left_leg.base_weight = 40
      self.right_leg.base_weight = 40

      self.head.armor_weight = 0.5
      self.shoulders.armor_weight = 1
      self.torso.armor_weight = 1.5
      self.left_arm.armor_weight = 1
      self.right_arm.armor_weight = 1
      self.left_leg.armor_weight = 1
      self.right_leg.armor_weight = 1

      self.left_leg.payload = 750
      self.right_leg.payload = 750

      COMPONENTS.each do |c|
        component = self.send c
        restrictions = Data[@type].addon_slots[c]
        restrictions.each do |classes|
          component.addon_slots << {
            restrictions: classes,
            addon: nil
          }
        end unless restrictions.nil?
      end
    end

    def weight
      @components.values
      .map(&:weight)
      .reduce(&:+) || 0
    end

    def max_weight
      left_leg.payload + right_leg.payload
    end

    def heat
      @components.values
      .map(&:heat)
      .reduce(&:+) || 0
    end

    def max_heat
      100
    end

    def acceleration
      torso.engine.acceleration
    end

    def max_acceleration
      torso.engine.max_acceleration
    end

    def friction
      @friction_base + (@friction_factor*velocity)
    end

    def max_velocity
      max = Math.sqrt(torso.engine.max_acceleration/@friction_factor)-@friction_base/@friction_factor/2
    end

    def target_velocity= value
      @target_velocity = [value, max_velocity].min
    end

    def update delta
      components.each do |component|
        component.update delta
      end

      distance = 0.5*acceleration*delta*delta + velocity*delta

      self.velocity = (velocity + acceleration*delta)*(1-friction*delta)
      self.location[:x] += Gosu::offset_x(rotation, distance)
      self.location[:y] += Gosu::offset_y(rotation, distance)
    end

    def legs
      [left_leg, right_leg]
    end

    def arms
      [left_arm, right_arm]
    end

    def weapons
      self.components
      .map(&:addons).flatten
      .reject { |a| a.nil? }
      .select { |a| a.is_weapon? }
    end

    def components
      @components.values
    end
  end
end
