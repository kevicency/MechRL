require_relative 'spec_helper'

module MechRL
  describe Mech do
    before { @it = Mech.new }
    subject { @it }

    it { should be_instance_of Mech }
    it { should be_kind_of Rotatable }

    it "has a getter for each component" do
      Mech::COMPONENTS.each do |c|
        @it.should respond_to c
      end
    end

    it "has a setter for each component" do
      Mech::COMPONENTS.each do |c|
        @it.should respond_to "#{c}=".to_s
      end
    end

    it "raises an error when a component is missing" do
      lambda {
        @it.torso
      }.should raise_error
    end

    describe "#initialize" do
      its(:location) { should == {x:0, y:0} }
      its(:velocity) { should == 0 }
      its(:target_velocity) { should == 0 }
    end

    describe "#weight" do
      subject { @it.weight }

      context "when mech has no components" do
        it { should == 0 }
      end

      context "when mech has components" do
        before do
          @it.torso = double(Mech::Component, :weight => 1)
          @it.head = double(Mech::Component, :weight => 2)
        end
        it "returns the sum of the components weight" do
          should == 3
        end
      end
    end

    describe "#heat" do
      subject { @it.heat }

      context "when mech has no components" do
        it { should == 0 }
      end

      context "when mech has components" do
        before do
          @it.torso = double(Mech::Component, :heat => 1)
          @it.head = double(Mech::Component, :heat => 2)
        end
        it "returns the sum of the components heat" do
          should == 3
        end
      end
    end

    describe "#update" do
      let(:rotation) { 0 }
      before do
        @it.stub(:acceleration => 0)
        @it.stub(:rotation => rotation)

        Mech::COMPONENTS.each do |c|
          component = double(Mech::Component)
          component.as_null_object
          @it.send "#{c}=".to_sym, component
        end
      end

      it "updates each component" do
        @it.components.each do |c|
          c.should_receive(:update).with(1)
        end
        @it.update 1
      end

      context "when the mech moves" do
        subject { @it.location }
        before do
          @it.location = {x:5,y:5}
          @it.velocity = 2
          @it.target_velocity = 10
          @it.stub(:acceleration => 3)
          @it.stub(:friction => 0.25)
          @it.update 2
        end

        specify { @it.velocity.should == 7 }

        context "horizontally" do
          let(:rotation) { 90 }

          its([:x]) { should be_within(0.01).of 13 }
          its([:y]) { should be_within(0.01).of 5 }
        end

        context "vertically" do
          let(:rotation) { 180 }

          its([:x]) { should be_within(0.01).of 5 }
          its([:y]) { should be_within(0.01).of 13 }
        end

        context "diagonally" do
          let(:rotation) { 135 }

          its([:x]) { should be_within(0.01).of @it.location[:y] }
        end
      end
    end
  end
end
