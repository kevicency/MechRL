module MechRL
  class Mech
    attr_accessor :location
    attr_accessor :velocity, :target_velocity
    attr_accessor :weight

    def initialize
      self.location = {x:0, y:0}
      self.velocity = 0
      self.target_velocity = 0
      @components = {}

      #add_component :torso  do |torso|
      #torso.extend Rotatable
      #torso.rotary_speed = 45
      #torso.max_rotation = 90
      #end
      #add_component :legs do |legs|
      #legs.extend Rotatable
      #legs.rotary_speed = 30
      #end

      self.weight = 250.0
    end

    def add_component slot, component = nil
      component ||= Component.new
      yield(component) if block_given?
      @components[slot] = component
      self.class.send(:define_method, slot) do
        @components[slot]
      end
    end

    def remove_component slot
      @components.delete slot
      self.class.send(:remove_method, slot)
    end

    def has slot
      @components.has_key? slot
    end

    def slots
      @components.keys
    end

    def update delta
      distance = 0.5*acceleration*delta*delta + velocity*delta

      self.velocity += acceleration*delta
      self.location[:x] += Gosu::offset_x(movement_direction, distance)
      self.location[:y] += Gosu::offset_y(movement_direction, distance)
    end

    def movement_direction
      return 0 unless has :legs

      legs.rotation
    end

    def viewing_direction
      return 0 unless has :torso

      movement_direction + torso.rotation
    end

    def look direction, delta
      torso.rotate direction, delta if has :torso
    end

    def turn direction, delta
      legs.rotate direction, delta if has :legs
    end

    def acceleration
      return 0 unless has :torso
      return 0 if (target_velocity - velocity).abs < 0.1

      base = torso[:engine][:power] / weight

      if (velocity > 0)
        if (target_velocity < velocity)
          base *= -3
        end
      else
        if (target_velocity < velocity)
          base *= -0.5
        end
      end

      base
    end

    class Component
      attr_accessor :durability, :max_durability, :heat

      def initialize
        self.durability = 1
        self.max_durability = 1
        self.heat = 0
      end

      def durability_percentage
        return 0 if max_durability == 0
        durability / max_durability.to_f
      end
    end
  end

  module Rotatable
    DIRECTION_MULTIPLIERS = {
      :left => -1,
      :right => 1,
      :none => 0
    }

    attr_accessor :rotation, :rotary_speed, :max_rotation

    def rotation
      @rotation || 0
    end

    def rotate direction, delta
      raise "Invalid direction: #{direction}" unless DIRECTION_MULTIPLIERS.keys.include? direction

      multiplier = DIRECTION_MULTIPLIERS[direction || :none]
      d_rot = (rotary_speed * multiplier * delta)
      @rotation = rotation + d_rot

      unless max_rotation.nil?
        if (@rotation > 0 && @rotation > max_rotation)
          @rotation = max_rotation
        end
        if (@rotation < 0 && @rotation < -max_rotation)
          @rotation = -max_rotation
        end
      end

      sign = @rotation > 0 ? 1 : -1
      @rotation %= 360 * sign
    end
  end
end
