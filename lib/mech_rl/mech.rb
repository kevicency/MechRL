module MechRL
  class Mech
    include Rotatable

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

    def initialize
      self.location = {x:0, y:0}
      self.velocity = 0
      @target_velocity = 0
      @components = {}
    end

    def weight
      @components.values
        .map(&:weight)
        .reduce(&:+) || 0
    end

    def heat
      @components.values
        .map(&:heat)
        .reduce(&:+) || 0
    end

    def max_heat
      torso.max_heat
    end

    def acceleration
      torso.engine.acceleration
    end

    def friction
      0.005 + (0.0005*velocity)
    end

    def max_velocity
      (Math.sqrt(torso.engine.max_acceleration/0.0005)-0.005/0.0005/2)*0.95
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
        .select { |a| a.is_weapon? }
    end

    def components
      @components.values
    end
  end
end
