require_relative '../spec_helper'

module MechRL
  describe Mech::Component do
    subject { @it }
    before do
      @it = Mech::Component.new
    end
    it { should be_kind_of Mech::Component }

    describe "#initialize" do
      its(:durability) { should == 1 }
      its(:max_durability) { should == 1 }
      its(:heat){ should == 0 }
    end

    describe "#durability_percentage" do
      before do
        @it.max_durability = 10
        @it.durability = 3
      end

      its(:durability_percentage) { should == 0.3 }
    end

    describe "#apply_coolant" do
      before do
        
      end
    end
  end
end
