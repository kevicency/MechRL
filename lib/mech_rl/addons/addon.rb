module MechRL
  class AddOn
    attr_accessor :weight, :heat
    attr_reader :mech

    def initialize mech = nil
      @weight = 0
      @heat = 0
      attach_to mech
    end

    def attach_to mech
      @mech = mech
    end

    def update delta
      return if @mech.nil?
    end

    def is_weapon?
      false
    end
  end
end
