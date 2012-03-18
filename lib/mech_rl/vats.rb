module MechRL
  class Vats
    attr_reader :target, :component

    def intialize mech
      @mech = mech
    end

    def lock_on target, component
      @target = target
      @component = component
    end

    def target_distance
      return nil if @target.nil?

      mx,my = @mech.location[:x], @mech.location[:y]
      tx,ty = @target.location[:x], @target.location[:y]

      Math.sqrt((mx-tx)**2 + (my-ty)**2)
    end
  end
end
