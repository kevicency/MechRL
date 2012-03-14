module MechRL
  class Mech

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
      self.target_velocity = 0
      @type = :timber_wolf
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

    def update delta
      self.velocity = velocity - (velocity*0.10*delta)
      torso.engine.update delta
      torso.cooling_unit.update delta

      distance = 0.5*acceleration*delta*delta + velocity*delta

      self.velocity += acceleration*delta
      self.location[:x] += Gosu::offset_x(movement_direction, distance)
      self.location[:y] += Gosu::offset_y(movement_direction, distance)
    end

    def movement_direction
      left_leg.rotation
    end

    def facing_direction
      movement_direction + torso.rotation
    end

    def look direction, delta
      "looking"
      torso.rotate direction, delta
    end

    def turn direction, delta
      legs.each do |leg|
        leg.rotate direction, delta
      end
    end

    def legs
      [left_leg, right_leg]
    end

    def arms
      [left_arm, right_arm]
    end

    def components
      @components.values
    end

    private

    def reduce_heat coolant
      heat = self.heat
      @components.values.each do |component|
        next if component.heat = 0
      end
    end
  end
end
