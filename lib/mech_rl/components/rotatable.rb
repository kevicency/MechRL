module MechRL
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
