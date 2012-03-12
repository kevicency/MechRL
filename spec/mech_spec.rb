require_relative 'spec_helper'

module MechRL
  describe Mech do
    before { @it = Mech.new }
    it("should be a mech") { @it.should be_kind_of Mech }

    describe "#initialize" do
      subject { @it }

      its(:location) { should == {x:0, y:0} }
      its(:velocity) { should == 0 }
      its(:desired_velocity) { should == 0 }
      its(:slots) { should_not be_nil }
      its(:movement_angle) { should == 0 }
    end

    describe "#update" do
      describe "moves the mech" do
        subject { @it.location }
        before do
          @it.location = {x:5,y:5}
          @it.velocity = 4
          @it.stub(:acceleration => 3)
          @it.movement_angle = test_angle
          @it.update 2
        end

        describe "horizontally" do
          let(:test_angle) { 90 }

          its([:x]) { should be_within(0.01).of 19 }
          its([:y]) { should be_within(0.01).of 5 }
        end

        describe "vertically" do
          let(:test_angle) { 180 }

          its([:x]) { should be_within(0.01).of 5 }
          its([:y]) { should be_within(0.01).of 19 }
        end

        describe "diagonally" do
          let(:test_angle) { 135 }

          its([:x]) { should be_within(0.01).of @it.location[:y] }
        end
      end

      describe "accelerates the mech" do
        subject { @it }
        before do
          @it.velocity = 1
          @it.desired_velocity = 10
          @it.stub(:acceleration => 3)
          @it.update 2
        end

        its(:velocity) { should == 7 }

      end
    end
  end
end
