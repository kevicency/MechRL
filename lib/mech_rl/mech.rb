module MechRL
  class Mech
    attr_accessor :location
    attr_accessor :velocity, :target_velocity, :rotary_speed, :rotary_multiplier
    attr_accessor :movement_direction
    attr_accessor :slots, :weight

    def initialize
      self.location = {x:0, y:0}
      self.velocity = 0
      self.target_velocity = 0
      self.slots = {
        engine: { power: 1000.0 }
      }
      self.weight = 250.0
      self.movement_direction = 0
      self.rotary_multiplier = 0
      self.rotary_speed = 45
    end

    def update delta
      self.movement_direction += (rotary_speed * rotary_multiplier * delta)
      distance = 0.5*acceleration*delta*delta + velocity*delta

      self.velocity += acceleration*delta
      self.location[:x] += Gosu::offset_x(movement_direction, distance)
      self.location[:y] += Gosu::offset_y(movement_direction, distance)
    end

    def turn_left
      @rotary_multiplier = -1
    end

    def turn_right
      @rotary_multiplier = 1
    end

    def stop_turning
      @rotary_multiplier = 0
    end

    def acceleration
      return 0 if target_velocity == velocity

      base = slots[:engine][:power] / weight
      if (target_velocity < velocity)
        base = -base
      end

      base
      #if (velocity > 0)
        #if (target_velocity > velocity)
          #base
        #else
          #base * -3
        #end
      #else
        #if (target_velocity > velocity)
          #base
        #else
          #base * -0.5
        #end
      #end
    end
  end
end
