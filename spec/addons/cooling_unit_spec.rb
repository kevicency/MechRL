require 'spec_helper'

module MechRL
  describe CoolingUnit do
    before do
      @addons = [
        double(AddOn, :heat => 30).as_null_object,
        double(AddOn, :heat => 70).as_null_object,
        double(AddOn, :heat => 0).as_null_object
      ]
      @mech = Mech.new
      @mech.stub(:components => [stub(:addons => @addons)])
      @mech.stub(:heat => 100)
      @it = CoolingUnit.new
      @it.cooling_rate = 5
      @it.attach_to @mech
    end

    [0,1,2].each do |i|
      it "cools addon ##{i} of the mech" do
        @addons[i].should_receive(:heat=).with(@addons[i].heat*0.9)
        @it.update 2
      end
    end
  end
end
